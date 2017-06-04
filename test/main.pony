
use peg = "peg"
use "collections"
use "files"
use "glob"
use "inspect"
use "ponytest"

use "../ast"
use "../ast/parse"
use "../ast/print"

actor Main
  new create(env: Env) =>
    let list = recover Array[UnitTest iso] end
    try
      let auth = env.root as AmbientAuth
      let test_root = FilePath(auth, Path.dir(__loc.file()))
      let fixtures = Glob.glob(test_root, "fixtures/*.pony")
      
      for path in fixtures.values() do
        let file = OpenFile(path) as File
        let source = Source(file.read_string(file.size()), path.path)
        
        list.push(TestFixture(source))
      end
    else
      env.out.print("An error occurred opening the test fixture files.")
    end
    
    PonyTest.create[Array[UnitTest iso] iso](env, consume list)

class TestFixture is UnitTest
  let source: Source
  
  new iso create(source': Source) => source = source'
  
  fun name(): String =>
    try Path.rel(Path.dir(__loc.file()), source.path())
    else source.path()
    end
  
  fun apply(h: TestHelper) =>
    let env = h.env
    
    let triple = "\"\"\""
    var i: ISize = 0
    if (try source.content().find(triple) == 0 else false end) then
      i = triple.size().isize()
    else
      return h.fail("Expected the start of the source file to be a docstring.")
    end
    
    let commands = List[TestCommand]
    var last_command: TestCommand = TestCommandNone
    var commands_parsed = false
    try
      while true do
        i = i + 1
        let j = source.content().find("\n", i)
        let line: String = source.content().substring(i, j)
        i = j
        
        if line.at(triple)       then commands_parsed = true; break
        elseif line.at("$PRINT") then last_command = TestCommandPrint; commands.unshift(last_command)
        elseif line.at("$PARSE") then last_command = TestCommandParse; commands.unshift(last_command)
        elseif line.at("$ERROR") then last_command = commands(0).add_error(TestCommandError(line.substring(7)))
        else last_command.add_line(line)
        end
      end
    else
      return h.fail("Expected to be able to parse the test plan docstring.")
    end
    
    for command in commands.values() do
      command(h, source)
    end

trait TestCommand
  fun ref add_line(line: String) => None
  fun ref add_error(err: TestCommandError): TestCommandError => err
  fun apply(h: TestHelper, source: Source) => None

class TestCommandNone is TestCommand

class TestCommandPrint is TestCommand
  fun apply(h: TestHelper, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    let module =
      try
        Parse(source, errs)
      else
        return h.fail("An unexpected parser error occurred.")
      end
    
    for (message, pos) in errs.values() do
      h.fail(message + ": " + pos.string())
      let shown = pos.show_in_line()
      h.fail(shown._1)
      h.fail(shown._2)
    end
    
    h.assert_eq[String](source.content(), Print(module))

class TestCommandParse is TestCommand
  embed expected: Array[TestCommandError] = Array[TestCommandError]
  
  fun ref add_error(err: TestCommandError): TestCommandError =>
    expected.push(err); err
  
  fun apply(h: TestHelper, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    let success =
      try
        Parse(source, errs)
        true
      else
        false
      end
    
    h.assert_eq[Bool](success, expected.size() == 0, "Success")
    
    for (i, expect) in expected.pairs() do
      try
        let actual = errs(i)
        try
          actual._1.find(expect.message)
        else
          h.fail("error did not match expected message")
          h.fail("expected: " + expect.message)
          h.fail("actual:   " + actual._1)
        end
        (let line_1, let line_2) = actual._2.show_in_line()
        try h.assert_eq[String](expect.lines(0), line_1) end
        try h.assert_eq[String](expect.lines(1), line_2) end
      else
        h.fail("expected error at index " + i.string() + " is missing")
      end
    end
    
    h.assert_eq[USize](expected.size(), errs.size(), "Number of Errors")

class TestCommandError is TestCommand
  let message: String
  embed lines: Array[String] = Array[String]
  
  new create(m: String) => message = m
  fun ref add_line(line: String) => lines.push(line)

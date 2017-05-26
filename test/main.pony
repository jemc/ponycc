
use peg = "peg"
use "collections"
use "files"
use "glob"
use "inspect"
use "ponytest"

use "../ast"
use "../parser"
use "../printer"

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
    var commands_parsed = false
    try
      while true do
        i = i + 1
        let j = source.content().find("\n", i)
        let line: String = source.content().substring(i, j)
        i = j
        
        match line
        | "$PRINT" => commands.unshift(TestCommandPrint)
        | triple   => commands_parsed = true; break
        else commands(0).add_line(line)
        end
      end
    else
      return h.fail("Expected to be able to parse the test plan docstring.")
    end
    
    for command in commands.values() do
      command(h, source)
    end

trait TestCommand
  new iso create()
  fun ref add_line(line: String) => None
  fun apply(h: TestHelper, source: Source) => None

class TestCommandPrint is TestCommand
  fun apply(h: TestHelper, source: Source) =>
    let parser = Parser
    let module =
      try
        parser(source, {(s: String, p: SourcePosAny) =>
          h.fail(s + ": " + p.string())
          let shown = p.show_in_line()
          h.fail(shown._1)
          h.fail(shown._2)
        })
      else
        return h.fail("An unexpected parser error occurred.")
      end
    
    h.assert_eq[String](source.content(), Printer(module))

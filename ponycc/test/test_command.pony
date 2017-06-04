
use "ponytest"

use "../ast"
use "../ast/parse"
use "../ast/print"

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

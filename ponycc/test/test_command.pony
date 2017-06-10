
use "ponytest"

use "../ast"
use "../ast/parse"
use "../ast/print"
use "../pass/post_parse"
use "../pass/syntax"

trait TestCommand
  fun ref add_line(line: String) => None
  fun ref add_error(err: TestCommandError): TestCommandError => err
  fun apply(h: TestHelper, source: Source) => None
  
  fun _print_errors(h: TestHelper, errs: Array[(String, SourcePosAny)] box) =>
    for (err, pos) in errs.values() do
      h.log(err)
      (let pos1, let pos2) = pos.show_in_line()
      h.log(pos1)
      h.log(pos2)
    end
  
  fun _check_errors(h: TestHelper, expected: Array[TestCommandError] box,
    success: Bool, errs: Array[(String, SourcePosAny)] box)
  =>
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
    
    if not
      h.assert_eq[USize](expected.size(), errs.size(), "Number of Errors")
    then _print_errors(h, errs) end

class TestCommandNone is TestCommand

class TestCommandPrint is TestCommand
  fun apply(h: TestHelper, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    let module =
      try
        Parse(source, errs)
      else
        _print_errors(h, errs)
        return h.fail("Unexpected parser error(s) occurred.")
      end
    
    h.assert_eq[String](source.content(), Print(module))

class TestCommandParse is TestCommand
  embed _expected: Array[TestCommandError] = Array[TestCommandError]
  
  fun ref add_error(err: TestCommandError): TestCommandError =>
    _expected.push(err); err
  
  fun apply(h: TestHelper, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    let success =
      try
        Parse(source, errs)
        true
      else
        false
      end
    
    _check_errors(h, _expected, success, errs)

class TestCommandPostParse is TestCommand
  embed _expected: Array[TestCommandError] = Array[TestCommandError]
  
  fun ref add_error(err: TestCommandError): TestCommandError =>
    _expected.push(err); err
  
  fun apply(h: TestHelper, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    let module =
      try
        Parse(source, errs)
      else
        _print_errors(h, errs)
        return h.fail("Unexpected parser error(s) occurred.")
      end
    
    PostParse.start(module, errs)
    _check_errors(h, _expected, errs.size() == 0, errs)

class TestCommandSyntax is TestCommand
  embed _expected: Array[TestCommandError] = Array[TestCommandError]
  
  fun ref add_error(err: TestCommandError): TestCommandError =>
    _expected.push(err); err
  
  fun apply(h: TestHelper, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    let module =
      try
        Parse(source, errs)
      else
        _print_errors(h, errs)
        return h.fail("Unexpected parser error(s) occurred.")
      end
    
    PostParse.start(module, errs)
    if errs.size() > 0 then
      _print_errors(h, errs)
      return h.fail("Unexpected syntax error(s) occurred.")
    end
    
    Syntax.start(module, errs)
    _check_errors(h, _expected, errs.size() == 0, errs)

class TestCommandError is TestCommand
  let message: String
  embed lines: Array[String] = Array[String]
  
  new create(m: String) => message = m
  fun ref add_line(line: String) => lines.push(line)

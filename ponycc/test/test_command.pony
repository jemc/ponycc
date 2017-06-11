
use "ponytest"

use "../ast"
use "../ast/parse"
use "../ast/print"
use "../pass/post_parse"
use "../pass/syntax"

trait TestCommand
  fun ref add_line(line: String) => None
  fun ref add_error(err: TestCommandError): TestCommandError => err
  fun ref add_check(err: TestCommandCheck): TestCommandCheck => err
  
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
  embed _errs:   Array[TestCommandError] = Array[TestCommandError]
  
  fun ref add_error(e: TestCommandError): TestCommandError => _errs.push(e); e
  
  fun apply(h: TestHelper, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    let success =
      try
        Parse(source, errs)
        true
      else
        false
      end
    
    _check_errors(h, _errs, success, errs)

class TestCommandPostParse is TestCommand
  embed _errs:   Array[TestCommandError] = Array[TestCommandError]
  embed _checks: Array[TestCommandCheck] = Array[TestCommandCheck]
  
  fun ref add_error(e: TestCommandError): TestCommandError => _errs.push(e); e
  fun ref add_check(c: TestCommandCheck): TestCommandCheck => _checks.push(c); c
  
  fun apply(h: TestHelper, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    var module =
      try
        Parse(source, errs)
      else
        _print_errors(h, errs)
        return h.fail("Unexpected parser error(s) occurred.")
      end
    
    module = PostParse.start(module, errs)
    
    _check_errors(h, _errs, errs.size() == 0, errs)
    for check in _checks.values() do check.check(h, module) end

class TestCommandSyntax is TestCommand
  embed _errs:   Array[TestCommandError] = Array[TestCommandError]
  embed _checks: Array[TestCommandCheck] = Array[TestCommandCheck]
  
  fun ref add_error(e: TestCommandError): TestCommandError => _errs.push(e); e
  fun ref add_check(c: TestCommandCheck): TestCommandCheck => _checks.push(c); c
  
  fun apply(h: TestHelper, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    var module =
      try
        Parse(source, errs)
      else
        _print_errors(h, errs)
        return h.fail("Unexpected parser error(s) occurred.")
      end
    
    module = PostParse.start(module, errs)
    if errs.size() > 0 then
      _print_errors(h, errs)
      return h.fail("Unexpected syntax error(s) occurred.")
    end
    
    module = Syntax.start(module, errs)
    _check_errors(h, _errs, errs.size() == 0, errs)
    for check in _checks.values() do check.check(h, module) end

class TestCommandError is TestCommand
  let message: String
  embed lines: Array[String] = Array[String]
  
  new create(m: String) => message = m
  fun ref add_line(line: String) => lines.push(line)

class TestCommandCheck is TestCommand
  let path: String
  embed lines: Array[String] = Array[String]
  
  new create(p: String) => path = p
  fun ref add_line(line: String) => lines.push(line)
  
  fun check(h: TestHelper, module: Module) =>
    var ast: (AST | None) = module
    var last_crumb: String = ""
    try
      for crumb in path.clone().>strip().split_by(".").values() do
        last_crumb = crumb
        let pieces = crumb.split_by("-", 2)
        
        ast =
          (ast as AST).get_child_dynamic(
            pieces(0),
            try pieces(1).usize() else 0 end)
      end
      
      h.assert_eq[String](String.join(lines), ast.string())
    else
      h.fail("Check failed to walk path: " + path)
      h.log("The crumb that failed parse and/or lookup was: " + last_crumb)
      h.log("The (AST | None) it couldn't be looked up on was: " + ast.string())
    end

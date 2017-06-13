
use "ponytest"

use "../ast"
use "../ast/parse"
use "../ast/print"
use "../pass/post_parse"
use "../pass/syntax"

interface TestCommandAny
  fun h(): TestHelper
  
  fun ref add_line(l: String)
  fun ref add_error(e: TestCommand[_Error]): TestCommand[_Error]
  fun ref add_check(c: TestCommand[_Check]): TestCommand[_Check]
  
  fun ref apply(source: Source)
  
  fun print_errors(actual_errors: Array[(String, SourcePosAny)] box)
  
  fun check_errors(
    actual_errors: Array[(String, SourcePosAny)] box,
    success: Bool = true)
  
  fun check_checks(module: Module)

trait val TestCommandType
  new val create()
  fun apply(command: TestCommandAny, source: Source) => None

class TestCommand[T: TestCommandType val]
  let _h: TestHelper
  
  let message:  String
  embed lines:  Array[String]              = Array[String]
  embed errors: Array[TestCommand[_Error]] = Array[TestCommand[_Error]]
  embed checks: Array[TestCommand[_Check]] = Array[TestCommand[_Check]]
  
  new create(h': TestHelper, m': String) =>
    (_h, message) = (h', m')
  
  fun h(): TestHelper => _h
  
  fun ref add_line(l: String) => lines.push(l)
  fun ref add_error(e: TestCommand[_Error]): TestCommand[_Error] => errors.push(e); e
  fun ref add_check(c: TestCommand[_Check]): TestCommand[_Check] => checks.push(c); c
  
  fun ref apply(source: Source) => T(this, source)
  
  fun print_errors(actual_errors: Array[(String, SourcePosAny)] box) =>
    for (err, pos) in actual_errors.values() do
      _h.log(err)
      (let pos1, let pos2) = pos.show_in_line()
      _h.log(pos1)
      _h.log(pos2)
    end
  
  fun check_errors(
    actual_errors: Array[(String, SourcePosAny)] box,
    success: Bool = true)
  =>
    _h.assert_eq[Bool](
      success and (actual_errors.size() == 0),
      errors.size() == 0,
      "Success")
    
    for (i, expect) in errors.pairs() do
      try
        let actual = actual_errors(i)
        try
          actual._1.find(expect.message)
        else
          _h.fail("error did not match expected message")
          _h.fail("expected: " + expect.message)
          _h.fail("actual:   " + actual._1)
        end
        (let line_1, let line_2) = actual._2.show_in_line()
        try _h.assert_eq[String](expect.lines(0), line_1) end
        try _h.assert_eq[String](expect.lines(1), line_2) end
      else
        _h.fail("expected error at index " + i.string() + " is missing")
      end
    end
    
    if not
      _h.assert_eq[USize](
        errors.size(), actual_errors.size(), "Number of Errors")
    then
      print_errors(actual_errors)
    end
  
  fun check_checks(module: Module) =>
    for check in checks.values() do _Check.check(check, module) end

primitive _Print is TestCommandType
  fun apply(command: TestCommandAny, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    let module =
      try
        Parse(source, errs)
      else
        command.print_errors(errs)
        return command.h().fail("Unexpected parser error(s) occurred.")
      end
    
    command.h().assert_eq[String](source.content(), Print(module))

primitive _Parse is TestCommandType
  fun apply(command: TestCommandAny, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    let success =
      try
        Parse(source, errs)
        true
      else
        false
      end
    
    command.check_errors(errs, success)

primitive _PostParse is TestCommandType
  fun apply(command: TestCommandAny, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    var module =
      try
        Parse(source, errs)
      else
        command.print_errors(errs)
        return command.h().fail("Unexpected parser error(s) occurred.")
      end
    
    module = PostParse.start(module, errs)
    
    command.check_errors(errs)
    command.check_checks(module)

primitive _Syntax is TestCommandType
  fun apply(command: TestCommandAny, source: Source) =>
    let errs = Array[(String, SourcePosAny)]
    var module =
      try
        Parse(source, errs)
      else
        command.print_errors(errs)
        return command.h().fail("Unexpected parser error(s) occurred.")
      end
    
    module = PostParse.start(module, errs)
    if errs.size() > 0 then
      command.print_errors(errs)
      return command.h().fail("Unexpected syntax error(s) occurred.")
    end
    
    module = Syntax.start(module, errs)
    command.check_errors(errs)
    command.check_checks(module)

primitive _Error is TestCommandType

primitive _Check is TestCommandType
  fun check(command: TestCommand[_Check] box, module: Module) =>
    var ast: (AST | None) = module
    var last_crumb: String = ""
    try
      for crumb in command.message.clone().>strip().split_by(".").values() do
        last_crumb = crumb
        let pieces = crumb.split_by("-", 2)
        
        ast =
          (ast as AST).get_child_dynamic(
            pieces(0),
            try pieces(1).usize() else 0 end)
      end
      
      command.h().assert_eq[String](String.join(command.lines), ast.string())
    else
      command.h().fail("Check failed to walk path: " + command.message)
      command.h().log("The crumb that failed parse and/or lookup was: " + last_crumb)
      command.h().log("The (AST | None) it couldn't be looked up on was: " + ast.string())
    end

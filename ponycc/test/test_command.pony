
use "ponytest"

use "../ast"

interface val TestCommandAny
  fun h(): TestHelper
  
  fun ref add_line(l: String)
  fun ref add_error(e: TestCommand[_Error])
  fun ref add_check(c: TestCommand[_Check])
  
  fun val apply(source: Source)
  
  fun print_errors(actual_errors: Array[(String, SourcePosAny)] box)
  
  fun check_errors(
    actual_errors: Array[(String, SourcePosAny)] box,
    success: Bool = true)
  
  fun check_checks(module: Module)

class val TestCommand[T: TestCommandType val]
  let _h: TestHelper
  
  let message:  String
  embed lines:  Array[String]              = Array[String]
  embed errors: Array[TestCommand[_Error]] = Array[TestCommand[_Error]]
  embed checks: Array[TestCommand[_Check]] = Array[TestCommand[_Check]]
  
  new iso create(h': TestHelper, m': String) =>
    (_h, message) = (h', m')
  
  fun h(): TestHelper => _h
  
  fun ref add_line(l: String) => lines.push(l)
  fun ref add_error(e: TestCommand[_Error]) => errors.push(e); e
  fun ref add_check(c: TestCommand[_Check]) => checks.push(c); c
  
  fun val apply(source: Source) => T(this, source)
  
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
        let actual = actual_errors(i)?
        try
          actual._1.find(expect.message)?
        else
          _h.fail("error did not match expected message")
          _h.fail("expected: " + expect.message)
          _h.fail("actual:   " + actual._1)
        end
        (let line_1, let line_2) = actual._2.show_in_line()
        try _h.assert_eq[String](expect.lines(0)?, line_1) end
        try _h.assert_eq[String](expect.lines(1)?, line_2) end
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
    for check in checks.values() do
      var ast: (AST | None) = module
      var last_crumb: String = ""
      try
        for crumb in check.message.clone().>strip().split_by(".").values() do
          last_crumb = crumb
          let pieces = crumb.split_by("-", 2)
          
          ast =
            (ast as AST).get_child_dynamic(
              pieces(0)?,
              try pieces(1)?.usize()? else 0 end)?
        end
        
        _h.assert_eq[String](String.join(check.lines), ast.string())
      else
        _h.fail("Check failed to walk path: " + check.message)
        _h.log("The crumb that failed parse and/or lookup was: " + last_crumb)
        _h.log("The (AST | None) couldn't be looked up on was: " + ast.string())
      end
    end


use "../ast"
use "../ast/parse"
use "../ast/print"
use "../pass/post_parse"
use "../pass/syntax"

trait val TestCommandType
  new val create()
  fun apply(command: TestCommandAny, source: Source) => None

primitive _Error is TestCommandType

primitive _Check is TestCommandType

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

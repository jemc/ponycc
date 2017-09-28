
use ".."
use "../ast"
use "../ast/parse"
use "../ast/print"
use "../frame"
use "../pass/post_parse"
use "../pass/syntax"
use "../pass/sugar"

trait val TestCommandType
  new val create()
  fun apply(command: TestCommandAny, source: Source) => None

primitive _Error is TestCommandType

primitive _Check is TestCommandType

primitive _Print is TestCommandType
  fun apply(command: TestCommandAny, source: Source) =>
    BuildCompiler[Source, Module](Parse)
      .next[String](Print)
      .on_errors({(pass, errs) =>
        command.print_errors(errs)
        command.h().fail("Unexpected " + pass.name() + " error(s) occurred.")
      })
      .on_complete({(string) =>
        command.h().assert_eq[String](source.content(), string)
        command.h().complete(true)
      })
      .apply(source)

primitive _Parse is TestCommandType
  fun apply(command: TestCommandAny, source: Source) =>
    BuildCompiler[Source, Module](Parse)
      .on_errors({(pass, errs) =>
        command.check_errors(errs)
        command.h().complete(true)
      })
      .on_complete({(module) =>
        command.check_errors([])
        command.h().complete(true)
      })
      .apply(source)

primitive _PostParse is TestCommandType
  fun apply(command: TestCommandAny, source: Source) =>
    BuildCompiler[Source, Module](Parse)
      .next[Module](PostParse)
      .on_errors({(pass, errs) =>
        match pass | PostParse =>
          command.check_errors(errs)
          command.h().complete(true)
        else
          command.print_errors(errs)
          command.h().fail("Unexpected " + pass.name() + " error(s) occurred.")
        end
      })
      .on_complete({(module) =>
        command.check_checks(module)
        command.h().complete(true)
      })
      .apply(source)

primitive _Syntax is TestCommandType
  fun apply(command: TestCommandAny, source: Source) =>
    BuildCompiler[Source, Module](Parse)
      .next[Module](PostParse)
      .next[Module](Syntax)
      .on_errors({(pass, errs) =>
        match pass | Syntax =>
          command.check_errors(errs)
          command.h().complete(true)
        else
          command.print_errors(errs)
          command.h().fail("Unexpected " + pass.name() + " error(s) occurred.")
        end
      })
      .on_complete({(module) =>
        command.check_checks(module)
        command.h().complete(true)
      })
      .apply(source)

primitive _Sugar is TestCommandType
  fun apply(command: TestCommandAny, source: Source) =>
    BuildCompiler[Source, Module](Parse)
      .next[Module](PostParse)
      .next[Module](Syntax)
      .next[Module](Sugar)
      .on_errors({(pass, errs) =>
        match pass | Sugar =>
          command.check_errors(errs)
          command.h().complete(true)
        else
          command.print_errors(errs)
          command.h().fail("Unexpected " + pass.name() + " error(s) occurred.")
        end
      })
      .on_complete({(module) =>
        command.check_checks(module)
        command.h().complete(true)
      })
      .apply(source)

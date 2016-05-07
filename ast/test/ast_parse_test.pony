
use "ponytest"
use ".."

class ASTParseTest is UnitTest
  new iso create() => None
  fun name(): String => "ast/ASTParse"
  
  fun apply(h: TestHelper)? =>
    match ASTParse(TestFixtures.string_1())
    | let err: ASTParseError => h.fail(err.message)
                                h.fail(err.show_in_line())
    | let ast: AST =>
      h.assert_true(ast == TestFixtures.ast_1())
    else error
    end

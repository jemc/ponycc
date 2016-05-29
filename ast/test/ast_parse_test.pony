
use "ponytest"
use ".."

class ASTParseTest is UnitTest
  new iso create() => None
  fun name(): String => "ast/ASTParse"
  
  fun apply_case(h: TestHelper, input: String, expected: AST,
    loc: SourceLoc = __loc)
  =>
    match ASTParse(input)
    | let err: ASTParseError => h.fail(err.message)
                                h.fail(err.show_in_line())
    | let ast: AST =>
      h.assert_true(expected == ast where loc = loc)
    end
  
  fun apply(h: TestHelper) =>
    apply_case(h, TestFixtures.string_1(), TestFixtures.ast_1())
    apply_case(h, TestFixtures.string_2(), TestFixtures.ast_2())

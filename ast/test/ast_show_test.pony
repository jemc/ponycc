
use "ponytest"
use ".."

class ASTShowTest is UnitTest
  new iso create() => None
  fun name(): String => "ast/ASTShow"
  
  fun apply(h: TestHelper) =>
    h.assert_eq[String box](
      TestFixtures.string_1().clone().strip(),
      ASTShow(TestFixtures.ast_1()).clone().strip())

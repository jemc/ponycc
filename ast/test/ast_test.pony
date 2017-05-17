
use "ponytest"
use ".."

class ASTTest is UnitTest
  new iso create() => None
  fun name(): String => "ast/ASTTest"
  
  fun apply(h: TestHelper) =>
    true

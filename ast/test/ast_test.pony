
use "ponytest"
use ".."

class ASTTest is UnitTest
  new iso create() => None
  fun name(): String => "static/ASTTest"
  
  fun apply(h: TestHelper) =>
    true

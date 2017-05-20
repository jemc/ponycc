
use peg = "peg"
use "../ast"

trait val TkAny is peg.Label
  fun text(): String => string() // Required for peg library, but otherwise unused.
  fun string(): String
  fun desc(): String

primitive Tk[A: (AST | None)] is TkAny
  fun string(): String => ASTInfo.name[A]()
  fun desc():   String => ASTInfo.name[A]()

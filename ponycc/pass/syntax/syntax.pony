
use "../../ast"
use "../../frame"

primitive Syntax is FrameVisitor[Syntax]
  fun start(ast: Module, errors: Array[(String, SourcePosAny)]) =>
    apply[Module](Frame[Syntax](ast, errors), ast)
  
  fun apply[A: AST val](frame: Frame[Syntax], ast: A) =>
    iftype A <: Module then
      for t in ast.type_decls().values() do frame.visit(t) end
    elseif A <: TypeAlias then
      try ast.provides() as Type else
        frame.err("A type alias must specify a type.", ast)
      end
    end


use "../../ast"
use "../../frame"
use "../../unreachable"

primitive PostParse is FrameVisitor[PostParse]
  fun start(ast: Module, errors: Array[(String, SourcePosAny)]) =>
    apply[Module](Frame[PostParse](ast, errors), ast)
  
  fun apply[A: AST val](frame: Frame[PostParse], ast: A) =>
    iftype A <: Module then
      for t in ast.type_decls().values() do frame.visit(t) end
    
    elseif A <: TypeDecl then
      frame.visit(ast.members())
    
    elseif A <: Members then
      for m in ast.methods().values() do frame.visit(m) end
    
    elseif A <: Method then
      match ast.body() | let body: Sequence =>
        try
          frame.err(ast.docs() as LitString,
            "A method with a body cannot have a docstring in the signature.")
        else
          if body.list().size() > 1 then
            try
              frame.replace(ast.with_docs(body.list()(0) as LitString))
              // TODO: reassign ast here, like so:
              // ast = ast.with_docs(body.list()(0) as LitString)
              // frame.replace(ast)
            end
          end
        end
      end
    
    else Unreachable(ast)
    end


use ".."
use "../../ast"
use "../../frame"

primitive Names is (Pass[Program, Program] & FrameVisitor[Names])
  """
  The purpose of the Names pass is...
  
  This pass only adds attachments to the AST, and is idempotent.
  """
  fun name(): String => "names"
  
  fun apply(ast: Program, fn: {(Program, Array[PassError] val)} val) =>
    FrameRunner[Names](ast, fn)
  
  fun visit[A: AST val](frame: Frame[Names], ast: A) =>
    iftype A <: NominalType then
      let promise = frame.find_type_decl(ast.package(), ast.name())
      frame.await[TypeDecl](promise, {(frame, type_decl) =>
        frame.err(ast, "This is a reference.")
        try
          frame.err((type_decl as TypeDecl).name(),
            "This is a referenced type.")
        end
      })
    end


use "../../ast"
use "../../frame"
use "../../unreachable"

primitive PostParse is FrameVisitor[PostParse]
  """
  The purpose of the PostParse pass is to check and/or clean up any oddities
  in the AST related to the specific implementation of the parser or grammar.
  
  Checks or cleanup operations that would also need to also be done for AST
  nodes that had been created directly in Pony code do not belong here
  (they probably belong in the Sugar pass, or later).
  
  This pass changes the AST, and is not idempotent.
  """
  
  fun apply[A: AST val](frame: Frame[PostParse], ast: A) =>
    iftype A <: Method then
      match ast.body() | let body: Sequence =>
        try
          frame.err(ast.docs() as LitString,
            "A method with a body cannot have a docstring in the signature.")
        else
          // If the method body has more than one expression and the first
          // expression is a string literal, we treat it as a docstring;
          // we set it as the docs of the method and remove it from the body.
          if body.list().size() > 1 then
            try let docs = body.list()(0) as LitString
              let ast': Method = ast // TODO: remove this when ponyc crash is fixed
              frame.replace(ast'
                .with_docs(docs)
                .with_body(body.with_list(body.list().delete(0))))
            end
          end
        end
      end
    
    elseif A <: BinaryOp then
      if
        match ast.left()
        | let _: A => false
        | let _: BinaryOp => true
        else false
        end
      or
        match ast.right()
        | let _: A => false
        | let _: BinaryOp => true
        else false
        end
      then
        frame.err(ast,
          "Operator precedence is not supported. Parentheses are required.")
      end
    end

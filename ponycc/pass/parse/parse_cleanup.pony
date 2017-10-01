
use ".."
use "../../ast"
use "../../frame"
use "../../unreachable"

primitive ParseCleanup is (Pass[Module, Module] & FrameVisitor[ParseCleanup])
  """
  The purpose of the ParseCleanup pass is to check and/or clean up any oddities
  in the AST related to the specific implementation of the parser or grammar.
  
  Checks or cleanup operations that would also need to also be done for AST
  nodes that had been created directly in Pony code do not belong here
  (they probably belong in the Sugar pass, or later).
  
  This pass changes the AST, and is not idempotent.
  """
  fun name(): String => "parse-cleanup"
  
  fun apply(ast: Module, fn: {(Module, Array[PassError] val)} val) =>
    let program = Program([Package([ast])])
    FrameRunner[ParseCleanup](program, {(program, errs)(fn) =>
      fn(try program.packages()(0)?.modules()(0)? else Module end, errs)
    })
  
  fun visit[A: AST val](frame: Frame[ParseCleanup], ast: A) =>
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
            try let docs = body.list()(0)? as LitString
              let ast': Method = ast // TODO: remove this when ponyc crash is fixed
              frame.replace(ast'
                .with_docs(docs)
                .with_body(body.with_list(body.list().delete(0)?)))
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
    
    elseif A <: TupleType then
      // If the tuple type contains just one element, we unwrap it.
      // It isn't a tuple type; just a type that was surrounded by parentheses.
      if ast.list().size() == 1 then
        try frame.replace(ast.list()(0)?) end
      end
    
    elseif A <: Semicolon then
      frame.err(ast,
        "Use semicolons only for separating expressions on the same line.")
    end

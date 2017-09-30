
use ".."
use "../../ast"
use "../../frame"
use "../../unreachable"

use coll = "collections/persistent"

primitive Sugar is (Pass[Program, Program] & FrameVisitor[Sugar])
  """
  The purpose of the Sugar pass is to fill in implicit details and expand
  abbreviated forms to their more verbose equivalents.
  
  Changes that require any kind of larger context (such as other packages,
  scoping, name resolution, type information) do not belong here.
  
  This pass changes the AST, but it is idempotent.
  """
  fun name(): String => "sugar"
  
  fun apply(ast: Program, fn: {(Program, Array[PassError] val)} val) =>
    FrameRunner[Sugar](ast, fn)
  
  fun _find_member(members: Members, name': String): (Method | Field | None) =>
    for method in members.methods().values() do
      if method.name().value() == name' then return method end
    end
    for field in members.fields().values() do
      if field.name().value() == name' then return field end
    end
  
  fun _unary_op_method_id[A: UnaryOp val](): (Id | None) =>
    iftype A <: Not       then Id("op_not")
    elseif A <: Neg       then Id("neg")
    elseif A <: NegUnsafe then Id("neg_unsafe")
    else                       None
    end
  
  fun _binary_op_method_id[A: BinaryOp val](): (Id | None) =>
    iftype A <: Add          then Id("add")
    elseif A <: AddUnsafe    then Id("add_unsafe")
    elseif A <: Sub          then Id("sub")
    elseif A <: SubUnsafe    then Id("sub_unsafe")
    elseif A <: Mul          then Id("mul")
    elseif A <: MulUnsafe    then Id("mul_unsafe")
    elseif A <: Div          then Id("div")
    elseif A <: DivUnsafe    then Id("div_unsafe")
    elseif A <: Mod          then Id("mod")
    elseif A <: ModUnsafe    then Id("mod_unsafe")
    elseif A <: LShift       then Id("shl")
    elseif A <: LShiftUnsafe then Id("shl_unsafe")
    elseif A <: RShift       then Id("shr")
    elseif A <: RShiftUnsafe then Id("shr_unsafe")
    elseif A <: Eq           then Id("eq")
    elseif A <: EqUnsafe     then Id("eq_unsafe")
    elseif A <: NE           then Id("ne")
    elseif A <: NEUnsafe     then Id("ne_unsafe")
    elseif A <: LT           then Id("lt")
    elseif A <: LTUnsafe     then Id("lt_unsafe")
    elseif A <: LE           then Id("le")
    elseif A <: LEUnsafe     then Id("le_unsafe")
    elseif A <: GE           then Id("ge")
    elseif A <: GEUnsafe     then Id("ge_unsafe")
    elseif A <: GT           then Id("gt")
    elseif A <: GTUnsafe     then Id("gt_unsafe")
    elseif A <: And          then Id("op_and")
    elseif A <: Or           then Id("op_or")
    elseif A <: XOr          then Id("op_xor")
    else                          None
    end
  
  fun visit[A: AST val](frame: Frame[Sugar], ast': A) =>
    // TODO: from sugar.c - sugar_module
    // TODO: from sugar.c - sugar_typeparam
    
    iftype A <: TypeDecl then
      var ast: TypeDecl = ast'
      
      // Apply a default cap to the type declaration.
      if ast.cap() is None then
        iftype A <: (Interface | Trait) then ast = ast.with_cap(Ref)
        elseif A <: (Struct | Class)    then ast = ast.with_cap(Ref)
        elseif A <: Primitive           then ast = ast.with_cap(Val)
        elseif A <: Actor               then ast = ast.with_cap(Tag)
        end
      end
      
      // Add a default constructor if there is no `create` member.
      iftype A <: (Primitive | Struct | Class | Actor) then
        if _find_member(ast.members(), "create") is None then
          let cap =
            iftype A <: (Struct | Class) then Iso
            elseif A <: Primitive        then Val
            elseif A <: Actor            then Tag
            else Unreachable(ast); Tag
            end
          
          let method =
            MethodNew(Id("create"), cap where body' = Sequence([LitTrue]))
          
          ast = ast
            .with_members(ast.members()
              .with_methods(ast.members().methods().push(method)))
        end
      end
      
      // Extract all Field initialisers as Exprs into a Sequence.
      var inits = coll.Vec[Expr]
      for field in ast.members().fields().values() do
        try
          inits = inits.push(
            Assign(Reference(field.name()), field.default() as Expr))
        end
      end
      
      // Insert the field initialisers at the start of every constructor.
      if inits.size() > 0 then
        var methods = coll.Vec[Method]
        for method in ast.members().methods().values() do
          methods = methods.push(
            match method | let _: MethodNew =>
              method.with_body(Sequence(
                try
                  inits.concat((method.body() as Sequence).list().values())
                else
                  inits
                end))
            else
              method
            end)
        end
        ast = ast.with_members(ast.members().with_methods(methods))
      end
      
      frame.replace(ast)
    
    elseif A <: MethodNew then
      var ast: MethodNew = ast'
      
      // Apply a default cap to the constructor.
      if ast.cap() is None then
        match frame.type_decl()
        | let _: Primitive => ast = ast.with_cap(Val)
        | let _: Actor     => ast = ast.with_cap(Tag)
        else                  ast = ast.with_cap(Ref)
        end
      end
      
      // Set the return type of the constructor.
      match ast.cap() | let cap: Cap =>
        let type_name =
          try (frame.type_decl() as TypeDecl).name()
          else Unreachable(frame.type_decl()); Id("")
          end
        ast = ast.with_return_type(
          NominalType(type_name where cap' = cap, cap_mod' = Ephemeral))
      else
        Unreachable(ast.cap())
      end
      
      frame.replace(ast)
    
    elseif A <: MethodBe then
      // Set the cap and the return type of the behaviour.
      frame.replace(ast'
        .with_cap(Tag)
        .with_return_type(NominalType(Id("None"))))
    
    elseif A <: MethodFun then
      var ast: MethodFun = ast'
      
      // Apply a default cap to the function.
      if ast.cap() is None then ast = ast.with_cap(Box) end
      
      // Apply a default return type to the function.
      if ast.return_type() is None then
        ast = ast.with_return_type(NominalType(Id("None")))
      end
      
      frame.replace(ast)
    
    elseif A <: Return then
      // Set the return value if none has been specified.
      if ast'.value() is None then
        try frame.method() as MethodNew
          frame.replace(ast'.with_value(This))
        else
          frame.replace(ast'.with_value(Reference(Id("None"))))
        end
      end
    
    elseif A <: For then
      // TODO: actual hygienic id
      // TODO: attach "nice name" to Id: "for loop iterator"?
      let iter_id = Id("$hygienic_id")
      
      let try_next = Try(
        Sequence([Call(Dot(Reference(iter_id), Id("next")))]),
        Sequence([Break])
      )
      
      frame.replace(Sequence([
        Assign(LocalLet(iter_id), ast'.iterator())
        While(
          Sequence([Call(Dot(Reference(iter_id), Id("has_next")))]),
          Sequence([Assign(ast'.refs(), try_next)])
        )
      ]))
    
    elseif A <: With then
      let preamble:  Array[Expr] trn = []
      let try_body:  Array[Expr] trn = []
      let else_body: Array[Expr] trn = []
      let then_body: Array[Expr] trn = []
      
      // Set up the preamble, and the preamble of each body section.
      // These contain assignments related to the "with expression",
      // and the final section contains calls to the "dispose" method.
      for assign in ast'.assigns().elements().values() do
        // TODO: actual hygienic id
        let hyg_id = Id("$hygienic_id")
        let id =
          try (assign.left() as Reference).name()
          else Unreachable(assign); Id("")
          end
        
        let local_assign = Assign(LocalLet(id), Reference(hyg_id))
        
        preamble.push(Assign(LocalLet(hyg_id), assign.right()))
        try_body.push(local_assign)
        else_body.push(local_assign)
        then_body.push(Call(Dot(Reference(hyg_id), Id("dispose"))))
      end
      
      // Add the actual body and else body contents.
      for expr in ast'.body().list().values() do
        try_body.push(expr)
      end
      try
        for expr in (ast'.else_body() as Sequence).list().values() do
          else_body.push(expr)
        end
      end
      
      frame.replace(Sequence((consume preamble) .> push(
        Try(
          Sequence(consume try_body),
          Sequence(consume else_body),
          Sequence(consume then_body)
        )
      )))
    
    elseif A <: Match then
      var has_changes = false
      let cases: Array[Case] trn = []
      
      // If any cases have no body, they get the body of the next case.
      var next_body: (Sequence | None) = None
      for case in ast'.cases().list().reverse().values() do // TODO: use rvalues()
        try next_body = case.body() as Sequence end
        
        cases.unshift(
          if case.body() is None then
            has_changes = true
            case.with_body(next_body)
          else
            case
          end
        )
      end
      
      if has_changes then
        frame.replace(ast'.with_cases(Cases(consume cases)))
      end
    
    elseif A <: Assign then
      match ast'.left() | let call: Call =>
        // Sugar as an update method call, with the right side as a named arg.
        frame.replace(call
          .with_callable(Dot(call.callable(), Id("update")))
          .with_named_args(call.named_args().with_list_push(
            NamedArg(Id("value"), Sequence([ast'.right()]))
          ))
        )
      end
    
    elseif A <: UnaryOp then
      match _unary_op_method_id[A]() | let method_id: Id =>
        frame.replace(Call(Dot(ast'.expr(), method_id)))
      end
    
    elseif A <: BinaryOp then
      match _binary_op_method_id[A]() | let method_id: Id =>
        let args =
          match ast'.right()
          | let tuple: Tuple => Args(tuple.elements())
          | let expr: Expr => Args([Sequence([expr])])
          end
        
        frame.replace(
          Call(Dot(ast'.left(), method_id), args, NamedArgs, ast'.partial())
        )
      end
    
    // TODO: from sugar.c - sugar_ffi
    // TODO: from sugar.c - sugar_ifdef
    // TODO: from sugar.c - sugar_use
    // TODO: from sugar.c - sugar_lambdatype
    // TODO: from sugar.c - sugar_barelambda
    // TODO: from sugar.c - sugar_location
    
    end

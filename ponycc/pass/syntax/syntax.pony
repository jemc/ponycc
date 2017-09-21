
use "../../ast"
use "../../frame"
use "../../unreachable"

primitive Syntax is FrameVisitor[Syntax]
  """
  The purpose of the Syntax pass is to impose some extra limitation on the
  forms that are allowed in the Pony compiler, even when they are allowed
  by the parser, or by the AST data structure types.
  
  Checks that require any kind of larger context (such as other packages,
  scoping, name resolution, type information) do not belong here.
  
  This pass only reads the AST.
  """
  
  fun apply[A: AST val](frame: Frame[Syntax], ast: A) =>
    iftype A <: TypeDecl then
      // TODO: check that ast.name() is a valid type name (uppercase).
      
      let desc =
        iftype A <: TypeAlias then "A type alias "
        elseif A <: Interface then "An interface "
        elseif A <: Trait     then "A trait "
        elseif A <: Primitive then "A primitive "
        elseif A <: Struct    then "A struct "
        elseif A <: Class     then "A class "
        elseif A <: Actor     then "An actor "
        else Unreachable(ast); ""
        end
      
      iftype A <: TypeAlias then
        try ast.provides() as Type else
          frame.err(ast, desc + "must specify a type.")
        end
      end
      
      iftype A <: (TypeAlias | Primitive | Actor) then
        try
          frame.err(ast.cap() as Cap,
            desc + "cannot specify a default capability.")
        end
      end
      
      iftype
        A <: (TypeAlias | Interface | Trait | Primitive | Struct | Class)
      then
        try
          frame.err(ast.at() as At, desc + "cannot specify a C API.")
        end
        
        if ast.name().value() == "Main" then
          frame.err(ast.name(),
            desc + "cannot be named Main - Main must be an actor.")
        end
      end
      
      try ast.at() as At
        frame.err(ast.type_params() as TypeParams,
          "A C API type cannot have type parameters.")
      end
      
      iftype A <: (TypeAlias | Interface | Trait | Primitive) then
        for f in ast.members().fields().values() do
          frame.err(f, desc + "cannot have fields.")
        end
      end
      
      iftype A <: TypeAlias then
        for m in ast.members().methods().values() do
          frame.err(m, desc + "cannot have methods.")
        end
      end
      
      iftype A <: (Primitive | Struct | Class) then
        for m in ast.members().methods().values() do
          try
            frame.err(m as MethodBe, desc + "cannot have behaviours.")
          end
        end
      end
      
      // TODO: syntax.c: check_provides_type
      //   but this should probably be in the Traits pass instead.
    
    elseif A <: Method then
      // TODO: check that ast.name() is a valid method name (lowercase).
      
      iftype A <: MethodFun then
        try frame.type_decl() as (Trait | Interface) else
          try
            frame.err(ast.body() as None; ast,
              "This function must provide a body.")
          end
        end
      else
        try
          frame.err(ast.return_type() as Type,
            "Only functions can specify a return type.")
        end
        
        try
          frame.err(ast.cap() as At,
            "Only functions can be bare.")
        end
      end
      
      iftype A <: MethodNew then
        try frame.type_decl() as Primitive
          frame.err(ast.cap() as Cap,
            "A primitive constructor cannot specify a receiver capability.")
        end
        
        try frame.type_decl() as Actor
          frame.err(ast.partial() as Question,
            "An actor constructor cannot be partial.")
        end
        
        try frame.type_decl() as (Trait | Interface)
          try
            frame.err(ast.body() as Sequence,
              "A trait or interface constructor cannot provide a body.")
          end
        else
          try
            frame.err(ast.body() as None; ast,
              "This constructor must provide a body.")
          end
        end
      end
      
      iftype A <: MethodBe then
        try
          frame.err(ast.cap() as Cap,
            "A behaviour cannot specify a receiver capability.")
        end
        
        try
          frame.err(ast.partial() as Question,
            "A behaviour cannot be partial.")
        end
        
        try frame.type_decl() as (Trait | Interface) else
          try
            frame.err(ast.body() as None; ast,
              "This behaviour must provide a body.")
          end
        end
      end
      
      try
        frame.err(ast.guard() as Sequence,
          "Method guards are not yet supported in this compiler.")
      end
    
    elseif A <: Field then
      // TODO: check that ast.name() is a valid field name (lowercase).
      
      // TODO: if in an Object, require that fields be initialized,
      //   though maybe this logic belongs in another pass.
      
      None
    
    elseif A <: Local then
      // TODO: check that ast.name() is a valid local name (lowercase).
      
      None
    
    elseif A <: Param then
      // TODO: check that ast.name() is a valid param name (lowercase).
      
      None
    
    elseif A <: Params then
      try frame.parent() as UseFFIDecl
        for param in ast.list().values() do
          try
            frame.err(param.default() as Expr,
              "An FFI declaration parameter may not have a default value.")
          end
        end
      else
        try
          frame.err(ast.ellipsis() as Ellipsis,
            "An ellipsis may only appear in FFI declaration parameters.")
        end
      end
    
    elseif A <: CallFFI then
      for named in ast.named_args().list().values() do
        frame.err(named, "An FFI call may not have named arguments.")
      end
    
    // TODO: from syntax.c - syntax_object
    
    elseif A <: LambdaCapture then
      if ast.value() is None then
        try
          frame.err(ast.local_type() as Type,
            "A lambda capture cannot specify a type without a value.")
        end
      end
    
    elseif A <: BareLambda then
      try
        frame.err(ast.method_cap() as Cap,
          "A bare lambda cannot specify a receiver capability.")
      end
      
      try
        frame.err(ast.type_params() as TypeParams,
          "A bare lambda cannot have type parameters.")
      end
      
      try
        frame.err(ast.captures() as LambdaCaptures,
          "A bare lambda cannot have captures.")
      end
      
      try
        frame.err(ast.object_cap() as (Iso | Trn | Ref | Box | Tag),
          "A bare lambda can only have the `val` capability.")
      end
    
    // TODO: from syntax.c - syntax_lambda (BareLambda only)
    // TODO: from syntax.c - syntax_barelambdatype
    
    elseif A <: Cases then
      for (idx, case) in ast.list().pairs() do
        if (idx >= (ast.list().size() - 1)) and (case.body() is None) then
          frame.err(case, "The final case in a match block must have a body.")
        end
      end
    
    elseif A <: Return then
      if frame.method_body() is None then
        frame.err(ast,
          "A return statement can only appear in a method body.")
      end
      
      try frame.method() as MethodNew
        frame.err(ast.value() as Expr,
          "A return statement in a constructor cannot have a value expression.")
      end
      
      try frame.method() as MethodBe
        frame.err(ast.value() as Expr,
          "A return statement in a behaviour cannot have a value expression.")
      end
    
    elseif A <: Error then
      try
        frame.err(ast.value() as Expr,
          "An error statement cannot have a value expression.")
      end
    
    elseif A <: CompileIntrinsic then
      try
        let body = frame.method_body() as Sequence
        if not (body.list().size() == 1) then error end
        if not (body.list()(0)? is ast) then error end
      else
        frame.err(ast, "A compile intrinsic must be the entire method body.")
      end
      
      try
        frame.err(ast.value() as Expr,
          "A compile intrinsic cannot have a value expression.")
      end
    
    elseif A <: CompileError then
      try
        let body = (frame.parent(2) as IfDef).then_body()
        if not ((body.list().size() == 1) and (body.list()(0)? is ast)) then
          frame.err(ast,
            "A compile error must be the entire ifdef clause body.")
        end
      else
        frame.err(ast, "A compile error must be in an ifdef clause.")
      end
      
      try ast.value() as LitString else
        frame.err(try ast.value() as Expr else ast end,
          "A compile error must have a string value explaining the error.")
      end
    
    // TODO: from syntax.c - syntax_nominal
    
    elseif A <: ThisType then
      try frame.parent() as ViewpointType else
        frame.err(ast, "`this` can only be used in a type as a viewpoint.")
      end
    
    elseif A <: ViewpointType then
      if
        (frame.constraint() isnt None) and
        (frame.iftype_constraint() isnt None)
      then
        frame.err(ast, "A viewpoint type cannot be used as a constraint.")
      end
      
      try
        frame.err(ast.right() as ThisType,
          "`this` cannot appear on the right side of a viewpoint type.")
      end
      
      try
        frame.err(ast.right() as Cap,
          "A reference capability cannot appear on the right side of a " +
          "viewpoint type.")
      end
    
    elseif A <: TupleType then
      if frame.constraint() isnt None then
        frame.err(ast, "A tuple cannot be used as a type parameter constraint.")
      end
    
    elseif A <: BareLambdaType then
      try
        frame.err(ast.method_cap() as Cap,
          "A bare lambda type cannot specify a receiver capability.")
      end
      
      try
        frame.err(ast.type_params() as TypeParams,
          "A bare lambda type cannot have type parameters.")
      end
      
      try
        frame.err(ast.object_cap() as (Iso | Trn | Ref | Box | Tag),
          "A bare lambda type can only have the `val` capability.")
      end
    
    elseif A <: TypeParam then
      // TODO: check that ast.name() is a valid type param name (uppercase).
      
      None
    
    elseif A <: (Cap | GenCap) then
      if
        match frame.parent()
        | let t: (TypeDecl | Object) => t.cap() isnt ast
        | let m: Method              => m.cap() isnt ast
        | let c: (Consume | Recover) => c.cap() isnt ast
        | let n: NominalType         => n.cap() isnt ast
        | let v: ViewpointType       => v.left() isnt ast
        | let l: ( Lambda
                 | LambdaType
                 | BareLambda
                 | BareLambdaType)   => (l.method_cap() isnt ast) and
                                        (l.object_cap() isnt ast)
        else true
        end
      then
        frame.err(ast, "A type cannot be only a reference capability.")
      end
      
      iftype A <: GenCap then
        if
          (frame.constraint() is None) and (frame.iftype_constraint() is None)
        then
          frame.err(ast,
            "A reference capability set can only appear in a constraint.")
        end
      end
    
    end


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
  
  fun start(ast: Module, errors: Array[(String, SourcePosAny)]): Module =>
    apply[Module](Frame[Syntax](ast, errors), ast)
    ast // return the original module - this pass can't change the AST.
  
  fun apply[A: AST val](frame: Frame[Syntax], ast: A) =>
    iftype A <: Module then
      for t in ast.use_decls().values() do frame.visit(t) end
      for t in ast.type_decls().values() do frame.visit(t) end
    
    elseif A <: UsePackage then
      // TODO: check that ast.prefix().value() is a valid package identifier.
      None
    
    elseif A <: UseFFIDecl then
      try frame.visit(ast.guard() as IfDefCond) end
    
    elseif A <: IfDefCond then
      iftype A <: IfDefFlag then
        match ast.name()
        | let n: Id => None // TODO: verify platform flag
        | let n: LitString => None // TODO: verify lowercase is NOT a platform flag, or "illegal flag"
        end
      elseif A <: IfDefNot then
        frame.visit(ast.expr())
      elseif A <: IfDefBinaryOp then
        frame.visit(ast.left())
        frame.visit(ast.right())
      else Unreachable(ast)
      end
    
    elseif A <: TypeDecl then
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
      
      frame.visit(ast.members())
    
    elseif A <: Members then
      for f in ast.fields().values() do frame.visit(f) end
      for m in ast.methods().values() do frame.visit(m) end
    
    elseif A <: Field then
      // TODO: check that ast.name() is a valid field name (lowercase).
      
      // TODO: if in an Object, require that fields be initialized,
      //   though maybe this logic belongs in another pass.
      
      None
    
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
        
        // TODO: add this check when bare functions are implemented:
        // try
        //   frame.err(ast.bare() as At,
        //     "Only functions can be bare.")
        // end
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
      
      // TODO: verify that in-signature docstring is not present if has a body.
      
      // TODO: also visit other fields?
      try frame.visit(ast.body() as Sequence) end
    
    elseif A <: Sequence then
      for expr in ast.list().values() do frame.visit(expr) end
    
    elseif A <: Expr then
      iftype A <: Semicolon then
        frame.err(ast,
          "Use semicolons only for separating expressions on the same line.")
        
        for expr in ast.list().values() do frame.visit(expr) end
      end
    
    else Unreachable(ast)
    end

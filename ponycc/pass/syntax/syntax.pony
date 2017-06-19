
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
    
    elseif A <: Cases then
      for (idx, case) in ast.list().pairs() do
        if (idx >= (ast.list().size() - 1)) and (case.body() is None) then
          frame.err(case, "The final case in a match block must have a body.")
        end
      end
    
    elseif A <: Error then
      try
        frame.err(ast.value() as Expr,
          "An error cannot have a value expression.")
      end
    
    // TODO: from syntax.c - syntax_nominal
    // TODO: from syntax.c - syntax_tupletype (needs frame.constraint())
    // TODO: from syntax.c - syntax_arrow     (needs frame.constraint())
    
    elseif A <: ThisType then
      try
        if not ((frame.parent() as ViewpointType).left() is ast) then error end
      else
        frame.err(ast, "`this` can only be used in a type as a viewpoint.")
      end
    
    elseif A <: Semicolon then
      frame.err(ast,
        "Use semicolons only for separating expressions on the same line.")
    end

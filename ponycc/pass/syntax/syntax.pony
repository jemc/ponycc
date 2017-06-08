
use "../../ast"
use "../../frame"
use "../../unreachable"

primitive Syntax is FrameVisitor[Syntax]
  fun start(ast: Module, errors: Array[(String, SourcePosAny)]) =>
    apply[Module](Frame[Syntax](ast, errors), ast)
  
  fun apply[A: AST val](frame: Frame[Syntax], ast: A) =>
    iftype A <: Module then
      for t in ast.type_decls().values() do frame.visit(t) end
    
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
          frame.err(desc + "must specify a type.", ast)
        end
      end
      
      iftype A <: (TypeAlias | Primitive | Actor) then
        try
          frame.err(
            desc + "cannot specify a default capability.",
            ast.cap() as Cap)
        end
      end
      
      iftype
        A <: (TypeAlias | Interface | Trait | Primitive | Struct | Class)
      then
        try
          frame.err(desc + "cannot specify a C API.", ast.at() as At)
        end
        
        if ast.name().value() == "Main" then
          frame.err(
            desc + "cannot be named Main - Main must be an actor.",
            ast.name())
        end
      end
      
      try ast.at() as At
        frame.err(
          "A C API type cannot have type parameters.",
          ast.type_params() as TypeParams)
      end
      
      iftype A <: (TypeAlias | Interface | Trait | Primitive) then
        for f in ast.members().fields().values() do
          frame.err(desc + "cannot have fields.", f)
        end
      end
      
      iftype A <: TypeAlias then
        for m in ast.members().methods().values() do
          frame.err(desc + "cannot have methods.", m)
        end
      end
      
      iftype A <: (Primitive | Struct | Class) then
        for m in ast.members().methods().values() do
          try
            frame.err(desc + "cannot have behaviours.", m as MethodBe)
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
      iftype A <: MethodFun then
        try frame.type_decl() as (Trait | Interface) else
          try
            frame.err(
              "This function must provide a body.",
              ast.body() as None; ast)
          end
        end
      else
        try
          frame.err(
            "Only functions can specify a return type.",
            ast.return_type() as Type)
        end
        
        // TODO: add this check when bare functions are implemented:
        // try
        //   frame.err(
        //     "Only functions can be bare.",
        //     ast.bare() as At)
        // end
      end
      
      iftype A <: MethodNew then
        try frame.type_decl() as Primitive
          frame.err(
            "A primitive constructor cannot specify a receiver capability.",
            ast.cap() as Cap)
        end
        
        try frame.type_decl() as Actor
          frame.err(
            "An actor constructor cannot be partial.",
            ast.partial() as Question)
        end
        
        try frame.type_decl() as (Trait | Interface)
          try
            frame.err(
              "A trait or interface constructor cannot provide a body.",
              ast.body() as Sequence)
          end
        else
          try
            frame.err(
              "This constructor must provide a body.",
              ast.body() as None; ast)
          end
        end
      end
      
      iftype A <: MethodBe then
        try
          frame.err(
            "A behaviour cannot specify a receiver capability.",
            ast.cap() as Cap)
        end
        
        try
          frame.err(
            "A behaviour cannot be partial.",
            ast.partial() as Question)
        end
        
        try frame.type_decl() as (Trait | Interface) else
          try
            frame.err(
              "This behaviour must provide a body.",
              ast.body() as None; ast)
          end
        end
      end
      
      // TODO: verify that in-signature docstring is not present if has a body.
    
    else Unreachable(ast)
    end

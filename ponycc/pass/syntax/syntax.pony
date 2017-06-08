
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
        try
          let first_field = ast.members().fields()(0)
          frame.err(desc + "cannot have fields.", first_field)
        end
      end
      
      iftype A <: TypeAlias then
        try
          let first_method = ast.members().methods()(0)
          frame.err(desc + "cannot have methods.", first_method)
        end
      end
      
      iftype A <: (Primitive | Struct | Class) then
        for m in ast.members().methods().values() do
          try m as MethodBe
            frame.err(desc + "cannot have behaviours.", m)
          end
          break // only report the first behaviour
        end
      end
      
      // TODO: syntax.c: check_provides_type
      //   but this should probably be in the Traits pass instead.
      
      // TODO: for f in ast.members().fields().values() do frame.visit(f) end
      // TODO: for m in ast.members().methods().values() do frame.visit(m) end
    
    else Unreachable(ast)
    end

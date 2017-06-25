
use "../../ast"
use "../../frame"
use "../../unreachable"

use coll = "collections/persistent"

primitive Sugar is FrameVisitor[Sugar]
  """
  The purpose of the Sugar pass is to fill in implicit details and expand
  abbreviated forms to their more verbose equivalents.
  
  Changes that require any kind of larger context (such as other packages,
  scoping, name resolution, type information) do not belong here.
  
  This pass changes the AST, but it is idempotent.
  """
  
  fun find_member(members: Members, name: String): (Method | Field | None) =>
    for method in members.methods().values() do
      if method.name().value() == name then return method end
    end
    for field in members.fields().values() do
      if field.name().value() == name then return field end
    end
  
  fun apply[A: AST val](frame: Frame[Sugar], ast': A) =>
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
        if find_member(ast.members(), "create") is None then
          let cap =
            iftype A <: (Struct | Class) then Iso
            elseif A <: Primitive        then Val
            elseif A <: Actor            then Tag
            else Unreachable(ast); Tag
            end
          
          let method =
            MethodNew(Id("create"), cap where body' =
              Sequence(coll.Vec[Expr].concat([as Expr: LitTrue].values())))
          
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
    end

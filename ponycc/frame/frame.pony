
use "../ast"

interface val FrameVisitor[V: FrameVisitor[V]]
  new val create()
  fun apply[A: AST val](frame: Frame[V], a: A)

actor _FrameErrors
  embed _errs: Array[(String, SourcePosAny)] = _errs.create()
  be err(a: AST, s: String) => _errs.push((s, a.pos()))
  be complete(fn: {(Array[(String, SourcePosAny)] val)} val) =>
    let copy = recover Array[(String, SourcePosAny)] end
    for e in _errs.values() do copy.push(e) end
    fn(consume copy)

actor FrameRunner[V: FrameVisitor[V]]
  new create(ast: Module, fn: {(Module, Array[(String, SourcePosAny)] val)} val)
  =>
    let errors = _FrameErrors
    let frame  = Frame[V](ast, errors)
    frame._visit(ast)
    let module = frame.module()
    
    errors.complete({(errs) => fn(module, errs) })

class _FrameTop[V: FrameVisitor[V]]
  let _errors: _FrameErrors
  var _module: Module
  
  new create(module': Module, errors': _FrameErrors) =>
    (_module, _errors) = (module', errors')
  
  fun err(a: AST, s: String) => _errors.err(a, s)
  
  fun parent(n: USize): AST => _module // ignore n - we can't go any higher
  fun ref replace(a: AST) => try _module = a as Module end
  fun module(): Module => _module
  fun type_decl(): (TypeDecl | None) => None
  fun method(): (Method | None) => None
  fun method_body(): (Sequence | None) => None
  fun constraint(): (Type | None) => None
  fun iftype_constraint(): (Type | None) => None

class Frame[V: FrameVisitor[V]]
  let _upper: (Frame[V] | _FrameTop[V])
  var _ast: AST
  
  new create(module': Module, errors': _FrameErrors) =>
    _upper = _FrameTop[V](module', errors')
    _ast   = module'
  
  new _create_under(upper': Frame[V], a: AST) =>
    _upper = upper'
    _ast   = a
  
  fun ref _visit(ast: AST) =>
    let frame = Frame[V]._create_under(this, ast) .> _visit_each()
    frame._ast.apply_specialised[Frame[V]](frame,
      {[A: AST val](frame, a: A) => V.apply[A](frame, a) })
  
  fun ref _visit_each() =>
    _ast.each({(child)(frame = this) => try frame._visit(child as AST) end })
  
  fun err(a: AST, s: String) =>
    """
    Emit an error, indicating a problem with the given AST node, including the
    given message as a human-friendly explanation of the problem.
    """
    _upper.err(a, s)
  
  fun parent(n: USize = 1): AST =>
    """
    Get the n-th AST node above this one.
    
    If n is zero, the AST node associated with the current Frame is returned.
    If n is too high, the uppermost AST node in this Frame stack is returned.
    """
    if n == 0 then _ast else _upper.parent(n - 1) end
  
  fun ref replace(replace': AST) =>
    """
    Replace the current AST node for this Frame with the given replacement AST.
    
    If the given AST is not the correct type for replacing this slot in the
    parent AST, or if the Frame's current AST is not actually a child of the
    parent AST, the replacement operation will silently fail, with no effect.
    """
    if _ast isnt replace' then
      if parent() is _ast then // TODO: less hacky dealing with FrameTop.
        _upper.replace(replace')
      else
        _upper.replace(parent().with_replaced_child(_ast, replace'))
      end
      _ast = replace'
    end
  
  fun module(): Module =>
    """
    Get the nearest Module above this AST node.
    """
    _upper.module()
  
  fun type_decl(): (TypeDecl | None) =>
    """
    Get the nearest TypeDecl above this AST node.
    """
    try _ast as TypeDecl else _upper.type_decl() end
  
  fun method(): (Method | None) =>
    """
    Get the nearest Method above this AST node.
    """
    try _ast as Method else _upper.method() end
  
  fun method_body(): (Sequence | None) =>
    """
    Get the nearest Method body Sequence above this AST node.
    Stop searching through the hierarchy when a Method is reached.
    """
    match parent() | let m: Method =>
      if _ast is m.body() then m.body() else None end
    else
      _upper.method_body()
    end
  
  fun constraint(): (Type | None) =>
    """
    Get the nearest TypeParam constraint Type above this AST node.
    Stop searching through the hierarchy when a TypeParam is reached.
    Also stop searching at TypeArgs - type arguments of a constraining Type
    are not counted as being a part of the constraining Type themselves.
    """
    match parent()
    | let _: TypeArgs => None
    | let t: TypeParam =>
      if _ast is t.constraint() then t.constraint() else None end
    else
      _upper.constraint()
    end
  
  fun iftype_constraint(): (Type | None) =>
    """
    Get the nearest IfType constraint (super) Type above this AST node.
    Stop searching through the hierarchy when an IfType is reached.
    Also stop searching at TypeArgs - type arguments of a constraining Type
    are not counted as being a part of the constraining Type themselves.
    """
    match parent()
    | let _: TypeArgs => None
    | let i: IfType =>
      if _ast is i.super() then i.super() else None end
    else
      _upper.iftype_constraint()
    end

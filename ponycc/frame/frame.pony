
use "../ast"
use "../pass"

interface val FrameVisitor[V: FrameVisitor[V]]
  new val create()
  fun visit[A: AST val](frame: Frame[V], a: A)

primitive FrameVisitorNone is FrameVisitor[FrameVisitorNone]
  fun visit[A: AST val](frame: Frame[FrameVisitorNone], a: A) => None

actor FrameRunner[V: FrameVisitor[V]]
  """
  Visit all of the AST nodes in the given Program, using the given FrameVisitor.
  
  The order of visitation is depth-first, with children being visited before
  their parent node is visited. Children have no knowledge of their parent,
  other than through the separate Frame object that is part of the visitation.
  """
  new create(ast: Program, fn: {(Program, Array[PassError] val)} val) =>
    let errors = _FrameErrors
    let frame  = Frame[V](ast, errors)
    frame._visit(ast)
    
    let program = frame.program()
    errors.complete({(errs) => fn(program, errs) })

actor _FrameErrors
  embed _errs: Array[PassError] = _errs.create()
  be err(a: AST, s: String) => _errs.push((s, a.pos()))
  be complete(fn: {(Array[PassError] val)} val) =>
    let copy = recover Array[PassError] end
    for e in _errs.values() do copy.push(e) end
    fn(consume copy)

class _FrameTop[V: FrameVisitor[V]]
  let _errors: _FrameErrors
  var _program: Program
  
  new create(program': Program, errors': _FrameErrors) =>
    (_program, _errors) = (program', errors')
  
  fun err(a: AST, s: String) => _errors.err(a, s)
  
  fun parent(n: USize): AST => _program // ignore n - we can't go any higher
  fun ref replace(a: AST) => try _program = a as Program end
  fun program(): Program => _program
  fun package(): (Package | None) => None
  fun module(): (Module | None) => None
  fun type_decl(): (TypeDecl | None) => None
  fun method(): (Method | None) => None
  fun method_body(): (Sequence | None) => None
  fun constraint(): (Type | None) => None
  fun iftype_constraint(): (Type | None) => None

class Frame[V: FrameVisitor[V]]
  let _upper: (Frame[V] | _FrameTop[V])
  var _ast: AST
  
  new create(program': Program, errors': _FrameErrors) =>
    _upper = _FrameTop[V](program', errors')
    _ast   = program'
  
  new _create_under(upper': Frame[V], a: AST) =>
    _upper = upper'
    _ast   = a
  
  fun ref _visit(ast: AST) =>
    """
    Visit the given AST node in a new frame, after visiting its children.
    """
    let frame = Frame[V]._create_under(this, ast)
    frame._visit_each()
    frame._ast.apply_specialised[Frame[V]](frame,
      {[A: AST val](frame, a: A) => V.visit[A](frame, a) })
  
  fun ref _visit_each() =>
    """
    Visit each child of the current AST node.
    """
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
  
  fun program(): Program =>
    """
    Get the nearest Program above this AST node.
    """
    _upper.program()
  
  fun package(): (Package | None) =>
    """
    Get the nearest Package above this AST node.
    """
    try _ast as Package else _upper.package() end
  
  fun module(): (Module | None) =>
    """
    Get the nearest Module above this AST node.
    """
    try _ast as Module else _upper.module() end
  
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

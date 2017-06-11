
use "../ast"

interface val FrameVisitor[V: FrameVisitor[V]]
  new val create()
  fun apply[A: AST val](frame: Frame[V], a: A)

class _FrameTop[V: FrameVisitor[V]]
  let _errors: Array[(String, SourcePosAny)]
  let _module: Module
  
  new create(module': Module, errors': Array[(String, SourcePosAny)]) =>
    (_module, _errors) = (module', errors')
  
  fun ref err(a: AST, s: String) => _errors.push((s, a.pos()))
  
  fun parent(n: USize): AST => _module // ignore n - we can't go any higher
  fun module(): Module => _module
  fun type_decl(): (TypeDecl | None) => None
  fun method(): (Method | None) => None

class Frame[V: FrameVisitor[V]]
  let _upper: (Frame[V] | _FrameTop[V])
  let _ast: AST
  
  new create(module': Module, errors': Array[(String, SourcePosAny)]) =>
    _upper = _FrameTop[V](module', errors')
    _ast   = module'
  
  new _create_under(upper': Frame[V], a: AST) =>
    _upper = upper'
    _ast   = a
  
  fun ref visit(ast: AST) =>
    ast.apply_specialised[Frame[V]](this,
      {[A: AST val](frame: Frame[V], a: A) =>
        V.apply[A](Frame[V]._create_under(frame, a), a)
      })
  
  fun ref err(a: AST, s: String) =>
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

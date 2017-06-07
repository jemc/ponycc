
use "../ast"

interface val FrameVisitor[V: FrameVisitor[V]]
  new val create()
  fun apply[A: AST val](frame: Frame[V], a: A)

class _FrameTop[V: FrameVisitor[V]]
  let _errors: Array[(String, SourcePosAny)]
  let _module: Module
  
  new create(module': Module, errors': Array[(String, SourcePosAny)]) =>
    (_module, _errors) = (module', errors')
  
  fun ref err(s: String, a: AST) => _errors.push((s, a.pos()))
  fun module(): Module => _module

class Frame[V: FrameVisitor[V]]
  let _upper: (Frame[V] | _FrameTop[V])
  let _type_decl: (TypeDecl | None)
  
  new create(module': Module, errors': Array[(String, SourcePosAny)]) =>
    _upper = _FrameTop[V](module', errors')
    _type_decl = None
  
  new _create_under[A: AST val = AST](upper': Frame[V], a: A) =>
    _upper = upper'
    _type_decl = iftype A <: TypeDecl then a else upper'.type_decl() end
  
  fun ref visit(ast: AST) =>
    ast.apply_specialised[Frame[V]](this,
      {[A: AST val](frame: Frame[V], a: A) =>
        V.apply[A](Frame[V]._create_under[A](frame, a), a)
      })
  
  fun ref err(s: String, a: AST) => _upper.err(s, a)
  fun module(): Module => _upper.module()
  fun type_decl(): TypeDecl ? => _type_decl as TypeDecl


use "../ast"
use "../pass"
use poly = "../polyfill"

interface val FrameVisitor[V: FrameVisitor[V]]
  new val create()
  fun visit[A: AST val](frame: Frame[V], a: A)

primitive FrameVisitorNone is FrameVisitor[FrameVisitorNone]
  fun visit[A: AST val](frame: Frame[FrameVisitorNone], a: A) => None

class val FrameRunner[V: FrameVisitor[V]]
  """
  Visit all of the AST nodes in the given program, using the given FrameVisitor.
  
  The order of visitation is depth-first, with children being visited before
  their parent node is visited. Children have no knowledge of their parent,
  other than through the separate Frame object that is part of the visitation.
  """
  let _reactor: _FrameReactor[V]
  
  new val create(program: Program, fn: {(Program, Array[PassError] val)} val) =>
    _reactor = _FrameReactor[V](program, fn)
  
  fun err(a: AST, s: String) => _reactor.err(a, s)
  
  fun view_each_ffi_decl(fn: {(UseFFIDecl)} val) =>
    _reactor.view_each_ffi_decl(fn)

actor _FrameReactor[V: FrameVisitor[V]]
  let _program: Program
  var _complete_fn: {(Program, Array[PassError] val)} val
  var _expectations: USize = 0
  embed _errs: Array[PassError] = _errs.create()
  
  new create(program: Program, fn: {(Program, Array[PassError] val)} val) =>
    _program = program
    _complete_fn = fn
    
    // TODO: figure out how to abstract this somehow.
    let reactor: _FrameReactor[V] = this
    reactor.push_expectation()
    program.access_packages({(packages)(reactor, program) =>
      for package in packages.values() do
        reactor.push_expectation()
        package.access_type_decls({(type_decls)(reactor, program, package) =>
          for type_decl in type_decls.values() do
            reactor.push_expectation()
            type_decl.access_type_decl({(ast)(reactor, program, package, type_decl) =>
              let top = _FrameTop[V](reactor, program, package, type_decl, ast)
              let frame = Frame[V]._create_under(top, ast)
              frame._visit(ast)
              reactor.pop_expectation()
              top.type_decl()
            })
          end
          reactor.pop_expectation()
        })
      end
      reactor.pop_expectation()
    })
  
  be view_each_ffi_decl(fn: {(UseFFIDecl)} val) =>
    let reactor: _FrameReactor[V] = this
    reactor.push_expectation()
    _program.access_packages({(packages)(reactor, fn) =>
      for package in packages.values() do
        reactor.push_expectation()
        package.access_ffi_decls({(ffi_decls)(reactor, fn) =>
          for ffi_decl in ffi_decls.values() do
            fn(ffi_decl)
          end
          reactor.pop_expectation()
        })
      end
      reactor.pop_expectation()
    })
  
  be err(a: AST, s: String) => _errs.push(PassError(a.pos(), s))
  
  be push_expectation() => _expectations = _expectations + 1
  be pop_expectation() =>
    if 1 >= (_expectations = _expectations - 1) then complete() end
  
  be complete() =>
    poly.Sort[PassError](_errs)
    let copy = recover Array[PassError] end
    for e in _errs.values() do copy.push(e) end
    (_complete_fn = {(_, _) => _ })(_program, consume copy)

class _FrameTop[V: FrameVisitor[V]]
  let _reactor: _FrameReactor[V]
  let _program: Program
  let _package: Package
  let _type_decl: PackageTypeDecl
  var _ast: TypeDecl
  
  new create(
    reactor': _FrameReactor[V],
    program': Program,
    package': Package,
    type_decl': PackageTypeDecl,
    ast': TypeDecl)
  =>
    (_reactor, _program, _package, _type_decl, _ast) =
      (reactor', program', package', type_decl', ast')
  
  fun err(a: AST, s: String) => _reactor.err(a, s)
  
  fun parent(n: USize): AST => _ast // ignore n - we can't go any higher
  fun ref replace(a: AST) => try _ast = a as TypeDecl end
  fun program(): Program => _program
  fun package(): Package => _package
  fun type_decl(): TypeDecl => _ast
  fun method(): (Method | None) => None
  fun method_body(): (Sequence | None) => None
  fun constraint(): (Type | None) => None
  fun iftype_constraint(): (Type | None) => None

class Frame[V: FrameVisitor[V]]
  let _upper: (Frame[V] | _FrameTop[V])
  var _ast: AST
  
  new _create_under(upper': (Frame[V] | _FrameTop[V]), a: AST) =>
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
  
  fun package(): Package =>
    """
    Get the nearest Package above this AST node.
    """
    _upper.package()
  
  fun type_decl(): TypeDecl =>
    """
    Get the nearest TypeDecl above this AST node.
    """
    _upper.type_decl()
  
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

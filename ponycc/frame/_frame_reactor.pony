use "../ast"
use "../pass"
use poly = "../polyfill"
use "collections"

actor _FrameReactor[V: FrameVisitor[V]]
  let _program: Program
  var _complete_fn: {(Program, Array[PassError] val)} val
  var _expectations: USize = 0
  embed _errs: Array[PassError] = _errs.create()
  embed _continuations:
    Array[(Program, Package, PackageTypeDecl, _FrameContinuation[V] iso)] =
      _continuations.create()
  
  new create(program: Program, fn: {(Program, Array[PassError] val)} val) =>
    (_program, _complete_fn) = (program, fn)
    visit_program(_program)
  
  be err(a: AST, s: String) => _errs.push(PassError(a.pos(), s))
  
  be _push_expectation() => _expectations = _expectations + 1
  be _pop_expectation() =>
    if 1 >= (_expectations = _expectations - 1) then _maybe_complete() end
  
  be _maybe_complete() =>
    if _continuations.size() == 0 then _complete(); return end
    
    try while true do
      (let a, let b, let c, let continuation) = _continuations.pop()?
      visit_type_decl(a, b, c, consume continuation)
    end end
  
  be _complete() =>
    poly.Sort[PassError](_errs)
    let copy = recover Array[PassError] end
    for e in _errs.values() do copy.push(e) end
    (_complete_fn = {(_, _) => _ })(_program, consume copy)
  
  be _track_result(
    program: Program,
    package: Package,
    type_decl: PackageTypeDecl,
    result: (_FrameContinuation[V] iso | None) = None)
  =>
    match consume result | let continuation: _FrameContinuation[V] iso =>
      _continuations.push((program, package, type_decl, consume continuation))
    end
  
  fun tag visit_program(program: Program) =>
    _push_expectation()
    program.access_packages({(packages)(reactor = this) =>
      for package in packages.values() do
        reactor.visit_package(program, package)
      end
      reactor._pop_expectation()
    })
  
  fun tag visit_package(program: Program, package: Package) =>
    _push_expectation()
    package.access_type_decls({(type_decls)(reactor = this) =>
      for type_decl in type_decls.values() do
        reactor.visit_type_decl(program, package, type_decl)
      end
      reactor._pop_expectation()
    })
  
  fun tag visit_type_decl(
    program: Program,
    package: Package,
    type_decl: PackageTypeDecl,
    continue_from: (_FrameContinuation[V] val | None) = None)
  =>
    _push_expectation()
    type_decl.access_type_decl({(ast')(reactor = this) =>
     // TODO: remove the need for this clone
      let continue_from' =
        try (continue_from as _FrameContinuation[V] val).clone() end
      
      var ast = ast'
      reactor._track_result(program, package, type_decl,
        recover
          let top = _FrameTop[V](reactor, program, package, type_decl, ast)
          let frame = Frame[V]._create_under(top, ast)
          let continuation = frame._visit(consume continue_from')
          ast = top.type_decl()
          continuation
        end
      )
      reactor._pop_expectation()
      ast
    })
  
  be view_each_ffi_decl(fn: {(UseFFIDecl)} val) =>
    let reactor: _FrameReactor[V] = this
    reactor._push_expectation()
    _program.access_packages({(packages)(reactor, fn) =>
      for package in packages.values() do
        reactor._push_expectation()
        package.access_ffi_decls({(ffi_decls)(reactor, fn) =>
          for ffi_decl in ffi_decls.values() do
            fn(ffi_decl)
          end
          reactor._pop_expectation()
        })
      end
      reactor._pop_expectation()
    })

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
  embed _ready_to_continue:
    MapIs[_FrameContinuation[V] tag, Any val] =
      _ready_to_continue.create()
  
  new create(program: Program, fn: {(Program, Array[PassError] val)} val) =>
    (_program, _complete_fn) = (program, fn)
    visit_program(_program)
  
  be err(a: AST, s: String) =>
    _errs.push(PassError(a.pos(), s))
  
  be _push_expectation() => _expectations = _expectations + 1
  be _pop_expectation() =>
    _expectations = _expectations - 1
    if _expectations == 0 then _complete() end
  
  be continue_with(c: _FrameContinuation[V] tag, value: Any val) =>
    var found = false
    try while true do
      (let prog, let pkg, let td, let continuation) = _continuations.shift()?
      if continuation is c then
        found = true
        continuation.value = value
        visit_type_decl(prog, pkg, td, consume continuation)
        _pop_expectation()
      else
        _continuations.push((prog, pkg, td, consume continuation))
      end
    end end
    if not found then _ready_to_continue(c) = value end
  
  fun ref _complete() =>
    if (_continuations.size() > 0) and (_errs.size() == 0) then
      _errs.push(PassError(SourcePosNone, "compiler deadlock"))
      // TODO: show info about pending continuations here.
    end
    
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
      if _ready_to_continue.contains(continuation) then
        try
          (_, let value) = _ready_to_continue.remove(continuation)?
          continuation.value = value
          visit_type_decl(program, package, type_decl, consume continuation)
          _pop_expectation()
        end
      else
        _continuations.push((program, package, type_decl, consume continuation))
      end
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
          match continuation | let c: _FrameContinuation[V] =>
            reactor._push_expectation()
          end
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

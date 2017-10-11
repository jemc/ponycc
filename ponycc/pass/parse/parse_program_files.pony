
use ".."
use "../../ast"
use "collections"

class val ParseProgramFiles is Pass[Sources, Program]
  """
  TODO: Docs for this agreggated pass
  """
  let _resolve_sources: {(String, String): (String, Sources)?} val
  
  fun name(): String => "parse-program-files"
  
  new val create(resolve_sources': {(String, String): (String, Sources)?} val) =>
    _resolve_sources = resolve_sources'
  
  fun apply(sources: Sources, fn: {(Program, Array[PassError] val)} val) =>
    _ParseProgramFilesEngine(_resolve_sources, fn).start(sources)

actor _ParseProgramFilesEngine
  let _pending: SetIs[Source]                    = _pending.create()
  let _packages: Array[(Package, Array[Module])] = _packages.create()
  var _errs: Array[PassError] trn                = []
  let _complete_fn: {(Program, Array[PassError] val)} val
  let _resolve_sources: {(String, String): (String, Sources)?} val
  
  new create(
    resolve_sources': {(String, String): (String, Sources)?} val,
    complete_fn': {(Program, Array[PassError] val)} val)
  =>
    (_resolve_sources, _complete_fn) = (resolve_sources', complete_fn')
  
  be start(sources: Sources, package_uuid: Uuid = Uuid) =>
    let package = Package.attach[Uuid](package_uuid)
    for source in sources.values() do
      _pending.set(source)
      let this_tag: _ParseProgramFilesEngine = this
      Parse(source, this_tag~after_parse(source, package)) // TODO: fix ponyc to let plain `this` work here
    end
  
  be after_parse(
    source: Source, package: Package,
    module': Module, errs: Array[PassError] val)
  =>
    var module = consume module'
    
    // Take note of having finished parsing this source.
    _pending.unset(source)
    
    // Take note of any errors.
    for err in errs.values() do _errs.push(err) end
    
    // Call start for the source files of any referenced packages.
    let new_use_decls: Array[UseDecl] trn = []
    for use_decl in module.use_decls().values() do
      match use_decl | let u: UsePackage =>
        try
          (let package_path, let sources) =
            _resolve_sources(u.pos().source().path(), u.package().value())?
          
          // TODO: assign same Uuid to Packages with the same absolute path.
          let package_uuid = Uuid
          new_use_decls.push(u.attach[Uuid](package_uuid))
          start(sources, package_uuid)
        else
          _errs.push(
            ("Couldn't resolve this package directory.", u.package().pos()))
        end
      else
        new_use_decls.push(use_decl)
      end
    end
    module = module.with_use_decls(consume new_use_decls)
    
    // Take note of this module as being within this package.
    try
      let idx = _packages.find(
        (package, []) where predicate = {(l, r) => l._1 is r._1 })?
      _packages(idx)?._2.push(module)
    else
      _packages.push((package, [module]))
    end
    
    _maybe_complete()
  
  be _maybe_complete() =>
    """
    If there are no more pending sources left, run the completion logic.
    This is in a separate behaviour so that causal message order ensures that
    this happens after any start calls in the same after_parse execution.
    """
    if _pending.size() == 0 then _complete() end
  
  fun ref _complete() =>
    let packages: Array[Package] trn = []
    
    // Collect the modules into packages.
    try while true do
      (var package, let modules) = _packages.pop()?
      for module in modules.values() do
        package = package.with_modules_push(module)
      end
      packages.push(package)
    end end
    
    _complete_fn(Program(consume packages), _errs = [])

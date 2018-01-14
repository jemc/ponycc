
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
  let _pending: SetIs[Source]     = _pending.create()
  let _packages: Array[Package]   = []
  var _errs: Array[PassError] trn = []
  let _complete_fn: {(Program, Array[PassError] val)} val
  let _resolve_sources: {(String, String): (String, Sources)?} val
  
  new create(
    resolve_sources': {(String, String): (String, Sources)?} val,
    complete_fn': {(Program, Array[PassError] val)} val)
  =>
    (_resolve_sources, _complete_fn) = (resolve_sources', complete_fn')
  
  be start(sources: Sources, package: Package = Package) =>
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
    
    let use_packages = Array[UsePackage]
    
    // Call start for the source files of any referenced packages.
    for u' in module.use_decls().values() do
      match u'
      | let u: UseFFIDecl => package.add_ffi_decl(u)
      | let u: UsePackage =>
        try
          (let package_path, let sources) =
            _resolve_sources(u.pos().source().path(), u.package().value())?
          
          // TODO: assign same Package to packages with the same absolute path.
          let new_package = Package
          use_packages.push(u.attach[Package](new_package))
          start(sources, new_package)
        else
          _errs.push(PassError(u.package().pos(),
            "Couldn't resolve this package directory."))
        end
      end
    end
    
    for t in module.type_decls().values() do
      let type_decl = PackageTypeDecl(t)
      for u in use_packages.values() do type_decl.add_use_package(u) end
      package.add_type_decl(type_decl)
    end
    
    try package.add_doc(module.docs() as LitString) end
    
    _packages.push(package)
    
    _maybe_complete()
  
  be _maybe_complete() =>
    """
    If there are no more pending sources left, run the completion logic.
    This is in a separate behaviour so that causal message order ensures that
    this happens after any start calls in the same after_parse execution.
    """
    if _pending.size() == 0 then _complete() end
  
  fun ref _complete() =>
    let program = Program
    
    // Collect the modules into packages.
    for package in _packages.values() do
      program.add_package(package)
    end
    
    _complete_fn(program, _errs = [])

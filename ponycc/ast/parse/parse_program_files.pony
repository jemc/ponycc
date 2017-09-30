
use ".."
use "../../pass"
use "collections"

class val ParseProgramFiles is Pass[Sources, Program]
  """
  TODO: Docs for this agreggated pass
  """
  fun name(): String => "parse-program-files"
  
  new val create(auth: AmbientAuth) => None
  
  fun apply(sources: Sources, fn: {(Program, Array[PassError] val)} val) =>
    let engine       = _ParseProgramFilesEngine(fn)
    let root_package = Package
    
    for source in sources.values() do
      engine.start(source, root_package)
    end

actor _ParseProgramFilesEngine
  let _pending: SetIs[Source]                    = _pending.create()
  let _packages: Array[(Package, Array[Module])] = _packages.create()
  var _errs: Array[PassError] trn                = []
  let _complete_fn: {(Program, Array[PassError] val)} val
  
  new create(fn: {(Program, Array[PassError] val)} val) =>
    _complete_fn = fn
  
  be start(source: Source, package: Package) =>
    _pending.set(source)
    let this_tag: _ParseProgramFilesEngine = this
    Parse(source, this_tag~after_parse(source, package)) // TODO: fix ponyc to let plain `this` work here
  
  be after_parse(
    source: Source, package: Package,
    module: Module, errs: Array[PassError] val)
  =>
    // Take note of having finished parsing this source.
    _pending.unset(source)
    
    // Take note of any errors.
    for err in errs.values() do _errs.push(err) end
    
    // TODO: call start for any use statements in the module.
    
    // Take note of this module as being within this package.
    try
      let idx = _packages.find(
        (package, []) where predicate = {(l, r) => l._1 is r._1 })?
      _packages(idx)?._2.push(module)
    else
      _packages.push((package, [module]))
    end
    
    // If there are no more pending sources left, run the completion logic.
    if _pending.size() == 0 then _complete() end
  
  fun ref _complete() =>
    let packages: Array[Package] trn = []
    
    // TODO: figure out how to link from Modules to Packages that they refer to.
    
    // Collect the modules into packages.
    try while true do
      (var package, let modules) = _packages.pop()?
      for module in modules.values() do
        package = package.with_modules_push(module)
      end
      packages.push(package)
    end end
    
    _complete_fn(Program(consume packages), _errs = [])

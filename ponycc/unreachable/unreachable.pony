
class Unreachable
  new create(value: (Stringable | None) = None, loc: SourceLoc = __loc) =>
    @fprintf[I32](@pony_os_stderr[Pointer[U8]](),
      "ABORT: Unreachable condition at %s:%zu (in %s method)\n".cstring(),
      loc.file().cstring(), loc.line(), loc.method().cstring())
    
    if value isnt None then
      @printf[I32]("%s\n".cstring(), value.string().cstring())
    end
    
    @exit[None](I32(1))

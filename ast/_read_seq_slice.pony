
class val _ReadSeqSlice[A: Equatable[A] val] is ReadSeq[A]
  let inner: ReadSeq[A] val
  let start: USize
  let finish: USize
  new val create(a: ReadSeq[A] val, s: USize, f: USize) =>
    inner = a; start = s; finish = f
  
  fun slice(i: USize, j: USize): _ReadSeqSlice[A] =>
    _ReadSeqSlice[A](inner, start + i, (start + j).min(finish))
  
  fun eq(that: box->ReadSeq[A]): Bool =>
    if this.size() != that.size() then return false end
    let a = this.values()
    let b = that.values()
    try while a.has_next() and b.has_next() do
      if a.next() != b.next() then return false end
    end end
    true
  
  fun size(): USize         => finish - start
  fun apply(i: USize): A?   => inner(start + i)
  fun values(): Iterator[A] =>
    object is Iterator[A]
      let slice: _ReadSeqSlice[A] box = this
      var index: USize                = start
      fun ref has_next(): Bool => index < slice.finish
      fun ref next(): A? =>
        if has_next() then slice.inner(index = index + 1) else error end
    end

class _FrameContinuation[V: FrameVisitor[V]]
  embed indices: Array[USize] = []
  let continue_fn: {(Frame[V], Any val)} val
  var value: Any val = None
  
  new create(fn: {(Frame[V], Any val)} val) => continue_fn = fn
  
  fun ref _push_index(idx: USize) => indices.push(idx)
  
  fun clone(): _FrameContinuation[V] iso^ =>
    let copy = recover _FrameContinuation[V](continue_fn) end
    for i in indices.values() do copy._push_index(i) end
    copy.value = value
    consume copy


use mut = "collections"
use coll = "collections/persistent"

trait val _AttachmentTagAny
primitive _AttachmentTag[T] is _AttachmentTagAny

class val Attachments
  let _val_map: coll.HashMap[_AttachmentTagAny, Any val, mut.HashIs[_AttachmentTagAny]]
  let _tag_map: coll.HashMap[_AttachmentTagAny, Any tag, mut.HashIs[_AttachmentTagAny]]

  new val create(
    val_map': coll.HashMap[_AttachmentTagAny, Any val, mut.HashIs[_AttachmentTagAny]] = coll.HashMap[_AttachmentTagAny, Any val, mut.HashIs[_AttachmentTagAny]],
    tag_map': coll.HashMap[_AttachmentTagAny, Any tag, mut.HashIs[_AttachmentTagAny]] = coll.HashMap[_AttachmentTagAny, Any tag, mut.HashIs[_AttachmentTagAny]])
  =>
    _val_map = val_map'
    _tag_map = tag_map'

  fun find[A: Any #share](): A? =>
    // WARNING: This uses an unsafe compiler loophole that will be closed.
    try
      _tag_map(_AttachmentTag[A])? as A
    else
      _val_map(_AttachmentTag[A])? as A
    end
    // TODO: reinstate this safe alternative when the compiler crash is fixed.
    //   https://github.com/ponylang/ponyc/issues/2363
    // iftype A <: Any tag then
    //   _tag_map(_AttachmentTag[A])?
    // else
    //   _val_map(_AttachmentTag[A])?
    // end as A

  fun val attach[A: Any #share](a: A): Attachments =>
    iftype A <: Any tag then
      create(_val_map, _tag_map(_AttachmentTag[A]) = a)
    elseif A <: Any val then
      create(_val_map(_AttachmentTag[A]) = a, _tag_map)
    else
      this
    end

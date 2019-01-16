
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

  fun find_val[A: Any val](): A? =>
    _val_map(_AttachmentTag[A])? as A

  fun find_tag[A: Any tag](): A? =>
    _tag_map(_AttachmentTag[A])? as A

  fun val attach_val[A: Any val](a: A): Attachments =>
    create(_val_map(_AttachmentTag[A]) = a, _tag_map)

  fun val attach_tag[A: Any tag](a: A): Attachments =>
    create(_val_map, _tag_map(_AttachmentTag[A]) = a)

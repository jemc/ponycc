
class val Source
  let content: String
  let path:    String
  
  new val create(content': String = "", path': String = "") =>
    (content, path) = (content', path')

class val SourcePos
  let source: Source
  let offset: USize
  let length: USize
  
  new val create(source': Source, offset': USize = 0, length': USize = 0) =>
    (source, offset, length) = (source', offset', length')


use "collections"

type Sources is ReadSeq[Source] val

interface val SourceAny is Comparable[SourceAny box]
  fun content(): String
  fun path():    String

  fun eq(that: SourceAny box): Bool => path() == that.path()
  fun lt(that: SourceAny box): Bool => path() < that.path()

primitive SourceNone is SourceAny
  fun content(): String => ""
  fun path():    String => ""

class val Source is SourceAny
  let _content: String
  let _path:    String

  new val create(content': String = "", path': String = "") =>
    (_content, _path) = (content', path')

  fun content(): String => _content
  fun path():    String => _path

interface val SourcePosAny is Comparable[SourcePosAny box]
  fun source(): SourceAny
  fun offset(): USize
  fun length(): USize

  fun eq(that: SourcePosAny box): Bool =>
    (source() == that.source()) and
    (offset() == that.offset()) and
    (length() == that.length())

  fun lt(that: SourcePosAny box): Bool =>
    (source() < that.source()) or (
      (source() == that.source()) and (
        (offset() < that.offset()) or (
          (offset() == that.offset()) and
            (length() < that.length())
        )
      )
    )

  fun string(): String =>
    source().content().trim(offset(), offset() + length())

  fun entire_line(): SourcePosAny =>
    let str = source().content()

    let i = try (str.rfind("\n", offset().isize())? + 1).usize() else 0 end
    let j = try str.find("\n", offset().isize())?.usize() else str.size() end

    SourcePos(source(), i, j - i)

  fun show_in_line(): (String, String) =>
    let l = entire_line()

    let arrow = recover String(l.length()) end
    for i in Range(0, offset() - l.offset().min(offset())) do arrow.push(' ') end
    arrow.push('^')
    if length() >= 1 then
      for i in Range(0, length() - 1) do arrow.push('~') end
    end

    (l.string(), consume arrow)

primitive SourcePosNone is SourcePosAny
  fun source(): SourceAny => SourceNone
  fun offset(): USize => 0
  fun length(): USize => 0

class val SourcePos is SourcePosAny
  let _source: SourceAny
  let _offset: USize
  let _length: USize

  new val create(source': SourceAny, offset': USize = 0, length': USize = 0) =>
    (_source, _offset, _length) = (source', offset', length')

  fun source(): SourceAny => _source
  fun offset(): USize => _offset
  fun length(): USize => _length

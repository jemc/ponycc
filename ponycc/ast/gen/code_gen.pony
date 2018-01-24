
use "collections"
use "format"

class CodeGen
  let _lines:   List[String] = List[String]
  let _indents: List[String] = List[String]

  new iso create() =>
    _indents.push("")

  fun string(): String =>
    let out = recover trn String end
    for l in _lines.values() do out.append(l + "\n") end
    out

  fun ref add(s: String = "") =>
    _lines.push(try _lines.pop()? else "" end + s)

  fun ref line(s: String = "") =>
    _lines.push(current_indent() + s)

  fun ref block(s: String = "") =>
    for s' in s.split_by("\n").values() do
      _lines.push(current_indent() + s')
    end

  fun ref push_indent(s: String = "  ") =>
    _indents.push(current_indent() + s)

  fun ref pop_indent() =>
    try _indents.pop()? end

  fun ref current_indent(): String =>
    try _indents.tail()?()? else "" end

  fun tag string_literal(s: String box): String =>
    let out = recover trn String end
    out.push('"')
    for b' in s.values() do
      match b'
      | '"'  => out.push('\\'); out.push('"')
      | '\\' => out.push('\\'); out.push('\\')
      | let b: U8 if b < 0x10 => out.append("\\x0" + Format.int[U8](b, FormatHexBare))
      | let b: U8 if b < 0x20 => out.append("\\x"  + Format.int[U8](b, FormatHexBare))
      | let b: U8 if b < 0x7F => out.push(b)
      else let b = b';           out.append("\\x"  + Format.int[U8](b, FormatHexBare))
      end
    end
    out.push('"')
    consume out

  fun tag bytes_literal(a: Array[U8] box): String =>
    if a.size() == 0 then return "recover val Array[U8] end" end
    let out = recover trn String end
    out.append("[as U8: ")

    let iter = a.values()
    for b in iter do
      out.append("0x" + Format.int[U8](b, FormatHexBare, PrefixDefault, 2))
      if iter.has_next() then out.append(", ") end
    end

    out.push(']')
    consume out

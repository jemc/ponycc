use peg = "peg"

type _L is peg.L
type _R is peg.R

class PonyLexer
  let parser: peg.Parser val = recover
    let digit = _R('0', '9')
    let digits = digit * digit.many()
    let bin = _R('0', '1')
    let hex = digit / _R('a', 'f') / _R('A', 'F')
    let alpha = _R('a', 'z') / _R('A', 'Z')
    
    let eol_comment = _L("//") * (not _L("\n") * peg.Unicode).many()
    let eol_item = eol_comment
    
    let inline_comment = peg.Forward
    inline_comment() =
        _L("/*")
      * ((not _L("/*") * not _L("*/") * peg.Unicode) / inline_comment).many()
      * _L("*/")
    
    let string1_char =
        _L("\\\"") / _L("\\\\") / _L("\\f") / _L("\\n") / _L("\\r") / _L("\\t")
      / _L("\\b") / (_L("\\x") * hex * hex) / (_L("\\u") * hex * hex * hex * hex)
      / (not _L("\"") * not _L("\\") * peg.Unicode)
    let string1_literal =
      (_L("\"") * string1_char.many() * _L("\""))
    
    let string3_literal =
        _L("\"\"\"") * (not _L("\"\"\"") * peg.Unicode).many() * _L("\"\"\"")
    
    let string_literal = (string3_literal / string1_literal).term(Tk[LitString])
    
    let char_char =
        _L("\\'") / _L("\\\\") / _L("\\f") / _L("\\n") /  _L("\\r") / _L("\\t")
      / _L("\\b") / (_L("\\x") * hex * hex) / (_L("\\u") * hex * hex * hex * hex)
      / (not _L("'") * not _L("\\") * peg.Unicode)
    let char_literal =
      (_L("'") * char_char * _L("'")).term(Tk[LitCharacter])
    
    let float_literal =
      (digits * (
        (_L(".") * digits * (_L("e") / _L("E")) * digits)
      / ((_L(".") / _L("e") / _L("E")) * digits)
      )).term(Tk[LitFloat])
    
    let int_literal =
      (
        ((_L("0x") / _L("0X")) * hex * hex.many())
      / ((_L("0b") / _L("0B")) * bin * bin.many())
      / digits
      ).term(Tk[LitInteger])
    
    let ident_start = alpha / _L("_")
    let ident_char = ident_start / digit / _L("'")
    let ident = (ident_start * ident_char.many()).term(Tk[Id])
    
    let lexicon = _Lexicon
    let keyword = lexicon.keywords * (not ident_char)
    let symbol = lexicon.symbols
    let newline_symbol = lexicon.newline_symbols
    
    let normal_item =
        inline_comment
      / string_literal
      / char_literal
      / float_literal
      / int_literal
      / keyword
      / symbol
      / ident
    
    let s = (_L(" ") / _L("\t") / _L("\r")).many()
    
    let line =
        s * newline_symbol.opt()
      * (s * not eol_item * normal_item).many()
      * (s * eol_item.opt())
      * s
    
    (line * _L("\n").term(Tk[NewLine])).many() * line
  end
  
  fun apply(string: String, path: String = ""): (Array[_Token] iso^ | USize) =>
    (let i, let p) = parser.parse(peg.Source.from_string(string, path))
    
    match p
    | let ast: peg.AST => if i == string.size() then _flatten(ast) else i end
    else i
    end
  
  fun tag _flatten(
    ast: peg.AST,
    array': Array[_Token] iso = recover Array[_Token] end)
    : Array[_Token] iso^
  =>
    var array: Array[_Token] iso = consume array'
    for child in ast.children.values() do
      array =
        match child
        | let ast': peg.AST => _flatten(ast', consume array)
        | let token: peg.Token =>
          match token.label() | let tk: TkAny =>
            let source     = Source(token.source.content, token.source.path)
            let source_pos = SourcePos(source, token.offset, token.length)
            (consume array).>push((tk, source_pos))
          else
            consume array
          end
        else
          consume array
        end
    end
    consume array

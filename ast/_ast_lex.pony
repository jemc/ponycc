
use "collections"

primitive _ASTLexemeLParen
primitive _ASTLexemeRParen
primitive _ASTLexemeLBracket
primitive _ASTLexemeRBracket
primitive _ASTLexemeString
primitive _ASTLexemeTerm
primitive _ASTLexemeEOF

type _ASTLexemeKind is
  (_ASTLexemeLParen
  |_ASTLexemeRParen
  |_ASTLexemeLBracket
  |_ASTLexemeRBracket
  |_ASTLexemeString
  |_ASTLexemeTerm
  |_ASTLexemeEOF
  )

class _ASTLexeme
  let kind: _ASTLexemeKind
  let source: ReadSeq[U8] val
  let start: USize
  var finish: USize
  
  new create(kind': _ASTLexemeKind, source': ReadSeq[U8] val, start': USize) =>
    kind = kind'; source = source'; start = start'; finish = start' + 1
  
  fun content(): _ReadSeqSlice[U8] =>
    _ReadSeqSlice[U8](source, start, finish)
  
  fun string(): String =>
    let size = finish - start
    let output = recover trn String(size) end
    var i = start
    try while i < finish do
      output.push(source(i))
    i = i + 1 end end
    consume output

primitive _ASTLex
  fun apply(source: ReadSeq[U8] val, pos': USize = 0): List[_ASTLexeme] =>
    let tokens = List[_ASTLexeme]
    var pos = pos'
    var last_term_pos: (USize | None) = None
    
    try while true do
      match source(pos)
      | ' ' | '\t' | '\r' | '\n' => None
      | '(' => tokens.push(_ASTLexeme(_ASTLexemeLParen, source, pos))
      | ')' => tokens.push(_ASTLexeme(_ASTLexemeRParen, source, pos))
      | '[' => tokens.push(_ASTLexeme(_ASTLexemeLBracket, source, pos))
      | ']' => tokens.push(_ASTLexeme(_ASTLexemeRBracket, source, pos))
      else
        if (source(pos) == '"')
        and (source(pos + 1) == '"')
        and (source(pos + 2) == '"') then
          pos = _triple_string(tokens, source, pos + 3)
        else
          if try ((last_term_pos as USize) + 1) == pos else false end
          then _extend_token(tokens, pos + 1)
          else tokens.push(_ASTLexeme(_ASTLexemeTerm, source, pos))
          end
          last_term_pos = pos
        end
      end
      pos = pos + 1
    end end
    
    tokens.push(_ASTLexeme(_ASTLexemeEOF, source, pos))
    
    tokens
  
  fun _extend_token(tokens: List[_ASTLexeme], pos: USize) =>
    try tokens.tail()().finish = pos end
  
  fun _triple_string(
    tokens: List[_ASTLexeme], source: ReadSeq[U8] val, pos': USize
  ): USize =>
    var pos = pos'
    
    tokens.push(_ASTLexeme(_ASTLexemeString, source, pos))
    var quote_count: USize = 0
    
    try while true do
      if source(pos) == '"' then
        quote_count = quote_count + 1
      elseif quote_count < 3 then
        quote_count = 0
      else
        _extend_token(tokens, pos - 3)
        break
      end
      pos = pos + 1
    end end
    
    pos - 1

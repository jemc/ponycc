
use "collections"

class val ASTParseError
  let message: String
  let _source: ReadSeq[U8] val
  let _offset: USize
  
  new val create(
    message': String = "", source': ReadSeq[U8] val = "", offset': USize = 0
  ) =>
    message = message'
    _source = source'
    _offset = offset'

class ASTParse
  var _iter: Iterator[_ASTLexeme] = Array[_ASTLexeme].values()
  var _last_error: ASTParseError = ASTParseError
  
  fun ref apply(input: ReadSeq[U8] val): (AST | ASTParseError) =>
    _iter = _ASTLex(input).values()
    try
      let ast = _parse_ast()
      _expect_kind(_iter.next(), _ASTLexemeEOF, "part of an AST expression")
      ast
    else
      _last_error
    end
  
  fun ref _expect_failed(token: _ASTLexeme, msg: String): _ASTLexeme ? =>
    _last_error = ASTParseError("expected " + msg, token.source, token.start)
    error
  
  fun ref _expect_kind(
    token: _ASTLexeme, kind: _ASTLexemeKind, msg: String
  ): _ASTLexeme ? =>
    if not (token.kind is kind) then _expect_failed(token, msg) end
    token
  
  fun tag _decode_uint(input: String): U128 ? =>
    var result: U128 = 0
    for c in input.values() do
      if (c < '0') or (c > '9') then error end
      result = (result * 10) + (c.u128() - '0')
    end
    result
  
  fun tag _decode_int(input: String): (U128 | I128) ? =>
    if input(0) == '-' then
      _decode_uint(input.substring(1, ISize.max_value())).i128() * -1
    else
      _decode_uint(input)
    end
  
  fun tag _decode_float(input: String): F64 ? =>
    let parts = input.split(".", 2)
    if parts.size() != 2 then error end
    
    let int_part = _decode_int(parts(0)).f64()
    let dec_part = _decode_uint(parts(1)).f64()
    
    int_part + (dec_part / F64(10).pow(parts(1).size().f64()))
  
  fun ref _parse_ast(seen_start: Bool = false): AST ? =>
    if not seen_start then
      _expect_kind(_iter.next(), _ASTLexemeLParen,
        "opening parenthesis of an AST expression")
    end
    
    let ast: AST trn = AST
    
    var name =
      _expect_kind(_iter.next(), _ASTLexemeTerm,
        "name term in an AST expression").string()
    
    if ":scope" == name.substring(-6, ISize.max_value()) then
      name = name.substring(0, -6)
      ast.is_scope = true
    end
    
    if name == "id" then
      ast.kind = TkId
      ast.value =
        _expect_kind(_iter.next(), _ASTLexemeTerm,
          "ID term in AST expression of kind TkId").string()
      
      _expect_kind(_iter.next(), _ASTLexemeRParen,
        "closing parenthesis of an AST expression of kind TkId")
      
      return consume ast
    end
    
    ast.kind = try _TkUtil.find_by_name(name) else TkNone end
    
    for token in _iter do
      let content = token.string()
      match token.kind
      | _ASTLexemeRParen => break
      | _ASTLexemeLParen => ast.push_child(_parse_ast(true))
      | _ASTLexemeString => ast.push_child(AST(TkString, content))
      | _ASTLexemeTerm =>
        try      ast.push_child(AST(TkFloat, _decode_float(content)))
        else try ast.push_child(AST(TkInt,   _decode_int(content)))
        else try ast.push_child(AST(_TkUtil.find_by_name(content)))
        else _expect_failed(token, "a known term in an AST expression")
        end end end
      else _expect_failed(token, "part of an AST expression")
      end
    end
    
    consume ast

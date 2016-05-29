
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
  
  fun show_in_line(): String =>
    (var i, var j) = (_offset, _offset)
    while '\n' != try _source(i) else '\n' end do i = i - 1 end
    while '\n' != try _source(j) else '\n' end do j = j + 1 end
    
    let output = recover trn String end
    output.append(_ReadSeqSlice[U8](_source, i + 1, j))
    output.push('\n')
    for x in Range(i + 1, _offset) do output.push(' ') end
    output.push('^')
    consume output

class ASTParse
  var _iter: Iterator[_ASTLexeme] = Array[_ASTLexeme].values()
  var _last_error: ASTParseError = ASTParseError
  
  fun ref apply(input: ReadSeq[U8] val): (AST | ASTParseError) =>
    _iter = _ASTLex(input).values()
    try
      let ast = _parse_ast()
      _expect_kind(_iter.next(), _ASTLexemeEOF, "the end of the AST input")
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
  
  fun tag _decode_uint(input: ReadSeq[U8] val): U128 ? =>
    var result: U128 = 0
    for c in input.values() do
      if (c < '0') or (c > '9') then error end
      result = (result * 10) + (c.u128() - '0')
    end
    result
  
  fun tag _decode_int(input: ReadSeq[U8] val): (U128 | I128) ? =>
    if input(0) == '-' then
      _decode_uint(_ReadSeqSlice[U8](input, 1, input.size())).i128() * -1
    else
      _decode_uint(input)
    end
  
  fun tag _decode_float(input: ReadSeq[U8] val): F64 ? =>
    var dot: (USize | None) = None
    var i: USize = 0
    for byte in input.values() do
      if byte == '.' then dot = i end
    i = i + 1 end
    
    let int_part_s = _ReadSeqSlice[U8](input, 0, dot as USize)
    let dec_part_s = _ReadSeqSlice[U8](input, (dot as USize) + 1, input.size())
    
    let int_part = _decode_int(int_part_s).f64()
    let dec_part = _decode_uint(dec_part_s).f64()
    
    int_part + (dec_part / F64(10).pow(dec_part_s.size().f64()))
  
  fun ref _parse_ast(seen_start: Bool = false, bracket: Bool = false): AST ? =>
    if not seen_start then
      if bracket then
        _expect_kind(_iter.next(), _ASTLexemeLBracket,
          "opening bracket of an AST type expression")
      else
        _expect_kind(_iter.next(), _ASTLexemeLParen,
          "opening parenthesis of an AST expression")
      end
    end
    
    let ast: AST trn = AST
    
    let first = _iter.next()
    match first.kind
    | _ASTLexemeString => return _parse_rest_string_with_type(first)
    | _ASTLexemeLParen => return _parse_rest_id_with_type(first)
    end
    
    var name =
      _expect_kind(first, _ASTLexemeTerm,
        "name term in an AST expression").content()
    
    if name.slice(name.size() - 6, name.size()) == ":scope" then
      name = name.slice(0, name.size() - 6)
      ast.is_scope = true
    end
    
    if name == "id" then
      ast.kind = TkId
      ast.value =
        _expect_kind(_iter.next(), _ASTLexemeTerm,
          "ID term in AST expression of kind TkId").string()
      
      if bracket then
        _expect_kind(_iter.next(), _ASTLexemeRBracket,
          "closing bracket of an AST type expression of kind TkId")
      else
        _expect_kind(_iter.next(), _ASTLexemeRParen,
          "closing parenthesis of an AST expression of kind TkId")
      end
      
      return consume ast
    end
    
    ast.kind = try _TkUtil._find_by_name_seq(name) else TkNone end
    
    for token in _iter do
      match token.kind
      | _ASTLexemeString => ast.push_child(AST(TkString, token.string()))
      | _ASTLexemeLParen => ast.push_child(_parse_ast(true, false))
      | _ASTLexemeRParen =>
        if not bracket then break
        else _expect_failed(token, "no closing parenthesis in this context")
        end
      | _ASTLexemeLBracket => ast.expr_type = _parse_ast(true, true)
      | _ASTLexemeRBracket =>
        if bracket then break
        else _expect_failed(token, "no closing bracket in this context")
        end
      | _ASTLexemeTerm =>
        let content = token.content()
        try      ast.push_child(AST(TkFloat, _decode_float(content)))
        else try ast.push_child(AST(TkInt,   _decode_int(content)))
        else try ast.push_child(AST(_TkUtil._find_by_name_seq(content)))
        else _expect_failed(token, "a known term in an AST expression")
        end end end
      else _expect_failed(token, "part of an AST expression")
      end
    end
    
    consume ast
  
  fun ref _parse_rest_string_with_type(first_token: _ASTLexeme): AST ? =>
    _expect_kind(first_token, _ASTLexemeString,
      "string AST expression with type")
    
    let ast: AST trn = AST(TkString, first_token.string())
    
    ast.expr_type = _parse_ast(false, true)
    
    _expect_kind(_iter.next(), _ASTLexemeRParen,
      "closing parenthesis of a string AST expression with type")
    
    consume ast
  
  fun ref _parse_rest_id_with_type(first_token: _ASTLexeme): AST ? =>
    _expect_kind(first_token, _ASTLexemeLParen,
      "opening parenthesis of an AST expression of kind TkId with type")
    
    let name = _expect_kind(_iter.next(), _ASTLexemeTerm,
      "name term in an AST expression of kind TkId")
    if name.content() != "id" then _expect_failed(name, "name term of id") end
    
    let ast: AST trn = AST(TkId)
    ast.value =
      _expect_kind(_iter.next(), _ASTLexemeTerm,
        "ID term in AST expression of kind TkId").string()
    
    _expect_kind(_iter.next(), _ASTLexemeRParen,
      "closing parenthesis of an AST expression of kind TkId with type")
    
    ast.expr_type = _parse_ast(false, true)
    
    _expect_kind(_iter.next(), _ASTLexemeRParen,
      "closing parenthesis of an AST expression")
    
    consume ast

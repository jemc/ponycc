
primitive ASTShow
  fun apply(ast: AST, wrap_width: USize = 80, indent: String = "",
    bracket: Bool = false): String
  =>
    let kind_string = _kind_string(ast)
    
    if (ast.children.size() == 0) and (ast.expr_type is None) then
      return indent + kind_string
    end
    
    let opener = if bracket then "[" else "(" end
    let closer = if bracket then "]" else ")" end
    
    // Try outputting on one line.
    var output = opener + kind_string
    for child in ast.children.values() do
      output = output + " " + apply(child, wrap_width)
    end
    match ast.expr_type | let t: AST =>
      output = output + " " + apply(t, wrap_width, "", true)
    end
    output = output + closer
    
    // If the output is too long, then print on multiple lines.
    if (indent.size() + output.size()) > wrap_width then
      output = opener + kind_string
      for child in ast.children.values() do
        output = output + "\n" + apply(child, wrap_width, indent + "  ")
      end
      match ast.expr_type | let t: AST =>
        output = output + "\n" + apply(t, wrap_width, indent + "  ", true)
      end
      output = output + "\n" + indent + closer
    end
    
    indent + output
  
  fun _kind_string(ast: AST): String =>
    match ast.kind
    | TkId     => try "(id " + (ast.value as String) + ")"    else "???" end
    | TkString => try "\"" + _esc(ast.value as String) + "\"" else "???" end
    | TkFloat  => try (ast.value as F64).string()             else "???" end
    | TkInt    => try (ast.value as (I128 | U128)).string()   else "???" end
    else
      var kind_string = try ast.kind.show() else "???" end
      
      if ast.is_scope then kind_string = kind_string + ":scope" end
      
      kind_string
    end
  
  fun _esc(string: String): String =>
    // Count characters that will need to be escaped.
    var escapes: USize = 0
    try
      var i: USize = 0
      while true do
        match string(i = i + 1) | '"' | '\\' | '\0' =>
          escapes = escapes + 1
        end
      end
    end
    
    // If no characters need to be escaped, we don't need a new string.
    if escapes == 0 then return string end
    
    // Create a new string and copy the appropriate characters, one at a time.
    let output = recover trn String(string.size() + escapes) end
    try
      var j: USize = 0
      while true do
        match string(j = j + 1)
        | '"'       => output.append("\\\"")
        | '\\'      => output.append("\\\\")
        | '\0'      => output.append("\\0")
        | let c: U8 => output.push(c)
        end
      end
    end
    consume output

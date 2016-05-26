
primitive ASTShow
  fun apply(ast: AST, wrap_width: USize = 80, indent: String = ""): String =>
    indent +
    match ast.kind
    | TkId     => try "(id " + (ast.value as String) + ")"    else "???" end
    | TkString => try "\"" + _esc(ast.value as String) + "\"" else "???" end
    | TkFloat  => try (ast.value as F64).string()             else "???" end
    | TkInt    => try (ast.value as (I128 | U128)).string()   else "???" end
    else
      var kind_string = try ast.kind.show() else "???" end
      
      if ast.is_scope then kind_string = kind_string + ":scope" end
      
      if ast.children.size() == 0 then
        kind_string
      else
        // Try outputting on one line.
        var output = "(" + kind_string
        for child in ast.children.values() do
          output = output + " " + apply(child, wrap_width)
        end
        output = output + ")"
        
        // If the output is too long, then print on multiple lines.
        if (indent.size() + output.size()) > wrap_width then
          output = "(" + kind_string
          for child in ast.children.values() do
            output = output + "\n" + apply(child, wrap_width, indent + "  ")
          end
          output = output + "\n" + indent + ")"
        end
        
        output
      end
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

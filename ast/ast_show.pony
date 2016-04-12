
primitive ASTShow
  fun apply(ast: AST, wrap_width: USize = 80, indent: String = ""): String =>
    indent +
    match ast.kind
    | TkId     => try "(id " + (ast.value as String) + ")"        else "???" end
    | TkString => try "\"\"\"" + (ast.value as String) + "\"\"\"" else "???" end
    | TkFloat  => try (ast.value as F64).string()                 else "???" end
    | TkInt    => try (ast.value as (I128 | U128)).string()       else "???" end
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

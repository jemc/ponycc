
use peg = "peg"
use "files"
use "inspect"

use "../ast"
use "../parser"

actor Main
  new create(env: Env) =>
    try
      let auth = env.root as AmbientAuth
      let path = env.args(1)
      let file = OpenFile(FilePath(auth, path)) as File
      let content: String = file.read_string(file.size())
      
      env.out.print(path)
      env.out.print(content)
      
      let lexer = PonyLexer
      match lexer(content, path)
      | let tokens: Array[(TkAny, SourcePosAny)] val =>
        // env.out.print(tokens.size().string())
        // for token in tokens.values() do
        //   env.out.print(token.label().text())
        // end
        // env.out.print("...")
        
        match PonyParser(tokens.values()).parse()
        | let tree: TkTree =>
          try
            Inspect.out(tree.to_ast(
              {(tk: TkAny, s: String, a: (AST | None)) =>
                env.out.print("Failed to build " + tk.string())
                env.out.print("  " + s)
                env.out.print("  > " + a.string())
              } ref))
          else
            env.out.print("Failed to build TkTree into an AST")
          end
        else
          env.out.print("Failed to parse tokens into a TkTree")
        end
      | let idx: USize =>
        env.out.print("Syntax error at idx: " + idx.string())
      end
    else
      env.out.print("An error occurred opening the example file for parsing.")
    end

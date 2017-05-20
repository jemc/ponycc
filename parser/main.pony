
use peg = "peg"
use "files"
use "inspect"

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
      | let tokens: Array[_Token] val =>
        // env.out.print(tokens.size().string())
        // for token in tokens.values() do
        //   env.out.print(token.label().text())
        // end
        // env.out.print("...")
        
        match PonyParser(tokens.values()).parse()
        | let tree: TkTree => Inspect.out(tree)
        end
      | let idx: USize =>
        env.out.print("Syntax error at idx: " + idx.string())
      end
    else
      env.out.print("An error occurred opening the example file for parsing.")
    end

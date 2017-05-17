
use peg = "peg"
use "inspect"

actor Main
  new create(env: Env) =>
    let lexer = PonyLexer
    let content =
      """
      use "package"
      use @ffi_decl[I32]()
      trait T
      class C
      """
    
    match lexer(content, "(test)")
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

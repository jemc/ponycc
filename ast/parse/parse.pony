
use ".."

class val Parse
  let _lexer: _Lexer = _Lexer
  
  new val create() => None
  
  fun apply[A: AST = Module](
    source: Source,
    err: {(String, SourcePosAny)} = {(s: String, p: SourcePosAny) => None } ref)
    : A ?
  =>
    match _lexer(source)
    | let tokens: Array[(TkAny, SourcePosAny)] val =>
      let parser = _Parser(tokens.values())
      match parser.parse()
      | let tree: TkTree =>
        let ast = tree.to_ast(err)
        match ast
        | let a: A => return a
        else
          err("Expected to parse an AST of type " + ASTInfo.name[A]() + ", "
            + "but got " + tree.tk.string(), tree.pos)
        end
      else
        err("Syntax error", parser.token._2)
      end
    | let err_idx: USize =>
      err("Unknown syntax", SourcePos(source, err_idx, 1))
    end
    
    error

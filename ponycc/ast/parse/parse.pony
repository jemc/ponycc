
use ".."

class val Parse
  let _lexer: _Lexer = _Lexer
  
  new val create() => None
  
  fun apply[A: AST = Module](
    source: Source,
    errs: Array[(String, SourcePosAny)] = [])
    : A ?
  =>
    match _lexer(source)
    | let tokens: Array[(TkAny, SourcePosAny)] val =>
      let parser = _Parser(tokens.values(), errs)
      match parser.parse()
      | let tree: TkTree =>
        let ast = tree.to_ast(errs)?
        match ast
        | let a: A => return a
        else
          errs.push(("Expected to parse an AST of type " + ASTInfo.name[A]()
            + ", but got " + tree.tk.string(), tree.pos))
        end
      else
        if errs.size() == 0 then
          errs.push(("Unspecified syntax error", parser.token._2))
        end
      end
    | let err_idx: USize =>
      errs.push(("Unknown syntax", SourcePos(source, err_idx, 1)))
    end
    
    error

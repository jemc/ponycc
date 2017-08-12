
actor Main
  new create(env: Env) =>
    match try env.args(1)? else "" end
    | "ast"    => let g = ASTGen;    ASTDefs(g);    env.out.print(g.string())
    | "parser" => let g = ParserGen; ParserDefs(g); env.out.print(g.string())
    | ""       => abort(env, "missing expected 'ast' or 'parser' argument")
    else          abort(env, "imvalid argument - expected 'ast' or 'parser'")
    end
  
  fun ref abort(env: Env, msg: String) =>
    env.err.print(msg)
    @pony_exitcode[None](I32(1))

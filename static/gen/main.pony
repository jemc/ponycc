
actor Main
  new create(env: Env) =>
    let g = ASTGen
    ASTDefs(g)
    env.out.print(g.string())

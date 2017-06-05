
use "collections"

class ASTGen
  let defs:   List[ASTGenDef]            = defs.create()
  let unions: Map[String, Set[String]] = unions.create()
  
  new ref create() => None
  
  fun ref def(n: String): ASTGenDefFixed =>
    ASTGenDefFixed(this, n)
  
  fun ref def_wrap(n: String, t: String): ASTGenDefWrap =>
    ASTGenDefWrap(this, n, t)
  
  fun ref def_lexeme(n: String): ASTGenDefLexeme =>
    ASTGenDefLexeme(this, n)
  
  fun string(): String =>
    let g: CodeGen = CodeGen
    
    // Use some persistent collections.
    g.line("use coll = \"collections/persistent\"")
    g.line()
    
    // Declare the AST trait
    g.line("trait val AST")
    g.push_indent()
    g.line("fun val pos(): SourcePosAny")
    g.line("fun val string(): String iso^")
    g.block(
      """
      new from_iter(
        iter: Iterator[(AST | None)],
        pos': SourcePosAny = SourcePosNone,
        errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
      """)
    g.pop_indent()
    g.line()
    
    // Declare the ASTInfo primitive
    g.line("primitive ASTInfo")
    g.push_indent()
    g.line("fun name[A: (AST | None)](): String =>")
    g.push_indent()
    g.line("iftype A <: None then \"x\"")
    for d in defs.values() do
      g.line("elseif A <: " + d.name() + " then \"" + d.name() + "\"")
    end
    g.line("else \"???\"")
    g.line("end")
    g.pop_indent()
    g.pop_indent()
    g.line()
    
    // Declare each type union.
    for (name, types) in unions.pairs() do
    //   g.line("type " + name + " is (")
    //   let iter = types.values()
    //   for t in iter do
    //     g.add(t)
    //     if iter.has_next() then g.add(" | ") end
    //   end
    //   g.add(")")
      g.line("trait val " + name + " is AST") // TODO: use union instead
      g.line()
    end
    
    // Declare each class def.
    for d in defs.values() do
      d.code_gen(g)
    end
    
    g.string()
  
  fun ref _add_to_union(u: String, m: String) =>
    try  unions(u).set(m)
    else unions(u) = Set[String].>set(m)
    end


use "collections"

class ASTGen
  let defs:   List[ASTGenDef]               = defs.create()
  let unions: Map[String, SetIs[ASTGenDef]] = unions.create()
  
  new ref create() => None
  
  fun ref def(n: String): ASTGenDefFixed =>
    ASTGenDefFixed(this, n)
  
  fun ref def_wrap(n: String, t: String, p: String): ASTGenDefWrap =>
    ASTGenDefWrap(this, n, t, p)
  
  fun ref def_lexeme(n: String): ASTGenDefLexeme =>
    ASTGenDefLexeme(this, n)
  
  fun ref def_actor(n: String): ASTGenDefActor =>
    ASTGenDefActor(this, n)
  
  fun string(): String =>
    let g: CodeGen = CodeGen
    
    // Use some persistent collections.
    g.line("use coll = \"collections/persistent\"")
    g.line()
    
    // Declare the AST trait
    g.line("trait val AST")
    g.push_indent()
    g.line("fun val size(): USize")
    g.line("fun val apply(idx: USize): (AST | None)?")
    g.line("fun val values(): Iterator[(AST | None)]^ =>")
    g.line("  object is Iterator[(AST | None)]")
    g.line("    let ast: AST = this")
    g.line("    var idx: USize = 0")
    g.line("    fun has_next(): Bool => idx < ast.size()")
    g.line("    fun ref next(): (AST | None)? => ast(idx = idx + 1)?")
    g.line("  end")
    g.line("fun val pairs(): Iterator[(USize, (AST | None))]^ =>")
    g.line("  object is Iterator[(USize, (AST | None))]")
    g.line("    let ast: AST = this")
    g.line("    var idx: USize = 0")
    g.line("    fun has_next(): Bool => idx < ast.size()")
    g.line("    fun ref next(): (USize, (AST | None))? => (idx, ast(idx = idx + 1)?)")
    g.line("  end")
    g.line("fun val attach[A: Any val](a: A): AST")
    g.line("fun val find_attached[A: Any val](): A?")
    g.line("fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val)")
    g.line("fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)?")
    g.line("fun val with_replaced_child(child': AST, replace': (AST | None)): AST")
    g.line("fun val pos(): SourcePosAny")
    g.line("fun string(): String iso^")
    g.block(
      """
      new from_iter(
        iter: Iterator[(AST | None)],
        pos': SourcePosAny = SourcePosNone,
        errs: Array[(String, SourcePosAny)] = [])?
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
    for (name, union_defs) in unions.pairs() do
    //   g.line("type " + name + " is (")
    //   let iter = union_defs.values()
    //   for t in iter do
    //     g.add(t)
    //     if iter.has_next() then g.add(" | ") end
    //   end
    //   g.add(")")
      
      g.line("trait val " + name + " is AST") // TODO: use union instead
      g.push_indent()
      
      // Determine which fields are common among all types.
      let common_fields = Map[String, String]
      let union_iter = union_defs.values()
      for union_def in union_iter do
        match union_def | let def_fixed: ASTGenDefFixed box =>
          for (field_name, field_type, _) in def_fixed.fields.values() do
            common_fields(field_name) = field_type
          end
          break // stop after processing just the first ASTGenDefFixed
        end
      end
      for union_def in union_iter do
        match union_def | let def_fixed: ASTGenDefFixed box =>
          // This snapshot is needed because we can't remove elements from the
          // map while iterating over it - the iterator will bug out.
          let common_fields_snapshot =
            Array[(String, String)].>concat(common_fields.pairs())
          
          for (field_name, field_type) in common_fields_snapshot.values() do
            if not
              def_fixed.fields.contains((field_name, field_type, ""),
                {(l, r) => (l._1 == r._1) and (l._2 == r._2) })
            then
              try common_fields.remove(field_name)? end
            end
          end
        end
      end
      
      // Define getter and setter trait methods for all common fields.
      for (field_name, field_type) in common_fields.pairs() do
        g.line("fun val " + field_name + "(): " + field_type)
      end
      for (field_name, field_type) in common_fields.pairs() do
        g.line("fun val with_" + field_name + "(")
        g.add(field_name + "': " + field_type + "): " + name)
      end
      
      g.pop_indent()
      g.line()
    end
    
    // Declare each class def.
    for d in defs.values() do
      d.code_gen(g)
    end
    
    g.string()
  
  fun ref _add_to_union(u: String, d: ASTGenDef) =>
    try  unions(u)?.set(d)
    else unions(u) = SetIs[ASTGenDef].>set(d)
    end

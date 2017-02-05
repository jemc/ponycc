
use "collections"

class ASTGen
  let defs:   List[_Def]              = defs.create()
  let unions: Map[String, List[_Def]] = unions.create()
  
  new ref create() => None
  
  fun ref def(name: String): _Def =>
    let d = _Def(this, name)
    defs.push(d)
    d
  
  fun string(): String =>
    let g: CodeGen = CodeGen
    
    // Declare each type union.
    for (name, types) in unions.pairs() do
      g.line("type " + name + " is (")
      let iter = types.values()
      for t in iter do
        g.add(t.name)
        if iter.has_next() then g.add(" | ") end
      end
      g.add(")")
      g.line()
    end
    
    // Declare each class def.
    for d in defs.values() do
      d.code_gen(g)
    end
    
    g.string()

class _Def
  let _gen: ASTGen
  let name: String
  
  let fields: List[(String, String)] = fields.create()
  
  var _todo:     Bool = false
  var _is_scope: Bool = false
  var _has_type: Bool = false
  
  new create(g: ASTGen, n: String) => (_gen, name) = (g, n)
  
  fun ref has(n: String, t: String) => fields.push((n, t))
  
  fun ref todo()     => _todo     = true
  fun ref is_scope() => _is_scope = true
  fun ref has_type() => _has_type = true
  
  fun ref in_union(n: String) =>
    try  _gen.unions(n).push(this)
    else _gen.unions(n) = List[_Def].>push(this)
    end
  
  fun code_gen(g: CodeGen) =>
    g.line("class " + name)
    if _todo then g.add(" // TODO") end
    g.push_indent()
    
    // Declare all fields.
    for (field_name, field_type) in fields.values() do
      g.line("var _" + field_name + ": " + field_type)
    end
    if fields.size() > 0 then g.line() end
    
    // Declare a constructor that initializes all fields from parameters.
    g.line("new create(")
    var iter = fields.values()
    g.push_indent()
    for (field_name, field_type) in iter do
      g.line(field_name + "': " + field_type)
      if iter.has_next() then g.add(",") end
    end
    g.add(")")
    g.pop_indent()
    if fields.size() == 0 then
      g.add(" => None")
    else
      g.line("=>")
      g.push_indent()
      for (field_name, field_type) in fields.values() do
        g.line("_" + field_name + " = " + field_name + "'")
      end
      g.pop_indent()
    end
    if fields.size() > 0 then g.line() end
    
    // Declare getter methods for all fields.
    for (field_name, field_type) in fields.values() do
      g.line("fun " + field_name + "(): this->" + field_type + " => ")
      g.add("_" + field_name)
    end
    if fields.size() > 0 then g.line() end
    
    // Declare setter methods for all fields.
    for (field_name, field_type) in fields.values() do
      g.line("fun ref set_" + field_name + "(")
      g.add(field_name + "': " + field_type + ") => ")
      g.add("_" + field_name + " = consume " + field_name + "'")
    end
    
    g.pop_indent()
    g.line()

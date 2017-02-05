
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
    let g = CodeGen
    
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
      g.line("class " + d.name)
      g.push_indent()
      
      // Declare all the fields that are specific to this def.
      for (field_name, field_type) in d.fields.values() do
        g.line("var _" + field_name + ": " + field_type)
      end
      
      // Declare a constructor that initializes all fields from parameters.
      g.line("new create(")
      var iter = d.fields.values()
      g.push_indent()
      for (field_name, field_type) in iter do
        g.line(field_name + "': " + field_type)
        if iter.has_next() then g.add(",") end
      end
      g.add(")")
      g.pop_indent()
      if d.fields.size() == 0 then
        g.add(" => None")
      else
        g.line("=>")
        g.push_indent()
        for (field_name, field_type) in d.fields.values() do
          g.line("_" + field_name + " = " + field_name + "'")
        end
        g.pop_indent()
      end
      
      g.pop_indent()
      g.line()
    end
    
    g.string()

class _Def
  let gen: ASTGen
  let name: String
  
  let fields: List[(String, String)] = fields.create()
  
  var _todo:     Bool = false
  var _is_scope: Bool = false
  var _has_type: Bool = false
  
  new create(g: ASTGen, n: String) => (gen, name) = (g, n)
  
  fun ref has(n: String, t: String) => fields.push((n, t))
  
  fun ref todo()     => _todo     = true
  fun ref is_scope() => _is_scope = true
  fun ref has_type() => _has_type = true
  
  fun ref in_union(n: String) =>
    try  gen.unions(n).push(this)
    else gen.unions(n) = List[_Def].>push(this)
    end

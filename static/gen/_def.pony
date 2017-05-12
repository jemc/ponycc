
use "collections"

trait _Def
  fun name(): String
  fun code_gen(g: CodeGen)

class _DefFixed is _Def
  let _gen: ASTGen
  let _name: String
  
  let fields: List[(String, String, String)] = fields.create()
  
  var _todo:       Bool = false
  var _with_scope: Bool = false
  var _with_type:  Bool = false
  
  new create(g: ASTGen, n: String) =>
    (_gen, _name) = (g, n)
    _gen.defs.push(this)
  
  fun ref has(n: String, t: String, d: String = "") => fields.push((n, t, d))
  
  fun ref todo()       => _todo       = true
  fun ref with_scope() => _with_scope = true
  fun ref with_type()  => _with_type  = true
  
  fun ref in_union(n: String, n2: String = "") =>
    _gen._add_to_union(n, _name)
    if n2.size() > 0 then _gen._add_to_union(n2, n) end
  
  fun name(): String => _name
  
  fun code_gen(g: CodeGen) =>
    g.line("class " + _name + " is AST")
    if _todo then g.add(" // TODO") end
    g.push_indent()
    
    // Declare all fields.
    for (field_name, field_type, _) in fields.values() do
      g.line("var _" + field_name + ": " + field_type)
    end
    if fields.size() > 0 then g.line() end
    
    // Declare a constructor that initializes all fields from parameters.
    g.line("new create(")
    var iter = fields.values()
    g.push_indent()
    for (field_name, field_type, field_default) in iter do
      g.line(field_name + "': " + field_type)
      if field_default.size() > 0 then g.add(" = " + field_default) end
      if iter.has_next() then g.add(",") end
    end
    g.add(")")
    g.pop_indent()
    if fields.size() == 0 then
      g.add(" => None")
    else
      g.line("=>")
      g.push_indent()
      for (field_name, field_type, _) in fields.values() do
        g.line("_" + field_name + " = " + field_name + "'")
      end
      g.pop_indent()
    end
    if fields.size() > 0 then g.line() end
    
    // Declare getter methods for all fields.
    for (field_name, field_type, _) in fields.values() do
      g.line("fun " + field_name + "(): this->" + field_type + " => ")
      g.add("_" + field_name)
    end
    if fields.size() > 0 then g.line() end
    
    // Declare setter methods for all fields.
    for (field_name, field_type, field_default) in fields.values() do
      g.line("fun ref set_" + field_name + "(")
      g.add(field_name + "': " + field_type)
      if field_default.size() > 0 then g.add(" = " + field_default) end
      g.add(") => ")
      g.add("_" + field_name + " = consume " + field_name + "'")
    end
    if fields.size() > 0 then g.line() end
    
    // Declare a string method to print itself.
    g.line("fun string(): String iso^ =>")
    g.push_indent()
    g.line("let s = recover iso String end")
    g.line("s.append(\"" + _name + "\")")
    if fields.size() > 0 then
      g.line("s.push('(')")
      iter = fields.values()
      for (field_name, field_type, _) in iter do
        if field_type.at("Array[", 0) then
          g.line("let " + field_name + "_iter = _" + field_name + ".values()")
          g.line("for v in " + field_name + "_iter do")
          g.line("  s.append(v.string())")
          g.line("  if " + field_name + "_iter.has_next() then")
          g.line("    s.>push(',').push(' ')")
          g.line("  end")
          g.line("end")
          if iter.has_next() then g.line("s.>push(',').push(' ')") end
        else
          g.line("s.>append(_" + field_name + ".string())")
          if iter.has_next() then g.add(".>push(',').push(' ')") end
        end
      end
      g.line("s.push(')')")
    end
    g.line("consume s")
    g.pop_indent()
    
    g.pop_indent()
    g.line()

class _DefWrap is _Def
  let _gen: ASTGen
  let _name: String
  let value_type: String
  
  new create(g: ASTGen, n: String, t: String) =>
    (_gen, _name, value_type) = (g, n, t)
    _gen.defs.push(this)
  
  fun ref in_union(n: String, n2: String = "") =>
    _gen._add_to_union(n, _name)
    if n2.size() > 0 then _gen._add_to_union(n2, n) end
  
  fun name(): String => _name
  
  fun code_gen(g: CodeGen) =>
    g.line("class " + _name)
    g.push_indent()
    
    // Declare the value field.
    g.line("var _value: " + value_type)
    
    // Declare a constructor that initializes the value field from a parameter.
    g.line("new create(value': " + value_type + ") => _value = value'")
    
    // Declare a getter method for the value field.
    g.line("fun value(): " + value_type + " => _value")
    
    // Declare a setter methods for the value field.
    g.line("fun ref set_value(value': " + value_type + ") => _value = value'")
    
    // Declare a string method to print itself.
    g.line("fun string(): String iso^ =>")
    g.push_indent()
    g.line("recover")
    g.push_indent()
    g.line("String.>append(\"" + _name + "(\")")
    g.add(".>append(_value.string()).>push(')')")
    g.pop_indent()
    g.line("end")
    g.pop_indent()
    
    g.pop_indent()
    g.line()

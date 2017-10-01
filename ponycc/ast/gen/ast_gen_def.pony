
trait ASTGenDef
  fun name(): String
  fun code_gen(g: CodeGen)

class ASTGenDefFixed is ASTGenDef
  let _gen: ASTGen
  let _name: String
  let _traits: Array[String] = [] // TODO: remove and use unions only
  
  let fields: Array[(String, String, String)] = []
  
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
    _traits.push(n)
    if n2.size() > 0 then _traits.push(n2) end
    _gen._add_to_union(n, this)
    if n2.size() > 0 then _gen._add_to_union(n2, this) end
  
  fun name(): String => _name
  
  fun code_gen(g: CodeGen) =>
    g.line("class val " + _name + " is ")
    if _traits.size() == 0 then
      g.add("AST")
    else
      g.add("(AST")
      for t in _traits.values() do g.add(" & " + t) end
      g.add(")")
    end
    if _todo then g.add(" // TODO") end
    g.push_indent()
    
    // Declare common fields.
    g.line("let _attachments: (coll.Vec[Any val] | None)")
    g.line()
    
    // Declare all fields.
    for (field_name, field_type, _) in fields.values() do
      g.line("let _" + field_name + ": " + field_type)
    end
    if fields.size() > 0 then g.line() end
    
    // Declare a constructor that initializes all fields from parameters.
    g.line("new val create(")
    var iter = fields.values()
    g.push_indent()
    for (field_name, field_type, field_default) in iter do
      g.line(field_name + "': ")
      if field_type.at("coll.Vec[") then
        let elem_type: String = field_type.substring(9, -1)
        g.add("(" + field_type + " | Array[" + elem_type + "] val)")
      else
        g.add(field_type)
      end
      if field_default.size() > 0 then g.add(" = " + field_default) end
      g.add(",")
    end
    g.line("attachments': (coll.Vec[Any val] | None) = None)")
    g.pop_indent()
    g.line("=>")
    g.push_indent()
    g.add("_attachments = attachments'")
    for (field_name, field_type, _) in fields.values() do
      g.line("_" + field_name + " = ")
      if field_type.at("coll.Vec[") then
        let elem_type: String = field_type.substring(9, -1)
        g.push_indent()
        g.line("match " + field_name + "'")
        g.line("| let v: coll.Vec[" + elem_type + "] => v")
        g.line("| let s: Array[" + elem_type + "] val => ")
        g.add("coll.Vec[" + elem_type + "].concat(s.values())")
        g.line("end")
        g.pop_indent()
      else
        g.add(field_name + "'")
      end
    end
    g.pop_indent()
    g.line()
    
    // Declare a constructor that initializes all fields from an iterator.
    g.block(
      """
      new from_iter(
        iter: Iterator[(AST | None)],
        pos': SourcePosAny = SourcePosNone,
        errs: Array[(String, SourcePosAny)] = [])?
      =>""")
    g.push_indent()
    g.line("_attachments = coll.Vec[Any val].push(pos')")
    
    var iter_next = "iter.next()?"
    for (field_name, field_type, field_default) in fields.values() do
      if field_type.at("coll.Vec[") then
        let elem_type: String = field_type.substring(9, -1)
        g.line("var " + field_name + "' = " + field_type)
        g.line("var " + field_name + "_next' = ")
        if iter_next != "iter.next()?" then
          g.add(iter_next)
        else
          g.add("try iter.next()? else None end")
        end
        g.line("while true do")
        g.push_indent()
        g.line("try " + field_name + "' = ")
        g.add(field_name + "'.push(" + field_name + "_next'")
        g.add(" as " + elem_type + ") else break end")
        g.line("try " + field_name + "_next' = iter.next()?")
        g.add(" else " + field_name + "_next' = None; break end")
        g.pop_indent()
        g.line("end")
        iter_next = field_name + "_next'"
      else
        g.line("let " + field_name + "': (AST | None) =")
        if iter_next != "iter.next()?" then
          g.add(" " + iter_next)
        else
          if field_default.size() > 0 then
            g.add(" try iter.next()? else " + field_default + " end")
          else
            g.push_indent()
            g.line("try iter.next()?")
            g.line("else errs.push((\"" + _name + " missing required field: " + field_name + "\", pos')); error")
            g.line("end")
            g.pop_indent()
          end
        end
        iter_next = "iter.next()?"
      end
    end
    
    if iter_next != "iter.next()?" then
      g.line("if " + iter_next + " isnt None then")
      g.push_indent()
      g.line("let extra' = " + iter_next)
      g.line("errs.push((\"" + _name + " got unexpected extra field: \" + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error")
      g.pop_indent()
      g.line("end")
    else
      g.line("if")
      g.push_indent()
      g.line("try")
      g.push_indent()
      g.line("let extra' = " + iter_next)
      g.line("errs.push((\"" + _name + " got unexpected extra field: \" + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true")
      g.pop_indent()
      g.line("else false")
      g.line("end")
      g.pop_indent()
      g.line("then error end")
    end
    
    if fields.size() > 0 then g.line() end
    for (field_name, field_type, field_default) in fields.values() do
      g.line("_" + field_name + " =")
      if field_type.at("coll.Vec[") then
        g.add(" " + field_name + "'")
      else
        g.push_indent()
        g.line("try " + field_name + "' as " + field_type)
        g.line("else errs.push((\"" + _name + " got incompatible field: " + field_name)
        g.add("\", try (" + field_name + "' as AST).pos() else SourcePosNone end)); error")
        g.line("end")
        g.pop_indent()
      end
    end
    
    g.pop_indent()
    g.line()
    
    // Declare common helpers.
    g.line("fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[" + _name + "](consume c, this)")
    g.line("fun val each(fn: {ref ((AST | None))} ref) =>")
    g.push_indent()
    for (field_name, field_type, _) in fields.values() do
      if field_type.at("coll.Vec[") then
        g.line("for x in _" + field_name + ".values() do fn(x) end")
      else
        g.line("fn(_" + field_name + ")")
      end
    else
      g.add(" None")
    end
    g.pop_indent()
    
    // Declare common getters and setters.
    g.line("fun val pos(): SourcePosAny")
    g.add(" => try find_attached[SourcePosAny]()? else SourcePosNone end")
    g.line("fun val with_pos(pos': SourcePosAny): " + _name)
    g.add(" => attach[SourcePosAny](pos')")
    g.line()
    
    g.line("fun val attach[A: Any val](a: A): " + _name)
    g.add(" => create(")
    for (field_name, _, _) in fields.values() do
      g.add("_" + field_name + ", ")
    end
    g.add("(try _attachments as coll.Vec[Any val] else coll.Vec[Any val] end).push(a))")
    g.line()
    
    g.line("fun val find_attached[A: Any val](): A? =>")
    g.push_indent()
    g.line("for a in (_attachments as coll.Vec[Any val]).values() do")
    g.push_indent()
    g.line("try return a as A end")
    g.pop_indent()
    g.line("end")
    g.line("error")
    g.pop_indent()
    
    // Declare getter methods for all fields.
    for (field_name, field_type, _) in fields.values() do
      g.line("fun val " + field_name + "(): " + field_type + " => ")
      g.add("_" + field_name)
    end
    if fields.size() > 0 then g.line() end
    
    // Declare setter methods for all fields.
    for (field_name, field_type, _) in fields.values() do
      g.line("fun val with_" + field_name + "(")
      g.add(field_name + "': " + field_type + "): " + _name)
      g.add(" => create(")
      for (other_field_name, _, _) in fields.values() do
        if other_field_name == field_name then
          g.add(field_name + "', ")
        else
          g.add("_" + other_field_name + ", ")
        end
      end
      g.add("_attachments)")
    end
    if fields.size() > 0 then g.line() end
    
    // Declare push methods for list fields.
    for (field_name, field_type, _) in fields.values() do
      if field_type.at("coll.Vec[", 0) then
        let elem_type: String = field_type.substring(9, -1)
        
        g.line("fun val with_" + field_name + "_push(")
        g.add("x: val->" + elem_type + "): " + _name)
        g.add(" => with_" + field_name)
        g.add("(_" + field_name + ".push(x))")
        g.line()
      end
    end
    
    // Declare a method that supports lookup of children by String name and
    // optional USize index number (only supported by coll.Vec fields).
    // Any invalid lookup is an error.
    g.line("fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>")
    if fields.size() == 0 then
      g.add(" error")
    else
      g.push_indent()
      g.line("match child'")
      for (field_name, field_type, _) in fields.values() do
        g.line("| \"" + field_name + "\" => _" + field_name)
        if field_type.at("coll.Vec[", 0) then
          g.add("(index')?")
        end
      end
      g.line("else error")
      g.line("end")
      g.pop_indent()
    end
    g.line()
    
    // Declare a method that finds (first occurrence of) the given child and
    // replaces it with the given new child, returning the resulting AST.
    // If the given child was not found, the original AST is returned.
    // If the given child is an incompatible type, the original AST is returned.
    // TODO: use a while loop to replace more than just the first occurrence.
    g.line("fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>")
    g.push_indent()
    g.line("if child' is replace' then return this end")
    g.line("try")
    g.push_indent()
    for (field_name, field_type, _) in fields.values() do
      if field_type.at("coll.Vec[", 0) then
        let elem_type: String = field_type.substring(9, -1)
        g.line("try")
        g.push_indent()
        g.line("let i = _" + field_name + ".find(child' as " + elem_type + ")?")
        g.line("return create(")
        for (other_field_name, _, _) in fields.values() do
          if other_field_name == field_name then
            g.add("_" + field_name + ".update(i, replace' as " + elem_type + ")?, ")
          else
            g.add("_" + other_field_name + ", ")
          end
        end
        g.add("_attachments)")
        g.pop_indent()
        g.line("end")
      else
        g.line("if child' is _" + field_name + " then")
        g.push_indent()
        g.line("return create(")
        for (other_field_name, _, _) in fields.values() do
          if other_field_name == field_name then
            g.add("replace' as " + field_type + ", ")
          else
            g.add("_" + other_field_name + ", ")
          end
        end
        g.add("_attachments)")
        g.pop_indent()
        g.line("end")
      end
    end
    g.line("error")
    g.pop_indent()
    g.line("else this")
    g.line("end")
    g.pop_indent()
    g.line()
    
    // Declare a string method to print itself.
    g.line("fun string(): String iso^ =>")
    g.push_indent()
    g.line("let s = recover iso String end")
    g.line("s.append(\"" + _name + "\")")
    if fields.size() > 0 then
      g.line("s.push('(')")
      iter = fields.values()
      for (field_name, field_type, _) in iter do
        if field_type.at("coll.Vec[", 0) then
          g.line("s.push('[')")
          g.line("for (i, v) in _" + field_name + ".pairs() do")
          g.push_indent()
          g.line("if i > 0 then s.>push(';').push(' ') end")
          g.line("s.append(v.string())")
          g.pop_indent()
          g.line("end")
          g.line("s.push(']')")
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

class ASTGenDefWrap is ASTGenDef
  let _gen: ASTGen
  let _name: String
  let _value_type: String
  let _value_parser: String
  let _traits: Array[String] = [] // TODO: remove and use unions only
  
  new create(g: ASTGen, n: String, t: String, p: String) =>
    (_gen, _name, _value_type, _value_parser) = (g, n, t, p)
    _gen.defs.push(this)
  
  fun ref in_union(n: String, n2: String = "") =>
    _traits.push(n)
    if n2.size() > 0 then _traits.push(n2) end
    _gen._add_to_union(n, this)
    if n2.size() > 0 then _gen._add_to_union(n2, this) end
  
  fun name(): String => _name
  
  fun code_gen(g: CodeGen) =>
    g.line("class val " + _name + " is ")
    if _traits.size() == 0 then
      g.add("AST")
    else
      g.add("(AST")
      for t in _traits.values() do g.add(" & " + t) end
      g.add(")")
    end
    g.push_indent()
    
    // Declare common fields.
    g.line("let _attachments: (coll.Vec[Any val] | None)")
    
    // Declare the value field.
    g.line("let _value: " + _value_type)
    
    // Declare a constructor that initializes the value and pos from parameters.
    g.line("new val create(value': " + _value_type + ", ")
    g.add("attachments': (coll.Vec[Any val] | None) = None) =>")
    g.push_indent()
    g.line("_value = value'")
    g.line("_attachments = attachments'")
    g.pop_indent()
    g.line()
    
    g.block(
      """
      new from_iter(
        iter: Iterator[(AST | None)],
        pos': SourcePosAny = SourcePosNone,
        errs: Array[(String, SourcePosAny)] = [])?
      =>""")
    g.push_indent()
    g.line("_attachments = coll.Vec[Any val].push(pos')")
    g.line("_value =")
    g.push_indent()
    g.line("try")
    g.push_indent()
    g.line(_value_parser + "(pos')?")
    g.pop_indent()
    g.line("else")
    g.push_indent()
    g.line("errs.push((\"" + _name + " failed to parse value\", pos')); true")
    g.line("error")
    g.pop_indent()
    g.line("end")
    g.pop_indent()
    g.line()
    g.line("if")
    g.push_indent()
    g.line("try")
    g.push_indent()
    g.line("let extra' = iter.next()?")
    g.line("errs.push((\"" + _name + " got unexpected extra field: \" + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true")
    g.pop_indent()
    g.line("else false")
    g.line("end")
    g.pop_indent()
    g.line("then error end")
    g.pop_indent()
    g.line()
    
    // Declare common helpers.
    g.line("fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[" + _name + "](consume c, this)")
    g.line("fun val each(fn: {ref ((AST | None))} ref) => None")
    g.line("fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error")
    g.line("fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this")
    
    // Declare common getters and setters.
    g.line("fun val pos(): SourcePosAny")
    g.add(" => try find_attached[SourcePosAny]()? else SourcePosNone end")
    g.line("fun val with_pos(pos': SourcePosAny): " + _name)
    g.add(" => attach[SourcePosAny](pos')")
    g.line()
    
    g.line("fun val attach[A: Any val](a: A): " + _name)
    g.add(" => create(_value, (try _attachments as coll.Vec[Any val] else coll.Vec[Any val] end).push(a))")
    
    g.line("fun val find_attached[A: Any val](): A? =>")
    g.push_indent()
    g.line("for a in (_attachments as coll.Vec[Any val]).values() do")
    g.push_indent()
    g.line("try return a as A end")
    g.pop_indent()
    g.line("end")
    g.line("error")
    g.pop_indent()
    g.line()
    
    // Declare a getter method for the value field.
    g.line("fun val value(): " + _value_type + " => _value")
    
    // Declare a setter methods for the value field.
    g.line("fun val with_value(value': " + _value_type + "): " + _name + " => create(value', _attachments)")
    
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

class ASTGenDefLexeme is ASTGenDef
  let _gen: ASTGen
  let _name: String
  let _traits: Array[String] = [] // TODO: remove and use unions only
  
  new create(g: ASTGen, n: String) =>
    (_gen, _name) = (g, n)
    _gen.defs.push(this)
  
  fun ref in_union(n: String, n2: String = "") =>
    _traits.push(n)
    if n2.size() > 0 then _traits.push(n2) end
    _gen._add_to_union(n, this)
    if n2.size() > 0 then _gen._add_to_union(n2, this) end
  
  fun name(): String => _name
  
  fun code_gen(g: CodeGen) =>
    g.line("class val " + _name + " is ")
    if _traits.size() == 0 then
      g.add("AST")
    else
      g.add("(AST")
      for t in _traits.values() do g.add(" & " + t) end
      g.add(")")
    end
    g.push_indent()
    
    // Declare a constructor that does nothing.
    g.line("new val create() => None")
    
    // Declare a constructor that accepts an iterator but always errors.
    g.block(
      """
      new from_iter(
        iter: Iterator[(AST | None)],
        pos': SourcePosAny = SourcePosNone,
        errs: Array[(String, SourcePosAny)] = [])?
      =>""")
    g.push_indent()
    g.line("errs.push((\"" + _name + " is a lexeme-only type append should never be built\", pos')); error")
    g.pop_indent()
    g.line()
    
    // Declare common helpers.
    g.line("fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[" + _name + "](consume c, this)")
    g.line("fun val each(fn: {ref ((AST | None))} ref) => None")
    g.line("fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error")
    g.line("fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this")
    
    // Declare common getters and setters.
    g.line("fun val pos(): SourcePosAny => SourcePosNone")
    g.line("fun val with_pos(pos': SourcePosAny): " + _name + " => create()")
    g.line()
    g.line("fun val attach[A: Any val](a: A): AST => this")
    g.line("fun val find_attached[A: Any val](): A? => error")
    g.line()
    
    // Declare a string method to print itself.
    g.line("fun string(): String iso^ =>")
    g.push_indent()
    g.line("recover String.>append(\"" + _name + "\") end")
    g.pop_indent()
    
    g.pop_indent()
    g.line()

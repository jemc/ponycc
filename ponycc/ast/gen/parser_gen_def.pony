
use "collections"

class ParserGenDef
  // TODO: docs for all DSL methods
  let _gen: ParserGen
  let _name: String
  let _pieces: Array[{(CodeGen)}] = Array[{(CodeGen)}]
  
  var _print_inline: Bool = false // TODO
  var _annotate:     Bool = false // TODO
  var _builder:      String = "_BuildDefault"
  
  var _restart: (None | Array[String]) = None
  
  new create(g: ParserGen, s: String) =>
    (_gen, _name) = (g, s)
    _gen.defs.push(this)
  
  fun code_gen(g: CodeGen) =>
    g.line("fun ref _parse_" + _name + "(rule_desc: String): (_RuleResult, _Build) =>")
    g.push_indent()
    g.line("let state = _RuleState(\"" + _name + "\", rule_desc)")
    g.line("var res: _RuleResult = None")
    g.line("var found: Bool = false")
    for piece in _pieces.values() do piece(g) end
    g.line()
    g.line("(_complete(state), " + _builder + ")")
    g.pop_indent()
    g.line()
  
  fun ref print_inline() => _print_inline = true // TODO
  fun ref annotate()     => _annotate     = true // TODO
  
  fun ref builder(builder': String) => _builder = builder'
  
  fun ref tree(s: String) =>
    _pieces.push({(g: CodeGen) =>
      g.line("state.add_deferrable_ast((" + s + ", _current_pos()))")
    } ref)
  
  fun ref restart(a: Array[String]) => _restart      = a    // TODO
  
  fun ref _rule_set(desc: String, array: Array[String], default_tk: String = "None") =>
    _pieces.push({(g: CodeGen) =>
      if _gen.debug then
        g.line()
        let opt = if default_tk is "None" then "required" else "optional" end
        // g.line("Debug(\"Rule " + _name + ": Looking for " + opt + " rule(s) '" + desc + "'\")")
      end
      g.line()
      g.line("state.default_tk = " + default_tk)
      g.line("found = false")
      g.line("res =")
      g.push_indent()
      g.line("while true do")
      g.push_indent()
      for rule in array.values() do
        g.line("match _parse_" + rule + "(\"" + desc + "\")")
        g.line("| (_RuleParseError, _) => break _handle_error(state)")
        g.line("| (let tree: (TkTree | None), let build: _Build) =>")
        g.push_indent()
        g.line("found = true")
        g.line("last_matched = \"" + desc + "\"")
        g.line("break _handle_found(state, tree, build)")
        g.pop_indent()
        g.line("end")
        g.line()
      end
      g.line("found = false")
      g.line("break _handle_not_found(state, \"" + desc + "\", false)")
      g.pop_indent()
      g.line("end")
      g.pop_indent()
      g.line("if res isnt None then return (res, " + _builder + ") end")
    })
  
  fun ref rule(desc: String, array: Array[String]) =>
    _rule_set(desc, array)
  
  fun ref opt_rule(desc: String, array: Array[String],
    default: String = "Tk[None]")
  =>
    _rule_set(desc, array, default)
  
  fun ref opt_no_dflt_rule(desc: String, array: Array[String]) =>
    _rule_set(desc, array, "Tk[EOF]")
  
  fun ref _token_set(
    desc': String,
    array: Array[String],
    default_tk: String = "None",
    make_ast: Bool = true,
    terminating: Bool = false)
  =>
    let desc =
      if desc' == "None" then
        try array(0)? else "Tk[EOF]" end + ".desc()"
      else
        "\"" + desc' + "\""
      end
    
    _pieces.push({(g: CodeGen) =>
      if _gen.debug then
        g.line()
        let opt = if default_tk is "None" then "required" else "optional" end
        // g.line("Debug(\"Rule " + _name + ": Looking for " + opt + " rule(s) '\" + " + desc + " + \"'. Found \" + _current_tk().string())")
      end
      g.line()
      g.line("state.default_tk = " + default_tk)
      g.line("found = false")
      
      // Skip past any occurrences of NewLine, unless that's one of our set.
      if not array.contains("Tk[NewLine]", {(a: String, b: String): Bool => a == b }) then
        g.line("while _current_tk() is Tk[NewLine] do _consume_token() end")
      end
      
      g.line("res =")
      g.push_indent()
      g.line("match _current_tk()")
      for (idx, tk) in array.pairs() do
        g.add(" | ")
        g.add(tk)
      end
      g.add(" =>")
      g.push_indent()
      // if _gen.debug then g.line("Debug(\"Compatible\")") end
      g.line("found = true")
      g.line("last_matched = " + desc)
      if make_ast then
        g.line("_handle_found(state, TkTree(_consume_token()), _BuildDefault)")
      else
        g.line("_handle_found(state, (_consume_token(); None), _BuildDefault)")
      end
      g.pop_indent()
      g.line("else")
      g.push_indent()
      // if _gen.debug then g.line("Debug(\"Not compatible\")") end
      g.line("found = false")
      g.line("_handle_not_found(state, " + desc + ", " + terminating.string() + ")")
      g.pop_indent()
      g.line("end")
      g.pop_indent()
      g.line("if res isnt None then return (res, " + _builder + ") end")
    })
  
  fun ref token(desc: String, array: Array[String]) =>
    _token_set(desc, array)
  
  fun ref opt_token(desc: String, array: Array[String]) =>
    _token_set(desc, array, "Tk[None]")
  
  fun ref opt_no_dflt_token(desc: String, array: Array[String]) =>
    _token_set(desc, array, "Tk[EOF]")
  
  fun ref not_token(desc: String, array: Array[String]) =>
    _token_set("None", array, "Tk[EOF]" where make_ast = false)
    _pieces.push({(g: CodeGen) =>
      g.line("if found then return (_RuleNotFound, " + _builder + ") end")
    } ref)
  
  fun ref if_token_then_rule(tk: String, desc: String, array: Array[String]) =>
    _token_set("None", [tk], "Tk[EOF]" where make_ast = false)
    _pieces.push({(g: CodeGen) => g.line("if found then"); g.push_indent() } ref)
    _rule_set(desc, array)
    _pieces.push({(g: CodeGen) => g.pop_indent(); g.line("end") } ref)
  
  fun ref if_token_then_rule_else_none(tk: String, desc: String,
    array: Array[String])
  =>
    _token_set("None", [tk], "Tk[None]" where make_ast = false)
    _pieces.push({(g: CodeGen) => g.line("if found then"); g.push_indent() } ref)
    _rule_set(desc, array)
    _pieces.push({(g: CodeGen) => g.pop_indent(); g.line("end") } ref)
  
  fun ref while_token_do_rule(tk: String, desc: String, array: Array[String]) =>
    _pieces.push({(g: CodeGen) => g.line("while true do"); g.push_indent() } ref)
    _token_set("None", [tk], "Tk[EOF]" where make_ast = false)
    _pieces.push({(g: CodeGen) => g.line("if not found then break end") } ref)
    _rule_set(desc, array)
    _pieces.push({(g: CodeGen) => g.pop_indent(); g.line("end") } ref)
  
  fun ref if_token_then_token(tk: String, desc: String, array: Array[String]) =>
    _token_set("None", [tk], "Tk[EOF]" where make_ast = false)
    _pieces.push({(g: CodeGen) => g.line("if found then"); g.push_indent() } ref)
    _token_set(desc, array)
    _pieces.push({(g: CodeGen) => g.pop_indent(); g.line("end") } ref)
  
  fun ref while_token_do_token(tk: String, desc: String, array: Array[String]) =>
    _pieces.push({(g: CodeGen) => g.line("while true do"); g.push_indent() } ref)
    _token_set("None", [tk], "Tk[EOF]" where make_ast = false)
    _pieces.push({(g: CodeGen) => g.line("if not found then break end") } ref)
    _token_set(desc, array)
    _pieces.push({(g: CodeGen) => g.pop_indent(); g.line("end") } ref)
  
  fun ref seq(desc: String, array: Array[String]) =>
    _pieces.push({(g: CodeGen) => g.line("while true do"); g.push_indent() } ref)
    _rule_set(desc, array, "Tk[EOF]")
    _pieces.push({(g: CodeGen) => g.line("if not found then break end") } ref)
    _pieces.push({(g: CodeGen) => g.pop_indent(); g.line("end") } ref)
  
  fun ref skip(desc: String, array: Array[String]) =>
    _token_set(desc, array where make_ast = false)
  
  fun ref terminate(desc: String, array: Array[String]) =>
    _token_set(desc, array where make_ast = false, terminating = true)
  
  fun ref map_tk(array: Array[(String, String)]) =>
    _pieces.push({(g: CodeGen) =>
      g.line("match state.tree | let tree: TkTree =>")
      g.push_indent()
      g.line("match tree.tk")
      for (src, dest) in array.values() do
        g.line("| " + src + " => tree.tk = " + dest)
      end
      g.line("end")
      g.pop_indent()
      g.line("end")
    } ref)
  
  fun ref reorder_children(array: Array[USize]) =>
    _pieces.push({(g: CodeGen) =>
      g.line("match state.tree | let tree: TkTree =>")
      g.push_indent()
      for i in Range(0, array.size()) do
        g.line("let child_" + i.string())
        g.add(" = try tree.children.shift()? else TkTree(token) end")
      end
      for i in array.values() do
        g.line("tree.children.push(child_" + i.string() + ")")
      end
      g.pop_indent()
      g.line("end")
    } ref)
  
  fun ref rotate_left_children(count: USize) =>
    _pieces.push({(g: CodeGen) =>
      g.line("match state.tree | let tree: TkTree =>")
      g.push_indent()
      for i in Range(0, count) do
        g.line("try tree.children.push(tree.children.shift()?) end")
      end
      g.pop_indent()
      g.line("end")
    } ref)

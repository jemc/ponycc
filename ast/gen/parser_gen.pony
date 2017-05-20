
use "collections"

class ParserGen
  embed defs: Array[ParserGenDef] = Array[ParserGenDef]
  let debug: Bool = true
  
  new ref create() => None
  
  fun ref def(s: String): ParserGenDef => ParserGenDef(this, s)
  
  fun string(): String =>
    let g: CodeGen = CodeGen
    
    g.line("use peg = \"peg\"")
    if debug then g.line("use \"debug\"") end
    g.line()
    g.line("class PonyParser")
    g.push_indent()
    
    // Declare parser state fields.
    g.block(
      """
      let tokens: Iterator[_Token]
      var token: _Token
      let errors: Array[String] = Array[String]
      var failed: Bool = false
      var last_matched: String = ""
      
      new create(tokens': Iterator[_Token]) =>
        tokens = tokens'
        token =
          try tokens.next()
          else (Tk[EOF], SourcePosNone)
          end
      
      fun ref parse(): (TkTree | None) =>
        let expected = "class, actor, primitive or trait" // TODO: get this from where?
        match _parse_root(expected)._1
        | _RuleNotFound => _syntax_error(expected, None, ""); None
        | let tree: TkTree => if failed then None else tree end
        else None
        end
      
      fun _current_tk(): TkAny =>
        try token._1 as TkAny else Tk[EOF] end
      
      fun _current_pos(): SourcePosAny =>
        token._2
      
      fun ref _consume_token(): _Token =>
        let new_token =
          try tokens.next()
          else (Tk[EOF], token._2)
          end
        
        token = new_token
      
      fun ref _ditch_restart(state: _RuleState): _RuleResult =>
        // Debug("Rule " + state.fn_name + ": Attempting recovery") // TODO: conditional compile
        
        while true do
          let tk = _current_tk()
          
          for restart_tk in state.restart.values() do
            if tk is restart_tk then
              // Debug("  recovered with " + tk.string()) // TODO: conditional compile
              return _RuleRestart
            end
          end
          
          // Debug("  ignoring " + tk.string()) // TODO: conditional compile
          
          _consume_token()
        end
        
        _RuleRestart // unreachable
      
      fun ref _handle_error(state: _RuleState): _RuleResult =>
        state.tree = None
        failed = true
        
        if state.restart.size() == 0 then
          // Debug("Rule " + state.fn_name + ": Propagate failure") // TODO: conditional compile
          return _RuleParseError
        end
        
        _ditch_restart(state)
      
      fun _handle_found(state: _RuleState, tree: (TkTree | None), build: _Build): _RuleResult =>
        if not state.matched then
          // Debug("Rule " + state.fn_name + ": Matched") // TODO: conditional compile
          
          state.matched = true
        end
        
        try state.add_tree(tree as TkTree, build) end
        
        state.default_tk = None
        None
      
      fun ref _handle_not_found(state: _RuleState, desc: String, terminating: Bool): _RuleResult =>
        if state.default_tk isnt None then
          // Optional token / sub rule not found
          if state.default_tk isnt Tk[EOF] then // Default node is specified
            let tk = try state.default_tk as TkAny else Tk[EOF] end
            state.add_deferrable_ast((tk, _current_pos()))
          end
          
          state.default_tk = None
          return None
        end
        
        // Required token / sub rule not found
        
        if not state.matched then
          // Debug("Rule " + state.fn_name + ": Not matched") // TODO: conditional compile
          
          state.tree = None
          return _RuleNotFound
        end
        
        // Rule partially matched, error
        // Debug("Rule " + state.fn_name + ": Error") // TODO: conditional compile
        
        _syntax_error(desc, state.tree, if terminating then desc else "" end)
        failed = true
        state.tree = None
        
        if state.restart.size() == 0 then
          return _RuleParseError
        else
          return _ditch_restart(state)
        end
      
      fun ref _complete(state: _RuleState): _RuleResult =>
        state.process_deferred_tree()
        
        // Debug("Rule " + state.fn_name + ": Complete") // TODO: conditional compile
        
        if state.restart.size() == 0 then return state.tree end
        
        // We have a restart point, check next token is legal
        let tk = _current_tk()
        
        // Debug("Rule " + state.fn_name + ": Check restart set for next token " + tk.string()) // TODO: conditional compile
        
        for restart_tk in state.restart.values() do
          if tk is restart_tk then
            // Debug("Rule " + state.fn_name + ": Restart check successful") // TODO: conditional compile
            return state.tree
          end
        end
        
        // Next token is not in restart set, error
        // Debug("Rule " + state.fn_name + ": Restart check error") // TODO: conditional compile
        
        _error("syntax error: unexpected token " + _current_tk().desc() + " after " + state.desc)
        
        failed = true
        _ditch_restart(state)
      
      fun ref _error(str: String, pos: (SourcePosAny | None) = None) =>
        // Debug("ERROR: " + str) // TODO: show token loc
        None
      
      fun ref _error_continue(str: String, pos: (SourcePosAny | None) = None) =>
        // Debug("ERROR_CONTINUE: " + str) // TODO: show token loc
        None
      
      fun ref _syntax_error(expected: String, tree: (TkTree | None), terminating: String) =>
        if last_matched.size() == 0 then
          _error("syntax error: no code found")
        else
          if terminating.size() == 0 then
            _error("syntax error: expected " + expected + " after " + last_matched)
          else
            _error("syntax error: unterminated " + terminating,
              try (tree as TkTree).pos else token._2 end)
            _error_continue("expected terminating " + expected + "before here")
          end
        end
      """)
    
    // Declare each rule def.
    for d in defs.values() do
      d.code_gen(g)
    end
    
    g.pop_indent()
    
    g.string()

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
  
  fun ref opt_rule(desc: String, array: Array[String]) =>
    _rule_set(desc, array, "Tk[None]")
  
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
        try array(0) else "Tk[EOF]" end + ".desc()"
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
        g.add(" = try tree.children.shift() else TkTree(token) end")
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
        g.line("try tree.children.push(tree.children.shift()) end")
      end
      g.pop_indent()
      g.line("end")
    } ref)

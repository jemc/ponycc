
class ParserGen
  embed defs: Array[ParserGenDef] = []
  let debug: Bool = true
  
  new ref create() => None
  
  fun ref def(s: String): ParserGenDef => ParserGenDef(this, s)
  
  fun string(): String =>
    let g: CodeGen = CodeGen
    
    g.line("use peg = \"peg\"")
    g.line("use \"../../ast\"")
    if debug then g.line("use \"debug\"") end
    g.line()
    g.line("class _Parser")
    g.push_indent()
    
    // TODO: Clean this up somehow.
    g.block(
      """
      let tokens: Iterator[_Token]
      let errs: Seq[(String, SourcePosAny)]
      var token: _Token
      var last_helpful_token: _Token
      let errors: Array[String] = []
      var failed: Bool = false
      var last_matched: String = ""
      
      new create(tokens': Iterator[_Token], errs': Seq[(String, SourcePosAny)]) =>
        (tokens, errs) = (tokens', errs')
        token =
          try tokens.next()?
          else (Tk[EOF], SourcePosNone)
          end
        last_helpful_token = token
      
      fun ref parse(): (TkTree | None) =>
        let expected = "class, actor, primitive or trait" // TODO: get this from where?
        match _parse_root(expected)._1
        | _RuleNotFound => _syntax_error(expected, None, ""); None
        | let tree: TkTree => if failed then None else tree end
        else None
        end
      
      fun _current_tk(): TkAny =>
        token._1
      
      fun _current_pos(): SourcePosAny =>
        token._2
      
      fun ref _consume_token(): _Token =>
        let new_token =
          try tokens.next()?
          else (Tk[EOF], token._2)
          end
        
        match new_token._1
        | Tk[NewLine] | Tk[EOF] | Tk[None] => None
        else last_helpful_token = new_token
        end
        
        token = (new_token._1, last_helpful_token._2)
      
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
        
        _error("Parse error: Unexpected token " + _current_tk().desc() + " after " + state.desc, last_helpful_token._2)
        
        failed = true
        _ditch_restart(state)
      
      fun ref _error(str: String, pos: SourcePosAny) =>
        errs.push((str, pos))
      
      fun ref _error_continue(str: String, pos: SourcePosAny) =>
        errs.push((str, pos)) // TODO: actually continue
      
      fun ref _syntax_error(expected: String, tree: (TkTree | None), terminating: String) =>
        if last_matched.size() == 0 then
          _error("Parse error: No code found", last_helpful_token._2)
        else
          if terminating.size() == 0 then
            _error("Parse error: Expected " + expected + " after " + last_matched, last_helpful_token._2)
          else
            _error("Parse error: Unterminated " + terminating,
              try (tree as TkTree).pos else last_helpful_token._2 end)
            _error_continue("Expected terminating " + expected + " before here", last_helpful_token._2)
          end
        end
      """)
    
    // Declare each rule def.
    for d in defs.values() do
      d.code_gen(g)
    end
    
    g.pop_indent()
    
    g.string()

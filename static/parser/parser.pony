use peg = "peg"
use "debug"

class PonyParser
  let tokens: Iterator[_Token]
  var token: _Token
  let errors: Array[String] = Array[String]
  var failed: Bool = false
  var last_matched: String = ""
  
  new create(tokens': Iterator[_Token]) =>
    tokens = tokens'
    token =
      try tokens.next()
      else (Tk[EOF], SourcePos(Source))
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
  
  fun _current_pos(): SourcePos =>
    token._2
  
  fun ref _consume_token(): _Token =>
    let new_token =
      try tokens.next()
      else (Tk[EOF], token._2)
      end
    
    token = new_token
  
  fun ref _ditch_restart(state: _RuleState): _RuleResult =>
    Debug("Rule " + state.fn_name + ": Attempting recovery") // TODO: conditional compile
    
    while true do
      let tk = _current_tk()
      
      for restart_tk in state.restart.values() do
        if tk is restart_tk then
          Debug("  recovered with " + tk.string()) // TODO: conditional compile
          return _RuleRestart
        end
      end
      
      Debug("  ignoring " + tk.string()) // TODO: conditional compile
      
      _consume_token()
    end
    
    _RuleRestart // unreachable
  
  fun ref _handle_error(state: _RuleState): _RuleResult =>
    state.tree = None
    failed = true
    
    if state.restart.size() == 0 then
      Debug("Rule " + state.fn_name + ": Propagate failure") // TODO: conditional compile
      return _RuleParseError
    end
    
    _ditch_restart(state)
  
  fun _handle_found(state: _RuleState, tree: (TkTree | None), build: _Build): _RuleResult =>
    if not state.matched then
      Debug("Rule " + state.fn_name + ": Matched") // TODO: conditional compile
      
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
      Debug("Rule " + state.fn_name + ": Not matched") // TODO: conditional compile
      
      state.tree = None
      return _RuleNotFound
    end
    
    // Rule partially matched, error
    Debug("Rule " + state.fn_name + ": Error") // TODO: conditional compile
    
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
    
    Debug("Rule " + state.fn_name + ": Complete") // TODO: conditional compile
    
    if state.restart.size() == 0 then return state.tree end
    
    // We have a restart point, check next token is legal
    let tk = _current_tk()
    
    Debug("Rule " + state.fn_name + ": Check restart set for next token " + tk.string()) // TODO: conditional compile
    
    for restart_tk in state.restart.values() do
      if tk is restart_tk then
        Debug("Rule " + state.fn_name + ": Restart check successful") // TODO: conditional compile
        return state.tree
      end
    end
    
    // Next token is not in restart set, error
    Debug("Rule " + state.fn_name + ": Restart check error") // TODO: conditional compile
    
    _error("syntax error: unexpected token " + _current_tk().desc() + " after " + state.desc)
    
    failed = true
    _ditch_restart(state)
  
  fun ref _error(str: String, pos: (SourcePos | None) = None) =>
    Debug("ERROR: " + str) // TODO: show token loc
  
  fun ref _error_continue(str: String, pos: (SourcePos | None) = None) =>
    Debug("ERROR_CONTINUE: " + str) // TODO: show token loc
  
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
  
  fun ref _parse_root(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("root", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule root: Looking for required rule(s) 'module'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_module("module")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "module"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "module", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_provides(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("provides", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Provides], _current_pos()))
    
    Debug("Rule provides: Looking for required rule(s) 'provided type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("provided type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "provided type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "provided type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_param(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("param", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Param], _current_pos()))
    
    Debug("Rule param: Looking for required rule(s) 'name'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_parampattern("name")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "name"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule param: Looking for optional rule(s) '" + Tk[Colon].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule param: Looking for required rule(s) 'parameter type'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_type("parameter type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "parameter type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "parameter type", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule param: Looking for optional rule(s) '" + Tk[Assign].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule param: Looking for required rule(s) 'default value'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_infix("default value")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "default value"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "default value", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_ellipsis(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ellipsis", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule ellipsis: Looking for required rule(s) '" + Tk[Ellipsis].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Ellipsis] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Ellipsis].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Ellipsis].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_literal(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("literal", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule literal: Looking for required rule(s) '" + "literal" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitTrue] | Tk[LitFalse] | Tk[LitInteger] | Tk[LitFloat] | Tk[LitString] | Tk[LitCharacter] =>
        Debug("Compatible")
        found = true
        last_matched = "literal"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "literal", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_const_expr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("const_expr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule const_expr: Looking for required rule(s) '" + Tk[Constant].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Constant] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Constant].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Constant].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule const_expr: Looking for required rule(s) 'formal argument value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_postfix("formal argument value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "formal argument value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "formal argument value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_typeargliteral(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typeargliteral", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Constant], _current_pos()))
    
    Debug("Rule typeargliteral: Looking for required rule(s) 'type argument'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_literal("type argument")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type argument"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type argument", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_typeargconst(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typeargconst", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Constant], _current_pos()))
    
    Debug("Rule typeargconst: Looking for required rule(s) 'formal argument value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_const_expr("formal argument value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "formal argument value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "formal argument value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_typearg(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typearg", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule typearg: Looking for required rule(s) 'type argument'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("type argument")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type argument"
          break _handle_found(state, tree, build)
        end
        
        match _parse_typeargliteral("type argument")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type argument"
          break _handle_found(state, tree, build)
        end
        
        match _parse_typeargconst("type argument")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type argument"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type argument", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_typeparam(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typeparam", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[TypeParam], _current_pos()))
    
    Debug("Rule typeparam: Looking for required rule(s) '" + "name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule typeparam: Looking for optional rule(s) '" + Tk[Colon].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule typeparam: Looking for required rule(s) 'type constraint'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_type("type constraint")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "type constraint"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "type constraint", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule typeparam: Looking for optional rule(s) '" + Tk[Assign].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule typeparam: Looking for required rule(s) 'default type argument'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_typearg("default type argument")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "default type argument"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "default type argument", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_params(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("params", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Params], _current_pos()))
    
    Debug("Rule params: Looking for required rule(s) 'parameter'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_param("parameter")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "parameter"
          break _handle_found(state, tree, build)
        end
        
        match _parse_ellipsis("parameter")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "parameter"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "parameter", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule params: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      Debug("Rule params: Looking for required rule(s) 'parameter'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_param("parameter")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "parameter"
            break _handle_found(state, tree, build)
          end
          
          match _parse_ellipsis("parameter")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "parameter"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "parameter", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_typeparams(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typeparams", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[TypeParams], _current_pos()))
    
    Debug("Rule typeparams: Looking for required rule(s) '" + Tk[LSquare].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LSquare] | Tk[LSquareNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LSquare].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LSquare].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule typeparams: Looking for required rule(s) 'type parameter'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_typeparam("type parameter")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type parameter"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type parameter", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule typeparams: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      Debug("Rule typeparams: Looking for required rule(s) 'type parameter'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_typeparam("type parameter")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "type parameter"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "type parameter", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule typeparams: Looking for required rule(s) '" + "type parameters" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RSquare] =>
        Debug("Compatible")
        found = true
        last_matched = "type parameters"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "type parameters", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_typeargs(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typeargs", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[TypeArgs], _current_pos()))
    
    Debug("Rule typeargs: Looking for required rule(s) '" + Tk[LSquare].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LSquare] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LSquare].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LSquare].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule typeargs: Looking for required rule(s) 'type argument'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_typearg("type argument")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type argument"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type argument", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule typeargs: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      Debug("Rule typeargs: Looking for required rule(s) 'type argument'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_typearg("type argument")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "type argument"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "type argument", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule typeargs: Looking for required rule(s) '" + "type arguments" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RSquare] =>
        Debug("Compatible")
        found = true
        last_matched = "type arguments"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "type arguments", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_cap(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("cap", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule cap: Looking for required rule(s) '" + "capability" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Iso] | Tk[Trn] | Tk[Ref] | Tk[Val] | Tk[Box] | Tk[Tag] =>
        Debug("Compatible")
        found = true
        last_matched = "capability"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_gencap(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("gencap", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule gencap: Looking for required rule(s) '" + "generic capability" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[CapRead] | Tk[CapSend] | Tk[CapShare] | Tk[CapAlias] | Tk[CapAny] =>
        Debug("Compatible")
        found = true
        last_matched = "generic capability"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "generic capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nominal(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nominal", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[NominalType], _current_pos()))
    
    Debug("Rule nominal: Looking for required rule(s) '" + "name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nominal: Looking for optional rule(s) 'type arguments'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_typeargs("type arguments")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type arguments"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type arguments", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nominal: Looking for optional rule(s) 'capability'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_cap("capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capability"
          break _handle_found(state, tree, build)
        end
        
        match _parse_gencap("capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capability"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nominal: Looking for optional rule(s) '" + Tk[Ephemeral].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Ephemeral] | Tk[Aliased] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Ephemeral].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Ephemeral].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_uniontype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("uniontype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[UnionType], _current_pos()))
    
    Debug("Rule uniontype: Looking for required rule(s) '" + Tk[Pipe].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Pipe] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Pipe].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Pipe].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    Debug("Rule uniontype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_isecttype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("isecttype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[IsectType], _current_pos()))
    
    Debug("Rule isecttype: Looking for required rule(s) '" + Tk[Ampersand].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Ampersand] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Ampersand].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Ampersand].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    Debug("Rule isecttype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_infixtype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("infixtype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule infixtype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule infixtype: Looking for optional rule(s) 'type'")
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_uniontype("type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "type"
            break _handle_found(state, tree, build)
          end
          
          match _parse_isecttype("type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "type", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_tupletype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("tupletype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule tupletype: Looking for required rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Comma] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Comma].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Comma].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    Debug("Rule tupletype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_infixtype("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    while true do
      
      Debug("Rule tupletype: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildInfix) end
      if not found then break end
      
      Debug("Rule tupletype: Looking for required rule(s) 'type'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_infixtype("type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "type", false)
        end
      if res isnt None then return (res, _BuildInfix) end
    end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_groupedtype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("groupedtype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule groupedtype: Looking for required rule(s) '" + Tk[LParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule groupedtype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_infixtype("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule groupedtype: Looking for optional rule(s) 'type'")
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      while true do
        match _parse_tupletype("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule groupedtype: Looking for required rule(s) '" + Tk[RParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_thistype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("thistype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[ThisType], _current_pos()))
    
    Debug("Rule thistype: Looking for required rule(s) '" + Tk[This].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[This] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[This].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[This].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_typelist(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typelist", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Params], _current_pos()))
    
    Debug("Rule typelist: Looking for required rule(s) 'parameter type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("parameter type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "parameter type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "parameter type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule typelist: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      Debug("Rule typelist: Looking for required rule(s) 'parameter type'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_type("parameter type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "parameter type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "parameter type", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_lambdatype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("lambdatype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[LambdaType], _current_pos()))
    
    Debug("Rule lambdatype: Looking for required rule(s) '" + Tk[LBrace].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LBrace] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LBrace].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LBrace].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdatype: Looking for optional rule(s) 'capability'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_cap("capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capability"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdatype: Looking for optional rule(s) '" + "function name" + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "function name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "function name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdatype: Looking for optional rule(s) 'type parameters'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_typeparams("type parameters")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type parameters"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type parameters", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdatype: Looking for required rule(s) '" + Tk[LParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdatype: Looking for optional rule(s) 'parameters'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_typelist("parameters")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "parameters"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "parameters", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdatype: Looking for required rule(s) '" + Tk[RParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdatype: Looking for optional rule(s) '" + Tk[Colon].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule lambdatype: Looking for required rule(s) 'return type'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_type("return type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "return type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "return type", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule lambdatype: Looking for optional rule(s) '" + Tk[Question].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Question] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Question].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Question].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdatype: Looking for required rule(s) '" + Tk[RBrace].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RBrace] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[RBrace].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[RBrace].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdatype: Looking for optional rule(s) 'capability'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_cap("capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capability"
          break _handle_found(state, tree, build)
        end
        
        match _parse_gencap("capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capability"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdatype: Looking for optional rule(s) '" + Tk[Ephemeral].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Ephemeral] | Tk[Aliased] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Ephemeral].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Ephemeral].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_atomtype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("atomtype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule atomtype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_thistype("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        match _parse_cap("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        match _parse_groupedtype("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        match _parse_nominal("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        match _parse_lambdatype("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_viewpoint(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("viewpoint", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule viewpoint: Looking for required rule(s) '" + Tk[Arrow].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Arrow] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Arrow].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Arrow].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    Debug("Rule viewpoint: Looking for required rule(s) 'viewpoint'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("viewpoint")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "viewpoint"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "viewpoint", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_type(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("type", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule type: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_atomtype("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule type: Looking for optional rule(s) 'viewpoint'")
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      while true do
        match _parse_viewpoint("viewpoint")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "viewpoint"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "viewpoint", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_namedarg(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("namedarg", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[NamedArg], _current_pos()))
    
    Debug("Rule namedarg: Looking for required rule(s) '" + "argument name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "argument name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "argument name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule namedarg: Looking for required rule(s) '" + Tk[Assign].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule namedarg: Looking for required rule(s) 'argument value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("argument value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "argument value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "argument value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_named(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("named", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[NamedArgs], _current_pos()))
    
    Debug("Rule named: Looking for required rule(s) '" + Tk[Where].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Where] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Where].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Where].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule named: Looking for required rule(s) 'named argument'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_namedarg("named argument")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "named argument"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "named argument", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule named: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      Debug("Rule named: Looking for required rule(s) 'named argument'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_namedarg("named argument")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "named argument"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "named argument", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_positional(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("positional", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Args], _current_pos()))
    
    Debug("Rule positional: Looking for required rule(s) 'argument'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("argument")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "argument"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "argument", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule positional: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      Debug("Rule positional: Looking for required rule(s) 'argument'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_rawseq("argument")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "argument"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "argument", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_annotations(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("annotations", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule annotations: Looking for required rule(s) '" + Tk[Backslash].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Backslash] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Backslash].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Backslash].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule annotations: Looking for required rule(s) '" + "annotation" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "annotation"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "annotation", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule annotations: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      Debug("Rule annotations: Looking for required rule(s) '" + "annotation" + "'. Found " + _current_tk().string())
      
      state.default_tk = None
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Id] =>
          Debug("Compatible")
          found = true
          last_matched = "annotation"
          _handle_found(state, TkTree(_consume_token()), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, "annotation", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule annotations: Looking for required rule(s) '" + "annotations" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Backslash] =>
        Debug("Compatible")
        found = true
        last_matched = "annotations"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "annotations", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_object(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("object", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule object: Looking for required rule(s) '" + Tk[Object].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Object] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Object].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Object].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule object: Looking for optional rule(s) 'capability'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_cap("capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capability"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule object: Looking for optional rule(s) '" + Tk[Is].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Is] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Is].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Is].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule object: Looking for required rule(s) 'provided type'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_provides("provided type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "provided type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "provided type", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule object: Looking for required rule(s) 'object member'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_members("object member")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "object member"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "object member", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule object: Looking for required rule(s) '" + "object literal" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "object literal"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "object literal", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_lambdacapture(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("lambdacapture", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[LambdaCapture], _current_pos()))
    
    Debug("Rule lambdacapture: Looking for required rule(s) '" + "name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdacapture: Looking for optional rule(s) '" + Tk[Colon].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule lambdacapture: Looking for required rule(s) 'capture type'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_type("capture type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "capture type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "capture type", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule lambdacapture: Looking for optional rule(s) '" + Tk[Assign].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule lambdacapture: Looking for required rule(s) 'capture value'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_infix("capture value")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "capture value"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "capture value", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_lambdacaptures(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("lambdacaptures", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[LambdaCaptures], _current_pos()))
    
    Debug("Rule lambdacaptures: Looking for required rule(s) '" + Tk[LParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambdacaptures: Looking for required rule(s) 'capture'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_lambdacapture("capture")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capture"
          break _handle_found(state, tree, build)
        end
        
        match _parse_thisliteral("capture")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capture"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "capture", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule lambdacaptures: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      Debug("Rule lambdacaptures: Looking for required rule(s) 'capture'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_lambdacapture("capture")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "capture"
            break _handle_found(state, tree, build)
          end
          
          match _parse_thisliteral("capture")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "capture"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "capture", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule lambdacaptures: Looking for required rule(s) '" + Tk[RParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_lambda(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("lambda", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Lambda], _current_pos()))
    
    Debug("Rule lambda: Looking for required rule(s) '" + Tk[LBrace].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LBrace] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LBrace].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LBrace].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for optional rule(s) 'receiver capability'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_cap("receiver capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "receiver capability"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "receiver capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for optional rule(s) '" + "function name" + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "function name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "function name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for optional rule(s) 'type parameters'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_typeparams("type parameters")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type parameters"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type parameters", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for required rule(s) '" + Tk[LParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for optional rule(s) 'parameters'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_params("parameters")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "parameters"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "parameters", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for required rule(s) '" + Tk[RParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for optional rule(s) 'captures'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_lambdacaptures("captures")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "captures"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "captures", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for optional rule(s) '" + Tk[Colon].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule lambda: Looking for required rule(s) 'return type'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_type("return type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "return type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "return type", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule lambda: Looking for optional rule(s) '" + Tk[Question].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Question] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Question].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Question].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for required rule(s) '" + Tk[DoubleArrow].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[DoubleArrow] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[DoubleArrow].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[DoubleArrow].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for required rule(s) 'lambda body'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("lambda body")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "lambda body"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "lambda body", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for required rule(s) '" + "lambda expression" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RBrace] =>
        Debug("Compatible")
        found = true
        last_matched = "lambda expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "lambda expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule lambda: Looking for optional rule(s) 'reference capability'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_cap("reference capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "reference capability"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "reference capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_arraytype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("arraytype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule arraytype: Looking for required rule(s) '" + Tk[As].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[As] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[As].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[As].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule arraytype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule arraytype: Looking for required rule(s) '" + Tk[Colon].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_array(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("array", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[LitArray], _current_pos()))
    
    Debug("Rule array: Looking for required rule(s) '" + Tk[LSquare].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LSquare] | Tk[LSquareNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LSquare].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LSquare].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule array: Looking for optional rule(s) 'element type'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_arraytype("element type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "element type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "element type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule array: Looking for required rule(s) 'array elements'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("array elements")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "array elements"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "array elements", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule array: Looking for required rule(s) '" + "array literal" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RSquare] =>
        Debug("Compatible")
        found = true
        last_matched = "array literal"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "array literal", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextarray(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextarray", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[LitArray], _current_pos()))
    
    Debug("Rule nextarray: Looking for required rule(s) '" + Tk[LSquareNew].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LSquareNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LSquareNew].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LSquareNew].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nextarray: Looking for optional rule(s) 'element type'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_arraytype("element type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "element type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "element type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nextarray: Looking for required rule(s) 'array elements'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("array elements")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "array elements"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "array elements", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nextarray: Looking for required rule(s) '" + "array literal" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RSquare] =>
        Debug("Compatible")
        found = true
        last_matched = "array literal"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "array literal", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_tuple(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("tuple", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule tuple: Looking for required rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Comma] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Comma].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Comma].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    Debug("Rule tuple: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    while true do
      
      Debug("Rule tuple: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildInfix) end
      if not found then break end
      
      Debug("Rule tuple: Looking for required rule(s) 'value'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_rawseq("value")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "value"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "value", false)
        end
      if res isnt None then return (res, _BuildInfix) end
    end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_groupedexpr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("groupedexpr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule groupedexpr: Looking for required rule(s) '" + Tk[LParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule groupedexpr: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule groupedexpr: Looking for optional rule(s) 'value'")
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      while true do
        match _parse_tuple("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule groupedexpr: Looking for required rule(s) '" + Tk[RParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextgroupedexpr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextgroupedexpr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nextgroupedexpr: Looking for required rule(s) '" + Tk[LParenNew].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParenNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParenNew].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParenNew].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nextgroupedexpr: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nextgroupedexpr: Looking for optional rule(s) 'value'")
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      while true do
        match _parse_tuple("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nextgroupedexpr: Looking for required rule(s) '" + Tk[RParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_thisliteral(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("thisliteral", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule thisliteral: Looking for required rule(s) '" + Tk[This].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[This] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[This].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[This].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_ref(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ref", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Reference], _current_pos()))
    
    Debug("Rule ref: Looking for required rule(s) '" + "name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_location(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("location", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule location: Looking for required rule(s) '" + Tk[LitLocation].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitLocation] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LitLocation].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LitLocation].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_ffi(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ffi", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule ffi: Looking for required rule(s) '" + Tk[At].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[At] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[At].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[At].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ffi: Looking for required rule(s) '" + "ffi name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] | Tk[LitString] =>
        Debug("Compatible")
        found = true
        last_matched = "ffi name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "ffi name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ffi: Looking for optional rule(s) 'return type'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_typeargs("return type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "return type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "return type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ffi: Looking for required rule(s) '" + Tk[LParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ffi: Looking for optional rule(s) 'ffi arguments'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_positional("ffi arguments")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "ffi arguments"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "ffi arguments", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ffi: Looking for optional rule(s) 'ffi arguments'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_named("ffi arguments")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "ffi arguments"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "ffi arguments", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ffi: Looking for required rule(s) '" + "ffi arguments" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = "ffi arguments"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "ffi arguments", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ffi: Looking for optional rule(s) '" + Tk[Question].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Question] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Question].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Question].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_atom(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("atom", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule atom: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_ref("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_thisliteral("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_literal("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_groupedexpr("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_array("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_object("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_lambda("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_ffi("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_location("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextatom(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextatom", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nextatom: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_ref("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_thisliteral("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_literal("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_nextgroupedexpr("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_nextarray("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_object("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_lambda("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_ffi("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_location("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_dot(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("dot", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule dot: Looking for required rule(s) '" + Tk[Dot].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Dot] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Dot].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Dot].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    Debug("Rule dot: Looking for required rule(s) '" + "member name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "member name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "member name", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_tilde(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("tilde", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule tilde: Looking for required rule(s) '" + Tk[Tilde].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Tilde] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Tilde].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Tilde].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    Debug("Rule tilde: Looking for required rule(s) '" + "method name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "method name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "method name", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_chain(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("chain", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule chain: Looking for required rule(s) '" + Tk[Chain].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Chain] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Chain].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Chain].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    Debug("Rule chain: Looking for required rule(s) '" + "method name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "method name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "method name", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_qualify(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("qualify", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Qualify], _current_pos()))
    
    Debug("Rule qualify: Looking for required rule(s) 'type arguments'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_typeargs("type arguments")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type arguments"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type arguments", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_call(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("call", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Call], _current_pos()))
    
    Debug("Rule call: Looking for required rule(s) '" + Tk[LParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule call: Looking for optional rule(s) 'argument'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_positional("argument")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "argument"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "argument", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule call: Looking for optional rule(s) 'argument'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_named("argument")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "argument"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "argument", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule call: Looking for required rule(s) '" + "call arguments" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = "call arguments"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "call arguments", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_postfix(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("postfix", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule postfix: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_atom("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule postfix: Looking for optional rule(s) 'postfix expression'")
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_dot("postfix expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "postfix expression"
            break _handle_found(state, tree, build)
          end
          
          match _parse_tilde("postfix expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "postfix expression"
            break _handle_found(state, tree, build)
          end
          
          match _parse_chain("postfix expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "postfix expression"
            break _handle_found(state, tree, build)
          end
          
          match _parse_qualify("postfix expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "postfix expression"
            break _handle_found(state, tree, build)
          end
          
          match _parse_call("postfix expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "postfix expression"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "postfix expression", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextpostfix(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextpostfix", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nextpostfix: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_nextatom("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule nextpostfix: Looking for optional rule(s) 'postfix expression'")
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_dot("postfix expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "postfix expression"
            break _handle_found(state, tree, build)
          end
          
          match _parse_tilde("postfix expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "postfix expression"
            break _handle_found(state, tree, build)
          end
          
          match _parse_chain("postfix expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "postfix expression"
            break _handle_found(state, tree, build)
          end
          
          match _parse_qualify("postfix expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "postfix expression"
            break _handle_found(state, tree, build)
          end
          
          match _parse_call("postfix expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "postfix expression"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "postfix expression", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_local(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("local", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule local: Looking for required rule(s) '" + Tk[Var].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Var] | Tk[Let] | Tk[Embed] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Var].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Var].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule local: Looking for required rule(s) '" + "variable name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "variable name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "variable name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule local: Looking for optional rule(s) '" + Tk[Colon].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule local: Looking for required rule(s) 'variable type'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_type("variable type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "variable type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "variable type", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_prefix(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("prefix", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule prefix: Looking for required rule(s) '" + "prefix" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Not] | Tk[AddressOf] | Tk[Sub] | Tk[SubUnsafe] | Tk[SubNew] | Tk[SubUnsafeNew] | Tk[DigestOf] =>
        Debug("Compatible")
        found = true
        last_matched = "prefix"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "prefix", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule prefix: Looking for required rule(s) 'expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_parampattern("expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextprefix(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextprefix", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nextprefix: Looking for required rule(s) '" + "prefix" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Not] | Tk[AddressOf] | Tk[SubNew] | Tk[SubUnsafeNew] | Tk[DigestOf] =>
        Debug("Compatible")
        found = true
        last_matched = "prefix"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "prefix", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nextprefix: Looking for required rule(s) 'expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_parampattern("expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_parampattern(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("parampattern", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule parampattern: Looking for required rule(s) 'pattern'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_prefix("pattern")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "pattern"
          break _handle_found(state, tree, build)
        end
        
        match _parse_postfix("pattern")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "pattern"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "pattern", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextparampattern(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextparampattern", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nextparampattern: Looking for required rule(s) 'pattern'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_nextprefix("pattern")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "pattern"
          break _handle_found(state, tree, build)
        end
        
        match _parse_nextpostfix("pattern")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "pattern"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "pattern", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_pattern(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("pattern", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule pattern: Looking for required rule(s) 'pattern'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_local("pattern")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "pattern"
          break _handle_found(state, tree, build)
        end
        
        match _parse_parampattern("pattern")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "pattern"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "pattern", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextpattern(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextpattern", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nextpattern: Looking for required rule(s) 'pattern'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_local("pattern")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "pattern"
          break _handle_found(state, tree, build)
        end
        
        match _parse_nextparampattern("pattern")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "pattern"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "pattern", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_idseqmulti(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("idseqmulti", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Tuple], _current_pos()))
    
    Debug("Rule idseqmulti: Looking for required rule(s) '" + Tk[LParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule idseqmulti: Looking for required rule(s) 'variable name'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_idseq_in_seq("variable name")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "variable name"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "variable name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule idseqmulti: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      Debug("Rule idseqmulti: Looking for required rule(s) 'variable name'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_idseq_in_seq("variable name")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "variable name"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "variable name", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule idseqmulti: Looking for required rule(s) '" + Tk[RParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_idseqsingle(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("idseqsingle", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Let], _current_pos()))
    
    Debug("Rule idseqsingle: Looking for required rule(s) '" + "variable name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "variable name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "variable name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    state.add_deferrable_ast((Tk[None], _current_pos()))
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_idseq_in_seq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("idseq_in_seq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[ExprSeq], _current_pos()))
    
    Debug("Rule idseq_in_seq: Looking for required rule(s) 'variable name'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_idseqsingle("variable name")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "variable name"
          break _handle_found(state, tree, build)
        end
        
        match _parse_idseqmulti("variable name")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "variable name"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "variable name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_idseq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("idseq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule idseq: Looking for required rule(s) 'variable name'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_idseqsingle("variable name")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "variable name"
          break _handle_found(state, tree, build)
        end
        
        match _parse_idseqmulti("variable name")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "variable name"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "variable name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_elseclause(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("elseclause", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule elseclause: Looking for required rule(s) '" + Tk[Else].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseclause: Looking for required rule(s) 'else value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_annotatedseq("else value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "else value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_elseif(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("elseif", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[If], _current_pos()))
    
    Debug("Rule elseif: Looking for required rule(s) '" + Tk[ElseIf].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[ElseIf] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[ElseIf].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[ElseIf].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseif: Looking for required rule(s) 'condition expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("condition expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "condition expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "condition expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseif: Looking for required rule(s) '" + Tk[Then].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseif: Looking for required rule(s) 'then value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("then value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "then value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "then value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseif: Looking for optional rule(s) 'else clause'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_elseif("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        match _parse_elseclause("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "else clause", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_cond(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("cond", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule cond: Looking for required rule(s) '" + Tk[If].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[If] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[If].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[If].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule cond: Looking for required rule(s) 'condition expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("condition expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "condition expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "condition expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule cond: Looking for required rule(s) '" + Tk[Then].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule cond: Looking for required rule(s) 'then value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("then value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "then value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "then value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule cond: Looking for optional rule(s) 'else clause'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_elseif("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        match _parse_elseclause("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "else clause", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule cond: Looking for required rule(s) '" + "if expression" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "if expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "if expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_elseifdef(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("elseifdef", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[IfDef], _current_pos()))
    
    Debug("Rule elseifdef: Looking for required rule(s) '" + Tk[ElseIf].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[ElseIf] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[ElseIf].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[ElseIf].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseifdef: Looking for required rule(s) 'condition expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_infix("condition expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "condition expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "condition expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseifdef: Looking for required rule(s) '" + Tk[Then].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseifdef: Looking for required rule(s) 'then value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("then value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "then value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "then value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseifdef: Looking for optional rule(s) 'else clause'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_elseifdef("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        match _parse_elseclause("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "else clause", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_ifdef(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ifdef", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule ifdef: Looking for required rule(s) '" + Tk[IfDef].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[IfDef] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[IfDef].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[IfDef].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ifdef: Looking for required rule(s) 'condition expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_infix("condition expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "condition expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "condition expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ifdef: Looking for required rule(s) '" + Tk[Then].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ifdef: Looking for required rule(s) 'then value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("then value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "then value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "then value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ifdef: Looking for optional rule(s) 'else clause'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_elseifdef("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        match _parse_elseclause("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "else clause", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule ifdef: Looking for required rule(s) '" + "ifdef expression" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "ifdef expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "ifdef expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_elseiftype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("elseiftype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[IfType], _current_pos()))
    
    Debug("Rule elseiftype: Looking for required rule(s) '" + Tk[ElseIf].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[ElseIf] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[ElseIf].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[ElseIf].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseiftype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseiftype: Looking for required rule(s) '" + Tk[SubType].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[SubType] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[SubType].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[SubType].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseiftype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseiftype: Looking for required rule(s) '" + Tk[Then].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseiftype: Looking for required rule(s) 'then value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("then value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "then value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "then value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule elseiftype: Looking for optional rule(s) 'else clause'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_elseiftype("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        match _parse_elseclause("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "else clause", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_iftype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("iftype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule iftype: Looking for required rule(s) '" + Tk[IfType].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[IfType] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[IfType].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[IfType].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule iftype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule iftype: Looking for required rule(s) '" + Tk[SubType].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[SubType] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[SubType].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[SubType].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule iftype: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule iftype: Looking for required rule(s) '" + Tk[Then].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule iftype: Looking for required rule(s) 'then value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("then value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "then value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "then value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule iftype: Looking for optional rule(s) 'else clause'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_elseiftype("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        match _parse_elseclause("else clause")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "else clause"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "else clause", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule iftype: Looking for required rule(s) '" + "iftype expression" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "iftype expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "iftype expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_caseexpr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("caseexpr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Case], _current_pos()))
    
    Debug("Rule caseexpr: Looking for required rule(s) '" + Tk[Pipe].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Pipe] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Pipe].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Pipe].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule caseexpr: Looking for optional rule(s) 'case pattern'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_pattern("case pattern")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "case pattern"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "case pattern", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule caseexpr: Looking for optional rule(s) '" + Tk[If].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[If] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[If].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[If].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule caseexpr: Looking for required rule(s) 'guard expression'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_rawseq("guard expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "guard expression"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "guard expression", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule caseexpr: Looking for optional rule(s) '" + Tk[DoubleArrow].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[DoubleArrow] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[DoubleArrow].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[DoubleArrow].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule caseexpr: Looking for required rule(s) 'case body'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_rawseq("case body")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "case body"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "case body", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_cases(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("cases", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Cases], _current_pos()))
    while true do
      
      Debug("Rule cases: Looking for optional rule(s) 'cases'")
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_caseexpr("cases")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "cases"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "cases", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_match(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("match", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule match: Looking for required rule(s) '" + Tk[Match].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Match] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Match].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Match].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule match: Looking for required rule(s) 'match expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("match expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "match expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "match expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule match: Looking for required rule(s) 'cases'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_cases("cases")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "cases"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "cases", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule match: Looking for optional rule(s) '" + Tk[Else].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule match: Looking for required rule(s) 'else clause'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_annotatedseq("else clause")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "else clause"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "else clause", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule match: Looking for required rule(s) '" + "match expression" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "match expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "match expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_whileloop(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("whileloop", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule whileloop: Looking for required rule(s) '" + Tk[While].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[While] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[While].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[While].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule whileloop: Looking for required rule(s) 'condition expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("condition expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "condition expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "condition expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule whileloop: Looking for required rule(s) '" + Tk[Do].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Do] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Do].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Do].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule whileloop: Looking for required rule(s) 'while body'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("while body")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "while body"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "while body", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule whileloop: Looking for optional rule(s) '" + Tk[Else].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule whileloop: Looking for required rule(s) 'else clause'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_annotatedseq("else clause")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "else clause"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "else clause", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule whileloop: Looking for required rule(s) '" + "while loop" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "while loop"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "while loop", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_repeat(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("repeat", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule repeat: Looking for required rule(s) '" + Tk[Repeat].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Repeat] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Repeat].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Repeat].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule repeat: Looking for required rule(s) 'repeat body'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("repeat body")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "repeat body"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "repeat body", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule repeat: Looking for required rule(s) '" + Tk[Until].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Until] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Until].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Until].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule repeat: Looking for required rule(s) 'condition expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_annotatedrawseq("condition expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "condition expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "condition expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule repeat: Looking for optional rule(s) '" + Tk[Else].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule repeat: Looking for required rule(s) 'else clause'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_annotatedseq("else clause")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "else clause"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "else clause", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule repeat: Looking for required rule(s) '" + "repeat loop" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "repeat loop"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "repeat loop", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_forloop(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("forloop", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule forloop: Looking for required rule(s) '" + Tk[For].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[For] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[For].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[For].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule forloop: Looking for required rule(s) 'iterator name'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_idseq("iterator name")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "iterator name"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "iterator name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule forloop: Looking for required rule(s) '" + Tk[In].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[In] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[In].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[In].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule forloop: Looking for required rule(s) 'iterator'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("iterator")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "iterator"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "iterator", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule forloop: Looking for required rule(s) '" + Tk[Do].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Do] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Do].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Do].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule forloop: Looking for required rule(s) 'for body'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("for body")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "for body"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "for body", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule forloop: Looking for optional rule(s) '" + Tk[Else].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule forloop: Looking for required rule(s) 'else clause'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_annotatedseq("else clause")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "else clause"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "else clause", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule forloop: Looking for required rule(s) '" + "for loop" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "for loop"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "for loop", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_withelem(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("withelem", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[ExprSeq], _current_pos()))
    
    Debug("Rule withelem: Looking for required rule(s) 'with name'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_idseq("with name")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "with name"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "with name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule withelem: Looking for required rule(s) '" + Tk[Assign].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule withelem: Looking for required rule(s) 'initialiser'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("initialiser")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "initialiser"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "initialiser", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_withexpr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("withexpr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[ExprSeq], _current_pos()))
    
    Debug("Rule withexpr: Looking for required rule(s) 'with expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_withelem("with expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "with expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "with expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule withexpr: Looking for optional rule(s) '" + Tk[Comma].desc() + "'. Found " + _current_tk().string())
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          Debug("Compatible")
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          Debug("Not compatible")
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      Debug("Rule withexpr: Looking for required rule(s) 'with expression'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_withelem("with expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "with expression"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "with expression", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_with(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("with", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule with: Looking for required rule(s) '" + Tk[With].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[With] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[With].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[With].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule with: Looking for required rule(s) 'with expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_withexpr("with expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "with expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "with expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule with: Looking for required rule(s) '" + Tk[Do].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Do] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Do].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Do].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule with: Looking for required rule(s) 'with body'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("with body")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "with body"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "with body", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule with: Looking for optional rule(s) '" + Tk[Else].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule with: Looking for required rule(s) 'else clause'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_annotatedrawseq("else clause")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "else clause"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "else clause", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule with: Looking for required rule(s) '" + "with expression" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "with expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "with expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_try_block(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("try_block", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule try_block: Looking for required rule(s) '" + Tk[Try].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Try] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Try].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Try].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule try_block: Looking for required rule(s) 'try body'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("try body")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "try body"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "try body", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule try_block: Looking for optional rule(s) '" + Tk[Else].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule try_block: Looking for required rule(s) 'try else body'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_annotatedseq("try else body")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "try else body"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "try else body", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule try_block: Looking for optional rule(s) '" + Tk[Then].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule try_block: Looking for required rule(s) 'try then body'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_annotatedseq("try then body")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "try then body"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "try then body", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule try_block: Looking for required rule(s) '" + "try expression" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "try expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "try expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_recover(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("recover", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule recover: Looking for required rule(s) '" + Tk[Recover].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Recover] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Recover].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Recover].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule recover: Looking for optional rule(s) 'capability'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_cap("capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capability"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule recover: Looking for required rule(s) 'recover body'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("recover body")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "recover body"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "recover body", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule recover: Looking for required rule(s) '" + "recover expression" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        Debug("Compatible")
        found = true
        last_matched = "recover expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "recover expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_consume(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("consume", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule consume: Looking for required rule(s) '" + "consume" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Consume] =>
        Debug("Compatible")
        found = true
        last_matched = "consume"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "consume", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule consume: Looking for optional rule(s) 'capability'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_cap("capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capability"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule consume: Looking for required rule(s) 'expression'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_term("expression")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "expression"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "expression", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_term(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("term", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule term: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_cond("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_ifdef("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_iftype("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_match("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_whileloop("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_repeat("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_forloop("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_with("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_try_block("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_recover("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_consume("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_pattern("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_const_expr("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextterm(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextterm", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nextterm: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_cond("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_ifdef("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_iftype("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_match("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_whileloop("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_repeat("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_forloop("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_with("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_try_block("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_recover("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_consume("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_nextpattern("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_const_expr("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_asop(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("asop", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule asop: Looking for required rule(s) '" + "as" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[As] =>
        Debug("Compatible")
        found = true
        last_matched = "as"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "as", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    Debug("Rule asop: Looking for required rule(s) 'type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_binop(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("binop", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule binop: Looking for required rule(s) '" + "binary operator" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[And] | Tk[Or] | Tk[XOr] | Tk[Add] | Tk[Sub] | Tk[Mul] | Tk[Div] | Tk[Mod] | Tk[LShift] | Tk[RShift] | Tk[LShiftUnsafe] | Tk[RShiftUnsafe] | Tk[Is] | Tk[Isnt] | Tk[Eq] | Tk[NE] | Tk[LT] | Tk[LE] | Tk[GE] | Tk[GT] | Tk[AddUnsafe] | Tk[SubUnsafe] | Tk[MulUnsafe] | Tk[DivUnsafe] | Tk[ModUnsafe] | Tk[EqUnsafe] | Tk[NEUnsafe] | Tk[LTUnsafe] | Tk[LEUnsafe] | Tk[GEUnsafe] | Tk[GTUnsafe] =>
        Debug("Compatible")
        found = true
        last_matched = "binary operator"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "binary operator", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    Debug("Rule binop: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_term("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_infix(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("infix", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule infix: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_term("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule infix: Looking for optional rule(s) 'value'")
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_binop("value")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "value"
            break _handle_found(state, tree, build)
          end
          
          match _parse_asop("value")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "value"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "value", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextinfix(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextinfix", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nextinfix: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_nextterm("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule nextinfix: Looking for optional rule(s) 'value'")
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_binop("value")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "value"
            break _handle_found(state, tree, build)
          end
          
          match _parse_asop("value")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "value"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "value", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_assignop(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("assignop", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule assignop: Looking for required rule(s) '" + "assign operator" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        Debug("Compatible")
        found = true
        last_matched = "assign operator"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "assign operator", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule assignop: Looking for required rule(s) 'assign rhs'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_assignment("assign rhs")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "assign rhs"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "assign rhs", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_assignment(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("assignment", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule assignment: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_infix("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule assignment: Looking for optional rule(s) 'value'")
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      while true do
        match _parse_assignop("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextassignment(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextassignment", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nextassignment: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_nextinfix("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule nextassignment: Looking for optional rule(s) 'value'")
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      while true do
        match _parse_assignop("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_jump(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("jump", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule jump: Looking for required rule(s) '" + "statement" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Return] | Tk[Break] | Tk[Continue] | Tk[Error] | Tk[CompileIntrinsic] | Tk[CompileError] =>
        Debug("Compatible")
        found = true
        last_matched = "statement"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "statement", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule jump: Looking for optional rule(s) 'return value'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_rawseq("return value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "return value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "return value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_semi(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("semi", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule semi: Looking for required rule(s) '" + Tk[Semicolon].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Semicolon] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Semicolon].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Semicolon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_semiexpr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("semiexpr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule semiexpr: Looking for required rule(s) 'semicolon'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_semi("semicolon")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "semicolon"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "semicolon", false)
      end
    if res isnt None then return (res, _BuildFlatten) end
    
    Debug("Rule semiexpr: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_exprseq("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_jump("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildFlatten) end
    
    (_complete(state), _BuildFlatten)
  
  fun ref _parse_nosemi(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nosemi", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nosemi: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_nextexprseq("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_jump("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextexprseq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextexprseq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule nextexprseq: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_nextassignment("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildFlatten) end
    
    Debug("Rule nextexprseq: Looking for optional rule(s) 'value'")
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      while true do
        match _parse_semiexpr("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_nosemi("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildFlatten) end
    
    (_complete(state), _BuildFlatten)
  
  fun ref _parse_exprseq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("exprseq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule exprseq: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_assignment("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildFlatten) end
    
    Debug("Rule exprseq: Looking for optional rule(s) 'value'")
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      while true do
        match _parse_semiexpr("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_nosemi("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildFlatten) end
    
    (_complete(state), _BuildFlatten)
  
  fun ref _parse_rawseq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("rawseq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[ExprSeq], _current_pos()))
    
    Debug("Rule rawseq: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_exprseq("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_jump("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_seq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("seq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule seq: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rawseq("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_annotatedrawseq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("annotatedrawseq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[ExprSeq], _current_pos()))
    
    Debug("Rule annotatedrawseq: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_exprseq("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_jump("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_annotatedseq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("annotatedseq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule annotatedseq: Looking for required rule(s) 'value'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_annotatedrawseq("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "value", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_method(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("method", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule method: Looking for required rule(s) '" + Tk[MethodFun].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[MethodFun] | Tk[MethodBe] | Tk[MethodNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[MethodFun].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[MethodFun].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule method: Looking for optional rule(s) 'capability'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_cap("capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capability"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule method: Looking for required rule(s) '" + "method name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "method name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "method name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule method: Looking for optional rule(s) 'type parameters'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_typeparams("type parameters")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type parameters"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type parameters", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule method: Looking for required rule(s) '" + Tk[LParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule method: Looking for optional rule(s) 'parameters'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_params("parameters")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "parameters"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "parameters", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule method: Looking for required rule(s) '" + Tk[RParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule method: Looking for optional rule(s) '" + Tk[Colon].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule method: Looking for required rule(s) 'return type'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_type("return type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "return type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "return type", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule method: Looking for optional rule(s) '" + Tk[Question].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Question] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Question].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Question].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule method: Looking for optional rule(s) '" + Tk[LitString].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitString] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LitString].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LitString].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule method: Looking for optional rule(s) '" + Tk[If].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[If] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[If].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[If].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule method: Looking for required rule(s) 'guard expression'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_rawseq("guard expression")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "guard expression"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "guard expression", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule method: Looking for optional rule(s) '" + Tk[DoubleArrow].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[DoubleArrow] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[DoubleArrow].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[DoubleArrow].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule method: Looking for required rule(s) 'method body'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_rawseq("method body")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "method body"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "method body", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_field(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("field", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule field: Looking for required rule(s) '" + Tk[Var].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Var] | Tk[Let] | Tk[Embed] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Var].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Var].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule field: Looking for required rule(s) '" + "field name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "field name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "field name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule field: Looking for required rule(s) '" + "mandatory type declaration on field" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        Debug("Compatible")
        found = true
        last_matched = "mandatory type declaration on field"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "mandatory type declaration on field", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule field: Looking for required rule(s) 'field type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_type("field type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "field type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "field type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule field: Looking for optional rule(s) '" + Tk[Assign].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule field: Looking for required rule(s) 'field value'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_infix("field value")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "field value"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "field value", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_members(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("members", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Members], _current_pos()))
    while true do
      
      Debug("Rule members: Looking for optional rule(s) 'field'")
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_field("field")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "field"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "field", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    while true do
      
      Debug("Rule members: Looking for optional rule(s) 'method'")
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_method("method")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "method"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "method", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_class_def(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("class_def", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule class_def: Looking for required rule(s) '" + "entity" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[TypeAlias] | Tk[Interface] | Tk[Trait] | Tk[Primitive] | Tk[Struct] | Tk[Class] | Tk[Actor] =>
        Debug("Compatible")
        found = true
        last_matched = "entity"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "entity", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule class_def: Looking for optional rule(s) '" + Tk[At].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[At] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[At].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[At].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule class_def: Looking for optional rule(s) 'capability'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_cap("capability")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "capability"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule class_def: Looking for required rule(s) '" + "name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = "name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule class_def: Looking for optional rule(s) 'type parameters'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_typeparams("type parameters")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type parameters"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type parameters", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule class_def: Looking for optional rule(s) '" + Tk[Is].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Is] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Is].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Is].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule class_def: Looking for required rule(s) 'provided type'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_provides("provided type")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "provided type"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "provided type", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    Debug("Rule class_def: Looking for optional rule(s) '" + "docstring" + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitString] =>
        Debug("Compatible")
        found = true
        last_matched = "docstring"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "docstring", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule class_def: Looking for required rule(s) 'members'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_members("members")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "members"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "members", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_use_uri(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("use_uri", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule use_uri: Looking for required rule(s) '" + Tk[LitString].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitString] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LitString].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LitString].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_use_ffi(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("use_ffi", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule use_ffi: Looking for required rule(s) '" + Tk[At].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[At] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[At].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[At].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule use_ffi: Looking for required rule(s) '" + "ffi name" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] | Tk[LitString] =>
        Debug("Compatible")
        found = true
        last_matched = "ffi name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "ffi name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule use_ffi: Looking for required rule(s) 'return type'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_typeargs("return type")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "return type"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "return type", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule use_ffi: Looking for required rule(s) '" + Tk[LParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule use_ffi: Looking for optional rule(s) 'ffi parameters'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_params("ffi parameters")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "ffi parameters"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "ffi parameters", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    state.add_deferrable_ast((Tk[None], _current_pos()))
    
    Debug("Rule use_ffi: Looking for required rule(s) '" + Tk[RParen].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule use_ffi: Looking for optional rule(s) '" + Tk[Question].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Question] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Question].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Question].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_use_name(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("use_name", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule use_name: Looking for required rule(s) '" + Tk[Id].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Id].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Id].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule use_name: Looking for required rule(s) '" + Tk[Assign].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_use(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("use", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    Debug("Rule use: Looking for required rule(s) '" + Tk[Use].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Use] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[Use].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[Use].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule use: Looking for optional rule(s) 'name'")
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_use_name("name")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "name"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule use: Looking for required rule(s) 'specifier'")
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_use_uri("specifier")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "specifier"
          break _handle_found(state, tree, build)
        end
        
        match _parse_use_ffi("specifier")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "specifier"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "specifier", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    Debug("Rule use: Looking for optional rule(s) '" + Tk[If].desc() + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[If] =>
        Debug("Compatible")
        found = true
        last_matched = Tk[If].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, Tk[If].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      Debug("Rule use: Looking for required rule(s) 'use condition'")
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_infix("use condition")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "use condition"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "use condition", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_module(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("module", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Module], _current_pos()))
    
    Debug("Rule module: Looking for optional rule(s) '" + "package docstring" + "'. Found " + _current_tk().string())
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitString] =>
        Debug("Compatible")
        found = true
        last_matched = "package docstring"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "package docstring", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      Debug("Rule module: Looking for optional rule(s) 'use command'")
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_use("use command")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "use command"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "use command", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    while true do
      
      Debug("Rule module: Looking for optional rule(s) 'type, interface, trait, primitive, class or actor definition'")
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_class_def("type, interface, trait, primitive, class or actor definition")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "type, interface, trait, primitive, class or actor definition"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "type, interface, trait, primitive, class or actor definition", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    
    Debug("Rule module: Looking for required rule(s) '" + "type, interface, trait, primitive, class, actor, member or method" + "'. Found " + _current_tk().string())
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[EOF] =>
        Debug("Compatible")
        found = true
        last_matched = "type, interface, trait, primitive, class, actor, member or method"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        Debug("Not compatible")
        found = false
        _handle_not_found(state, "type, interface, trait, primitive, class, actor, member or method", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  


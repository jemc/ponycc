use peg = "peg"
use "../ast"
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
  
  fun ref _parse_root(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("root", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
  
  fun ref _parse_module(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("module", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Module], _current_pos()))
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitString] =>
        found = true
        last_matched = "package docstring"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "package docstring", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_type_decl("type, interface, trait, primitive, class or actor definition")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[EOF] =>
        found = true
        last_matched = "type, interface, trait, primitive, class, actor, member or method"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "type, interface, trait, primitive, class, actor, member or method", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    match state.tree | let tree: TkTree =>
      try tree.children.push(tree.children.shift()) end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_use(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("use", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Use] =>
        found = true
        last_matched = Tk[Use].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Use].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_use_package("package or ffi declaration")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "package or ffi declaration"
          break _handle_found(state, tree, build)
        end
        
        match _parse_use_ffi_decl("package or ffi declaration")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "package or ffi declaration"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "package or ffi declaration", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_use_package(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("use_package", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[UsePackage], _current_pos()))
    
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_use_package_name("package name assignment")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "package name assignment"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "package name assignment", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitString] =>
        found = true
        last_matched = "package path"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "package path", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_use_package_name(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("use_package_name", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = Tk[Id].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Id].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_use_ffi_decl(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("use_ffi_decl", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[UseFFIDecl], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[At] =>
        found = true
        last_matched = Tk[At].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[At].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] | Tk[LitString] =>
        found = true
        last_matched = "ffi name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "ffi name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Question] =>
        found = true
        last_matched = Tk[Question].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Question].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[If] =>
        found = true
        last_matched = Tk[If].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[If].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
  
  fun ref _parse_type_decl(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("type_decl", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[TypeAlias] | Tk[Interface] | Tk[Trait] | Tk[Primitive] | Tk[Struct] | Tk[Class] | Tk[Actor] =>
        found = true
        last_matched = "entity"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "entity", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[At] =>
        found = true
        last_matched = Tk[At].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[At].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Is] =>
        found = true
        last_matched = Tk[Is].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Is].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    end
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitString] =>
        found = true
        last_matched = "docstring"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "docstring", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    match state.tree | let tree: TkTree =>
      let child_0 = try tree.children.shift() else TkTree(token) end
      let child_1 = try tree.children.shift() else TkTree(token) end
      let child_2 = try tree.children.shift() else TkTree(token) end
      let child_3 = try tree.children.shift() else TkTree(token) end
      let child_4 = try tree.children.shift() else TkTree(token) end
      let child_5 = try tree.children.shift() else TkTree(token) end
      let child_6 = try tree.children.shift() else TkTree(token) end
      tree.children.push(child_2)
      tree.children.push(child_0)
      tree.children.push(child_3)
      tree.children.push(child_4)
      tree.children.push(child_6)
      tree.children.push(child_1)
      tree.children.push(child_5)
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_members(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("members", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Members], _current_pos()))
    while true do
      
      
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
  
  fun ref _parse_field(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("field", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Var] | Tk[Let] | Tk[Embed] =>
        found = true
        last_matched = Tk[Var].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Var].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    match state.tree | let tree: TkTree =>
      match tree.tk
      | Tk[Var] => tree.tk = Tk[FieldVar]
      | Tk[Let] => tree.tk = Tk[FieldLet]
      | Tk[Embed] => tree.tk = Tk[FieldEmbed]
      end
    end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "field name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "field name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        found = true
        last_matched = "mandatory type declaration on field"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "mandatory type declaration on field", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
  
  fun ref _parse_method(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("method", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[MethodFun] | Tk[MethodBe] | Tk[MethodNew] =>
        found = true
        last_matched = Tk[MethodFun].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[MethodFun].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "method name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "method name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Question] =>
        found = true
        last_matched = Tk[Question].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Question].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitString] =>
        found = true
        last_matched = Tk[LitString].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LitString].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[If] =>
        found = true
        last_matched = Tk[If].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[If].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_seq("guard expression")
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
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[DoubleArrow] =>
        found = true
        last_matched = Tk[DoubleArrow].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[DoubleArrow].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_seq("method body")
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
    match state.tree | let tree: TkTree =>
      let child_0 = try tree.children.shift() else TkTree(token) end
      let child_1 = try tree.children.shift() else TkTree(token) end
      let child_2 = try tree.children.shift() else TkTree(token) end
      let child_3 = try tree.children.shift() else TkTree(token) end
      let child_4 = try tree.children.shift() else TkTree(token) end
      let child_5 = try tree.children.shift() else TkTree(token) end
      let child_6 = try tree.children.shift() else TkTree(token) end
      let child_7 = try tree.children.shift() else TkTree(token) end
      let child_8 = try tree.children.shift() else TkTree(token) end
      tree.children.push(child_1)
      tree.children.push(child_0)
      tree.children.push(child_2)
      tree.children.push(child_3)
      tree.children.push(child_4)
      tree.children.push(child_5)
      tree.children.push(child_7)
      tree.children.push(child_8)
      tree.children.push(child_6)
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_typeparams(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typeparams", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[TypeParams], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LSquare] | Tk[LSquareNew] =>
        found = true
        last_matched = Tk[LSquare].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LSquare].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RSquare] =>
        found = true
        last_matched = "type parameters"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "type parameters", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_typeparam(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typeparam", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[TypeParam], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
  
  fun ref _parse_typeargs(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typeargs", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[TypeArgs], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LSquare] =>
        found = true
        last_matched = Tk[LSquare].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LSquare].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RSquare] =>
        found = true
        last_matched = "type arguments"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "type arguments", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_typearg(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typearg", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
        
        match _parse_typearg_literal("type argument")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type argument"
          break _handle_found(state, tree, build)
        end
        
        match _parse_const_expr("type argument")
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
  
  fun ref _parse_typearg_literal(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("typearg_literal", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Constant], _current_pos()))
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_literal("type argument literal")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "type argument literal"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "type argument literal", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_const_expr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("const_expr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Constant] =>
        found = true
        last_matched = Tk[Constant].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Constant].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
  
  fun ref _parse_params(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("params", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Params], _current_pos()))
    
    
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      
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
  
  fun ref _parse_param(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("param", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Param], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "parameter name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "parameter name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
  
  fun ref _parse_seq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("seq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Sequence], _current_pos()))
    
    
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
    while true do
      
      
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
          
          match _parse_nextassignment("value")
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
      if not found then break end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_annotatedseq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("annotatedseq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Sequence], _current_pos()))
    
    
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
    while true do
      
      
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
          
          match _parse_nextassignment("value")
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
      if not found then break end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_semiexpr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("semiexpr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
    if res isnt None then return (res, _BuildDefault) end
    
    
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
  
  fun ref _parse_semi(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("semi", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Semicolon] =>
        found = true
        last_matched = Tk[Semicolon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Semicolon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      match _current_tk() | Tk[NewLine] =>
        found = true
        last_matched = Tk[NewLine].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[NewLine].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    match state.tree | let tree: TkTree =>
      match tree.tk
      | Tk[NewLine] => tree.tk = Tk[Semicolon]
      end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_jump(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("jump", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Return] | Tk[Break] | Tk[Continue] | Tk[Error] | Tk[CompileIntrinsic] | Tk[CompileError] =>
        found = true
        last_matched = "statement"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "statement", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_jumpvalue("return value")
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
  
  fun ref _parse_jumpvalue(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("jumpvalue", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      match _current_tk() | Tk[NewLine] =>
        found = true
        last_matched = Tk[NewLine].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[NewLine].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then return (_RuleNotFound, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_assignment("return value")
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
  
  fun ref _parse_assignment(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("assignment", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
  
  fun ref _parse_infix(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("infix", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
  
  fun ref _parse_term(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("term", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    res =
      while true do
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
        
        match _parse_if("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_while("value")
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
        
        match _parse_for("value")
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
        
        match _parse_match("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_try("value")
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
    
    
    state.default_tk = None
    found = false
    res =
      while true do
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
        
        match _parse_if("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_while("value")
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
        
        match _parse_for("value")
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
        
        match _parse_match("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_try("value")
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
  
  fun ref _parse_ifdefinfix(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ifdefinfix", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_ifdefterm("ifdef condition")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "ifdef condition"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "ifdef condition", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      
      state.default_tk = Tk[EOF]
      found = false
      res =
        while true do
          match _parse_ifdefbinop("ifdef binary operator")
          | (_RuleParseError, _) => break _handle_error(state)
          | (let tree: (TkTree | None), let build: _Build) =>
            found = true
            last_matched = "ifdef binary operator"
            break _handle_found(state, tree, build)
          end
          
          found = false
          break _handle_not_found(state, "ifdef binary operator", false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
    end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_ifdefterm(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ifdefterm", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_ifdefflag("ifdef condition")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "ifdef condition"
          break _handle_found(state, tree, build)
        end
        
        match _parse_ifdefnot("ifdef condition")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "ifdef condition"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "ifdef condition", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_ifdefflag(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ifdefflag", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[IfDefFlag], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] | Tk[LitString] =>
        found = true
        last_matched = "ifdef condition"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "ifdef condition", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_ifdefnot(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ifdefnot", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[IfDefNot], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Not] =>
        found = true
        last_matched = Tk[Not].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Not].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_ifdefterm("ifdef condition")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "ifdef condition"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "ifdef condition", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_ifdefbinop(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ifdefbinop", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[And] | Tk[Or] =>
        found = true
        last_matched = "ifdef binary operator"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "ifdef binary operator", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    match state.tree | let tree: TkTree =>
      match tree.tk
      | Tk[And] => tree.tk = Tk[IfDefAnd]
      | Tk[Or] => tree.tk = Tk[IfDefOr]
      end
    end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_ifdefterm("ifdef condition")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "ifdef condition"
          break _handle_found(state, tree, build)
        end
        
        found = false
        break _handle_not_found(state, "ifdef condition", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_ifdef(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ifdef", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[IfDef] =>
        found = true
        last_matched = Tk[IfDef].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[IfDef].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_ifdefinfix("condition expression")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "ifdef expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "ifdef expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_elseifdef(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("elseifdef", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[IfDef], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[ElseIf] =>
        found = true
        last_matched = Tk[ElseIf].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[ElseIf].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_ifdefinfix("condition expression")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
  
  fun ref _parse_iftype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("iftype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[IfType] =>
        found = true
        last_matched = Tk[IfType].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[IfType].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[SubType] =>
        found = true
        last_matched = Tk[SubType].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[SubType].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "iftype expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "iftype expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_elseiftype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("elseiftype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[IfType], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[ElseIf] =>
        found = true
        last_matched = Tk[ElseIf].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[ElseIf].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[SubType] =>
        found = true
        last_matched = Tk[SubType].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[SubType].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
  
  fun ref _parse_if(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("if", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[If] =>
        found = true
        last_matched = Tk[If].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[If].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("condition expression")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "if expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "if expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_elseif(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("elseif", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[If], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[ElseIf] =>
        found = true
        last_matched = Tk[ElseIf].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[ElseIf].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("condition expression")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
  
  fun ref _parse_elseclause(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("elseclause", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
  
  fun ref _parse_while(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("while", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[While] =>
        found = true
        last_matched = Tk[While].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[While].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("condition expression")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Do] =>
        found = true
        last_matched = Tk[Do].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Do].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "while loop"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "while loop", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_repeat(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("repeat", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Repeat] =>
        found = true
        last_matched = Tk[Repeat].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Repeat].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Until] =>
        found = true
        last_matched = Tk[Until].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Until].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_annotatedseq("condition expression")
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "repeat loop"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "repeat loop", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_for(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("for", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[For] =>
        found = true
        last_matched = Tk[For].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[For].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[In] =>
        found = true
        last_matched = Tk[In].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[In].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("iterator")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Do] =>
        found = true
        last_matched = Tk[Do].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Do].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("for body")
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "for loop"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "for loop", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_with(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("with", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[With] =>
        found = true
        last_matched = Tk[With].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[With].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Do] =>
        found = true
        last_matched = Tk[Do].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Do].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("with body")
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "with expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "with expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_idseq(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("idseq", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
  
  fun ref _parse_idseqsingle(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("idseqsingle", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "variable name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "variable name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_idseqmulti(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("idseqmulti", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Tuple], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_idseq("variable name")
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_idseq("variable name")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_withelem(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("withelem", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_infix("with name")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_assignment("initialiser")
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
    state.add_deferrable_ast((Tk[AssignTuple], _current_pos()))
    
    
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      
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
  
  fun ref _parse_match(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("match", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Match] =>
        found = true
        last_matched = Tk[Match].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Match].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("match expression")
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "match expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "match expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_cases(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("cases", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Cases], _current_pos()))
    while true do
      
      
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
  
  fun ref _parse_caseexpr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("caseexpr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Case], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Pipe] =>
        found = true
        last_matched = Tk[Pipe].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Pipe].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[If] =>
        found = true
        last_matched = Tk[If].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[If].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_seq("guard expression")
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[DoubleArrow] =>
        found = true
        last_matched = Tk[DoubleArrow].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[DoubleArrow].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_seq("case body")
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
  
  fun ref _parse_try(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("try", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Try] =>
        found = true
        last_matched = Tk[Try].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Try].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Else] =>
        found = true
        last_matched = Tk[Else].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Else].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Then] =>
        found = true
        last_matched = Tk[Then].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Then].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "try expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "try expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_consume(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("consume", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Consume] =>
        found = true
        last_matched = "consume"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "consume", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
  
  fun ref _parse_recover(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("recover", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Recover] =>
        found = true
        last_matched = Tk[Recover].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Recover].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "recover expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "recover expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_asop(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("asop", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[As] =>
        found = true
        last_matched = "as"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "as", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Add] | Tk[AddUnsafe] | Tk[Sub] | Tk[SubUnsafe] | Tk[Mul] | Tk[MulUnsafe] | Tk[Div] | Tk[DivUnsafe] | Tk[Mod] | Tk[ModUnsafe] | Tk[LShift] | Tk[RShift] | Tk[LShiftUnsafe] | Tk[RShiftUnsafe] | Tk[Eq] | Tk[EqUnsafe] | Tk[NE] | Tk[NEUnsafe] | Tk[LT] | Tk[LTUnsafe] | Tk[LE] | Tk[LEUnsafe] | Tk[GE] | Tk[GEUnsafe] | Tk[GT] | Tk[GTUnsafe] | Tk[Is] | Tk[Isnt] | Tk[And] | Tk[Or] | Tk[XOr] =>
        found = true
        last_matched = "binary operator"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "binary operator", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    
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
  
  fun ref _parse_prefix(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("prefix", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Not] | Tk[AddressOf] | Tk[DigestOf] | Tk[Sub] | Tk[SubUnsafe] | Tk[SubNew] | Tk[SubUnsafeNew] =>
        found = true
        last_matched = "prefix"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "prefix", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    match state.tree | let tree: TkTree =>
      match tree.tk
      | Tk[Sub] => tree.tk = Tk[Neg]
      | Tk[SubUnsafe] => tree.tk = Tk[NegUnsafe]
      | Tk[SubNew] => tree.tk = Tk[Neg]
      | Tk[SubUnsafeNew] => tree.tk = Tk[NegUnsafe]
      end
    end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rhspattern("expression")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Not] | Tk[AddressOf] | Tk[DigestOf] | Tk[SubNew] | Tk[SubUnsafeNew] =>
        found = true
        last_matched = "prefix"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "prefix", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    match state.tree | let tree: TkTree =>
      match tree.tk
      | Tk[SubNew] => tree.tk = Tk[Neg]
      | Tk[SubUnsafeNew] => tree.tk = Tk[NegUnsafe]
      end
    end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_rhspattern("expression")
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
  
  fun ref _parse_rhspattern(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("rhspattern", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
  
  fun ref _parse_nextrhspattern(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextrhspattern", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
        
        match _parse_rhspattern("pattern")
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
        
        match _parse_nextrhspattern("pattern")
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
  
  fun ref _parse_local(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("local", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Var] | Tk[Let] =>
        found = true
        last_matched = Tk[Var].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Var].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    match state.tree | let tree: TkTree =>
      match tree.tk
      | Tk[Var] => tree.tk = Tk[LocalVar]
      | Tk[Let] => tree.tk = Tk[LocalLet]
      end
    end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "variable name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "variable name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
  
  fun ref _parse_assignop(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("assignop", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        found = true
        last_matched = "assign operator"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "assign operator", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
  
  fun ref _parse_postfix(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("postfix", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
          
          match _parse_chain("postfix expression")
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
          
          match _parse_chain("postfix expression")
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
  
  fun ref _parse_dot(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("dot", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Dot] =>
        found = true
        last_matched = Tk[Dot].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Dot].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "member name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "member name", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_chain(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("chain", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Chain] =>
        found = true
        last_matched = Tk[Chain].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Chain].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "method name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "method name", false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_tilde(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("tilde", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Tilde] =>
        found = true
        last_matched = Tk[Tilde].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Tilde].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "method name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] =>
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_args("argument")
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
    
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_namedargs("argument")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = "call arguments"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "call arguments", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_callffi(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("callffi", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[CallFFI], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[At] =>
        found = true
        last_matched = Tk[At].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[At].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] | Tk[LitString] =>
        found = true
        last_matched = "ffi name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "ffi name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_args("ffi arguments")
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
    
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_namedargs("ffi arguments")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = "ffi arguments"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "ffi arguments", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Question] =>
        found = true
        last_matched = Tk[Question].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Question].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_args(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("args", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Args], _current_pos()))
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("argument")
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_seq("argument")
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
  
  fun ref _parse_namedargs(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("namedargs", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[NamedArgs], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Where] =>
        found = true
        last_matched = Tk[Where].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Where].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      
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
  
  fun ref _parse_namedarg(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("namedarg", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[NamedArg], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "argument name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "argument name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("argument value")
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
  
  fun ref _parse_atom(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("atom", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_callffi("value")
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
        
        match _parse_object("value")
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
        
        match _parse_groupedexpr("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_this("value")
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
        
        match _parse_location("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_reference("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_dontcare("value")
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
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_callffi("value")
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
        
        match _parse_object("value")
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
        
        match _parse_nextgroupedexpr("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_this("value")
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
        
        match _parse_location("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_reference("value")
        | (_RuleParseError, _) => break _handle_error(state)
        | (let tree: (TkTree | None), let build: _Build) =>
          found = true
          last_matched = "value"
          break _handle_found(state, tree, build)
        end
        
        match _parse_dontcare("value")
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
  
  fun ref _parse_lambda(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("lambda", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Lambda], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LBrace] =>
        found = true
        last_matched = Tk[LBrace].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LBrace].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "function name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "function name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Question] =>
        found = true
        last_matched = Tk[Question].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Question].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[DoubleArrow] =>
        found = true
        last_matched = Tk[DoubleArrow].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[DoubleArrow].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("lambda body")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RBrace] =>
        found = true
        last_matched = "lambda expression"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "lambda expression", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
  
  fun ref _parse_lambdacaptures(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("lambdacaptures", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[LambdaCaptures], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
        
        match _parse_this("capture")
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      
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
          
          match _parse_this("capture")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_lambdacapture(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("lambdacapture", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[LambdaCapture], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Assign] =>
        found = true
        last_matched = Tk[Assign].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Assign].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
  
  fun ref _parse_object(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("object", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Object] =>
        found = true
        last_matched = Tk[Object].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Object].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Is] =>
        found = true
        last_matched = Tk[Is].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Is].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[End] =>
        found = true
        last_matched = "object literal"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "object literal", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_array(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("array", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[LitArray], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LSquare] | Tk[LSquareNew] =>
        found = true
        last_matched = Tk[LSquare].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LSquare].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("array elements")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RSquare] =>
        found = true
        last_matched = "array literal"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LSquareNew] =>
        found = true
        last_matched = Tk[LSquareNew].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LSquareNew].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("array elements")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RSquare] =>
        found = true
        last_matched = "array literal"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "array literal", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_arraytype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("arraytype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[As] =>
        found = true
        last_matched = Tk[As].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[As].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_groupedexpr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("groupedexpr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("value")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nextgroupedexpr(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nextgroupedexpr", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParenNew] =>
        found = true
        last_matched = Tk[LParenNew].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParenNew].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("value")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_tuple(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("tuple", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Tuple], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Comma] =>
        found = true
        last_matched = Tk[Comma].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Comma].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_seq("value")
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildInfix) end
      if not found then break end
      
      
      state.default_tk = None
      found = false
      res =
        while true do
          match _parse_seq("value")
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
  
  fun ref _parse_this(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("this", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[This] =>
        found = true
        last_matched = Tk[This].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[This].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_literal(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("literal", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitTrue] | Tk[LitFalse] | Tk[LitInteger] | Tk[LitFloat] | Tk[LitString] | Tk[LitCharacter] =>
        found = true
        last_matched = "literal"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "literal", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_location(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("location", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LitLocation] =>
        found = true
        last_matched = Tk[LitLocation].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LitLocation].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_reference(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("reference", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Reference], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_dontcare(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("dontcare", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[DontCare] =>
        found = true
        last_matched = Tk[DontCare].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[DontCare].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_type(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("type", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
  
  fun ref _parse_atomtype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("atomtype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
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
        
        match _parse_gencap("type")
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
    state.add_deferrable_ast((Tk[ViewpointType], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Arrow] =>
        found = true
        last_matched = Tk[Arrow].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Arrow].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    
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
  
  fun ref _parse_tupletype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("tupletype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[TupleType], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[EOF]
    found = false
    res =
      while true do
        match _parse_commatype("type")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_infixtype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("infixtype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
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
  
  fun ref _parse_uniontype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("uniontype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[UnionType], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Pipe] =>
        found = true
        last_matched = Tk[Pipe].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Pipe].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    
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
    while true do
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Pipe] =>
          found = true
          last_matched = Tk[Pipe].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Pipe].desc(), false)
        end
      if res isnt None then return (res, _BuildInfix) end
      if not found then break end
      
      
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
    end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_isecttype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("isecttype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[IsectType], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Ampersand] =>
        found = true
        last_matched = Tk[Ampersand].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Ampersand].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    
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
    while true do
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Ampersand] =>
          found = true
          last_matched = Tk[Ampersand].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Ampersand].desc(), false)
        end
      if res isnt None then return (res, _BuildInfix) end
      if not found then break end
      
      
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
    end
    
    (_complete(state), _BuildInfix)
  
  fun ref _parse_commatype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("commatype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Comma] =>
        found = true
        last_matched = Tk[Comma].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Comma].desc(), false)
      end
    if res isnt None then return (res, _BuildInfix) end
    
    
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
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildInfix) end
      if not found then break end
      
      
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
  
  fun ref _parse_nominal(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nominal", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[NominalType], _current_pos()))
    
    
    state.default_tk = None
    found = false
    res =
      while true do
        match _parse_nominaldot("name")
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
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Ephemeral] | Tk[Aliased] =>
        found = true
        last_matched = Tk[Ephemeral].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Ephemeral].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_nominaldot(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("nominaldot", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[Dot], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "name", false)
      end
    if res isnt None then return (res, _BuildUnwrap[Tk[Dot]]) end
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Dot] =>
        found = true
        last_matched = Tk[Dot].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Dot].desc(), false)
      end
    if res isnt None then return (res, _BuildUnwrap[Tk[Dot]]) end
    if found then
      
      
      state.default_tk = None
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Id] =>
          found = true
          last_matched = Tk[Id].desc()
          _handle_found(state, TkTree(_consume_token()), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Id].desc(), false)
        end
      if res isnt None then return (res, _BuildUnwrap[Tk[Dot]]) end
    end
    match state.tree | let tree: TkTree =>
      try tree.children.push(tree.children.shift()) end
    end
    
    (_complete(state), _BuildUnwrap[Tk[Dot]])
  
  fun ref _parse_lambdatype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("lambdatype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[LambdaType], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LBrace] =>
        found = true
        last_matched = Tk[LBrace].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LBrace].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "function name"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "function name", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[LParen] | Tk[LParenNew] =>
        found = true
        last_matched = Tk[LParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[LParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[None]
    found = false
    res =
      while true do
        match _parse_tupletype("parameters")
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
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RParen] =>
        found = true
        last_matched = Tk[RParen].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[RParen].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = Tk[EOF]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Colon] =>
        found = true
        last_matched = Tk[Colon].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Colon].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    if found then
      
      
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
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Question] =>
        found = true
        last_matched = Tk[Question].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Question].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[RBrace] =>
        found = true
        last_matched = Tk[RBrace].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[RBrace].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
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
    
    
    state.default_tk = Tk[None]
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Ephemeral] | Tk[Aliased] =>
        found = true
        last_matched = Tk[Ephemeral].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Ephemeral].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_thistype(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("thistype", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    state.add_deferrable_ast((Tk[ThisType], _current_pos()))
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[This] =>
        found = true
        last_matched = Tk[This].desc()
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[This].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_ellipsis(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("ellipsis", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Ellipsis] =>
        found = true
        last_matched = Tk[Ellipsis].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Ellipsis].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_cap(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("cap", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Iso] | Tk[Trn] | Tk[Ref] | Tk[Val] | Tk[Box] | Tk[Tag] =>
        found = true
        last_matched = "capability"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_gencap(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("gencap", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[CapRead] | Tk[CapSend] | Tk[CapShare] | Tk[CapAlias] | Tk[CapAny] =>
        found = true
        last_matched = "generic capability"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "generic capability", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  
  fun ref _parse_annotations(rule_desc: String): (_RuleResult, _Build) =>
    let state = _RuleState("annotations", rule_desc)
    var res: _RuleResult = None
    var found: Bool = false
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Backslash] =>
        found = true
        last_matched = Tk[Backslash].desc()
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, Tk[Backslash].desc(), false)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Id] =>
        found = true
        last_matched = "annotation"
        _handle_found(state, TkTree(_consume_token()), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "annotation", false)
      end
    if res isnt None then return (res, _BuildDefault) end
    while true do
      
      
      state.default_tk = Tk[EOF]
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Comma] =>
          found = true
          last_matched = Tk[Comma].desc()
          _handle_found(state, (_consume_token(); None), _BuildDefault)
        else
          found = false
          _handle_not_found(state, Tk[Comma].desc(), false)
        end
      if res isnt None then return (res, _BuildDefault) end
      if not found then break end
      
      
      state.default_tk = None
      found = false
      while _current_tk() is Tk[NewLine] do _consume_token() end
      res =
        match _current_tk() | Tk[Id] =>
          found = true
          last_matched = "annotation"
          _handle_found(state, TkTree(_consume_token()), _BuildDefault)
        else
          found = false
          _handle_not_found(state, "annotation", false)
        end
      if res isnt None then return (res, _BuildDefault) end
    end
    
    
    state.default_tk = None
    found = false
    while _current_tk() is Tk[NewLine] do _consume_token() end
    res =
      match _current_tk() | Tk[Backslash] =>
        found = true
        last_matched = "annotations"
        _handle_found(state, (_consume_token(); None), _BuildDefault)
      else
        found = false
        _handle_not_found(state, "annotations", true)
      end
    if res isnt None then return (res, _BuildDefault) end
    
    (_complete(state), _BuildDefault)
  


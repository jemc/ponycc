use coll = "collections/persistent"

trait val AST
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val)
  fun val each(fn: {ref ((AST | None))} ref)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)?
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST
  fun val pos(): SourcePosAny
  fun string(): String iso^
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  

primitive ASTInfo
  fun name[A: (AST | None)](): String =>
    iftype A <: None then "x"
    elseif A <: Module then "Module"
    elseif A <: UsePackage then "UsePackage"
    elseif A <: UseFFIDecl then "UseFFIDecl"
    elseif A <: TypeAlias then "TypeAlias"
    elseif A <: Interface then "Interface"
    elseif A <: Trait then "Trait"
    elseif A <: Primitive then "Primitive"
    elseif A <: Struct then "Struct"
    elseif A <: Class then "Class"
    elseif A <: Actor then "Actor"
    elseif A <: Members then "Members"
    elseif A <: FieldLet then "FieldLet"
    elseif A <: FieldVar then "FieldVar"
    elseif A <: FieldEmbed then "FieldEmbed"
    elseif A <: MethodFun then "MethodFun"
    elseif A <: MethodNew then "MethodNew"
    elseif A <: MethodBe then "MethodBe"
    elseif A <: TypeParams then "TypeParams"
    elseif A <: TypeParam then "TypeParam"
    elseif A <: TypeArgs then "TypeArgs"
    elseif A <: Params then "Params"
    elseif A <: Param then "Param"
    elseif A <: Sequence then "Sequence"
    elseif A <: Return then "Return"
    elseif A <: Break then "Break"
    elseif A <: Continue then "Continue"
    elseif A <: Error then "Error"
    elseif A <: CompileIntrinsic then "CompileIntrinsic"
    elseif A <: CompileError then "CompileError"
    elseif A <: IfDefFlag then "IfDefFlag"
    elseif A <: IfDefNot then "IfDefNot"
    elseif A <: IfDefAnd then "IfDefAnd"
    elseif A <: IfDefOr then "IfDefOr"
    elseif A <: IfDef then "IfDef"
    elseif A <: IfType then "IfType"
    elseif A <: If then "If"
    elseif A <: While then "While"
    elseif A <: Repeat then "Repeat"
    elseif A <: For then "For"
    elseif A <: With then "With"
    elseif A <: IdTuple then "IdTuple"
    elseif A <: AssignTuple then "AssignTuple"
    elseif A <: Match then "Match"
    elseif A <: Cases then "Cases"
    elseif A <: Case then "Case"
    elseif A <: Try then "Try"
    elseif A <: Consume then "Consume"
    elseif A <: Recover then "Recover"
    elseif A <: As then "As"
    elseif A <: Add then "Add"
    elseif A <: AddUnsafe then "AddUnsafe"
    elseif A <: Sub then "Sub"
    elseif A <: SubUnsafe then "SubUnsafe"
    elseif A <: Mul then "Mul"
    elseif A <: MulUnsafe then "MulUnsafe"
    elseif A <: Div then "Div"
    elseif A <: DivUnsafe then "DivUnsafe"
    elseif A <: Mod then "Mod"
    elseif A <: ModUnsafe then "ModUnsafe"
    elseif A <: LShift then "LShift"
    elseif A <: LShiftUnsafe then "LShiftUnsafe"
    elseif A <: RShift then "RShift"
    elseif A <: RShiftUnsafe then "RShiftUnsafe"
    elseif A <: Eq then "Eq"
    elseif A <: EqUnsafe then "EqUnsafe"
    elseif A <: NE then "NE"
    elseif A <: NEUnsafe then "NEUnsafe"
    elseif A <: LT then "LT"
    elseif A <: LTUnsafe then "LTUnsafe"
    elseif A <: LE then "LE"
    elseif A <: LEUnsafe then "LEUnsafe"
    elseif A <: GE then "GE"
    elseif A <: GEUnsafe then "GEUnsafe"
    elseif A <: GT then "GT"
    elseif A <: GTUnsafe then "GTUnsafe"
    elseif A <: Is then "Is"
    elseif A <: Isnt then "Isnt"
    elseif A <: And then "And"
    elseif A <: Or then "Or"
    elseif A <: XOr then "XOr"
    elseif A <: Not then "Not"
    elseif A <: Neg then "Neg"
    elseif A <: NegUnsafe then "NegUnsafe"
    elseif A <: AddressOf then "AddressOf"
    elseif A <: DigestOf then "DigestOf"
    elseif A <: LocalLet then "LocalLet"
    elseif A <: LocalVar then "LocalVar"
    elseif A <: Assign then "Assign"
    elseif A <: Dot then "Dot"
    elseif A <: Chain then "Chain"
    elseif A <: Tilde then "Tilde"
    elseif A <: Qualify then "Qualify"
    elseif A <: Call then "Call"
    elseif A <: CallFFI then "CallFFI"
    elseif A <: Args then "Args"
    elseif A <: NamedArgs then "NamedArgs"
    elseif A <: NamedArg then "NamedArg"
    elseif A <: Lambda then "Lambda"
    elseif A <: LambdaCaptures then "LambdaCaptures"
    elseif A <: LambdaCapture then "LambdaCapture"
    elseif A <: Object then "Object"
    elseif A <: LitArray then "LitArray"
    elseif A <: Tuple then "Tuple"
    elseif A <: This then "This"
    elseif A <: LitTrue then "LitTrue"
    elseif A <: LitFalse then "LitFalse"
    elseif A <: LitInteger then "LitInteger"
    elseif A <: LitFloat then "LitFloat"
    elseif A <: LitString then "LitString"
    elseif A <: LitCharacter then "LitCharacter"
    elseif A <: LitLocation then "LitLocation"
    elseif A <: Reference then "Reference"
    elseif A <: DontCare then "DontCare"
    elseif A <: PackageRef then "PackageRef"
    elseif A <: MethodFunRef then "MethodFunRef"
    elseif A <: MethodNewRef then "MethodNewRef"
    elseif A <: MethodBeRef then "MethodBeRef"
    elseif A <: TypeRef then "TypeRef"
    elseif A <: FieldLetRef then "FieldLetRef"
    elseif A <: FieldVarRef then "FieldVarRef"
    elseif A <: FieldEmbedRef then "FieldEmbedRef"
    elseif A <: TupleElementRef then "TupleElementRef"
    elseif A <: LocalLetRef then "LocalLetRef"
    elseif A <: LocalVarRef then "LocalVarRef"
    elseif A <: ParamRef then "ParamRef"
    elseif A <: ViewpointType then "ViewpointType"
    elseif A <: UnionType then "UnionType"
    elseif A <: IsectType then "IsectType"
    elseif A <: TupleType then "TupleType"
    elseif A <: NominalType then "NominalType"
    elseif A <: FunType then "FunType"
    elseif A <: LambdaType then "LambdaType"
    elseif A <: TypeParamRef then "TypeParamRef"
    elseif A <: ThisType then "ThisType"
    elseif A <: DontCareType then "DontCareType"
    elseif A <: ErrorType then "ErrorType"
    elseif A <: LiteralType then "LiteralType"
    elseif A <: LiteralTypeBranch then "LiteralTypeBranch"
    elseif A <: OpLiteralType then "OpLiteralType"
    elseif A <: Iso then "Iso"
    elseif A <: Trn then "Trn"
    elseif A <: Ref then "Ref"
    elseif A <: Val then "Val"
    elseif A <: Box then "Box"
    elseif A <: Tag then "Tag"
    elseif A <: CapRead then "CapRead"
    elseif A <: CapSend then "CapSend"
    elseif A <: CapShare then "CapShare"
    elseif A <: CapAlias then "CapAlias"
    elseif A <: CapAny then "CapAny"
    elseif A <: Aliased then "Aliased"
    elseif A <: Ephemeral then "Ephemeral"
    elseif A <: At then "At"
    elseif A <: Question then "Question"
    elseif A <: Ellipsis then "Ellipsis"
    elseif A <: Semicolon then "Semicolon"
    elseif A <: Id then "Id"
    elseif A <: EOF then "EOF"
    elseif A <: NewLine then "NewLine"
    elseif A <: Use then "Use"
    elseif A <: Colon then "Colon"
    elseif A <: Comma then "Comma"
    elseif A <: Constant then "Constant"
    elseif A <: Pipe then "Pipe"
    elseif A <: Ampersand then "Ampersand"
    elseif A <: SubType then "SubType"
    elseif A <: Arrow then "Arrow"
    elseif A <: DoubleArrow then "DoubleArrow"
    elseif A <: Backslash then "Backslash"
    elseif A <: LParen then "LParen"
    elseif A <: RParen then "RParen"
    elseif A <: LBrace then "LBrace"
    elseif A <: RBrace then "RBrace"
    elseif A <: LSquare then "LSquare"
    elseif A <: RSquare then "RSquare"
    elseif A <: LParenNew then "LParenNew"
    elseif A <: LBraceNew then "LBraceNew"
    elseif A <: LSquareNew then "LSquareNew"
    elseif A <: SubNew then "SubNew"
    elseif A <: SubUnsafeNew then "SubUnsafeNew"
    elseif A <: In then "In"
    elseif A <: Until then "Until"
    elseif A <: Do then "Do"
    elseif A <: Else then "Else"
    elseif A <: ElseIf then "ElseIf"
    elseif A <: Then then "Then"
    elseif A <: End then "End"
    elseif A <: Var then "Var"
    elseif A <: Let then "Let"
    elseif A <: Embed then "Embed"
    elseif A <: Where then "Where"
    else "???"
    end

trait val BinaryOp is AST
  fun val left(): Expr
  fun val right(): Expr
  fun val with_left(left': Expr): BinaryOp
  fun val with_right(right': Expr): BinaryOp

trait val Cap is AST

trait val LitBool is AST

trait val Type is AST

trait val Field is AST
  fun val field_type(): Type
  fun val default(): (Expr | None)
  fun val name(): Id
  fun val with_field_type(field_type': Type): Field
  fun val with_default(default': (Expr | None)): Field
  fun val with_name(name': Id): Field

trait val IfDefBinaryOp is AST
  fun val left(): IfDefCond
  fun val right(): IfDefCond
  fun val with_left(left': IfDefCond): IfDefBinaryOp
  fun val with_right(right': IfDefCond): IfDefBinaryOp

trait val GenCap is AST

trait val Local is AST
  fun val local_type(): (Type | None)
  fun val name(): Id
  fun val with_local_type(local_type': (Type | None)): Local
  fun val with_name(name': Id): Local

trait val UseDecl is AST

trait val Jump is AST
  fun val value(): (Expr | None)
  fun val with_value(value': (Expr | None)): Jump

trait val CapMod is AST

trait val MethodRef is AST
  fun val receiver(): Expr
  fun val name(): (Id | TypeArgs)
  fun val with_receiver(receiver': Expr): MethodRef
  fun val with_name(name': (Id | TypeArgs)): MethodRef

trait val TypeDecl is AST
  fun val members(): Members
  fun val at(): (At | None)
  fun val type_params(): (TypeParams | None)
  fun val cap(): (Cap | None)
  fun val provides(): (Type | None)
  fun val docs(): (LitString | None)
  fun val name(): Id
  fun val with_members(members': Members): TypeDecl
  fun val with_at(at': (At | None)): TypeDecl
  fun val with_type_params(type_params': (TypeParams | None)): TypeDecl
  fun val with_cap(cap': (Cap | None)): TypeDecl
  fun val with_provides(provides': (Type | None)): TypeDecl
  fun val with_docs(docs': (LitString | None)): TypeDecl
  fun val with_name(name': Id): TypeDecl

trait val IfDefCond is AST

trait val Lexeme is AST

trait val Method is AST
  fun val name(): Id
  fun val partial(): (Question | None)
  fun val type_params(): (TypeParams | None)
  fun val body(): (Sequence | None)
  fun val cap(): (Cap | None)
  fun val docs(): (LitString | None)
  fun val return_type(): (Type | None)
  fun val params(): Params
  fun val guard(): (Sequence | None)
  fun val with_name(name': Id): Method
  fun val with_partial(partial': (Question | None)): Method
  fun val with_type_params(type_params': (TypeParams | None)): Method
  fun val with_body(body': (Sequence | None)): Method
  fun val with_cap(cap': (Cap | None)): Method
  fun val with_docs(docs': (LitString | None)): Method
  fun val with_return_type(return_type': (Type | None)): Method
  fun val with_params(params': Params): Method
  fun val with_guard(guard': (Sequence | None)): Method

trait val Expr is AST

trait val FieldRef is AST
  fun val receiver(): Expr
  fun val name(): Id
  fun val with_receiver(receiver': Expr): FieldRef
  fun val with_name(name': Id): FieldRef

trait val LocalRef is AST
  fun val name(): Id
  fun val with_name(name': Id): LocalRef

trait val UnaryOp is AST
  fun val expr(): Expr
  fun val with_expr(expr': Expr): UnaryOp

class val Module is AST
  let _pos: SourcePosAny
  
  let _use_decls: coll.Vec[UseDecl]
  let _type_decls: coll.Vec[TypeDecl]
  let _docs: (LitString | None)
  
  new val create(
    use_decls': coll.Vec[UseDecl] = coll.Vec[UseDecl],
    type_decls': coll.Vec[TypeDecl] = coll.Vec[TypeDecl],
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _use_decls = use_decls'
    _type_decls = type_decls'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    use_decls': coll.Vec[UseDecl],
    type_decls': coll.Vec[TypeDecl],
    docs': (LitString | None))
  =>
    _pos = pos'
    _use_decls = use_decls'
    _type_decls = type_decls'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var use_decls' = coll.Vec[UseDecl]
    var use_decls_next' = try iter.next() else None end
    while true do
      try use_decls' = use_decls'.push(use_decls_next' as UseDecl) else break end
      try use_decls_next' = iter.next() else use_decls_next' = None; break end
    end
    var type_decls' = coll.Vec[TypeDecl]
    var type_decls_next' = use_decls_next'
    while true do
      try type_decls' = type_decls'.push(type_decls_next' as TypeDecl) else break end
      try type_decls_next' = iter.next() else type_decls_next' = None; break end
    end
    let docs': (AST | None) = type_decls_next'
    if
      try
        let extra' = iter.next()
        errs.push(("Module got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _use_decls = use_decls'
    _type_decls = type_decls'
    _docs =
      try docs' as (LitString | None)
      else errs.push(("Module got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Module](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _use_decls.values() do fn(x) end
    for x in _type_decls.values() do fn(x) end
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Module => _create(pos', _use_decls, _type_decls, _docs)
  
  fun val use_decls(): coll.Vec[UseDecl] => _use_decls
  fun val type_decls(): coll.Vec[TypeDecl] => _type_decls
  fun val docs(): (LitString | None) => _docs
  
  fun val with_use_decls(use_decls': coll.Vec[UseDecl]): Module => _create(_pos, use_decls', _type_decls, _docs)
  fun val with_type_decls(type_decls': coll.Vec[TypeDecl]): Module => _create(_pos, _use_decls, type_decls', _docs)
  fun val with_docs(docs': (LitString | None)): Module => _create(_pos, _use_decls, _type_decls, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "use_decls" => _use_decls(index')
    | "type_decls" => _type_decls(index')
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _use_decls.find(child' as UseDecl)
        return _create(_pos, _use_decls.update(i, replace' as UseDecl), _type_decls, _docs)
      end
      try
        let i = _type_decls.find(child' as TypeDecl)
        return _create(_pos, _use_decls, _type_decls.update(i, replace' as TypeDecl), _docs)
      end
      if child' is _docs then
        return _create(_pos, _use_decls, _type_decls, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Module")
    s.push('(')
    s.push('[')
    for (i, v) in _use_decls.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.>push(',').push(' ')
    s.push('[')
    for (i, v) in _type_decls.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val UsePackage is (AST & UseDecl)
  let _pos: SourcePosAny
  
  let _prefix: (Id | None)
  let _package: LitString
  
  new val create(
    prefix': (Id | None) = None,
    package': LitString)
  =>_pos = SourcePosNone
    _prefix = prefix'
    _package = package'
  
  new val _create(pos': SourcePosAny,
    prefix': (Id | None),
    package': LitString)
  =>
    _pos = pos'
    _prefix = prefix'
    _package = package'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let prefix': (AST | None) = try iter.next() else None end
    let package': (AST | None) =
      try iter.next()
      else errs.push(("UsePackage missing required field: package", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("UsePackage got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _prefix =
      try prefix' as (Id | None)
      else errs.push(("UsePackage got incompatible field: prefix", try (prefix' as AST).pos() else SourcePosNone end)); error
      end
    _package =
      try package' as LitString
      else errs.push(("UsePackage got incompatible field: package", try (package' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[UsePackage](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_prefix)
    fn(_package)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): UsePackage => _create(pos', _prefix, _package)
  
  fun val prefix(): (Id | None) => _prefix
  fun val package(): LitString => _package
  
  fun val with_prefix(prefix': (Id | None)): UsePackage => _create(_pos, prefix', _package)
  fun val with_package(package': LitString): UsePackage => _create(_pos, _prefix, package')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "prefix" => _prefix
    | "package" => _package
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _prefix then
        return _create(_pos, replace' as (Id | None), _package)
      end
      if child' is _package then
        return _create(_pos, _prefix, replace' as LitString)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("UsePackage")
    s.push('(')
    s.>append(_prefix.string()).>push(',').push(' ')
    s.>append(_package.string())
    s.push(')')
    consume s

class val UseFFIDecl is (AST & UseDecl)
  let _pos: SourcePosAny
  
  let _name: (Id | LitString)
  let _return_type: TypeArgs
  let _params: Params
  let _partial: (Question | None)
  let _guard: (IfDefCond | None)
  
  new val create(
    name': (Id | LitString),
    return_type': TypeArgs,
    params': Params,
    partial': (Question | None),
    guard': (IfDefCond | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _return_type = return_type'
    _params = params'
    _partial = partial'
    _guard = guard'
  
  new val _create(pos': SourcePosAny,
    name': (Id | LitString),
    return_type': TypeArgs,
    params': Params,
    partial': (Question | None),
    guard': (IfDefCond | None))
  =>
    _pos = pos'
    _name = name'
    _return_type = return_type'
    _params = params'
    _partial = partial'
    _guard = guard'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("UseFFIDecl missing required field: name", pos')); error
      end
    let return_type': (AST | None) =
      try iter.next()
      else errs.push(("UseFFIDecl missing required field: return_type", pos')); error
      end
    let params': (AST | None) =
      try iter.next()
      else errs.push(("UseFFIDecl missing required field: params", pos')); error
      end
    let partial': (AST | None) =
      try iter.next()
      else errs.push(("UseFFIDecl missing required field: partial", pos')); error
      end
    let guard': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("UseFFIDecl got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as (Id | LitString)
      else errs.push(("UseFFIDecl got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _return_type =
      try return_type' as TypeArgs
      else errs.push(("UseFFIDecl got incompatible field: return_type", try (return_type' as AST).pos() else SourcePosNone end)); error
      end
    _params =
      try params' as Params
      else errs.push(("UseFFIDecl got incompatible field: params", try (params' as AST).pos() else SourcePosNone end)); error
      end
    _partial =
      try partial' as (Question | None)
      else errs.push(("UseFFIDecl got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
    _guard =
      try guard' as (IfDefCond | None)
      else errs.push(("UseFFIDecl got incompatible field: guard", try (guard' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[UseFFIDecl](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_return_type)
    fn(_params)
    fn(_partial)
    fn(_guard)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): UseFFIDecl => _create(pos', _name, _return_type, _params, _partial, _guard)
  
  fun val name(): (Id | LitString) => _name
  fun val return_type(): TypeArgs => _return_type
  fun val params(): Params => _params
  fun val partial(): (Question | None) => _partial
  fun val guard(): (IfDefCond | None) => _guard
  
  fun val with_name(name': (Id | LitString)): UseFFIDecl => _create(_pos, name', _return_type, _params, _partial, _guard)
  fun val with_return_type(return_type': TypeArgs): UseFFIDecl => _create(_pos, _name, return_type', _params, _partial, _guard)
  fun val with_params(params': Params): UseFFIDecl => _create(_pos, _name, _return_type, params', _partial, _guard)
  fun val with_partial(partial': (Question | None)): UseFFIDecl => _create(_pos, _name, _return_type, _params, partial', _guard)
  fun val with_guard(guard': (IfDefCond | None)): UseFFIDecl => _create(_pos, _name, _return_type, _params, _partial, guard')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "return_type" => _return_type
    | "params" => _params
    | "partial" => _partial
    | "guard" => _guard
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as (Id | LitString), _return_type, _params, _partial, _guard)
      end
      if child' is _return_type then
        return _create(_pos, _name, replace' as TypeArgs, _params, _partial, _guard)
      end
      if child' is _params then
        return _create(_pos, _name, _return_type, replace' as Params, _partial, _guard)
      end
      if child' is _partial then
        return _create(_pos, _name, _return_type, _params, replace' as (Question | None), _guard)
      end
      if child' is _guard then
        return _create(_pos, _name, _return_type, _params, _partial, replace' as (IfDefCond | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("UseFFIDecl")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_params.string()).>push(',').push(' ')
    s.>append(_partial.string()).>push(',').push(' ')
    s.>append(_guard.string())
    s.push(')')
    consume s

class val TypeAlias is (AST & TypeDecl)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | None)
  let _type_params: (TypeParams | None)
  let _provides: (Type | None)
  let _members: Members
  let _at: (At | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | None),
    type_params': (TypeParams | None),
    provides': (Type | None),
    members': Members,
    at': (At | None),
    docs': (LitString | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("TypeAlias missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let provides': (AST | None) = try iter.next() else None end
    let members': (AST | None) = try iter.next() else Members end
    let at': (AST | None) = try iter.next() else None end
    let docs': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("TypeAlias got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("TypeAlias got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | None)
      else errs.push(("TypeAlias got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("TypeAlias got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _provides =
      try provides' as (Type | None)
      else errs.push(("TypeAlias got incompatible field: provides", try (provides' as AST).pos() else SourcePosNone end)); error
      end
    _members =
      try members' as Members
      else errs.push(("TypeAlias got incompatible field: members", try (members' as AST).pos() else SourcePosNone end)); error
      end
    _at =
      try at' as (At | None)
      else errs.push(("TypeAlias got incompatible field: at", try (at' as AST).pos() else SourcePosNone end)); error
      end
    _docs =
      try docs' as (LitString | None)
      else errs.push(("TypeAlias got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TypeAlias](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_type_params)
    fn(_provides)
    fn(_members)
    fn(_at)
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): TypeAlias => _create(pos', _name, _cap, _type_params, _provides, _members, _at, _docs)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): TypeAlias => _create(_pos, name', _cap, _type_params, _provides, _members, _at, _docs)
  fun val with_cap(cap': (Cap | None)): TypeAlias => _create(_pos, _name, cap', _type_params, _provides, _members, _at, _docs)
  fun val with_type_params(type_params': (TypeParams | None)): TypeAlias => _create(_pos, _name, _cap, type_params', _provides, _members, _at, _docs)
  fun val with_provides(provides': (Type | None)): TypeAlias => _create(_pos, _name, _cap, _type_params, provides', _members, _at, _docs)
  fun val with_members(members': Members): TypeAlias => _create(_pos, _name, _cap, _type_params, _provides, members', _at, _docs)
  fun val with_at(at': (At | None)): TypeAlias => _create(_pos, _name, _cap, _type_params, _provides, _members, at', _docs)
  fun val with_docs(docs': (LitString | None)): TypeAlias => _create(_pos, _name, _cap, _type_params, _provides, _members, _at, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "type_params" => _type_params
    | "provides" => _provides
    | "members" => _members
    | "at" => _at
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _type_params, _provides, _members, _at, _docs)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs)
      end
      if child' is _type_params then
        return _create(_pos, _name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs)
      end
      if child' is _provides then
        return _create(_pos, _name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs)
      end
      if child' is _members then
        return _create(_pos, _name, _cap, _type_params, _provides, replace' as Members, _at, _docs)
      end
      if child' is _at then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs)
      end
      if child' is _docs then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeAlias")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val Interface is (AST & TypeDecl)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | None)
  let _type_params: (TypeParams | None)
  let _provides: (Type | None)
  let _members: Members
  let _at: (At | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | None),
    type_params': (TypeParams | None),
    provides': (Type | None),
    members': Members,
    at': (At | None),
    docs': (LitString | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("Interface missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let provides': (AST | None) = try iter.next() else None end
    let members': (AST | None) = try iter.next() else Members end
    let at': (AST | None) = try iter.next() else None end
    let docs': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Interface got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("Interface got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | None)
      else errs.push(("Interface got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("Interface got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _provides =
      try provides' as (Type | None)
      else errs.push(("Interface got incompatible field: provides", try (provides' as AST).pos() else SourcePosNone end)); error
      end
    _members =
      try members' as Members
      else errs.push(("Interface got incompatible field: members", try (members' as AST).pos() else SourcePosNone end)); error
      end
    _at =
      try at' as (At | None)
      else errs.push(("Interface got incompatible field: at", try (at' as AST).pos() else SourcePosNone end)); error
      end
    _docs =
      try docs' as (LitString | None)
      else errs.push(("Interface got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Interface](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_type_params)
    fn(_provides)
    fn(_members)
    fn(_at)
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Interface => _create(pos', _name, _cap, _type_params, _provides, _members, _at, _docs)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Interface => _create(_pos, name', _cap, _type_params, _provides, _members, _at, _docs)
  fun val with_cap(cap': (Cap | None)): Interface => _create(_pos, _name, cap', _type_params, _provides, _members, _at, _docs)
  fun val with_type_params(type_params': (TypeParams | None)): Interface => _create(_pos, _name, _cap, type_params', _provides, _members, _at, _docs)
  fun val with_provides(provides': (Type | None)): Interface => _create(_pos, _name, _cap, _type_params, provides', _members, _at, _docs)
  fun val with_members(members': Members): Interface => _create(_pos, _name, _cap, _type_params, _provides, members', _at, _docs)
  fun val with_at(at': (At | None)): Interface => _create(_pos, _name, _cap, _type_params, _provides, _members, at', _docs)
  fun val with_docs(docs': (LitString | None)): Interface => _create(_pos, _name, _cap, _type_params, _provides, _members, _at, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "type_params" => _type_params
    | "provides" => _provides
    | "members" => _members
    | "at" => _at
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _type_params, _provides, _members, _at, _docs)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs)
      end
      if child' is _type_params then
        return _create(_pos, _name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs)
      end
      if child' is _provides then
        return _create(_pos, _name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs)
      end
      if child' is _members then
        return _create(_pos, _name, _cap, _type_params, _provides, replace' as Members, _at, _docs)
      end
      if child' is _at then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs)
      end
      if child' is _docs then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Interface")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val Trait is (AST & TypeDecl)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | None)
  let _type_params: (TypeParams | None)
  let _provides: (Type | None)
  let _members: Members
  let _at: (At | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | None),
    type_params': (TypeParams | None),
    provides': (Type | None),
    members': Members,
    at': (At | None),
    docs': (LitString | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("Trait missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let provides': (AST | None) = try iter.next() else None end
    let members': (AST | None) = try iter.next() else Members end
    let at': (AST | None) = try iter.next() else None end
    let docs': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Trait got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("Trait got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | None)
      else errs.push(("Trait got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("Trait got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _provides =
      try provides' as (Type | None)
      else errs.push(("Trait got incompatible field: provides", try (provides' as AST).pos() else SourcePosNone end)); error
      end
    _members =
      try members' as Members
      else errs.push(("Trait got incompatible field: members", try (members' as AST).pos() else SourcePosNone end)); error
      end
    _at =
      try at' as (At | None)
      else errs.push(("Trait got incompatible field: at", try (at' as AST).pos() else SourcePosNone end)); error
      end
    _docs =
      try docs' as (LitString | None)
      else errs.push(("Trait got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Trait](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_type_params)
    fn(_provides)
    fn(_members)
    fn(_at)
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Trait => _create(pos', _name, _cap, _type_params, _provides, _members, _at, _docs)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Trait => _create(_pos, name', _cap, _type_params, _provides, _members, _at, _docs)
  fun val with_cap(cap': (Cap | None)): Trait => _create(_pos, _name, cap', _type_params, _provides, _members, _at, _docs)
  fun val with_type_params(type_params': (TypeParams | None)): Trait => _create(_pos, _name, _cap, type_params', _provides, _members, _at, _docs)
  fun val with_provides(provides': (Type | None)): Trait => _create(_pos, _name, _cap, _type_params, provides', _members, _at, _docs)
  fun val with_members(members': Members): Trait => _create(_pos, _name, _cap, _type_params, _provides, members', _at, _docs)
  fun val with_at(at': (At | None)): Trait => _create(_pos, _name, _cap, _type_params, _provides, _members, at', _docs)
  fun val with_docs(docs': (LitString | None)): Trait => _create(_pos, _name, _cap, _type_params, _provides, _members, _at, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "type_params" => _type_params
    | "provides" => _provides
    | "members" => _members
    | "at" => _at
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _type_params, _provides, _members, _at, _docs)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs)
      end
      if child' is _type_params then
        return _create(_pos, _name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs)
      end
      if child' is _provides then
        return _create(_pos, _name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs)
      end
      if child' is _members then
        return _create(_pos, _name, _cap, _type_params, _provides, replace' as Members, _at, _docs)
      end
      if child' is _at then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs)
      end
      if child' is _docs then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Trait")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val Primitive is (AST & TypeDecl)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | None)
  let _type_params: (TypeParams | None)
  let _provides: (Type | None)
  let _members: Members
  let _at: (At | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | None),
    type_params': (TypeParams | None),
    provides': (Type | None),
    members': Members,
    at': (At | None),
    docs': (LitString | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("Primitive missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let provides': (AST | None) = try iter.next() else None end
    let members': (AST | None) = try iter.next() else Members end
    let at': (AST | None) = try iter.next() else None end
    let docs': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Primitive got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("Primitive got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | None)
      else errs.push(("Primitive got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("Primitive got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _provides =
      try provides' as (Type | None)
      else errs.push(("Primitive got incompatible field: provides", try (provides' as AST).pos() else SourcePosNone end)); error
      end
    _members =
      try members' as Members
      else errs.push(("Primitive got incompatible field: members", try (members' as AST).pos() else SourcePosNone end)); error
      end
    _at =
      try at' as (At | None)
      else errs.push(("Primitive got incompatible field: at", try (at' as AST).pos() else SourcePosNone end)); error
      end
    _docs =
      try docs' as (LitString | None)
      else errs.push(("Primitive got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Primitive](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_type_params)
    fn(_provides)
    fn(_members)
    fn(_at)
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Primitive => _create(pos', _name, _cap, _type_params, _provides, _members, _at, _docs)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Primitive => _create(_pos, name', _cap, _type_params, _provides, _members, _at, _docs)
  fun val with_cap(cap': (Cap | None)): Primitive => _create(_pos, _name, cap', _type_params, _provides, _members, _at, _docs)
  fun val with_type_params(type_params': (TypeParams | None)): Primitive => _create(_pos, _name, _cap, type_params', _provides, _members, _at, _docs)
  fun val with_provides(provides': (Type | None)): Primitive => _create(_pos, _name, _cap, _type_params, provides', _members, _at, _docs)
  fun val with_members(members': Members): Primitive => _create(_pos, _name, _cap, _type_params, _provides, members', _at, _docs)
  fun val with_at(at': (At | None)): Primitive => _create(_pos, _name, _cap, _type_params, _provides, _members, at', _docs)
  fun val with_docs(docs': (LitString | None)): Primitive => _create(_pos, _name, _cap, _type_params, _provides, _members, _at, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "type_params" => _type_params
    | "provides" => _provides
    | "members" => _members
    | "at" => _at
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _type_params, _provides, _members, _at, _docs)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs)
      end
      if child' is _type_params then
        return _create(_pos, _name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs)
      end
      if child' is _provides then
        return _create(_pos, _name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs)
      end
      if child' is _members then
        return _create(_pos, _name, _cap, _type_params, _provides, replace' as Members, _at, _docs)
      end
      if child' is _at then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs)
      end
      if child' is _docs then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Primitive")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val Struct is (AST & TypeDecl)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | None)
  let _type_params: (TypeParams | None)
  let _provides: (Type | None)
  let _members: Members
  let _at: (At | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | None),
    type_params': (TypeParams | None),
    provides': (Type | None),
    members': Members,
    at': (At | None),
    docs': (LitString | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("Struct missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let provides': (AST | None) = try iter.next() else None end
    let members': (AST | None) = try iter.next() else Members end
    let at': (AST | None) = try iter.next() else None end
    let docs': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Struct got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("Struct got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | None)
      else errs.push(("Struct got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("Struct got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _provides =
      try provides' as (Type | None)
      else errs.push(("Struct got incompatible field: provides", try (provides' as AST).pos() else SourcePosNone end)); error
      end
    _members =
      try members' as Members
      else errs.push(("Struct got incompatible field: members", try (members' as AST).pos() else SourcePosNone end)); error
      end
    _at =
      try at' as (At | None)
      else errs.push(("Struct got incompatible field: at", try (at' as AST).pos() else SourcePosNone end)); error
      end
    _docs =
      try docs' as (LitString | None)
      else errs.push(("Struct got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Struct](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_type_params)
    fn(_provides)
    fn(_members)
    fn(_at)
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Struct => _create(pos', _name, _cap, _type_params, _provides, _members, _at, _docs)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Struct => _create(_pos, name', _cap, _type_params, _provides, _members, _at, _docs)
  fun val with_cap(cap': (Cap | None)): Struct => _create(_pos, _name, cap', _type_params, _provides, _members, _at, _docs)
  fun val with_type_params(type_params': (TypeParams | None)): Struct => _create(_pos, _name, _cap, type_params', _provides, _members, _at, _docs)
  fun val with_provides(provides': (Type | None)): Struct => _create(_pos, _name, _cap, _type_params, provides', _members, _at, _docs)
  fun val with_members(members': Members): Struct => _create(_pos, _name, _cap, _type_params, _provides, members', _at, _docs)
  fun val with_at(at': (At | None)): Struct => _create(_pos, _name, _cap, _type_params, _provides, _members, at', _docs)
  fun val with_docs(docs': (LitString | None)): Struct => _create(_pos, _name, _cap, _type_params, _provides, _members, _at, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "type_params" => _type_params
    | "provides" => _provides
    | "members" => _members
    | "at" => _at
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _type_params, _provides, _members, _at, _docs)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs)
      end
      if child' is _type_params then
        return _create(_pos, _name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs)
      end
      if child' is _provides then
        return _create(_pos, _name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs)
      end
      if child' is _members then
        return _create(_pos, _name, _cap, _type_params, _provides, replace' as Members, _at, _docs)
      end
      if child' is _at then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs)
      end
      if child' is _docs then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Struct")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val Class is (AST & TypeDecl)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | None)
  let _type_params: (TypeParams | None)
  let _provides: (Type | None)
  let _members: Members
  let _at: (At | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | None),
    type_params': (TypeParams | None),
    provides': (Type | None),
    members': Members,
    at': (At | None),
    docs': (LitString | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("Class missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let provides': (AST | None) = try iter.next() else None end
    let members': (AST | None) = try iter.next() else Members end
    let at': (AST | None) = try iter.next() else None end
    let docs': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Class got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("Class got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | None)
      else errs.push(("Class got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("Class got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _provides =
      try provides' as (Type | None)
      else errs.push(("Class got incompatible field: provides", try (provides' as AST).pos() else SourcePosNone end)); error
      end
    _members =
      try members' as Members
      else errs.push(("Class got incompatible field: members", try (members' as AST).pos() else SourcePosNone end)); error
      end
    _at =
      try at' as (At | None)
      else errs.push(("Class got incompatible field: at", try (at' as AST).pos() else SourcePosNone end)); error
      end
    _docs =
      try docs' as (LitString | None)
      else errs.push(("Class got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Class](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_type_params)
    fn(_provides)
    fn(_members)
    fn(_at)
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Class => _create(pos', _name, _cap, _type_params, _provides, _members, _at, _docs)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Class => _create(_pos, name', _cap, _type_params, _provides, _members, _at, _docs)
  fun val with_cap(cap': (Cap | None)): Class => _create(_pos, _name, cap', _type_params, _provides, _members, _at, _docs)
  fun val with_type_params(type_params': (TypeParams | None)): Class => _create(_pos, _name, _cap, type_params', _provides, _members, _at, _docs)
  fun val with_provides(provides': (Type | None)): Class => _create(_pos, _name, _cap, _type_params, provides', _members, _at, _docs)
  fun val with_members(members': Members): Class => _create(_pos, _name, _cap, _type_params, _provides, members', _at, _docs)
  fun val with_at(at': (At | None)): Class => _create(_pos, _name, _cap, _type_params, _provides, _members, at', _docs)
  fun val with_docs(docs': (LitString | None)): Class => _create(_pos, _name, _cap, _type_params, _provides, _members, _at, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "type_params" => _type_params
    | "provides" => _provides
    | "members" => _members
    | "at" => _at
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _type_params, _provides, _members, _at, _docs)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs)
      end
      if child' is _type_params then
        return _create(_pos, _name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs)
      end
      if child' is _provides then
        return _create(_pos, _name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs)
      end
      if child' is _members then
        return _create(_pos, _name, _cap, _type_params, _provides, replace' as Members, _at, _docs)
      end
      if child' is _at then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs)
      end
      if child' is _docs then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Class")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val Actor is (AST & TypeDecl)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | None)
  let _type_params: (TypeParams | None)
  let _provides: (Type | None)
  let _members: Members
  let _at: (At | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | None),
    type_params': (TypeParams | None),
    provides': (Type | None),
    members': Members,
    at': (At | None),
    docs': (LitString | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("Actor missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let provides': (AST | None) = try iter.next() else None end
    let members': (AST | None) = try iter.next() else Members end
    let at': (AST | None) = try iter.next() else None end
    let docs': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Actor got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("Actor got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | None)
      else errs.push(("Actor got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("Actor got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _provides =
      try provides' as (Type | None)
      else errs.push(("Actor got incompatible field: provides", try (provides' as AST).pos() else SourcePosNone end)); error
      end
    _members =
      try members' as Members
      else errs.push(("Actor got incompatible field: members", try (members' as AST).pos() else SourcePosNone end)); error
      end
    _at =
      try at' as (At | None)
      else errs.push(("Actor got incompatible field: at", try (at' as AST).pos() else SourcePosNone end)); error
      end
    _docs =
      try docs' as (LitString | None)
      else errs.push(("Actor got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Actor](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_type_params)
    fn(_provides)
    fn(_members)
    fn(_at)
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Actor => _create(pos', _name, _cap, _type_params, _provides, _members, _at, _docs)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Actor => _create(_pos, name', _cap, _type_params, _provides, _members, _at, _docs)
  fun val with_cap(cap': (Cap | None)): Actor => _create(_pos, _name, cap', _type_params, _provides, _members, _at, _docs)
  fun val with_type_params(type_params': (TypeParams | None)): Actor => _create(_pos, _name, _cap, type_params', _provides, _members, _at, _docs)
  fun val with_provides(provides': (Type | None)): Actor => _create(_pos, _name, _cap, _type_params, provides', _members, _at, _docs)
  fun val with_members(members': Members): Actor => _create(_pos, _name, _cap, _type_params, _provides, members', _at, _docs)
  fun val with_at(at': (At | None)): Actor => _create(_pos, _name, _cap, _type_params, _provides, _members, at', _docs)
  fun val with_docs(docs': (LitString | None)): Actor => _create(_pos, _name, _cap, _type_params, _provides, _members, _at, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "type_params" => _type_params
    | "provides" => _provides
    | "members" => _members
    | "at" => _at
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _type_params, _provides, _members, _at, _docs)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs)
      end
      if child' is _type_params then
        return _create(_pos, _name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs)
      end
      if child' is _provides then
        return _create(_pos, _name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs)
      end
      if child' is _members then
        return _create(_pos, _name, _cap, _type_params, _provides, replace' as Members, _at, _docs)
      end
      if child' is _at then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs)
      end
      if child' is _docs then
        return _create(_pos, _name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Actor")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val Members is AST
  let _pos: SourcePosAny
  
  let _fields: coll.Vec[Field]
  let _methods: coll.Vec[Method]
  
  new val create(
    fields': coll.Vec[Field] = coll.Vec[Field],
    methods': coll.Vec[Method] = coll.Vec[Method])
  =>_pos = SourcePosNone
    _fields = fields'
    _methods = methods'
  
  new val _create(pos': SourcePosAny,
    fields': coll.Vec[Field],
    methods': coll.Vec[Method])
  =>
    _pos = pos'
    _fields = fields'
    _methods = methods'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var fields' = coll.Vec[Field]
    var fields_next' = try iter.next() else None end
    while true do
      try fields' = fields'.push(fields_next' as Field) else break end
      try fields_next' = iter.next() else fields_next' = None; break end
    end
    var methods' = coll.Vec[Method]
    var methods_next' = fields_next'
    while true do
      try methods' = methods'.push(methods_next' as Method) else break end
      try methods_next' = iter.next() else methods_next' = None; break end
    end
    if methods_next' isnt None then
      let extra' = methods_next'
      errs.push(("Members got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _fields = fields'
    _methods = methods'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Members](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _fields.values() do fn(x) end
    for x in _methods.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Members => _create(pos', _fields, _methods)
  
  fun val fields(): coll.Vec[Field] => _fields
  fun val methods(): coll.Vec[Method] => _methods
  
  fun val with_fields(fields': coll.Vec[Field]): Members => _create(_pos, fields', _methods)
  fun val with_methods(methods': coll.Vec[Method]): Members => _create(_pos, _fields, methods')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "fields" => _fields(index')
    | "methods" => _methods(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _fields.find(child' as Field)
        return _create(_pos, _fields.update(i, replace' as Field), _methods)
      end
      try
        let i = _methods.find(child' as Method)
        return _create(_pos, _fields, _methods.update(i, replace' as Method))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Members")
    s.push('(')
    s.push('[')
    for (i, v) in _fields.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.>push(',').push(' ')
    s.push('[')
    for (i, v) in _methods.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val FieldLet is (AST & Field)
  let _pos: SourcePosAny
  
  let _name: Id
  let _field_type: Type
  let _default: (Expr | None)
  
  new val create(
    name': Id,
    field_type': Type,
    default': (Expr | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _field_type = field_type'
    _default = default'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    field_type': Type,
    default': (Expr | None))
  =>
    _pos = pos'
    _name = name'
    _field_type = field_type'
    _default = default'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("FieldLet missing required field: name", pos')); error
      end
    let field_type': (AST | None) =
      try iter.next()
      else errs.push(("FieldLet missing required field: field_type", pos')); error
      end
    let default': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("FieldLet got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("FieldLet got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _field_type =
      try field_type' as Type
      else errs.push(("FieldLet got incompatible field: field_type", try (field_type' as AST).pos() else SourcePosNone end)); error
      end
    _default =
      try default' as (Expr | None)
      else errs.push(("FieldLet got incompatible field: default", try (default' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[FieldLet](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_field_type)
    fn(_default)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): FieldLet => _create(pos', _name, _field_type, _default)
  
  fun val name(): Id => _name
  fun val field_type(): Type => _field_type
  fun val default(): (Expr | None) => _default
  
  fun val with_name(name': Id): FieldLet => _create(_pos, name', _field_type, _default)
  fun val with_field_type(field_type': Type): FieldLet => _create(_pos, _name, field_type', _default)
  fun val with_default(default': (Expr | None)): FieldLet => _create(_pos, _name, _field_type, default')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "field_type" => _field_type
    | "default" => _default
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _field_type, _default)
      end
      if child' is _field_type then
        return _create(_pos, _name, replace' as Type, _default)
      end
      if child' is _default then
        return _create(_pos, _name, _field_type, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldLet")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_field_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class val FieldVar is (AST & Field)
  let _pos: SourcePosAny
  
  let _name: Id
  let _field_type: Type
  let _default: (Expr | None)
  
  new val create(
    name': Id,
    field_type': Type,
    default': (Expr | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _field_type = field_type'
    _default = default'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    field_type': Type,
    default': (Expr | None))
  =>
    _pos = pos'
    _name = name'
    _field_type = field_type'
    _default = default'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("FieldVar missing required field: name", pos')); error
      end
    let field_type': (AST | None) =
      try iter.next()
      else errs.push(("FieldVar missing required field: field_type", pos')); error
      end
    let default': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("FieldVar got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("FieldVar got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _field_type =
      try field_type' as Type
      else errs.push(("FieldVar got incompatible field: field_type", try (field_type' as AST).pos() else SourcePosNone end)); error
      end
    _default =
      try default' as (Expr | None)
      else errs.push(("FieldVar got incompatible field: default", try (default' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[FieldVar](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_field_type)
    fn(_default)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): FieldVar => _create(pos', _name, _field_type, _default)
  
  fun val name(): Id => _name
  fun val field_type(): Type => _field_type
  fun val default(): (Expr | None) => _default
  
  fun val with_name(name': Id): FieldVar => _create(_pos, name', _field_type, _default)
  fun val with_field_type(field_type': Type): FieldVar => _create(_pos, _name, field_type', _default)
  fun val with_default(default': (Expr | None)): FieldVar => _create(_pos, _name, _field_type, default')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "field_type" => _field_type
    | "default" => _default
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _field_type, _default)
      end
      if child' is _field_type then
        return _create(_pos, _name, replace' as Type, _default)
      end
      if child' is _default then
        return _create(_pos, _name, _field_type, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldVar")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_field_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class val FieldEmbed is (AST & Field)
  let _pos: SourcePosAny
  
  let _name: Id
  let _field_type: Type
  let _default: (Expr | None)
  
  new val create(
    name': Id,
    field_type': Type,
    default': (Expr | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _field_type = field_type'
    _default = default'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    field_type': Type,
    default': (Expr | None))
  =>
    _pos = pos'
    _name = name'
    _field_type = field_type'
    _default = default'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("FieldEmbed missing required field: name", pos')); error
      end
    let field_type': (AST | None) =
      try iter.next()
      else errs.push(("FieldEmbed missing required field: field_type", pos')); error
      end
    let default': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("FieldEmbed got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("FieldEmbed got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _field_type =
      try field_type' as Type
      else errs.push(("FieldEmbed got incompatible field: field_type", try (field_type' as AST).pos() else SourcePosNone end)); error
      end
    _default =
      try default' as (Expr | None)
      else errs.push(("FieldEmbed got incompatible field: default", try (default' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[FieldEmbed](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_field_type)
    fn(_default)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): FieldEmbed => _create(pos', _name, _field_type, _default)
  
  fun val name(): Id => _name
  fun val field_type(): Type => _field_type
  fun val default(): (Expr | None) => _default
  
  fun val with_name(name': Id): FieldEmbed => _create(_pos, name', _field_type, _default)
  fun val with_field_type(field_type': Type): FieldEmbed => _create(_pos, _name, field_type', _default)
  fun val with_default(default': (Expr | None)): FieldEmbed => _create(_pos, _name, _field_type, default')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "field_type" => _field_type
    | "default" => _default
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _field_type, _default)
      end
      if child' is _field_type then
        return _create(_pos, _name, replace' as Type, _default)
      end
      if child' is _default then
        return _create(_pos, _name, _field_type, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldEmbed")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_field_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class val MethodFun is (AST & Method)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | None)
  let _type_params: (TypeParams | None)
  let _params: Params
  let _return_type: (Type | None)
  let _partial: (Question | None)
  let _guard: (Sequence | None)
  let _body: (Sequence | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    params': Params = Params,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None,
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
    _partial = partial'
    _guard = guard'
    _body = body'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | None),
    type_params': (TypeParams | None),
    params': Params,
    return_type': (Type | None),
    partial': (Question | None),
    guard': (Sequence | None),
    body': (Sequence | None),
    docs': (LitString | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
    _partial = partial'
    _guard = guard'
    _body = body'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("MethodFun missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let params': (AST | None) = try iter.next() else Params end
    let return_type': (AST | None) = try iter.next() else None end
    let partial': (AST | None) = try iter.next() else None end
    let guard': (AST | None) = try iter.next() else None end
    let body': (AST | None) = try iter.next() else None end
    let docs': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("MethodFun got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("MethodFun got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | None)
      else errs.push(("MethodFun got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("MethodFun got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _params =
      try params' as Params
      else errs.push(("MethodFun got incompatible field: params", try (params' as AST).pos() else SourcePosNone end)); error
      end
    _return_type =
      try return_type' as (Type | None)
      else errs.push(("MethodFun got incompatible field: return_type", try (return_type' as AST).pos() else SourcePosNone end)); error
      end
    _partial =
      try partial' as (Question | None)
      else errs.push(("MethodFun got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
    _guard =
      try guard' as (Sequence | None)
      else errs.push(("MethodFun got incompatible field: guard", try (guard' as AST).pos() else SourcePosNone end)); error
      end
    _body =
      try body' as (Sequence | None)
      else errs.push(("MethodFun got incompatible field: body", try (body' as AST).pos() else SourcePosNone end)); error
      end
    _docs =
      try docs' as (LitString | None)
      else errs.push(("MethodFun got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[MethodFun](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_type_params)
    fn(_params)
    fn(_return_type)
    fn(_partial)
    fn(_guard)
    fn(_body)
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): MethodFun => _create(pos', _name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val guard(): (Sequence | None) => _guard
  fun val body(): (Sequence | None) => _body
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): MethodFun => _create(_pos, name', _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs)
  fun val with_cap(cap': (Cap | None)): MethodFun => _create(_pos, _name, cap', _type_params, _params, _return_type, _partial, _guard, _body, _docs)
  fun val with_type_params(type_params': (TypeParams | None)): MethodFun => _create(_pos, _name, _cap, type_params', _params, _return_type, _partial, _guard, _body, _docs)
  fun val with_params(params': Params): MethodFun => _create(_pos, _name, _cap, _type_params, params', _return_type, _partial, _guard, _body, _docs)
  fun val with_return_type(return_type': (Type | None)): MethodFun => _create(_pos, _name, _cap, _type_params, _params, return_type', _partial, _guard, _body, _docs)
  fun val with_partial(partial': (Question | None)): MethodFun => _create(_pos, _name, _cap, _type_params, _params, _return_type, partial', _guard, _body, _docs)
  fun val with_guard(guard': (Sequence | None)): MethodFun => _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, guard', _body, _docs)
  fun val with_body(body': (Sequence | None)): MethodFun => _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, body', _docs)
  fun val with_docs(docs': (LitString | None)): MethodFun => _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "type_params" => _type_params
    | "params" => _params
    | "return_type" => _return_type
    | "partial" => _partial
    | "guard" => _guard
    | "body" => _body
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | None), _type_params, _params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _type_params then
        return _create(_pos, _name, _cap, replace' as (TypeParams | None), _params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _params then
        return _create(_pos, _name, _cap, _type_params, replace' as Params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _return_type then
        return _create(_pos, _name, _cap, _type_params, _params, replace' as (Type | None), _partial, _guard, _body, _docs)
      end
      if child' is _partial then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, replace' as (Question | None), _guard, _body, _docs)
      end
      if child' is _guard then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, replace' as (Sequence | None), _body, _docs)
      end
      if child' is _body then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, replace' as (Sequence | None), _docs)
      end
      if child' is _docs then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodFun")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_params.string()).>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_partial.string()).>push(',').push(' ')
    s.>append(_guard.string()).>push(',').push(' ')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val MethodNew is (AST & Method)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | None)
  let _type_params: (TypeParams | None)
  let _params: Params
  let _return_type: (Type | None)
  let _partial: (Question | None)
  let _guard: (Sequence | None)
  let _body: (Sequence | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    params': Params = Params,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None,
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
    _partial = partial'
    _guard = guard'
    _body = body'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | None),
    type_params': (TypeParams | None),
    params': Params,
    return_type': (Type | None),
    partial': (Question | None),
    guard': (Sequence | None),
    body': (Sequence | None),
    docs': (LitString | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
    _partial = partial'
    _guard = guard'
    _body = body'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("MethodNew missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let params': (AST | None) = try iter.next() else Params end
    let return_type': (AST | None) = try iter.next() else None end
    let partial': (AST | None) = try iter.next() else None end
    let guard': (AST | None) = try iter.next() else None end
    let body': (AST | None) = try iter.next() else None end
    let docs': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("MethodNew got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("MethodNew got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | None)
      else errs.push(("MethodNew got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("MethodNew got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _params =
      try params' as Params
      else errs.push(("MethodNew got incompatible field: params", try (params' as AST).pos() else SourcePosNone end)); error
      end
    _return_type =
      try return_type' as (Type | None)
      else errs.push(("MethodNew got incompatible field: return_type", try (return_type' as AST).pos() else SourcePosNone end)); error
      end
    _partial =
      try partial' as (Question | None)
      else errs.push(("MethodNew got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
    _guard =
      try guard' as (Sequence | None)
      else errs.push(("MethodNew got incompatible field: guard", try (guard' as AST).pos() else SourcePosNone end)); error
      end
    _body =
      try body' as (Sequence | None)
      else errs.push(("MethodNew got incompatible field: body", try (body' as AST).pos() else SourcePosNone end)); error
      end
    _docs =
      try docs' as (LitString | None)
      else errs.push(("MethodNew got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[MethodNew](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_type_params)
    fn(_params)
    fn(_return_type)
    fn(_partial)
    fn(_guard)
    fn(_body)
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): MethodNew => _create(pos', _name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val guard(): (Sequence | None) => _guard
  fun val body(): (Sequence | None) => _body
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): MethodNew => _create(_pos, name', _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs)
  fun val with_cap(cap': (Cap | None)): MethodNew => _create(_pos, _name, cap', _type_params, _params, _return_type, _partial, _guard, _body, _docs)
  fun val with_type_params(type_params': (TypeParams | None)): MethodNew => _create(_pos, _name, _cap, type_params', _params, _return_type, _partial, _guard, _body, _docs)
  fun val with_params(params': Params): MethodNew => _create(_pos, _name, _cap, _type_params, params', _return_type, _partial, _guard, _body, _docs)
  fun val with_return_type(return_type': (Type | None)): MethodNew => _create(_pos, _name, _cap, _type_params, _params, return_type', _partial, _guard, _body, _docs)
  fun val with_partial(partial': (Question | None)): MethodNew => _create(_pos, _name, _cap, _type_params, _params, _return_type, partial', _guard, _body, _docs)
  fun val with_guard(guard': (Sequence | None)): MethodNew => _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, guard', _body, _docs)
  fun val with_body(body': (Sequence | None)): MethodNew => _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, body', _docs)
  fun val with_docs(docs': (LitString | None)): MethodNew => _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "type_params" => _type_params
    | "params" => _params
    | "return_type" => _return_type
    | "partial" => _partial
    | "guard" => _guard
    | "body" => _body
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | None), _type_params, _params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _type_params then
        return _create(_pos, _name, _cap, replace' as (TypeParams | None), _params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _params then
        return _create(_pos, _name, _cap, _type_params, replace' as Params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _return_type then
        return _create(_pos, _name, _cap, _type_params, _params, replace' as (Type | None), _partial, _guard, _body, _docs)
      end
      if child' is _partial then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, replace' as (Question | None), _guard, _body, _docs)
      end
      if child' is _guard then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, replace' as (Sequence | None), _body, _docs)
      end
      if child' is _body then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, replace' as (Sequence | None), _docs)
      end
      if child' is _docs then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodNew")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_params.string()).>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_partial.string()).>push(',').push(' ')
    s.>append(_guard.string()).>push(',').push(' ')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val MethodBe is (AST & Method)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | None)
  let _type_params: (TypeParams | None)
  let _params: Params
  let _return_type: (Type | None)
  let _partial: (Question | None)
  let _guard: (Sequence | None)
  let _body: (Sequence | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    params': Params = Params,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None,
    docs': (LitString | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
    _partial = partial'
    _guard = guard'
    _body = body'
    _docs = docs'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | None),
    type_params': (TypeParams | None),
    params': Params,
    return_type': (Type | None),
    partial': (Question | None),
    guard': (Sequence | None),
    body': (Sequence | None),
    docs': (LitString | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
    _partial = partial'
    _guard = guard'
    _body = body'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("MethodBe missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let params': (AST | None) = try iter.next() else Params end
    let return_type': (AST | None) = try iter.next() else None end
    let partial': (AST | None) = try iter.next() else None end
    let guard': (AST | None) = try iter.next() else None end
    let body': (AST | None) = try iter.next() else None end
    let docs': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("MethodBe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("MethodBe got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | None)
      else errs.push(("MethodBe got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("MethodBe got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _params =
      try params' as Params
      else errs.push(("MethodBe got incompatible field: params", try (params' as AST).pos() else SourcePosNone end)); error
      end
    _return_type =
      try return_type' as (Type | None)
      else errs.push(("MethodBe got incompatible field: return_type", try (return_type' as AST).pos() else SourcePosNone end)); error
      end
    _partial =
      try partial' as (Question | None)
      else errs.push(("MethodBe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
    _guard =
      try guard' as (Sequence | None)
      else errs.push(("MethodBe got incompatible field: guard", try (guard' as AST).pos() else SourcePosNone end)); error
      end
    _body =
      try body' as (Sequence | None)
      else errs.push(("MethodBe got incompatible field: body", try (body' as AST).pos() else SourcePosNone end)); error
      end
    _docs =
      try docs' as (LitString | None)
      else errs.push(("MethodBe got incompatible field: docs", try (docs' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[MethodBe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_type_params)
    fn(_params)
    fn(_return_type)
    fn(_partial)
    fn(_guard)
    fn(_body)
    fn(_docs)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): MethodBe => _create(pos', _name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val guard(): (Sequence | None) => _guard
  fun val body(): (Sequence | None) => _body
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): MethodBe => _create(_pos, name', _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs)
  fun val with_cap(cap': (Cap | None)): MethodBe => _create(_pos, _name, cap', _type_params, _params, _return_type, _partial, _guard, _body, _docs)
  fun val with_type_params(type_params': (TypeParams | None)): MethodBe => _create(_pos, _name, _cap, type_params', _params, _return_type, _partial, _guard, _body, _docs)
  fun val with_params(params': Params): MethodBe => _create(_pos, _name, _cap, _type_params, params', _return_type, _partial, _guard, _body, _docs)
  fun val with_return_type(return_type': (Type | None)): MethodBe => _create(_pos, _name, _cap, _type_params, _params, return_type', _partial, _guard, _body, _docs)
  fun val with_partial(partial': (Question | None)): MethodBe => _create(_pos, _name, _cap, _type_params, _params, _return_type, partial', _guard, _body, _docs)
  fun val with_guard(guard': (Sequence | None)): MethodBe => _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, guard', _body, _docs)
  fun val with_body(body': (Sequence | None)): MethodBe => _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, body', _docs)
  fun val with_docs(docs': (LitString | None)): MethodBe => _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, docs')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "type_params" => _type_params
    | "params" => _params
    | "return_type" => _return_type
    | "partial" => _partial
    | "guard" => _guard
    | "body" => _body
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | None), _type_params, _params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _type_params then
        return _create(_pos, _name, _cap, replace' as (TypeParams | None), _params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _params then
        return _create(_pos, _name, _cap, _type_params, replace' as Params, _return_type, _partial, _guard, _body, _docs)
      end
      if child' is _return_type then
        return _create(_pos, _name, _cap, _type_params, _params, replace' as (Type | None), _partial, _guard, _body, _docs)
      end
      if child' is _partial then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, replace' as (Question | None), _guard, _body, _docs)
      end
      if child' is _guard then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, replace' as (Sequence | None), _body, _docs)
      end
      if child' is _body then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, replace' as (Sequence | None), _docs)
      end
      if child' is _docs then
        return _create(_pos, _name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, replace' as (LitString | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodBe")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_params.string()).>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_partial.string()).>push(',').push(' ')
    s.>append(_guard.string()).>push(',').push(' ')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class val TypeParams is AST
  let _pos: SourcePosAny
  
  let _list: coll.Vec[TypeParam]
  
  new val create(
    list': coll.Vec[TypeParam] = coll.Vec[TypeParam])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[TypeParam])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[TypeParam]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as TypeParam) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("TypeParams got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TypeParams](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): TypeParams => _create(pos', _list)
  
  fun val list(): coll.Vec[TypeParam] => _list
  
  fun val with_list(list': coll.Vec[TypeParam]): TypeParams => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as TypeParam)
        return _create(_pos, _list.update(i, replace' as TypeParam))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeParams")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val TypeParam is AST
  let _pos: SourcePosAny
  
  let _name: Id
  let _constraint: (Type | None)
  let _default: (Type | None)
  
  new val create(
    name': Id,
    constraint': (Type | None) = None,
    default': (Type | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _constraint = constraint'
    _default = default'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    constraint': (Type | None),
    default': (Type | None))
  =>
    _pos = pos'
    _name = name'
    _constraint = constraint'
    _default = default'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("TypeParam missing required field: name", pos')); error
      end
    let constraint': (AST | None) = try iter.next() else None end
    let default': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("TypeParam got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("TypeParam got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _constraint =
      try constraint' as (Type | None)
      else errs.push(("TypeParam got incompatible field: constraint", try (constraint' as AST).pos() else SourcePosNone end)); error
      end
    _default =
      try default' as (Type | None)
      else errs.push(("TypeParam got incompatible field: default", try (default' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TypeParam](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_constraint)
    fn(_default)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): TypeParam => _create(pos', _name, _constraint, _default)
  
  fun val name(): Id => _name
  fun val constraint(): (Type | None) => _constraint
  fun val default(): (Type | None) => _default
  
  fun val with_name(name': Id): TypeParam => _create(_pos, name', _constraint, _default)
  fun val with_constraint(constraint': (Type | None)): TypeParam => _create(_pos, _name, constraint', _default)
  fun val with_default(default': (Type | None)): TypeParam => _create(_pos, _name, _constraint, default')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "constraint" => _constraint
    | "default" => _default
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _constraint, _default)
      end
      if child' is _constraint then
        return _create(_pos, _name, replace' as (Type | None), _default)
      end
      if child' is _default then
        return _create(_pos, _name, _constraint, replace' as (Type | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeParam")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_constraint.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class val TypeArgs is AST
  let _pos: SourcePosAny
  
  let _list: coll.Vec[Type]
  
  new val create(
    list': coll.Vec[Type] = coll.Vec[Type])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[Type])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[Type]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as Type) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("TypeArgs got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TypeArgs](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): TypeArgs => _create(pos', _list)
  
  fun val list(): coll.Vec[Type] => _list
  
  fun val with_list(list': coll.Vec[Type]): TypeArgs => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Type)
        return _create(_pos, _list.update(i, replace' as Type))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeArgs")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val Params is AST
  let _pos: SourcePosAny
  
  let _list: coll.Vec[Param]
  let _ellipsis: (Ellipsis | None)
  
  new val create(
    list': coll.Vec[Param] = coll.Vec[Param],
    ellipsis': (Ellipsis | None) = None)
  =>_pos = SourcePosNone
    _list = list'
    _ellipsis = ellipsis'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[Param],
    ellipsis': (Ellipsis | None))
  =>
    _pos = pos'
    _list = list'
    _ellipsis = ellipsis'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[Param]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as Param) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    let ellipsis': (AST | None) = list_next'
    if
      try
        let extra' = iter.next()
        errs.push(("Params got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _list = list'
    _ellipsis =
      try ellipsis' as (Ellipsis | None)
      else errs.push(("Params got incompatible field: ellipsis", try (ellipsis' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Params](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
    fn(_ellipsis)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Params => _create(pos', _list, _ellipsis)
  
  fun val list(): coll.Vec[Param] => _list
  fun val ellipsis(): (Ellipsis | None) => _ellipsis
  
  fun val with_list(list': coll.Vec[Param]): Params => _create(_pos, list', _ellipsis)
  fun val with_ellipsis(ellipsis': (Ellipsis | None)): Params => _create(_pos, _list, ellipsis')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    | "ellipsis" => _ellipsis
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Param)
        return _create(_pos, _list.update(i, replace' as Param), _ellipsis)
      end
      if child' is _ellipsis then
        return _create(_pos, _list, replace' as (Ellipsis | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Params")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.>push(',').push(' ')
    s.>append(_ellipsis.string())
    s.push(')')
    consume s

class val Param is AST
  let _pos: SourcePosAny
  
  let _name: Id
  let _param_type: (Type | None)
  let _default: (Expr | None)
  
  new val create(
    name': Id,
    param_type': (Type | None) = None,
    default': (Expr | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _param_type = param_type'
    _default = default'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    param_type': (Type | None),
    default': (Expr | None))
  =>
    _pos = pos'
    _name = name'
    _param_type = param_type'
    _default = default'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("Param missing required field: name", pos')); error
      end
    let param_type': (AST | None) = try iter.next() else None end
    let default': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Param got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("Param got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _param_type =
      try param_type' as (Type | None)
      else errs.push(("Param got incompatible field: param_type", try (param_type' as AST).pos() else SourcePosNone end)); error
      end
    _default =
      try default' as (Expr | None)
      else errs.push(("Param got incompatible field: default", try (default' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Param](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_param_type)
    fn(_default)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Param => _create(pos', _name, _param_type, _default)
  
  fun val name(): Id => _name
  fun val param_type(): (Type | None) => _param_type
  fun val default(): (Expr | None) => _default
  
  fun val with_name(name': Id): Param => _create(_pos, name', _param_type, _default)
  fun val with_param_type(param_type': (Type | None)): Param => _create(_pos, _name, param_type', _default)
  fun val with_default(default': (Expr | None)): Param => _create(_pos, _name, _param_type, default')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "param_type" => _param_type
    | "default" => _default
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _param_type, _default)
      end
      if child' is _param_type then
        return _create(_pos, _name, replace' as (Type | None), _default)
      end
      if child' is _default then
        return _create(_pos, _name, _param_type, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Param")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_param_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class val Sequence is (AST & Expr)
  let _pos: SourcePosAny
  
  let _list: coll.Vec[Expr]
  
  new val create(
    list': coll.Vec[Expr] = coll.Vec[Expr])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[Expr])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[Expr]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as Expr) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Sequence got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Sequence](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Sequence => _create(pos', _list)
  
  fun val list(): coll.Vec[Expr] => _list
  
  fun val with_list(list': coll.Vec[Expr]): Sequence => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Expr)
        return _create(_pos, _list.update(i, replace' as Expr))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Sequence")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val Return is (AST & Jump & Expr)
  let _pos: SourcePosAny
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None))
  =>_pos = SourcePosNone
    _value = value'
  
  new val _create(pos': SourcePosAny,
    value': (Expr | None))
  =>
    _pos = pos'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let value': (AST | None) =
      try iter.next()
      else errs.push(("Return missing required field: value", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Return got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("Return got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Return](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_value)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Return => _create(pos', _value)
  
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): Return => _create(_pos, value')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return _create(_pos, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Return")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class val Break is (AST & Jump & Expr)
  let _pos: SourcePosAny
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None))
  =>_pos = SourcePosNone
    _value = value'
  
  new val _create(pos': SourcePosAny,
    value': (Expr | None))
  =>
    _pos = pos'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let value': (AST | None) =
      try iter.next()
      else errs.push(("Break missing required field: value", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Break got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("Break got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Break](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_value)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Break => _create(pos', _value)
  
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): Break => _create(_pos, value')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return _create(_pos, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Break")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class val Continue is (AST & Jump & Expr)
  let _pos: SourcePosAny
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None))
  =>_pos = SourcePosNone
    _value = value'
  
  new val _create(pos': SourcePosAny,
    value': (Expr | None))
  =>
    _pos = pos'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let value': (AST | None) =
      try iter.next()
      else errs.push(("Continue missing required field: value", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Continue got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("Continue got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Continue](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_value)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Continue => _create(pos', _value)
  
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): Continue => _create(_pos, value')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return _create(_pos, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Continue")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class val Error is (AST & Jump & Expr)
  let _pos: SourcePosAny
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None))
  =>_pos = SourcePosNone
    _value = value'
  
  new val _create(pos': SourcePosAny,
    value': (Expr | None))
  =>
    _pos = pos'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let value': (AST | None) =
      try iter.next()
      else errs.push(("Error missing required field: value", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Error got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("Error got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Error](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_value)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Error => _create(pos', _value)
  
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): Error => _create(_pos, value')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return _create(_pos, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Error")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class val CompileIntrinsic is (AST & Jump & Expr)
  let _pos: SourcePosAny
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None))
  =>_pos = SourcePosNone
    _value = value'
  
  new val _create(pos': SourcePosAny,
    value': (Expr | None))
  =>
    _pos = pos'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let value': (AST | None) =
      try iter.next()
      else errs.push(("CompileIntrinsic missing required field: value", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("CompileIntrinsic got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("CompileIntrinsic got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CompileIntrinsic](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_value)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): CompileIntrinsic => _create(pos', _value)
  
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): CompileIntrinsic => _create(_pos, value')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return _create(_pos, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CompileIntrinsic")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class val CompileError is (AST & Jump & Expr)
  let _pos: SourcePosAny
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None))
  =>_pos = SourcePosNone
    _value = value'
  
  new val _create(pos': SourcePosAny,
    value': (Expr | None))
  =>
    _pos = pos'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let value': (AST | None) =
      try iter.next()
      else errs.push(("CompileError missing required field: value", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("CompileError got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("CompileError got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CompileError](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_value)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): CompileError => _create(pos', _value)
  
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): CompileError => _create(_pos, value')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return _create(_pos, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CompileError")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class val IfDefFlag is (AST & IfDefCond)
  let _pos: SourcePosAny
  
  let _name: (Id | LitString)
  
  new val create(
    name': (Id | LitString))
  =>_pos = SourcePosNone
    _name = name'
  
  new val _create(pos': SourcePosAny,
    name': (Id | LitString))
  =>
    _pos = pos'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("IfDefFlag missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("IfDefFlag got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as (Id | LitString)
      else errs.push(("IfDefFlag got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IfDefFlag](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): IfDefFlag => _create(pos', _name)
  
  fun val name(): (Id | LitString) => _name
  
  fun val with_name(name': (Id | LitString)): IfDefFlag => _create(_pos, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as (Id | LitString))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefFlag")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class val IfDefNot is (AST & IfDefCond)
  let _pos: SourcePosAny
  
  let _expr: IfDefCond
  
  new val create(
    expr': IfDefCond)
  =>_pos = SourcePosNone
    _expr = expr'
  
  new val _create(pos': SourcePosAny,
    expr': IfDefCond)
  =>
    _pos = pos'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("IfDefNot missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("IfDefNot got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as IfDefCond
      else errs.push(("IfDefNot got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IfDefNot](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_expr)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): IfDefNot => _create(pos', _expr)
  
  fun val expr(): IfDefCond => _expr
  
  fun val with_expr(expr': IfDefCond): IfDefNot => _create(_pos, expr')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return _create(_pos, replace' as IfDefCond)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefNot")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class val IfDefAnd is (AST & IfDefBinaryOp & IfDefCond)
  let _pos: SourcePosAny
  
  let _left: IfDefCond
  let _right: IfDefCond
  
  new val create(
    left': IfDefCond,
    right': IfDefCond)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': IfDefCond,
    right': IfDefCond)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("IfDefAnd missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("IfDefAnd missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("IfDefAnd got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as IfDefCond
      else errs.push(("IfDefAnd got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as IfDefCond
      else errs.push(("IfDefAnd got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IfDefAnd](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): IfDefAnd => _create(pos', _left, _right)
  
  fun val left(): IfDefCond => _left
  fun val right(): IfDefCond => _right
  
  fun val with_left(left': IfDefCond): IfDefAnd => _create(_pos, left', _right)
  fun val with_right(right': IfDefCond): IfDefAnd => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as IfDefCond, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as IfDefCond)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefAnd")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val IfDefOr is (AST & IfDefBinaryOp & IfDefCond)
  let _pos: SourcePosAny
  
  let _left: IfDefCond
  let _right: IfDefCond
  
  new val create(
    left': IfDefCond,
    right': IfDefCond)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': IfDefCond,
    right': IfDefCond)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("IfDefOr missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("IfDefOr missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("IfDefOr got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as IfDefCond
      else errs.push(("IfDefOr got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as IfDefCond
      else errs.push(("IfDefOr got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IfDefOr](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): IfDefOr => _create(pos', _left, _right)
  
  fun val left(): IfDefCond => _left
  fun val right(): IfDefCond => _right
  
  fun val with_left(left': IfDefCond): IfDefOr => _create(_pos, left', _right)
  fun val with_right(right': IfDefCond): IfDefOr => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as IfDefCond, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as IfDefCond)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefOr")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val IfDef is (AST & Expr)
  let _pos: SourcePosAny
  
  let _condition: IfDefCond
  let _then_body: Sequence
  let _else_body: (Sequence | IfDef | None)
  
  new val create(
    condition': IfDefCond,
    then_body': Sequence,
    else_body': (Sequence | IfDef | None) = None)
  =>_pos = SourcePosNone
    _condition = condition'
    _then_body = then_body'
    _else_body = else_body'
  
  new val _create(pos': SourcePosAny,
    condition': IfDefCond,
    then_body': Sequence,
    else_body': (Sequence | IfDef | None))
  =>
    _pos = pos'
    _condition = condition'
    _then_body = then_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let condition': (AST | None) =
      try iter.next()
      else errs.push(("IfDef missing required field: condition", pos')); error
      end
    let then_body': (AST | None) =
      try iter.next()
      else errs.push(("IfDef missing required field: then_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("IfDef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _condition =
      try condition' as IfDefCond
      else errs.push(("IfDef got incompatible field: condition", try (condition' as AST).pos() else SourcePosNone end)); error
      end
    _then_body =
      try then_body' as Sequence
      else errs.push(("IfDef got incompatible field: then_body", try (then_body' as AST).pos() else SourcePosNone end)); error
      end
    _else_body =
      try else_body' as (Sequence | IfDef | None)
      else errs.push(("IfDef got incompatible field: else_body", try (else_body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IfDef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_condition)
    fn(_then_body)
    fn(_else_body)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): IfDef => _create(pos', _condition, _then_body, _else_body)
  
  fun val condition(): IfDefCond => _condition
  fun val then_body(): Sequence => _then_body
  fun val else_body(): (Sequence | IfDef | None) => _else_body
  
  fun val with_condition(condition': IfDefCond): IfDef => _create(_pos, condition', _then_body, _else_body)
  fun val with_then_body(then_body': Sequence): IfDef => _create(_pos, _condition, then_body', _else_body)
  fun val with_else_body(else_body': (Sequence | IfDef | None)): IfDef => _create(_pos, _condition, _then_body, else_body')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "condition" => _condition
    | "then_body" => _then_body
    | "else_body" => _else_body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _condition then
        return _create(_pos, replace' as IfDefCond, _then_body, _else_body)
      end
      if child' is _then_body then
        return _create(_pos, _condition, replace' as Sequence, _else_body)
      end
      if child' is _else_body then
        return _create(_pos, _condition, _then_body, replace' as (Sequence | IfDef | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDef")
    s.push('(')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_then_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class val IfType is (AST & Expr)
  let _pos: SourcePosAny
  
  let _sub: Type
  let _super: Type
  let _then_body: Sequence
  let _else_body: (Sequence | IfType | None)
  
  new val create(
    sub': Type,
    super': Type,
    then_body': Sequence,
    else_body': (Sequence | IfType | None) = None)
  =>_pos = SourcePosNone
    _sub = sub'
    _super = super'
    _then_body = then_body'
    _else_body = else_body'
  
  new val _create(pos': SourcePosAny,
    sub': Type,
    super': Type,
    then_body': Sequence,
    else_body': (Sequence | IfType | None))
  =>
    _pos = pos'
    _sub = sub'
    _super = super'
    _then_body = then_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let sub': (AST | None) =
      try iter.next()
      else errs.push(("IfType missing required field: sub", pos')); error
      end
    let super': (AST | None) =
      try iter.next()
      else errs.push(("IfType missing required field: super", pos')); error
      end
    let then_body': (AST | None) =
      try iter.next()
      else errs.push(("IfType missing required field: then_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("IfType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _sub =
      try sub' as Type
      else errs.push(("IfType got incompatible field: sub", try (sub' as AST).pos() else SourcePosNone end)); error
      end
    _super =
      try super' as Type
      else errs.push(("IfType got incompatible field: super", try (super' as AST).pos() else SourcePosNone end)); error
      end
    _then_body =
      try then_body' as Sequence
      else errs.push(("IfType got incompatible field: then_body", try (then_body' as AST).pos() else SourcePosNone end)); error
      end
    _else_body =
      try else_body' as (Sequence | IfType | None)
      else errs.push(("IfType got incompatible field: else_body", try (else_body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IfType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_sub)
    fn(_super)
    fn(_then_body)
    fn(_else_body)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): IfType => _create(pos', _sub, _super, _then_body, _else_body)
  
  fun val sub(): Type => _sub
  fun val super(): Type => _super
  fun val then_body(): Sequence => _then_body
  fun val else_body(): (Sequence | IfType | None) => _else_body
  
  fun val with_sub(sub': Type): IfType => _create(_pos, sub', _super, _then_body, _else_body)
  fun val with_super(super': Type): IfType => _create(_pos, _sub, super', _then_body, _else_body)
  fun val with_then_body(then_body': Sequence): IfType => _create(_pos, _sub, _super, then_body', _else_body)
  fun val with_else_body(else_body': (Sequence | IfType | None)): IfType => _create(_pos, _sub, _super, _then_body, else_body')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "sub" => _sub
    | "super" => _super
    | "then_body" => _then_body
    | "else_body" => _else_body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _sub then
        return _create(_pos, replace' as Type, _super, _then_body, _else_body)
      end
      if child' is _super then
        return _create(_pos, _sub, replace' as Type, _then_body, _else_body)
      end
      if child' is _then_body then
        return _create(_pos, _sub, _super, replace' as Sequence, _else_body)
      end
      if child' is _else_body then
        return _create(_pos, _sub, _super, _then_body, replace' as (Sequence | IfType | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfType")
    s.push('(')
    s.>append(_sub.string()).>push(',').push(' ')
    s.>append(_super.string()).>push(',').push(' ')
    s.>append(_then_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class val If is (AST & Expr)
  let _pos: SourcePosAny
  
  let _condition: Sequence
  let _then_body: Sequence
  let _else_body: (Sequence | If | None)
  
  new val create(
    condition': Sequence,
    then_body': Sequence,
    else_body': (Sequence | If | None) = None)
  =>_pos = SourcePosNone
    _condition = condition'
    _then_body = then_body'
    _else_body = else_body'
  
  new val _create(pos': SourcePosAny,
    condition': Sequence,
    then_body': Sequence,
    else_body': (Sequence | If | None))
  =>
    _pos = pos'
    _condition = condition'
    _then_body = then_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let condition': (AST | None) =
      try iter.next()
      else errs.push(("If missing required field: condition", pos')); error
      end
    let then_body': (AST | None) =
      try iter.next()
      else errs.push(("If missing required field: then_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("If got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _condition =
      try condition' as Sequence
      else errs.push(("If got incompatible field: condition", try (condition' as AST).pos() else SourcePosNone end)); error
      end
    _then_body =
      try then_body' as Sequence
      else errs.push(("If got incompatible field: then_body", try (then_body' as AST).pos() else SourcePosNone end)); error
      end
    _else_body =
      try else_body' as (Sequence | If | None)
      else errs.push(("If got incompatible field: else_body", try (else_body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[If](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_condition)
    fn(_then_body)
    fn(_else_body)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): If => _create(pos', _condition, _then_body, _else_body)
  
  fun val condition(): Sequence => _condition
  fun val then_body(): Sequence => _then_body
  fun val else_body(): (Sequence | If | None) => _else_body
  
  fun val with_condition(condition': Sequence): If => _create(_pos, condition', _then_body, _else_body)
  fun val with_then_body(then_body': Sequence): If => _create(_pos, _condition, then_body', _else_body)
  fun val with_else_body(else_body': (Sequence | If | None)): If => _create(_pos, _condition, _then_body, else_body')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "condition" => _condition
    | "then_body" => _then_body
    | "else_body" => _else_body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _condition then
        return _create(_pos, replace' as Sequence, _then_body, _else_body)
      end
      if child' is _then_body then
        return _create(_pos, _condition, replace' as Sequence, _else_body)
      end
      if child' is _else_body then
        return _create(_pos, _condition, _then_body, replace' as (Sequence | If | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("If")
    s.push('(')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_then_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class val While is (AST & Expr)
  let _pos: SourcePosAny
  
  let _condition: Sequence
  let _loop_body: Sequence
  let _else_body: (Sequence | None)
  
  new val create(
    condition': Sequence,
    loop_body': Sequence,
    else_body': (Sequence | None) = None)
  =>_pos = SourcePosNone
    _condition = condition'
    _loop_body = loop_body'
    _else_body = else_body'
  
  new val _create(pos': SourcePosAny,
    condition': Sequence,
    loop_body': Sequence,
    else_body': (Sequence | None))
  =>
    _pos = pos'
    _condition = condition'
    _loop_body = loop_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let condition': (AST | None) =
      try iter.next()
      else errs.push(("While missing required field: condition", pos')); error
      end
    let loop_body': (AST | None) =
      try iter.next()
      else errs.push(("While missing required field: loop_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("While got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _condition =
      try condition' as Sequence
      else errs.push(("While got incompatible field: condition", try (condition' as AST).pos() else SourcePosNone end)); error
      end
    _loop_body =
      try loop_body' as Sequence
      else errs.push(("While got incompatible field: loop_body", try (loop_body' as AST).pos() else SourcePosNone end)); error
      end
    _else_body =
      try else_body' as (Sequence | None)
      else errs.push(("While got incompatible field: else_body", try (else_body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[While](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_condition)
    fn(_loop_body)
    fn(_else_body)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): While => _create(pos', _condition, _loop_body, _else_body)
  
  fun val condition(): Sequence => _condition
  fun val loop_body(): Sequence => _loop_body
  fun val else_body(): (Sequence | None) => _else_body
  
  fun val with_condition(condition': Sequence): While => _create(_pos, condition', _loop_body, _else_body)
  fun val with_loop_body(loop_body': Sequence): While => _create(_pos, _condition, loop_body', _else_body)
  fun val with_else_body(else_body': (Sequence | None)): While => _create(_pos, _condition, _loop_body, else_body')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "condition" => _condition
    | "loop_body" => _loop_body
    | "else_body" => _else_body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _condition then
        return _create(_pos, replace' as Sequence, _loop_body, _else_body)
      end
      if child' is _loop_body then
        return _create(_pos, _condition, replace' as Sequence, _else_body)
      end
      if child' is _else_body then
        return _create(_pos, _condition, _loop_body, replace' as (Sequence | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("While")
    s.push('(')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_loop_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class val Repeat is (AST & Expr)
  let _pos: SourcePosAny
  
  let _loop_body: Sequence
  let _condition: Sequence
  let _else_body: (Sequence | None)
  
  new val create(
    loop_body': Sequence,
    condition': Sequence,
    else_body': (Sequence | None) = None)
  =>_pos = SourcePosNone
    _loop_body = loop_body'
    _condition = condition'
    _else_body = else_body'
  
  new val _create(pos': SourcePosAny,
    loop_body': Sequence,
    condition': Sequence,
    else_body': (Sequence | None))
  =>
    _pos = pos'
    _loop_body = loop_body'
    _condition = condition'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let loop_body': (AST | None) =
      try iter.next()
      else errs.push(("Repeat missing required field: loop_body", pos')); error
      end
    let condition': (AST | None) =
      try iter.next()
      else errs.push(("Repeat missing required field: condition", pos')); error
      end
    let else_body': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Repeat got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _loop_body =
      try loop_body' as Sequence
      else errs.push(("Repeat got incompatible field: loop_body", try (loop_body' as AST).pos() else SourcePosNone end)); error
      end
    _condition =
      try condition' as Sequence
      else errs.push(("Repeat got incompatible field: condition", try (condition' as AST).pos() else SourcePosNone end)); error
      end
    _else_body =
      try else_body' as (Sequence | None)
      else errs.push(("Repeat got incompatible field: else_body", try (else_body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Repeat](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_loop_body)
    fn(_condition)
    fn(_else_body)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Repeat => _create(pos', _loop_body, _condition, _else_body)
  
  fun val loop_body(): Sequence => _loop_body
  fun val condition(): Sequence => _condition
  fun val else_body(): (Sequence | None) => _else_body
  
  fun val with_loop_body(loop_body': Sequence): Repeat => _create(_pos, loop_body', _condition, _else_body)
  fun val with_condition(condition': Sequence): Repeat => _create(_pos, _loop_body, condition', _else_body)
  fun val with_else_body(else_body': (Sequence | None)): Repeat => _create(_pos, _loop_body, _condition, else_body')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "loop_body" => _loop_body
    | "condition" => _condition
    | "else_body" => _else_body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _loop_body then
        return _create(_pos, replace' as Sequence, _condition, _else_body)
      end
      if child' is _condition then
        return _create(_pos, _loop_body, replace' as Sequence, _else_body)
      end
      if child' is _else_body then
        return _create(_pos, _loop_body, _condition, replace' as (Sequence | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Repeat")
    s.push('(')
    s.>append(_loop_body.string()).>push(',').push(' ')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class val For is (AST & Expr)
  let _pos: SourcePosAny
  
  let _refs: (Id | IdTuple)
  let _iterator: Sequence
  let _loop_body: Sequence
  let _else_body: (Sequence | None)
  
  new val create(
    refs': (Id | IdTuple),
    iterator': Sequence,
    loop_body': Sequence,
    else_body': (Sequence | None) = None)
  =>_pos = SourcePosNone
    _refs = refs'
    _iterator = iterator'
    _loop_body = loop_body'
    _else_body = else_body'
  
  new val _create(pos': SourcePosAny,
    refs': (Id | IdTuple),
    iterator': Sequence,
    loop_body': Sequence,
    else_body': (Sequence | None))
  =>
    _pos = pos'
    _refs = refs'
    _iterator = iterator'
    _loop_body = loop_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let refs': (AST | None) =
      try iter.next()
      else errs.push(("For missing required field: refs", pos')); error
      end
    let iterator': (AST | None) =
      try iter.next()
      else errs.push(("For missing required field: iterator", pos')); error
      end
    let loop_body': (AST | None) =
      try iter.next()
      else errs.push(("For missing required field: loop_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("For got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _refs =
      try refs' as (Id | IdTuple)
      else errs.push(("For got incompatible field: refs", try (refs' as AST).pos() else SourcePosNone end)); error
      end
    _iterator =
      try iterator' as Sequence
      else errs.push(("For got incompatible field: iterator", try (iterator' as AST).pos() else SourcePosNone end)); error
      end
    _loop_body =
      try loop_body' as Sequence
      else errs.push(("For got incompatible field: loop_body", try (loop_body' as AST).pos() else SourcePosNone end)); error
      end
    _else_body =
      try else_body' as (Sequence | None)
      else errs.push(("For got incompatible field: else_body", try (else_body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[For](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_refs)
    fn(_iterator)
    fn(_loop_body)
    fn(_else_body)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): For => _create(pos', _refs, _iterator, _loop_body, _else_body)
  
  fun val refs(): (Id | IdTuple) => _refs
  fun val iterator(): Sequence => _iterator
  fun val loop_body(): Sequence => _loop_body
  fun val else_body(): (Sequence | None) => _else_body
  
  fun val with_refs(refs': (Id | IdTuple)): For => _create(_pos, refs', _iterator, _loop_body, _else_body)
  fun val with_iterator(iterator': Sequence): For => _create(_pos, _refs, iterator', _loop_body, _else_body)
  fun val with_loop_body(loop_body': Sequence): For => _create(_pos, _refs, _iterator, loop_body', _else_body)
  fun val with_else_body(else_body': (Sequence | None)): For => _create(_pos, _refs, _iterator, _loop_body, else_body')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "refs" => _refs
    | "iterator" => _iterator
    | "loop_body" => _loop_body
    | "else_body" => _else_body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _refs then
        return _create(_pos, replace' as (Id | IdTuple), _iterator, _loop_body, _else_body)
      end
      if child' is _iterator then
        return _create(_pos, _refs, replace' as Sequence, _loop_body, _else_body)
      end
      if child' is _loop_body then
        return _create(_pos, _refs, _iterator, replace' as Sequence, _else_body)
      end
      if child' is _else_body then
        return _create(_pos, _refs, _iterator, _loop_body, replace' as (Sequence | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("For")
    s.push('(')
    s.>append(_refs.string()).>push(',').push(' ')
    s.>append(_iterator.string()).>push(',').push(' ')
    s.>append(_loop_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class val With is (AST & Expr)
  let _pos: SourcePosAny
  
  let _assigns: AssignTuple
  let _with_body: Sequence
  let _else_body: (Sequence | None)
  
  new val create(
    assigns': AssignTuple,
    with_body': Sequence,
    else_body': (Sequence | None) = None)
  =>_pos = SourcePosNone
    _assigns = assigns'
    _with_body = with_body'
    _else_body = else_body'
  
  new val _create(pos': SourcePosAny,
    assigns': AssignTuple,
    with_body': Sequence,
    else_body': (Sequence | None))
  =>
    _pos = pos'
    _assigns = assigns'
    _with_body = with_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let assigns': (AST | None) =
      try iter.next()
      else errs.push(("With missing required field: assigns", pos')); error
      end
    let with_body': (AST | None) =
      try iter.next()
      else errs.push(("With missing required field: with_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("With got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _assigns =
      try assigns' as AssignTuple
      else errs.push(("With got incompatible field: assigns", try (assigns' as AST).pos() else SourcePosNone end)); error
      end
    _with_body =
      try with_body' as Sequence
      else errs.push(("With got incompatible field: with_body", try (with_body' as AST).pos() else SourcePosNone end)); error
      end
    _else_body =
      try else_body' as (Sequence | None)
      else errs.push(("With got incompatible field: else_body", try (else_body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[With](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_assigns)
    fn(_with_body)
    fn(_else_body)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): With => _create(pos', _assigns, _with_body, _else_body)
  
  fun val assigns(): AssignTuple => _assigns
  fun val with_body(): Sequence => _with_body
  fun val else_body(): (Sequence | None) => _else_body
  
  fun val with_assigns(assigns': AssignTuple): With => _create(_pos, assigns', _with_body, _else_body)
  fun val with_with_body(with_body': Sequence): With => _create(_pos, _assigns, with_body', _else_body)
  fun val with_else_body(else_body': (Sequence | None)): With => _create(_pos, _assigns, _with_body, else_body')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "assigns" => _assigns
    | "with_body" => _with_body
    | "else_body" => _else_body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _assigns then
        return _create(_pos, replace' as AssignTuple, _with_body, _else_body)
      end
      if child' is _with_body then
        return _create(_pos, _assigns, replace' as Sequence, _else_body)
      end
      if child' is _else_body then
        return _create(_pos, _assigns, _with_body, replace' as (Sequence | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("With")
    s.push('(')
    s.>append(_assigns.string()).>push(',').push(' ')
    s.>append(_with_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class val IdTuple is AST
  let _pos: SourcePosAny
  
  let _elements: coll.Vec[(Id | IdTuple)]
  
  new val create(
    elements': coll.Vec[(Id | IdTuple)] = coll.Vec[(Id | IdTuple)])
  =>_pos = SourcePosNone
    _elements = elements'
  
  new val _create(pos': SourcePosAny,
    elements': coll.Vec[(Id | IdTuple)])
  =>
    _pos = pos'
    _elements = elements'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var elements' = coll.Vec[(Id | IdTuple)]
    var elements_next' = try iter.next() else None end
    while true do
      try elements' = elements'.push(elements_next' as (Id | IdTuple)) else break end
      try elements_next' = iter.next() else elements_next' = None; break end
    end
    if elements_next' isnt None then
      let extra' = elements_next'
      errs.push(("IdTuple got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _elements = elements'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IdTuple](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _elements.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): IdTuple => _create(pos', _elements)
  
  fun val elements(): coll.Vec[(Id | IdTuple)] => _elements
  
  fun val with_elements(elements': coll.Vec[(Id | IdTuple)]): IdTuple => _create(_pos, elements')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "elements" => _elements(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _elements.find(child' as (Id | IdTuple))
        return _create(_pos, _elements.update(i, replace' as (Id | IdTuple)))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IdTuple")
    s.push('(')
    s.push('[')
    for (i, v) in _elements.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val AssignTuple is AST
  let _pos: SourcePosAny
  
  let _elements: coll.Vec[Assign]
  
  new val create(
    elements': coll.Vec[Assign] = coll.Vec[Assign])
  =>_pos = SourcePosNone
    _elements = elements'
  
  new val _create(pos': SourcePosAny,
    elements': coll.Vec[Assign])
  =>
    _pos = pos'
    _elements = elements'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var elements' = coll.Vec[Assign]
    var elements_next' = try iter.next() else None end
    while true do
      try elements' = elements'.push(elements_next' as Assign) else break end
      try elements_next' = iter.next() else elements_next' = None; break end
    end
    if elements_next' isnt None then
      let extra' = elements_next'
      errs.push(("AssignTuple got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _elements = elements'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[AssignTuple](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _elements.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): AssignTuple => _create(pos', _elements)
  
  fun val elements(): coll.Vec[Assign] => _elements
  
  fun val with_elements(elements': coll.Vec[Assign]): AssignTuple => _create(_pos, elements')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "elements" => _elements(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _elements.find(child' as Assign)
        return _create(_pos, _elements.update(i, replace' as Assign))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("AssignTuple")
    s.push('(')
    s.push('[')
    for (i, v) in _elements.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val Match is (AST & Expr)
  let _pos: SourcePosAny
  
  let _expr: Sequence
  let _cases: Cases
  let _else_body: (Sequence | None)
  
  new val create(
    expr': Sequence,
    cases': Cases = Cases,
    else_body': (Sequence | None) = None)
  =>_pos = SourcePosNone
    _expr = expr'
    _cases = cases'
    _else_body = else_body'
  
  new val _create(pos': SourcePosAny,
    expr': Sequence,
    cases': Cases,
    else_body': (Sequence | None))
  =>
    _pos = pos'
    _expr = expr'
    _cases = cases'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("Match missing required field: expr", pos')); error
      end
    let cases': (AST | None) = try iter.next() else Cases end
    let else_body': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Match got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Sequence
      else errs.push(("Match got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
    _cases =
      try cases' as Cases
      else errs.push(("Match got incompatible field: cases", try (cases' as AST).pos() else SourcePosNone end)); error
      end
    _else_body =
      try else_body' as (Sequence | None)
      else errs.push(("Match got incompatible field: else_body", try (else_body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Match](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_expr)
    fn(_cases)
    fn(_else_body)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Match => _create(pos', _expr, _cases, _else_body)
  
  fun val expr(): Sequence => _expr
  fun val cases(): Cases => _cases
  fun val else_body(): (Sequence | None) => _else_body
  
  fun val with_expr(expr': Sequence): Match => _create(_pos, expr', _cases, _else_body)
  fun val with_cases(cases': Cases): Match => _create(_pos, _expr, cases', _else_body)
  fun val with_else_body(else_body': (Sequence | None)): Match => _create(_pos, _expr, _cases, else_body')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    | "cases" => _cases
    | "else_body" => _else_body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return _create(_pos, replace' as Sequence, _cases, _else_body)
      end
      if child' is _cases then
        return _create(_pos, _expr, replace' as Cases, _else_body)
      end
      if child' is _else_body then
        return _create(_pos, _expr, _cases, replace' as (Sequence | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Match")
    s.push('(')
    s.>append(_expr.string()).>push(',').push(' ')
    s.>append(_cases.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class val Cases is AST
  let _pos: SourcePosAny
  
  let _list: coll.Vec[Case]
  
  new val create(
    list': coll.Vec[Case] = coll.Vec[Case])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[Case])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[Case]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as Case) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Cases got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Cases](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Cases => _create(pos', _list)
  
  fun val list(): coll.Vec[Case] => _list
  
  fun val with_list(list': coll.Vec[Case]): Cases => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Case)
        return _create(_pos, _list.update(i, replace' as Case))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Cases")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val Case is AST
  let _pos: SourcePosAny
  
  let _expr: Expr
  let _guard: (Sequence | None)
  let _body: (Sequence | None)
  
  new val create(
    expr': Expr,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None)
  =>_pos = SourcePosNone
    _expr = expr'
    _guard = guard'
    _body = body'
  
  new val _create(pos': SourcePosAny,
    expr': Expr,
    guard': (Sequence | None),
    body': (Sequence | None))
  =>
    _pos = pos'
    _expr = expr'
    _guard = guard'
    _body = body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("Case missing required field: expr", pos')); error
      end
    let guard': (AST | None) = try iter.next() else None end
    let body': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Case got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("Case got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
    _guard =
      try guard' as (Sequence | None)
      else errs.push(("Case got incompatible field: guard", try (guard' as AST).pos() else SourcePosNone end)); error
      end
    _body =
      try body' as (Sequence | None)
      else errs.push(("Case got incompatible field: body", try (body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Case](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_expr)
    fn(_guard)
    fn(_body)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Case => _create(pos', _expr, _guard, _body)
  
  fun val expr(): Expr => _expr
  fun val guard(): (Sequence | None) => _guard
  fun val body(): (Sequence | None) => _body
  
  fun val with_expr(expr': Expr): Case => _create(_pos, expr', _guard, _body)
  fun val with_guard(guard': (Sequence | None)): Case => _create(_pos, _expr, guard', _body)
  fun val with_body(body': (Sequence | None)): Case => _create(_pos, _expr, _guard, body')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    | "guard" => _guard
    | "body" => _body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return _create(_pos, replace' as Expr, _guard, _body)
      end
      if child' is _guard then
        return _create(_pos, _expr, replace' as (Sequence | None), _body)
      end
      if child' is _body then
        return _create(_pos, _expr, _guard, replace' as (Sequence | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Case")
    s.push('(')
    s.>append(_expr.string()).>push(',').push(' ')
    s.>append(_guard.string()).>push(',').push(' ')
    s.>append(_body.string())
    s.push(')')
    consume s

class val Try is (AST & Expr)
  let _pos: SourcePosAny
  
  let _body: Sequence
  let _else_body: (Sequence | None)
  let _then_body: (Sequence | None)
  
  new val create(
    body': Sequence,
    else_body': (Sequence | None) = None,
    then_body': (Sequence | None) = None)
  =>_pos = SourcePosNone
    _body = body'
    _else_body = else_body'
    _then_body = then_body'
  
  new val _create(pos': SourcePosAny,
    body': Sequence,
    else_body': (Sequence | None),
    then_body': (Sequence | None))
  =>
    _pos = pos'
    _body = body'
    _else_body = else_body'
    _then_body = then_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let body': (AST | None) =
      try iter.next()
      else errs.push(("Try missing required field: body", pos')); error
      end
    let else_body': (AST | None) = try iter.next() else None end
    let then_body': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Try got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _body =
      try body' as Sequence
      else errs.push(("Try got incompatible field: body", try (body' as AST).pos() else SourcePosNone end)); error
      end
    _else_body =
      try else_body' as (Sequence | None)
      else errs.push(("Try got incompatible field: else_body", try (else_body' as AST).pos() else SourcePosNone end)); error
      end
    _then_body =
      try then_body' as (Sequence | None)
      else errs.push(("Try got incompatible field: then_body", try (then_body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Try](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_body)
    fn(_else_body)
    fn(_then_body)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Try => _create(pos', _body, _else_body, _then_body)
  
  fun val body(): Sequence => _body
  fun val else_body(): (Sequence | None) => _else_body
  fun val then_body(): (Sequence | None) => _then_body
  
  fun val with_body(body': Sequence): Try => _create(_pos, body', _else_body, _then_body)
  fun val with_else_body(else_body': (Sequence | None)): Try => _create(_pos, _body, else_body', _then_body)
  fun val with_then_body(then_body': (Sequence | None)): Try => _create(_pos, _body, _else_body, then_body')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "body" => _body
    | "else_body" => _else_body
    | "then_body" => _then_body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _body then
        return _create(_pos, replace' as Sequence, _else_body, _then_body)
      end
      if child' is _else_body then
        return _create(_pos, _body, replace' as (Sequence | None), _then_body)
      end
      if child' is _then_body then
        return _create(_pos, _body, _else_body, replace' as (Sequence | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Try")
    s.push('(')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_else_body.string()).>push(',').push(' ')
    s.>append(_then_body.string())
    s.push(')')
    consume s

class val Consume is (AST & Expr)
  let _pos: SourcePosAny
  
  let _cap: (Cap | None)
  let _expr: (Reference | This)
  
  new val create(
    cap': (Cap | None),
    expr': (Reference | This))
  =>_pos = SourcePosNone
    _cap = cap'
    _expr = expr'
  
  new val _create(pos': SourcePosAny,
    cap': (Cap | None),
    expr': (Reference | This))
  =>
    _pos = pos'
    _cap = cap'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let cap': (AST | None) =
      try iter.next()
      else errs.push(("Consume missing required field: cap", pos')); error
      end
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("Consume missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Consume got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _cap =
      try cap' as (Cap | None)
      else errs.push(("Consume got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _expr =
      try expr' as (Reference | This)
      else errs.push(("Consume got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Consume](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_cap)
    fn(_expr)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Consume => _create(pos', _cap, _expr)
  
  fun val cap(): (Cap | None) => _cap
  fun val expr(): (Reference | This) => _expr
  
  fun val with_cap(cap': (Cap | None)): Consume => _create(_pos, cap', _expr)
  fun val with_expr(expr': (Reference | This)): Consume => _create(_pos, _cap, expr')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "cap" => _cap
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _cap then
        return _create(_pos, replace' as (Cap | None), _expr)
      end
      if child' is _expr then
        return _create(_pos, _cap, replace' as (Reference | This))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Consume")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_expr.string())
    s.push(')')
    consume s

class val Recover is (AST & Expr)
  let _pos: SourcePosAny
  
  let _cap: (Cap | None)
  let _expr: Sequence
  
  new val create(
    cap': (Cap | None),
    expr': Sequence)
  =>_pos = SourcePosNone
    _cap = cap'
    _expr = expr'
  
  new val _create(pos': SourcePosAny,
    cap': (Cap | None),
    expr': Sequence)
  =>
    _pos = pos'
    _cap = cap'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let cap': (AST | None) =
      try iter.next()
      else errs.push(("Recover missing required field: cap", pos')); error
      end
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("Recover missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Recover got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _cap =
      try cap' as (Cap | None)
      else errs.push(("Recover got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _expr =
      try expr' as Sequence
      else errs.push(("Recover got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Recover](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_cap)
    fn(_expr)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Recover => _create(pos', _cap, _expr)
  
  fun val cap(): (Cap | None) => _cap
  fun val expr(): Sequence => _expr
  
  fun val with_cap(cap': (Cap | None)): Recover => _create(_pos, cap', _expr)
  fun val with_expr(expr': Sequence): Recover => _create(_pos, _cap, expr')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "cap" => _cap
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _cap then
        return _create(_pos, replace' as (Cap | None), _expr)
      end
      if child' is _expr then
        return _create(_pos, _cap, replace' as Sequence)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Recover")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_expr.string())
    s.push(')')
    consume s

class val As is (AST & Expr)
  let _pos: SourcePosAny
  
  let _expr: Expr
  let _as_type: Type
  
  new val create(
    expr': Expr,
    as_type': Type)
  =>_pos = SourcePosNone
    _expr = expr'
    _as_type = as_type'
  
  new val _create(pos': SourcePosAny,
    expr': Expr,
    as_type': Type)
  =>
    _pos = pos'
    _expr = expr'
    _as_type = as_type'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("As missing required field: expr", pos')); error
      end
    let as_type': (AST | None) =
      try iter.next()
      else errs.push(("As missing required field: as_type", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("As got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("As got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
    _as_type =
      try as_type' as Type
      else errs.push(("As got incompatible field: as_type", try (as_type' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[As](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_expr)
    fn(_as_type)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): As => _create(pos', _expr, _as_type)
  
  fun val expr(): Expr => _expr
  fun val as_type(): Type => _as_type
  
  fun val with_expr(expr': Expr): As => _create(_pos, expr', _as_type)
  fun val with_as_type(as_type': Type): As => _create(_pos, _expr, as_type')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    | "as_type" => _as_type
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return _create(_pos, replace' as Expr, _as_type)
      end
      if child' is _as_type then
        return _create(_pos, _expr, replace' as Type)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("As")
    s.push('(')
    s.>append(_expr.string()).>push(',').push(' ')
    s.>append(_as_type.string())
    s.push(')')
    consume s

class val Add is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Add missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Add missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Add got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Add got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("Add got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Add](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Add => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Add => _create(_pos, left', _right)
  fun val with_right(right': Expr): Add => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Add")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val AddUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("AddUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("AddUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("AddUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("AddUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("AddUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[AddUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): AddUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): AddUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): AddUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("AddUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Sub is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Sub missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Sub missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Sub got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Sub got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("Sub got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Sub](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Sub => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Sub => _create(_pos, left', _right)
  fun val with_right(right': Expr): Sub => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Sub")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val SubUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("SubUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("SubUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("SubUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("SubUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("SubUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[SubUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): SubUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): SubUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): SubUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("SubUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Mul is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Mul missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Mul missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Mul got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Mul got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("Mul got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Mul](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Mul => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Mul => _create(_pos, left', _right)
  fun val with_right(right': Expr): Mul => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Mul")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val MulUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("MulUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("MulUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("MulUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("MulUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("MulUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[MulUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): MulUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): MulUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): MulUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MulUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Div is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Div missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Div missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Div got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Div got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("Div got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Div](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Div => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Div => _create(_pos, left', _right)
  fun val with_right(right': Expr): Div => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Div")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val DivUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("DivUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("DivUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("DivUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("DivUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("DivUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[DivUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): DivUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): DivUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): DivUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DivUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Mod is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Mod missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Mod missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Mod got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Mod got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("Mod got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Mod](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Mod => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Mod => _create(_pos, left', _right)
  fun val with_right(right': Expr): Mod => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Mod")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val ModUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("ModUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("ModUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("ModUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("ModUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("ModUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ModUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): ModUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): ModUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): ModUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ModUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val LShift is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("LShift missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("LShift missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("LShift got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("LShift got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("LShift got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LShift](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LShift => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): LShift => _create(_pos, left', _right)
  fun val with_right(right': Expr): LShift => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LShift")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val LShiftUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("LShiftUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("LShiftUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("LShiftUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("LShiftUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("LShiftUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LShiftUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LShiftUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): LShiftUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): LShiftUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LShiftUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val RShift is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("RShift missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("RShift missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("RShift got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("RShift got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("RShift got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[RShift](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): RShift => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): RShift => _create(_pos, left', _right)
  fun val with_right(right': Expr): RShift => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RShift")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val RShiftUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("RShiftUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("RShiftUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("RShiftUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("RShiftUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("RShiftUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[RShiftUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): RShiftUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): RShiftUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): RShiftUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RShiftUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Eq is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Eq missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Eq missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Eq got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Eq got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("Eq got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Eq](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Eq => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Eq => _create(_pos, left', _right)
  fun val with_right(right': Expr): Eq => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Eq")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val EqUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("EqUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("EqUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("EqUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("EqUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("EqUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[EqUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): EqUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): EqUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): EqUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("EqUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val NE is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("NE missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("NE missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("NE got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("NE got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("NE got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NE](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): NE => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): NE => _create(_pos, left', _right)
  fun val with_right(right': Expr): NE => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val NEUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("NEUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("NEUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("NEUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("NEUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("NEUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NEUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): NEUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): NEUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): NEUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NEUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val LT is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("LT missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("LT missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("LT got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("LT got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("LT got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LT](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LT => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): LT => _create(_pos, left', _right)
  fun val with_right(right': Expr): LT => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LT")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val LTUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("LTUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("LTUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("LTUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("LTUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("LTUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LTUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LTUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): LTUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): LTUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LTUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val LE is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("LE missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("LE missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("LE got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("LE got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("LE got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LE](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LE => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): LE => _create(_pos, left', _right)
  fun val with_right(right': Expr): LE => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val LEUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("LEUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("LEUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("LEUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("LEUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("LEUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LEUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LEUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): LEUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): LEUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LEUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val GE is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("GE missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("GE missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("GE got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("GE got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("GE got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[GE](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): GE => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): GE => _create(_pos, left', _right)
  fun val with_right(right': Expr): GE => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val GEUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("GEUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("GEUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("GEUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("GEUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("GEUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[GEUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): GEUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): GEUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): GEUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GEUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val GT is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("GT missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("GT missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("GT got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("GT got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("GT got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[GT](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): GT => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): GT => _create(_pos, left', _right)
  fun val with_right(right': Expr): GT => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GT")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val GTUnsafe is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("GTUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("GTUnsafe missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("GTUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("GTUnsafe got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("GTUnsafe got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[GTUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): GTUnsafe => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): GTUnsafe => _create(_pos, left', _right)
  fun val with_right(right': Expr): GTUnsafe => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GTUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Is is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Is missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Is missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Is got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Is got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("Is got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Is](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Is => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Is => _create(_pos, left', _right)
  fun val with_right(right': Expr): Is => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Is")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Isnt is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Isnt missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Isnt missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Isnt got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Isnt got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("Isnt got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Isnt](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Isnt => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Isnt => _create(_pos, left', _right)
  fun val with_right(right': Expr): Isnt => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Isnt")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val And is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("And missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("And missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("And got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("And got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("And got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[And](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): And => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): And => _create(_pos, left', _right)
  fun val with_right(right': Expr): And => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("And")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Or is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Or missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Or missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Or got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Or got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("Or got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Or](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Or => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Or => _create(_pos, left', _right)
  fun val with_right(right': Expr): Or => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Or")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val XOr is (AST & BinaryOp & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("XOr missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("XOr missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("XOr got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("XOr got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("XOr got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[XOr](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): XOr => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): XOr => _create(_pos, left', _right)
  fun val with_right(right': Expr): XOr => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("XOr")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Not is (AST & UnaryOp & Expr)
  let _pos: SourcePosAny
  
  let _expr: Expr
  
  new val create(
    expr': Expr)
  =>_pos = SourcePosNone
    _expr = expr'
  
  new val _create(pos': SourcePosAny,
    expr': Expr)
  =>
    _pos = pos'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("Not missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Not got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("Not got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Not](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_expr)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Not => _create(pos', _expr)
  
  fun val expr(): Expr => _expr
  
  fun val with_expr(expr': Expr): Not => _create(_pos, expr')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return _create(_pos, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Not")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class val Neg is (AST & UnaryOp & Expr)
  let _pos: SourcePosAny
  
  let _expr: Expr
  
  new val create(
    expr': Expr)
  =>_pos = SourcePosNone
    _expr = expr'
  
  new val _create(pos': SourcePosAny,
    expr': Expr)
  =>
    _pos = pos'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("Neg missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Neg got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("Neg got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Neg](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_expr)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Neg => _create(pos', _expr)
  
  fun val expr(): Expr => _expr
  
  fun val with_expr(expr': Expr): Neg => _create(_pos, expr')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return _create(_pos, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Neg")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class val NegUnsafe is (AST & UnaryOp & Expr)
  let _pos: SourcePosAny
  
  let _expr: Expr
  
  new val create(
    expr': Expr)
  =>_pos = SourcePosNone
    _expr = expr'
  
  new val _create(pos': SourcePosAny,
    expr': Expr)
  =>
    _pos = pos'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("NegUnsafe missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("NegUnsafe got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("NegUnsafe got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NegUnsafe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_expr)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): NegUnsafe => _create(pos', _expr)
  
  fun val expr(): Expr => _expr
  
  fun val with_expr(expr': Expr): NegUnsafe => _create(_pos, expr')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return _create(_pos, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NegUnsafe")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class val AddressOf is (AST & UnaryOp & Expr)
  let _pos: SourcePosAny
  
  let _expr: Expr
  
  new val create(
    expr': Expr)
  =>_pos = SourcePosNone
    _expr = expr'
  
  new val _create(pos': SourcePosAny,
    expr': Expr)
  =>
    _pos = pos'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("AddressOf missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("AddressOf got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("AddressOf got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[AddressOf](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_expr)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): AddressOf => _create(pos', _expr)
  
  fun val expr(): Expr => _expr
  
  fun val with_expr(expr': Expr): AddressOf => _create(_pos, expr')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return _create(_pos, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("AddressOf")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class val DigestOf is (AST & UnaryOp & Expr)
  let _pos: SourcePosAny
  
  let _expr: Expr
  
  new val create(
    expr': Expr)
  =>_pos = SourcePosNone
    _expr = expr'
  
  new val _create(pos': SourcePosAny,
    expr': Expr)
  =>
    _pos = pos'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let expr': (AST | None) =
      try iter.next()
      else errs.push(("DigestOf missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("DigestOf got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("DigestOf got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[DigestOf](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_expr)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): DigestOf => _create(pos', _expr)
  
  fun val expr(): Expr => _expr
  
  fun val with_expr(expr': Expr): DigestOf => _create(_pos, expr')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return _create(_pos, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DigestOf")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class val LocalLet is (AST & Local & Expr)
  let _pos: SourcePosAny
  
  let _name: Id
  let _local_type: (Type | None)
  
  new val create(
    name': Id,
    local_type': (Type | None))
  =>_pos = SourcePosNone
    _name = name'
    _local_type = local_type'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    local_type': (Type | None))
  =>
    _pos = pos'
    _name = name'
    _local_type = local_type'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("LocalLet missing required field: name", pos')); error
      end
    let local_type': (AST | None) =
      try iter.next()
      else errs.push(("LocalLet missing required field: local_type", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("LocalLet got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("LocalLet got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _local_type =
      try local_type' as (Type | None)
      else errs.push(("LocalLet got incompatible field: local_type", try (local_type' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LocalLet](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_local_type)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LocalLet => _create(pos', _name, _local_type)
  
  fun val name(): Id => _name
  fun val local_type(): (Type | None) => _local_type
  
  fun val with_name(name': Id): LocalLet => _create(_pos, name', _local_type)
  fun val with_local_type(local_type': (Type | None)): LocalLet => _create(_pos, _name, local_type')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "local_type" => _local_type
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _local_type)
      end
      if child' is _local_type then
        return _create(_pos, _name, replace' as (Type | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalLet")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_local_type.string())
    s.push(')')
    consume s

class val LocalVar is (AST & Local & Expr)
  let _pos: SourcePosAny
  
  let _name: Id
  let _local_type: (Type | None)
  
  new val create(
    name': Id,
    local_type': (Type | None))
  =>_pos = SourcePosNone
    _name = name'
    _local_type = local_type'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    local_type': (Type | None))
  =>
    _pos = pos'
    _name = name'
    _local_type = local_type'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("LocalVar missing required field: name", pos')); error
      end
    let local_type': (AST | None) =
      try iter.next()
      else errs.push(("LocalVar missing required field: local_type", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("LocalVar got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("LocalVar got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _local_type =
      try local_type' as (Type | None)
      else errs.push(("LocalVar got incompatible field: local_type", try (local_type' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LocalVar](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_local_type)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LocalVar => _create(pos', _name, _local_type)
  
  fun val name(): Id => _name
  fun val local_type(): (Type | None) => _local_type
  
  fun val with_name(name': Id): LocalVar => _create(_pos, name', _local_type)
  fun val with_local_type(local_type': (Type | None)): LocalVar => _create(_pos, _name, local_type')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "local_type" => _local_type
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _local_type)
      end
      if child' is _local_type then
        return _create(_pos, _name, replace' as (Type | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalVar")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_local_type.string())
    s.push(')')
    consume s

class val Assign is (AST & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Expr)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Assign missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Assign missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Assign got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Assign got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Expr
      else errs.push(("Assign got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Assign](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Assign => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Assign => _create(_pos, left', _right)
  fun val with_right(right': Expr): Assign => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Expr)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Assign")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Dot is (AST & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Id
  
  new val create(
    left': Expr,
    right': Id)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Id)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Dot missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Dot missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Dot got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Dot got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Id
      else errs.push(("Dot got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Dot](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Dot => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Id => _right
  
  fun val with_left(left': Expr): Dot => _create(_pos, left', _right)
  fun val with_right(right': Id): Dot => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Dot")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Chain is (AST & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Id
  
  new val create(
    left': Expr,
    right': Id)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Id)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Chain missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Chain missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Chain got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Chain got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Id
      else errs.push(("Chain got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Chain](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Chain => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Id => _right
  
  fun val with_left(left': Expr): Chain => _create(_pos, left', _right)
  fun val with_right(right': Id): Chain => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Chain")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Tilde is (AST & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: Id
  
  new val create(
    left': Expr,
    right': Id)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': Id)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Tilde missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Tilde missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Tilde got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Tilde got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Id
      else errs.push(("Tilde got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Tilde](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Tilde => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): Id => _right
  
  fun val with_left(left': Expr): Tilde => _create(_pos, left', _right)
  fun val with_right(right': Id): Tilde => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Tilde")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Qualify is (AST & Expr)
  let _pos: SourcePosAny
  
  let _left: Expr
  let _right: TypeArgs
  
  new val create(
    left': Expr,
    right': TypeArgs)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Expr,
    right': TypeArgs)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("Qualify missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("Qualify missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Qualify got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Expr
      else errs.push(("Qualify got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as TypeArgs
      else errs.push(("Qualify got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Qualify](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Qualify => _create(pos', _left, _right)
  
  fun val left(): Expr => _left
  fun val right(): TypeArgs => _right
  
  fun val with_left(left': Expr): Qualify => _create(_pos, left', _right)
  fun val with_right(right': TypeArgs): Qualify => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Expr, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as TypeArgs)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Qualify")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val Call is (AST & Expr)
  let _pos: SourcePosAny
  
  let _callable: Expr
  let _args: Args
  let _named_args: NamedArgs
  
  new val create(
    callable': Expr,
    args': Args = Args,
    named_args': NamedArgs = NamedArgs)
  =>_pos = SourcePosNone
    _callable = callable'
    _args = args'
    _named_args = named_args'
  
  new val _create(pos': SourcePosAny,
    callable': Expr,
    args': Args,
    named_args': NamedArgs)
  =>
    _pos = pos'
    _callable = callable'
    _args = args'
    _named_args = named_args'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let callable': (AST | None) =
      try iter.next()
      else errs.push(("Call missing required field: callable", pos')); error
      end
    let args': (AST | None) = try iter.next() else Args end
    let named_args': (AST | None) = try iter.next() else NamedArgs end
    if
      try
        let extra' = iter.next()
        errs.push(("Call got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _callable =
      try callable' as Expr
      else errs.push(("Call got incompatible field: callable", try (callable' as AST).pos() else SourcePosNone end)); error
      end
    _args =
      try args' as Args
      else errs.push(("Call got incompatible field: args", try (args' as AST).pos() else SourcePosNone end)); error
      end
    _named_args =
      try named_args' as NamedArgs
      else errs.push(("Call got incompatible field: named_args", try (named_args' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Call](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_callable)
    fn(_args)
    fn(_named_args)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Call => _create(pos', _callable, _args, _named_args)
  
  fun val callable(): Expr => _callable
  fun val args(): Args => _args
  fun val named_args(): NamedArgs => _named_args
  
  fun val with_callable(callable': Expr): Call => _create(_pos, callable', _args, _named_args)
  fun val with_args(args': Args): Call => _create(_pos, _callable, args', _named_args)
  fun val with_named_args(named_args': NamedArgs): Call => _create(_pos, _callable, _args, named_args')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "callable" => _callable
    | "args" => _args
    | "named_args" => _named_args
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _callable then
        return _create(_pos, replace' as Expr, _args, _named_args)
      end
      if child' is _args then
        return _create(_pos, _callable, replace' as Args, _named_args)
      end
      if child' is _named_args then
        return _create(_pos, _callable, _args, replace' as NamedArgs)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Call")
    s.push('(')
    s.>append(_callable.string()).>push(',').push(' ')
    s.>append(_args.string()).>push(',').push(' ')
    s.>append(_named_args.string())
    s.push(')')
    consume s

class val CallFFI is (AST & Expr)
  let _pos: SourcePosAny
  
  let _name: (Id | LitString)
  let _type_args: (TypeArgs | None)
  let _args: Args
  let _named_args: NamedArgs
  let _partial: (Question | None)
  
  new val create(
    name': (Id | LitString),
    type_args': (TypeArgs | None) = None,
    args': Args = Args,
    named_args': NamedArgs = NamedArgs,
    partial': (Question | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _type_args = type_args'
    _args = args'
    _named_args = named_args'
    _partial = partial'
  
  new val _create(pos': SourcePosAny,
    name': (Id | LitString),
    type_args': (TypeArgs | None),
    args': Args,
    named_args': NamedArgs,
    partial': (Question | None))
  =>
    _pos = pos'
    _name = name'
    _type_args = type_args'
    _args = args'
    _named_args = named_args'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("CallFFI missing required field: name", pos')); error
      end
    let type_args': (AST | None) = try iter.next() else None end
    let args': (AST | None) = try iter.next() else Args end
    let named_args': (AST | None) = try iter.next() else NamedArgs end
    let partial': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("CallFFI got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as (Id | LitString)
      else errs.push(("CallFFI got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _type_args =
      try type_args' as (TypeArgs | None)
      else errs.push(("CallFFI got incompatible field: type_args", try (type_args' as AST).pos() else SourcePosNone end)); error
      end
    _args =
      try args' as Args
      else errs.push(("CallFFI got incompatible field: args", try (args' as AST).pos() else SourcePosNone end)); error
      end
    _named_args =
      try named_args' as NamedArgs
      else errs.push(("CallFFI got incompatible field: named_args", try (named_args' as AST).pos() else SourcePosNone end)); error
      end
    _partial =
      try partial' as (Question | None)
      else errs.push(("CallFFI got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CallFFI](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_type_args)
    fn(_args)
    fn(_named_args)
    fn(_partial)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): CallFFI => _create(pos', _name, _type_args, _args, _named_args, _partial)
  
  fun val name(): (Id | LitString) => _name
  fun val type_args(): (TypeArgs | None) => _type_args
  fun val args(): Args => _args
  fun val named_args(): NamedArgs => _named_args
  fun val partial(): (Question | None) => _partial
  
  fun val with_name(name': (Id | LitString)): CallFFI => _create(_pos, name', _type_args, _args, _named_args, _partial)
  fun val with_type_args(type_args': (TypeArgs | None)): CallFFI => _create(_pos, _name, type_args', _args, _named_args, _partial)
  fun val with_args(args': Args): CallFFI => _create(_pos, _name, _type_args, args', _named_args, _partial)
  fun val with_named_args(named_args': NamedArgs): CallFFI => _create(_pos, _name, _type_args, _args, named_args', _partial)
  fun val with_partial(partial': (Question | None)): CallFFI => _create(_pos, _name, _type_args, _args, _named_args, partial')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "type_args" => _type_args
    | "args" => _args
    | "named_args" => _named_args
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as (Id | LitString), _type_args, _args, _named_args, _partial)
      end
      if child' is _type_args then
        return _create(_pos, _name, replace' as (TypeArgs | None), _args, _named_args, _partial)
      end
      if child' is _args then
        return _create(_pos, _name, _type_args, replace' as Args, _named_args, _partial)
      end
      if child' is _named_args then
        return _create(_pos, _name, _type_args, _args, replace' as NamedArgs, _partial)
      end
      if child' is _partial then
        return _create(_pos, _name, _type_args, _args, _named_args, replace' as (Question | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CallFFI")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_args.string()).>push(',').push(' ')
    s.>append(_args.string()).>push(',').push(' ')
    s.>append(_named_args.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val Args is AST
  let _pos: SourcePosAny
  
  let _list: coll.Vec[Sequence]
  
  new val create(
    list': coll.Vec[Sequence] = coll.Vec[Sequence])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[Sequence])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[Sequence]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as Sequence) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Args got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Args](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Args => _create(pos', _list)
  
  fun val list(): coll.Vec[Sequence] => _list
  
  fun val with_list(list': coll.Vec[Sequence]): Args => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Sequence)
        return _create(_pos, _list.update(i, replace' as Sequence))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Args")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val NamedArgs is AST
  let _pos: SourcePosAny
  
  let _list: coll.Vec[NamedArg]
  
  new val create(
    list': coll.Vec[NamedArg] = coll.Vec[NamedArg])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[NamedArg])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[NamedArg]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as NamedArg) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("NamedArgs got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NamedArgs](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): NamedArgs => _create(pos', _list)
  
  fun val list(): coll.Vec[NamedArg] => _list
  
  fun val with_list(list': coll.Vec[NamedArg]): NamedArgs => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as NamedArg)
        return _create(_pos, _list.update(i, replace' as NamedArg))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NamedArgs")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val NamedArg is AST
  let _pos: SourcePosAny
  
  let _name: Id
  let _value: Sequence
  
  new val create(
    name': Id,
    value': Sequence)
  =>_pos = SourcePosNone
    _name = name'
    _value = value'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    value': Sequence)
  =>
    _pos = pos'
    _name = name'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("NamedArg missing required field: name", pos')); error
      end
    let value': (AST | None) =
      try iter.next()
      else errs.push(("NamedArg missing required field: value", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("NamedArg got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("NamedArg got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _value =
      try value' as Sequence
      else errs.push(("NamedArg got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NamedArg](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_value)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): NamedArg => _create(pos', _name, _value)
  
  fun val name(): Id => _name
  fun val value(): Sequence => _value
  
  fun val with_name(name': Id): NamedArg => _create(_pos, name', _value)
  fun val with_value(value': Sequence): NamedArg => _create(_pos, _name, value')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _value)
      end
      if child' is _value then
        return _create(_pos, _name, replace' as Sequence)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NamedArg")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_value.string())
    s.push(')')
    consume s

class val Lambda is (AST & Expr)
  let _pos: SourcePosAny
  
  let _method_cap: (Cap | None)
  let _name: (Id | None)
  let _type_params: (TypeParams | None)
  let _params: Params
  let _captures: (LambdaCaptures | None)
  let _return_type: (Type | None)
  let _partial: (Question | None)
  let _body: Sequence
  let _object_cap: (Cap | None)
  
  new val create(
    method_cap': (Cap | None) = None,
    name': (Id | None) = None,
    type_params': (TypeParams | None) = None,
    params': Params = Params,
    captures': (LambdaCaptures | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    body': Sequence = Sequence,
    object_cap': (Cap | None) = None)
  =>_pos = SourcePosNone
    _method_cap = method_cap'
    _name = name'
    _type_params = type_params'
    _params = params'
    _captures = captures'
    _return_type = return_type'
    _partial = partial'
    _body = body'
    _object_cap = object_cap'
  
  new val _create(pos': SourcePosAny,
    method_cap': (Cap | None),
    name': (Id | None),
    type_params': (TypeParams | None),
    params': Params,
    captures': (LambdaCaptures | None),
    return_type': (Type | None),
    partial': (Question | None),
    body': Sequence,
    object_cap': (Cap | None))
  =>
    _pos = pos'
    _method_cap = method_cap'
    _name = name'
    _type_params = type_params'
    _params = params'
    _captures = captures'
    _return_type = return_type'
    _partial = partial'
    _body = body'
    _object_cap = object_cap'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let method_cap': (AST | None) = try iter.next() else None end
    let name': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let params': (AST | None) = try iter.next() else Params end
    let captures': (AST | None) = try iter.next() else None end
    let return_type': (AST | None) = try iter.next() else None end
    let partial': (AST | None) = try iter.next() else None end
    let body': (AST | None) = try iter.next() else Sequence end
    let object_cap': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Lambda got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _method_cap =
      try method_cap' as (Cap | None)
      else errs.push(("Lambda got incompatible field: method_cap", try (method_cap' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as (Id | None)
      else errs.push(("Lambda got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("Lambda got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _params =
      try params' as Params
      else errs.push(("Lambda got incompatible field: params", try (params' as AST).pos() else SourcePosNone end)); error
      end
    _captures =
      try captures' as (LambdaCaptures | None)
      else errs.push(("Lambda got incompatible field: captures", try (captures' as AST).pos() else SourcePosNone end)); error
      end
    _return_type =
      try return_type' as (Type | None)
      else errs.push(("Lambda got incompatible field: return_type", try (return_type' as AST).pos() else SourcePosNone end)); error
      end
    _partial =
      try partial' as (Question | None)
      else errs.push(("Lambda got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
    _body =
      try body' as Sequence
      else errs.push(("Lambda got incompatible field: body", try (body' as AST).pos() else SourcePosNone end)); error
      end
    _object_cap =
      try object_cap' as (Cap | None)
      else errs.push(("Lambda got incompatible field: object_cap", try (object_cap' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Lambda](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_method_cap)
    fn(_name)
    fn(_type_params)
    fn(_params)
    fn(_captures)
    fn(_return_type)
    fn(_partial)
    fn(_body)
    fn(_object_cap)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Lambda => _create(pos', _method_cap, _name, _type_params, _params, _captures, _return_type, _partial, _body, _object_cap)
  
  fun val method_cap(): (Cap | None) => _method_cap
  fun val name(): (Id | None) => _name
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val captures(): (LambdaCaptures | None) => _captures
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val body(): Sequence => _body
  fun val object_cap(): (Cap | None) => _object_cap
  
  fun val with_method_cap(method_cap': (Cap | None)): Lambda => _create(_pos, method_cap', _name, _type_params, _params, _captures, _return_type, _partial, _body, _object_cap)
  fun val with_name(name': (Id | None)): Lambda => _create(_pos, _method_cap, name', _type_params, _params, _captures, _return_type, _partial, _body, _object_cap)
  fun val with_type_params(type_params': (TypeParams | None)): Lambda => _create(_pos, _method_cap, _name, type_params', _params, _captures, _return_type, _partial, _body, _object_cap)
  fun val with_params(params': Params): Lambda => _create(_pos, _method_cap, _name, _type_params, params', _captures, _return_type, _partial, _body, _object_cap)
  fun val with_captures(captures': (LambdaCaptures | None)): Lambda => _create(_pos, _method_cap, _name, _type_params, _params, captures', _return_type, _partial, _body, _object_cap)
  fun val with_return_type(return_type': (Type | None)): Lambda => _create(_pos, _method_cap, _name, _type_params, _params, _captures, return_type', _partial, _body, _object_cap)
  fun val with_partial(partial': (Question | None)): Lambda => _create(_pos, _method_cap, _name, _type_params, _params, _captures, _return_type, partial', _body, _object_cap)
  fun val with_body(body': Sequence): Lambda => _create(_pos, _method_cap, _name, _type_params, _params, _captures, _return_type, _partial, body', _object_cap)
  fun val with_object_cap(object_cap': (Cap | None)): Lambda => _create(_pos, _method_cap, _name, _type_params, _params, _captures, _return_type, _partial, _body, object_cap')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "method_cap" => _method_cap
    | "name" => _name
    | "type_params" => _type_params
    | "params" => _params
    | "captures" => _captures
    | "return_type" => _return_type
    | "partial" => _partial
    | "body" => _body
    | "object_cap" => _object_cap
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _method_cap then
        return _create(_pos, replace' as (Cap | None), _name, _type_params, _params, _captures, _return_type, _partial, _body, _object_cap)
      end
      if child' is _name then
        return _create(_pos, _method_cap, replace' as (Id | None), _type_params, _params, _captures, _return_type, _partial, _body, _object_cap)
      end
      if child' is _type_params then
        return _create(_pos, _method_cap, _name, replace' as (TypeParams | None), _params, _captures, _return_type, _partial, _body, _object_cap)
      end
      if child' is _params then
        return _create(_pos, _method_cap, _name, _type_params, replace' as Params, _captures, _return_type, _partial, _body, _object_cap)
      end
      if child' is _captures then
        return _create(_pos, _method_cap, _name, _type_params, _params, replace' as (LambdaCaptures | None), _return_type, _partial, _body, _object_cap)
      end
      if child' is _return_type then
        return _create(_pos, _method_cap, _name, _type_params, _params, _captures, replace' as (Type | None), _partial, _body, _object_cap)
      end
      if child' is _partial then
        return _create(_pos, _method_cap, _name, _type_params, _params, _captures, _return_type, replace' as (Question | None), _body, _object_cap)
      end
      if child' is _body then
        return _create(_pos, _method_cap, _name, _type_params, _params, _captures, _return_type, _partial, replace' as Sequence, _object_cap)
      end
      if child' is _object_cap then
        return _create(_pos, _method_cap, _name, _type_params, _params, _captures, _return_type, _partial, _body, replace' as (Cap | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Lambda")
    s.push('(')
    s.>append(_method_cap.string()).>push(',').push(' ')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_params.string()).>push(',').push(' ')
    s.>append(_captures.string()).>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_partial.string()).>push(',').push(' ')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_object_cap.string())
    s.push(')')
    consume s

class val LambdaCaptures is AST
  let _pos: SourcePosAny
  
  let _list: coll.Vec[LambdaCapture]
  
  new val create(
    list': coll.Vec[LambdaCapture] = coll.Vec[LambdaCapture])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[LambdaCapture])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[LambdaCapture]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as LambdaCapture) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("LambdaCaptures got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LambdaCaptures](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LambdaCaptures => _create(pos', _list)
  
  fun val list(): coll.Vec[LambdaCapture] => _list
  
  fun val with_list(list': coll.Vec[LambdaCapture]): LambdaCaptures => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as LambdaCapture)
        return _create(_pos, _list.update(i, replace' as LambdaCapture))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LambdaCaptures")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val LambdaCapture is AST
  let _pos: SourcePosAny
  
  let _name: Id
  let _local_type: (Type | None)
  let _expr: (Expr | None)
  
  new val create(
    name': Id,
    local_type': (Type | None) = None,
    expr': (Expr | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _local_type = local_type'
    _expr = expr'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    local_type': (Type | None),
    expr': (Expr | None))
  =>
    _pos = pos'
    _name = name'
    _local_type = local_type'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("LambdaCapture missing required field: name", pos')); error
      end
    let local_type': (AST | None) = try iter.next() else None end
    let expr': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("LambdaCapture got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("LambdaCapture got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _local_type =
      try local_type' as (Type | None)
      else errs.push(("LambdaCapture got incompatible field: local_type", try (local_type' as AST).pos() else SourcePosNone end)); error
      end
    _expr =
      try expr' as (Expr | None)
      else errs.push(("LambdaCapture got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LambdaCapture](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_local_type)
    fn(_expr)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LambdaCapture => _create(pos', _name, _local_type, _expr)
  
  fun val name(): Id => _name
  fun val local_type(): (Type | None) => _local_type
  fun val expr(): (Expr | None) => _expr
  
  fun val with_name(name': Id): LambdaCapture => _create(_pos, name', _local_type, _expr)
  fun val with_local_type(local_type': (Type | None)): LambdaCapture => _create(_pos, _name, local_type', _expr)
  fun val with_expr(expr': (Expr | None)): LambdaCapture => _create(_pos, _name, _local_type, expr')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "local_type" => _local_type
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _local_type, _expr)
      end
      if child' is _local_type then
        return _create(_pos, _name, replace' as (Type | None), _expr)
      end
      if child' is _expr then
        return _create(_pos, _name, _local_type, replace' as (Expr | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LambdaCapture")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_local_type.string()).>push(',').push(' ')
    s.>append(_expr.string())
    s.push(')')
    consume s

class val Object is (AST & Expr)
  let _pos: SourcePosAny
  
  let _cap: (Cap | None)
  let _provides: (Type | None)
  let _members: (Members | None)
  
  new val create(
    cap': (Cap | None) = None,
    provides': (Type | None) = None,
    members': (Members | None) = None)
  =>_pos = SourcePosNone
    _cap = cap'
    _provides = provides'
    _members = members'
  
  new val _create(pos': SourcePosAny,
    cap': (Cap | None),
    provides': (Type | None),
    members': (Members | None))
  =>
    _pos = pos'
    _cap = cap'
    _provides = provides'
    _members = members'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let cap': (AST | None) = try iter.next() else None end
    let provides': (AST | None) = try iter.next() else None end
    let members': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("Object got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _cap =
      try cap' as (Cap | None)
      else errs.push(("Object got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _provides =
      try provides' as (Type | None)
      else errs.push(("Object got incompatible field: provides", try (provides' as AST).pos() else SourcePosNone end)); error
      end
    _members =
      try members' as (Members | None)
      else errs.push(("Object got incompatible field: members", try (members' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Object](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_cap)
    fn(_provides)
    fn(_members)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Object => _create(pos', _cap, _provides, _members)
  
  fun val cap(): (Cap | None) => _cap
  fun val provides(): (Type | None) => _provides
  fun val members(): (Members | None) => _members
  
  fun val with_cap(cap': (Cap | None)): Object => _create(_pos, cap', _provides, _members)
  fun val with_provides(provides': (Type | None)): Object => _create(_pos, _cap, provides', _members)
  fun val with_members(members': (Members | None)): Object => _create(_pos, _cap, _provides, members')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "cap" => _cap
    | "provides" => _provides
    | "members" => _members
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _cap then
        return _create(_pos, replace' as (Cap | None), _provides, _members)
      end
      if child' is _provides then
        return _create(_pos, _cap, replace' as (Type | None), _members)
      end
      if child' is _members then
        return _create(_pos, _cap, _provides, replace' as (Members | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Object")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string())
    s.push(')')
    consume s

class val LitArray is (AST & Expr)
  let _pos: SourcePosAny
  
  let _elem_type: (Type | None)
  let _sequence: Sequence
  
  new val create(
    elem_type': (Type | None) = None,
    sequence': Sequence = Sequence)
  =>_pos = SourcePosNone
    _elem_type = elem_type'
    _sequence = sequence'
  
  new val _create(pos': SourcePosAny,
    elem_type': (Type | None),
    sequence': Sequence)
  =>
    _pos = pos'
    _elem_type = elem_type'
    _sequence = sequence'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let elem_type': (AST | None) = try iter.next() else None end
    let sequence': (AST | None) = try iter.next() else Sequence end
    if
      try
        let extra' = iter.next()
        errs.push(("LitArray got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _elem_type =
      try elem_type' as (Type | None)
      else errs.push(("LitArray got incompatible field: elem_type", try (elem_type' as AST).pos() else SourcePosNone end)); error
      end
    _sequence =
      try sequence' as Sequence
      else errs.push(("LitArray got incompatible field: sequence", try (sequence' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitArray](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_elem_type)
    fn(_sequence)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LitArray => _create(pos', _elem_type, _sequence)
  
  fun val elem_type(): (Type | None) => _elem_type
  fun val sequence(): Sequence => _sequence
  
  fun val with_elem_type(elem_type': (Type | None)): LitArray => _create(_pos, elem_type', _sequence)
  fun val with_sequence(sequence': Sequence): LitArray => _create(_pos, _elem_type, sequence')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "elem_type" => _elem_type
    | "sequence" => _sequence
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _elem_type then
        return _create(_pos, replace' as (Type | None), _sequence)
      end
      if child' is _sequence then
        return _create(_pos, _elem_type, replace' as Sequence)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitArray")
    s.push('(')
    s.>append(_elem_type.string()).>push(',').push(' ')
    s.>append(_sequence.string())
    s.push(')')
    consume s

class val Tuple is (AST & Expr)
  let _pos: SourcePosAny
  
  let _elements: coll.Vec[Sequence]
  
  new val create(
    elements': coll.Vec[Sequence] = coll.Vec[Sequence])
  =>_pos = SourcePosNone
    _elements = elements'
  
  new val _create(pos': SourcePosAny,
    elements': coll.Vec[Sequence])
  =>
    _pos = pos'
    _elements = elements'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var elements' = coll.Vec[Sequence]
    var elements_next' = try iter.next() else None end
    while true do
      try elements' = elements'.push(elements_next' as Sequence) else break end
      try elements_next' = iter.next() else elements_next' = None; break end
    end
    if elements_next' isnt None then
      let extra' = elements_next'
      errs.push(("Tuple got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _elements = elements'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Tuple](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _elements.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Tuple => _create(pos', _elements)
  
  fun val elements(): coll.Vec[Sequence] => _elements
  
  fun val with_elements(elements': coll.Vec[Sequence]): Tuple => _create(_pos, elements')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "elements" => _elements(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _elements.find(child' as Sequence)
        return _create(_pos, _elements.update(i, replace' as Sequence))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Tuple")
    s.push('(')
    s.push('[')
    for (i, v) in _elements.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val This is (AST & Expr)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("This got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[This](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): This => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("This")
    consume s

class val LitTrue is (AST & LitBool & Expr)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("LitTrue got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitTrue](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LitTrue => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitTrue")
    consume s

class val LitFalse is (AST & LitBool & Expr)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("LitFalse got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitFalse](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LitFalse => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitFalse")
    consume s

class val LitInteger is (AST & Expr)
  let _pos: SourcePosAny
  let _value: U128
  new val create(value': U128) =>(_pos, _value) = (SourcePosNone, value')
  new val _create(pos': SourcePosAny, value': U128) =>(_pos, _value) = (pos', value')
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    _value =
      try
        _ASTUtil.parse_lit_integer(_pos)
      else
        errs.push(("LitInteger failed to parse value", _pos)); true
        error
      end
    
    if
      try
        let extra' = iter.next()
        errs.push(("LitInteger got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitInteger](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LitInteger => _create(pos', _value)
  
  fun val value(): U128 => _value
  fun val with_value(value': U128): LitInteger => _create(_pos, value')
  fun string(): String iso^ =>
    recover
      String.>append("LitInteger(").>append(_value.string()).>push(')')
    end

class val LitFloat is (AST & Expr)
  let _pos: SourcePosAny
  let _value: F64
  new val create(value': F64) =>(_pos, _value) = (SourcePosNone, value')
  new val _create(pos': SourcePosAny, value': F64) =>(_pos, _value) = (pos', value')
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    _value =
      try
        _ASTUtil.parse_lit_float(_pos)
      else
        errs.push(("LitFloat failed to parse value", _pos)); true
        error
      end
    
    if
      try
        let extra' = iter.next()
        errs.push(("LitFloat got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitFloat](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LitFloat => _create(pos', _value)
  
  fun val value(): F64 => _value
  fun val with_value(value': F64): LitFloat => _create(_pos, value')
  fun string(): String iso^ =>
    recover
      String.>append("LitFloat(").>append(_value.string()).>push(')')
    end

class val LitString is (AST & Expr)
  let _pos: SourcePosAny
  let _value: String
  new val create(value': String) =>(_pos, _value) = (SourcePosNone, value')
  new val _create(pos': SourcePosAny, value': String) =>(_pos, _value) = (pos', value')
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    _value =
      try
        _ASTUtil.parse_lit_string(_pos)
      else
        errs.push(("LitString failed to parse value", _pos)); true
        error
      end
    
    if
      try
        let extra' = iter.next()
        errs.push(("LitString got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitString](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LitString => _create(pos', _value)
  
  fun val value(): String => _value
  fun val with_value(value': String): LitString => _create(_pos, value')
  fun string(): String iso^ =>
    recover
      String.>append("LitString(").>append(_value.string()).>push(')')
    end

class val LitCharacter is (AST & Expr)
  let _pos: SourcePosAny
  let _value: U8
  new val create(value': U8) =>(_pos, _value) = (SourcePosNone, value')
  new val _create(pos': SourcePosAny, value': U8) =>(_pos, _value) = (pos', value')
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    _value =
      try
        _ASTUtil.parse_lit_character(_pos)
      else
        errs.push(("LitCharacter failed to parse value", _pos)); true
        error
      end
    
    if
      try
        let extra' = iter.next()
        errs.push(("LitCharacter got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitCharacter](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LitCharacter => _create(pos', _value)
  
  fun val value(): U8 => _value
  fun val with_value(value': U8): LitCharacter => _create(_pos, value')
  fun string(): String iso^ =>
    recover
      String.>append("LitCharacter(").>append(_value.string()).>push(')')
    end

class val LitLocation is (AST & Expr)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("LitLocation got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitLocation](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LitLocation => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitLocation")
    consume s

class val Reference is (AST & Expr)
  let _pos: SourcePosAny
  
  let _name: Id
  
  new val create(
    name': Id)
  =>_pos = SourcePosNone
    _name = name'
  
  new val _create(pos': SourcePosAny,
    name': Id)
  =>
    _pos = pos'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("Reference missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("Reference got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("Reference got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Reference](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Reference => _create(pos', _name)
  
  fun val name(): Id => _name
  
  fun val with_name(name': Id): Reference => _create(_pos, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Reference")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class val DontCare is (AST & Expr)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("DontCare got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[DontCare](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): DontCare => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DontCare")
    consume s

class val PackageRef is (AST & Expr)
  let _pos: SourcePosAny
  
  let _name: Id
  
  new val create(
    name': Id)
  =>_pos = SourcePosNone
    _name = name'
  
  new val _create(pos': SourcePosAny,
    name': Id)
  =>
    _pos = pos'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("PackageRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("PackageRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("PackageRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[PackageRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): PackageRef => _create(pos', _name)
  
  fun val name(): Id => _name
  
  fun val with_name(name': Id): PackageRef => _create(_pos, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("PackageRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class val MethodFunRef is (AST & MethodRef & Expr)
  let _pos: SourcePosAny
  
  let _receiver: Expr
  let _name: (Id | TypeArgs)
  
  new val create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>_pos = SourcePosNone
    _receiver = receiver'
    _name = name'
  
  new val _create(pos': SourcePosAny,
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
    _pos = pos'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let receiver': (AST | None) =
      try iter.next()
      else errs.push(("MethodFunRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()
      else errs.push(("MethodFunRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("MethodFunRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _receiver =
      try receiver' as Expr
      else errs.push(("MethodFunRef got incompatible field: receiver", try (receiver' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as (Id | TypeArgs)
      else errs.push(("MethodFunRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[MethodFunRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_receiver)
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): MethodFunRef => _create(pos', _receiver, _name)
  
  fun val receiver(): Expr => _receiver
  fun val name(): (Id | TypeArgs) => _name
  
  fun val with_receiver(receiver': Expr): MethodFunRef => _create(_pos, receiver', _name)
  fun val with_name(name': (Id | TypeArgs)): MethodFunRef => _create(_pos, _receiver, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "receiver" => _receiver
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _receiver then
        return _create(_pos, replace' as Expr, _name)
      end
      if child' is _name then
        return _create(_pos, _receiver, replace' as (Id | TypeArgs))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodFunRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class val MethodNewRef is (AST & MethodRef & Expr)
  let _pos: SourcePosAny
  
  let _receiver: Expr
  let _name: (Id | TypeArgs)
  
  new val create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>_pos = SourcePosNone
    _receiver = receiver'
    _name = name'
  
  new val _create(pos': SourcePosAny,
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
    _pos = pos'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let receiver': (AST | None) =
      try iter.next()
      else errs.push(("MethodNewRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()
      else errs.push(("MethodNewRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("MethodNewRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _receiver =
      try receiver' as Expr
      else errs.push(("MethodNewRef got incompatible field: receiver", try (receiver' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as (Id | TypeArgs)
      else errs.push(("MethodNewRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[MethodNewRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_receiver)
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): MethodNewRef => _create(pos', _receiver, _name)
  
  fun val receiver(): Expr => _receiver
  fun val name(): (Id | TypeArgs) => _name
  
  fun val with_receiver(receiver': Expr): MethodNewRef => _create(_pos, receiver', _name)
  fun val with_name(name': (Id | TypeArgs)): MethodNewRef => _create(_pos, _receiver, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "receiver" => _receiver
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _receiver then
        return _create(_pos, replace' as Expr, _name)
      end
      if child' is _name then
        return _create(_pos, _receiver, replace' as (Id | TypeArgs))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodNewRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class val MethodBeRef is (AST & MethodRef & Expr)
  let _pos: SourcePosAny
  
  let _receiver: Expr
  let _name: (Id | TypeArgs)
  
  new val create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>_pos = SourcePosNone
    _receiver = receiver'
    _name = name'
  
  new val _create(pos': SourcePosAny,
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
    _pos = pos'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let receiver': (AST | None) =
      try iter.next()
      else errs.push(("MethodBeRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()
      else errs.push(("MethodBeRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("MethodBeRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _receiver =
      try receiver' as Expr
      else errs.push(("MethodBeRef got incompatible field: receiver", try (receiver' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as (Id | TypeArgs)
      else errs.push(("MethodBeRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[MethodBeRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_receiver)
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): MethodBeRef => _create(pos', _receiver, _name)
  
  fun val receiver(): Expr => _receiver
  fun val name(): (Id | TypeArgs) => _name
  
  fun val with_receiver(receiver': Expr): MethodBeRef => _create(_pos, receiver', _name)
  fun val with_name(name': (Id | TypeArgs)): MethodBeRef => _create(_pos, _receiver, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "receiver" => _receiver
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _receiver then
        return _create(_pos, replace' as Expr, _name)
      end
      if child' is _name then
        return _create(_pos, _receiver, replace' as (Id | TypeArgs))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodBeRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class val TypeRef is (AST & Expr)
  let _pos: SourcePosAny
  
  let _package: Expr
  let _name: (Id | TypeArgs)
  
  new val create(
    package': Expr,
    name': (Id | TypeArgs))
  =>_pos = SourcePosNone
    _package = package'
    _name = name'
  
  new val _create(pos': SourcePosAny,
    package': Expr,
    name': (Id | TypeArgs))
  =>
    _pos = pos'
    _package = package'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let package': (AST | None) =
      try iter.next()
      else errs.push(("TypeRef missing required field: package", pos')); error
      end
    let name': (AST | None) =
      try iter.next()
      else errs.push(("TypeRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("TypeRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _package =
      try package' as Expr
      else errs.push(("TypeRef got incompatible field: package", try (package' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as (Id | TypeArgs)
      else errs.push(("TypeRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TypeRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_package)
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): TypeRef => _create(pos', _package, _name)
  
  fun val package(): Expr => _package
  fun val name(): (Id | TypeArgs) => _name
  
  fun val with_package(package': Expr): TypeRef => _create(_pos, package', _name)
  fun val with_name(name': (Id | TypeArgs)): TypeRef => _create(_pos, _package, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "package" => _package
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _package then
        return _create(_pos, replace' as Expr, _name)
      end
      if child' is _name then
        return _create(_pos, _package, replace' as (Id | TypeArgs))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeRef")
    s.push('(')
    s.>append(_package.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class val FieldLetRef is (AST & FieldRef & Expr)
  let _pos: SourcePosAny
  
  let _receiver: Expr
  let _name: Id
  
  new val create(
    receiver': Expr,
    name': Id)
  =>_pos = SourcePosNone
    _receiver = receiver'
    _name = name'
  
  new val _create(pos': SourcePosAny,
    receiver': Expr,
    name': Id)
  =>
    _pos = pos'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let receiver': (AST | None) =
      try iter.next()
      else errs.push(("FieldLetRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()
      else errs.push(("FieldLetRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("FieldLetRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _receiver =
      try receiver' as Expr
      else errs.push(("FieldLetRef got incompatible field: receiver", try (receiver' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as Id
      else errs.push(("FieldLetRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[FieldLetRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_receiver)
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): FieldLetRef => _create(pos', _receiver, _name)
  
  fun val receiver(): Expr => _receiver
  fun val name(): Id => _name
  
  fun val with_receiver(receiver': Expr): FieldLetRef => _create(_pos, receiver', _name)
  fun val with_name(name': Id): FieldLetRef => _create(_pos, _receiver, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "receiver" => _receiver
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _receiver then
        return _create(_pos, replace' as Expr, _name)
      end
      if child' is _name then
        return _create(_pos, _receiver, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldLetRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class val FieldVarRef is (AST & FieldRef & Expr)
  let _pos: SourcePosAny
  
  let _receiver: Expr
  let _name: Id
  
  new val create(
    receiver': Expr,
    name': Id)
  =>_pos = SourcePosNone
    _receiver = receiver'
    _name = name'
  
  new val _create(pos': SourcePosAny,
    receiver': Expr,
    name': Id)
  =>
    _pos = pos'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let receiver': (AST | None) =
      try iter.next()
      else errs.push(("FieldVarRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()
      else errs.push(("FieldVarRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("FieldVarRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _receiver =
      try receiver' as Expr
      else errs.push(("FieldVarRef got incompatible field: receiver", try (receiver' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as Id
      else errs.push(("FieldVarRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[FieldVarRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_receiver)
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): FieldVarRef => _create(pos', _receiver, _name)
  
  fun val receiver(): Expr => _receiver
  fun val name(): Id => _name
  
  fun val with_receiver(receiver': Expr): FieldVarRef => _create(_pos, receiver', _name)
  fun val with_name(name': Id): FieldVarRef => _create(_pos, _receiver, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "receiver" => _receiver
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _receiver then
        return _create(_pos, replace' as Expr, _name)
      end
      if child' is _name then
        return _create(_pos, _receiver, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldVarRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class val FieldEmbedRef is (AST & FieldRef & Expr)
  let _pos: SourcePosAny
  
  let _receiver: Expr
  let _name: Id
  
  new val create(
    receiver': Expr,
    name': Id)
  =>_pos = SourcePosNone
    _receiver = receiver'
    _name = name'
  
  new val _create(pos': SourcePosAny,
    receiver': Expr,
    name': Id)
  =>
    _pos = pos'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let receiver': (AST | None) =
      try iter.next()
      else errs.push(("FieldEmbedRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()
      else errs.push(("FieldEmbedRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("FieldEmbedRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _receiver =
      try receiver' as Expr
      else errs.push(("FieldEmbedRef got incompatible field: receiver", try (receiver' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as Id
      else errs.push(("FieldEmbedRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[FieldEmbedRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_receiver)
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): FieldEmbedRef => _create(pos', _receiver, _name)
  
  fun val receiver(): Expr => _receiver
  fun val name(): Id => _name
  
  fun val with_receiver(receiver': Expr): FieldEmbedRef => _create(_pos, receiver', _name)
  fun val with_name(name': Id): FieldEmbedRef => _create(_pos, _receiver, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "receiver" => _receiver
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _receiver then
        return _create(_pos, replace' as Expr, _name)
      end
      if child' is _name then
        return _create(_pos, _receiver, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldEmbedRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class val TupleElementRef is (AST & Expr)
  let _pos: SourcePosAny
  
  let _receiver: Expr
  let _name: LitInteger
  
  new val create(
    receiver': Expr,
    name': LitInteger)
  =>_pos = SourcePosNone
    _receiver = receiver'
    _name = name'
  
  new val _create(pos': SourcePosAny,
    receiver': Expr,
    name': LitInteger)
  =>
    _pos = pos'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let receiver': (AST | None) =
      try iter.next()
      else errs.push(("TupleElementRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()
      else errs.push(("TupleElementRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("TupleElementRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _receiver =
      try receiver' as Expr
      else errs.push(("TupleElementRef got incompatible field: receiver", try (receiver' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as LitInteger
      else errs.push(("TupleElementRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TupleElementRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_receiver)
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): TupleElementRef => _create(pos', _receiver, _name)
  
  fun val receiver(): Expr => _receiver
  fun val name(): LitInteger => _name
  
  fun val with_receiver(receiver': Expr): TupleElementRef => _create(_pos, receiver', _name)
  fun val with_name(name': LitInteger): TupleElementRef => _create(_pos, _receiver, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "receiver" => _receiver
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _receiver then
        return _create(_pos, replace' as Expr, _name)
      end
      if child' is _name then
        return _create(_pos, _receiver, replace' as LitInteger)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TupleElementRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class val LocalLetRef is (AST & LocalRef & Expr)
  let _pos: SourcePosAny
  
  let _name: Id
  
  new val create(
    name': Id)
  =>_pos = SourcePosNone
    _name = name'
  
  new val _create(pos': SourcePosAny,
    name': Id)
  =>
    _pos = pos'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("LocalLetRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("LocalLetRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("LocalLetRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LocalLetRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LocalLetRef => _create(pos', _name)
  
  fun val name(): Id => _name
  
  fun val with_name(name': Id): LocalLetRef => _create(_pos, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalLetRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class val LocalVarRef is (AST & LocalRef & Expr)
  let _pos: SourcePosAny
  
  let _name: Id
  
  new val create(
    name': Id)
  =>_pos = SourcePosNone
    _name = name'
  
  new val _create(pos': SourcePosAny,
    name': Id)
  =>
    _pos = pos'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("LocalVarRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("LocalVarRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("LocalVarRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LocalVarRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LocalVarRef => _create(pos', _name)
  
  fun val name(): Id => _name
  
  fun val with_name(name': Id): LocalVarRef => _create(_pos, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalVarRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class val ParamRef is (AST & LocalRef & Expr)
  let _pos: SourcePosAny
  
  let _name: Id
  
  new val create(
    name': Id)
  =>_pos = SourcePosNone
    _name = name'
  
  new val _create(pos': SourcePosAny,
    name': Id)
  =>
    _pos = pos'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("ParamRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("ParamRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("ParamRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ParamRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): ParamRef => _create(pos', _name)
  
  fun val name(): Id => _name
  
  fun val with_name(name': Id): ParamRef => _create(_pos, name')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ParamRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class val ViewpointType is (AST & Type)
  let _pos: SourcePosAny
  
  let _left: Type
  let _right: Type
  
  new val create(
    left': Type,
    right': Type)
  =>_pos = SourcePosNone
    _left = left'
    _right = right'
  
  new val _create(pos': SourcePosAny,
    left': Type,
    right': Type)
  =>
    _pos = pos'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let left': (AST | None) =
      try iter.next()
      else errs.push(("ViewpointType missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()
      else errs.push(("ViewpointType missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()
        errs.push(("ViewpointType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _left =
      try left' as Type
      else errs.push(("ViewpointType got incompatible field: left", try (left' as AST).pos() else SourcePosNone end)); error
      end
    _right =
      try right' as Type
      else errs.push(("ViewpointType got incompatible field: right", try (right' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ViewpointType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_left)
    fn(_right)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): ViewpointType => _create(pos', _left, _right)
  
  fun val left(): Type => _left
  fun val right(): Type => _right
  
  fun val with_left(left': Type): ViewpointType => _create(_pos, left', _right)
  fun val with_right(right': Type): ViewpointType => _create(_pos, _left, right')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return _create(_pos, replace' as Type, _right)
      end
      if child' is _right then
        return _create(_pos, _left, replace' as Type)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ViewpointType")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class val UnionType is (AST & Type)
  let _pos: SourcePosAny
  
  let _list: coll.Vec[Type]
  
  new val create(
    list': coll.Vec[Type] = coll.Vec[Type])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[Type])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[Type]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as Type) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("UnionType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[UnionType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): UnionType => _create(pos', _list)
  
  fun val list(): coll.Vec[Type] => _list
  
  fun val with_list(list': coll.Vec[Type]): UnionType => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Type)
        return _create(_pos, _list.update(i, replace' as Type))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("UnionType")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val IsectType is (AST & Type)
  let _pos: SourcePosAny
  
  let _list: coll.Vec[Type]
  
  new val create(
    list': coll.Vec[Type] = coll.Vec[Type])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[Type])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[Type]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as Type) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("IsectType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IsectType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): IsectType => _create(pos', _list)
  
  fun val list(): coll.Vec[Type] => _list
  
  fun val with_list(list': coll.Vec[Type]): IsectType => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Type)
        return _create(_pos, _list.update(i, replace' as Type))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IsectType")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val TupleType is (AST & Type)
  let _pos: SourcePosAny
  
  let _list: coll.Vec[Type]
  
  new val create(
    list': coll.Vec[Type] = coll.Vec[Type])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[Type])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[Type]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as Type) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("TupleType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TupleType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): TupleType => _create(pos', _list)
  
  fun val list(): coll.Vec[Type] => _list
  
  fun val with_list(list': coll.Vec[Type]): TupleType => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Type)
        return _create(_pos, _list.update(i, replace' as Type))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TupleType")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val NominalType is (AST & Type)
  let _pos: SourcePosAny
  
  let _name: Id
  let _package: (Id | None)
  let _type_args: (TypeArgs | None)
  let _cap: (Cap | GenCap | None)
  let _cap_mod: (CapMod | None)
  
  new val create(
    name': Id,
    package': (Id | None) = None,
    type_args': (TypeArgs | None) = None,
    cap': (Cap | GenCap | None) = None,
    cap_mod': (CapMod | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _package = package'
    _type_args = type_args'
    _cap = cap'
    _cap_mod = cap_mod'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    package': (Id | None),
    type_args': (TypeArgs | None),
    cap': (Cap | GenCap | None),
    cap_mod': (CapMod | None))
  =>
    _pos = pos'
    _name = name'
    _package = package'
    _type_args = type_args'
    _cap = cap'
    _cap_mod = cap_mod'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("NominalType missing required field: name", pos')); error
      end
    let package': (AST | None) = try iter.next() else None end
    let type_args': (AST | None) = try iter.next() else None end
    let cap': (AST | None) = try iter.next() else None end
    let cap_mod': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("NominalType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("NominalType got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _package =
      try package' as (Id | None)
      else errs.push(("NominalType got incompatible field: package", try (package' as AST).pos() else SourcePosNone end)); error
      end
    _type_args =
      try type_args' as (TypeArgs | None)
      else errs.push(("NominalType got incompatible field: type_args", try (type_args' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | GenCap | None)
      else errs.push(("NominalType got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _cap_mod =
      try cap_mod' as (CapMod | None)
      else errs.push(("NominalType got incompatible field: cap_mod", try (cap_mod' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NominalType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_package)
    fn(_type_args)
    fn(_cap)
    fn(_cap_mod)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): NominalType => _create(pos', _name, _package, _type_args, _cap, _cap_mod)
  
  fun val name(): Id => _name
  fun val package(): (Id | None) => _package
  fun val type_args(): (TypeArgs | None) => _type_args
  fun val cap(): (Cap | GenCap | None) => _cap
  fun val cap_mod(): (CapMod | None) => _cap_mod
  
  fun val with_name(name': Id): NominalType => _create(_pos, name', _package, _type_args, _cap, _cap_mod)
  fun val with_package(package': (Id | None)): NominalType => _create(_pos, _name, package', _type_args, _cap, _cap_mod)
  fun val with_type_args(type_args': (TypeArgs | None)): NominalType => _create(_pos, _name, _package, type_args', _cap, _cap_mod)
  fun val with_cap(cap': (Cap | GenCap | None)): NominalType => _create(_pos, _name, _package, _type_args, cap', _cap_mod)
  fun val with_cap_mod(cap_mod': (CapMod | None)): NominalType => _create(_pos, _name, _package, _type_args, _cap, cap_mod')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "package" => _package
    | "type_args" => _type_args
    | "cap" => _cap
    | "cap_mod" => _cap_mod
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _package, _type_args, _cap, _cap_mod)
      end
      if child' is _package then
        return _create(_pos, _name, replace' as (Id | None), _type_args, _cap, _cap_mod)
      end
      if child' is _type_args then
        return _create(_pos, _name, _package, replace' as (TypeArgs | None), _cap, _cap_mod)
      end
      if child' is _cap then
        return _create(_pos, _name, _package, _type_args, replace' as (Cap | GenCap | None), _cap_mod)
      end
      if child' is _cap_mod then
        return _create(_pos, _name, _package, _type_args, _cap, replace' as (CapMod | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NominalType")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_package.string()).>push(',').push(' ')
    s.>append(_type_args.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_cap_mod.string())
    s.push(')')
    consume s

class val FunType is (AST & Type)
  let _pos: SourcePosAny
  
  let _cap: Cap
  let _type_params: (TypeParams | None)
  let _params: Params
  let _return_type: (Type | None)
  
  new val create(
    cap': Cap,
    type_params': (TypeParams | None) = None,
    params': Params = Params,
    return_type': (Type | None) = None)
  =>_pos = SourcePosNone
    _cap = cap'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
  
  new val _create(pos': SourcePosAny,
    cap': Cap,
    type_params': (TypeParams | None),
    params': Params,
    return_type': (Type | None))
  =>
    _pos = pos'
    _cap = cap'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let cap': (AST | None) =
      try iter.next()
      else errs.push(("FunType missing required field: cap", pos')); error
      end
    let type_params': (AST | None) = try iter.next() else None end
    let params': (AST | None) = try iter.next() else Params end
    let return_type': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("FunType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _cap =
      try cap' as Cap
      else errs.push(("FunType got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("FunType got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _params =
      try params' as Params
      else errs.push(("FunType got incompatible field: params", try (params' as AST).pos() else SourcePosNone end)); error
      end
    _return_type =
      try return_type' as (Type | None)
      else errs.push(("FunType got incompatible field: return_type", try (return_type' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[FunType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_cap)
    fn(_type_params)
    fn(_params)
    fn(_return_type)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): FunType => _create(pos', _cap, _type_params, _params, _return_type)
  
  fun val cap(): Cap => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val return_type(): (Type | None) => _return_type
  
  fun val with_cap(cap': Cap): FunType => _create(_pos, cap', _type_params, _params, _return_type)
  fun val with_type_params(type_params': (TypeParams | None)): FunType => _create(_pos, _cap, type_params', _params, _return_type)
  fun val with_params(params': Params): FunType => _create(_pos, _cap, _type_params, params', _return_type)
  fun val with_return_type(return_type': (Type | None)): FunType => _create(_pos, _cap, _type_params, _params, return_type')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "cap" => _cap
    | "type_params" => _type_params
    | "params" => _params
    | "return_type" => _return_type
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _cap then
        return _create(_pos, replace' as Cap, _type_params, _params, _return_type)
      end
      if child' is _type_params then
        return _create(_pos, _cap, replace' as (TypeParams | None), _params, _return_type)
      end
      if child' is _params then
        return _create(_pos, _cap, _type_params, replace' as Params, _return_type)
      end
      if child' is _return_type then
        return _create(_pos, _cap, _type_params, _params, replace' as (Type | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FunType")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_params.string()).>push(',').push(' ')
    s.>append(_return_type.string())
    s.push(')')
    consume s

class val LambdaType is (AST & Type)
  let _pos: SourcePosAny
  
  let _method_cap: (Cap | None)
  let _name: (Id | None)
  let _type_params: (TypeParams | None)
  let _param_types: TupleType
  let _return_type: (Type | None)
  let _partial: (Question | None)
  let _object_cap: (Cap | GenCap | None)
  let _cap_mod: (CapMod | None)
  
  new val create(
    method_cap': (Cap | None) = None,
    name': (Id | None) = None,
    type_params': (TypeParams | None) = None,
    param_types': TupleType = TupleType,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    object_cap': (Cap | GenCap | None) = None,
    cap_mod': (CapMod | None) = None)
  =>_pos = SourcePosNone
    _method_cap = method_cap'
    _name = name'
    _type_params = type_params'
    _param_types = param_types'
    _return_type = return_type'
    _partial = partial'
    _object_cap = object_cap'
    _cap_mod = cap_mod'
  
  new val _create(pos': SourcePosAny,
    method_cap': (Cap | None),
    name': (Id | None),
    type_params': (TypeParams | None),
    param_types': TupleType,
    return_type': (Type | None),
    partial': (Question | None),
    object_cap': (Cap | GenCap | None),
    cap_mod': (CapMod | None))
  =>
    _pos = pos'
    _method_cap = method_cap'
    _name = name'
    _type_params = type_params'
    _param_types = param_types'
    _return_type = return_type'
    _partial = partial'
    _object_cap = object_cap'
    _cap_mod = cap_mod'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let method_cap': (AST | None) = try iter.next() else None end
    let name': (AST | None) = try iter.next() else None end
    let type_params': (AST | None) = try iter.next() else None end
    let param_types': (AST | None) = try iter.next() else TupleType end
    let return_type': (AST | None) = try iter.next() else None end
    let partial': (AST | None) = try iter.next() else None end
    let object_cap': (AST | None) = try iter.next() else None end
    let cap_mod': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("LambdaType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _method_cap =
      try method_cap' as (Cap | None)
      else errs.push(("LambdaType got incompatible field: method_cap", try (method_cap' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as (Id | None)
      else errs.push(("LambdaType got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("LambdaType got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _param_types =
      try param_types' as TupleType
      else errs.push(("LambdaType got incompatible field: param_types", try (param_types' as AST).pos() else SourcePosNone end)); error
      end
    _return_type =
      try return_type' as (Type | None)
      else errs.push(("LambdaType got incompatible field: return_type", try (return_type' as AST).pos() else SourcePosNone end)); error
      end
    _partial =
      try partial' as (Question | None)
      else errs.push(("LambdaType got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
    _object_cap =
      try object_cap' as (Cap | GenCap | None)
      else errs.push(("LambdaType got incompatible field: object_cap", try (object_cap' as AST).pos() else SourcePosNone end)); error
      end
    _cap_mod =
      try cap_mod' as (CapMod | None)
      else errs.push(("LambdaType got incompatible field: cap_mod", try (cap_mod' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LambdaType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_method_cap)
    fn(_name)
    fn(_type_params)
    fn(_param_types)
    fn(_return_type)
    fn(_partial)
    fn(_object_cap)
    fn(_cap_mod)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LambdaType => _create(pos', _method_cap, _name, _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod)
  
  fun val method_cap(): (Cap | None) => _method_cap
  fun val name(): (Id | None) => _name
  fun val type_params(): (TypeParams | None) => _type_params
  fun val param_types(): TupleType => _param_types
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val object_cap(): (Cap | GenCap | None) => _object_cap
  fun val cap_mod(): (CapMod | None) => _cap_mod
  
  fun val with_method_cap(method_cap': (Cap | None)): LambdaType => _create(_pos, method_cap', _name, _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod)
  fun val with_name(name': (Id | None)): LambdaType => _create(_pos, _method_cap, name', _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod)
  fun val with_type_params(type_params': (TypeParams | None)): LambdaType => _create(_pos, _method_cap, _name, type_params', _param_types, _return_type, _partial, _object_cap, _cap_mod)
  fun val with_param_types(param_types': TupleType): LambdaType => _create(_pos, _method_cap, _name, _type_params, param_types', _return_type, _partial, _object_cap, _cap_mod)
  fun val with_return_type(return_type': (Type | None)): LambdaType => _create(_pos, _method_cap, _name, _type_params, _param_types, return_type', _partial, _object_cap, _cap_mod)
  fun val with_partial(partial': (Question | None)): LambdaType => _create(_pos, _method_cap, _name, _type_params, _param_types, _return_type, partial', _object_cap, _cap_mod)
  fun val with_object_cap(object_cap': (Cap | GenCap | None)): LambdaType => _create(_pos, _method_cap, _name, _type_params, _param_types, _return_type, _partial, object_cap', _cap_mod)
  fun val with_cap_mod(cap_mod': (CapMod | None)): LambdaType => _create(_pos, _method_cap, _name, _type_params, _param_types, _return_type, _partial, _object_cap, cap_mod')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "method_cap" => _method_cap
    | "name" => _name
    | "type_params" => _type_params
    | "param_types" => _param_types
    | "return_type" => _return_type
    | "partial" => _partial
    | "object_cap" => _object_cap
    | "cap_mod" => _cap_mod
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _method_cap then
        return _create(_pos, replace' as (Cap | None), _name, _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod)
      end
      if child' is _name then
        return _create(_pos, _method_cap, replace' as (Id | None), _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod)
      end
      if child' is _type_params then
        return _create(_pos, _method_cap, _name, replace' as (TypeParams | None), _param_types, _return_type, _partial, _object_cap, _cap_mod)
      end
      if child' is _param_types then
        return _create(_pos, _method_cap, _name, _type_params, replace' as TupleType, _return_type, _partial, _object_cap, _cap_mod)
      end
      if child' is _return_type then
        return _create(_pos, _method_cap, _name, _type_params, _param_types, replace' as (Type | None), _partial, _object_cap, _cap_mod)
      end
      if child' is _partial then
        return _create(_pos, _method_cap, _name, _type_params, _param_types, _return_type, replace' as (Question | None), _object_cap, _cap_mod)
      end
      if child' is _object_cap then
        return _create(_pos, _method_cap, _name, _type_params, _param_types, _return_type, _partial, replace' as (Cap | GenCap | None), _cap_mod)
      end
      if child' is _cap_mod then
        return _create(_pos, _method_cap, _name, _type_params, _param_types, _return_type, _partial, _object_cap, replace' as (CapMod | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LambdaType")
    s.push('(')
    s.>append(_method_cap.string()).>push(',').push(' ')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_param_types.string()).>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_partial.string()).>push(',').push(' ')
    s.>append(_object_cap.string()).>push(',').push(' ')
    s.>append(_cap_mod.string())
    s.push(')')
    consume s

class val TypeParamRef is (AST & Type)
  let _pos: SourcePosAny
  
  let _name: Id
  let _cap: (Cap | GenCap | None)
  let _cap_mod: (CapMod | None)
  
  new val create(
    name': Id,
    cap': (Cap | GenCap | None) = None,
    cap_mod': (CapMod | None) = None)
  =>_pos = SourcePosNone
    _name = name'
    _cap = cap'
    _cap_mod = cap_mod'
  
  new val _create(pos': SourcePosAny,
    name': Id,
    cap': (Cap | GenCap | None),
    cap_mod': (CapMod | None))
  =>
    _pos = pos'
    _name = name'
    _cap = cap'
    _cap_mod = cap_mod'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    let name': (AST | None) =
      try iter.next()
      else errs.push(("TypeParamRef missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next() else None end
    let cap_mod': (AST | None) = try iter.next() else None end
    if
      try
        let extra' = iter.next()
        errs.push(("TypeParamRef got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("TypeParamRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | GenCap | None)
      else errs.push(("TypeParamRef got incompatible field: cap", try (cap' as AST).pos() else SourcePosNone end)); error
      end
    _cap_mod =
      try cap_mod' as (CapMod | None)
      else errs.push(("TypeParamRef got incompatible field: cap_mod", try (cap_mod' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TypeParamRef](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    fn(_name)
    fn(_cap)
    fn(_cap_mod)
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): TypeParamRef => _create(pos', _name, _cap, _cap_mod)
  
  fun val name(): Id => _name
  fun val cap(): (Cap | GenCap | None) => _cap
  fun val cap_mod(): (CapMod | None) => _cap_mod
  
  fun val with_name(name': Id): TypeParamRef => _create(_pos, name', _cap, _cap_mod)
  fun val with_cap(cap': (Cap | GenCap | None)): TypeParamRef => _create(_pos, _name, cap', _cap_mod)
  fun val with_cap_mod(cap_mod': (CapMod | None)): TypeParamRef => _create(_pos, _name, _cap, cap_mod')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "cap" => _cap
    | "cap_mod" => _cap_mod
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return _create(_pos, replace' as Id, _cap, _cap_mod)
      end
      if child' is _cap then
        return _create(_pos, _name, replace' as (Cap | GenCap | None), _cap_mod)
      end
      if child' is _cap_mod then
        return _create(_pos, _name, _cap, replace' as (CapMod | None))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeParamRef")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_cap_mod.string())
    s.push(')')
    consume s

class val ThisType is (AST & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("ThisType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ThisType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): ThisType => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ThisType")
    consume s

class val DontCareType is (AST & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("DontCareType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[DontCareType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): DontCareType => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DontCareType")
    consume s

class val ErrorType is (AST & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("ErrorType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ErrorType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): ErrorType => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ErrorType")
    consume s

class val LiteralType is (AST & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("LiteralType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LiteralType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LiteralType => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LiteralType")
    consume s

class val LiteralTypeBranch is (AST & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("LiteralTypeBranch got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LiteralTypeBranch](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): LiteralTypeBranch => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LiteralTypeBranch")
    consume s

class val OpLiteralType is (AST & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("OpLiteralType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[OpLiteralType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): OpLiteralType => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("OpLiteralType")
    consume s

class val Iso is (AST & Cap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("Iso got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Iso](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Iso => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Iso")
    consume s

class val Trn is (AST & Cap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("Trn got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Trn](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Trn => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Trn")
    consume s

class val Ref is (AST & Cap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("Ref got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Ref](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Ref => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ref")
    consume s

class val Val is (AST & Cap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("Val got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Val](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Val => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Val")
    consume s

class val Box is (AST & Cap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("Box got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Box](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Box => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Box")
    consume s

class val Tag is (AST & Cap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("Tag got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Tag](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Tag => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Tag")
    consume s

class val CapRead is (AST & GenCap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("CapRead got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CapRead](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): CapRead => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapRead")
    consume s

class val CapSend is (AST & GenCap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("CapSend got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CapSend](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): CapSend => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapSend")
    consume s

class val CapShare is (AST & GenCap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("CapShare got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CapShare](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): CapShare => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapShare")
    consume s

class val CapAlias is (AST & GenCap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("CapAlias got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CapAlias](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): CapAlias => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapAlias")
    consume s

class val CapAny is (AST & GenCap & Type)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("CapAny got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CapAny](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): CapAny => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapAny")
    consume s

class val Aliased is (AST & CapMod)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("Aliased got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Aliased](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Aliased => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Aliased")
    consume s

class val Ephemeral is (AST & CapMod)
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("Ephemeral got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Ephemeral](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Ephemeral => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ephemeral")
    consume s

class val At is AST
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("At got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[At](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): At => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("At")
    consume s

class val Question is AST
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("Question got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Question](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Question => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Question")
    consume s

class val Ellipsis is AST
  let _pos: SourcePosAny
  
  new val create() => _pos = SourcePosNone
  
  new val _create(pos': SourcePosAny)
  =>
    _pos = pos'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    if
      try
        let extra' = iter.next()
        errs.push(("Ellipsis got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Ellipsis](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Ellipsis => _create(pos')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ellipsis")
    consume s

class val Semicolon is (AST & Expr)
  let _pos: SourcePosAny
  
  let _list: coll.Vec[Expr]
  
  new val create(
    list': coll.Vec[Expr])
  =>_pos = SourcePosNone
    _list = list'
  
  new val _create(pos': SourcePosAny,
    list': coll.Vec[Expr])
  =>
    _pos = pos'
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    var list' = coll.Vec[Expr]
    var list_next' = try iter.next() else None end
    while true do
      try list' = list'.push(list_next' as Expr) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Semicolon got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Semicolon](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) =>
    for x in _list.values() do fn(x) end
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Semicolon => _create(pos', _list)
  
  fun val list(): coll.Vec[Expr] => _list
  
  fun val with_list(list': coll.Vec[Expr]): Semicolon => _create(_pos, list')
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Expr)
        return _create(_pos, _list.update(i, replace' as Expr))
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Semicolon")
    s.push('(')
    s.push('[')
    for (i, v) in _list.pairs() do
      if i > 0 then s.>push(';').push(' ') end
      s.append(v.string())
    end
    s.push(']')
    s.push(')')
    consume s

class val Id is AST
  let _pos: SourcePosAny
  let _value: String
  new val create(value': String) =>(_pos, _value) = (SourcePosNone, value')
  new val _create(pos': SourcePosAny, value': String) =>(_pos, _value) = (pos', value')
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    _pos = pos'
    _value =
      try
        _ASTUtil.parse_id(_pos)
      else
        errs.push(("Id failed to parse value", _pos)); true
        error
      end
    
    if
      try
        let extra' = iter.next()
        errs.push(("Id got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Id](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => _pos
  fun val with_pos(pos': SourcePosAny): Id => _create(pos', _value)
  
  fun val value(): String => _value
  fun val with_value(value': String): Id => _create(_pos, value')
  fun string(): String iso^ =>
    recover
      String.>append("Id(").>append(_value.string()).>push(')')
    end

class val EOF is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("EOF is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[EOF](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): EOF => create()
  
  fun string(): String iso^ =>
    recover String.>append("EOF") end

class val NewLine is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("NewLine is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NewLine](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): NewLine => create()
  
  fun string(): String iso^ =>
    recover String.>append("NewLine") end

class val Use is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Use is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Use](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Use => create()
  
  fun string(): String iso^ =>
    recover String.>append("Use") end

class val Colon is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Colon is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Colon](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Colon => create()
  
  fun string(): String iso^ =>
    recover String.>append("Colon") end

class val Comma is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Comma is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Comma](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Comma => create()
  
  fun string(): String iso^ =>
    recover String.>append("Comma") end

class val Constant is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Constant is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Constant](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Constant => create()
  
  fun string(): String iso^ =>
    recover String.>append("Constant") end

class val Pipe is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Pipe is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Pipe](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Pipe => create()
  
  fun string(): String iso^ =>
    recover String.>append("Pipe") end

class val Ampersand is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Ampersand is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Ampersand](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Ampersand => create()
  
  fun string(): String iso^ =>
    recover String.>append("Ampersand") end

class val SubType is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("SubType is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[SubType](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): SubType => create()
  
  fun string(): String iso^ =>
    recover String.>append("SubType") end

class val Arrow is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Arrow is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Arrow](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Arrow => create()
  
  fun string(): String iso^ =>
    recover String.>append("Arrow") end

class val DoubleArrow is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("DoubleArrow is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[DoubleArrow](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): DoubleArrow => create()
  
  fun string(): String iso^ =>
    recover String.>append("DoubleArrow") end

class val Backslash is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Backslash is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Backslash](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Backslash => create()
  
  fun string(): String iso^ =>
    recover String.>append("Backslash") end

class val LParen is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("LParen is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LParen](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LParen => create()
  
  fun string(): String iso^ =>
    recover String.>append("LParen") end

class val RParen is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("RParen is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[RParen](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): RParen => create()
  
  fun string(): String iso^ =>
    recover String.>append("RParen") end

class val LBrace is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("LBrace is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LBrace](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LBrace => create()
  
  fun string(): String iso^ =>
    recover String.>append("LBrace") end

class val RBrace is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("RBrace is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[RBrace](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): RBrace => create()
  
  fun string(): String iso^ =>
    recover String.>append("RBrace") end

class val LSquare is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("LSquare is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LSquare](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LSquare => create()
  
  fun string(): String iso^ =>
    recover String.>append("LSquare") end

class val RSquare is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("RSquare is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[RSquare](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): RSquare => create()
  
  fun string(): String iso^ =>
    recover String.>append("RSquare") end

class val LParenNew is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("LParenNew is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LParenNew](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LParenNew => create()
  
  fun string(): String iso^ =>
    recover String.>append("LParenNew") end

class val LBraceNew is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("LBraceNew is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LBraceNew](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LBraceNew => create()
  
  fun string(): String iso^ =>
    recover String.>append("LBraceNew") end

class val LSquareNew is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("LSquareNew is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LSquareNew](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LSquareNew => create()
  
  fun string(): String iso^ =>
    recover String.>append("LSquareNew") end

class val SubNew is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("SubNew is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[SubNew](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): SubNew => create()
  
  fun string(): String iso^ =>
    recover String.>append("SubNew") end

class val SubUnsafeNew is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("SubUnsafeNew is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[SubUnsafeNew](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): SubUnsafeNew => create()
  
  fun string(): String iso^ =>
    recover String.>append("SubUnsafeNew") end

class val In is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("In is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[In](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): In => create()
  
  fun string(): String iso^ =>
    recover String.>append("In") end

class val Until is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Until is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Until](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Until => create()
  
  fun string(): String iso^ =>
    recover String.>append("Until") end

class val Do is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Do is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Do](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Do => create()
  
  fun string(): String iso^ =>
    recover String.>append("Do") end

class val Else is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Else is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Else](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Else => create()
  
  fun string(): String iso^ =>
    recover String.>append("Else") end

class val ElseIf is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("ElseIf is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ElseIf](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): ElseIf => create()
  
  fun string(): String iso^ =>
    recover String.>append("ElseIf") end

class val Then is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Then is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Then](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Then => create()
  
  fun string(): String iso^ =>
    recover String.>append("Then") end

class val End is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("End is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[End](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): End => create()
  
  fun string(): String iso^ =>
    recover String.>append("End") end

class val Var is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Var is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Var](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Var => create()
  
  fun string(): String iso^ =>
    recover String.>append("Var") end

class val Let is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Let is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Let](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Let => create()
  
  fun string(): String iso^ =>
    recover String.>append("Let") end

class val Embed is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Embed is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Embed](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Embed => create()
  
  fun string(): String iso^ =>
    recover String.>append("Embed") end

class val Where is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
    errs.push(("Where is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Where](consume c, this)
  fun val each(fn: {ref ((AST | None))} ref) => None
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Where => create()
  
  fun string(): String iso^ =>
    recover String.>append("Where") end



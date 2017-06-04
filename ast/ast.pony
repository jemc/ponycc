trait AST
  fun pos(): SourcePosAny
  fun ref set_pos(pos': SourcePosAny)
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
    elseif A <: Id then "Id"
    elseif A <: EOF then "EOF"
    elseif A <: NewLine then "NewLine"
    elseif A <: Use then "Use"
    elseif A <: Colon then "Colon"
    elseif A <: Semicolon then "Semicolon"
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

trait BinaryOp is AST

trait Cap is AST

trait LitBool is AST

trait Type is AST

trait Field is AST

trait IfDefBinaryOp is AST

trait GenCap is AST

trait Local is AST

trait UseDecl is AST

trait Jump is AST

trait CapMod is AST

trait MethodRef is AST

trait TypeDecl is AST

trait IfDefCond is AST

trait Lexeme is AST

trait Method is AST

trait Expr is AST

trait FieldRef is AST

trait LocalRef is AST

trait UnaryOp is AST

class Module is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _use_decls: Array[UseDecl]
  var _type_decls: Array[TypeDecl]
  var _docs: (LitString | None)
  
  new create(
    use_decls': Array[UseDecl] = Array[UseDecl],
    type_decls': Array[TypeDecl] = Array[TypeDecl],
    docs': (LitString | None) = None)
  =>
    _use_decls = use_decls'
    _type_decls = type_decls'
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let use_decls' = Array[UseDecl]
    var use_decls_next' = try iter.next() else None end
    while true do
      try use_decls'.push(use_decls_next' as UseDecl) else break end
      try use_decls_next' = iter.next() else use_decls_next' = None; break end
    end
    let type_decls' = Array[TypeDecl]
    var type_decls_next' = use_decls_next'
    while true do
      try type_decls'.push(type_decls_next' as TypeDecl) else break end
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun use_decls(): this->Array[UseDecl] => _use_decls
  fun type_decls(): this->Array[TypeDecl] => _type_decls
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_use_decls(use_decls': Array[UseDecl] = Array[UseDecl]) => _use_decls = consume use_decls'
  fun ref set_type_decls(type_decls': Array[TypeDecl] = Array[TypeDecl]) => _type_decls = consume type_decls'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class UsePackage is (AST & UseDecl)
  var _pos: SourcePosAny = SourcePosNone
  
  var _prefix: (Id | None)
  var _package: LitString
  
  new create(
    prefix': (Id | None) = None,
    package': LitString)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun prefix(): this->(Id | None) => _prefix
  fun package(): this->LitString => _package
  
  fun ref set_prefix(prefix': (Id | None) = None) => _prefix = consume prefix'
  fun ref set_package(package': LitString) => _package = consume package'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("UsePackage")
    s.push('(')
    s.>append(_prefix.string()).>push(',').push(' ')
    s.>append(_package.string())
    s.push(')')
    consume s

class UseFFIDecl is (AST & UseDecl)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: (Id | LitString)
  var _return_type: TypeArgs
  var _params: (Params | None)
  var _partial: (Question | None)
  var _guard: (IfDefCond | None)
  
  new create(
    name': (Id | LitString),
    return_type': TypeArgs,
    params': (Params | None),
    partial': (Question | None),
    guard': (IfDefCond | None) = None)
  =>
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
      try params' as (Params | None)
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->(Id | LitString) => _name
  fun return_type(): this->TypeArgs => _return_type
  fun params(): this->(Params | None) => _params
  fun partial(): this->(Question | None) => _partial
  fun guard(): this->(IfDefCond | None) => _guard
  
  fun ref set_name(name': (Id | LitString)) => _name = consume name'
  fun ref set_return_type(return_type': TypeArgs) => _return_type = consume return_type'
  fun ref set_params(params': (Params | None)) => _params = consume params'
  fun ref set_partial(partial': (Question | None)) => _partial = consume partial'
  fun ref set_guard(guard': (IfDefCond | None) = None) => _guard = consume guard'
  
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

class TypeAlias is (AST & TypeDecl)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | None)
  var _type_params: (TypeParams | None)
  var _provides: (Type | None)
  var _members: Members
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | None) => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun provides(): this->(Type | None) => _provides
  fun members(): this->Members => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_provides(provides': (Type | None) = None) => _provides = consume provides'
  fun ref set_members(members': Members = Members) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class Interface is (AST & TypeDecl)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | None)
  var _type_params: (TypeParams | None)
  var _provides: (Type | None)
  var _members: Members
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | None) => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun provides(): this->(Type | None) => _provides
  fun members(): this->Members => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_provides(provides': (Type | None) = None) => _provides = consume provides'
  fun ref set_members(members': Members = Members) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class Trait is (AST & TypeDecl)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | None)
  var _type_params: (TypeParams | None)
  var _provides: (Type | None)
  var _members: Members
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | None) => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun provides(): this->(Type | None) => _provides
  fun members(): this->Members => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_provides(provides': (Type | None) = None) => _provides = consume provides'
  fun ref set_members(members': Members = Members) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class Primitive is (AST & TypeDecl)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | None)
  var _type_params: (TypeParams | None)
  var _provides: (Type | None)
  var _members: Members
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | None) => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun provides(): this->(Type | None) => _provides
  fun members(): this->Members => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_provides(provides': (Type | None) = None) => _provides = consume provides'
  fun ref set_members(members': Members = Members) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class Struct is (AST & TypeDecl)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | None)
  var _type_params: (TypeParams | None)
  var _provides: (Type | None)
  var _members: Members
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | None) => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun provides(): this->(Type | None) => _provides
  fun members(): this->Members => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_provides(provides': (Type | None) = None) => _provides = consume provides'
  fun ref set_members(members': Members = Members) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class Class is (AST & TypeDecl)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | None)
  var _type_params: (TypeParams | None)
  var _provides: (Type | None)
  var _members: Members
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | None) => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun provides(): this->(Type | None) => _provides
  fun members(): this->Members => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_provides(provides': (Type | None) = None) => _provides = consume provides'
  fun ref set_members(members': Members = Members) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class Actor is (AST & TypeDecl)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | None)
  var _type_params: (TypeParams | None)
  var _provides: (Type | None)
  var _members: Members
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    provides': (Type | None) = None,
    members': Members = Members,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | None) => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun provides(): this->(Type | None) => _provides
  fun members(): this->Members => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_provides(provides': (Type | None) = None) => _provides = consume provides'
  fun ref set_members(members': Members = Members) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class Members is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _fields: Array[Field]
  var _methods: Array[Method]
  
  new create(
    fields': Array[Field] = Array[Field],
    methods': Array[Method] = Array[Method])
  =>
    _fields = fields'
    _methods = methods'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let fields' = Array[Field]
    var fields_next' = try iter.next() else None end
    while true do
      try fields'.push(fields_next' as Field) else break end
      try fields_next' = iter.next() else fields_next' = None; break end
    end
    let methods' = Array[Method]
    var methods_next' = fields_next'
    while true do
      try methods'.push(methods_next' as Method) else break end
      try methods_next' = iter.next() else methods_next' = None; break end
    end
    if methods_next' isnt None then
      let extra' = methods_next'
      errs.push(("Members got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _fields = fields'
    _methods = methods'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun fields(): this->Array[Field] => _fields
  fun methods(): this->Array[Method] => _methods
  
  fun ref set_fields(fields': Array[Field] = Array[Field]) => _fields = consume fields'
  fun ref set_methods(methods': Array[Method] = Array[Method]) => _methods = consume methods'
  
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

class FieldLet is (AST & Field)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _field_type: Type
  var _default: (Expr | None)
  
  new create(
    name': Id,
    field_type': Type,
    default': (Expr | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun field_type(): this->Type => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': Type) => _field_type = consume field_type'
  fun ref set_default(default': (Expr | None) = None) => _default = consume default'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldLet")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_field_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class FieldVar is (AST & Field)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _field_type: Type
  var _default: (Expr | None)
  
  new create(
    name': Id,
    field_type': Type,
    default': (Expr | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun field_type(): this->Type => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': Type) => _field_type = consume field_type'
  fun ref set_default(default': (Expr | None) = None) => _default = consume default'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldVar")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_field_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class FieldEmbed is (AST & Field)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _field_type: Type
  var _default: (Expr | None)
  
  new create(
    name': Id,
    field_type': Type,
    default': (Expr | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun field_type(): this->Type => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': Type) => _field_type = consume field_type'
  fun ref set_default(default': (Expr | None) = None) => _default = consume default'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldEmbed")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_field_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class MethodFun is (AST & Method)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | None)
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _guard: (Sequence | None)
  var _body: (Sequence | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    params': (Params | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None,
    docs': (LitString | None) = None)
  =>
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
    let params': (AST | None) = try iter.next() else None end
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
      try params' as (Params | None)
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | None) => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun guard(): this->(Sequence | None) => _guard
  fun body(): this->(Sequence | None) => _body
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_guard(guard': (Sequence | None) = None) => _guard = consume guard'
  fun ref set_body(body': (Sequence | None) = None) => _body = consume body'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class MethodNew is (AST & Method)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | None)
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _guard: (Sequence | None)
  var _body: (Sequence | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    params': (Params | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None,
    docs': (LitString | None) = None)
  =>
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
    let params': (AST | None) = try iter.next() else None end
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
      try params' as (Params | None)
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | None) => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun guard(): this->(Sequence | None) => _guard
  fun body(): this->(Sequence | None) => _body
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_guard(guard': (Sequence | None) = None) => _guard = consume guard'
  fun ref set_body(body': (Sequence | None) = None) => _body = consume body'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class MethodBe is (AST & Method)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | None)
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _guard: (Sequence | None)
  var _body: (Sequence | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    cap': (Cap | None) = None,
    type_params': (TypeParams | None) = None,
    params': (Params | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None,
    docs': (LitString | None) = None)
  =>
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
    let params': (AST | None) = try iter.next() else None end
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
      try params' as (Params | None)
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | None) => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun guard(): this->(Sequence | None) => _guard
  fun body(): this->(Sequence | None) => _body
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_guard(guard': (Sequence | None) = None) => _guard = consume guard'
  fun ref set_body(body': (Sequence | None) = None) => _body = consume body'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
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

class TypeParams is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[TypeParam]
  
  new create(
    list': Array[TypeParam] = Array[TypeParam])
  =>
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[TypeParam]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as TypeParam) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("TypeParams got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[TypeParam] => _list
  
  fun ref set_list(list': Array[TypeParam] = Array[TypeParam]) => _list = consume list'
  
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

class TypeParam is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _constraint: (Type | None)
  var _default: (Type | None)
  
  new create(
    name': Id,
    constraint': (Type | None) = None,
    default': (Type | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun constraint(): this->(Type | None) => _constraint
  fun default(): this->(Type | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_constraint(constraint': (Type | None) = None) => _constraint = consume constraint'
  fun ref set_default(default': (Type | None) = None) => _default = consume default'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeParam")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_constraint.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class TypeArgs is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[Type]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as Type) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("TypeArgs got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'
  
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

class Params is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Param]
  var _ellipsis: (Ellipsis | None)
  
  new create(
    list': Array[Param] = Array[Param],
    ellipsis': (Ellipsis | None) = None)
  =>
    _list = list'
    _ellipsis = ellipsis'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[Param]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as Param) else break end
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Param] => _list
  fun ellipsis(): this->(Ellipsis | None) => _ellipsis
  
  fun ref set_list(list': Array[Param] = Array[Param]) => _list = consume list'
  fun ref set_ellipsis(ellipsis': (Ellipsis | None) = None) => _ellipsis = consume ellipsis'
  
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

class Param is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _param_type: (Type | None)
  var _default: (Expr | None)
  
  new create(
    name': Id,
    param_type': (Type | None) = None,
    default': (Expr | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun param_type(): this->(Type | None) => _param_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_param_type(param_type': (Type | None) = None) => _param_type = consume param_type'
  fun ref set_default(default': (Expr | None) = None) => _default = consume default'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Param")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_param_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class Sequence is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Expr]
  
  new create(
    list': Array[Expr] = Array[Expr])
  =>
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[Expr]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as Expr) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Sequence got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Expr] => _list
  
  fun ref set_list(list': Array[Expr] = Array[Expr]) => _list = consume list'
  
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

class Return is (AST & Jump & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _value: (Expr | None)
  
  new create(
    value': (Expr | None))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): this->(Expr | None) => _value
  
  fun ref set_value(value': (Expr | None)) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Return")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class Break is (AST & Jump & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _value: (Expr | None)
  
  new create(
    value': (Expr | None))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): this->(Expr | None) => _value
  
  fun ref set_value(value': (Expr | None)) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Break")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class Continue is (AST & Jump & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _value: (Expr | None)
  
  new create(
    value': (Expr | None))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): this->(Expr | None) => _value
  
  fun ref set_value(value': (Expr | None)) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Continue")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class Error is (AST & Jump & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _value: (Expr | None)
  
  new create(
    value': (Expr | None))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): this->(Expr | None) => _value
  
  fun ref set_value(value': (Expr | None)) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Error")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class CompileIntrinsic is (AST & Jump & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _value: (Expr | None)
  
  new create(
    value': (Expr | None))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): this->(Expr | None) => _value
  
  fun ref set_value(value': (Expr | None)) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CompileIntrinsic")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class CompileError is (AST & Jump & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _value: (Expr | None)
  
  new create(
    value': (Expr | None))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): this->(Expr | None) => _value
  
  fun ref set_value(value': (Expr | None)) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CompileError")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class IfDefFlag is (AST & IfDefCond)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: (Id | LitString)
  
  new create(
    name': (Id | LitString))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->(Id | LitString) => _name
  
  fun ref set_name(name': (Id | LitString)) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefFlag")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class IfDefNot is (AST & IfDefCond)
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: IfDefCond
  
  new create(
    expr': IfDefCond)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->IfDefCond => _expr
  
  fun ref set_expr(expr': IfDefCond) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefNot")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class IfDefAnd is (AST & IfDefBinaryOp & IfDefCond)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: IfDefCond
  var _right: IfDefCond
  
  new create(
    left': IfDefCond,
    right': IfDefCond)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->IfDefCond => _left
  fun right(): this->IfDefCond => _right
  
  fun ref set_left(left': IfDefCond) => _left = consume left'
  fun ref set_right(right': IfDefCond) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefAnd")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class IfDefOr is (AST & IfDefBinaryOp & IfDefCond)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: IfDefCond
  var _right: IfDefCond
  
  new create(
    left': IfDefCond,
    right': IfDefCond)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->IfDefCond => _left
  fun right(): this->IfDefCond => _right
  
  fun ref set_left(left': IfDefCond) => _left = consume left'
  fun ref set_right(right': IfDefCond) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefOr")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class IfDef is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _condition: IfDefCond
  var _then_body: Sequence
  var _else_body: (Sequence | IfDef | None)
  
  new create(
    condition': IfDefCond,
    then_body': Sequence,
    else_body': (Sequence | IfDef | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun condition(): this->IfDefCond => _condition
  fun then_body(): this->Sequence => _then_body
  fun else_body(): this->(Sequence | IfDef | None) => _else_body
  
  fun ref set_condition(condition': IfDefCond) => _condition = consume condition'
  fun ref set_then_body(then_body': Sequence) => _then_body = consume then_body'
  fun ref set_else_body(else_body': (Sequence | IfDef | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDef")
    s.push('(')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_then_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class IfType is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _sub: Type
  var _super: Type
  var _then_body: Sequence
  var _else_body: (Sequence | IfType | None)
  
  new create(
    sub': Type,
    super': Type,
    then_body': Sequence,
    else_body': (Sequence | IfType | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun sub(): this->Type => _sub
  fun super(): this->Type => _super
  fun then_body(): this->Sequence => _then_body
  fun else_body(): this->(Sequence | IfType | None) => _else_body
  
  fun ref set_sub(sub': Type) => _sub = consume sub'
  fun ref set_super(super': Type) => _super = consume super'
  fun ref set_then_body(then_body': Sequence) => _then_body = consume then_body'
  fun ref set_else_body(else_body': (Sequence | IfType | None) = None) => _else_body = consume else_body'
  
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

class If is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _condition: Sequence
  var _then_body: Sequence
  var _else_body: (Sequence | If | None)
  
  new create(
    condition': Sequence,
    then_body': Sequence,
    else_body': (Sequence | If | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun condition(): this->Sequence => _condition
  fun then_body(): this->Sequence => _then_body
  fun else_body(): this->(Sequence | If | None) => _else_body
  
  fun ref set_condition(condition': Sequence) => _condition = consume condition'
  fun ref set_then_body(then_body': Sequence) => _then_body = consume then_body'
  fun ref set_else_body(else_body': (Sequence | If | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("If")
    s.push('(')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_then_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class While is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _condition: Sequence
  var _loop_body: Sequence
  var _else_body: (Sequence | None)
  
  new create(
    condition': Sequence,
    loop_body': Sequence,
    else_body': (Sequence | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun condition(): this->Sequence => _condition
  fun loop_body(): this->Sequence => _loop_body
  fun else_body(): this->(Sequence | None) => _else_body
  
  fun ref set_condition(condition': Sequence) => _condition = consume condition'
  fun ref set_loop_body(loop_body': Sequence) => _loop_body = consume loop_body'
  fun ref set_else_body(else_body': (Sequence | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("While")
    s.push('(')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_loop_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class Repeat is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _loop_body: Sequence
  var _condition: Sequence
  var _else_body: (Sequence | None)
  
  new create(
    loop_body': Sequence,
    condition': Sequence,
    else_body': (Sequence | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun loop_body(): this->Sequence => _loop_body
  fun condition(): this->Sequence => _condition
  fun else_body(): this->(Sequence | None) => _else_body
  
  fun ref set_loop_body(loop_body': Sequence) => _loop_body = consume loop_body'
  fun ref set_condition(condition': Sequence) => _condition = consume condition'
  fun ref set_else_body(else_body': (Sequence | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Repeat")
    s.push('(')
    s.>append(_loop_body.string()).>push(',').push(' ')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class For is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _refs: (Id | IdTuple)
  var _iterator: Sequence
  var _loop_body: Sequence
  var _else_body: (Sequence | None)
  
  new create(
    refs': (Id | IdTuple),
    iterator': Sequence,
    loop_body': Sequence,
    else_body': (Sequence | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun refs(): this->(Id | IdTuple) => _refs
  fun iterator(): this->Sequence => _iterator
  fun loop_body(): this->Sequence => _loop_body
  fun else_body(): this->(Sequence | None) => _else_body
  
  fun ref set_refs(refs': (Id | IdTuple)) => _refs = consume refs'
  fun ref set_iterator(iterator': Sequence) => _iterator = consume iterator'
  fun ref set_loop_body(loop_body': Sequence) => _loop_body = consume loop_body'
  fun ref set_else_body(else_body': (Sequence | None) = None) => _else_body = consume else_body'
  
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

class With is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _assigns: AssignTuple
  var _with_body: Sequence
  var _else_body: (Sequence | None)
  
  new create(
    assigns': AssignTuple,
    with_body': Sequence,
    else_body': (Sequence | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun assigns(): this->AssignTuple => _assigns
  fun with_body(): this->Sequence => _with_body
  fun else_body(): this->(Sequence | None) => _else_body
  
  fun ref set_assigns(assigns': AssignTuple) => _assigns = consume assigns'
  fun ref set_with_body(with_body': Sequence) => _with_body = consume with_body'
  fun ref set_else_body(else_body': (Sequence | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("With")
    s.push('(')
    s.>append(_assigns.string()).>push(',').push(' ')
    s.>append(_with_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class IdTuple is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _elements: Array[(Id | IdTuple)]
  
  new create(
    elements': Array[(Id | IdTuple)] = Array[(Id | IdTuple)])
  =>
    _elements = elements'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let elements' = Array[(Id | IdTuple)]
    var elements_next' = try iter.next() else None end
    while true do
      try elements'.push(elements_next' as (Id | IdTuple)) else break end
      try elements_next' = iter.next() else elements_next' = None; break end
    end
    if elements_next' isnt None then
      let extra' = elements_next'
      errs.push(("IdTuple got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _elements = elements'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun elements(): this->Array[(Id | IdTuple)] => _elements
  
  fun ref set_elements(elements': Array[(Id | IdTuple)] = Array[(Id | IdTuple)]) => _elements = consume elements'
  
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

class AssignTuple is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _elements: Array[Assign]
  
  new create(
    elements': Array[Assign] = Array[Assign])
  =>
    _elements = elements'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let elements' = Array[Assign]
    var elements_next' = try iter.next() else None end
    while true do
      try elements'.push(elements_next' as Assign) else break end
      try elements_next' = iter.next() else elements_next' = None; break end
    end
    if elements_next' isnt None then
      let extra' = elements_next'
      errs.push(("AssignTuple got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _elements = elements'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun elements(): this->Array[Assign] => _elements
  
  fun ref set_elements(elements': Array[Assign] = Array[Assign]) => _elements = consume elements'
  
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

class Match is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Sequence
  var _cases: Cases
  var _else_body: (Sequence | None)
  
  new create(
    expr': Sequence,
    cases': Cases = Cases,
    else_body': (Sequence | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->Sequence => _expr
  fun cases(): this->Cases => _cases
  fun else_body(): this->(Sequence | None) => _else_body
  
  fun ref set_expr(expr': Sequence) => _expr = consume expr'
  fun ref set_cases(cases': Cases = Cases) => _cases = consume cases'
  fun ref set_else_body(else_body': (Sequence | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Match")
    s.push('(')
    s.>append(_expr.string()).>push(',').push(' ')
    s.>append(_cases.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class Cases is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Case]
  
  new create(
    list': Array[Case] = Array[Case])
  =>
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[Case]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as Case) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Cases got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Case] => _list
  
  fun ref set_list(list': Array[Case] = Array[Case]) => _list = consume list'
  
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

class Case is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  var _guard: (Sequence | None)
  var _body: (Sequence | None)
  
  new create(
    expr': Expr,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->Expr => _expr
  fun guard(): this->(Sequence | None) => _guard
  fun body(): this->(Sequence | None) => _body
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  fun ref set_guard(guard': (Sequence | None) = None) => _guard = consume guard'
  fun ref set_body(body': (Sequence | None) = None) => _body = consume body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Case")
    s.push('(')
    s.>append(_expr.string()).>push(',').push(' ')
    s.>append(_guard.string()).>push(',').push(' ')
    s.>append(_body.string())
    s.push(')')
    consume s

class Try is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _body: Sequence
  var _else_body: (Sequence | None)
  var _then_body: (Sequence | None)
  
  new create(
    body': Sequence,
    else_body': (Sequence | None) = None,
    then_body': (Sequence | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun body(): this->Sequence => _body
  fun else_body(): this->(Sequence | None) => _else_body
  fun then_body(): this->(Sequence | None) => _then_body
  
  fun ref set_body(body': Sequence) => _body = consume body'
  fun ref set_else_body(else_body': (Sequence | None) = None) => _else_body = consume else_body'
  fun ref set_then_body(then_body': (Sequence | None) = None) => _then_body = consume then_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Try")
    s.push('(')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_else_body.string()).>push(',').push(' ')
    s.>append(_then_body.string())
    s.push(')')
    consume s

class Consume is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _cap: (Cap | None)
  var _expr: Expr
  
  new create(
    cap': (Cap | None),
    expr': Expr)
  =>
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
      try expr' as Expr
      else errs.push(("Consume got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun cap(): this->(Cap | None) => _cap
  fun expr(): this->Expr => _expr
  
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Consume")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_expr.string())
    s.push(')')
    consume s

class Recover is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _cap: (Cap | None)
  var _expr: Sequence
  
  new create(
    cap': (Cap | None),
    expr': Sequence)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun cap(): this->(Cap | None) => _cap
  fun expr(): this->Sequence => _expr
  
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_expr(expr': Sequence) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Recover")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_expr.string())
    s.push(')')
    consume s

class As is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  var _as_type: Type
  
  new create(
    expr': Expr,
    as_type': Type)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->Expr => _expr
  fun as_type(): this->Type => _as_type
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  fun ref set_as_type(as_type': Type) => _as_type = consume as_type'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("As")
    s.push('(')
    s.>append(_expr.string()).>push(',').push(' ')
    s.>append(_as_type.string())
    s.push(')')
    consume s

class Add is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Add")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class AddUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("AddUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Sub is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Sub")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class SubUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("SubUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Mul is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Mul")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class MulUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MulUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Div is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Div")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class DivUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DivUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Mod is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Mod")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class ModUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ModUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class LShift is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LShift")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class LShiftUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LShiftUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class RShift is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RShift")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class RShiftUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RShiftUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Eq is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Eq")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class EqUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("EqUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class NE is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class NEUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NEUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class LT is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LT")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class LTUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LTUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class LE is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class LEUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LEUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class GE is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class GEUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GEUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class GT is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GT")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class GTUnsafe is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GTUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Is is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Is")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Isnt is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Isnt")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class And is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("And")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Or is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Or")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class XOr is (AST & BinaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("XOr")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Not is (AST & UnaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Not")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class Neg is (AST & UnaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Neg")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class NegUnsafe is (AST & UnaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NegUnsafe")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class AddressOf is (AST & UnaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("AddressOf")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class DigestOf is (AST & UnaryOp & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DigestOf")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class LocalLet is (AST & Local & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _local_type: (Type | None)
  
  new create(
    name': Id,
    local_type': (Type | None))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun local_type(): this->(Type | None) => _local_type
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_local_type(local_type': (Type | None)) => _local_type = consume local_type'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalLet")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_local_type.string())
    s.push(')')
    consume s

class LocalVar is (AST & Local & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _local_type: (Type | None)
  
  new create(
    name': Id,
    local_type': (Type | None))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun local_type(): this->(Type | None) => _local_type
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_local_type(local_type': (Type | None)) => _local_type = consume local_type'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalVar")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_local_type.string())
    s.push(')')
    consume s

class Assign is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Assign")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Dot is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Id
  
  new create(
    left': Expr,
    right': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Id => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Id) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Dot")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Chain is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Id
  
  new create(
    left': Expr,
    right': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Id => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Id) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Chain")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Tilde is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Id
  
  new create(
    left': Expr,
    right': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->Id => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Id) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Tilde")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Qualify is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: TypeArgs
  
  new create(
    left': Expr,
    right': TypeArgs)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->TypeArgs => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': TypeArgs) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Qualify")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Call is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _callable: Expr
  var _args: Args
  var _named_args: NamedArgs
  
  new create(
    callable': Expr,
    args': Args = Args,
    named_args': NamedArgs = NamedArgs)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun callable(): this->Expr => _callable
  fun args(): this->Args => _args
  fun named_args(): this->NamedArgs => _named_args
  
  fun ref set_callable(callable': Expr) => _callable = consume callable'
  fun ref set_args(args': Args = Args) => _args = consume args'
  fun ref set_named_args(named_args': NamedArgs = NamedArgs) => _named_args = consume named_args'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Call")
    s.push('(')
    s.>append(_callable.string()).>push(',').push(' ')
    s.>append(_args.string()).>push(',').push(' ')
    s.>append(_named_args.string())
    s.push(')')
    consume s

class CallFFI is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: (Id | LitString)
  var _type_args: (TypeArgs | None)
  var _args: Args
  var _named_args: NamedArgs
  var _partial: (Question | None)
  
  new create(
    name': (Id | LitString),
    type_args': (TypeArgs | None) = None,
    args': Args = Args,
    named_args': NamedArgs = NamedArgs,
    partial': (Question | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->(Id | LitString) => _name
  fun type_args(): this->(TypeArgs | None) => _type_args
  fun args(): this->Args => _args
  fun named_args(): this->NamedArgs => _named_args
  fun partial(): this->(Question | None) => _partial
  
  fun ref set_name(name': (Id | LitString)) => _name = consume name'
  fun ref set_type_args(type_args': (TypeArgs | None) = None) => _type_args = consume type_args'
  fun ref set_args(args': Args = Args) => _args = consume args'
  fun ref set_named_args(named_args': NamedArgs = NamedArgs) => _named_args = consume named_args'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  
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

class Args is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Sequence]
  
  new create(
    list': Array[Sequence] = Array[Sequence])
  =>
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[Sequence]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as Sequence) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Args got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Sequence] => _list
  
  fun ref set_list(list': Array[Sequence] = Array[Sequence]) => _list = consume list'
  
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

class NamedArgs is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[NamedArg]
  
  new create(
    list': Array[NamedArg] = Array[NamedArg])
  =>
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[NamedArg]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as NamedArg) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("NamedArgs got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[NamedArg] => _list
  
  fun ref set_list(list': Array[NamedArg] = Array[NamedArg]) => _list = consume list'
  
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

class NamedArg is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _value: Sequence
  
  new create(
    name': Id,
    value': Sequence)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun value(): this->Sequence => _value
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_value(value': Sequence) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NamedArg")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_value.string())
    s.push(')')
    consume s

class Lambda is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _method_cap: (Cap | None)
  var _name: (Id | None)
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _captures: (LambdaCaptures | None)
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _body: Sequence
  var _object_cap: (Cap | None)
  
  new create(
    method_cap': (Cap | None) = None,
    name': (Id | None) = None,
    type_params': (TypeParams | None) = None,
    params': (Params | None) = None,
    captures': (LambdaCaptures | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    body': Sequence = Sequence,
    object_cap': (Cap | None) = None)
  =>
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
    let params': (AST | None) = try iter.next() else None end
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
      try params' as (Params | None)
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun method_cap(): this->(Cap | None) => _method_cap
  fun name(): this->(Id | None) => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun captures(): this->(LambdaCaptures | None) => _captures
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun body(): this->Sequence => _body
  fun object_cap(): this->(Cap | None) => _object_cap
  
  fun ref set_method_cap(method_cap': (Cap | None) = None) => _method_cap = consume method_cap'
  fun ref set_name(name': (Id | None) = None) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_captures(captures': (LambdaCaptures | None) = None) => _captures = consume captures'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_body(body': Sequence = Sequence) => _body = consume body'
  fun ref set_object_cap(object_cap': (Cap | None) = None) => _object_cap = consume object_cap'
  
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

class LambdaCaptures is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[LambdaCapture]
  
  new create(
    list': Array[LambdaCapture] = Array[LambdaCapture])
  =>
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[LambdaCapture]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as LambdaCapture) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("LambdaCaptures got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[LambdaCapture] => _list
  
  fun ref set_list(list': Array[LambdaCapture] = Array[LambdaCapture]) => _list = consume list'
  
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

class LambdaCapture is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _local_type: (Type | None)
  var _expr: (Expr | None)
  
  new create(
    name': Id,
    local_type': (Type | None) = None,
    expr': (Expr | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun local_type(): this->(Type | None) => _local_type
  fun expr(): this->(Expr | None) => _expr
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_local_type(local_type': (Type | None) = None) => _local_type = consume local_type'
  fun ref set_expr(expr': (Expr | None) = None) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LambdaCapture")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_local_type.string()).>push(',').push(' ')
    s.>append(_expr.string())
    s.push(')')
    consume s

class Object is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _cap: (Cap | None)
  var _provides: (Type | None)
  var _members: (Members | None)
  
  new create(
    cap': (Cap | None) = None,
    provides': (Type | None) = None,
    members': (Members | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun cap(): this->(Cap | None) => _cap
  fun provides(): this->(Type | None) => _provides
  fun members(): this->(Members | None) => _members
  
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_provides(provides': (Type | None) = None) => _provides = consume provides'
  fun ref set_members(members': (Members | None) = None) => _members = consume members'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Object")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string())
    s.push(')')
    consume s

class LitArray is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _elem_type: (Type | None)
  var _sequence: Sequence
  
  new create(
    elem_type': (Type | None) = None,
    sequence': Sequence = Sequence)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun elem_type(): this->(Type | None) => _elem_type
  fun sequence(): this->Sequence => _sequence
  
  fun ref set_elem_type(elem_type': (Type | None) = None) => _elem_type = consume elem_type'
  fun ref set_sequence(sequence': Sequence = Sequence) => _sequence = consume sequence'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitArray")
    s.push('(')
    s.>append(_elem_type.string()).>push(',').push(' ')
    s.>append(_sequence.string())
    s.push(')')
    consume s

class Tuple is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _elements: Array[Sequence]
  
  new create(
    elements': Array[Sequence] = Array[Sequence])
  =>
    _elements = elements'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let elements' = Array[Sequence]
    var elements_next' = try iter.next() else None end
    while true do
      try elements'.push(elements_next' as Sequence) else break end
      try elements_next' = iter.next() else elements_next' = None; break end
    end
    if elements_next' isnt None then
      let extra' = elements_next'
      errs.push(("Tuple got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _elements = elements'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun elements(): this->Array[Sequence] => _elements
  
  fun ref set_elements(elements': Array[Sequence] = Array[Sequence]) => _elements = consume elements'
  
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

class This is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("This")
    consume s

class LitTrue is (AST & LitBool & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitTrue")
    consume s

class LitFalse is (AST & LitBool & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitFalse")
    consume s

class LitInteger is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  var _value: I128
  new create(value': I128) => _value = value'
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    _value = 88 // TODO: parse from _pos?
    
    if
      try
        let extra' = iter.next()
        errs.push(("LitInteger got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): I128 => _value
  fun ref set_value(value': I128) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitInteger(").>append(_value.string()).>push(')')
    end

class LitFloat is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  var _value: F64
  new create(value': F64) => _value = value'
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    _value = 88 // TODO: parse from _pos?
    
    if
      try
        let extra' = iter.next()
        errs.push(("LitFloat got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): F64 => _value
  fun ref set_value(value': F64) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitFloat(").>append(_value.string()).>push(')')
    end

class LitString is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  var _value: String
  new create(value': String) => _value = value'
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    _value = "foo" // TODO: parse from _pos?
    
    if
      try
        let extra' = iter.next()
        errs.push(("LitString got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): String => _value
  fun ref set_value(value': String) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitString(").>append(_value.string()).>push(')')
    end

class LitCharacter is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  var _value: U8
  new create(value': U8) => _value = value'
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    _value = 88 // TODO: parse from _pos?
    
    if
      try
        let extra' = iter.next()
        errs.push(("LitCharacter got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): U8 => _value
  fun ref set_value(value': U8) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitCharacter(").>append(_value.string()).>push(')')
    end

class LitLocation is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitLocation")
    consume s

class Reference is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Reference")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class DontCare is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DontCare")
    consume s

class PackageRef is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("PackageRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class MethodFunRef is (AST & MethodRef & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->(Id | TypeArgs) => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': (Id | TypeArgs)) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodFunRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class MethodNewRef is (AST & MethodRef & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->(Id | TypeArgs) => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': (Id | TypeArgs)) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodNewRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class MethodBeRef is (AST & MethodRef & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->(Id | TypeArgs) => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': (Id | TypeArgs)) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodBeRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class TypeRef is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _package: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    package': Expr,
    name': (Id | TypeArgs))
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun package(): this->Expr => _package
  fun name(): this->(Id | TypeArgs) => _name
  
  fun ref set_package(package': Expr) => _package = consume package'
  fun ref set_name(name': (Id | TypeArgs)) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeRef")
    s.push('(')
    s.>append(_package.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class FieldLetRef is (AST & FieldRef & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: Id
  
  new create(
    receiver': Expr,
    name': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->Id => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldLetRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class FieldVarRef is (AST & FieldRef & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: Id
  
  new create(
    receiver': Expr,
    name': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->Id => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldVarRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class FieldEmbedRef is (AST & FieldRef & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: Id
  
  new create(
    receiver': Expr,
    name': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->Id => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldEmbedRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class TupleElementRef is (AST & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: LitInteger
  
  new create(
    receiver': Expr,
    name': LitInteger)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->LitInteger => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': LitInteger) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TupleElementRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class LocalLetRef is (AST & LocalRef & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalLetRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class LocalVarRef is (AST & LocalRef & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalVarRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class ParamRef is (AST & LocalRef & Expr)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ParamRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class ViewpointType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Type
  var _right: Type
  
  new create(
    left': Type,
    right': Type)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Type => _left
  fun right(): this->Type => _right
  
  fun ref set_left(left': Type) => _left = consume left'
  fun ref set_right(right': Type) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ViewpointType")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class UnionType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[Type]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as Type) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("UnionType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'
  
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

class IsectType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[Type]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as Type) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("IsectType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'
  
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

class TupleType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    
    let list' = Array[Type]
    var list_next' = try iter.next() else None end
    while true do
      try list'.push(list_next' as Type) else break end
      try list_next' = iter.next() else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("TupleType got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'
  
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

class NominalType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _package: (Id | None)
  var _type_args: (TypeArgs | None)
  var _cap: (Cap | GenCap | None)
  var _cap_mod: (CapMod | None)
  
  new create(
    name': Id,
    package': (Id | None) = None,
    type_args': (TypeArgs | None) = None,
    cap': (Cap | GenCap | None) = None,
    cap_mod': (CapMod | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun package(): this->(Id | None) => _package
  fun type_args(): this->(TypeArgs | None) => _type_args
  fun cap(): this->(Cap | GenCap | None) => _cap
  fun cap_mod(): this->(CapMod | None) => _cap_mod
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_package(package': (Id | None) = None) => _package = consume package'
  fun ref set_type_args(type_args': (TypeArgs | None) = None) => _type_args = consume type_args'
  fun ref set_cap(cap': (Cap | GenCap | None) = None) => _cap = consume cap'
  fun ref set_cap_mod(cap_mod': (CapMod | None) = None) => _cap_mod = consume cap_mod'
  
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

class FunType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  var _cap: Cap
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (Type | None)
  
  new create(
    cap': Cap,
    type_params': (TypeParams | None) = None,
    params': (Params | None) = None,
    return_type': (Type | None) = None)
  =>
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
    let params': (AST | None) = try iter.next() else None end
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
      try params' as (Params | None)
      else errs.push(("FunType got incompatible field: params", try (params' as AST).pos() else SourcePosNone end)); error
      end
    _return_type =
      try return_type' as (Type | None)
      else errs.push(("FunType got incompatible field: return_type", try (return_type' as AST).pos() else SourcePosNone end)); error
      end
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun cap(): this->Cap => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun return_type(): this->(Type | None) => _return_type
  
  fun ref set_cap(cap': Cap) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  
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

class LambdaType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  var _method_cap: (Cap | None)
  var _name: (Id | None)
  var _type_params: (TypeParams | None)
  var _param_types: TupleType
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _object_cap: (Cap | GenCap | None)
  var _cap_mod: (CapMod | None)
  
  new create(
    method_cap': (Cap | None) = None,
    name': (Id | None) = None,
    type_params': (TypeParams | None) = None,
    param_types': TupleType = TupleType,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    object_cap': (Cap | GenCap | None) = None,
    cap_mod': (CapMod | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun method_cap(): this->(Cap | None) => _method_cap
  fun name(): this->(Id | None) => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun param_types(): this->TupleType => _param_types
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun object_cap(): this->(Cap | GenCap | None) => _object_cap
  fun cap_mod(): this->(CapMod | None) => _cap_mod
  
  fun ref set_method_cap(method_cap': (Cap | None) = None) => _method_cap = consume method_cap'
  fun ref set_name(name': (Id | None) = None) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_param_types(param_types': TupleType = TupleType) => _param_types = consume param_types'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_object_cap(object_cap': (Cap | GenCap | None) = None) => _object_cap = consume object_cap'
  fun ref set_cap_mod(cap_mod': (CapMod | None) = None) => _cap_mod = consume cap_mod'
  
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

class TypeParamRef is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _cap: (Cap | GenCap | None)
  var _cap_mod: (CapMod | None)
  
  new create(
    name': Id,
    cap': (Cap | GenCap | None) = None,
    cap_mod': (CapMod | None) = None)
  =>
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | GenCap | None) => _cap
  fun cap_mod(): this->(CapMod | None) => _cap_mod
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | GenCap | None) = None) => _cap = consume cap'
  fun ref set_cap_mod(cap_mod': (CapMod | None) = None) => _cap_mod = consume cap_mod'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeParamRef")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_cap_mod.string())
    s.push(')')
    consume s

class ThisType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ThisType")
    consume s

class DontCareType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DontCareType")
    consume s

class ErrorType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ErrorType")
    consume s

class LiteralType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LiteralType")
    consume s

class LiteralTypeBranch is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LiteralTypeBranch")
    consume s

class OpLiteralType is (AST & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("OpLiteralType")
    consume s

class Iso is (AST & Cap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Iso")
    consume s

class Trn is (AST & Cap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Trn")
    consume s

class Ref is (AST & Cap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ref")
    consume s

class Val is (AST & Cap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Val")
    consume s

class Box is (AST & Cap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Box")
    consume s

class Tag is (AST & Cap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Tag")
    consume s

class CapRead is (AST & GenCap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapRead")
    consume s

class CapSend is (AST & GenCap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapSend")
    consume s

class CapShare is (AST & GenCap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapShare")
    consume s

class CapAlias is (AST & GenCap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapAlias")
    consume s

class CapAny is (AST & GenCap & Type)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapAny")
    consume s

class Aliased is (AST & CapMod)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Aliased")
    consume s

class Ephemeral is (AST & CapMod)
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ephemeral")
    consume s

class At is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("At")
    consume s

class Question is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Question")
    consume s

class Ellipsis is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ellipsis")
    consume s

class Id is AST
  var _pos: SourcePosAny = SourcePosNone
  var _value: String
  new create(value': String) => _value = value'
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    _pos = pos'
    _value = "foo" // TODO: parse from _pos?
    
    if
      try
        let extra' = iter.next()
        errs.push(("Id got unexpected extra field", try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): String => _value
  fun ref set_value(value': String) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("Id(").>append(_value.string()).>push(')')
    end

class EOF is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("EOF is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("EOF") end

class NewLine is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("NewLine is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("NewLine") end

class Use is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Use is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Use") end

class Colon is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Colon is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Colon") end

class Semicolon is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Semicolon is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Semicolon") end

class Comma is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Comma is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Comma") end

class Constant is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Constant is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Constant") end

class Pipe is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Pipe is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Pipe") end

class Ampersand is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Ampersand is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Ampersand") end

class SubType is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("SubType is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("SubType") end

class Arrow is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Arrow is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Arrow") end

class DoubleArrow is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("DoubleArrow is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("DoubleArrow") end

class Backslash is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Backslash is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Backslash") end

class LParen is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("LParen is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("LParen") end

class RParen is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("RParen is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("RParen") end

class LBrace is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("LBrace is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("LBrace") end

class RBrace is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("RBrace is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("RBrace") end

class LSquare is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("LSquare is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("LSquare") end

class RSquare is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("RSquare is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("RSquare") end

class LParenNew is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("LParenNew is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("LParenNew") end

class LBraceNew is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("LBraceNew is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("LBraceNew") end

class LSquareNew is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("LSquareNew is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("LSquareNew") end

class SubNew is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("SubNew is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("SubNew") end

class SubUnsafeNew is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("SubUnsafeNew is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("SubUnsafeNew") end

class In is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("In is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("In") end

class Until is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Until is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Until") end

class Do is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Do is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Do") end

class Else is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Else is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Else") end

class ElseIf is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("ElseIf is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("ElseIf") end

class Then is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Then is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Then") end

class End is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("End is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("End") end

class Var is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Var is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Var") end

class Let is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Let is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Let") end

class Embed is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Embed is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Embed") end

class Where is (AST & Lexeme)
  var _pos: SourcePosAny = SourcePosNone
  new create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = Array[(String, SourcePosAny)])?
  =>
  
    errs.push(("Where is a lexeme-only type append should never be built", pos')); error
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    recover String.>append("Where") end



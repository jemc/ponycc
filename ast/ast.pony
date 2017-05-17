trait AST
  fun string(): String iso^

primitive ASTInfo
  fun name[A: (AST | None)](): String =>
    iftype A <: None then "x"
    elseiftype A <: Program then "Program"
    elseiftype A <: Package then "Package"
    elseiftype A <: Module then "Module"
    elseiftype A <: UsePackage then "UsePackage"
    elseiftype A <: UseFFIDecl then "UseFFIDecl"
    elseiftype A <: FFIDecl then "FFIDecl"
    elseiftype A <: TypeAlias then "TypeAlias"
    elseiftype A <: Interface then "Interface"
    elseiftype A <: Trait then "Trait"
    elseiftype A <: Primitive then "Primitive"
    elseiftype A <: Struct then "Struct"
    elseiftype A <: Class then "Class"
    elseiftype A <: Actor then "Actor"
    elseiftype A <: Provides then "Provides"
    elseiftype A <: Members then "Members"
    elseiftype A <: FieldLet then "FieldLet"
    elseiftype A <: FieldVar then "FieldVar"
    elseiftype A <: FieldEmbed then "FieldEmbed"
    elseiftype A <: MethodFun then "MethodFun"
    elseiftype A <: MethodNew then "MethodNew"
    elseiftype A <: MethodBe then "MethodBe"
    elseiftype A <: TypeParams then "TypeParams"
    elseiftype A <: TypeParam then "TypeParam"
    elseiftype A <: TypeArgs then "TypeArgs"
    elseiftype A <: Params then "Params"
    elseiftype A <: Param then "Param"
    elseiftype A <: ExprSeq then "ExprSeq"
    elseiftype A <: RawExprSeq then "RawExprSeq"
    elseiftype A <: Return then "Return"
    elseiftype A <: Break then "Break"
    elseiftype A <: Continue then "Continue"
    elseiftype A <: Error then "Error"
    elseiftype A <: CompileIntrinsic then "CompileIntrinsic"
    elseiftype A <: CompileError then "CompileError"
    elseiftype A <: LocalLet then "LocalLet"
    elseiftype A <: LocalVar then "LocalVar"
    elseiftype A <: MatchCapture then "MatchCapture"
    elseiftype A <: As then "As"
    elseiftype A <: Tuple then "Tuple"
    elseiftype A <: Consume then "Consume"
    elseiftype A <: Recover then "Recover"
    elseiftype A <: Not then "Not"
    elseiftype A <: Neg then "Neg"
    elseiftype A <: NegUnsafe then "NegUnsafe"
    elseiftype A <: AddressOf then "AddressOf"
    elseiftype A <: DigestOf then "DigestOf"
    elseiftype A <: Add then "Add"
    elseiftype A <: AddUnsafe then "AddUnsafe"
    elseiftype A <: Sub then "Sub"
    elseiftype A <: SubUnsafe then "SubUnsafe"
    elseiftype A <: Mul then "Mul"
    elseiftype A <: MulUnsafe then "MulUnsafe"
    elseiftype A <: Div then "Div"
    elseiftype A <: DivUnsafe then "DivUnsafe"
    elseiftype A <: Mod then "Mod"
    elseiftype A <: ModUnsafe then "ModUnsafe"
    elseiftype A <: LShift then "LShift"
    elseiftype A <: LShiftUnsafe then "LShiftUnsafe"
    elseiftype A <: RShift then "RShift"
    elseiftype A <: RShiftUnsafe then "RShiftUnsafe"
    elseiftype A <: Eq then "Eq"
    elseiftype A <: EqUnsafe then "EqUnsafe"
    elseiftype A <: NE then "NE"
    elseiftype A <: NEUnsafe then "NEUnsafe"
    elseiftype A <: LT then "LT"
    elseiftype A <: LTUnsafe then "LTUnsafe"
    elseiftype A <: LE then "LE"
    elseiftype A <: LEUnsafe then "LEUnsafe"
    elseiftype A <: GE then "GE"
    elseiftype A <: GEUnsafe then "GEUnsafe"
    elseiftype A <: GT then "GT"
    elseiftype A <: GTUnsafe then "GTUnsafe"
    elseiftype A <: Is then "Is"
    elseiftype A <: Isnt then "Isnt"
    elseiftype A <: And then "And"
    elseiftype A <: Or then "Or"
    elseiftype A <: XOr then "XOr"
    elseiftype A <: Assign then "Assign"
    elseiftype A <: Dot then "Dot"
    elseiftype A <: Chain then "Chain"
    elseiftype A <: Tilde then "Tilde"
    elseiftype A <: Qualify then "Qualify"
    elseiftype A <: Call then "Call"
    elseiftype A <: FFICall then "FFICall"
    elseiftype A <: Args then "Args"
    elseiftype A <: NamedArgs then "NamedArgs"
    elseiftype A <: NamedArg then "NamedArg"
    elseiftype A <: IfDef then "IfDef"
    elseiftype A <: IfType then "IfType"
    elseiftype A <: IfDefAnd then "IfDefAnd"
    elseiftype A <: IfDefOr then "IfDefOr"
    elseiftype A <: IfDefNot then "IfDefNot"
    elseiftype A <: IfDefFlag then "IfDefFlag"
    elseiftype A <: If then "If"
    elseiftype A <: While then "While"
    elseiftype A <: Repeat then "Repeat"
    elseiftype A <: For then "For"
    elseiftype A <: With then "With"
    elseiftype A <: Match then "Match"
    elseiftype A <: Cases then "Cases"
    elseiftype A <: Case then "Case"
    elseiftype A <: Try then "Try"
    elseiftype A <: Lambda then "Lambda"
    elseiftype A <: LambdaCaptures then "LambdaCaptures"
    elseiftype A <: LambdaCapture then "LambdaCapture"
    elseiftype A <: Object then "Object"
    elseiftype A <: LitArray then "LitArray"
    elseiftype A <: Reference then "Reference"
    elseiftype A <: DontCare then "DontCare"
    elseiftype A <: PackageRef then "PackageRef"
    elseiftype A <: MethodFunRef then "MethodFunRef"
    elseiftype A <: MethodNewRef then "MethodNewRef"
    elseiftype A <: MethodBeRef then "MethodBeRef"
    elseiftype A <: TypeRef then "TypeRef"
    elseiftype A <: FieldLetRef then "FieldLetRef"
    elseiftype A <: FieldVarRef then "FieldVarRef"
    elseiftype A <: FieldEmbedRef then "FieldEmbedRef"
    elseiftype A <: TupleElementRef then "TupleElementRef"
    elseiftype A <: LocalLetRef then "LocalLetRef"
    elseiftype A <: LocalVarRef then "LocalVarRef"
    elseiftype A <: ParamRef then "ParamRef"
    elseiftype A <: UnionType then "UnionType"
    elseiftype A <: IsectType then "IsectType"
    elseiftype A <: TupleType then "TupleType"
    elseiftype A <: ArrowType then "ArrowType"
    elseiftype A <: FunType then "FunType"
    elseiftype A <: LambdaType then "LambdaType"
    elseiftype A <: NominalType then "NominalType"
    elseiftype A <: TypeParamRef then "TypeParamRef"
    elseiftype A <: ThisType then "ThisType"
    elseiftype A <: DontCareType then "DontCareType"
    elseiftype A <: ErrorType then "ErrorType"
    elseiftype A <: LiteralType then "LiteralType"
    elseiftype A <: LiteralTypeBranch then "LiteralTypeBranch"
    elseiftype A <: OpLiteralType then "OpLiteralType"
    elseiftype A <: Iso then "Iso"
    elseiftype A <: Trn then "Trn"
    elseiftype A <: Ref then "Ref"
    elseiftype A <: Val then "Val"
    elseiftype A <: Box then "Box"
    elseiftype A <: Tag then "Tag"
    elseiftype A <: CapRead then "CapRead"
    elseiftype A <: CapSend then "CapSend"
    elseiftype A <: CapShare then "CapShare"
    elseiftype A <: CapAlias then "CapAlias"
    elseiftype A <: CapAny then "CapAny"
    elseiftype A <: Aliased then "Aliased"
    elseiftype A <: Ephemeral then "Ephemeral"
    elseiftype A <: At then "At"
    elseiftype A <: Question then "Question"
    elseiftype A <: Ellipsis then "Ellipsis"
    elseiftype A <: Id then "Id"
    elseiftype A <: This then "This"
    elseiftype A <: LitTrue then "LitTrue"
    elseiftype A <: LitFalse then "LitFalse"
    elseiftype A <: LitFloat then "LitFloat"
    elseiftype A <: LitInteger then "LitInteger"
    elseiftype A <: LitCharacter then "LitCharacter"
    elseiftype A <: LitString then "LitString"
    elseiftype A <: LitLocation then "LitLocation"
    elseiftype A <: EOF then "EOF"
    elseiftype A <: NewLine then "NewLine"
    elseiftype A <: Use then "Use"
    elseiftype A <: Colon then "Colon"
    elseiftype A <: Semicolon then "Semicolon"
    elseiftype A <: Comma then "Comma"
    elseiftype A <: Constant then "Constant"
    elseiftype A <: Pipe then "Pipe"
    elseiftype A <: Ampersand then "Ampersand"
    elseiftype A <: SubType then "SubType"
    elseiftype A <: Arrow then "Arrow"
    elseiftype A <: DoubleArrow then "DoubleArrow"
    elseiftype A <: Backslash then "Backslash"
    elseiftype A <: LParen then "LParen"
    elseiftype A <: RParen then "RParen"
    elseiftype A <: LBrace then "LBrace"
    elseiftype A <: RBrace then "RBrace"
    elseiftype A <: LSquare then "LSquare"
    elseiftype A <: RSquare then "RSquare"
    elseiftype A <: LParenNew then "LParenNew"
    elseiftype A <: LBraceNew then "LBraceNew"
    elseiftype A <: LSquareNew then "LSquareNew"
    elseiftype A <: SubNew then "SubNew"
    elseiftype A <: SubUnsafeNew then "SubUnsafeNew"
    elseiftype A <: In then "In"
    elseiftype A <: Until then "Until"
    elseiftype A <: Do then "Do"
    elseiftype A <: Else then "Else"
    elseiftype A <: ElseIf then "ElseIf"
    elseiftype A <: Then then "Then"
    elseiftype A <: End then "End"
    elseiftype A <: Var then "Var"
    elseiftype A <: Let then "Let"
    elseiftype A <: Embed then "Embed"
    elseiftype A <: Where then "Where"
    else "???"
    end

type BinaryOp is (GTUnsafe | NEUnsafe | LEUnsafe | MulUnsafe | GE | Eq | LTUnsafe | GEUnsafe | Is | And | EqUnsafe | DivUnsafe | NE | Div | AddUnsafe | XOr | SubUnsafe | Mod | Or | Mul | ModUnsafe | Sub | RShiftUnsafe | GT | Add | LT | RShift | LShift | Isnt | LShiftUnsafe | LE)

type Cap is (Ref | Val | Tag | Box | Trn | Iso)

type LitBool is (LitTrue | LitFalse)

type Type is (LiteralTypeBranch | LambdaType | FunType | OpLiteralType | IsectType | TypeParamRef | ErrorType | NominalType | DontCareType | LiteralType | TupleType | ArrowType | ThisType | UnionType)

type Field is (FieldVar | FieldLet | FieldEmbed)

type IfDefBinaryOp is (IfDefAnd | IfDefOr)

type GenCap is (CapAlias | CapAny | CapRead | CapSend | CapShare)

type Local is (LocalVar | LocalLet)

type MethodRef is (MethodNewRef | MethodFunRef | MethodBeRef)

type Jump is (Continue | Error | Break | Return)

type UseDecl is (UseFFIDecl | UsePackage)

type Lexeme is (SubUnsafeNew | Where | LSquareNew | Let | Else | DoubleArrow | SubType | Use | Comma | LBrace | RParen | LBraceNew | In | Then | LParen | Arrow | Ampersand | Semicolon | EOF | Colon | Constant | Pipe | LParenNew | Until | Embed | NewLine | RBrace | Backslash | RSquare | End | LSquare | ElseIf | Do | Var | SubNew)

type TypeDecl is (Trait | Primitive | Struct | Actor | Class | Interface | TypeAlias)

type IfDefCond is (IfDefBinaryOp | IfDefNot | IfDefFlag)

type Method is (MethodFun | MethodNew | MethodBe)

type Expr is (RawExprSeq | Lambda | FFICall | Id | This | For | Qualify | DontCare | Chain | MatchCapture | TypeRef | Jump | TupleElementRef | As | Consume | If | LitBool | CompileIntrinsic | Dot | Repeat | Match | While | LitLocation | IfDef | Object | With | Try | LitCharacter | BinaryOp | Reference | IfType | LitInteger | PackageRef | LocalRef | Assign | Tilde | Local | MethodRef | CompileError | LitString | LitFloat | Tuple | Call | LitArray | FieldRef | Recover | UnaryOp)

type CapMod is (Aliased | Ephemeral)

type FieldRef is (FieldVarRef | FieldLetRef | FieldEmbedRef)

type LocalRef is (LocalLetRef | LocalVarRef | ParamRef)

type UnaryOp is (Neg | AddressOf | NegUnsafe | DigestOf | Not)

class Program is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _packages: Array[Package]
  
  new create(
    packages': Array[Package])
  =>
    _packages = packages'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun packages(): this->Array[Package] => _packages
  
  fun ref set_packages(packages': Array[Package]) => _packages = consume packages'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Program")
    s.push('(')
    let packages_iter = _packages.values()
    for v in packages_iter do
      s.append(v.string())
      if packages_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class Package is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _modules: Array[Module]
  var _docs: (LitString | None)
  
  new create(
    modules': Array[Module] = Array[Module],
    docs': (LitString | None) = None)
  =>
    _modules = modules'
    _docs = docs'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun modules(): this->Array[Module] => _modules
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_modules(modules': Array[Module] = Array[Module]) => _modules = consume modules'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Package")
    s.push('(')
    let modules_iter = _modules.values()
    for v in modules_iter do
      s.append(v.string())
      if modules_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

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
    let use_decls_iter = _use_decls.values()
    for v in use_decls_iter do
      s.append(v.string())
      if use_decls_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.>push(',').push(' ')
    let type_decls_iter = _type_decls.values()
    for v in type_decls_iter do
      s.append(v.string())
      if type_decls_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class UsePackage is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _prefix: (Id | None)
  var _package: String
  
  new create(
    prefix': (Id | None) = None,
    package': String)
  =>
    _prefix = prefix'
    _package = package'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun prefix(): this->(Id | None) => _prefix
  fun package(): this->String => _package
  
  fun ref set_prefix(prefix': (Id | None) = None) => _prefix = consume prefix'
  fun ref set_package(package': String) => _package = consume package'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("UsePackage")
    s.push('(')
    s.>append(_prefix.string()).>push(',').push(' ')
    s.>append(_package.string())
    s.push(')')
    consume s

class UseFFIDecl is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _body: FFIDecl
  var _guard: (Expr | IfDefCond | None)
  
  new create(
    body': FFIDecl,
    guard': (Expr | IfDefCond | None) = None)
  =>
    _body = body'
    _guard = guard'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun body(): this->FFIDecl => _body
  fun guard(): this->(Expr | IfDefCond | None) => _guard
  
  fun ref set_body(body': FFIDecl) => _body = consume body'
  fun ref set_guard(guard': (Expr | IfDefCond | None) = None) => _guard = consume guard'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("UseFFIDecl")
    s.push('(')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_guard.string())
    s.push(')')
    consume s

class FFIDecl is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: (Id | LitString)
  var _return_type: TypeArgs
  var _params: (Params | None)
  var _named_params: None
  var _partial: (Question | None)
  
  new create(
    name': (Id | LitString),
    return_type': TypeArgs,
    params': (Params | None),
    named_params': None,
    partial': (Question | None))
  =>
    _name = name'
    _return_type = return_type'
    _params = params'
    _named_params = named_params'
    _partial = partial'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->(Id | LitString) => _name
  fun return_type(): this->TypeArgs => _return_type
  fun params(): this->(Params | None) => _params
  fun named_params(): this->None => _named_params
  fun partial(): this->(Question | None) => _partial
  
  fun ref set_name(name': (Id | LitString)) => _name = consume name'
  fun ref set_return_type(return_type': TypeArgs) => _return_type = consume return_type'
  fun ref set_params(params': (Params | None)) => _params = consume params'
  fun ref set_named_params(named_params': None) => _named_params = consume named_params'
  fun ref set_partial(partial': (Question | None)) => _partial = consume partial'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FFIDecl")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_params.string()).>push(',').push(' ')
    s.>append(_named_params.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class TypeAlias is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _type_params: (TypeParams | None)
  var _cap: (Cap | None)
  var _provides: (Provides | None)
  var _members: (Members | None)
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    type_params': (TypeParams | None) = None,
    cap': (Cap | None) = None,
    provides': (Provides | None) = None,
    members': (Members | None) = None,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
    _name = name'
    _type_params = type_params'
    _cap = cap'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun cap(): this->(Cap | None) => _cap
  fun provides(): this->(Provides | None) => _provides
  fun members(): this->(Members | None) => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None) = None) => _provides = consume provides'
  fun ref set_members(members': (Members | None) = None) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeAlias")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class Interface is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _type_params: (TypeParams | None)
  var _cap: (Cap | None)
  var _provides: (Provides | None)
  var _members: (Members | None)
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    type_params': (TypeParams | None) = None,
    cap': (Cap | None) = None,
    provides': (Provides | None) = None,
    members': (Members | None) = None,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
    _name = name'
    _type_params = type_params'
    _cap = cap'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun cap(): this->(Cap | None) => _cap
  fun provides(): this->(Provides | None) => _provides
  fun members(): this->(Members | None) => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None) = None) => _provides = consume provides'
  fun ref set_members(members': (Members | None) = None) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Interface")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class Trait is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _type_params: (TypeParams | None)
  var _cap: (Cap | None)
  var _provides: (Provides | None)
  var _members: (Members | None)
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    type_params': (TypeParams | None) = None,
    cap': (Cap | None) = None,
    provides': (Provides | None) = None,
    members': (Members | None) = None,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
    _name = name'
    _type_params = type_params'
    _cap = cap'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun cap(): this->(Cap | None) => _cap
  fun provides(): this->(Provides | None) => _provides
  fun members(): this->(Members | None) => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None) = None) => _provides = consume provides'
  fun ref set_members(members': (Members | None) = None) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Trait")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class Primitive is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _type_params: (TypeParams | None)
  var _cap: (Cap | None)
  var _provides: (Provides | None)
  var _members: (Members | None)
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    type_params': (TypeParams | None) = None,
    cap': (Cap | None) = None,
    provides': (Provides | None) = None,
    members': (Members | None) = None,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
    _name = name'
    _type_params = type_params'
    _cap = cap'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun cap(): this->(Cap | None) => _cap
  fun provides(): this->(Provides | None) => _provides
  fun members(): this->(Members | None) => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None) = None) => _provides = consume provides'
  fun ref set_members(members': (Members | None) = None) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Primitive")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class Struct is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _type_params: (TypeParams | None)
  var _cap: (Cap | None)
  var _provides: (Provides | None)
  var _members: (Members | None)
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    type_params': (TypeParams | None) = None,
    cap': (Cap | None) = None,
    provides': (Provides | None) = None,
    members': (Members | None) = None,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
    _name = name'
    _type_params = type_params'
    _cap = cap'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun cap(): this->(Cap | None) => _cap
  fun provides(): this->(Provides | None) => _provides
  fun members(): this->(Members | None) => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None) = None) => _provides = consume provides'
  fun ref set_members(members': (Members | None) = None) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Struct")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class Class is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _type_params: (TypeParams | None)
  var _cap: (Cap | None)
  var _provides: (Provides | None)
  var _members: (Members | None)
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    type_params': (TypeParams | None) = None,
    cap': (Cap | None) = None,
    provides': (Provides | None) = None,
    members': (Members | None) = None,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
    _name = name'
    _type_params = type_params'
    _cap = cap'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun cap(): this->(Cap | None) => _cap
  fun provides(): this->(Provides | None) => _provides
  fun members(): this->(Members | None) => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None) = None) => _provides = consume provides'
  fun ref set_members(members': (Members | None) = None) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Class")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class Actor is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _type_params: (TypeParams | None)
  var _cap: (Cap | None)
  var _provides: (Provides | None)
  var _members: (Members | None)
  var _at: (At | None)
  var _docs: (LitString | None)
  
  new create(
    name': Id,
    type_params': (TypeParams | None) = None,
    cap': (Cap | None) = None,
    provides': (Provides | None) = None,
    members': (Members | None) = None,
    at': (At | None) = None,
    docs': (LitString | None) = None)
  =>
    _name = name'
    _type_params = type_params'
    _cap = cap'
    _provides = provides'
    _members = members'
    _at = at'
    _docs = docs'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun cap(): this->(Cap | None) => _cap
  fun provides(): this->(Provides | None) => _provides
  fun members(): this->(Members | None) => _members
  fun at(): this->(At | None) => _at
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None) = None) => _provides = consume provides'
  fun ref set_members(members': (Members | None) = None) => _members = consume members'
  fun ref set_at(at': (At | None) = None) => _at = consume at'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Actor")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_provides.string()).>push(',').push(' ')
    s.>append(_members.string()).>push(',').push(' ')
    s.>append(_at.string()).>push(',').push(' ')
    s.>append(_docs.string())
    s.push(')')
    consume s

class Provides is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _types: Array[Type]
  
  new create(
    types': Array[Type] = Array[Type])
  =>
    _types = types'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun types(): this->Array[Type] => _types
  
  fun ref set_types(types': Array[Type] = Array[Type]) => _types = consume types'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Provides")
    s.push('(')
    let types_iter = _types.values()
    for v in types_iter do
      s.append(v.string())
      if types_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
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
    let fields_iter = _fields.values()
    for v in fields_iter do
      s.append(v.string())
      if fields_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.>push(',').push(' ')
    let methods_iter = _methods.values()
    for v in methods_iter do
      s.append(v.string())
      if methods_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class FieldLet is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _field_type: (Type | None)
  var _default: (Expr | None)
  
  new create(
    name': Id,
    field_type': (Type | None) = None,
    default': (Expr | None) = None)
  =>
    _name = name'
    _field_type = field_type'
    _default = default'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun field_type(): this->(Type | None) => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': (Type | None) = None) => _field_type = consume field_type'
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

class FieldVar is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _field_type: (Type | None)
  var _default: (Expr | None)
  
  new create(
    name': Id,
    field_type': (Type | None) = None,
    default': (Expr | None) = None)
  =>
    _name = name'
    _field_type = field_type'
    _default = default'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun field_type(): this->(Type | None) => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': (Type | None) = None) => _field_type = consume field_type'
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

class FieldEmbed is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _field_type: (Type | None)
  var _default: (Expr | None)
  
  new create(
    name': Id,
    field_type': (Type | None) = None,
    default': (Expr | None) = None)
  =>
    _name = name'
    _field_type = field_type'
    _default = default'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun field_type(): this->(Type | None) => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': (Type | None) = None) => _field_type = consume field_type'
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

class MethodFun is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _cap: (Cap | None)
  var _name: Id
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _body: (RawExprSeq | None)
  var _docs: (LitString | None)
  var _guard: (RawExprSeq | None)
  
  new create(
    cap': (Cap | None) = None,
    name': Id,
    type_params': (TypeParams | None) = None,
    params': (Params | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    body': (RawExprSeq | None) = None,
    docs': (LitString | None) = None,
    guard': (RawExprSeq | None) = None)
  =>
    _cap = cap'
    _name = name'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
    _partial = partial'
    _body = body'
    _docs = docs'
    _guard = guard'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun cap(): this->(Cap | None) => _cap
  fun name(): this->Id => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun body(): this->(RawExprSeq | None) => _body
  fun docs(): this->(LitString | None) => _docs
  fun guard(): this->(RawExprSeq | None) => _guard
  
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_body(body': (RawExprSeq | None) = None) => _body = consume body'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  fun ref set_guard(guard': (RawExprSeq | None) = None) => _guard = consume guard'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodFun")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_params.string()).>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_partial.string()).>push(',').push(' ')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_docs.string()).>push(',').push(' ')
    s.>append(_guard.string())
    s.push(')')
    consume s

class MethodNew is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _cap: (Cap | None)
  var _name: Id
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _body: (RawExprSeq | None)
  var _docs: (LitString | None)
  var _guard: (RawExprSeq | None)
  
  new create(
    cap': (Cap | None) = None,
    name': Id,
    type_params': (TypeParams | None) = None,
    params': (Params | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    body': (RawExprSeq | None) = None,
    docs': (LitString | None) = None,
    guard': (RawExprSeq | None) = None)
  =>
    _cap = cap'
    _name = name'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
    _partial = partial'
    _body = body'
    _docs = docs'
    _guard = guard'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun cap(): this->(Cap | None) => _cap
  fun name(): this->Id => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun body(): this->(RawExprSeq | None) => _body
  fun docs(): this->(LitString | None) => _docs
  fun guard(): this->(RawExprSeq | None) => _guard
  
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_body(body': (RawExprSeq | None) = None) => _body = consume body'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  fun ref set_guard(guard': (RawExprSeq | None) = None) => _guard = consume guard'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodNew")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_params.string()).>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_partial.string()).>push(',').push(' ')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_docs.string()).>push(',').push(' ')
    s.>append(_guard.string())
    s.push(')')
    consume s

class MethodBe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _cap: (Cap | None)
  var _name: Id
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _body: (RawExprSeq | None)
  var _docs: (LitString | None)
  var _guard: (RawExprSeq | None)
  
  new create(
    cap': (Cap | None) = None,
    name': Id,
    type_params': (TypeParams | None) = None,
    params': (Params | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    body': (RawExprSeq | None) = None,
    docs': (LitString | None) = None,
    guard': (RawExprSeq | None) = None)
  =>
    _cap = cap'
    _name = name'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
    _partial = partial'
    _body = body'
    _docs = docs'
    _guard = guard'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun cap(): this->(Cap | None) => _cap
  fun name(): this->Id => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun body(): this->(RawExprSeq | None) => _body
  fun docs(): this->(LitString | None) => _docs
  fun guard(): this->(RawExprSeq | None) => _guard
  
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_body(body': (RawExprSeq | None) = None) => _body = consume body'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'
  fun ref set_guard(guard': (RawExprSeq | None) = None) => _guard = consume guard'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MethodBe")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_params.string()).>push(',').push(' ')
    s.>append(_params.string()).>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_partial.string()).>push(',').push(' ')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_docs.string()).>push(',').push(' ')
    s.>append(_guard.string())
    s.push(')')
    consume s

class TypeParams is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[TypeParam]
  
  new create(
    list': Array[TypeParam] = Array[TypeParam])
  =>
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[TypeParam] => _list
  
  fun ref set_list(list': Array[TypeParam] = Array[TypeParam]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeParams")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class TypeParam is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _constraint: (Type | None)
  var _default: (Type | None)
  
  new create(
    name': Id,
    constraint': (Type | None),
    default': (Type | None))
  =>
    _name = name'
    _constraint = constraint'
    _default = default'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun constraint(): this->(Type | None) => _constraint
  fun default(): this->(Type | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_constraint(constraint': (Type | None)) => _constraint = consume constraint'
  fun ref set_default(default': (Type | None)) => _default = consume default'
  
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeArgs")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
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
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
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

class ExprSeq is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Expr]
  
  new create(
    list': Array[Expr] = Array[Expr])
  =>
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Expr] => _list
  
  fun ref set_list(list': Array[Expr] = Array[Expr]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ExprSeq")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class RawExprSeq is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Expr]
  
  new create(
    list': Array[Expr] = Array[Expr])
  =>
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Expr] => _list
  
  fun ref set_list(list': Array[Expr] = Array[Expr]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RawExprSeq")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class Return is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _value: RawExprSeq
  
  new create(
    value': RawExprSeq)
  =>
    _value = value'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): this->RawExprSeq => _value
  
  fun ref set_value(value': RawExprSeq) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Return")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class Break is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _value: RawExprSeq
  
  new create(
    value': RawExprSeq)
  =>
    _value = value'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): this->RawExprSeq => _value
  
  fun ref set_value(value': RawExprSeq) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Break")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class Continue is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _value: RawExprSeq
  
  new create(
    value': RawExprSeq)
  =>
    _value = value'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): this->RawExprSeq => _value
  
  fun ref set_value(value': RawExprSeq) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Continue")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class Error is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _value: RawExprSeq
  
  new create(
    value': RawExprSeq)
  =>
    _value = value'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): this->RawExprSeq => _value
  
  fun ref set_value(value': RawExprSeq) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Error")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class CompileIntrinsic is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CompileIntrinsic")
    consume s

class CompileError is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _message: RawExprSeq
  
  new create(
    message': RawExprSeq)
  =>
    _message = message'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun message(): this->RawExprSeq => _message
  
  fun ref set_message(message': RawExprSeq) => _message = consume message'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CompileError")
    s.push('(')
    s.>append(_message.string())
    s.push(')')
    consume s

class LocalLet is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _local_type: (Type | None)
  
  new create(
    name': Id,
    local_type': (Type | None))
  =>
    _name = name'
    _local_type = local_type'
  
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

class LocalVar is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _local_type: (Type | None)
  
  new create(
    name': Id,
    local_type': (Type | None))
  =>
    _name = name'
    _local_type = local_type'
  
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

class MatchCapture is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _local_type: Type
  
  new create(
    name': Id,
    local_type': Type)
  =>
    _name = name'
    _local_type = local_type'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun local_type(): this->Type => _local_type
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_local_type(local_type': Type) => _local_type = consume local_type'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MatchCapture")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_local_type.string())
    s.push(')')
    consume s

class As is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  var _as_type: Type
  
  new create(
    expr': Expr,
    as_type': Type)
  =>
    _expr = expr'
    _as_type = as_type'
  
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

class Tuple is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _elements: Array[RawExprSeq]
  
  new create(
    elements': Array[RawExprSeq] = Array[RawExprSeq])
  =>
    _elements = elements'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun elements(): this->Array[RawExprSeq] => _elements
  
  fun ref set_elements(elements': Array[RawExprSeq] = Array[RawExprSeq]) => _elements = consume elements'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Tuple")
    s.push('(')
    let elements_iter = _elements.values()
    for v in elements_iter do
      s.append(v.string())
      if elements_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class Consume is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _cap: (Cap | None)
  var _expr: Expr
  
  new create(
    cap': (Cap | None),
    expr': Expr)
  =>
    _cap = cap'
    _expr = expr'
  
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

class Recover is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _cap: (Cap | None)
  var _expr: Expr
  
  new create(
    cap': (Cap | None),
    expr': Expr)
  =>
    _cap = cap'
    _expr = expr'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun cap(): this->(Cap | None) => _cap
  fun expr(): this->Expr => _expr
  
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Recover")
    s.push('(')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_expr.string())
    s.push(')')
    consume s

class Not is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
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

class Neg is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
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

class NegUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
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

class AddressOf is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
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

class DigestOf is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
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

class Add is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class AddUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class Sub is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class SubUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class Mul is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class MulUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class Div is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class DivUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class Mod is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class ModUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class LShift is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class LShiftUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class RShift is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class RShiftUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class Eq is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class EqUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class NE is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class NEUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class LT is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class LTUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class LE is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class LEUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class GE is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class GEUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class GT is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class GTUnsafe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class Is is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class Isnt is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class And is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class Or is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class XOr is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
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

class Assign is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _right: Expr
  var _left: Expr
  
  new create(
    right': Expr,
    left': Expr)
  =>
    _right = right'
    _left = left'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun right(): this->Expr => _right
  fun left(): this->Expr => _left
  
  fun ref set_right(right': Expr) => _right = consume right'
  fun ref set_left(left': Expr) => _left = consume left'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Assign")
    s.push('(')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_left.string())
    s.push(')')
    consume s

class Dot is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: (Id | LitInteger | TypeArgs)
  
  new create(
    left': Expr,
    right': (Id | LitInteger | TypeArgs))
  =>
    _left = left'
    _right = right'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Expr => _left
  fun right(): this->(Id | LitInteger | TypeArgs) => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': (Id | LitInteger | TypeArgs)) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Dot")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Chain is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Id
  
  new create(
    left': Expr,
    right': Id)
  =>
    _left = left'
    _right = right'
  
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

class Tilde is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: Id
  
  new create(
    left': Expr,
    right': Id)
  =>
    _left = left'
    _right = right'
  
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

class Qualify is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Expr
  var _right: TypeArgs
  
  new create(
    left': Expr,
    right': TypeArgs)
  =>
    _left = left'
    _right = right'
  
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

class Call is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _args: (Args | None)
  var _named_args: (NamedArgs | None)
  var _receiver: Expr
  
  new create(
    args': (Args | None) = None,
    named_args': (NamedArgs | None) = None,
    receiver': Expr)
  =>
    _args = args'
    _named_args = named_args'
    _receiver = receiver'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun args(): this->(Args | None) => _args
  fun named_args(): this->(NamedArgs | None) => _named_args
  fun receiver(): this->Expr => _receiver
  
  fun ref set_args(args': (Args | None) = None) => _args = consume args'
  fun ref set_named_args(named_args': (NamedArgs | None) = None) => _named_args = consume named_args'
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Call")
    s.push('(')
    s.>append(_args.string()).>push(',').push(' ')
    s.>append(_named_args.string()).>push(',').push(' ')
    s.>append(_receiver.string())
    s.push(')')
    consume s

class FFICall is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: (Id | LitString)
  var _type_args: (TypeArgs | None)
  var _args: (Args | None)
  var _named_args: (NamedArgs | None)
  var _partial: (Question | None)
  
  new create(
    name': (Id | LitString),
    type_args': (TypeArgs | None) = None,
    args': (Args | None) = None,
    named_args': (NamedArgs | None) = None,
    partial': (Question | None) = None)
  =>
    _name = name'
    _type_args = type_args'
    _args = args'
    _named_args = named_args'
    _partial = partial'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->(Id | LitString) => _name
  fun type_args(): this->(TypeArgs | None) => _type_args
  fun args(): this->(Args | None) => _args
  fun named_args(): this->(NamedArgs | None) => _named_args
  fun partial(): this->(Question | None) => _partial
  
  fun ref set_name(name': (Id | LitString)) => _name = consume name'
  fun ref set_type_args(type_args': (TypeArgs | None) = None) => _type_args = consume type_args'
  fun ref set_args(args': (Args | None) = None) => _args = consume args'
  fun ref set_named_args(named_args': (NamedArgs | None) = None) => _named_args = consume named_args'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FFICall")
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
  
  var _list: Array[RawExprSeq]
  
  new create(
    list': Array[RawExprSeq] = Array[RawExprSeq])
  =>
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[RawExprSeq] => _list
  
  fun ref set_list(list': Array[RawExprSeq] = Array[RawExprSeq]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Args")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class NamedArgs is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[NamedArg]
  
  new create(
    list': Array[NamedArg] = Array[NamedArg])
  =>
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[NamedArg] => _list
  
  fun ref set_list(list': Array[NamedArg] = Array[NamedArg]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NamedArgs")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class NamedArg is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  var _value: RawExprSeq
  
  new create(
    name': Id,
    value': RawExprSeq)
  =>
    _name = name'
    _value = value'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  fun value(): this->RawExprSeq => _value
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_value(value': RawExprSeq) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NamedArg")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_value.string())
    s.push(')')
    consume s

class IfDef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _then_expr: (Expr | IfDefCond)
  var _then_body: ExprSeq
  var _else_body: (Expr | IfDef | None)
  var _else_expr: (None | IfDefCond)
  
  new create(
    then_expr': (Expr | IfDefCond),
    then_body': ExprSeq,
    else_body': (Expr | IfDef | None),
    else_expr': (None | IfDefCond))
  =>
    _then_expr = then_expr'
    _then_body = then_body'
    _else_body = else_body'
    _else_expr = else_expr'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun then_expr(): this->(Expr | IfDefCond) => _then_expr
  fun then_body(): this->ExprSeq => _then_body
  fun else_body(): this->(Expr | IfDef | None) => _else_body
  fun else_expr(): this->(None | IfDefCond) => _else_expr
  
  fun ref set_then_expr(then_expr': (Expr | IfDefCond)) => _then_expr = consume then_expr'
  fun ref set_then_body(then_body': ExprSeq) => _then_body = consume then_body'
  fun ref set_else_body(else_body': (Expr | IfDef | None)) => _else_body = consume else_body'
  fun ref set_else_expr(else_expr': (None | IfDefCond)) => _else_expr = consume else_expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDef")
    s.push('(')
    s.>append(_then_expr.string()).>push(',').push(' ')
    s.>append(_then_body.string()).>push(',').push(' ')
    s.>append(_else_body.string()).>push(',').push(' ')
    s.>append(_else_expr.string())
    s.push(')')
    consume s

class IfType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _sub: TypeRef
  var _super: TypeRef
  var _then_body: ExprSeq
  var _else_body: (Expr | IfType | None)
  
  new create(
    sub': TypeRef,
    super': TypeRef,
    then_body': ExprSeq,
    else_body': (Expr | IfType | None))
  =>
    _sub = sub'
    _super = super'
    _then_body = then_body'
    _else_body = else_body'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun sub(): this->TypeRef => _sub
  fun super(): this->TypeRef => _super
  fun then_body(): this->ExprSeq => _then_body
  fun else_body(): this->(Expr | IfType | None) => _else_body
  
  fun ref set_sub(sub': TypeRef) => _sub = consume sub'
  fun ref set_super(super': TypeRef) => _super = consume super'
  fun ref set_then_body(then_body': ExprSeq) => _then_body = consume then_body'
  fun ref set_else_body(else_body': (Expr | IfType | None)) => _else_body = consume else_body'
  
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

class IfDefAnd is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: IfDefCond
  var _right: IfDefCond
  
  new create(
    left': IfDefCond,
    right': IfDefCond)
  =>
    _left = left'
    _right = right'
  
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

class IfDefOr is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: IfDefCond
  var _right: IfDefCond
  
  new create(
    left': IfDefCond,
    right': IfDefCond)
  =>
    _left = left'
    _right = right'
  
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

class IfDefNot is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: IfDefCond
  
  new create(
    expr': IfDefCond)
  =>
    _expr = expr'
  
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

class IfDefFlag is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefFlag")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class If is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _condition: RawExprSeq
  var _then_body: ExprSeq
  var _else_body: (ExprSeq | If | None)
  
  new create(
    condition': RawExprSeq,
    then_body': ExprSeq,
    else_body': (ExprSeq | If | None) = None)
  =>
    _condition = condition'
    _then_body = then_body'
    _else_body = else_body'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun condition(): this->RawExprSeq => _condition
  fun then_body(): this->ExprSeq => _then_body
  fun else_body(): this->(ExprSeq | If | None) => _else_body
  
  fun ref set_condition(condition': RawExprSeq) => _condition = consume condition'
  fun ref set_then_body(then_body': ExprSeq) => _then_body = consume then_body'
  fun ref set_else_body(else_body': (ExprSeq | If | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("If")
    s.push('(')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_then_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class While is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _condition: RawExprSeq
  var _loop_body: ExprSeq
  var _else_body: (ExprSeq | None)
  
  new create(
    condition': RawExprSeq,
    loop_body': ExprSeq,
    else_body': (ExprSeq | None) = None)
  =>
    _condition = condition'
    _loop_body = loop_body'
    _else_body = else_body'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun condition(): this->RawExprSeq => _condition
  fun loop_body(): this->ExprSeq => _loop_body
  fun else_body(): this->(ExprSeq | None) => _else_body
  
  fun ref set_condition(condition': RawExprSeq) => _condition = consume condition'
  fun ref set_loop_body(loop_body': ExprSeq) => _loop_body = consume loop_body'
  fun ref set_else_body(else_body': (ExprSeq | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("While")
    s.push('(')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_loop_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class Repeat is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _loop_body: ExprSeq
  var _condition: RawExprSeq
  var _else_body: (ExprSeq | None)
  
  new create(
    loop_body': ExprSeq,
    condition': RawExprSeq,
    else_body': (ExprSeq | None) = None)
  =>
    _loop_body = loop_body'
    _condition = condition'
    _else_body = else_body'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun loop_body(): this->ExprSeq => _loop_body
  fun condition(): this->RawExprSeq => _condition
  fun else_body(): this->(ExprSeq | None) => _else_body
  
  fun ref set_loop_body(loop_body': ExprSeq) => _loop_body = consume loop_body'
  fun ref set_condition(condition': RawExprSeq) => _condition = consume condition'
  fun ref set_else_body(else_body': (ExprSeq | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Repeat")
    s.push('(')
    s.>append(_loop_body.string()).>push(',').push(' ')
    s.>append(_condition.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class For is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: ExprSeq
  var _iterator: RawExprSeq
  var _loop_body: RawExprSeq
  var _else_body: (ExprSeq | None)
  
  new create(
    expr': ExprSeq,
    iterator': RawExprSeq,
    loop_body': RawExprSeq,
    else_body': (ExprSeq | None) = None)
  =>
    _expr = expr'
    _iterator = iterator'
    _loop_body = loop_body'
    _else_body = else_body'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->ExprSeq => _expr
  fun iterator(): this->RawExprSeq => _iterator
  fun loop_body(): this->RawExprSeq => _loop_body
  fun else_body(): this->(ExprSeq | None) => _else_body
  
  fun ref set_expr(expr': ExprSeq) => _expr = consume expr'
  fun ref set_iterator(iterator': RawExprSeq) => _iterator = consume iterator'
  fun ref set_loop_body(loop_body': RawExprSeq) => _loop_body = consume loop_body'
  fun ref set_else_body(else_body': (ExprSeq | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("For")
    s.push('(')
    s.>append(_expr.string()).>push(',').push(' ')
    s.>append(_iterator.string()).>push(',').push(' ')
    s.>append(_loop_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class With is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _refs: Expr
  var _with_body: RawExprSeq
  var _else_body: (RawExprSeq | None)
  
  new create(
    refs': Expr,
    with_body': RawExprSeq,
    else_body': (RawExprSeq | None) = None)
  =>
    _refs = refs'
    _with_body = with_body'
    _else_body = else_body'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun refs(): this->Expr => _refs
  fun with_body(): this->RawExprSeq => _with_body
  fun else_body(): this->(RawExprSeq | None) => _else_body
  
  fun ref set_refs(refs': Expr) => _refs = consume refs'
  fun ref set_with_body(with_body': RawExprSeq) => _with_body = consume with_body'
  fun ref set_else_body(else_body': (RawExprSeq | None) = None) => _else_body = consume else_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("With")
    s.push('(')
    s.>append(_refs.string()).>push(',').push(' ')
    s.>append(_with_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class Match is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: RawExprSeq
  var _cases: (Cases | None)
  var _else_body: (ExprSeq | None)
  
  new create(
    expr': RawExprSeq,
    cases': (Cases | None) = None,
    else_body': (ExprSeq | None) = None)
  =>
    _expr = expr'
    _cases = cases'
    _else_body = else_body'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->RawExprSeq => _expr
  fun cases(): this->(Cases | None) => _cases
  fun else_body(): this->(ExprSeq | None) => _else_body
  
  fun ref set_expr(expr': RawExprSeq) => _expr = consume expr'
  fun ref set_cases(cases': (Cases | None) = None) => _cases = consume cases'
  fun ref set_else_body(else_body': (ExprSeq | None) = None) => _else_body = consume else_body'
  
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Case] => _list
  
  fun ref set_list(list': Array[Case] = Array[Case]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Cases")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class Case is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _expr: (Expr | None)
  var _guard: (RawExprSeq | None)
  var _body: (RawExprSeq | None)
  
  new create(
    expr': (Expr | None) = None,
    guard': (RawExprSeq | None) = None,
    body': (RawExprSeq | None) = None)
  =>
    _expr = expr'
    _guard = guard'
    _body = body'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun expr(): this->(Expr | None) => _expr
  fun guard(): this->(RawExprSeq | None) => _guard
  fun body(): this->(RawExprSeq | None) => _body
  
  fun ref set_expr(expr': (Expr | None) = None) => _expr = consume expr'
  fun ref set_guard(guard': (RawExprSeq | None) = None) => _guard = consume guard'
  fun ref set_body(body': (RawExprSeq | None) = None) => _body = consume body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Case")
    s.push('(')
    s.>append(_expr.string()).>push(',').push(' ')
    s.>append(_guard.string()).>push(',').push(' ')
    s.>append(_body.string())
    s.push(')')
    consume s

class Try is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _body: ExprSeq
  var _else_body: (ExprSeq | None)
  var _then_body: (ExprSeq | None)
  
  new create(
    body': ExprSeq,
    else_body': (ExprSeq | None) = None,
    then_body': (ExprSeq | None) = None)
  =>
    _body = body'
    _else_body = else_body'
    _then_body = then_body'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun body(): this->ExprSeq => _body
  fun else_body(): this->(ExprSeq | None) => _else_body
  fun then_body(): this->(ExprSeq | None) => _then_body
  
  fun ref set_body(body': ExprSeq) => _body = consume body'
  fun ref set_else_body(else_body': (ExprSeq | None) = None) => _else_body = consume else_body'
  fun ref set_then_body(then_body': (ExprSeq | None) = None) => _then_body = consume then_body'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Try")
    s.push('(')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_else_body.string()).>push(',').push(' ')
    s.>append(_then_body.string())
    s.push(')')
    consume s

class Lambda is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _method_cap: (Cap | None)
  var _name: (Id | None)
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _captures: (LambdaCaptures | None)
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _body: (RawExprSeq)
  var _object_cap: (Cap | None)
  
  new create(
    method_cap': (Cap | None) = None,
    name': (Id | None) = None,
    type_params': (TypeParams | None) = None,
    params': (Params | None) = None,
    captures': (LambdaCaptures | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    body': (RawExprSeq),
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun method_cap(): this->(Cap | None) => _method_cap
  fun name(): this->(Id | None) => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun captures(): this->(LambdaCaptures | None) => _captures
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun body(): this->(RawExprSeq) => _body
  fun object_cap(): this->(Cap | None) => _object_cap
  
  fun ref set_method_cap(method_cap': (Cap | None) = None) => _method_cap = consume method_cap'
  fun ref set_name(name': (Id | None) = None) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_captures(captures': (LambdaCaptures | None) = None) => _captures = consume captures'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_body(body': (RawExprSeq)) => _body = consume body'
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[LambdaCapture] => _list
  
  fun ref set_list(list': Array[LambdaCapture] = Array[LambdaCapture]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LambdaCaptures")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
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

class Object is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _cap: (Cap | None)
  var _provides: (Provides | None)
  var _members: (Members | None)
  
  new create(
    cap': (Cap | None) = None,
    provides': (Provides | None) = None,
    members': (Members | None) = None)
  =>
    _cap = cap'
    _provides = provides'
    _members = members'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun cap(): this->(Cap | None) => _cap
  fun provides(): this->(Provides | None) => _provides
  fun members(): this->(Members | None) => _members
  
  fun ref set_cap(cap': (Cap | None) = None) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None) = None) => _provides = consume provides'
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

class LitArray is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[RawExprSeq]
  
  new create(
    list': Array[RawExprSeq] = Array[RawExprSeq])
  =>
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[RawExprSeq] => _list
  
  fun ref set_list(list': Array[RawExprSeq] = Array[RawExprSeq]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitArray")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class Reference is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
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

class DontCare is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DontCare")
    consume s

class PackageRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
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

class MethodFunRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
    _receiver = receiver'
    _name = name'
  
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

class MethodNewRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
    _receiver = receiver'
    _name = name'
  
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

class MethodBeRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
    _receiver = receiver'
    _name = name'
  
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

class TypeRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _package: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    package': Expr,
    name': (Id | TypeArgs))
  =>
    _package = package'
    _name = name'
  
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

class FieldLetRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: Id
  
  new create(
    receiver': Expr,
    name': Id)
  =>
    _receiver = receiver'
    _name = name'
  
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

class FieldVarRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: Id
  
  new create(
    receiver': Expr,
    name': Id)
  =>
    _receiver = receiver'
    _name = name'
  
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

class FieldEmbedRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: Id
  
  new create(
    receiver': Expr,
    name': Id)
  =>
    _receiver = receiver'
    _name = name'
  
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

class TupleElementRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _receiver: Expr
  var _name: LitInteger
  
  new create(
    receiver': Expr,
    name': LitInteger)
  =>
    _receiver = receiver'
    _name = name'
  
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

class LocalLetRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
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

class LocalVarRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
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

class ParamRef is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
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

class UnionType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("UnionType")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class IsectType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IsectType")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class TupleType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TupleType")
    s.push('(')
    let list_iter = _list.values()
    for v in list_iter do
      s.append(v.string())
      if list_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.push(')')
    consume s

class ArrowType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _left: Type
  var _right: Type
  
  new create(
    left': Type,
    right': Type)
  =>
    _left = left'
    _right = right'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun left(): this->Type => _left
  fun right(): this->Type => _right
  
  fun ref set_left(left': Type) => _left = consume left'
  fun ref set_right(right': Type) => _right = consume right'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ArrowType")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class FunType is AST
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

class LambdaType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _method_cap: (Cap | None)
  var _name: (Id | None)
  var _type_params: (TypeParams | None)
  var _param_types: Array[Type]
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _object_cap: (Cap | GenCap | None)
  var _cap_mod: (CapMod | None)
  
  new create(
    method_cap': (Cap | None) = None,
    name': (Id | None) = None,
    type_params': (TypeParams | None) = None,
    param_types': Array[Type] = Array[Type],
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
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun method_cap(): this->(Cap | None) => _method_cap
  fun name(): this->(Id | None) => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun param_types(): this->Array[Type] => _param_types
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun object_cap(): this->(Cap | GenCap | None) => _object_cap
  fun cap_mod(): this->(CapMod | None) => _cap_mod
  
  fun ref set_method_cap(method_cap': (Cap | None) = None) => _method_cap = consume method_cap'
  fun ref set_name(name': (Id | None) = None) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_param_types(param_types': Array[Type] = Array[Type]) => _param_types = consume param_types'
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
    let param_types_iter = _param_types.values()
    for v in param_types_iter do
      s.append(v.string())
      if param_types_iter.has_next() then
        s.>push(',').push(' ')
      end
    end
    s.>push(',').push(' ')
    s.>append(_return_type.string()).>push(',').push(' ')
    s.>append(_partial.string()).>push(',').push(' ')
    s.>append(_object_cap.string()).>push(',').push(' ')
    s.>append(_cap_mod.string())
    s.push(')')
    consume s

class NominalType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  var _package: (Id | None)
  var _name: Id
  var _type_args: (TypeArgs | None)
  var _cap: (Cap | GenCap | None)
  var _cap_mod: (CapMod | None)
  
  new create(
    package': (Id | None) = None,
    name': Id,
    type_args': (TypeArgs | None) = None,
    cap': (Cap | GenCap | None) = None,
    cap_mod': (CapMod | None) = None)
  =>
    _package = package'
    _name = name'
    _type_args = type_args'
    _cap = cap'
    _cap_mod = cap_mod'
  
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun package(): this->(Id | None) => _package
  fun name(): this->Id => _name
  fun type_args(): this->(TypeArgs | None) => _type_args
  fun cap(): this->(Cap | GenCap | None) => _cap
  fun cap_mod(): this->(CapMod | None) => _cap_mod
  
  fun ref set_package(package': (Id | None) = None) => _package = consume package'
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_args(type_args': (TypeArgs | None) = None) => _type_args = consume type_args'
  fun ref set_cap(cap': (Cap | GenCap | None) = None) => _cap = consume cap'
  fun ref set_cap_mod(cap_mod': (CapMod | None) = None) => _cap_mod = consume cap_mod'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NominalType")
    s.push('(')
    s.>append(_package.string()).>push(',').push(' ')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_type_args.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_cap_mod.string())
    s.push(')')
    consume s

class TypeParamRef is AST
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

class ThisType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ThisType")
    consume s

class DontCareType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DontCareType")
    consume s

class ErrorType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ErrorType")
    consume s

class LiteralType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LiteralType")
    consume s

class LiteralTypeBranch is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LiteralTypeBranch")
    consume s

class OpLiteralType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("OpLiteralType")
    consume s

class Iso is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Iso")
    consume s

class Trn is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Trn")
    consume s

class Ref is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ref")
    consume s

class Val is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Val")
    consume s

class Box is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Box")
    consume s

class Tag is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Tag")
    consume s

class CapRead is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapRead")
    consume s

class CapSend is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapSend")
    consume s

class CapShare is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapShare")
    consume s

class CapAlias is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapAlias")
    consume s

class CapAny is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapAny")
    consume s

class Aliased is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Aliased")
    consume s

class Ephemeral is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ephemeral")
    consume s

class At is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("At")
    consume s

class Question is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Question")
    consume s

class Ellipsis is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
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
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): String => _value
  fun ref set_value(value': String) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("Id(").>append(_value.string()).>push(')')
    end

class This is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("This")
    consume s

class LitTrue is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitTrue")
    consume s

class LitFalse is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitFalse")
    consume s

class LitFloat is AST
  var _pos: SourcePosAny = SourcePosNone
  var _value: F64
  new create(value': F64) => _value = value'
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): F64 => _value
  fun ref set_value(value': F64) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitFloat(").>append(_value.string()).>push(')')
    end

class LitInteger is AST
  var _pos: SourcePosAny = SourcePosNone
  var _value: I128
  new create(value': I128) => _value = value'
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): I128 => _value
  fun ref set_value(value': I128) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitInteger(").>append(_value.string()).>push(')')
    end

class LitCharacter is AST
  var _pos: SourcePosAny = SourcePosNone
  var _value: U8
  new create(value': U8) => _value = value'
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): U8 => _value
  fun ref set_value(value': U8) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitCharacter(").>append(_value.string()).>push(')')
    end

class LitString is AST
  var _pos: SourcePosAny = SourcePosNone
  var _value: String
  new create(value': String) => _value = value'
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun value(): String => _value
  fun ref set_value(value': String) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitString(").>append(_value.string()).>push(')')
    end

class LitLocation is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitLocation")
    consume s

class EOF is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("EOF")
    consume s

class NewLine is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NewLine")
    consume s

class Use is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Use")
    consume s

class Colon is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Colon")
    consume s

class Semicolon is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Semicolon")
    consume s

class Comma is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Comma")
    consume s

class Constant is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Constant")
    consume s

class Pipe is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Pipe")
    consume s

class Ampersand is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ampersand")
    consume s

class SubType is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("SubType")
    consume s

class Arrow is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Arrow")
    consume s

class DoubleArrow is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DoubleArrow")
    consume s

class Backslash is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Backslash")
    consume s

class LParen is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LParen")
    consume s

class RParen is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RParen")
    consume s

class LBrace is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LBrace")
    consume s

class RBrace is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RBrace")
    consume s

class LSquare is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LSquare")
    consume s

class RSquare is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RSquare")
    consume s

class LParenNew is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LParenNew")
    consume s

class LBraceNew is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LBraceNew")
    consume s

class LSquareNew is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LSquareNew")
    consume s

class SubNew is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("SubNew")
    consume s

class SubUnsafeNew is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("SubUnsafeNew")
    consume s

class In is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("In")
    consume s

class Until is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Until")
    consume s

class Do is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Do")
    consume s

class Else is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Else")
    consume s

class ElseIf is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ElseIf")
    consume s

class Then is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Then")
    consume s

class End is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("End")
    consume s

class Var is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Var")
    consume s

class Let is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Let")
    consume s

class Embed is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Embed")
    consume s

class Where is AST
  var _pos: SourcePosAny = SourcePosNone
  
  new create() => None
  fun pos(): SourcePosAny => _pos
  fun ref set_pos(pos': SourcePosAny) => _pos = pos'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Where")
    consume s



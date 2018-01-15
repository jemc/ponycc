use coll = "collections/persistent"

trait val AST
  fun val size(): USize
  fun val apply(idx: USize): (AST | None)?
  fun val values(): Iterator[(AST | None)]^ =>
    object is Iterator[(AST | None)]
      let ast: AST = this
      var idx: USize = 0
      fun has_next(): Bool => idx < ast.size()
      fun ref next(): (AST | None)? => ast(idx = idx + 1)?
    end
  fun val attach[A: Any val](a: A): AST
  fun val find_attached[A: Any val](): A?
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)?
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST
  fun val pos(): SourcePosAny
  fun string(): String iso^
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  

primitive ASTInfo
  fun name[A: (AST | None)](): String =>
    iftype A <: None then "x"
    elseif A <: _Program then "_Program"
    elseif A <: Package then "Package"
    elseif A <: PackageTypeDecl then "PackageTypeDecl"
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
    elseif A <: BareLambda then "BareLambda"
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
    elseif A <: BareLambdaType then "BareLambdaType"
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
    elseif A <: Annotation then "Annotation"
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
    elseif A <: AtLBrace then "AtLBrace"
    elseif A <: LBrace then "LBrace"
    elseif A <: RBrace then "RBrace"
    elseif A <: LParen then "LParen"
    elseif A <: RParen then "RParen"
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
  fun val partial(): (Question | None)
  fun val left(): Expr
  fun val right(): Expr
  fun val with_partial(partial': (Question | None)): BinaryOp
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
  fun val cap(): (Cap | At | None)
  fun val docs(): (LitString | None)
  fun val return_type(): (Type | None)
  fun val params(): Params
  fun val guard(): (Sequence | None)
  fun val with_name(name': Id): Method
  fun val with_partial(partial': (Question | None)): Method
  fun val with_type_params(type_params': (TypeParams | None)): Method
  fun val with_body(body': (Sequence | None)): Method
  fun val with_cap(cap': (Cap | At | None)): Method
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

actor _Program
  let _packages: Array[Package] = []
  new create() => None
  be add_package(e: Package) => _packages.push(e)
  be access_packages(fn: {(Array[Package])} val) => fn(_packages)

actor Package
  let _type_decls: Array[PackageTypeDecl] = []
  let _ffi_decls: Array[UseFFIDecl] = []
  let _docs: Array[LitString] = []
  new create() => None
  be add_type_decl(e: PackageTypeDecl) => _type_decls.push(e)
  be access_type_decls(fn: {(Array[PackageTypeDecl])} val) => fn(_type_decls)
  be add_ffi_decl(e: UseFFIDecl) => _ffi_decls.push(e)
  be access_ffi_decls(fn: {(Array[UseFFIDecl])} val) => fn(_ffi_decls)
  be add_doc(e: LitString) => _docs.push(e)
  be access_docs(fn: {(Array[LitString])} val) => fn(_docs)

actor PackageTypeDecl
  let _use_packages: Array[UsePackage] = []
  var _type_decl: TypeDecl
  new create(type_decl': TypeDecl) => _type_decl = type_decl'
  be add_use_package(e: UsePackage) => _use_packages.push(e)
  be access_use_packages(fn: {(Array[UsePackage])} val) => fn(_use_packages)
  be access_type_decl(fn: {(TypeDecl): TypeDecl} val) => _type_decl= fn(_type_decl)

class val Module is AST
  let _attachments: (Attachments | None)
  
  let _use_decls: coll.Vec[UseDecl]
  let _type_decls: coll.Vec[TypeDecl]
  let _docs: (LitString | None)
  
  new val create(
    use_decls': (coll.Vec[UseDecl] | Array[UseDecl] val) = coll.Vec[UseDecl],
    type_decls': (coll.Vec[TypeDecl] | Array[TypeDecl] val) = coll.Vec[TypeDecl],
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _use_decls = 
      match use_decls'
      | let v: coll.Vec[UseDecl] => v
      | let s: Array[UseDecl] val => coll.Vec[UseDecl].concat(s.values())
      end
    _type_decls = 
      match type_decls'
      | let v: coll.Vec[TypeDecl] => v
      | let s: Array[TypeDecl] val => coll.Vec[TypeDecl].concat(s.values())
      end
    _docs = docs'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var use_decls' = coll.Vec[UseDecl]
    var use_decls_next' = try iter.next()? else None end
    while true do
      try use_decls' = use_decls'.push(use_decls_next' as UseDecl) else break end
      try use_decls_next' = iter.next()? else use_decls_next' = None; break end
    end
    var type_decls' = coll.Vec[TypeDecl]
    var type_decls_next' = use_decls_next'
    while true do
      try type_decls' = type_decls'.push(type_decls_next' as TypeDecl) else break end
      try type_decls_next' = iter.next()? else type_decls_next' = None; break end
    end
    let docs': (AST | None) = type_decls_next'
    if
      try
        let extra' = iter.next()?
        errs.push(("Module got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Module => attach[SourcePosAny](pos')
  
  fun val size(): USize => _use_decls.size() + _type_decls.size() + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _use_decls.size()) then return _use_decls(idx - (0 + offset))? end
    offset = (offset + _use_decls.size()) - 1
    if idx < (1 + offset + _type_decls.size()) then return _type_decls(idx - (1 + offset))? end
    offset = (offset + _type_decls.size()) - 1
    if idx == (2 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): Module => create(_use_decls, _type_decls, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val use_decls(): coll.Vec[UseDecl] => _use_decls
  fun val type_decls(): coll.Vec[TypeDecl] => _type_decls
  fun val docs(): (LitString | None) => _docs
  
  fun val with_use_decls(use_decls': (coll.Vec[UseDecl] | Array[UseDecl] val)): Module => create(use_decls', _type_decls, _docs, _attachments)
  fun val with_type_decls(type_decls': (coll.Vec[TypeDecl] | Array[TypeDecl] val)): Module => create(_use_decls, type_decls', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): Module => create(_use_decls, _type_decls, docs', _attachments)
  
  fun val with_use_decls_push(x: val->UseDecl): Module => with_use_decls(_use_decls.push(x))
  
  fun val with_type_decls_push(x: val->TypeDecl): Module => with_type_decls(_type_decls.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "use_decls" => _use_decls(index')?
    | "type_decls" => _type_decls(index')?
    | "docs" => _docs
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _use_decls.find(child' as UseDecl)?
        return create(_use_decls.update(i, replace' as UseDecl)?, _type_decls, _docs, _attachments)
      end
      try
        let i = _type_decls.find(child' as TypeDecl)?
        return create(_use_decls, _type_decls.update(i, replace' as TypeDecl)?, _docs, _attachments)
      end
      if child' is _docs then
        return create(_use_decls, _type_decls, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _prefix: (Id | None)
  let _package: LitString
  
  new val create(
    prefix': (Id | None) = None,
    package': LitString,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _prefix = prefix'
    _package = package'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let prefix': (AST | None) = try iter.next()? else None end
    let package': (AST | None) =
      try iter.next()?
      else errs.push(("UsePackage missing required field: package", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("UsePackage got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): UsePackage => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _prefix end
    if idx == (1 + offset) then return _package end
    error
  fun val attach[A: Any #share](a: A): UsePackage => create(_prefix, _package, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val prefix(): (Id | None) => _prefix
  fun val package(): LitString => _package
  
  fun val with_prefix(prefix': (Id | None)): UsePackage => create(prefix', _package, _attachments)
  fun val with_package(package': LitString): UsePackage => create(_prefix, package', _attachments)
  
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
        return create(replace' as (Id | None), _package, _attachments)
      end
      if child' is _package then
        return create(_prefix, replace' as LitString, _attachments)
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
  let _attachments: (Attachments | None)
  
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
    guard': (IfDefCond | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _return_type = return_type'
    _params = params'
    _partial = partial'
    _guard = guard'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("UseFFIDecl missing required field: name", pos')); error
      end
    let return_type': (AST | None) =
      try iter.next()?
      else errs.push(("UseFFIDecl missing required field: return_type", pos')); error
      end
    let params': (AST | None) =
      try iter.next()?
      else errs.push(("UseFFIDecl missing required field: params", pos')); error
      end
    let partial': (AST | None) =
      try iter.next()?
      else errs.push(("UseFFIDecl missing required field: partial", pos')); error
      end
    let guard': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("UseFFIDecl got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): UseFFIDecl => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _return_type end
    if idx == (2 + offset) then return _params end
    if idx == (3 + offset) then return _partial end
    if idx == (4 + offset) then return _guard end
    error
  fun val attach[A: Any #share](a: A): UseFFIDecl => create(_name, _return_type, _params, _partial, _guard, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): (Id | LitString) => _name
  fun val return_type(): TypeArgs => _return_type
  fun val params(): Params => _params
  fun val partial(): (Question | None) => _partial
  fun val guard(): (IfDefCond | None) => _guard
  
  fun val with_name(name': (Id | LitString)): UseFFIDecl => create(name', _return_type, _params, _partial, _guard, _attachments)
  fun val with_return_type(return_type': TypeArgs): UseFFIDecl => create(_name, return_type', _params, _partial, _guard, _attachments)
  fun val with_params(params': Params): UseFFIDecl => create(_name, _return_type, params', _partial, _guard, _attachments)
  fun val with_partial(partial': (Question | None)): UseFFIDecl => create(_name, _return_type, _params, partial', _guard, _attachments)
  fun val with_guard(guard': (IfDefCond | None)): UseFFIDecl => create(_name, _return_type, _params, _partial, guard', _attachments)
  
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
        return create(replace' as (Id | LitString), _return_type, _params, _partial, _guard, _attachments)
      end
      if child' is _return_type then
        return create(_name, replace' as TypeArgs, _params, _partial, _guard, _attachments)
      end
      if child' is _params then
        return create(_name, _return_type, replace' as Params, _partial, _guard, _attachments)
      end
      if child' is _partial then
        return create(_name, _return_type, _params, replace' as (Question | None), _guard, _attachments)
      end
      if child' is _guard then
        return create(_name, _return_type, _params, _partial, replace' as (IfDefCond | None), _attachments)
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
  let _attachments: (Attachments | None)
  
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
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("TypeAlias missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let provides': (AST | None) = try iter.next()? else None end
    let members': (AST | None) = try iter.next()? else Members end
    let at': (AST | None) = try iter.next()? else None end
    let docs': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("TypeAlias got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): TypeAlias => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _provides end
    if idx == (4 + offset) then return _members end
    if idx == (5 + offset) then return _at end
    if idx == (6 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): TypeAlias => create(_name, _cap, _type_params, _provides, _members, _at, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): TypeAlias => create(name', _cap, _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_cap(cap': (Cap | None)): TypeAlias => create(_name, cap', _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): TypeAlias => create(_name, _cap, type_params', _provides, _members, _at, _docs, _attachments)
  fun val with_provides(provides': (Type | None)): TypeAlias => create(_name, _cap, _type_params, provides', _members, _at, _docs, _attachments)
  fun val with_members(members': Members): TypeAlias => create(_name, _cap, _type_params, _provides, members', _at, _docs, _attachments)
  fun val with_at(at': (At | None)): TypeAlias => create(_name, _cap, _type_params, _provides, _members, at', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): TypeAlias => create(_name, _cap, _type_params, _provides, _members, _at, docs', _attachments)
  
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
        return create(replace' as Id, _cap, _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _type_params then
        return create(_name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs, _attachments)
      end
      if child' is _provides then
        return create(_name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs, _attachments)
      end
      if child' is _members then
        return create(_name, _cap, _type_params, _provides, replace' as Members, _at, _docs, _attachments)
      end
      if child' is _at then
        return create(_name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs, _attachments)
      end
      if child' is _docs then
        return create(_name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
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
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("Interface missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let provides': (AST | None) = try iter.next()? else None end
    let members': (AST | None) = try iter.next()? else Members end
    let at': (AST | None) = try iter.next()? else None end
    let docs': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Interface got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Interface => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _provides end
    if idx == (4 + offset) then return _members end
    if idx == (5 + offset) then return _at end
    if idx == (6 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): Interface => create(_name, _cap, _type_params, _provides, _members, _at, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Interface => create(name', _cap, _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_cap(cap': (Cap | None)): Interface => create(_name, cap', _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): Interface => create(_name, _cap, type_params', _provides, _members, _at, _docs, _attachments)
  fun val with_provides(provides': (Type | None)): Interface => create(_name, _cap, _type_params, provides', _members, _at, _docs, _attachments)
  fun val with_members(members': Members): Interface => create(_name, _cap, _type_params, _provides, members', _at, _docs, _attachments)
  fun val with_at(at': (At | None)): Interface => create(_name, _cap, _type_params, _provides, _members, at', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): Interface => create(_name, _cap, _type_params, _provides, _members, _at, docs', _attachments)
  
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
        return create(replace' as Id, _cap, _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _type_params then
        return create(_name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs, _attachments)
      end
      if child' is _provides then
        return create(_name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs, _attachments)
      end
      if child' is _members then
        return create(_name, _cap, _type_params, _provides, replace' as Members, _at, _docs, _attachments)
      end
      if child' is _at then
        return create(_name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs, _attachments)
      end
      if child' is _docs then
        return create(_name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
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
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("Trait missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let provides': (AST | None) = try iter.next()? else None end
    let members': (AST | None) = try iter.next()? else Members end
    let at': (AST | None) = try iter.next()? else None end
    let docs': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Trait got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Trait => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _provides end
    if idx == (4 + offset) then return _members end
    if idx == (5 + offset) then return _at end
    if idx == (6 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): Trait => create(_name, _cap, _type_params, _provides, _members, _at, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Trait => create(name', _cap, _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_cap(cap': (Cap | None)): Trait => create(_name, cap', _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): Trait => create(_name, _cap, type_params', _provides, _members, _at, _docs, _attachments)
  fun val with_provides(provides': (Type | None)): Trait => create(_name, _cap, _type_params, provides', _members, _at, _docs, _attachments)
  fun val with_members(members': Members): Trait => create(_name, _cap, _type_params, _provides, members', _at, _docs, _attachments)
  fun val with_at(at': (At | None)): Trait => create(_name, _cap, _type_params, _provides, _members, at', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): Trait => create(_name, _cap, _type_params, _provides, _members, _at, docs', _attachments)
  
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
        return create(replace' as Id, _cap, _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _type_params then
        return create(_name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs, _attachments)
      end
      if child' is _provides then
        return create(_name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs, _attachments)
      end
      if child' is _members then
        return create(_name, _cap, _type_params, _provides, replace' as Members, _at, _docs, _attachments)
      end
      if child' is _at then
        return create(_name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs, _attachments)
      end
      if child' is _docs then
        return create(_name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
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
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("Primitive missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let provides': (AST | None) = try iter.next()? else None end
    let members': (AST | None) = try iter.next()? else Members end
    let at': (AST | None) = try iter.next()? else None end
    let docs': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Primitive got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Primitive => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _provides end
    if idx == (4 + offset) then return _members end
    if idx == (5 + offset) then return _at end
    if idx == (6 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): Primitive => create(_name, _cap, _type_params, _provides, _members, _at, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Primitive => create(name', _cap, _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_cap(cap': (Cap | None)): Primitive => create(_name, cap', _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): Primitive => create(_name, _cap, type_params', _provides, _members, _at, _docs, _attachments)
  fun val with_provides(provides': (Type | None)): Primitive => create(_name, _cap, _type_params, provides', _members, _at, _docs, _attachments)
  fun val with_members(members': Members): Primitive => create(_name, _cap, _type_params, _provides, members', _at, _docs, _attachments)
  fun val with_at(at': (At | None)): Primitive => create(_name, _cap, _type_params, _provides, _members, at', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): Primitive => create(_name, _cap, _type_params, _provides, _members, _at, docs', _attachments)
  
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
        return create(replace' as Id, _cap, _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _type_params then
        return create(_name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs, _attachments)
      end
      if child' is _provides then
        return create(_name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs, _attachments)
      end
      if child' is _members then
        return create(_name, _cap, _type_params, _provides, replace' as Members, _at, _docs, _attachments)
      end
      if child' is _at then
        return create(_name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs, _attachments)
      end
      if child' is _docs then
        return create(_name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
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
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("Struct missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let provides': (AST | None) = try iter.next()? else None end
    let members': (AST | None) = try iter.next()? else Members end
    let at': (AST | None) = try iter.next()? else None end
    let docs': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Struct got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Struct => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _provides end
    if idx == (4 + offset) then return _members end
    if idx == (5 + offset) then return _at end
    if idx == (6 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): Struct => create(_name, _cap, _type_params, _provides, _members, _at, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Struct => create(name', _cap, _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_cap(cap': (Cap | None)): Struct => create(_name, cap', _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): Struct => create(_name, _cap, type_params', _provides, _members, _at, _docs, _attachments)
  fun val with_provides(provides': (Type | None)): Struct => create(_name, _cap, _type_params, provides', _members, _at, _docs, _attachments)
  fun val with_members(members': Members): Struct => create(_name, _cap, _type_params, _provides, members', _at, _docs, _attachments)
  fun val with_at(at': (At | None)): Struct => create(_name, _cap, _type_params, _provides, _members, at', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): Struct => create(_name, _cap, _type_params, _provides, _members, _at, docs', _attachments)
  
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
        return create(replace' as Id, _cap, _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _type_params then
        return create(_name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs, _attachments)
      end
      if child' is _provides then
        return create(_name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs, _attachments)
      end
      if child' is _members then
        return create(_name, _cap, _type_params, _provides, replace' as Members, _at, _docs, _attachments)
      end
      if child' is _at then
        return create(_name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs, _attachments)
      end
      if child' is _docs then
        return create(_name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
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
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("Class missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let provides': (AST | None) = try iter.next()? else None end
    let members': (AST | None) = try iter.next()? else Members end
    let at': (AST | None) = try iter.next()? else None end
    let docs': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Class got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Class => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _provides end
    if idx == (4 + offset) then return _members end
    if idx == (5 + offset) then return _at end
    if idx == (6 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): Class => create(_name, _cap, _type_params, _provides, _members, _at, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Class => create(name', _cap, _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_cap(cap': (Cap | None)): Class => create(_name, cap', _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): Class => create(_name, _cap, type_params', _provides, _members, _at, _docs, _attachments)
  fun val with_provides(provides': (Type | None)): Class => create(_name, _cap, _type_params, provides', _members, _at, _docs, _attachments)
  fun val with_members(members': Members): Class => create(_name, _cap, _type_params, _provides, members', _at, _docs, _attachments)
  fun val with_at(at': (At | None)): Class => create(_name, _cap, _type_params, _provides, _members, at', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): Class => create(_name, _cap, _type_params, _provides, _members, _at, docs', _attachments)
  
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
        return create(replace' as Id, _cap, _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _type_params then
        return create(_name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs, _attachments)
      end
      if child' is _provides then
        return create(_name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs, _attachments)
      end
      if child' is _members then
        return create(_name, _cap, _type_params, _provides, replace' as Members, _at, _docs, _attachments)
      end
      if child' is _at then
        return create(_name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs, _attachments)
      end
      if child' is _docs then
        return create(_name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
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
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("Actor missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let provides': (AST | None) = try iter.next()? else None end
    let members': (AST | None) = try iter.next()? else Members end
    let at': (AST | None) = try iter.next()? else None end
    let docs': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Actor got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Actor => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _provides end
    if idx == (4 + offset) then return _members end
    if idx == (5 + offset) then return _at end
    if idx == (6 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): Actor => create(_name, _cap, _type_params, _provides, _members, _at, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val provides(): (Type | None) => _provides
  fun val members(): Members => _members
  fun val at(): (At | None) => _at
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): Actor => create(name', _cap, _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_cap(cap': (Cap | None)): Actor => create(_name, cap', _type_params, _provides, _members, _at, _docs, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): Actor => create(_name, _cap, type_params', _provides, _members, _at, _docs, _attachments)
  fun val with_provides(provides': (Type | None)): Actor => create(_name, _cap, _type_params, provides', _members, _at, _docs, _attachments)
  fun val with_members(members': Members): Actor => create(_name, _cap, _type_params, _provides, members', _at, _docs, _attachments)
  fun val with_at(at': (At | None)): Actor => create(_name, _cap, _type_params, _provides, _members, at', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): Actor => create(_name, _cap, _type_params, _provides, _members, _at, docs', _attachments)
  
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
        return create(replace' as Id, _cap, _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | None), _type_params, _provides, _members, _at, _docs, _attachments)
      end
      if child' is _type_params then
        return create(_name, _cap, replace' as (TypeParams | None), _provides, _members, _at, _docs, _attachments)
      end
      if child' is _provides then
        return create(_name, _cap, _type_params, replace' as (Type | None), _members, _at, _docs, _attachments)
      end
      if child' is _members then
        return create(_name, _cap, _type_params, _provides, replace' as Members, _at, _docs, _attachments)
      end
      if child' is _at then
        return create(_name, _cap, _type_params, _provides, _members, replace' as (At | None), _docs, _attachments)
      end
      if child' is _docs then
        return create(_name, _cap, _type_params, _provides, _members, _at, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _fields: coll.Vec[Field]
  let _methods: coll.Vec[Method]
  
  new val create(
    fields': (coll.Vec[Field] | Array[Field] val) = coll.Vec[Field],
    methods': (coll.Vec[Method] | Array[Method] val) = coll.Vec[Method],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _fields = 
      match fields'
      | let v: coll.Vec[Field] => v
      | let s: Array[Field] val => coll.Vec[Field].concat(s.values())
      end
    _methods = 
      match methods'
      | let v: coll.Vec[Method] => v
      | let s: Array[Method] val => coll.Vec[Method].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var fields' = coll.Vec[Field]
    var fields_next' = try iter.next()? else None end
    while true do
      try fields' = fields'.push(fields_next' as Field) else break end
      try fields_next' = iter.next()? else fields_next' = None; break end
    end
    var methods' = coll.Vec[Method]
    var methods_next' = fields_next'
    while true do
      try methods' = methods'.push(methods_next' as Method) else break end
      try methods_next' = iter.next()? else methods_next' = None; break end
    end
    if methods_next' isnt None then
      let extra' = methods_next'
      errs.push(("Members got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _fields = fields'
    _methods = methods'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Members](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Members => attach[SourcePosAny](pos')
  
  fun val size(): USize => _fields.size() + _methods.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _fields.size()) then return _fields(idx - (0 + offset))? end
    offset = (offset + _fields.size()) - 1
    if idx < (1 + offset + _methods.size()) then return _methods(idx - (1 + offset))? end
    offset = (offset + _methods.size()) - 1
    error
  fun val attach[A: Any #share](a: A): Members => create(_fields, _methods, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val fields(): coll.Vec[Field] => _fields
  fun val methods(): coll.Vec[Method] => _methods
  
  fun val with_fields(fields': (coll.Vec[Field] | Array[Field] val)): Members => create(fields', _methods, _attachments)
  fun val with_methods(methods': (coll.Vec[Method] | Array[Method] val)): Members => create(_fields, methods', _attachments)
  
  fun val with_fields_push(x: val->Field): Members => with_fields(_fields.push(x))
  
  fun val with_methods_push(x: val->Method): Members => with_methods(_methods.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "fields" => _fields(index')?
    | "methods" => _methods(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _fields.find(child' as Field)?
        return create(_fields.update(i, replace' as Field)?, _methods, _attachments)
      end
      try
        let i = _methods.find(child' as Method)?
        return create(_fields, _methods.update(i, replace' as Method)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _field_type: Type
  let _default: (Expr | None)
  
  new val create(
    name': Id,
    field_type': Type,
    default': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _field_type = field_type'
    _default = default'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("FieldLet missing required field: name", pos')); error
      end
    let field_type': (AST | None) =
      try iter.next()?
      else errs.push(("FieldLet missing required field: field_type", pos')); error
      end
    let default': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("FieldLet got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): FieldLet => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _field_type end
    if idx == (2 + offset) then return _default end
    error
  fun val attach[A: Any #share](a: A): FieldLet => create(_name, _field_type, _default, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val field_type(): Type => _field_type
  fun val default(): (Expr | None) => _default
  
  fun val with_name(name': Id): FieldLet => create(name', _field_type, _default, _attachments)
  fun val with_field_type(field_type': Type): FieldLet => create(_name, field_type', _default, _attachments)
  fun val with_default(default': (Expr | None)): FieldLet => create(_name, _field_type, default', _attachments)
  
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
        return create(replace' as Id, _field_type, _default, _attachments)
      end
      if child' is _field_type then
        return create(_name, replace' as Type, _default, _attachments)
      end
      if child' is _default then
        return create(_name, _field_type, replace' as (Expr | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _field_type: Type
  let _default: (Expr | None)
  
  new val create(
    name': Id,
    field_type': Type,
    default': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _field_type = field_type'
    _default = default'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("FieldVar missing required field: name", pos')); error
      end
    let field_type': (AST | None) =
      try iter.next()?
      else errs.push(("FieldVar missing required field: field_type", pos')); error
      end
    let default': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("FieldVar got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): FieldVar => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _field_type end
    if idx == (2 + offset) then return _default end
    error
  fun val attach[A: Any #share](a: A): FieldVar => create(_name, _field_type, _default, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val field_type(): Type => _field_type
  fun val default(): (Expr | None) => _default
  
  fun val with_name(name': Id): FieldVar => create(name', _field_type, _default, _attachments)
  fun val with_field_type(field_type': Type): FieldVar => create(_name, field_type', _default, _attachments)
  fun val with_default(default': (Expr | None)): FieldVar => create(_name, _field_type, default', _attachments)
  
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
        return create(replace' as Id, _field_type, _default, _attachments)
      end
      if child' is _field_type then
        return create(_name, replace' as Type, _default, _attachments)
      end
      if child' is _default then
        return create(_name, _field_type, replace' as (Expr | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _field_type: Type
  let _default: (Expr | None)
  
  new val create(
    name': Id,
    field_type': Type,
    default': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _field_type = field_type'
    _default = default'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("FieldEmbed missing required field: name", pos')); error
      end
    let field_type': (AST | None) =
      try iter.next()?
      else errs.push(("FieldEmbed missing required field: field_type", pos')); error
      end
    let default': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("FieldEmbed got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): FieldEmbed => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _field_type end
    if idx == (2 + offset) then return _default end
    error
  fun val attach[A: Any #share](a: A): FieldEmbed => create(_name, _field_type, _default, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val field_type(): Type => _field_type
  fun val default(): (Expr | None) => _default
  
  fun val with_name(name': Id): FieldEmbed => create(name', _field_type, _default, _attachments)
  fun val with_field_type(field_type': Type): FieldEmbed => create(_name, field_type', _default, _attachments)
  fun val with_default(default': (Expr | None)): FieldEmbed => create(_name, _field_type, default', _attachments)
  
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
        return create(replace' as Id, _field_type, _default, _attachments)
      end
      if child' is _field_type then
        return create(_name, replace' as Type, _default, _attachments)
      end
      if child' is _default then
        return create(_name, _field_type, replace' as (Expr | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _cap: (Cap | At | None)
  let _type_params: (TypeParams | None)
  let _params: Params
  let _return_type: (Type | None)
  let _partial: (Question | None)
  let _guard: (Sequence | None)
  let _body: (Sequence | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | At | None) = None,
    type_params': (TypeParams | None) = None,
    params': Params = Params,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None,
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("MethodFun missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let params': (AST | None) = try iter.next()? else Params end
    let return_type': (AST | None) = try iter.next()? else None end
    let partial': (AST | None) = try iter.next()? else None end
    let guard': (AST | None) = try iter.next()? else None end
    let body': (AST | None) = try iter.next()? else None end
    let docs': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("MethodFun got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("MethodFun got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | At | None)
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): MethodFun => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _params end
    if idx == (4 + offset) then return _return_type end
    if idx == (5 + offset) then return _partial end
    if idx == (6 + offset) then return _guard end
    if idx == (7 + offset) then return _body end
    if idx == (8 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): MethodFun => create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | At | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val guard(): (Sequence | None) => _guard
  fun val body(): (Sequence | None) => _body
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): MethodFun => create(name', _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_cap(cap': (Cap | At | None)): MethodFun => create(_name, cap', _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): MethodFun => create(_name, _cap, type_params', _params, _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_params(params': Params): MethodFun => create(_name, _cap, _type_params, params', _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_return_type(return_type': (Type | None)): MethodFun => create(_name, _cap, _type_params, _params, return_type', _partial, _guard, _body, _docs, _attachments)
  fun val with_partial(partial': (Question | None)): MethodFun => create(_name, _cap, _type_params, _params, _return_type, partial', _guard, _body, _docs, _attachments)
  fun val with_guard(guard': (Sequence | None)): MethodFun => create(_name, _cap, _type_params, _params, _return_type, _partial, guard', _body, _docs, _attachments)
  fun val with_body(body': (Sequence | None)): MethodFun => create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, body', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): MethodFun => create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, docs', _attachments)
  
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
        return create(replace' as Id, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | At | None), _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _type_params then
        return create(_name, _cap, replace' as (TypeParams | None), _params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _params then
        return create(_name, _cap, _type_params, replace' as Params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _return_type then
        return create(_name, _cap, _type_params, _params, replace' as (Type | None), _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _partial then
        return create(_name, _cap, _type_params, _params, _return_type, replace' as (Question | None), _guard, _body, _docs, _attachments)
      end
      if child' is _guard then
        return create(_name, _cap, _type_params, _params, _return_type, _partial, replace' as (Sequence | None), _body, _docs, _attachments)
      end
      if child' is _body then
        return create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, replace' as (Sequence | None), _docs, _attachments)
      end
      if child' is _docs then
        return create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _cap: (Cap | At | None)
  let _type_params: (TypeParams | None)
  let _params: Params
  let _return_type: (Type | None)
  let _partial: (Question | None)
  let _guard: (Sequence | None)
  let _body: (Sequence | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | At | None) = None,
    type_params': (TypeParams | None) = None,
    params': Params = Params,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None,
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("MethodNew missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let params': (AST | None) = try iter.next()? else Params end
    let return_type': (AST | None) = try iter.next()? else None end
    let partial': (AST | None) = try iter.next()? else None end
    let guard': (AST | None) = try iter.next()? else None end
    let body': (AST | None) = try iter.next()? else None end
    let docs': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("MethodNew got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("MethodNew got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | At | None)
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): MethodNew => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _params end
    if idx == (4 + offset) then return _return_type end
    if idx == (5 + offset) then return _partial end
    if idx == (6 + offset) then return _guard end
    if idx == (7 + offset) then return _body end
    if idx == (8 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): MethodNew => create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | At | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val guard(): (Sequence | None) => _guard
  fun val body(): (Sequence | None) => _body
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): MethodNew => create(name', _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_cap(cap': (Cap | At | None)): MethodNew => create(_name, cap', _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): MethodNew => create(_name, _cap, type_params', _params, _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_params(params': Params): MethodNew => create(_name, _cap, _type_params, params', _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_return_type(return_type': (Type | None)): MethodNew => create(_name, _cap, _type_params, _params, return_type', _partial, _guard, _body, _docs, _attachments)
  fun val with_partial(partial': (Question | None)): MethodNew => create(_name, _cap, _type_params, _params, _return_type, partial', _guard, _body, _docs, _attachments)
  fun val with_guard(guard': (Sequence | None)): MethodNew => create(_name, _cap, _type_params, _params, _return_type, _partial, guard', _body, _docs, _attachments)
  fun val with_body(body': (Sequence | None)): MethodNew => create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, body', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): MethodNew => create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, docs', _attachments)
  
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
        return create(replace' as Id, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | At | None), _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _type_params then
        return create(_name, _cap, replace' as (TypeParams | None), _params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _params then
        return create(_name, _cap, _type_params, replace' as Params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _return_type then
        return create(_name, _cap, _type_params, _params, replace' as (Type | None), _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _partial then
        return create(_name, _cap, _type_params, _params, _return_type, replace' as (Question | None), _guard, _body, _docs, _attachments)
      end
      if child' is _guard then
        return create(_name, _cap, _type_params, _params, _return_type, _partial, replace' as (Sequence | None), _body, _docs, _attachments)
      end
      if child' is _body then
        return create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, replace' as (Sequence | None), _docs, _attachments)
      end
      if child' is _docs then
        return create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _cap: (Cap | At | None)
  let _type_params: (TypeParams | None)
  let _params: Params
  let _return_type: (Type | None)
  let _partial: (Question | None)
  let _guard: (Sequence | None)
  let _body: (Sequence | None)
  let _docs: (LitString | None)
  
  new val create(
    name': Id,
    cap': (Cap | At | None) = None,
    type_params': (TypeParams | None) = None,
    params': Params = Params,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None,
    docs': (LitString | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("MethodBe missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let params': (AST | None) = try iter.next()? else Params end
    let return_type': (AST | None) = try iter.next()? else None end
    let partial': (AST | None) = try iter.next()? else None end
    let guard': (AST | None) = try iter.next()? else None end
    let body': (AST | None) = try iter.next()? else None end
    let docs': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("MethodBe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("MethodBe got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _cap =
      try cap' as (Cap | At | None)
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): MethodBe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _params end
    if idx == (4 + offset) then return _return_type end
    if idx == (5 + offset) then return _partial end
    if idx == (6 + offset) then return _guard end
    if idx == (7 + offset) then return _body end
    if idx == (8 + offset) then return _docs end
    error
  fun val attach[A: Any #share](a: A): MethodBe => create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | At | None) => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val guard(): (Sequence | None) => _guard
  fun val body(): (Sequence | None) => _body
  fun val docs(): (LitString | None) => _docs
  
  fun val with_name(name': Id): MethodBe => create(name', _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_cap(cap': (Cap | At | None)): MethodBe => create(_name, cap', _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): MethodBe => create(_name, _cap, type_params', _params, _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_params(params': Params): MethodBe => create(_name, _cap, _type_params, params', _return_type, _partial, _guard, _body, _docs, _attachments)
  fun val with_return_type(return_type': (Type | None)): MethodBe => create(_name, _cap, _type_params, _params, return_type', _partial, _guard, _body, _docs, _attachments)
  fun val with_partial(partial': (Question | None)): MethodBe => create(_name, _cap, _type_params, _params, _return_type, partial', _guard, _body, _docs, _attachments)
  fun val with_guard(guard': (Sequence | None)): MethodBe => create(_name, _cap, _type_params, _params, _return_type, _partial, guard', _body, _docs, _attachments)
  fun val with_body(body': (Sequence | None)): MethodBe => create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, body', _docs, _attachments)
  fun val with_docs(docs': (LitString | None)): MethodBe => create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, docs', _attachments)
  
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
        return create(replace' as Id, _cap, _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | At | None), _type_params, _params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _type_params then
        return create(_name, _cap, replace' as (TypeParams | None), _params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _params then
        return create(_name, _cap, _type_params, replace' as Params, _return_type, _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _return_type then
        return create(_name, _cap, _type_params, _params, replace' as (Type | None), _partial, _guard, _body, _docs, _attachments)
      end
      if child' is _partial then
        return create(_name, _cap, _type_params, _params, _return_type, replace' as (Question | None), _guard, _body, _docs, _attachments)
      end
      if child' is _guard then
        return create(_name, _cap, _type_params, _params, _return_type, _partial, replace' as (Sequence | None), _body, _docs, _attachments)
      end
      if child' is _body then
        return create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, replace' as (Sequence | None), _docs, _attachments)
      end
      if child' is _docs then
        return create(_name, _cap, _type_params, _params, _return_type, _partial, _guard, _body, replace' as (LitString | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[TypeParam]
  
  new val create(
    list': (coll.Vec[TypeParam] | Array[TypeParam] val) = coll.Vec[TypeParam],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[TypeParam] => v
      | let s: Array[TypeParam] val => coll.Vec[TypeParam].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[TypeParam]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as TypeParam) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("TypeParams got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TypeParams](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): TypeParams => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): TypeParams => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[TypeParam] => _list
  
  fun val with_list(list': (coll.Vec[TypeParam] | Array[TypeParam] val)): TypeParams => create(list', _attachments)
  
  fun val with_list_push(x: val->TypeParam): TypeParams => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as TypeParam)?
        return create(_list.update(i, replace' as TypeParam)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _constraint: (Type | None)
  let _default: (Type | None)
  
  new val create(
    name': Id,
    constraint': (Type | None) = None,
    default': (Type | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _constraint = constraint'
    _default = default'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("TypeParam missing required field: name", pos')); error
      end
    let constraint': (AST | None) = try iter.next()? else None end
    let default': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("TypeParam got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): TypeParam => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _constraint end
    if idx == (2 + offset) then return _default end
    error
  fun val attach[A: Any #share](a: A): TypeParam => create(_name, _constraint, _default, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val constraint(): (Type | None) => _constraint
  fun val default(): (Type | None) => _default
  
  fun val with_name(name': Id): TypeParam => create(name', _constraint, _default, _attachments)
  fun val with_constraint(constraint': (Type | None)): TypeParam => create(_name, constraint', _default, _attachments)
  fun val with_default(default': (Type | None)): TypeParam => create(_name, _constraint, default', _attachments)
  
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
        return create(replace' as Id, _constraint, _default, _attachments)
      end
      if child' is _constraint then
        return create(_name, replace' as (Type | None), _default, _attachments)
      end
      if child' is _default then
        return create(_name, _constraint, replace' as (Type | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[Type]
  
  new val create(
    list': (coll.Vec[Type] | Array[Type] val) = coll.Vec[Type],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[Type] => v
      | let s: Array[Type] val => coll.Vec[Type].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[Type]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as Type) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("TypeArgs got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TypeArgs](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): TypeArgs => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): TypeArgs => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[Type] => _list
  
  fun val with_list(list': (coll.Vec[Type] | Array[Type] val)): TypeArgs => create(list', _attachments)
  
  fun val with_list_push(x: val->Type): TypeArgs => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Type)?
        return create(_list.update(i, replace' as Type)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[Param]
  let _ellipsis: (Ellipsis | None)
  
  new val create(
    list': (coll.Vec[Param] | Array[Param] val) = coll.Vec[Param],
    ellipsis': (Ellipsis | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[Param] => v
      | let s: Array[Param] val => coll.Vec[Param].concat(s.values())
      end
    _ellipsis = ellipsis'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[Param]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as Param) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    let ellipsis': (AST | None) = list_next'
    if
      try
        let extra' = iter.next()?
        errs.push(("Params got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _list = list'
    _ellipsis =
      try ellipsis' as (Ellipsis | None)
      else errs.push(("Params got incompatible field: ellipsis", try (ellipsis' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Params](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Params => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size() + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    if idx == (1 + offset) then return _ellipsis end
    error
  fun val attach[A: Any #share](a: A): Params => create(_list, _ellipsis, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[Param] => _list
  fun val ellipsis(): (Ellipsis | None) => _ellipsis
  
  fun val with_list(list': (coll.Vec[Param] | Array[Param] val)): Params => create(list', _ellipsis, _attachments)
  fun val with_ellipsis(ellipsis': (Ellipsis | None)): Params => create(_list, ellipsis', _attachments)
  
  fun val with_list_push(x: val->Param): Params => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    | "ellipsis" => _ellipsis
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Param)?
        return create(_list.update(i, replace' as Param)?, _ellipsis, _attachments)
      end
      if child' is _ellipsis then
        return create(_list, replace' as (Ellipsis | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _param_type: (Type | None)
  let _default: (Expr | None)
  
  new val create(
    name': Id,
    param_type': (Type | None) = None,
    default': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _param_type = param_type'
    _default = default'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("Param missing required field: name", pos')); error
      end
    let param_type': (AST | None) = try iter.next()? else None end
    let default': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Param got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Param => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _param_type end
    if idx == (2 + offset) then return _default end
    error
  fun val attach[A: Any #share](a: A): Param => create(_name, _param_type, _default, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val param_type(): (Type | None) => _param_type
  fun val default(): (Expr | None) => _default
  
  fun val with_name(name': Id): Param => create(name', _param_type, _default, _attachments)
  fun val with_param_type(param_type': (Type | None)): Param => create(_name, param_type', _default, _attachments)
  fun val with_default(default': (Expr | None)): Param => create(_name, _param_type, default', _attachments)
  
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
        return create(replace' as Id, _param_type, _default, _attachments)
      end
      if child' is _param_type then
        return create(_name, replace' as (Type | None), _default, _attachments)
      end
      if child' is _default then
        return create(_name, _param_type, replace' as (Expr | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[Expr]
  
  new val create(
    list': (coll.Vec[Expr] | Array[Expr] val) = coll.Vec[Expr],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[Expr] => v
      | let s: Array[Expr] val => coll.Vec[Expr].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[Expr]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as Expr) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Sequence got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Sequence](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Sequence => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): Sequence => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[Expr] => _list
  
  fun val with_list(list': (coll.Vec[Expr] | Array[Expr] val)): Sequence => create(list', _attachments)
  
  fun val with_list_push(x: val->Expr): Sequence => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Expr)?
        return create(_list.update(i, replace' as Expr)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let value': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Return got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("Return got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Return](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Return => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _value end
    error
  fun val attach[A: Any #share](a: A): Return => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): Return => create(value', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return create(replace' as (Expr | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let value': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Break got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("Break got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Break](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Break => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _value end
    error
  fun val attach[A: Any #share](a: A): Break => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): Break => create(value', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return create(replace' as (Expr | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let value': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Continue got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("Continue got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Continue](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Continue => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _value end
    error
  fun val attach[A: Any #share](a: A): Continue => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): Continue => create(value', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return create(replace' as (Expr | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let value': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Error got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("Error got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Error](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Error => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _value end
    error
  fun val attach[A: Any #share](a: A): Error => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): Error => create(value', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return create(replace' as (Expr | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let value': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("CompileIntrinsic got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("CompileIntrinsic got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CompileIntrinsic](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): CompileIntrinsic => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _value end
    error
  fun val attach[A: Any #share](a: A): CompileIntrinsic => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): CompileIntrinsic => create(value', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return create(replace' as (Expr | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _value: (Expr | None)
  
  new val create(
    value': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let value': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("CompileError got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _value =
      try value' as (Expr | None)
      else errs.push(("CompileError got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CompileError](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): CompileError => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _value end
    error
  fun val attach[A: Any #share](a: A): CompileError => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): (Expr | None) => _value
  
  fun val with_value(value': (Expr | None)): CompileError => create(value', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _value then
        return create(replace' as (Expr | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: (Id | LitString)
  
  new val create(
    name': (Id | LitString),
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("IfDefFlag missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("IfDefFlag got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as (Id | LitString)
      else errs.push(("IfDefFlag got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IfDefFlag](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): IfDefFlag => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): IfDefFlag => create(_name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): (Id | LitString) => _name
  
  fun val with_name(name': (Id | LitString)): IfDefFlag => create(name', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return create(replace' as (Id | LitString), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _expr: IfDefCond
  
  new val create(
    expr': IfDefCond,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("IfDefNot missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("IfDefNot got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as IfDefCond
      else errs.push(("IfDefNot got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IfDefNot](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): IfDefNot => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _expr end
    error
  fun val attach[A: Any #share](a: A): IfDefNot => create(_expr, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val expr(): IfDefCond => _expr
  
  fun val with_expr(expr': IfDefCond): IfDefNot => create(expr', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return create(replace' as IfDefCond, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _left: IfDefCond
  let _right: IfDefCond
  
  new val create(
    left': IfDefCond,
    right': IfDefCond,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("IfDefAnd missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("IfDefAnd missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("IfDefAnd got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): IfDefAnd => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    error
  fun val attach[A: Any #share](a: A): IfDefAnd => create(_left, _right, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): IfDefCond => _left
  fun val right(): IfDefCond => _right
  
  fun val with_left(left': IfDefCond): IfDefAnd => create(left', _right, _attachments)
  fun val with_right(right': IfDefCond): IfDefAnd => create(_left, right', _attachments)
  
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
        return create(replace' as IfDefCond, _right, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as IfDefCond, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _left: IfDefCond
  let _right: IfDefCond
  
  new val create(
    left': IfDefCond,
    right': IfDefCond,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("IfDefOr missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("IfDefOr missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("IfDefOr got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): IfDefOr => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    error
  fun val attach[A: Any #share](a: A): IfDefOr => create(_left, _right, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): IfDefCond => _left
  fun val right(): IfDefCond => _right
  
  fun val with_left(left': IfDefCond): IfDefOr => create(left', _right, _attachments)
  fun val with_right(right': IfDefCond): IfDefOr => create(_left, right', _attachments)
  
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
        return create(replace' as IfDefCond, _right, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as IfDefCond, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _condition: IfDefCond
  let _then_body: Sequence
  let _else_body: (Sequence | IfDef | None)
  
  new val create(
    condition': IfDefCond,
    then_body': Sequence,
    else_body': (Sequence | IfDef | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _condition = condition'
    _then_body = then_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let condition': (AST | None) =
      try iter.next()?
      else errs.push(("IfDef missing required field: condition", pos')); error
      end
    let then_body': (AST | None) =
      try iter.next()?
      else errs.push(("IfDef missing required field: then_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("IfDef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): IfDef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _condition end
    if idx == (1 + offset) then return _then_body end
    if idx == (2 + offset) then return _else_body end
    error
  fun val attach[A: Any #share](a: A): IfDef => create(_condition, _then_body, _else_body, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val condition(): IfDefCond => _condition
  fun val then_body(): Sequence => _then_body
  fun val else_body(): (Sequence | IfDef | None) => _else_body
  
  fun val with_condition(condition': IfDefCond): IfDef => create(condition', _then_body, _else_body, _attachments)
  fun val with_then_body(then_body': Sequence): IfDef => create(_condition, then_body', _else_body, _attachments)
  fun val with_else_body(else_body': (Sequence | IfDef | None)): IfDef => create(_condition, _then_body, else_body', _attachments)
  
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
        return create(replace' as IfDefCond, _then_body, _else_body, _attachments)
      end
      if child' is _then_body then
        return create(_condition, replace' as Sequence, _else_body, _attachments)
      end
      if child' is _else_body then
        return create(_condition, _then_body, replace' as (Sequence | IfDef | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _sub: Type
  let _super: Type
  let _then_body: Sequence
  let _else_body: (Sequence | IfType | None)
  
  new val create(
    sub': Type,
    super': Type,
    then_body': Sequence,
    else_body': (Sequence | IfType | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _sub = sub'
    _super = super'
    _then_body = then_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let sub': (AST | None) =
      try iter.next()?
      else errs.push(("IfType missing required field: sub", pos')); error
      end
    let super': (AST | None) =
      try iter.next()?
      else errs.push(("IfType missing required field: super", pos')); error
      end
    let then_body': (AST | None) =
      try iter.next()?
      else errs.push(("IfType missing required field: then_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("IfType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): IfType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _sub end
    if idx == (1 + offset) then return _super end
    if idx == (2 + offset) then return _then_body end
    if idx == (3 + offset) then return _else_body end
    error
  fun val attach[A: Any #share](a: A): IfType => create(_sub, _super, _then_body, _else_body, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val sub(): Type => _sub
  fun val super(): Type => _super
  fun val then_body(): Sequence => _then_body
  fun val else_body(): (Sequence | IfType | None) => _else_body
  
  fun val with_sub(sub': Type): IfType => create(sub', _super, _then_body, _else_body, _attachments)
  fun val with_super(super': Type): IfType => create(_sub, super', _then_body, _else_body, _attachments)
  fun val with_then_body(then_body': Sequence): IfType => create(_sub, _super, then_body', _else_body, _attachments)
  fun val with_else_body(else_body': (Sequence | IfType | None)): IfType => create(_sub, _super, _then_body, else_body', _attachments)
  
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
        return create(replace' as Type, _super, _then_body, _else_body, _attachments)
      end
      if child' is _super then
        return create(_sub, replace' as Type, _then_body, _else_body, _attachments)
      end
      if child' is _then_body then
        return create(_sub, _super, replace' as Sequence, _else_body, _attachments)
      end
      if child' is _else_body then
        return create(_sub, _super, _then_body, replace' as (Sequence | IfType | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _condition: Sequence
  let _then_body: Sequence
  let _else_body: (Sequence | If | None)
  
  new val create(
    condition': Sequence,
    then_body': Sequence,
    else_body': (Sequence | If | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _condition = condition'
    _then_body = then_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let condition': (AST | None) =
      try iter.next()?
      else errs.push(("If missing required field: condition", pos')); error
      end
    let then_body': (AST | None) =
      try iter.next()?
      else errs.push(("If missing required field: then_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("If got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): If => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _condition end
    if idx == (1 + offset) then return _then_body end
    if idx == (2 + offset) then return _else_body end
    error
  fun val attach[A: Any #share](a: A): If => create(_condition, _then_body, _else_body, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val condition(): Sequence => _condition
  fun val then_body(): Sequence => _then_body
  fun val else_body(): (Sequence | If | None) => _else_body
  
  fun val with_condition(condition': Sequence): If => create(condition', _then_body, _else_body, _attachments)
  fun val with_then_body(then_body': Sequence): If => create(_condition, then_body', _else_body, _attachments)
  fun val with_else_body(else_body': (Sequence | If | None)): If => create(_condition, _then_body, else_body', _attachments)
  
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
        return create(replace' as Sequence, _then_body, _else_body, _attachments)
      end
      if child' is _then_body then
        return create(_condition, replace' as Sequence, _else_body, _attachments)
      end
      if child' is _else_body then
        return create(_condition, _then_body, replace' as (Sequence | If | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _condition: Sequence
  let _loop_body: Sequence
  let _else_body: (Sequence | None)
  
  new val create(
    condition': Sequence,
    loop_body': Sequence,
    else_body': (Sequence | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _condition = condition'
    _loop_body = loop_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let condition': (AST | None) =
      try iter.next()?
      else errs.push(("While missing required field: condition", pos')); error
      end
    let loop_body': (AST | None) =
      try iter.next()?
      else errs.push(("While missing required field: loop_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("While got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): While => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _condition end
    if idx == (1 + offset) then return _loop_body end
    if idx == (2 + offset) then return _else_body end
    error
  fun val attach[A: Any #share](a: A): While => create(_condition, _loop_body, _else_body, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val condition(): Sequence => _condition
  fun val loop_body(): Sequence => _loop_body
  fun val else_body(): (Sequence | None) => _else_body
  
  fun val with_condition(condition': Sequence): While => create(condition', _loop_body, _else_body, _attachments)
  fun val with_loop_body(loop_body': Sequence): While => create(_condition, loop_body', _else_body, _attachments)
  fun val with_else_body(else_body': (Sequence | None)): While => create(_condition, _loop_body, else_body', _attachments)
  
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
        return create(replace' as Sequence, _loop_body, _else_body, _attachments)
      end
      if child' is _loop_body then
        return create(_condition, replace' as Sequence, _else_body, _attachments)
      end
      if child' is _else_body then
        return create(_condition, _loop_body, replace' as (Sequence | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _loop_body: Sequence
  let _condition: Sequence
  let _else_body: (Sequence | None)
  
  new val create(
    loop_body': Sequence,
    condition': Sequence,
    else_body': (Sequence | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _loop_body = loop_body'
    _condition = condition'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let loop_body': (AST | None) =
      try iter.next()?
      else errs.push(("Repeat missing required field: loop_body", pos')); error
      end
    let condition': (AST | None) =
      try iter.next()?
      else errs.push(("Repeat missing required field: condition", pos')); error
      end
    let else_body': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Repeat got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Repeat => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _loop_body end
    if idx == (1 + offset) then return _condition end
    if idx == (2 + offset) then return _else_body end
    error
  fun val attach[A: Any #share](a: A): Repeat => create(_loop_body, _condition, _else_body, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val loop_body(): Sequence => _loop_body
  fun val condition(): Sequence => _condition
  fun val else_body(): (Sequence | None) => _else_body
  
  fun val with_loop_body(loop_body': Sequence): Repeat => create(loop_body', _condition, _else_body, _attachments)
  fun val with_condition(condition': Sequence): Repeat => create(_loop_body, condition', _else_body, _attachments)
  fun val with_else_body(else_body': (Sequence | None)): Repeat => create(_loop_body, _condition, else_body', _attachments)
  
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
        return create(replace' as Sequence, _condition, _else_body, _attachments)
      end
      if child' is _condition then
        return create(_loop_body, replace' as Sequence, _else_body, _attachments)
      end
      if child' is _else_body then
        return create(_loop_body, _condition, replace' as (Sequence | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _refs: (Id | IdTuple)
  let _iterator: Sequence
  let _loop_body: Sequence
  let _else_body: (Sequence | None)
  
  new val create(
    refs': (Id | IdTuple),
    iterator': Sequence,
    loop_body': Sequence,
    else_body': (Sequence | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _refs = refs'
    _iterator = iterator'
    _loop_body = loop_body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let refs': (AST | None) =
      try iter.next()?
      else errs.push(("For missing required field: refs", pos')); error
      end
    let iterator': (AST | None) =
      try iter.next()?
      else errs.push(("For missing required field: iterator", pos')); error
      end
    let loop_body': (AST | None) =
      try iter.next()?
      else errs.push(("For missing required field: loop_body", pos')); error
      end
    let else_body': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("For got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): For => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _refs end
    if idx == (1 + offset) then return _iterator end
    if idx == (2 + offset) then return _loop_body end
    if idx == (3 + offset) then return _else_body end
    error
  fun val attach[A: Any #share](a: A): For => create(_refs, _iterator, _loop_body, _else_body, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val refs(): (Id | IdTuple) => _refs
  fun val iterator(): Sequence => _iterator
  fun val loop_body(): Sequence => _loop_body
  fun val else_body(): (Sequence | None) => _else_body
  
  fun val with_refs(refs': (Id | IdTuple)): For => create(refs', _iterator, _loop_body, _else_body, _attachments)
  fun val with_iterator(iterator': Sequence): For => create(_refs, iterator', _loop_body, _else_body, _attachments)
  fun val with_loop_body(loop_body': Sequence): For => create(_refs, _iterator, loop_body', _else_body, _attachments)
  fun val with_else_body(else_body': (Sequence | None)): For => create(_refs, _iterator, _loop_body, else_body', _attachments)
  
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
        return create(replace' as (Id | IdTuple), _iterator, _loop_body, _else_body, _attachments)
      end
      if child' is _iterator then
        return create(_refs, replace' as Sequence, _loop_body, _else_body, _attachments)
      end
      if child' is _loop_body then
        return create(_refs, _iterator, replace' as Sequence, _else_body, _attachments)
      end
      if child' is _else_body then
        return create(_refs, _iterator, _loop_body, replace' as (Sequence | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _assigns: AssignTuple
  let _body: Sequence
  let _else_body: (Sequence | None)
  
  new val create(
    assigns': AssignTuple,
    body': Sequence,
    else_body': (Sequence | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _assigns = assigns'
    _body = body'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let assigns': (AST | None) =
      try iter.next()?
      else errs.push(("With missing required field: assigns", pos')); error
      end
    let body': (AST | None) =
      try iter.next()?
      else errs.push(("With missing required field: body", pos')); error
      end
    let else_body': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("With got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _assigns =
      try assigns' as AssignTuple
      else errs.push(("With got incompatible field: assigns", try (assigns' as AST).pos() else SourcePosNone end)); error
      end
    _body =
      try body' as Sequence
      else errs.push(("With got incompatible field: body", try (body' as AST).pos() else SourcePosNone end)); error
      end
    _else_body =
      try else_body' as (Sequence | None)
      else errs.push(("With got incompatible field: else_body", try (else_body' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[With](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): With => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _assigns end
    if idx == (1 + offset) then return _body end
    if idx == (2 + offset) then return _else_body end
    error
  fun val attach[A: Any #share](a: A): With => create(_assigns, _body, _else_body, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val assigns(): AssignTuple => _assigns
  fun val body(): Sequence => _body
  fun val else_body(): (Sequence | None) => _else_body
  
  fun val with_assigns(assigns': AssignTuple): With => create(assigns', _body, _else_body, _attachments)
  fun val with_body(body': Sequence): With => create(_assigns, body', _else_body, _attachments)
  fun val with_else_body(else_body': (Sequence | None)): With => create(_assigns, _body, else_body', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "assigns" => _assigns
    | "body" => _body
    | "else_body" => _else_body
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _assigns then
        return create(replace' as AssignTuple, _body, _else_body, _attachments)
      end
      if child' is _body then
        return create(_assigns, replace' as Sequence, _else_body, _attachments)
      end
      if child' is _else_body then
        return create(_assigns, _body, replace' as (Sequence | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("With")
    s.push('(')
    s.>append(_assigns.string()).>push(',').push(' ')
    s.>append(_body.string()).>push(',').push(' ')
    s.>append(_else_body.string())
    s.push(')')
    consume s

class val IdTuple is (AST & Expr)
  let _attachments: (Attachments | None)
  
  let _elements: coll.Vec[(Id | IdTuple)]
  
  new val create(
    elements': (coll.Vec[(Id | IdTuple)] | Array[(Id | IdTuple)] val) = coll.Vec[(Id | IdTuple)],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _elements = 
      match elements'
      | let v: coll.Vec[(Id | IdTuple)] => v
      | let s: Array[(Id | IdTuple)] val => coll.Vec[(Id | IdTuple)].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var elements' = coll.Vec[(Id | IdTuple)]
    var elements_next' = try iter.next()? else None end
    while true do
      try elements' = elements'.push(elements_next' as (Id | IdTuple)) else break end
      try elements_next' = iter.next()? else elements_next' = None; break end
    end
    if elements_next' isnt None then
      let extra' = elements_next'
      errs.push(("IdTuple got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _elements = elements'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IdTuple](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): IdTuple => attach[SourcePosAny](pos')
  
  fun val size(): USize => _elements.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _elements.size()) then return _elements(idx - (0 + offset))? end
    offset = (offset + _elements.size()) - 1
    error
  fun val attach[A: Any #share](a: A): IdTuple => create(_elements, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val elements(): coll.Vec[(Id | IdTuple)] => _elements
  
  fun val with_elements(elements': (coll.Vec[(Id | IdTuple)] | Array[(Id | IdTuple)] val)): IdTuple => create(elements', _attachments)
  
  fun val with_elements_push(x: val->(Id | IdTuple)): IdTuple => with_elements(_elements.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "elements" => _elements(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _elements.find(child' as (Id | IdTuple))?
        return create(_elements.update(i, replace' as (Id | IdTuple))?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _elements: coll.Vec[Assign]
  
  new val create(
    elements': (coll.Vec[Assign] | Array[Assign] val) = coll.Vec[Assign],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _elements = 
      match elements'
      | let v: coll.Vec[Assign] => v
      | let s: Array[Assign] val => coll.Vec[Assign].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var elements' = coll.Vec[Assign]
    var elements_next' = try iter.next()? else None end
    while true do
      try elements' = elements'.push(elements_next' as Assign) else break end
      try elements_next' = iter.next()? else elements_next' = None; break end
    end
    if elements_next' isnt None then
      let extra' = elements_next'
      errs.push(("AssignTuple got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _elements = elements'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[AssignTuple](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): AssignTuple => attach[SourcePosAny](pos')
  
  fun val size(): USize => _elements.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _elements.size()) then return _elements(idx - (0 + offset))? end
    offset = (offset + _elements.size()) - 1
    error
  fun val attach[A: Any #share](a: A): AssignTuple => create(_elements, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val elements(): coll.Vec[Assign] => _elements
  
  fun val with_elements(elements': (coll.Vec[Assign] | Array[Assign] val)): AssignTuple => create(elements', _attachments)
  
  fun val with_elements_push(x: val->Assign): AssignTuple => with_elements(_elements.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "elements" => _elements(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _elements.find(child' as Assign)?
        return create(_elements.update(i, replace' as Assign)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _expr: Sequence
  let _cases: Cases
  let _else_body: (Sequence | None)
  
  new val create(
    expr': Sequence,
    cases': Cases = Cases,
    else_body': (Sequence | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _expr = expr'
    _cases = cases'
    _else_body = else_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("Match missing required field: expr", pos')); error
      end
    let cases': (AST | None) = try iter.next()? else Cases end
    let else_body': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Match got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Match => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _expr end
    if idx == (1 + offset) then return _cases end
    if idx == (2 + offset) then return _else_body end
    error
  fun val attach[A: Any #share](a: A): Match => create(_expr, _cases, _else_body, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val expr(): Sequence => _expr
  fun val cases(): Cases => _cases
  fun val else_body(): (Sequence | None) => _else_body
  
  fun val with_expr(expr': Sequence): Match => create(expr', _cases, _else_body, _attachments)
  fun val with_cases(cases': Cases): Match => create(_expr, cases', _else_body, _attachments)
  fun val with_else_body(else_body': (Sequence | None)): Match => create(_expr, _cases, else_body', _attachments)
  
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
        return create(replace' as Sequence, _cases, _else_body, _attachments)
      end
      if child' is _cases then
        return create(_expr, replace' as Cases, _else_body, _attachments)
      end
      if child' is _else_body then
        return create(_expr, _cases, replace' as (Sequence | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[Case]
  
  new val create(
    list': (coll.Vec[Case] | Array[Case] val) = coll.Vec[Case],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[Case] => v
      | let s: Array[Case] val => coll.Vec[Case].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[Case]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as Case) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Cases got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Cases](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Cases => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): Cases => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[Case] => _list
  
  fun val with_list(list': (coll.Vec[Case] | Array[Case] val)): Cases => create(list', _attachments)
  
  fun val with_list_push(x: val->Case): Cases => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Case)?
        return create(_list.update(i, replace' as Case)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _expr: Expr
  let _guard: (Sequence | None)
  let _body: (Sequence | None)
  
  new val create(
    expr': Expr,
    guard': (Sequence | None) = None,
    body': (Sequence | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _expr = expr'
    _guard = guard'
    _body = body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("Case missing required field: expr", pos')); error
      end
    let guard': (AST | None) = try iter.next()? else None end
    let body': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Case got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Case => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _expr end
    if idx == (1 + offset) then return _guard end
    if idx == (2 + offset) then return _body end
    error
  fun val attach[A: Any #share](a: A): Case => create(_expr, _guard, _body, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val expr(): Expr => _expr
  fun val guard(): (Sequence | None) => _guard
  fun val body(): (Sequence | None) => _body
  
  fun val with_expr(expr': Expr): Case => create(expr', _guard, _body, _attachments)
  fun val with_guard(guard': (Sequence | None)): Case => create(_expr, guard', _body, _attachments)
  fun val with_body(body': (Sequence | None)): Case => create(_expr, _guard, body', _attachments)
  
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
        return create(replace' as Expr, _guard, _body, _attachments)
      end
      if child' is _guard then
        return create(_expr, replace' as (Sequence | None), _body, _attachments)
      end
      if child' is _body then
        return create(_expr, _guard, replace' as (Sequence | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _body: Sequence
  let _else_body: (Sequence | None)
  let _then_body: (Sequence | None)
  
  new val create(
    body': Sequence,
    else_body': (Sequence | None) = None,
    then_body': (Sequence | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _body = body'
    _else_body = else_body'
    _then_body = then_body'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let body': (AST | None) =
      try iter.next()?
      else errs.push(("Try missing required field: body", pos')); error
      end
    let else_body': (AST | None) = try iter.next()? else None end
    let then_body': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Try got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Try => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _body end
    if idx == (1 + offset) then return _else_body end
    if idx == (2 + offset) then return _then_body end
    error
  fun val attach[A: Any #share](a: A): Try => create(_body, _else_body, _then_body, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val body(): Sequence => _body
  fun val else_body(): (Sequence | None) => _else_body
  fun val then_body(): (Sequence | None) => _then_body
  
  fun val with_body(body': Sequence): Try => create(body', _else_body, _then_body, _attachments)
  fun val with_else_body(else_body': (Sequence | None)): Try => create(_body, else_body', _then_body, _attachments)
  fun val with_then_body(then_body': (Sequence | None)): Try => create(_body, _else_body, then_body', _attachments)
  
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
        return create(replace' as Sequence, _else_body, _then_body, _attachments)
      end
      if child' is _else_body then
        return create(_body, replace' as (Sequence | None), _then_body, _attachments)
      end
      if child' is _then_body then
        return create(_body, _else_body, replace' as (Sequence | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _cap: (Cap | None)
  let _expr: (Reference | This)
  
  new val create(
    cap': (Cap | None),
    expr': (Reference | This),
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _cap = cap'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let cap': (AST | None) =
      try iter.next()?
      else errs.push(("Consume missing required field: cap", pos')); error
      end
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("Consume missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("Consume got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Consume => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _cap end
    if idx == (1 + offset) then return _expr end
    error
  fun val attach[A: Any #share](a: A): Consume => create(_cap, _expr, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val cap(): (Cap | None) => _cap
  fun val expr(): (Reference | This) => _expr
  
  fun val with_cap(cap': (Cap | None)): Consume => create(cap', _expr, _attachments)
  fun val with_expr(expr': (Reference | This)): Consume => create(_cap, expr', _attachments)
  
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
        return create(replace' as (Cap | None), _expr, _attachments)
      end
      if child' is _expr then
        return create(_cap, replace' as (Reference | This), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _cap: (Cap | None)
  let _expr: Sequence
  
  new val create(
    cap': (Cap | None),
    expr': Sequence,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _cap = cap'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let cap': (AST | None) =
      try iter.next()?
      else errs.push(("Recover missing required field: cap", pos')); error
      end
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("Recover missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("Recover got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Recover => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _cap end
    if idx == (1 + offset) then return _expr end
    error
  fun val attach[A: Any #share](a: A): Recover => create(_cap, _expr, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val cap(): (Cap | None) => _cap
  fun val expr(): Sequence => _expr
  
  fun val with_cap(cap': (Cap | None)): Recover => create(cap', _expr, _attachments)
  fun val with_expr(expr': Sequence): Recover => create(_cap, expr', _attachments)
  
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
        return create(replace' as (Cap | None), _expr, _attachments)
      end
      if child' is _expr then
        return create(_cap, replace' as Sequence, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _expr: Expr
  let _as_type: Type
  
  new val create(
    expr': Expr,
    as_type': Type,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _expr = expr'
    _as_type = as_type'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("As missing required field: expr", pos')); error
      end
    let as_type': (AST | None) =
      try iter.next()?
      else errs.push(("As missing required field: as_type", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("As got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): As => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _expr end
    if idx == (1 + offset) then return _as_type end
    error
  fun val attach[A: Any #share](a: A): As => create(_expr, _as_type, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val expr(): Expr => _expr
  fun val as_type(): Type => _as_type
  
  fun val with_expr(expr': Expr): As => create(expr', _as_type, _attachments)
  fun val with_as_type(as_type': Type): As => create(_expr, as_type', _attachments)
  
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
        return create(replace' as Expr, _as_type, _attachments)
      end
      if child' is _as_type then
        return create(_expr, replace' as Type, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Add missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Add missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Add got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("Add got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Add](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Add => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): Add => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): Add => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): Add => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): Add => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Add")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val AddUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("AddUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("AddUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("AddUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("AddUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[AddUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): AddUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): AddUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): AddUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): AddUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): AddUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("AddUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val Sub is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Sub missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Sub missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Sub got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("Sub got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Sub](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Sub => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): Sub => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): Sub => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): Sub => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): Sub => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Sub")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val SubUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("SubUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("SubUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("SubUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("SubUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[SubUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): SubUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): SubUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): SubUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): SubUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): SubUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("SubUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val Mul is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Mul missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Mul missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Mul got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("Mul got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Mul](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Mul => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): Mul => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): Mul => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): Mul => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): Mul => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Mul")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val MulUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("MulUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("MulUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("MulUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("MulUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[MulUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): MulUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): MulUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): MulUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): MulUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): MulUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MulUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val Div is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Div missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Div missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Div got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("Div got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Div](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Div => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): Div => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): Div => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): Div => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): Div => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Div")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val DivUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("DivUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("DivUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("DivUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("DivUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[DivUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): DivUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): DivUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): DivUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): DivUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): DivUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DivUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val Mod is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Mod missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Mod missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Mod got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("Mod got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Mod](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Mod => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): Mod => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): Mod => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): Mod => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): Mod => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Mod")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val ModUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("ModUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("ModUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("ModUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("ModUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ModUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): ModUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): ModUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): ModUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): ModUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): ModUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ModUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val LShift is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("LShift missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("LShift missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("LShift got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("LShift got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LShift](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LShift => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): LShift => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): LShift => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): LShift => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): LShift => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LShift")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val LShiftUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("LShiftUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("LShiftUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("LShiftUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("LShiftUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LShiftUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LShiftUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): LShiftUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): LShiftUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): LShiftUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): LShiftUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LShiftUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val RShift is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("RShift missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("RShift missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("RShift got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("RShift got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[RShift](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): RShift => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): RShift => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): RShift => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): RShift => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): RShift => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RShift")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val RShiftUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("RShiftUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("RShiftUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("RShiftUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("RShiftUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[RShiftUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): RShiftUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): RShiftUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): RShiftUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): RShiftUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): RShiftUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RShiftUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val Eq is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Eq missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Eq missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Eq got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("Eq got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Eq](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Eq => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): Eq => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): Eq => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): Eq => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): Eq => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Eq")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val EqUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("EqUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("EqUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("EqUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("EqUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[EqUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): EqUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): EqUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): EqUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): EqUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): EqUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("EqUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val NE is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("NE missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("NE missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("NE got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("NE got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NE](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): NE => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): NE => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): NE => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): NE => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): NE => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val NEUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("NEUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("NEUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("NEUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("NEUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NEUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): NEUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): NEUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): NEUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): NEUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): NEUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NEUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val LT is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("LT missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("LT missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("LT got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("LT got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LT](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LT => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): LT => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): LT => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): LT => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): LT => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LT")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val LTUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("LTUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("LTUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("LTUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("LTUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LTUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LTUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): LTUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): LTUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): LTUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): LTUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LTUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val LE is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("LE missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("LE missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("LE got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("LE got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LE](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LE => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): LE => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): LE => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): LE => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): LE => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val LEUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("LEUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("LEUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("LEUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("LEUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LEUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LEUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): LEUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): LEUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): LEUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): LEUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LEUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val GE is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("GE missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("GE missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("GE got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("GE got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[GE](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): GE => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): GE => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): GE => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): GE => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): GE => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val GEUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("GEUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("GEUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("GEUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("GEUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[GEUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): GEUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): GEUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): GEUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): GEUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): GEUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GEUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val GT is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("GT missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("GT missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("GT got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("GT got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[GT](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): GT => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): GT => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): GT => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): GT => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): GT => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GT")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val GTUnsafe is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("GTUnsafe missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("GTUnsafe missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("GTUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("GTUnsafe got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[GTUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): GTUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): GTUnsafe => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): GTUnsafe => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): GTUnsafe => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): GTUnsafe => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GTUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val Is is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Is missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Is missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Is got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("Is got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Is](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Is => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): Is => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): Is => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): Is => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): Is => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Is")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val Isnt is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Isnt missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Isnt missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Isnt got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("Isnt got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Isnt](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Isnt => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): Isnt => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): Isnt => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): Isnt => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): Isnt => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Isnt")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val And is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("And missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("And missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("And got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("And got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[And](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): And => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): And => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): And => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): And => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): And => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("And")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val Or is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Or missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Or missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Or got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("Or got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Or](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Or => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): Or => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): Or => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): Or => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): Or => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Or")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val XOr is (AST & BinaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  let _partial: (Question | None)
  
  new val create(
    left': Expr,
    right': Expr,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("XOr missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("XOr missing required field: right", pos')); error
      end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("XOr got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("XOr got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[XOr](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): XOr => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    if idx == (2 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): XOr => create(_left, _right, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  fun val partial(): (Question | None) => _partial
  
  fun val with_left(left': Expr): XOr => create(left', _right, _partial, _attachments)
  fun val with_right(right': Expr): XOr => create(_left, right', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): XOr => create(_left, _right, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "left" => _left
    | "right" => _right
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _left then
        return create(replace' as Expr, _right, _partial, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _partial, _attachments)
      end
      if child' is _partial then
        return create(_left, _right, replace' as (Question | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("XOr")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val Not is (AST & UnaryOp & Expr)
  let _attachments: (Attachments | None)
  
  let _expr: Expr
  
  new val create(
    expr': Expr,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("Not missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("Not got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("Not got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Not](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Not => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _expr end
    error
  fun val attach[A: Any #share](a: A): Not => create(_expr, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val expr(): Expr => _expr
  
  fun val with_expr(expr': Expr): Not => create(expr', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return create(replace' as Expr, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _expr: Expr
  
  new val create(
    expr': Expr,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("Neg missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("Neg got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("Neg got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Neg](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Neg => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _expr end
    error
  fun val attach[A: Any #share](a: A): Neg => create(_expr, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val expr(): Expr => _expr
  
  fun val with_expr(expr': Expr): Neg => create(expr', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return create(replace' as Expr, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _expr: Expr
  
  new val create(
    expr': Expr,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("NegUnsafe missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("NegUnsafe got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("NegUnsafe got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NegUnsafe](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): NegUnsafe => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _expr end
    error
  fun val attach[A: Any #share](a: A): NegUnsafe => create(_expr, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val expr(): Expr => _expr
  
  fun val with_expr(expr': Expr): NegUnsafe => create(expr', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return create(replace' as Expr, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _expr: Expr
  
  new val create(
    expr': Expr,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("AddressOf missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("AddressOf got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("AddressOf got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[AddressOf](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): AddressOf => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _expr end
    error
  fun val attach[A: Any #share](a: A): AddressOf => create(_expr, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val expr(): Expr => _expr
  
  fun val with_expr(expr': Expr): AddressOf => create(expr', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return create(replace' as Expr, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _expr: Expr
  
  new val create(
    expr': Expr,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _expr = expr'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let expr': (AST | None) =
      try iter.next()?
      else errs.push(("DigestOf missing required field: expr", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("DigestOf got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _expr =
      try expr' as Expr
      else errs.push(("DigestOf got incompatible field: expr", try (expr' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[DigestOf](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): DigestOf => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _expr end
    error
  fun val attach[A: Any #share](a: A): DigestOf => create(_expr, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val expr(): Expr => _expr
  
  fun val with_expr(expr': Expr): DigestOf => create(expr', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "expr" => _expr
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _expr then
        return create(replace' as Expr, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _local_type: (Type | None)
  
  new val create(
    name': Id,
    local_type': (Type | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _local_type = local_type'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("LocalLet missing required field: name", pos')); error
      end
    let local_type': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("LocalLet got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LocalLet => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _local_type end
    error
  fun val attach[A: Any #share](a: A): LocalLet => create(_name, _local_type, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val local_type(): (Type | None) => _local_type
  
  fun val with_name(name': Id): LocalLet => create(name', _local_type, _attachments)
  fun val with_local_type(local_type': (Type | None)): LocalLet => create(_name, local_type', _attachments)
  
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
        return create(replace' as Id, _local_type, _attachments)
      end
      if child' is _local_type then
        return create(_name, replace' as (Type | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _local_type: (Type | None)
  
  new val create(
    name': Id,
    local_type': (Type | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _local_type = local_type'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("LocalVar missing required field: name", pos')); error
      end
    let local_type': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("LocalVar got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LocalVar => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _local_type end
    error
  fun val attach[A: Any #share](a: A): LocalVar => create(_name, _local_type, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val local_type(): (Type | None) => _local_type
  
  fun val with_name(name': Id): LocalVar => create(name', _local_type, _attachments)
  fun val with_local_type(local_type': (Type | None)): LocalVar => create(_name, local_type', _attachments)
  
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
        return create(replace' as Id, _local_type, _attachments)
      end
      if child' is _local_type then
        return create(_name, replace' as (Type | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Expr
  
  new val create(
    left': Expr,
    right': Expr,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Assign missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Assign missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("Assign got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Assign => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    error
  fun val attach[A: Any #share](a: A): Assign => create(_left, _right, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Expr => _right
  
  fun val with_left(left': Expr): Assign => create(left', _right, _attachments)
  fun val with_right(right': Expr): Assign => create(_left, right', _attachments)
  
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
        return create(replace' as Expr, _right, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Expr, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Id
  
  new val create(
    left': Expr,
    right': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Dot missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Dot missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("Dot got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Dot => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    error
  fun val attach[A: Any #share](a: A): Dot => create(_left, _right, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Id => _right
  
  fun val with_left(left': Expr): Dot => create(left', _right, _attachments)
  fun val with_right(right': Id): Dot => create(_left, right', _attachments)
  
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
        return create(replace' as Expr, _right, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Id
  
  new val create(
    left': Expr,
    right': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Chain missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Chain missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("Chain got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Chain => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    error
  fun val attach[A: Any #share](a: A): Chain => create(_left, _right, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Id => _right
  
  fun val with_left(left': Expr): Chain => create(left', _right, _attachments)
  fun val with_right(right': Id): Chain => create(_left, right', _attachments)
  
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
        return create(replace' as Expr, _right, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: Id
  
  new val create(
    left': Expr,
    right': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Tilde missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Tilde missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("Tilde got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Tilde => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    error
  fun val attach[A: Any #share](a: A): Tilde => create(_left, _right, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): Id => _right
  
  fun val with_left(left': Expr): Tilde => create(left', _right, _attachments)
  fun val with_right(right': Id): Tilde => create(_left, right', _attachments)
  
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
        return create(replace' as Expr, _right, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _left: Expr
  let _right: TypeArgs
  
  new val create(
    left': Expr,
    right': TypeArgs,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("Qualify missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("Qualify missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("Qualify got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Qualify => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    error
  fun val attach[A: Any #share](a: A): Qualify => create(_left, _right, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Expr => _left
  fun val right(): TypeArgs => _right
  
  fun val with_left(left': Expr): Qualify => create(left', _right, _attachments)
  fun val with_right(right': TypeArgs): Qualify => create(_left, right', _attachments)
  
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
        return create(replace' as Expr, _right, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as TypeArgs, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _callable: Expr
  let _args: Args
  let _named_args: NamedArgs
  let _partial: (Question | None)
  
  new val create(
    callable': Expr,
    args': Args = Args,
    named_args': NamedArgs = NamedArgs,
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _callable = callable'
    _args = args'
    _named_args = named_args'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let callable': (AST | None) =
      try iter.next()?
      else errs.push(("Call missing required field: callable", pos')); error
      end
    let args': (AST | None) = try iter.next()? else Args end
    let named_args': (AST | None) = try iter.next()? else NamedArgs end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Call got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _partial =
      try partial' as (Question | None)
      else errs.push(("Call got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Call](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Call => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _callable end
    if idx == (1 + offset) then return _args end
    if idx == (2 + offset) then return _named_args end
    if idx == (3 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): Call => create(_callable, _args, _named_args, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val callable(): Expr => _callable
  fun val args(): Args => _args
  fun val named_args(): NamedArgs => _named_args
  fun val partial(): (Question | None) => _partial
  
  fun val with_callable(callable': Expr): Call => create(callable', _args, _named_args, _partial, _attachments)
  fun val with_args(args': Args): Call => create(_callable, args', _named_args, _partial, _attachments)
  fun val with_named_args(named_args': NamedArgs): Call => create(_callable, _args, named_args', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): Call => create(_callable, _args, _named_args, partial', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "callable" => _callable
    | "args" => _args
    | "named_args" => _named_args
    | "partial" => _partial
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _callable then
        return create(replace' as Expr, _args, _named_args, _partial, _attachments)
      end
      if child' is _args then
        return create(_callable, replace' as Args, _named_args, _partial, _attachments)
      end
      if child' is _named_args then
        return create(_callable, _args, replace' as NamedArgs, _partial, _attachments)
      end
      if child' is _partial then
        return create(_callable, _args, _named_args, replace' as (Question | None), _attachments)
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
    s.>append(_named_args.string()).>push(',').push(' ')
    s.>append(_partial.string())
    s.push(')')
    consume s

class val CallFFI is (AST & Expr)
  let _attachments: (Attachments | None)
  
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
    partial': (Question | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _type_args = type_args'
    _args = args'
    _named_args = named_args'
    _partial = partial'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("CallFFI missing required field: name", pos')); error
      end
    let type_args': (AST | None) = try iter.next()? else None end
    let args': (AST | None) = try iter.next()? else Args end
    let named_args': (AST | None) = try iter.next()? else NamedArgs end
    let partial': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("CallFFI got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): CallFFI => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _type_args end
    if idx == (2 + offset) then return _args end
    if idx == (3 + offset) then return _named_args end
    if idx == (4 + offset) then return _partial end
    error
  fun val attach[A: Any #share](a: A): CallFFI => create(_name, _type_args, _args, _named_args, _partial, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): (Id | LitString) => _name
  fun val type_args(): (TypeArgs | None) => _type_args
  fun val args(): Args => _args
  fun val named_args(): NamedArgs => _named_args
  fun val partial(): (Question | None) => _partial
  
  fun val with_name(name': (Id | LitString)): CallFFI => create(name', _type_args, _args, _named_args, _partial, _attachments)
  fun val with_type_args(type_args': (TypeArgs | None)): CallFFI => create(_name, type_args', _args, _named_args, _partial, _attachments)
  fun val with_args(args': Args): CallFFI => create(_name, _type_args, args', _named_args, _partial, _attachments)
  fun val with_named_args(named_args': NamedArgs): CallFFI => create(_name, _type_args, _args, named_args', _partial, _attachments)
  fun val with_partial(partial': (Question | None)): CallFFI => create(_name, _type_args, _args, _named_args, partial', _attachments)
  
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
        return create(replace' as (Id | LitString), _type_args, _args, _named_args, _partial, _attachments)
      end
      if child' is _type_args then
        return create(_name, replace' as (TypeArgs | None), _args, _named_args, _partial, _attachments)
      end
      if child' is _args then
        return create(_name, _type_args, replace' as Args, _named_args, _partial, _attachments)
      end
      if child' is _named_args then
        return create(_name, _type_args, _args, replace' as NamedArgs, _partial, _attachments)
      end
      if child' is _partial then
        return create(_name, _type_args, _args, _named_args, replace' as (Question | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[Sequence]
  
  new val create(
    list': (coll.Vec[Sequence] | Array[Sequence] val) = coll.Vec[Sequence],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[Sequence] => v
      | let s: Array[Sequence] val => coll.Vec[Sequence].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[Sequence]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as Sequence) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Args got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Args](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Args => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): Args => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[Sequence] => _list
  
  fun val with_list(list': (coll.Vec[Sequence] | Array[Sequence] val)): Args => create(list', _attachments)
  
  fun val with_list_push(x: val->Sequence): Args => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Sequence)?
        return create(_list.update(i, replace' as Sequence)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[NamedArg]
  
  new val create(
    list': (coll.Vec[NamedArg] | Array[NamedArg] val) = coll.Vec[NamedArg],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[NamedArg] => v
      | let s: Array[NamedArg] val => coll.Vec[NamedArg].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[NamedArg]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as NamedArg) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("NamedArgs got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NamedArgs](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): NamedArgs => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): NamedArgs => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[NamedArg] => _list
  
  fun val with_list(list': (coll.Vec[NamedArg] | Array[NamedArg] val)): NamedArgs => create(list', _attachments)
  
  fun val with_list_push(x: val->NamedArg): NamedArgs => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as NamedArg)?
        return create(_list.update(i, replace' as NamedArg)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _value: Sequence
  
  new val create(
    name': Id,
    value': Sequence,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("NamedArg missing required field: name", pos')); error
      end
    let value': (AST | None) =
      try iter.next()?
      else errs.push(("NamedArg missing required field: value", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("NamedArg got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): NamedArg => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _value end
    error
  fun val attach[A: Any #share](a: A): NamedArg => create(_name, _value, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val value(): Sequence => _value
  
  fun val with_name(name': Id): NamedArg => create(name', _value, _attachments)
  fun val with_value(value': Sequence): NamedArg => create(_name, value', _attachments)
  
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
        return create(replace' as Id, _value, _attachments)
      end
      if child' is _value then
        return create(_name, replace' as Sequence, _attachments)
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
  let _attachments: (Attachments | None)
  
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
    object_cap': (Cap | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let method_cap': (AST | None) = try iter.next()? else None end
    let name': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let params': (AST | None) = try iter.next()? else Params end
    let captures': (AST | None) = try iter.next()? else None end
    let return_type': (AST | None) = try iter.next()? else None end
    let partial': (AST | None) = try iter.next()? else None end
    let body': (AST | None) = try iter.next()? else Sequence end
    let object_cap': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Lambda got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Lambda => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _method_cap end
    if idx == (1 + offset) then return _name end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _params end
    if idx == (4 + offset) then return _captures end
    if idx == (5 + offset) then return _return_type end
    if idx == (6 + offset) then return _partial end
    if idx == (7 + offset) then return _body end
    if idx == (8 + offset) then return _object_cap end
    error
  fun val attach[A: Any #share](a: A): Lambda => create(_method_cap, _name, _type_params, _params, _captures, _return_type, _partial, _body, _object_cap, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val method_cap(): (Cap | None) => _method_cap
  fun val name(): (Id | None) => _name
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val captures(): (LambdaCaptures | None) => _captures
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val body(): Sequence => _body
  fun val object_cap(): (Cap | None) => _object_cap
  
  fun val with_method_cap(method_cap': (Cap | None)): Lambda => create(method_cap', _name, _type_params, _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
  fun val with_name(name': (Id | None)): Lambda => create(_method_cap, name', _type_params, _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): Lambda => create(_method_cap, _name, type_params', _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
  fun val with_params(params': Params): Lambda => create(_method_cap, _name, _type_params, params', _captures, _return_type, _partial, _body, _object_cap, _attachments)
  fun val with_captures(captures': (LambdaCaptures | None)): Lambda => create(_method_cap, _name, _type_params, _params, captures', _return_type, _partial, _body, _object_cap, _attachments)
  fun val with_return_type(return_type': (Type | None)): Lambda => create(_method_cap, _name, _type_params, _params, _captures, return_type', _partial, _body, _object_cap, _attachments)
  fun val with_partial(partial': (Question | None)): Lambda => create(_method_cap, _name, _type_params, _params, _captures, _return_type, partial', _body, _object_cap, _attachments)
  fun val with_body(body': Sequence): Lambda => create(_method_cap, _name, _type_params, _params, _captures, _return_type, _partial, body', _object_cap, _attachments)
  fun val with_object_cap(object_cap': (Cap | None)): Lambda => create(_method_cap, _name, _type_params, _params, _captures, _return_type, _partial, _body, object_cap', _attachments)
  
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
        return create(replace' as (Cap | None), _name, _type_params, _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
      end
      if child' is _name then
        return create(_method_cap, replace' as (Id | None), _type_params, _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
      end
      if child' is _type_params then
        return create(_method_cap, _name, replace' as (TypeParams | None), _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
      end
      if child' is _params then
        return create(_method_cap, _name, _type_params, replace' as Params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
      end
      if child' is _captures then
        return create(_method_cap, _name, _type_params, _params, replace' as (LambdaCaptures | None), _return_type, _partial, _body, _object_cap, _attachments)
      end
      if child' is _return_type then
        return create(_method_cap, _name, _type_params, _params, _captures, replace' as (Type | None), _partial, _body, _object_cap, _attachments)
      end
      if child' is _partial then
        return create(_method_cap, _name, _type_params, _params, _captures, _return_type, replace' as (Question | None), _body, _object_cap, _attachments)
      end
      if child' is _body then
        return create(_method_cap, _name, _type_params, _params, _captures, _return_type, _partial, replace' as Sequence, _object_cap, _attachments)
      end
      if child' is _object_cap then
        return create(_method_cap, _name, _type_params, _params, _captures, _return_type, _partial, _body, replace' as (Cap | None), _attachments)
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

class val BareLambda is (AST & Expr)
  let _attachments: (Attachments | None)
  
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
    object_cap': (Cap | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let method_cap': (AST | None) = try iter.next()? else None end
    let name': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let params': (AST | None) = try iter.next()? else Params end
    let captures': (AST | None) = try iter.next()? else None end
    let return_type': (AST | None) = try iter.next()? else None end
    let partial': (AST | None) = try iter.next()? else None end
    let body': (AST | None) = try iter.next()? else Sequence end
    let object_cap': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("BareLambda got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _method_cap =
      try method_cap' as (Cap | None)
      else errs.push(("BareLambda got incompatible field: method_cap", try (method_cap' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as (Id | None)
      else errs.push(("BareLambda got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("BareLambda got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _params =
      try params' as Params
      else errs.push(("BareLambda got incompatible field: params", try (params' as AST).pos() else SourcePosNone end)); error
      end
    _captures =
      try captures' as (LambdaCaptures | None)
      else errs.push(("BareLambda got incompatible field: captures", try (captures' as AST).pos() else SourcePosNone end)); error
      end
    _return_type =
      try return_type' as (Type | None)
      else errs.push(("BareLambda got incompatible field: return_type", try (return_type' as AST).pos() else SourcePosNone end)); error
      end
    _partial =
      try partial' as (Question | None)
      else errs.push(("BareLambda got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
    _body =
      try body' as Sequence
      else errs.push(("BareLambda got incompatible field: body", try (body' as AST).pos() else SourcePosNone end)); error
      end
    _object_cap =
      try object_cap' as (Cap | None)
      else errs.push(("BareLambda got incompatible field: object_cap", try (object_cap' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[BareLambda](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): BareLambda => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _method_cap end
    if idx == (1 + offset) then return _name end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _params end
    if idx == (4 + offset) then return _captures end
    if idx == (5 + offset) then return _return_type end
    if idx == (6 + offset) then return _partial end
    if idx == (7 + offset) then return _body end
    if idx == (8 + offset) then return _object_cap end
    error
  fun val attach[A: Any #share](a: A): BareLambda => create(_method_cap, _name, _type_params, _params, _captures, _return_type, _partial, _body, _object_cap, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val method_cap(): (Cap | None) => _method_cap
  fun val name(): (Id | None) => _name
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val captures(): (LambdaCaptures | None) => _captures
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val body(): Sequence => _body
  fun val object_cap(): (Cap | None) => _object_cap
  
  fun val with_method_cap(method_cap': (Cap | None)): BareLambda => create(method_cap', _name, _type_params, _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
  fun val with_name(name': (Id | None)): BareLambda => create(_method_cap, name', _type_params, _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): BareLambda => create(_method_cap, _name, type_params', _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
  fun val with_params(params': Params): BareLambda => create(_method_cap, _name, _type_params, params', _captures, _return_type, _partial, _body, _object_cap, _attachments)
  fun val with_captures(captures': (LambdaCaptures | None)): BareLambda => create(_method_cap, _name, _type_params, _params, captures', _return_type, _partial, _body, _object_cap, _attachments)
  fun val with_return_type(return_type': (Type | None)): BareLambda => create(_method_cap, _name, _type_params, _params, _captures, return_type', _partial, _body, _object_cap, _attachments)
  fun val with_partial(partial': (Question | None)): BareLambda => create(_method_cap, _name, _type_params, _params, _captures, _return_type, partial', _body, _object_cap, _attachments)
  fun val with_body(body': Sequence): BareLambda => create(_method_cap, _name, _type_params, _params, _captures, _return_type, _partial, body', _object_cap, _attachments)
  fun val with_object_cap(object_cap': (Cap | None)): BareLambda => create(_method_cap, _name, _type_params, _params, _captures, _return_type, _partial, _body, object_cap', _attachments)
  
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
        return create(replace' as (Cap | None), _name, _type_params, _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
      end
      if child' is _name then
        return create(_method_cap, replace' as (Id | None), _type_params, _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
      end
      if child' is _type_params then
        return create(_method_cap, _name, replace' as (TypeParams | None), _params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
      end
      if child' is _params then
        return create(_method_cap, _name, _type_params, replace' as Params, _captures, _return_type, _partial, _body, _object_cap, _attachments)
      end
      if child' is _captures then
        return create(_method_cap, _name, _type_params, _params, replace' as (LambdaCaptures | None), _return_type, _partial, _body, _object_cap, _attachments)
      end
      if child' is _return_type then
        return create(_method_cap, _name, _type_params, _params, _captures, replace' as (Type | None), _partial, _body, _object_cap, _attachments)
      end
      if child' is _partial then
        return create(_method_cap, _name, _type_params, _params, _captures, _return_type, replace' as (Question | None), _body, _object_cap, _attachments)
      end
      if child' is _body then
        return create(_method_cap, _name, _type_params, _params, _captures, _return_type, _partial, replace' as Sequence, _object_cap, _attachments)
      end
      if child' is _object_cap then
        return create(_method_cap, _name, _type_params, _params, _captures, _return_type, _partial, _body, replace' as (Cap | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("BareLambda")
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[LambdaCapture]
  
  new val create(
    list': (coll.Vec[LambdaCapture] | Array[LambdaCapture] val) = coll.Vec[LambdaCapture],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[LambdaCapture] => v
      | let s: Array[LambdaCapture] val => coll.Vec[LambdaCapture].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[LambdaCapture]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as LambdaCapture) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("LambdaCaptures got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LambdaCaptures](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LambdaCaptures => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): LambdaCaptures => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[LambdaCapture] => _list
  
  fun val with_list(list': (coll.Vec[LambdaCapture] | Array[LambdaCapture] val)): LambdaCaptures => create(list', _attachments)
  
  fun val with_list_push(x: val->LambdaCapture): LambdaCaptures => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as LambdaCapture)?
        return create(_list.update(i, replace' as LambdaCapture)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _local_type: (Type | None)
  let _value: (Expr | None)
  
  new val create(
    name': Id,
    local_type': (Type | None) = None,
    value': (Expr | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _local_type = local_type'
    _value = value'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("LambdaCapture missing required field: name", pos')); error
      end
    let local_type': (AST | None) = try iter.next()? else None end
    let value': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("LambdaCapture got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
    _value =
      try value' as (Expr | None)
      else errs.push(("LambdaCapture got incompatible field: value", try (value' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LambdaCapture](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LambdaCapture => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _local_type end
    if idx == (2 + offset) then return _value end
    error
  fun val attach[A: Any #share](a: A): LambdaCapture => create(_name, _local_type, _value, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val local_type(): (Type | None) => _local_type
  fun val value(): (Expr | None) => _value
  
  fun val with_name(name': Id): LambdaCapture => create(name', _local_type, _value, _attachments)
  fun val with_local_type(local_type': (Type | None)): LambdaCapture => create(_name, local_type', _value, _attachments)
  fun val with_value(value': (Expr | None)): LambdaCapture => create(_name, _local_type, value', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    | "local_type" => _local_type
    | "value" => _value
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return create(replace' as Id, _local_type, _value, _attachments)
      end
      if child' is _local_type then
        return create(_name, replace' as (Type | None), _value, _attachments)
      end
      if child' is _value then
        return create(_name, _local_type, replace' as (Expr | None), _attachments)
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
    s.>append(_value.string())
    s.push(')')
    consume s

class val Object is (AST & Expr)
  let _attachments: (Attachments | None)
  
  let _cap: (Cap | None)
  let _provides: (Type | None)
  let _members: (Members | None)
  
  new val create(
    cap': (Cap | None) = None,
    provides': (Type | None) = None,
    members': (Members | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _cap = cap'
    _provides = provides'
    _members = members'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let cap': (AST | None) = try iter.next()? else None end
    let provides': (AST | None) = try iter.next()? else None end
    let members': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("Object got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Object => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _cap end
    if idx == (1 + offset) then return _provides end
    if idx == (2 + offset) then return _members end
    error
  fun val attach[A: Any #share](a: A): Object => create(_cap, _provides, _members, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val cap(): (Cap | None) => _cap
  fun val provides(): (Type | None) => _provides
  fun val members(): (Members | None) => _members
  
  fun val with_cap(cap': (Cap | None)): Object => create(cap', _provides, _members, _attachments)
  fun val with_provides(provides': (Type | None)): Object => create(_cap, provides', _members, _attachments)
  fun val with_members(members': (Members | None)): Object => create(_cap, _provides, members', _attachments)
  
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
        return create(replace' as (Cap | None), _provides, _members, _attachments)
      end
      if child' is _provides then
        return create(_cap, replace' as (Type | None), _members, _attachments)
      end
      if child' is _members then
        return create(_cap, _provides, replace' as (Members | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _elem_type: (Type | None)
  let _sequence: Sequence
  
  new val create(
    elem_type': (Type | None) = None,
    sequence': Sequence = Sequence,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _elem_type = elem_type'
    _sequence = sequence'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let elem_type': (AST | None) = try iter.next()? else None end
    let sequence': (AST | None) = try iter.next()? else Sequence end
    if
      try
        let extra' = iter.next()?
        errs.push(("LitArray got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LitArray => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _elem_type end
    if idx == (1 + offset) then return _sequence end
    error
  fun val attach[A: Any #share](a: A): LitArray => create(_elem_type, _sequence, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val elem_type(): (Type | None) => _elem_type
  fun val sequence(): Sequence => _sequence
  
  fun val with_elem_type(elem_type': (Type | None)): LitArray => create(elem_type', _sequence, _attachments)
  fun val with_sequence(sequence': Sequence): LitArray => create(_elem_type, sequence', _attachments)
  
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
        return create(replace' as (Type | None), _sequence, _attachments)
      end
      if child' is _sequence then
        return create(_elem_type, replace' as Sequence, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _elements: coll.Vec[Sequence]
  
  new val create(
    elements': (coll.Vec[Sequence] | Array[Sequence] val) = coll.Vec[Sequence],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _elements = 
      match elements'
      | let v: coll.Vec[Sequence] => v
      | let s: Array[Sequence] val => coll.Vec[Sequence].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var elements' = coll.Vec[Sequence]
    var elements_next' = try iter.next()? else None end
    while true do
      try elements' = elements'.push(elements_next' as Sequence) else break end
      try elements_next' = iter.next()? else elements_next' = None; break end
    end
    if elements_next' isnt None then
      let extra' = elements_next'
      errs.push(("Tuple got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _elements = elements'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Tuple](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Tuple => attach[SourcePosAny](pos')
  
  fun val size(): USize => _elements.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _elements.size()) then return _elements(idx - (0 + offset))? end
    offset = (offset + _elements.size()) - 1
    error
  fun val attach[A: Any #share](a: A): Tuple => create(_elements, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val elements(): coll.Vec[Sequence] => _elements
  
  fun val with_elements(elements': (coll.Vec[Sequence] | Array[Sequence] val)): Tuple => create(elements', _attachments)
  
  fun val with_elements_push(x: val->Sequence): Tuple => with_elements(_elements.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "elements" => _elements(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _elements.find(child' as Sequence)?
        return create(_elements.update(i, replace' as Sequence)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("This got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[This](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): This => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): This => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("LitTrue got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitTrue](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LitTrue => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): LitTrue => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("LitFalse got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitFalse](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LitFalse => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): LitFalse => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  let _value: U128
  new val create(value': U128, attachments': (Attachments | None) = None) =>
    _value = value'
    _attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    _value =
      try
        _ASTUtil.parse_lit_integer(pos')?
      else
        errs.push(("LitInteger failed to parse value", pos')); true
        error
      end
    
    if
      try
        let extra' = iter.next()?
        errs.push(("LitInteger got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitInteger](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LitInteger => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  fun val attach[A: Any #share](a: A): LitInteger => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): U128 => _value
  fun val with_value(value': U128): LitInteger => create(value', _attachments)
  fun string(): String iso^ =>
    recover
      String.>append("LitInteger(").>append(_value.string()).>push(')')
    end

class val LitFloat is (AST & Expr)
  let _attachments: (Attachments | None)
  let _value: F64
  new val create(value': F64, attachments': (Attachments | None) = None) =>
    _value = value'
    _attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    _value =
      try
        _ASTUtil.parse_lit_float(pos')?
      else
        errs.push(("LitFloat failed to parse value", pos')); true
        error
      end
    
    if
      try
        let extra' = iter.next()?
        errs.push(("LitFloat got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitFloat](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LitFloat => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  fun val attach[A: Any #share](a: A): LitFloat => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): F64 => _value
  fun val with_value(value': F64): LitFloat => create(value', _attachments)
  fun string(): String iso^ =>
    recover
      String.>append("LitFloat(").>append(_value.string()).>push(')')
    end

class val LitString is (AST & Expr)
  let _attachments: (Attachments | None)
  let _value: String
  new val create(value': String, attachments': (Attachments | None) = None) =>
    _value = value'
    _attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    _value =
      try
        _ASTUtil.parse_lit_string(pos')?
      else
        errs.push(("LitString failed to parse value", pos')); true
        error
      end
    
    if
      try
        let extra' = iter.next()?
        errs.push(("LitString got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitString](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LitString => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  fun val attach[A: Any #share](a: A): LitString => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): String => _value
  fun val with_value(value': String): LitString => create(value', _attachments)
  fun string(): String iso^ =>
    recover
      String.>append("LitString(").>append(_value.string()).>push(')')
    end

class val LitCharacter is (AST & Expr)
  let _attachments: (Attachments | None)
  let _value: U8
  new val create(value': U8, attachments': (Attachments | None) = None) =>
    _value = value'
    _attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    _value =
      try
        _ASTUtil.parse_lit_character(pos')?
      else
        errs.push(("LitCharacter failed to parse value", pos')); true
        error
      end
    
    if
      try
        let extra' = iter.next()?
        errs.push(("LitCharacter got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitCharacter](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LitCharacter => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  fun val attach[A: Any #share](a: A): LitCharacter => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): U8 => _value
  fun val with_value(value': U8): LitCharacter => create(value', _attachments)
  fun string(): String iso^ =>
    recover
      String.>append("LitCharacter(").>append(_value.string()).>push(')')
    end

class val LitLocation is (AST & Expr)
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("LitLocation got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LitLocation](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LitLocation => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): LitLocation => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  
  new val create(
    name': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("Reference missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("Reference got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("Reference got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Reference](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Reference => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): Reference => create(_name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  
  fun val with_name(name': Id): Reference => create(name', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return create(replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("DontCare got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[DontCare](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): DontCare => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): DontCare => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  
  new val create(
    name': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("PackageRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("PackageRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("PackageRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[PackageRef](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): PackageRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): PackageRef => create(_name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  
  fun val with_name(name': Id): PackageRef => create(name', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return create(replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _receiver: Expr
  let _name: (Id | TypeArgs)
  
  new val create(
    receiver': Expr,
    name': (Id | TypeArgs),
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let receiver': (AST | None) =
      try iter.next()?
      else errs.push(("MethodFunRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("MethodFunRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("MethodFunRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): MethodFunRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _receiver end
    if idx == (1 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): MethodFunRef => create(_receiver, _name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val receiver(): Expr => _receiver
  fun val name(): (Id | TypeArgs) => _name
  
  fun val with_receiver(receiver': Expr): MethodFunRef => create(receiver', _name, _attachments)
  fun val with_name(name': (Id | TypeArgs)): MethodFunRef => create(_receiver, name', _attachments)
  
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
        return create(replace' as Expr, _name, _attachments)
      end
      if child' is _name then
        return create(_receiver, replace' as (Id | TypeArgs), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _receiver: Expr
  let _name: (Id | TypeArgs)
  
  new val create(
    receiver': Expr,
    name': (Id | TypeArgs),
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let receiver': (AST | None) =
      try iter.next()?
      else errs.push(("MethodNewRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("MethodNewRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("MethodNewRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): MethodNewRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _receiver end
    if idx == (1 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): MethodNewRef => create(_receiver, _name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val receiver(): Expr => _receiver
  fun val name(): (Id | TypeArgs) => _name
  
  fun val with_receiver(receiver': Expr): MethodNewRef => create(receiver', _name, _attachments)
  fun val with_name(name': (Id | TypeArgs)): MethodNewRef => create(_receiver, name', _attachments)
  
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
        return create(replace' as Expr, _name, _attachments)
      end
      if child' is _name then
        return create(_receiver, replace' as (Id | TypeArgs), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _receiver: Expr
  let _name: (Id | TypeArgs)
  
  new val create(
    receiver': Expr,
    name': (Id | TypeArgs),
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let receiver': (AST | None) =
      try iter.next()?
      else errs.push(("MethodBeRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("MethodBeRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("MethodBeRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): MethodBeRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _receiver end
    if idx == (1 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): MethodBeRef => create(_receiver, _name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val receiver(): Expr => _receiver
  fun val name(): (Id | TypeArgs) => _name
  
  fun val with_receiver(receiver': Expr): MethodBeRef => create(receiver', _name, _attachments)
  fun val with_name(name': (Id | TypeArgs)): MethodBeRef => create(_receiver, name', _attachments)
  
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
        return create(replace' as Expr, _name, _attachments)
      end
      if child' is _name then
        return create(_receiver, replace' as (Id | TypeArgs), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _package: Expr
  let _name: (Id | TypeArgs)
  
  new val create(
    package': Expr,
    name': (Id | TypeArgs),
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _package = package'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let package': (AST | None) =
      try iter.next()?
      else errs.push(("TypeRef missing required field: package", pos')); error
      end
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("TypeRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("TypeRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): TypeRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _package end
    if idx == (1 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): TypeRef => create(_package, _name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val package(): Expr => _package
  fun val name(): (Id | TypeArgs) => _name
  
  fun val with_package(package': Expr): TypeRef => create(package', _name, _attachments)
  fun val with_name(name': (Id | TypeArgs)): TypeRef => create(_package, name', _attachments)
  
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
        return create(replace' as Expr, _name, _attachments)
      end
      if child' is _name then
        return create(_package, replace' as (Id | TypeArgs), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _receiver: Expr
  let _name: Id
  
  new val create(
    receiver': Expr,
    name': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let receiver': (AST | None) =
      try iter.next()?
      else errs.push(("FieldLetRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("FieldLetRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("FieldLetRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): FieldLetRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _receiver end
    if idx == (1 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): FieldLetRef => create(_receiver, _name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val receiver(): Expr => _receiver
  fun val name(): Id => _name
  
  fun val with_receiver(receiver': Expr): FieldLetRef => create(receiver', _name, _attachments)
  fun val with_name(name': Id): FieldLetRef => create(_receiver, name', _attachments)
  
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
        return create(replace' as Expr, _name, _attachments)
      end
      if child' is _name then
        return create(_receiver, replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _receiver: Expr
  let _name: Id
  
  new val create(
    receiver': Expr,
    name': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let receiver': (AST | None) =
      try iter.next()?
      else errs.push(("FieldVarRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("FieldVarRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("FieldVarRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): FieldVarRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _receiver end
    if idx == (1 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): FieldVarRef => create(_receiver, _name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val receiver(): Expr => _receiver
  fun val name(): Id => _name
  
  fun val with_receiver(receiver': Expr): FieldVarRef => create(receiver', _name, _attachments)
  fun val with_name(name': Id): FieldVarRef => create(_receiver, name', _attachments)
  
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
        return create(replace' as Expr, _name, _attachments)
      end
      if child' is _name then
        return create(_receiver, replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _receiver: Expr
  let _name: Id
  
  new val create(
    receiver': Expr,
    name': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let receiver': (AST | None) =
      try iter.next()?
      else errs.push(("FieldEmbedRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("FieldEmbedRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("FieldEmbedRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): FieldEmbedRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _receiver end
    if idx == (1 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): FieldEmbedRef => create(_receiver, _name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val receiver(): Expr => _receiver
  fun val name(): Id => _name
  
  fun val with_receiver(receiver': Expr): FieldEmbedRef => create(receiver', _name, _attachments)
  fun val with_name(name': Id): FieldEmbedRef => create(_receiver, name', _attachments)
  
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
        return create(replace' as Expr, _name, _attachments)
      end
      if child' is _name then
        return create(_receiver, replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _receiver: Expr
  let _name: LitInteger
  
  new val create(
    receiver': Expr,
    name': LitInteger,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _receiver = receiver'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let receiver': (AST | None) =
      try iter.next()?
      else errs.push(("TupleElementRef missing required field: receiver", pos')); error
      end
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("TupleElementRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("TupleElementRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): TupleElementRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _receiver end
    if idx == (1 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): TupleElementRef => create(_receiver, _name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val receiver(): Expr => _receiver
  fun val name(): LitInteger => _name
  
  fun val with_receiver(receiver': Expr): TupleElementRef => create(receiver', _name, _attachments)
  fun val with_name(name': LitInteger): TupleElementRef => create(_receiver, name', _attachments)
  
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
        return create(replace' as Expr, _name, _attachments)
      end
      if child' is _name then
        return create(_receiver, replace' as LitInteger, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  
  new val create(
    name': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("LocalLetRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("LocalLetRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("LocalLetRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LocalLetRef](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LocalLetRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): LocalLetRef => create(_name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  
  fun val with_name(name': Id): LocalLetRef => create(name', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return create(replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  
  new val create(
    name': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("LocalVarRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("LocalVarRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("LocalVarRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LocalVarRef](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LocalVarRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): LocalVarRef => create(_name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  
  fun val with_name(name': Id): LocalVarRef => create(name', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return create(replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  
  new val create(
    name': Id,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("ParamRef missing required field: name", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("ParamRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _name =
      try name' as Id
      else errs.push(("ParamRef got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ParamRef](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): ParamRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    error
  fun val attach[A: Any #share](a: A): ParamRef => create(_name, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  
  fun val with_name(name': Id): ParamRef => create(name', _attachments)
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "name" => _name
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      if child' is _name then
        return create(replace' as Id, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _left: Type
  let _right: Type
  
  new val create(
    left': Type,
    right': Type,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _left = left'
    _right = right'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let left': (AST | None) =
      try iter.next()?
      else errs.push(("ViewpointType missing required field: left", pos')); error
      end
    let right': (AST | None) =
      try iter.next()?
      else errs.push(("ViewpointType missing required field: right", pos')); error
      end
    if
      try
        let extra' = iter.next()?
        errs.push(("ViewpointType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): ViewpointType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _left end
    if idx == (1 + offset) then return _right end
    error
  fun val attach[A: Any #share](a: A): ViewpointType => create(_left, _right, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val left(): Type => _left
  fun val right(): Type => _right
  
  fun val with_left(left': Type): ViewpointType => create(left', _right, _attachments)
  fun val with_right(right': Type): ViewpointType => create(_left, right', _attachments)
  
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
        return create(replace' as Type, _right, _attachments)
      end
      if child' is _right then
        return create(_left, replace' as Type, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[Type]
  
  new val create(
    list': (coll.Vec[Type] | Array[Type] val) = coll.Vec[Type],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[Type] => v
      | let s: Array[Type] val => coll.Vec[Type].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[Type]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as Type) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("UnionType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[UnionType](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): UnionType => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): UnionType => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[Type] => _list
  
  fun val with_list(list': (coll.Vec[Type] | Array[Type] val)): UnionType => create(list', _attachments)
  
  fun val with_list_push(x: val->Type): UnionType => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Type)?
        return create(_list.update(i, replace' as Type)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[Type]
  
  new val create(
    list': (coll.Vec[Type] | Array[Type] val) = coll.Vec[Type],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[Type] => v
      | let s: Array[Type] val => coll.Vec[Type].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[Type]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as Type) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("IsectType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[IsectType](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): IsectType => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): IsectType => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[Type] => _list
  
  fun val with_list(list': (coll.Vec[Type] | Array[Type] val)): IsectType => create(list', _attachments)
  
  fun val with_list_push(x: val->Type): IsectType => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Type)?
        return create(_list.update(i, replace' as Type)?, _attachments)
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
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[Type]
  
  new val create(
    list': (coll.Vec[Type] | Array[Type] val) = coll.Vec[Type],
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[Type] => v
      | let s: Array[Type] val => coll.Vec[Type].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[Type]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as Type) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("TupleType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[TupleType](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): TupleType => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): TupleType => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[Type] => _list
  
  fun val with_list(list': (coll.Vec[Type] | Array[Type] val)): TupleType => create(list', _attachments)
  
  fun val with_list_push(x: val->Type): TupleType => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Type)?
        return create(_list.update(i, replace' as Type)?, _attachments)
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
  let _attachments: (Attachments | None)
  
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
    cap_mod': (CapMod | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _package = package'
    _type_args = type_args'
    _cap = cap'
    _cap_mod = cap_mod'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("NominalType missing required field: name", pos')); error
      end
    let package': (AST | None) = try iter.next()? else None end
    let type_args': (AST | None) = try iter.next()? else None end
    let cap': (AST | None) = try iter.next()? else None end
    let cap_mod': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("NominalType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): NominalType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _package end
    if idx == (2 + offset) then return _type_args end
    if idx == (3 + offset) then return _cap end
    if idx == (4 + offset) then return _cap_mod end
    error
  fun val attach[A: Any #share](a: A): NominalType => create(_name, _package, _type_args, _cap, _cap_mod, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val package(): (Id | None) => _package
  fun val type_args(): (TypeArgs | None) => _type_args
  fun val cap(): (Cap | GenCap | None) => _cap
  fun val cap_mod(): (CapMod | None) => _cap_mod
  
  fun val with_name(name': Id): NominalType => create(name', _package, _type_args, _cap, _cap_mod, _attachments)
  fun val with_package(package': (Id | None)): NominalType => create(_name, package', _type_args, _cap, _cap_mod, _attachments)
  fun val with_type_args(type_args': (TypeArgs | None)): NominalType => create(_name, _package, type_args', _cap, _cap_mod, _attachments)
  fun val with_cap(cap': (Cap | GenCap | None)): NominalType => create(_name, _package, _type_args, cap', _cap_mod, _attachments)
  fun val with_cap_mod(cap_mod': (CapMod | None)): NominalType => create(_name, _package, _type_args, _cap, cap_mod', _attachments)
  
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
        return create(replace' as Id, _package, _type_args, _cap, _cap_mod, _attachments)
      end
      if child' is _package then
        return create(_name, replace' as (Id | None), _type_args, _cap, _cap_mod, _attachments)
      end
      if child' is _type_args then
        return create(_name, _package, replace' as (TypeArgs | None), _cap, _cap_mod, _attachments)
      end
      if child' is _cap then
        return create(_name, _package, _type_args, replace' as (Cap | GenCap | None), _cap_mod, _attachments)
      end
      if child' is _cap_mod then
        return create(_name, _package, _type_args, _cap, replace' as (CapMod | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  let _cap: Cap
  let _type_params: (TypeParams | None)
  let _params: Params
  let _return_type: (Type | None)
  
  new val create(
    cap': Cap,
    type_params': (TypeParams | None) = None,
    params': Params = Params,
    return_type': (Type | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _cap = cap'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let cap': (AST | None) =
      try iter.next()?
      else errs.push(("FunType missing required field: cap", pos')); error
      end
    let type_params': (AST | None) = try iter.next()? else None end
    let params': (AST | None) = try iter.next()? else Params end
    let return_type': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("FunType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): FunType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _cap end
    if idx == (1 + offset) then return _type_params end
    if idx == (2 + offset) then return _params end
    if idx == (3 + offset) then return _return_type end
    error
  fun val attach[A: Any #share](a: A): FunType => create(_cap, _type_params, _params, _return_type, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val cap(): Cap => _cap
  fun val type_params(): (TypeParams | None) => _type_params
  fun val params(): Params => _params
  fun val return_type(): (Type | None) => _return_type
  
  fun val with_cap(cap': Cap): FunType => create(cap', _type_params, _params, _return_type, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): FunType => create(_cap, type_params', _params, _return_type, _attachments)
  fun val with_params(params': Params): FunType => create(_cap, _type_params, params', _return_type, _attachments)
  fun val with_return_type(return_type': (Type | None)): FunType => create(_cap, _type_params, _params, return_type', _attachments)
  
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
        return create(replace' as Cap, _type_params, _params, _return_type, _attachments)
      end
      if child' is _type_params then
        return create(_cap, replace' as (TypeParams | None), _params, _return_type, _attachments)
      end
      if child' is _params then
        return create(_cap, _type_params, replace' as Params, _return_type, _attachments)
      end
      if child' is _return_type then
        return create(_cap, _type_params, _params, replace' as (Type | None), _attachments)
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
  let _attachments: (Attachments | None)
  
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
    cap_mod': (CapMod | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let method_cap': (AST | None) = try iter.next()? else None end
    let name': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let param_types': (AST | None) = try iter.next()? else TupleType end
    let return_type': (AST | None) = try iter.next()? else None end
    let partial': (AST | None) = try iter.next()? else None end
    let object_cap': (AST | None) = try iter.next()? else None end
    let cap_mod': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("LambdaType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LambdaType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _method_cap end
    if idx == (1 + offset) then return _name end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _param_types end
    if idx == (4 + offset) then return _return_type end
    if idx == (5 + offset) then return _partial end
    if idx == (6 + offset) then return _object_cap end
    if idx == (7 + offset) then return _cap_mod end
    error
  fun val attach[A: Any #share](a: A): LambdaType => create(_method_cap, _name, _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val method_cap(): (Cap | None) => _method_cap
  fun val name(): (Id | None) => _name
  fun val type_params(): (TypeParams | None) => _type_params
  fun val param_types(): TupleType => _param_types
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val object_cap(): (Cap | GenCap | None) => _object_cap
  fun val cap_mod(): (CapMod | None) => _cap_mod
  
  fun val with_method_cap(method_cap': (Cap | None)): LambdaType => create(method_cap', _name, _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
  fun val with_name(name': (Id | None)): LambdaType => create(_method_cap, name', _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): LambdaType => create(_method_cap, _name, type_params', _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
  fun val with_param_types(param_types': TupleType): LambdaType => create(_method_cap, _name, _type_params, param_types', _return_type, _partial, _object_cap, _cap_mod, _attachments)
  fun val with_return_type(return_type': (Type | None)): LambdaType => create(_method_cap, _name, _type_params, _param_types, return_type', _partial, _object_cap, _cap_mod, _attachments)
  fun val with_partial(partial': (Question | None)): LambdaType => create(_method_cap, _name, _type_params, _param_types, _return_type, partial', _object_cap, _cap_mod, _attachments)
  fun val with_object_cap(object_cap': (Cap | GenCap | None)): LambdaType => create(_method_cap, _name, _type_params, _param_types, _return_type, _partial, object_cap', _cap_mod, _attachments)
  fun val with_cap_mod(cap_mod': (CapMod | None)): LambdaType => create(_method_cap, _name, _type_params, _param_types, _return_type, _partial, _object_cap, cap_mod', _attachments)
  
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
        return create(replace' as (Cap | None), _name, _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
      end
      if child' is _name then
        return create(_method_cap, replace' as (Id | None), _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
      end
      if child' is _type_params then
        return create(_method_cap, _name, replace' as (TypeParams | None), _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
      end
      if child' is _param_types then
        return create(_method_cap, _name, _type_params, replace' as TupleType, _return_type, _partial, _object_cap, _cap_mod, _attachments)
      end
      if child' is _return_type then
        return create(_method_cap, _name, _type_params, _param_types, replace' as (Type | None), _partial, _object_cap, _cap_mod, _attachments)
      end
      if child' is _partial then
        return create(_method_cap, _name, _type_params, _param_types, _return_type, replace' as (Question | None), _object_cap, _cap_mod, _attachments)
      end
      if child' is _object_cap then
        return create(_method_cap, _name, _type_params, _param_types, _return_type, _partial, replace' as (Cap | GenCap | None), _cap_mod, _attachments)
      end
      if child' is _cap_mod then
        return create(_method_cap, _name, _type_params, _param_types, _return_type, _partial, _object_cap, replace' as (CapMod | None), _attachments)
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

class val BareLambdaType is (AST & Type)
  let _attachments: (Attachments | None)
  
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
    cap_mod': (CapMod | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
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
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let method_cap': (AST | None) = try iter.next()? else None end
    let name': (AST | None) = try iter.next()? else None end
    let type_params': (AST | None) = try iter.next()? else None end
    let param_types': (AST | None) = try iter.next()? else TupleType end
    let return_type': (AST | None) = try iter.next()? else None end
    let partial': (AST | None) = try iter.next()? else None end
    let object_cap': (AST | None) = try iter.next()? else None end
    let cap_mod': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("BareLambdaType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
    
    _method_cap =
      try method_cap' as (Cap | None)
      else errs.push(("BareLambdaType got incompatible field: method_cap", try (method_cap' as AST).pos() else SourcePosNone end)); error
      end
    _name =
      try name' as (Id | None)
      else errs.push(("BareLambdaType got incompatible field: name", try (name' as AST).pos() else SourcePosNone end)); error
      end
    _type_params =
      try type_params' as (TypeParams | None)
      else errs.push(("BareLambdaType got incompatible field: type_params", try (type_params' as AST).pos() else SourcePosNone end)); error
      end
    _param_types =
      try param_types' as TupleType
      else errs.push(("BareLambdaType got incompatible field: param_types", try (param_types' as AST).pos() else SourcePosNone end)); error
      end
    _return_type =
      try return_type' as (Type | None)
      else errs.push(("BareLambdaType got incompatible field: return_type", try (return_type' as AST).pos() else SourcePosNone end)); error
      end
    _partial =
      try partial' as (Question | None)
      else errs.push(("BareLambdaType got incompatible field: partial", try (partial' as AST).pos() else SourcePosNone end)); error
      end
    _object_cap =
      try object_cap' as (Cap | GenCap | None)
      else errs.push(("BareLambdaType got incompatible field: object_cap", try (object_cap' as AST).pos() else SourcePosNone end)); error
      end
    _cap_mod =
      try cap_mod' as (CapMod | None)
      else errs.push(("BareLambdaType got incompatible field: cap_mod", try (cap_mod' as AST).pos() else SourcePosNone end)); error
      end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[BareLambdaType](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): BareLambdaType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _method_cap end
    if idx == (1 + offset) then return _name end
    if idx == (2 + offset) then return _type_params end
    if idx == (3 + offset) then return _param_types end
    if idx == (4 + offset) then return _return_type end
    if idx == (5 + offset) then return _partial end
    if idx == (6 + offset) then return _object_cap end
    if idx == (7 + offset) then return _cap_mod end
    error
  fun val attach[A: Any #share](a: A): BareLambdaType => create(_method_cap, _name, _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val method_cap(): (Cap | None) => _method_cap
  fun val name(): (Id | None) => _name
  fun val type_params(): (TypeParams | None) => _type_params
  fun val param_types(): TupleType => _param_types
  fun val return_type(): (Type | None) => _return_type
  fun val partial(): (Question | None) => _partial
  fun val object_cap(): (Cap | GenCap | None) => _object_cap
  fun val cap_mod(): (CapMod | None) => _cap_mod
  
  fun val with_method_cap(method_cap': (Cap | None)): BareLambdaType => create(method_cap', _name, _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
  fun val with_name(name': (Id | None)): BareLambdaType => create(_method_cap, name', _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
  fun val with_type_params(type_params': (TypeParams | None)): BareLambdaType => create(_method_cap, _name, type_params', _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
  fun val with_param_types(param_types': TupleType): BareLambdaType => create(_method_cap, _name, _type_params, param_types', _return_type, _partial, _object_cap, _cap_mod, _attachments)
  fun val with_return_type(return_type': (Type | None)): BareLambdaType => create(_method_cap, _name, _type_params, _param_types, return_type', _partial, _object_cap, _cap_mod, _attachments)
  fun val with_partial(partial': (Question | None)): BareLambdaType => create(_method_cap, _name, _type_params, _param_types, _return_type, partial', _object_cap, _cap_mod, _attachments)
  fun val with_object_cap(object_cap': (Cap | GenCap | None)): BareLambdaType => create(_method_cap, _name, _type_params, _param_types, _return_type, _partial, object_cap', _cap_mod, _attachments)
  fun val with_cap_mod(cap_mod': (CapMod | None)): BareLambdaType => create(_method_cap, _name, _type_params, _param_types, _return_type, _partial, _object_cap, cap_mod', _attachments)
  
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
        return create(replace' as (Cap | None), _name, _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
      end
      if child' is _name then
        return create(_method_cap, replace' as (Id | None), _type_params, _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
      end
      if child' is _type_params then
        return create(_method_cap, _name, replace' as (TypeParams | None), _param_types, _return_type, _partial, _object_cap, _cap_mod, _attachments)
      end
      if child' is _param_types then
        return create(_method_cap, _name, _type_params, replace' as TupleType, _return_type, _partial, _object_cap, _cap_mod, _attachments)
      end
      if child' is _return_type then
        return create(_method_cap, _name, _type_params, _param_types, replace' as (Type | None), _partial, _object_cap, _cap_mod, _attachments)
      end
      if child' is _partial then
        return create(_method_cap, _name, _type_params, _param_types, _return_type, replace' as (Question | None), _object_cap, _cap_mod, _attachments)
      end
      if child' is _object_cap then
        return create(_method_cap, _name, _type_params, _param_types, _return_type, _partial, replace' as (Cap | GenCap | None), _cap_mod, _attachments)
      end
      if child' is _cap_mod then
        return create(_method_cap, _name, _type_params, _param_types, _return_type, _partial, _object_cap, replace' as (CapMod | None), _attachments)
      end
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("BareLambdaType")
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
  let _attachments: (Attachments | None)
  
  let _name: Id
  let _cap: (Cap | GenCap | None)
  let _cap_mod: (CapMod | None)
  
  new val create(
    name': Id,
    cap': (Cap | GenCap | None) = None,
    cap_mod': (CapMod | None) = None,
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _name = name'
    _cap = cap'
    _cap_mod = cap_mod'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    let name': (AST | None) =
      try iter.next()?
      else errs.push(("TypeParamRef missing required field: name", pos')); error
      end
    let cap': (AST | None) = try iter.next()? else None end
    let cap_mod': (AST | None) = try iter.next()? else None end
    if
      try
        let extra' = iter.next()?
        errs.push(("TypeParamRef got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
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
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): TypeParamRef => attach[SourcePosAny](pos')
  
  fun val size(): USize => 1 + 1 + 1
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx == (0 + offset) then return _name end
    if idx == (1 + offset) then return _cap end
    if idx == (2 + offset) then return _cap_mod end
    error
  fun val attach[A: Any #share](a: A): TypeParamRef => create(_name, _cap, _cap_mod, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val name(): Id => _name
  fun val cap(): (Cap | GenCap | None) => _cap
  fun val cap_mod(): (CapMod | None) => _cap_mod
  
  fun val with_name(name': Id): TypeParamRef => create(name', _cap, _cap_mod, _attachments)
  fun val with_cap(cap': (Cap | GenCap | None)): TypeParamRef => create(_name, cap', _cap_mod, _attachments)
  fun val with_cap_mod(cap_mod': (CapMod | None)): TypeParamRef => create(_name, _cap, cap_mod', _attachments)
  
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
        return create(replace' as Id, _cap, _cap_mod, _attachments)
      end
      if child' is _cap then
        return create(_name, replace' as (Cap | GenCap | None), _cap_mod, _attachments)
      end
      if child' is _cap_mod then
        return create(_name, _cap, replace' as (CapMod | None), _attachments)
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("ThisType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ThisType](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): ThisType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): ThisType => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("DontCareType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[DontCareType](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): DontCareType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): DontCareType => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("ErrorType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ErrorType](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): ErrorType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): ErrorType => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("LiteralType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LiteralType](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LiteralType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): LiteralType => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("LiteralTypeBranch got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LiteralTypeBranch](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): LiteralTypeBranch => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): LiteralTypeBranch => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("OpLiteralType got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[OpLiteralType](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): OpLiteralType => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): OpLiteralType => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Iso got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Iso](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Iso => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Iso => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Trn got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Trn](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Trn => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Trn => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Ref got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Ref](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Ref => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Ref => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Val got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Val](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Val => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Val => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Box got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Box](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Box => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Box => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Tag got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Tag](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Tag => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Tag => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("CapRead got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CapRead](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): CapRead => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): CapRead => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("CapSend got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CapSend](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): CapSend => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): CapSend => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("CapShare got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CapShare](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): CapShare => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): CapShare => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("CapAlias got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CapAlias](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): CapAlias => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): CapAlias => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("CapAny got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[CapAny](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): CapAny => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): CapAny => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Aliased got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Aliased](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Aliased => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Aliased => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Ephemeral got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Ephemeral](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Ephemeral => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Ephemeral => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("At got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[At](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): At => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): At => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Question got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Question](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Question => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Question => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Ellipsis got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Ellipsis](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Ellipsis => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Ellipsis => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
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

class val Annotation is AST
  let _attachments: (Attachments | None)
  
  new val create(
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    if
      try
        let extra' = iter.next()?
        errs.push(("Annotation got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Annotation](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Annotation => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    error
  fun val attach[A: Any #share](a: A): Annotation => create((try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      error
    else this
    end
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Annotation")
    consume s

class val Semicolon is (AST & Expr)
  let _attachments: (Attachments | None)
  
  let _list: coll.Vec[Expr]
  
  new val create(
    list': (coll.Vec[Expr] | Array[Expr] val),
    attachments': (Attachments | None) = None)
  =>_attachments = attachments'
    _list = 
      match list'
      | let v: coll.Vec[Expr] => v
      | let s: Array[Expr] val => coll.Vec[Expr].concat(s.values())
      end
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    var list' = coll.Vec[Expr]
    var list_next' = try iter.next()? else None end
    while true do
      try list' = list'.push(list_next' as Expr) else break end
      try list_next' = iter.next()? else list_next' = None; break end
    end
    if list_next' isnt None then
      let extra' = list_next'
      errs.push(("Semicolon got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); error
    end
    
    _list = list'
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Semicolon](consume c, this)
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Semicolon => attach[SourcePosAny](pos')
  
  fun val size(): USize => _list.size()
  fun val apply(idx: USize): (AST | None)? =>
    var offset: USize = 0
    if idx < (0 + offset + _list.size()) then return _list(idx - (0 + offset))? end
    offset = (offset + _list.size()) - 1
    error
  fun val attach[A: Any #share](a: A): Semicolon => create(_list, (try _attachments as Attachments else Attachments end).attach[A](a))
  
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val list(): coll.Vec[Expr] => _list
  
  fun val with_list(list': (coll.Vec[Expr] | Array[Expr] val)): Semicolon => create(list', _attachments)
  
  fun val with_list_push(x: val->Expr): Semicolon => with_list(_list.push(x))
  
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? =>
    match child'
    | "list" => _list(index')?
    else error
    end
  
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST =>
    if child' is replace' then return this end
    try
      try
        let i = _list.find(child' as Expr)?
        return create(_list.update(i, replace' as Expr)?, _attachments)
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

class val Id is (AST & Expr)
  let _attachments: (Attachments | None)
  let _value: String
  new val create(value': String, attachments': (Attachments | None) = None) =>
    _value = value'
    _attachments = attachments'
  
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    _attachments = Attachments.attach[SourcePosAny](pos')
    _value =
      try
        _ASTUtil.parse_id(pos')?
      else
        errs.push(("Id failed to parse value", pos')); true
        error
      end
    
    if
      try
        let extra' = iter.next()?
        errs.push(("Id got unexpected extra field: " + extra'.string(), try (extra' as AST).pos() else SourcePosNone end)); true
      else false
      end
    then error end
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Id](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => try find_attached[SourcePosAny]()? else SourcePosNone end
  fun val with_pos(pos': SourcePosAny): Id => attach[SourcePosAny](pos')
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  fun val attach[A: Any #share](a: A): Id => create(_value, (try _attachments as Attachments else Attachments end).attach[A](a))
  fun val find_attached[A: Any #share](): A? => (_attachments as Attachments).find[A]()?
  fun val value(): String => _value
  fun val with_value(value': String): Id => create(value', _attachments)
  fun string(): String iso^ =>
    recover
      String.>append("Id(").>append(_value.string()).>push(')')
    end

class val EOF is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("EOF is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[EOF](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): EOF => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("EOF") end

class val NewLine is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("NewLine is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[NewLine](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): NewLine => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("NewLine") end

class val Use is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Use is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Use](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Use => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Use") end

class val Colon is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Colon is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Colon](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Colon => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Colon") end

class val Comma is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Comma is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Comma](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Comma => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Comma") end

class val Constant is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Constant is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Constant](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Constant => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Constant") end

class val Pipe is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Pipe is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Pipe](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Pipe => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Pipe") end

class val Ampersand is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Ampersand is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Ampersand](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Ampersand => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Ampersand") end

class val SubType is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("SubType is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[SubType](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): SubType => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("SubType") end

class val Arrow is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Arrow is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Arrow](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Arrow => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Arrow") end

class val DoubleArrow is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("DoubleArrow is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[DoubleArrow](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): DoubleArrow => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("DoubleArrow") end

class val AtLBrace is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("AtLBrace is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[AtLBrace](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): AtLBrace => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("AtLBrace") end

class val LBrace is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("LBrace is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LBrace](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LBrace => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("LBrace") end

class val RBrace is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("RBrace is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[RBrace](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): RBrace => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("RBrace") end

class val LParen is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("LParen is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LParen](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LParen => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("LParen") end

class val RParen is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("RParen is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[RParen](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): RParen => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("RParen") end

class val LSquare is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("LSquare is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LSquare](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LSquare => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("LSquare") end

class val RSquare is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("RSquare is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[RSquare](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): RSquare => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("RSquare") end

class val LParenNew is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("LParenNew is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LParenNew](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LParenNew => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("LParenNew") end

class val LBraceNew is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("LBraceNew is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LBraceNew](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LBraceNew => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("LBraceNew") end

class val LSquareNew is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("LSquareNew is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[LSquareNew](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): LSquareNew => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("LSquareNew") end

class val SubNew is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("SubNew is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[SubNew](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): SubNew => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("SubNew") end

class val SubUnsafeNew is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("SubUnsafeNew is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[SubUnsafeNew](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): SubUnsafeNew => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("SubUnsafeNew") end

class val In is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("In is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[In](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): In => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("In") end

class val Until is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Until is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Until](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Until => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Until") end

class val Do is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Do is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Do](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Do => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Do") end

class val Else is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Else is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Else](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Else => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Else") end

class val ElseIf is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("ElseIf is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[ElseIf](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): ElseIf => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("ElseIf") end

class val Then is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Then is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Then](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Then => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Then") end

class val End is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("End is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[End](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): End => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("End") end

class val Var is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Var is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Var](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Var => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Var") end

class val Let is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Let is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Let](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Let => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Let") end

class val Embed is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Embed is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Embed](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Embed => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Embed") end

class val Where is (AST & Lexeme)
  new val create() => None
  new from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])?
  =>
    errs.push(("Where is a lexeme-only type append should never be built", pos')); error
  
  fun val apply_specialised[C](c: C, fn: {[A: AST val](C, A)} val) => fn[Where](consume c, this)
  fun val get_child_dynamic(child': String, index': USize = 0): (AST | None)? => error
  fun val with_replaced_child(child': AST, replace': (AST | None)): AST => this
  fun val pos(): SourcePosAny => SourcePosNone
  fun val with_pos(pos': SourcePosAny): Where => create()
  
  fun val size(): USize => 0
  fun val apply(idx: USize): (AST | None)? => error
  
  fun val attach[A: Any #share](a: A): AST => this
  fun val find_attached[A: Any #share](): A? => error
  
  fun string(): String iso^ =>
    recover String.>append("Where") end



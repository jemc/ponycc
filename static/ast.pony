type BinaryOp is (Add | AddUnsafe | Sub | SubUnsafe | Mul | MulUnsafe | Div | DivUnsafe | Mod | ModUnsafe | LShift | LShiftUnsafe | RShift | RShiftUnsafe | Is | Isnt | Eq | NE | LT | LE | GE | GT | And | Or | XOr)

type Cap is (Iso | Trn | Ref | Val | Box | Tag)

type LitBool is (True | False)

type Type is (UnionType | IsectType | TupleType | ArrowType | FunType | LambdaType | NominalType | TypeParamRef | CtrlTypeIf | CtrlTypeCases | CtrlTypeReturn | CtrlTypeBreak | CtrlTypeContinue | CtrlTypeError | CtrlTypeCompileError | CtrlTypeCompileIntrinsic | DontCareType | ErrorType | LiteralType | OpLiteralType | ThisType)

type CtrlType is (CtrlTypeIf | CtrlTypeCases | CtrlTypeReturn | CtrlTypeBreak | CtrlTypeContinue | CtrlTypeError | CtrlTypeCompileError | CtrlTypeCompileIntrinsic)

type Field is (FieldLet | FieldVar | FieldEmbed)

type GenCap is (CapRead | CapSend | CapShare | CapAlias | CapAny)

type Local is (LocalLet | LocalVar)

type Jump is (Return | Break | Continue | Error)

type CapMod is (Aliased | Ephemeral)

type TypeDecl is (TypeAlias | Interface | Trait | Primitive | Struct | Class | Actor)

type Method is (MethodFun | MethodNew | MethodBe)

type Expr is (Return | Break | Continue | Error | Intrinsic | CompileError | LocalLet | LocalVar | MatchCapture | Infix | As | Tuple | Consume | Recover | Not | Neg | NegUnsafe | AddressOf | DigestOf | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | BinaryOp | Assign | FFICall | True | False | Id | LitFloat | LitInteger | LitString | LitLocation | This)

type UnaryOp is (Not | Neg | NegUnsafe | AddressOf | DigestOf)

class Program
  var _packages: Array[Package]
  
  new create(
    packages': Array[Package])
  =>
    _packages = packages'
  
  fun packages(): this->Array[Package] => _packages
  
  fun ref set_packages(packages': Array[Package]) => _packages = consume packages'

class Package
  var _modules: Array[Module]
  var _docs: (LitString | None)
  
  new create(
    modules': Array[Module] = Array[Module],
    docs': (LitString | None) = None)
  =>
    _modules = modules'
    _docs = docs'
  
  fun modules(): this->Array[Module] => _modules
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_modules(modules': Array[Module] = Array[Module]) => _modules = consume modules'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'

class Module
  var _use_decls: Array[Use]
  var _type_decls: Array[TypeDecl]
  var _docs: (LitString | None)
  
  new create(
    use_decls': Array[Use] = Array[Use],
    type_decls': Array[TypeDecl] = Array[TypeDecl],
    docs': (LitString | None) = None)
  =>
    _use_decls = use_decls'
    _type_decls = type_decls'
    _docs = docs'
  
  fun use_decls(): this->Array[Use] => _use_decls
  fun type_decls(): this->Array[TypeDecl] => _type_decls
  fun docs(): this->(LitString | None) => _docs
  
  fun ref set_use_decls(use_decls': Array[Use] = Array[Use]) => _use_decls = consume use_decls'
  fun ref set_type_decls(type_decls': Array[TypeDecl] = Array[TypeDecl]) => _type_decls = consume type_decls'
  fun ref set_docs(docs': (LitString | None) = None) => _docs = consume docs'

class Use
  var _prefix: (Id | None)
  var _body: (FFIDecl | String)
  var _guard: (Expr | IfDefCond | None)
  
  new create(
    prefix': (Id | None) = None,
    body': (FFIDecl | String),
    guard': (Expr | IfDefCond | None) = None)
  =>
    _prefix = prefix'
    _body = body'
    _guard = guard'
  
  fun prefix(): this->(Id | None) => _prefix
  fun body(): this->(FFIDecl | String) => _body
  fun guard(): this->(Expr | IfDefCond | None) => _guard
  
  fun ref set_prefix(prefix': (Id | None) = None) => _prefix = consume prefix'
  fun ref set_body(body': (FFIDecl | String)) => _body = consume body'
  fun ref set_guard(guard': (Expr | IfDefCond | None) = None) => _guard = consume guard'

class FFIDecl
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

class TypeAlias
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

class Interface
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

class Trait
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

class Primitive
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

class Struct
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

class Class
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

class Actor
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

class Provides
  var _types: Array[Type]
  
  new create(
    types': Array[Type] = Array[Type])
  =>
    _types = types'
  
  fun types(): this->Array[Type] => _types
  
  fun ref set_types(types': Array[Type] = Array[Type]) => _types = consume types'

class Members
  var _fields: Array[Field]
  var _methods: Array[Method]
  
  new create(
    fields': Array[Field] = Array[Field],
    methods': Array[Method] = Array[Method])
  =>
    _fields = fields'
    _methods = methods'
  
  fun fields(): this->Array[Field] => _fields
  fun methods(): this->Array[Method] => _methods
  
  fun ref set_fields(fields': Array[Field] = Array[Field]) => _fields = consume fields'
  fun ref set_methods(methods': Array[Method] = Array[Method]) => _methods = consume methods'

class FieldLet
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
  
  fun name(): this->Id => _name
  fun field_type(): this->(Type | None) => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': (Type | None) = None) => _field_type = consume field_type'
  fun ref set_default(default': (Expr | None) = None) => _default = consume default'

class FieldVar
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
  
  fun name(): this->Id => _name
  fun field_type(): this->(Type | None) => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': (Type | None) = None) => _field_type = consume field_type'
  fun ref set_default(default': (Expr | None) = None) => _default = consume default'

class FieldEmbed
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
  
  fun name(): this->Id => _name
  fun field_type(): this->(Type | None) => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': (Type | None) = None) => _field_type = consume field_type'
  fun ref set_default(default': (Expr | None) = None) => _default = consume default'

class MethodFun
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

class MethodNew
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

class MethodBe
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

class TypeParams
  var _list: Array[TypeParam]
  
  new create(
    list': Array[TypeParam] = Array[TypeParam])
  =>
    _list = list'
  
  fun list(): this->Array[TypeParam] => _list
  
  fun ref set_list(list': Array[TypeParam] = Array[TypeParam]) => _list = consume list'

class TypeParam
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
  
  fun name(): this->Id => _name
  fun constraint(): this->(Type | None) => _constraint
  fun default(): this->(Type | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_constraint(constraint': (Type | None)) => _constraint = consume constraint'
  fun ref set_default(default': (Type | None)) => _default = consume default'

class TypeArgs
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'

class Params
  var _param: Array[Param]
  var _ellipsis: (Ellipsis | None)
  
  new create(
    param': Array[Param] = Array[Param],
    ellipsis': (Ellipsis | None) = None)
  =>
    _param = param'
    _ellipsis = ellipsis'
  
  fun param(): this->Array[Param] => _param
  fun ellipsis(): this->(Ellipsis | None) => _ellipsis
  
  fun ref set_param(param': Array[Param] = Array[Param]) => _param = consume param'
  fun ref set_ellipsis(ellipsis': (Ellipsis | None) = None) => _ellipsis = consume ellipsis'

class Param
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
  
  fun name(): this->Id => _name
  fun param_type(): this->(Type | None) => _param_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_param_type(param_type': (Type | None) = None) => _param_type = consume param_type'
  fun ref set_default(default': (Expr | None) = None) => _default = consume default'

class ExprSeq
  var _list: Array[Expr]
  
  new create(
    list': Array[Expr] = Array[Expr])
  =>
    _list = list'
  
  fun list(): this->Array[Expr] => _list
  
  fun ref set_list(list': Array[Expr] = Array[Expr]) => _list = consume list'

class RawExprSeq
  var _list: Array[Expr]
  
  new create(
    list': Array[Expr] = Array[Expr])
  =>
    _list = list'
  
  fun list(): this->Array[Expr] => _list
  
  fun ref set_list(list': Array[Expr] = Array[Expr]) => _list = consume list'

class Return // TODO
  new create() => None

class Break // TODO
  new create() => None

class Continue // TODO
  new create() => None

class Error // TODO
  new create() => None

class Intrinsic // TODO
  new create() => None

class CompileError // TODO
  new create() => None

class LocalLet
  var _name: Id
  var _local_type: (Type | None)
  
  new create(
    name': Id,
    local_type': (Type | None))
  =>
    _name = name'
    _local_type = local_type'
  
  fun name(): this->Id => _name
  fun local_type(): this->(Type | None) => _local_type
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_local_type(local_type': (Type | None)) => _local_type = consume local_type'

class LocalVar
  var _name: Id
  var _local_type: (Type | None)
  
  new create(
    name': Id,
    local_type': (Type | None))
  =>
    _name = name'
    _local_type = local_type'
  
  fun name(): this->Id => _name
  fun local_type(): this->(Type | None) => _local_type
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_local_type(local_type': (Type | None)) => _local_type = consume local_type'

class MatchCapture
  var _name: Id
  var _match_type: Type
  
  new create(
    name': Id,
    match_type': Type)
  =>
    _name = name'
    _match_type = match_type'
  
  fun name(): this->Id => _name
  fun match_type(): this->Type => _match_type
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_match_type(match_type': Type) => _match_type = consume match_type'

class Infix // TODO
  new create() => None

class As
  var _expr: Expr
  var _as_type: Type
  
  new create(
    expr': Expr,
    as_type': Type)
  =>
    _expr = expr'
    _as_type = as_type'
  
  fun expr(): this->Expr => _expr
  fun as_type(): this->Type => _as_type
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  fun ref set_as_type(as_type': Type) => _as_type = consume as_type'

class Tuple
  var _elements: Array[RawExprSeq]
  
  new create(
    elements': Array[RawExprSeq] = Array[RawExprSeq])
  =>
    _elements = elements'
  
  fun elements(): this->Array[RawExprSeq] => _elements
  
  fun ref set_elements(elements': Array[RawExprSeq] = Array[RawExprSeq]) => _elements = consume elements'

class Consume
  var _cap: (Cap | Aliased | None)
  var _expr: Expr
  
  new create(
    cap': (Cap | Aliased | None),
    expr': Expr)
  =>
    _cap = cap'
    _expr = expr'
  
  fun cap(): this->(Cap | Aliased | None) => _cap
  fun expr(): this->Expr => _expr
  
  fun ref set_cap(cap': (Cap | Aliased | None)) => _cap = consume cap'
  fun ref set_expr(expr': Expr) => _expr = consume expr'

class Recover
  var _cap: (Cap | None)
  var _block: Expr
  
  new create(
    cap': (Cap | None),
    block': Expr)
  =>
    _cap = cap'
    _block = block'
  
  fun cap(): this->(Cap | None) => _cap
  fun block(): this->Expr => _block
  
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_block(block': Expr) => _block = consume block'

class Not
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'

class Neg
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'

class NegUnsafe
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'

class AddressOf
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'

class DigestOf
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'

class Add
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class AddUnsafe
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class Sub
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class SubUnsafe
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class Mul
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class MulUnsafe
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class Div
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class DivUnsafe
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class Mod
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class ModUnsafe
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class LShift
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class LShiftUnsafe
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class RShift
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class RShiftUnsafe
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class Is
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class Isnt
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class Eq
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class NE
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class LT
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class LE
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class GE
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class GT
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class And
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class Or
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class XOr
  var _left: Expr
  var _right: Expr
  
  new create(
    left': Expr,
    right': Expr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Expr => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Expr) => _right = consume right'

class Assign
  var _right: Expr
  var _left: Expr
  
  new create(
    right': Expr,
    left': Expr)
  =>
    _right = right'
    _left = left'
  
  fun right(): this->Expr => _right
  fun left(): this->Expr => _left
  
  fun ref set_right(right': Expr) => _right = consume right'
  fun ref set_left(left': Expr) => _left = consume left'

class FFICall
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

class Args
  var _list: Array[RawExprSeq]
  
  new create(
    list': Array[RawExprSeq] = Array[RawExprSeq])
  =>
    _list = list'
  
  fun list(): this->Array[RawExprSeq] => _list
  
  fun ref set_list(list': Array[RawExprSeq] = Array[RawExprSeq]) => _list = consume list'

class NamedArgs
  var _list: Array[NamedArg]
  
  new create(
    list': Array[NamedArg] = Array[NamedArg])
  =>
    _list = list'
  
  fun list(): this->Array[NamedArg] => _list
  
  fun ref set_list(list': Array[NamedArg] = Array[NamedArg]) => _list = consume list'

class NamedArg
  var _name: Id
  var _value: RawExprSeq
  
  new create(
    name': Id,
    value': RawExprSeq)
  =>
    _name = name'
    _value = value'
  
  fun name(): this->Id => _name
  fun value(): this->RawExprSeq => _value
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_value(value': RawExprSeq) => _value = consume value'

class IfDefCond // TODO
  new create() => None

class IfDefInfix
  var _left: IfDefCond
  var _right: IfDefCond
  
  new create(
    left': IfDefCond,
    right': IfDefCond)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->IfDefCond => _left
  fun right(): this->IfDefCond => _right
  
  fun ref set_left(left': IfDefCond) => _left = consume left'
  fun ref set_right(right': IfDefCond) => _right = consume right'

class IfDefNot
  var _expr: IfDefCond
  
  new create(
    expr': IfDefCond)
  =>
    _expr = expr'
  
  fun expr(): this->IfDefCond => _expr
  
  fun ref set_expr(expr': IfDefCond) => _expr = consume expr'

class IfDefFlag
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'

class UnionType
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'

class IsectType
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'

class TupleType
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'

class ArrowType
  var _left: Type
  var _right: Type
  
  new create(
    left': Type,
    right': Type)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Type => _left
  fun right(): this->Type => _right
  
  fun ref set_left(left': Type) => _left = consume left'
  fun ref set_right(right': Type) => _right = consume right'

class FunType
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
  
  fun cap(): this->Cap => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun return_type(): this->(Type | None) => _return_type
  
  fun ref set_cap(cap': Cap) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'

class LambdaType
  var _method_cap: (Cap | None)
  var _name: (Id | None)
  var _type_params: (TypeParams | None)
  var _params: (TypeList | None)
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _object_cap: (Cap | GenCap | None)
  var _cap_mod: (CapMod | None)
  
  new create(
    method_cap': (Cap | None) = None,
    name': (Id | None) = None,
    type_params': (TypeParams | None) = None,
    params': (TypeList | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    object_cap': (Cap | GenCap | None) = None,
    cap_mod': (CapMod | None) = None)
  =>
    _method_cap = method_cap'
    _name = name'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
    _partial = partial'
    _object_cap = object_cap'
    _cap_mod = cap_mod'
  
  fun method_cap(): this->(Cap | None) => _method_cap
  fun name(): this->(Id | None) => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(TypeList | None) => _params
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun object_cap(): this->(Cap | GenCap | None) => _object_cap
  fun cap_mod(): this->(CapMod | None) => _cap_mod
  
  fun ref set_method_cap(method_cap': (Cap | None) = None) => _method_cap = consume method_cap'
  fun ref set_name(name': (Id | None) = None) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (TypeList | None) = None) => _params = consume params'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_object_cap(object_cap': (Cap | GenCap | None) = None) => _object_cap = consume object_cap'
  fun ref set_cap_mod(cap_mod': (CapMod | None) = None) => _cap_mod = consume cap_mod'

class TypeList
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
  fun list(): this->Array[Type] => _list
  
  fun ref set_list(list': Array[Type] = Array[Type]) => _list = consume list'

class NominalType
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

class TypeParamRef
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
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | GenCap | None) => _cap
  fun cap_mod(): this->(CapMod | None) => _cap_mod
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | GenCap | None) = None) => _cap = consume cap'
  fun ref set_cap_mod(cap_mod': (CapMod | None) = None) => _cap_mod = consume cap_mod'

class At
  new create() => None

class True
  new create() => None

class False
  new create() => None

class Iso
  new create() => None

class Trn
  new create() => None

class Ref
  new create() => None

class Val
  new create() => None

class Box
  new create() => None

class Tag
  new create() => None

class Aliased
  new create() => None

class Ephemeral
  new create() => None

class CtrlTypeIf
  new create() => None

class CtrlTypeCases
  new create() => None

class CtrlTypeReturn
  new create() => None

class CtrlTypeBreak
  new create() => None

class CtrlTypeContinue
  new create() => None

class CtrlTypeError
  new create() => None

class CtrlTypeCompileError
  new create() => None

class CtrlTypeCompileIntrinsic
  new create() => None

class DontCareType
  new create() => None

class Ellipsis
  new create() => None

class ErrorType
  new create() => None

class CapRead
  new create() => None

class CapSend
  new create() => None

class CapShare
  new create() => None

class CapAlias
  new create() => None

class CapAny
  new create() => None

class Id
  var _value: String
  new create(value': String) => _value = value'
  fun value(): String => _value
  fun ref set_value(value': String) => _value = value'

class LitFloat
  var _value: F64
  new create(value': F64) => _value = value'
  fun value(): F64 => _value
  fun ref set_value(value': F64) => _value = value'

class LitInteger
  var _value: I128
  new create(value': I128) => _value = value'
  fun value(): I128 => _value
  fun ref set_value(value': I128) => _value = value'

class LitString
  var _value: String
  new create(value': String) => _value = value'
  fun value(): String => _value
  fun ref set_value(value': String) => _value = value'

class LitLocation // TODO
  new create() => None

class LiteralType // TODO
  new create() => None

class LiteralTypeBranch // TODO
  new create() => None

class OpLiteralType // TODO
  new create() => None

class Question
  new create() => None

class This
  new create() => None

class ThisType
  new create() => None



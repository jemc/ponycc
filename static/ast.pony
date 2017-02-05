type Cap is (Iso | Trn | Ref | Val | Box | Tag)

type LitBool is (True | False)

type Type is (TypeAlias | Interface | Trait | Primitive | Struct | Class | Actor)

type CtrlType is (CtrlTypeIf | CtrlTypeCases | CtrlTypeReturn | CtrlTypeBreak | CtrlTypeContinue | CtrlTypeError | CtrlTypeCompileError | CtrlTypeCompileIntrinsic)

type Field is (FieldLet | FieldVar | FieldEmbed)

type GenCap is (CapRead | CapSend | CapShare | CapAlias | CapAny)

type Local is (LocalLet | LocalVar)

type MethodRef is (MethodFunRef | MethodNewRef | MethodBeRef)

type CapMod is (Aliased | Ephemeral)

type UnaryOperator is (Not | UMinus | UMinusUnsafe | AddressOf | DigestOf)

type Method is (MethodFun | MethodNew | MethodBe)

type FieldRef is (FieldLetRef | FieldVarRef | FieldEmbedRef)

type LocalRef is (LocalLetRef | LocalVarRef | ParamRef)

class Program // TODO
  new create() => None

class Package // TODO
  new create() => None

class Module // TODO
  new create() => None

class Use
  var _prefix: (Id | None)
  var _body: (FFIDecl | None)
  var _guard: (Expr | IfDefCond | None)
  
  new create(
    prefix': (Id | None),
    body': (FFIDecl | None),
    guard': (Expr | IfDefCond | None))
  =>
    _prefix = prefix'
    _body = body'
    _guard = guard'
  
  fun prefix(): this->(Id | None) => _prefix
  fun body(): this->(FFIDecl | None) => _body
  fun guard(): this->(Expr | IfDefCond | None) => _guard
  
  fun ref set_prefix(prefix': (Id | None)) => _prefix = consume prefix'
  fun ref set_body(body': (FFIDecl | None)) => _body = consume body'
  fun ref set_guard(guard': (Expr | IfDefCond | None)) => _guard = consume guard'

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
    type_params': (TypeParams | None),
    cap': (Cap | None),
    provides': (Provides | None),
    members': (Members | None),
    at': (At | None),
    docs': (LitString | None))
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
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None)) => _provides = consume provides'
  fun ref set_members(members': (Members | None)) => _members = consume members'
  fun ref set_at(at': (At | None)) => _at = consume at'
  fun ref set_docs(docs': (LitString | None)) => _docs = consume docs'

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
    type_params': (TypeParams | None),
    cap': (Cap | None),
    provides': (Provides | None),
    members': (Members | None),
    at': (At | None),
    docs': (LitString | None))
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
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None)) => _provides = consume provides'
  fun ref set_members(members': (Members | None)) => _members = consume members'
  fun ref set_at(at': (At | None)) => _at = consume at'
  fun ref set_docs(docs': (LitString | None)) => _docs = consume docs'

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
    type_params': (TypeParams | None),
    cap': (Cap | None),
    provides': (Provides | None),
    members': (Members | None),
    at': (At | None),
    docs': (LitString | None))
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
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None)) => _provides = consume provides'
  fun ref set_members(members': (Members | None)) => _members = consume members'
  fun ref set_at(at': (At | None)) => _at = consume at'
  fun ref set_docs(docs': (LitString | None)) => _docs = consume docs'

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
    type_params': (TypeParams | None),
    cap': (Cap | None),
    provides': (Provides | None),
    members': (Members | None),
    at': (At | None),
    docs': (LitString | None))
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
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None)) => _provides = consume provides'
  fun ref set_members(members': (Members | None)) => _members = consume members'
  fun ref set_at(at': (At | None)) => _at = consume at'
  fun ref set_docs(docs': (LitString | None)) => _docs = consume docs'

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
    type_params': (TypeParams | None),
    cap': (Cap | None),
    provides': (Provides | None),
    members': (Members | None),
    at': (At | None),
    docs': (LitString | None))
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
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None)) => _provides = consume provides'
  fun ref set_members(members': (Members | None)) => _members = consume members'
  fun ref set_at(at': (At | None)) => _at = consume at'
  fun ref set_docs(docs': (LitString | None)) => _docs = consume docs'

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
    type_params': (TypeParams | None),
    cap': (Cap | None),
    provides': (Provides | None),
    members': (Members | None),
    at': (At | None),
    docs': (LitString | None))
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
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None)) => _provides = consume provides'
  fun ref set_members(members': (Members | None)) => _members = consume members'
  fun ref set_at(at': (At | None)) => _at = consume at'
  fun ref set_docs(docs': (LitString | None)) => _docs = consume docs'

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
    type_params': (TypeParams | None),
    cap': (Cap | None),
    provides': (Provides | None),
    members': (Members | None),
    at': (At | None),
    docs': (LitString | None))
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
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None)) => _provides = consume provides'
  fun ref set_members(members': (Members | None)) => _members = consume members'
  fun ref set_at(at': (At | None)) => _at = consume at'
  fun ref set_docs(docs': (LitString | None)) => _docs = consume docs'

class Provides // TODO
  new create() => None

class Members // TODO
  new create() => None

class FieldLet
  var _name: Id
  var _field_type: (TypePtr | None)
  var _default: (Expr | None)
  
  new create(
    name': Id,
    field_type': (TypePtr | None),
    default': (Expr | None))
  =>
    _name = name'
    _field_type = field_type'
    _default = default'
  
  fun name(): this->Id => _name
  fun field_type(): this->(TypePtr | None) => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': (TypePtr | None)) => _field_type = consume field_type'
  fun ref set_default(default': (Expr | None)) => _default = consume default'

class FieldVar
  var _name: Id
  var _field_type: (TypePtr | None)
  var _default: (Expr | None)
  
  new create(
    name': Id,
    field_type': (TypePtr | None),
    default': (Expr | None))
  =>
    _name = name'
    _field_type = field_type'
    _default = default'
  
  fun name(): this->Id => _name
  fun field_type(): this->(TypePtr | None) => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': (TypePtr | None)) => _field_type = consume field_type'
  fun ref set_default(default': (Expr | None)) => _default = consume default'

class FieldEmbed
  var _name: Id
  var _field_type: (TypePtr | None)
  var _default: (Expr | None)
  
  new create(
    name': Id,
    field_type': (TypePtr | None),
    default': (Expr | None))
  =>
    _name = name'
    _field_type = field_type'
    _default = default'
  
  fun name(): this->Id => _name
  fun field_type(): this->(TypePtr | None) => _field_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_field_type(field_type': (TypePtr | None)) => _field_type = consume field_type'
  fun ref set_default(default': (Expr | None)) => _default = consume default'

class MethodFun
  var _cap: (Cap | None)
  var _name: Id
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (TypePtr | None)
  var _partial: (Question | None)
  var _body: (RawExprSeq | None)
  var _docs: (LitString | None)
  var _guard: (RawExprSeq | None)
  
  new create(
    cap': (Cap | None),
    name': Id,
    type_params': (TypeParams | None),
    params': (Params | None),
    return_type': (TypePtr | None),
    partial': (Question | None),
    body': (RawExprSeq | None),
    docs': (LitString | None),
    guard': (RawExprSeq | None))
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
  fun return_type(): this->(TypePtr | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun body(): this->(RawExprSeq | None) => _body
  fun docs(): this->(LitString | None) => _docs
  fun guard(): this->(RawExprSeq | None) => _guard
  
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None)) => _params = consume params'
  fun ref set_return_type(return_type': (TypePtr | None)) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None)) => _partial = consume partial'
  fun ref set_body(body': (RawExprSeq | None)) => _body = consume body'
  fun ref set_docs(docs': (LitString | None)) => _docs = consume docs'
  fun ref set_guard(guard': (RawExprSeq | None)) => _guard = consume guard'

class MethodNew
  var _cap: (Cap | None)
  var _name: Id
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (TypePtr | None)
  var _partial: (Question | None)
  var _body: (RawExprSeq | None)
  var _docs: (LitString | None)
  var _guard: (RawExprSeq | None)
  
  new create(
    cap': (Cap | None),
    name': Id,
    type_params': (TypeParams | None),
    params': (Params | None),
    return_type': (TypePtr | None),
    partial': (Question | None),
    body': (RawExprSeq | None),
    docs': (LitString | None),
    guard': (RawExprSeq | None))
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
  fun return_type(): this->(TypePtr | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun body(): this->(RawExprSeq | None) => _body
  fun docs(): this->(LitString | None) => _docs
  fun guard(): this->(RawExprSeq | None) => _guard
  
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None)) => _params = consume params'
  fun ref set_return_type(return_type': (TypePtr | None)) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None)) => _partial = consume partial'
  fun ref set_body(body': (RawExprSeq | None)) => _body = consume body'
  fun ref set_docs(docs': (LitString | None)) => _docs = consume docs'
  fun ref set_guard(guard': (RawExprSeq | None)) => _guard = consume guard'

class MethodBe
  var _cap: (Cap | None)
  var _name: Id
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (TypePtr | None)
  var _partial: (Question | None)
  var _body: (RawExprSeq | None)
  var _docs: (LitString | None)
  var _guard: (RawExprSeq | None)
  
  new create(
    cap': (Cap | None),
    name': Id,
    type_params': (TypeParams | None),
    params': (Params | None),
    return_type': (TypePtr | None),
    partial': (Question | None),
    body': (RawExprSeq | None),
    docs': (LitString | None),
    guard': (RawExprSeq | None))
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
  fun return_type(): this->(TypePtr | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun body(): this->(RawExprSeq | None) => _body
  fun docs(): this->(LitString | None) => _docs
  fun guard(): this->(RawExprSeq | None) => _guard
  
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None)) => _params = consume params'
  fun ref set_return_type(return_type': (TypePtr | None)) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None)) => _partial = consume partial'
  fun ref set_body(body': (RawExprSeq | None)) => _body = consume body'
  fun ref set_docs(docs': (LitString | None)) => _docs = consume docs'
  fun ref set_guard(guard': (RawExprSeq | None)) => _guard = consume guard'

class TypeParams // TODO
  new create() => None

class TypeParam
  var _name: Id
  var _constraint: (TypePtr | None)
  var _default: (TypePtr | None)
  
  new create(
    name': Id,
    constraint': (TypePtr | None),
    default': (TypePtr | None))
  =>
    _name = name'
    _constraint = constraint'
    _default = default'
  
  fun name(): this->Id => _name
  fun constraint(): this->(TypePtr | None) => _constraint
  fun default(): this->(TypePtr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_constraint(constraint': (TypePtr | None)) => _constraint = consume constraint'
  fun ref set_default(default': (TypePtr | None)) => _default = consume default'

class TypeArgs // TODO
  new create() => None

class Params // TODO
  new create() => None

class Param
  var _name: Id
  var _param_type: (TypePtr | None)
  var _default: (Expr | None)
  
  new create(
    name': Id,
    param_type': (TypePtr | None),
    default': (Expr | None))
  =>
    _name = name'
    _param_type = param_type'
    _default = default'
  
  fun name(): this->Id => _name
  fun param_type(): this->(TypePtr | None) => _param_type
  fun default(): this->(Expr | None) => _default
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_param_type(param_type': (TypePtr | None)) => _param_type = consume param_type'
  fun ref set_default(default': (Expr | None)) => _default = consume default'

class ExprSeq // TODO
  new create() => None

class RawExprSeq // TODO
  new create() => None

class Return // TODO
  new create() => None

class Break // TODO
  new create() => None

class Continue // TODO
  new create() => None

class Error // TODO
  new create() => None

class CompileError // TODO
  new create() => None

class Expr // TODO
  new create() => None

class LocalLet
  var _name: Id
  var _local_type: (TypePtr | None)
  
  new create(
    name': Id,
    local_type': (TypePtr | None))
  =>
    _name = name'
    _local_type = local_type'
  
  fun name(): this->Id => _name
  fun local_type(): this->(TypePtr | None) => _local_type
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_local_type(local_type': (TypePtr | None)) => _local_type = consume local_type'

class LocalVar
  var _name: Id
  var _local_type: (TypePtr | None)
  
  new create(
    name': Id,
    local_type': (TypePtr | None))
  =>
    _name = name'
    _local_type = local_type'
  
  fun name(): this->Id => _name
  fun local_type(): this->(TypePtr | None) => _local_type
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_local_type(local_type': (TypePtr | None)) => _local_type = consume local_type'

class MatchCapture
  var _name: Id
  var _match_type: TypePtr
  
  new create(
    name': Id,
    match_type': TypePtr)
  =>
    _name = name'
    _match_type = match_type'
  
  fun name(): this->Id => _name
  fun match_type(): this->TypePtr => _match_type
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_match_type(match_type': TypePtr) => _match_type = consume match_type'

class Infix // TODO
  new create() => None

class As
  var _expr: Expr
  var _as_type: TypePtr
  
  new create(
    expr': Expr,
    as_type': TypePtr)
  =>
    _expr = expr'
    _as_type = as_type'
  
  fun expr(): this->Expr => _expr
  fun as_type(): this->TypePtr => _as_type
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  fun ref set_as_type(as_type': TypePtr) => _as_type = consume as_type'

class Tuple // TODO
  new create() => None

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

class UMinus
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'

class UMinusUnsafe
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

class Dot
  var _left: Expr
  var _right: (Id | LitInteger | TypeArgs)
  
  new create(
    left': Expr,
    right': (Id | LitInteger | TypeArgs))
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->(Id | LitInteger | TypeArgs) => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': (Id | LitInteger | TypeArgs)) => _right = consume right'

class Tilde
  var _left: Expr
  var _right: Id
  
  new create(
    left': Expr,
    right': Id)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->Id => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': Id) => _right = consume right'

class Qualify
  var _left: Expr
  var _right: TypeArgs
  
  new create(
    left': Expr,
    right': TypeArgs)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->Expr => _left
  fun right(): this->TypeArgs => _right
  
  fun ref set_left(left': Expr) => _left = consume left'
  fun ref set_right(right': TypeArgs) => _right = consume right'

class Call
  var _args: (Args | None)
  var _named_args: (NamedArgs | None)
  var _receiver: Expr
  
  new create(
    args': (Args | None),
    named_args': (NamedArgs | None),
    receiver': Expr)
  =>
    _args = args'
    _named_args = named_args'
    _receiver = receiver'
  
  fun args(): this->(Args | None) => _args
  fun named_args(): this->(NamedArgs | None) => _named_args
  fun receiver(): this->Expr => _receiver
  
  fun ref set_args(args': (Args | None)) => _args = consume args'
  fun ref set_named_args(named_args': (NamedArgs | None)) => _named_args = consume named_args'
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'

class FFICall
  var _name: (Id | LitString)
  var _type_args: (TypeArgs | None)
  var _args: (Args | None)
  var _named_args: (NamedArgs | None)
  var _partial: (Question | None)
  
  new create(
    name': (Id | LitString),
    type_args': (TypeArgs | None),
    args': (Args | None),
    named_args': (NamedArgs | None),
    partial': (Question | None))
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
  fun ref set_type_args(type_args': (TypeArgs | None)) => _type_args = consume type_args'
  fun ref set_args(args': (Args | None)) => _args = consume args'
  fun ref set_named_args(named_args': (NamedArgs | None)) => _named_args = consume named_args'
  fun ref set_partial(partial': (Question | None)) => _partial = consume partial'

class Args // TODO
  new create() => None

class NamedArgs // TODO
  new create() => None

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

class IfDef
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
  
  fun then_expr(): this->(Expr | IfDefCond) => _then_expr
  fun then_body(): this->ExprSeq => _then_body
  fun else_body(): this->(Expr | IfDef | None) => _else_body
  fun else_expr(): this->(None | IfDefCond) => _else_expr
  
  fun ref set_then_expr(then_expr': (Expr | IfDefCond)) => _then_expr = consume then_expr'
  fun ref set_then_body(then_body': ExprSeq) => _then_body = consume then_body'
  fun ref set_else_body(else_body': (Expr | IfDef | None)) => _else_body = consume else_body'
  fun ref set_else_expr(else_expr': (None | IfDefCond)) => _else_expr = consume else_expr'

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

class If
  var _condition: RawExprSeq
  var _then_body: ExprSeq
  var _else_body: (ExprSeq | If | None)
  
  new create(
    condition': RawExprSeq,
    then_body': ExprSeq,
    else_body': (ExprSeq | If | None))
  =>
    _condition = condition'
    _then_body = then_body'
    _else_body = else_body'
  
  fun condition(): this->RawExprSeq => _condition
  fun then_body(): this->ExprSeq => _then_body
  fun else_body(): this->(ExprSeq | If | None) => _else_body
  
  fun ref set_condition(condition': RawExprSeq) => _condition = consume condition'
  fun ref set_then_body(then_body': ExprSeq) => _then_body = consume then_body'
  fun ref set_else_body(else_body': (ExprSeq | If | None)) => _else_body = consume else_body'

class While
  var _condition: RawExprSeq
  var _loop_body: ExprSeq
  var _else_body: (ExprSeq | None)
  
  new create(
    condition': RawExprSeq,
    loop_body': ExprSeq,
    else_body': (ExprSeq | None))
  =>
    _condition = condition'
    _loop_body = loop_body'
    _else_body = else_body'
  
  fun condition(): this->RawExprSeq => _condition
  fun loop_body(): this->ExprSeq => _loop_body
  fun else_body(): this->(ExprSeq | None) => _else_body
  
  fun ref set_condition(condition': RawExprSeq) => _condition = consume condition'
  fun ref set_loop_body(loop_body': ExprSeq) => _loop_body = consume loop_body'
  fun ref set_else_body(else_body': (ExprSeq | None)) => _else_body = consume else_body'

class Repeat
  var _loop_body: ExprSeq
  var _condition: RawExprSeq
  var _else_body: (ExprSeq | None)
  
  new create(
    loop_body': ExprSeq,
    condition': RawExprSeq,
    else_body': (ExprSeq | None))
  =>
    _loop_body = loop_body'
    _condition = condition'
    _else_body = else_body'
  
  fun loop_body(): this->ExprSeq => _loop_body
  fun condition(): this->RawExprSeq => _condition
  fun else_body(): this->(ExprSeq | None) => _else_body
  
  fun ref set_loop_body(loop_body': ExprSeq) => _loop_body = consume loop_body'
  fun ref set_condition(condition': RawExprSeq) => _condition = consume condition'
  fun ref set_else_body(else_body': (ExprSeq | None)) => _else_body = consume else_body'

class For
  var _expr: ExprSeq
  var _iterator: RawExprSeq
  var _loop_body: RawExprSeq
  var _else_body: (ExprSeq | None)
  
  new create(
    expr': ExprSeq,
    iterator': RawExprSeq,
    loop_body': RawExprSeq,
    else_body': (ExprSeq | None))
  =>
    _expr = expr'
    _iterator = iterator'
    _loop_body = loop_body'
    _else_body = else_body'
  
  fun expr(): this->ExprSeq => _expr
  fun iterator(): this->RawExprSeq => _iterator
  fun loop_body(): this->RawExprSeq => _loop_body
  fun else_body(): this->(ExprSeq | None) => _else_body
  
  fun ref set_expr(expr': ExprSeq) => _expr = consume expr'
  fun ref set_iterator(iterator': RawExprSeq) => _iterator = consume iterator'
  fun ref set_loop_body(loop_body': RawExprSeq) => _loop_body = consume loop_body'
  fun ref set_else_body(else_body': (ExprSeq | None)) => _else_body = consume else_body'

class With
  var _refs: Expr
  var _with_body: RawExprSeq
  var _else_body: (RawExprSeq | None)
  
  new create(
    refs': Expr,
    with_body': RawExprSeq,
    else_body': (RawExprSeq | None))
  =>
    _refs = refs'
    _with_body = with_body'
    _else_body = else_body'
  
  fun refs(): this->Expr => _refs
  fun with_body(): this->RawExprSeq => _with_body
  fun else_body(): this->(RawExprSeq | None) => _else_body
  
  fun ref set_refs(refs': Expr) => _refs = consume refs'
  fun ref set_with_body(with_body': RawExprSeq) => _with_body = consume with_body'
  fun ref set_else_body(else_body': (RawExprSeq | None)) => _else_body = consume else_body'

class Match
  var _expr: RawExprSeq
  var _cases: (Cases | None)
  var _else_body: (ExprSeq | None)
  
  new create(
    expr': RawExprSeq,
    cases': (Cases | None),
    else_body': (ExprSeq | None))
  =>
    _expr = expr'
    _cases = cases'
    _else_body = else_body'
  
  fun expr(): this->RawExprSeq => _expr
  fun cases(): this->(Cases | None) => _cases
  fun else_body(): this->(ExprSeq | None) => _else_body
  
  fun ref set_expr(expr': RawExprSeq) => _expr = consume expr'
  fun ref set_cases(cases': (Cases | None)) => _cases = consume cases'
  fun ref set_else_body(else_body': (ExprSeq | None)) => _else_body = consume else_body'

class Cases // TODO
  new create() => None

class Case
  var _expr: (Expr | None)
  var _guard: (RawExprSeq | None)
  var _body: (RawExprSeq | None)
  
  new create(
    expr': (Expr | None),
    guard': (RawExprSeq | None),
    body': (RawExprSeq | None))
  =>
    _expr = expr'
    _guard = guard'
    _body = body'
  
  fun expr(): this->(Expr | None) => _expr
  fun guard(): this->(RawExprSeq | None) => _guard
  fun body(): this->(RawExprSeq | None) => _body
  
  fun ref set_expr(expr': (Expr | None)) => _expr = consume expr'
  fun ref set_guard(guard': (RawExprSeq | None)) => _guard = consume guard'
  fun ref set_body(body': (RawExprSeq | None)) => _body = consume body'

class Try
  var _body: ExprSeq
  var _else_body: (ExprSeq | None)
  var _then_body: (ExprSeq | None)
  
  new create(
    body': ExprSeq,
    else_body': (ExprSeq | None),
    then_body': (ExprSeq | None))
  =>
    _body = body'
    _else_body = else_body'
    _then_body = then_body'
  
  fun body(): this->ExprSeq => _body
  fun else_body(): this->(ExprSeq | None) => _else_body
  fun then_body(): this->(ExprSeq | None) => _then_body
  
  fun ref set_body(body': ExprSeq) => _body = consume body'
  fun ref set_else_body(else_body': (ExprSeq | None)) => _else_body = consume else_body'
  fun ref set_then_body(then_body': (ExprSeq | None)) => _then_body = consume then_body'

class Lambda
  var _method_cap: (Cap | None)
  var _name: (Id | None)
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _captures: (LambdaCaptures | None)
  var _return_type: (TypePtr | None)
  var _partial: (Question | None)
  var _body: (RawExprSeq)
  var _object_cap: (Cap | None | Question)
  
  new create(
    method_cap': (Cap | None),
    name': (Id | None),
    type_params': (TypeParams | None),
    params': (Params | None),
    captures': (LambdaCaptures | None),
    return_type': (TypePtr | None),
    partial': (Question | None),
    body': (RawExprSeq),
    object_cap': (Cap | None | Question))
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
  
  fun method_cap(): this->(Cap | None) => _method_cap
  fun name(): this->(Id | None) => _name
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun captures(): this->(LambdaCaptures | None) => _captures
  fun return_type(): this->(TypePtr | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun body(): this->(RawExprSeq) => _body
  fun object_cap(): this->(Cap | None | Question) => _object_cap
  
  fun ref set_method_cap(method_cap': (Cap | None)) => _method_cap = consume method_cap'
  fun ref set_name(name': (Id | None)) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None)) => _params = consume params'
  fun ref set_captures(captures': (LambdaCaptures | None)) => _captures = consume captures'
  fun ref set_return_type(return_type': (TypePtr | None)) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None)) => _partial = consume partial'
  fun ref set_body(body': (RawExprSeq)) => _body = consume body'
  fun ref set_object_cap(object_cap': (Cap | None | Question)) => _object_cap = consume object_cap'

class LambdaCaptures // TODO
  new create() => None

class LambdaCapture
  var _name: Id
  var _local_type: (TypePtr | None)
  var _expr: (Expr | None)
  
  new create(
    name': Id,
    local_type': (TypePtr | None),
    expr': (Expr | None))
  =>
    _name = name'
    _local_type = local_type'
    _expr = expr'
  
  fun name(): this->Id => _name
  fun local_type(): this->(TypePtr | None) => _local_type
  fun expr(): this->(Expr | None) => _expr
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_local_type(local_type': (TypePtr | None)) => _local_type = consume local_type'
  fun ref set_expr(expr': (Expr | None)) => _expr = consume expr'

class LitArray // TODO
  new create() => None

class Object
  var _cap: (Cap | None)
  var _provides: (Provides | None)
  var _members: (Members | None)
  
  new create(
    cap': (Cap | None),
    provides': (Provides | None),
    members': (Members | None))
  =>
    _cap = cap'
    _provides = provides'
    _members = members'
  
  fun cap(): this->(Cap | None) => _cap
  fun provides(): this->(Provides | None) => _provides
  fun members(): this->(Members | None) => _members
  
  fun ref set_cap(cap': (Cap | None)) => _cap = consume cap'
  fun ref set_provides(provides': (Provides | None)) => _provides = consume provides'
  fun ref set_members(members': (Members | None)) => _members = consume members'

class Reference
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'

class PackageRef
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'

class MethodFunRef
  var _receiver: Expr
  var _name: (Id, TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id, TypeArgs))
  =>
    _receiver = receiver'
    _name = name'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->(Id, TypeArgs) => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': (Id, TypeArgs)) => _name = consume name'

class MethodNewRef
  var _receiver: Expr
  var _name: (Id, TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id, TypeArgs))
  =>
    _receiver = receiver'
    _name = name'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->(Id, TypeArgs) => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': (Id, TypeArgs)) => _name = consume name'

class MethodBeRef
  var _receiver: Expr
  var _name: (Id, TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id, TypeArgs))
  =>
    _receiver = receiver'
    _name = name'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->(Id, TypeArgs) => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': (Id, TypeArgs)) => _name = consume name'

class TypeRef
  var _package: Expr
  var _name: (Id, TypeArgs)
  
  new create(
    package': Expr,
    name': (Id, TypeArgs))
  =>
    _package = package'
    _name = name'
  
  fun package(): this->Expr => _package
  fun name(): this->(Id, TypeArgs) => _name
  
  fun ref set_package(package': Expr) => _package = consume package'
  fun ref set_name(name': (Id, TypeArgs)) => _name = consume name'

class FieldLetRef
  var _receiver: Expr
  var _name: Id
  
  new create(
    receiver': Expr,
    name': Id)
  =>
    _receiver = receiver'
    _name = name'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->Id => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': Id) => _name = consume name'

class FieldVarRef
  var _receiver: Expr
  var _name: Id
  
  new create(
    receiver': Expr,
    name': Id)
  =>
    _receiver = receiver'
    _name = name'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->Id => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': Id) => _name = consume name'

class FieldEmbedRef
  var _receiver: Expr
  var _name: Id
  
  new create(
    receiver': Expr,
    name': Id)
  =>
    _receiver = receiver'
    _name = name'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->Id => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': Id) => _name = consume name'

class TupleElementRef
  var _receiver: Expr
  var _name: LitInteger
  
  new create(
    receiver': Expr,
    name': LitInteger)
  =>
    _receiver = receiver'
    _name = name'
  
  fun receiver(): this->Expr => _receiver
  fun name(): this->LitInteger => _name
  
  fun ref set_receiver(receiver': Expr) => _receiver = consume receiver'
  fun ref set_name(name': LitInteger) => _name = consume name'

class LocalLetRef
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'

class LocalVarRef
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'

class ParamRef
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'

class TypePtr // TODO
  new create() => None

class UnionType // TODO
  new create() => None

class IsectType // TODO
  new create() => None

class TupleType // TODO
  new create() => None

class ArrowType
  var _left: TypePtr
  var _right: TypePtr
  
  new create(
    left': TypePtr,
    right': TypePtr)
  =>
    _left = left'
    _right = right'
  
  fun left(): this->TypePtr => _left
  fun right(): this->TypePtr => _right
  
  fun ref set_left(left': TypePtr) => _left = consume left'
  fun ref set_right(right': TypePtr) => _right = consume right'

class FunType
  var _cap: Cap
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _return_type: (TypePtr | None)
  
  new create(
    cap': Cap,
    type_params': (TypeParams | None),
    params': (Params | None),
    return_type': (TypePtr | None))
  =>
    _cap = cap'
    _type_params = type_params'
    _params = params'
    _return_type = return_type'
  
  fun cap(): this->Cap => _cap
  fun type_params(): this->(TypeParams | None) => _type_params
  fun params(): this->(Params | None) => _params
  fun return_type(): this->(TypePtr | None) => _return_type
  
  fun ref set_cap(cap': Cap) => _cap = consume cap'
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None)) => _params = consume params'
  fun ref set_return_type(return_type': (TypePtr | None)) => _return_type = consume return_type'

class LambdaType
  var _method_cap: (Cap | None)
  var _name: (Id | None)
  var _type_params: (TypeParams | None)
  var _params: (TypePtrList | None)
  var _return_type: (TypePtr | None)
  var _partial: (Question | None)
  var _object_cap: (Cap | GenCap | None)
  var _cap_mod: (CapMod | None)
  
  new create(
    method_cap': (Cap | None),
    name': (Id | None),
    type_params': (TypeParams | None),
    params': (TypePtrList | None),
    return_type': (TypePtr | None),
    partial': (Question | None),
    object_cap': (Cap | GenCap | None),
    cap_mod': (CapMod | None))
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
  fun params(): this->(TypePtrList | None) => _params
  fun return_type(): this->(TypePtr | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun object_cap(): this->(Cap | GenCap | None) => _object_cap
  fun cap_mod(): this->(CapMod | None) => _cap_mod
  
  fun ref set_method_cap(method_cap': (Cap | None)) => _method_cap = consume method_cap'
  fun ref set_name(name': (Id | None)) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None)) => _type_params = consume type_params'
  fun ref set_params(params': (TypePtrList | None)) => _params = consume params'
  fun ref set_return_type(return_type': (TypePtr | None)) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None)) => _partial = consume partial'
  fun ref set_object_cap(object_cap': (Cap | GenCap | None)) => _object_cap = consume object_cap'
  fun ref set_cap_mod(cap_mod': (CapMod | None)) => _cap_mod = consume cap_mod'

class TypePtrList // TODO
  new create() => None

class NominalType
  var _package: (Id | None)
  var _name: Id
  var _type_args: (TypeArgs | None)
  var _cap: (Cap | GenCap | None)
  var _cap_mod: (CapMod | None)
  
  new create(
    package': (Id | None),
    name': Id,
    type_args': (TypeArgs | None),
    cap': (Cap | GenCap | None),
    cap_mod': (CapMod | None))
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
  
  fun ref set_package(package': (Id | None)) => _package = consume package'
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_type_args(type_args': (TypeArgs | None)) => _type_args = consume type_args'
  fun ref set_cap(cap': (Cap | GenCap | None)) => _cap = consume cap'
  fun ref set_cap_mod(cap_mod': (CapMod | None)) => _cap_mod = consume cap_mod'

class TypeParamRef
  var _name: Id
  var _cap: (Cap | GenCap | None)
  var _cap_mod: (CapMod | None)
  
  new create(
    name': Id,
    cap': (Cap | GenCap | None),
    cap_mod': (CapMod | None))
  =>
    _name = name'
    _cap = cap'
    _cap_mod = cap_mod'
  
  fun name(): this->Id => _name
  fun cap(): this->(Cap | GenCap | None) => _cap
  fun cap_mod(): this->(CapMod | None) => _cap_mod
  
  fun ref set_name(name': Id) => _name = consume name'
  fun ref set_cap(cap': (Cap | GenCap | None)) => _cap = consume cap'
  fun ref set_cap_mod(cap_mod': (CapMod | None)) => _cap_mod = consume cap_mod'

class At // TODO
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

class Semi
  new create() => None

class This
  new create() => None

class ThisType
  new create() => None



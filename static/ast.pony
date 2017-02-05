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

class Program
  new create() => None

class Package
  new create() => None

class Module
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

class Provides
  new create() => None

class Members
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

class TypeParams
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

class TypeArgs
  new create() => None

class Params
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

class ExprSeq
  new create() => None

class RawExprSeq
  new create() => None

class Return
  new create() => None

class Break
  new create() => None

class Continue
  new create() => None

class Error
  new create() => None

class CompileError
  new create() => None

class Expr
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

class LocalVar
  var _name: Id
  var _local_type: (TypePtr | None)
  new create(
    name': Id,
    local_type': (TypePtr | None))
  =>
    _name = name'
    _local_type = local_type'

class MatchCapture
  var _name: Id
  var _match_type: TypePtr
  new create(
    name': Id,
    match_type': TypePtr)
  =>
    _name = name'
    _match_type = match_type'

class Infix
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

class Tuple
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

class Recover
  var _cap: (Cap | None)
  var _block: Expr
  new create(
    cap': (Cap | None),
    block': Expr)
  =>
    _cap = cap'
    _block = block'

class Not
  var _expr: Expr
  new create(
    expr': Expr)
  =>
    _expr = expr'

class UMinus
  var _expr: Expr
  new create(
    expr': Expr)
  =>
    _expr = expr'

class UMinusUnsafe
  var _expr: Expr
  new create(
    expr': Expr)
  =>
    _expr = expr'

class AddressOf
  var _expr: Expr
  new create(
    expr': Expr)
  =>
    _expr = expr'

class DigestOf
  var _expr: Expr
  new create(
    expr': Expr)
  =>
    _expr = expr'

class Dot
  var _left: Expr
  var _right: (Id | LitInteger | TypeArgs)
  new create(
    left': Expr,
    right': (Id | LitInteger | TypeArgs))
  =>
    _left = left'
    _right = right'

class Tilde
  var _left: Expr
  var _right: Id
  new create(
    left': Expr,
    right': Id)
  =>
    _left = left'
    _right = right'

class Qualify
  var _left: Expr
  var _right: TypeArgs
  new create(
    left': Expr,
    right': TypeArgs)
  =>
    _left = left'
    _right = right'

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

class Args
  new create() => None

class NamedArgs
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

class IfDefCond
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

class IfDefNot
  var _expr: IfDefCond
  new create(
    expr': IfDefCond)
  =>
    _expr = expr'

class IfDefFlag
  var _name: Id
  new create(
    name': Id)
  =>
    _name = name'

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

class Cases
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

class LambdaCaptures
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

class LitArray
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

class Reference
  var _name: Id
  new create(
    name': Id)
  =>
    _name = name'

class PackageRef
  var _name: Id
  new create(
    name': Id)
  =>
    _name = name'

class MethodFunRef
  var _receiver: Expr
  var _name: (Id, TypeArgs)
  new create(
    receiver': Expr,
    name': (Id, TypeArgs))
  =>
    _receiver = receiver'
    _name = name'

class MethodNewRef
  var _receiver: Expr
  var _name: (Id, TypeArgs)
  new create(
    receiver': Expr,
    name': (Id, TypeArgs))
  =>
    _receiver = receiver'
    _name = name'

class MethodBeRef
  var _receiver: Expr
  var _name: (Id, TypeArgs)
  new create(
    receiver': Expr,
    name': (Id, TypeArgs))
  =>
    _receiver = receiver'
    _name = name'

class TypeRef
  var _package: Expr
  var _name: (Id, TypeArgs)
  new create(
    package': Expr,
    name': (Id, TypeArgs))
  =>
    _package = package'
    _name = name'

class FieldLetRef
  var _receiver: Expr
  var _name: Id
  new create(
    receiver': Expr,
    name': Id)
  =>
    _receiver = receiver'
    _name = name'

class FieldVarRef
  var _receiver: Expr
  var _name: Id
  new create(
    receiver': Expr,
    name': Id)
  =>
    _receiver = receiver'
    _name = name'

class FieldEmbedRef
  var _receiver: Expr
  var _name: Id
  new create(
    receiver': Expr,
    name': Id)
  =>
    _receiver = receiver'
    _name = name'

class TupleElementRef
  var _receiver: Expr
  var _name: LitInteger
  new create(
    receiver': Expr,
    name': LitInteger)
  =>
    _receiver = receiver'
    _name = name'

class LocalLetRef
  var _name: Id
  new create(
    name': Id)
  =>
    _name = name'

class LocalVarRef
  var _name: Id
  new create(
    name': Id)
  =>
    _name = name'

class ParamRef
  var _name: Id
  new create(
    name': Id)
  =>
    _name = name'

class TypePtr
  new create() => None

class UnionType
  new create() => None

class IsectType
  new create() => None

class TupleType
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

class TypePtrList
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
  new create() => None

class LitFloat
  new create() => None

class LitInteger
  new create() => None

class LitLocation
  new create() => None

class LitString
  new create() => None

class LiteralType
  new create() => None

class LiteralTypeBranch
  new create() => None

class OpLiteralType
  new create() => None

class Question
  new create() => None

class Semi
  new create() => None

class This
  new create() => None

class ThisType
  new create() => None



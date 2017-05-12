type BinaryOp is (MulUnsafe | GE | Eq | Is | And | DivUnsafe | NE | Div | AddUnsafe | XOr | SubUnsafe | Mod | Or | Mul | ModUnsafe | Sub | RShiftUnsafe | GT | Add | LT | RShift | LShift | Isnt | LShiftUnsafe | LE)

type Cap is (Ref | Val | Tag | Box | Trn | Iso)

type LitBool is (LitTrue | LitFalse)

type Type is (LiteralTypeBranch | LambdaType | FunType | OpLiteralType | IsectType | TypeParamRef | ErrorType | NominalType | DontCareType | LiteralType | TupleType | ArrowType | ThisType | UnionType)

type Field is (FieldVar | FieldLet | FieldEmbed)

type IfDefBinaryOp is (IfDefAnd | IfDefOr)

type GenCap is (CapAlias | CapAny | CapRead | CapSend | CapShare)

type Local is (LocalVar | LocalLet)

type MethodRef is (MethodNewRef | MethodFunRef | MethodBeRef)

type Jump is (Continue | Error | Break | Return)

type Use is (UseFFIDecl | UsePackage)

type TypeDecl is (Trait | Primitive | Struct | Actor | Class | Interface | TypeAlias)

type IfDefCond is (IfDefBinaryOp | IfDefNot | IfDefFlag)

type Method is (MethodFun | MethodNew | MethodBe)

type Expr is (RawExprSeq | Lambda | FFICall | Id | This | For | Qualify | TupleElementRef | MatchCapture | TypeRef | Jump | LitBool | As | Consume | If | LitLocation | CompileIntrinsic | Dot | Match | Repeat | While | IfDef | Object | With | Try | BinaryOp | Reference | PackageRef | LitNone | LocalRef | LitInteger | Assign | Tilde | Local | MethodRef | CompileError | LitString | LitFloat | Tuple | Call | LitArray | FieldRef | Recover | UnaryOp)

type CapMod is (Aliased | Ephemeral)

type FieldRef is (FieldVarRef | FieldLetRef | FieldEmbedRef)

type LocalRef is (LocalLetRef | LocalVarRef | ParamRef)

type UnaryOp is (Neg | AddressOf | NegUnsafe | DigestOf | Not)

class Program
  var _packages: Array[Package]
  
  new create(
    packages': Array[Package])
  =>
    _packages = packages'
  
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

class UsePackage
  var _prefix: (Id | None)
  var _package: String
  
  new create(
    prefix': (Id | None) = None,
    package': String)
  =>
    _prefix = prefix'
    _package = package'
  
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

class UseFFIDecl
  var _body: FFIDecl
  var _guard: (Expr | IfDefCond | None)
  
  new create(
    body': FFIDecl,
    guard': (Expr | IfDefCond | None) = None)
  =>
    _body = body'
    _guard = guard'
  
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

class Provides
  var _types: Array[Type]
  
  new create(
    types': Array[Type] = Array[Type])
  =>
    _types = types'
  
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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldLet")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_field_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldVar")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_field_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldEmbed")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_field_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

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

class TypeParams
  var _list: Array[TypeParam]
  
  new create(
    list': Array[TypeParam] = Array[TypeParam])
  =>
    _list = list'
  
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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeParam")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_constraint.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class TypeArgs
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
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

class Params
  var _list: Array[Param]
  var _ellipsis: (Ellipsis | None)
  
  new create(
    list': Array[Param] = Array[Param],
    ellipsis': (Ellipsis | None) = None)
  =>
    _list = list'
    _ellipsis = ellipsis'
  
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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Param")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_param_type.string()).>push(',').push(' ')
    s.>append(_default.string())
    s.push(')')
    consume s

class ExprSeq
  var _list: Array[Expr]
  
  new create(
    list': Array[Expr] = Array[Expr])
  =>
    _list = list'
  
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

class RawExprSeq
  var _list: Array[Expr]
  
  new create(
    list': Array[Expr] = Array[Expr])
  =>
    _list = list'
  
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

class Return
  var _value: RawExprSeq
  
  new create(
    value': RawExprSeq)
  =>
    _value = value'
  
  fun value(): this->RawExprSeq => _value
  
  fun ref set_value(value': RawExprSeq) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Return")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class Break
  var _value: RawExprSeq
  
  new create(
    value': RawExprSeq)
  =>
    _value = value'
  
  fun value(): this->RawExprSeq => _value
  
  fun ref set_value(value': RawExprSeq) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Break")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class Continue
  var _value: RawExprSeq
  
  new create(
    value': RawExprSeq)
  =>
    _value = value'
  
  fun value(): this->RawExprSeq => _value
  
  fun ref set_value(value': RawExprSeq) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Continue")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class Error
  var _value: RawExprSeq
  
  new create(
    value': RawExprSeq)
  =>
    _value = value'
  
  fun value(): this->RawExprSeq => _value
  
  fun ref set_value(value': RawExprSeq) => _value = consume value'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Error")
    s.push('(')
    s.>append(_value.string())
    s.push(')')
    consume s

class CompileIntrinsic
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CompileIntrinsic")
    consume s

class CompileError
  var _message: RawExprSeq
  
  new create(
    message': RawExprSeq)
  =>
    _message = message'
  
  fun message(): this->RawExprSeq => _message
  
  fun ref set_message(message': RawExprSeq) => _message = consume message'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CompileError")
    s.push('(')
    s.>append(_message.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalLet")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_local_type.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalVar")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_local_type.string())
    s.push(')')
    consume s

class MatchCapture
  var _name: Id
  var _local_type: Type
  
  new create(
    name': Id,
    local_type': Type)
  =>
    _name = name'
    _local_type = local_type'
  
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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("As")
    s.push('(')
    s.>append(_expr.string()).>push(',').push(' ')
    s.>append(_as_type.string())
    s.push(')')
    consume s

class Tuple
  var _elements: Array[RawExprSeq]
  
  new create(
    elements': Array[RawExprSeq] = Array[RawExprSeq])
  =>
    _elements = elements'
  
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

class Consume
  var _cap: (Cap | None)
  var _expr: Expr
  
  new create(
    cap': (Cap | None),
    expr': Expr)
  =>
    _cap = cap'
    _expr = expr'
  
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

class Recover
  var _cap: (Cap | None)
  var _expr: Expr
  
  new create(
    cap': (Cap | None),
    expr': Expr)
  =>
    _cap = cap'
    _expr = expr'
  
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

class Not
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Not")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class Neg
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Neg")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class NegUnsafe
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NegUnsafe")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class AddressOf
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("AddressOf")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class DigestOf
  var _expr: Expr
  
  new create(
    expr': Expr)
  =>
    _expr = expr'
  
  fun expr(): this->Expr => _expr
  
  fun ref set_expr(expr': Expr) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DigestOf")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Add")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("AddUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Sub")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("SubUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Mul")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("MulUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Div")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DivUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Mod")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ModUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LShift")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LShiftUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RShift")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("RShiftUnsafe")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Is")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Isnt")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Eq")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LT")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GE")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("GT")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("And")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Or")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("XOr")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Assign")
    s.push('(')
    s.>append(_right.string()).>push(',').push(' ')
    s.>append(_left.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Dot")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Tilde")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Qualify")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class Call
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

class Args
  var _list: Array[RawExprSeq]
  
  new create(
    list': Array[RawExprSeq] = Array[RawExprSeq])
  =>
    _list = list'
  
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

class NamedArgs
  var _list: Array[NamedArg]
  
  new create(
    list': Array[NamedArg] = Array[NamedArg])
  =>
    _list = list'
  
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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("NamedArg")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_value.string())
    s.push(')')
    consume s

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

class IfDefAnd
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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefAnd")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class IfDefOr
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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefOr")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

class IfDefNot
  var _expr: IfDefCond
  
  new create(
    expr': IfDefCond)
  =>
    _expr = expr'
  
  fun expr(): this->IfDefCond => _expr
  
  fun ref set_expr(expr': IfDefCond) => _expr = consume expr'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefNot")
    s.push('(')
    s.>append(_expr.string())
    s.push(')')
    consume s

class IfDefFlag
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("IfDefFlag")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class If
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

class While
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

class Repeat
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

class For
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

class With
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

class Match
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

class Cases
  var _list: Array[Case]
  
  new create(
    list': Array[Case] = Array[Case])
  =>
    _list = list'
  
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

class Case
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

class Try
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

class Lambda
  var _method_cap: (Cap | None)
  var _name: (Id | None)
  var _type_params: (TypeParams | None)
  var _params: (Params | None)
  var _captures: (LambdaCaptures | None)
  var _return_type: (Type | None)
  var _partial: (Question | None)
  var _body: (RawExprSeq)
  var _object_cap: (Cap | None | Question)
  
  new create(
    method_cap': (Cap | None) = None,
    name': (Id | None) = None,
    type_params': (TypeParams | None) = None,
    params': (Params | None) = None,
    captures': (LambdaCaptures | None) = None,
    return_type': (Type | None) = None,
    partial': (Question | None) = None,
    body': (RawExprSeq),
    object_cap': (Cap | None | Question) = None)
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
  fun return_type(): this->(Type | None) => _return_type
  fun partial(): this->(Question | None) => _partial
  fun body(): this->(RawExprSeq) => _body
  fun object_cap(): this->(Cap | None | Question) => _object_cap
  
  fun ref set_method_cap(method_cap': (Cap | None) = None) => _method_cap = consume method_cap'
  fun ref set_name(name': (Id | None) = None) => _name = consume name'
  fun ref set_type_params(type_params': (TypeParams | None) = None) => _type_params = consume type_params'
  fun ref set_params(params': (Params | None) = None) => _params = consume params'
  fun ref set_captures(captures': (LambdaCaptures | None) = None) => _captures = consume captures'
  fun ref set_return_type(return_type': (Type | None) = None) => _return_type = consume return_type'
  fun ref set_partial(partial': (Question | None) = None) => _partial = consume partial'
  fun ref set_body(body': (RawExprSeq)) => _body = consume body'
  fun ref set_object_cap(object_cap': (Cap | None | Question) = None) => _object_cap = consume object_cap'
  
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

class LambdaCaptures
  var _list: Array[LambdaCapture]
  
  new create(
    list': Array[LambdaCapture] = Array[LambdaCapture])
  =>
    _list = list'
  
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

class LambdaCapture
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

class Object
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

class LitArray
  var _list: Array[RawExprSeq]
  
  new create(
    list': Array[RawExprSeq] = Array[RawExprSeq])
  =>
    _list = list'
  
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

class Reference
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Reference")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class PackageRef
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("PackageRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class MethodFunRef
  var _receiver: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
    _receiver = receiver'
    _name = name'
  
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

class MethodNewRef
  var _receiver: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
    _receiver = receiver'
    _name = name'
  
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

class MethodBeRef
  var _receiver: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    receiver': Expr,
    name': (Id | TypeArgs))
  =>
    _receiver = receiver'
    _name = name'
  
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

class TypeRef
  var _package: Expr
  var _name: (Id | TypeArgs)
  
  new create(
    package': Expr,
    name': (Id | TypeArgs))
  =>
    _package = package'
    _name = name'
  
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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldLetRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldVarRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("FieldEmbedRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TupleElementRef")
    s.push('(')
    s.>append(_receiver.string()).>push(',').push(' ')
    s.>append(_name.string())
    s.push(')')
    consume s

class LocalLetRef
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalLetRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class LocalVarRef
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LocalVarRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class ParamRef
  var _name: Id
  
  new create(
    name': Id)
  =>
    _name = name'
  
  fun name(): this->Id => _name
  
  fun ref set_name(name': Id) => _name = consume name'
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ParamRef")
    s.push('(')
    s.>append(_name.string())
    s.push(')')
    consume s

class UnionType
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
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

class IsectType
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
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

class TupleType
  var _list: Array[Type]
  
  new create(
    list': Array[Type] = Array[Type])
  =>
    _list = list'
  
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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ArrowType")
    s.push('(')
    s.>append(_left.string()).>push(',').push(' ')
    s.>append(_right.string())
    s.push(')')
    consume s

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

class LambdaType
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
  
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("TypeParamRef")
    s.push('(')
    s.>append(_name.string()).>push(',').push(' ')
    s.>append(_cap.string()).>push(',').push(' ')
    s.>append(_cap_mod.string())
    s.push(')')
    consume s

class ThisType
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ThisType")
    consume s

class DontCareType
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("DontCareType")
    consume s

class ErrorType
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("ErrorType")
    consume s

class LiteralType
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LiteralType")
    consume s

class LiteralTypeBranch
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LiteralTypeBranch")
    consume s

class OpLiteralType
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("OpLiteralType")
    consume s

class Iso
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Iso")
    consume s

class Trn
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Trn")
    consume s

class Ref
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ref")
    consume s

class Val
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Val")
    consume s

class Box
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Box")
    consume s

class Tag
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Tag")
    consume s

class CapRead
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapRead")
    consume s

class CapSend
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapSend")
    consume s

class CapShare
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapShare")
    consume s

class CapAlias
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapAlias")
    consume s

class CapAny
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("CapAny")
    consume s

class Aliased
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Aliased")
    consume s

class Ephemeral
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ephemeral")
    consume s

class At
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("At")
    consume s

class Question
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Question")
    consume s

class Ellipsis
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("Ellipsis")
    consume s

class Id
  var _value: String
  new create(value': String) => _value = value'
  fun value(): String => _value
  fun ref set_value(value': String) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("Id(").>append(_value.string()).>push(')')
    end

class This
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("This")
    consume s

class LitTrue
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitTrue")
    consume s

class LitFalse
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitFalse")
    consume s

class LitNone
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitNone")
    consume s

class LitFloat
  var _value: F64
  new create(value': F64) => _value = value'
  fun value(): F64 => _value
  fun ref set_value(value': F64) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitFloat(").>append(_value.string()).>push(')')
    end

class LitInteger
  var _value: I128
  new create(value': I128) => _value = value'
  fun value(): I128 => _value
  fun ref set_value(value': I128) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitInteger(").>append(_value.string()).>push(')')
    end

class LitString
  var _value: String
  new create(value': String) => _value = value'
  fun value(): String => _value
  fun ref set_value(value': String) => _value = value'
  fun string(): String iso^ =>
    recover
      String.>append("LitString(").>append(_value.string()).>push(')')
    end

class LitLocation
  new create() => None
  fun string(): String iso^ =>
    let s = recover iso String end
    s.append("LitLocation")
    consume s



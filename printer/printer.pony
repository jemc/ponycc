
use "collections"
use "../ast"
use "inspect"

primitive _GenNewline
primitive _GenIndentPush
primitive _GenIndentPop

type _GenItem is (String | _GenIndentPush | _GenIndentPop | _GenNewline)

class _Gen
  var _list: Array[_GenItem] = Array[_GenItem]
  new create() => None
  
  fun ref string(): String iso^ =>
    var size:   USize = 0
    var indent: USize = 0
    for x in _list.values() do
      match x
      | let s: String  => size = size + s.size()
      | _GenIndentPush => indent = indent + 2
      | _GenIndentPop  => indent = indent - 2
      | _GenNewline    => size = size + 1 + indent
      end
    end
    
    let buf = recover String end
    indent = 0
    for x in _list.values() do
      match x
      | let s: String  => buf.append(s)
      | _GenIndentPush => indent = indent + 2
      | _GenIndentPop  => indent = indent - 2
      | _GenNewline    => buf.push('\n')
                          for i in Range(0, indent) do buf.push(' ') end
      end
    end
    
    buf
  
  fun ref write(s: String) => _list.push(s)
  
  fun ref push_indent() => _list.push(_GenIndentPush)
  fun ref pop_indent()  => _list.push(_GenIndentPop)
  
  fun ref line() => _list.push(_GenNewline)
  fun ref line_start() =>
    let last_item = try _list(_list.size() - 1) else _GenNewline end
    if last_item isnt _GenNewline then line() end
  
  fun ref string_triple(s: String) =>
    line_start(); write("\"\"\"")
    write(s) // TODO: split on newline and add indent to each line.
    line(); write("\"\"\"")

primitive Printer
  fun apply(x: Module): String iso^ =>
    let g = _Gen
    _show(g, x)
    g.string()
  
  fun _show(g: _Gen, x: Module) =>
    try
      g.write((x.docs() as LitString).pos().string()) // TODO: less cheating...
      if (x.use_decls().size() + x.type_decls().size()) > 0 then
        g.line()
        g.line()
      end
    end
    for u in x.use_decls().values() do _show(g, u) end
    for (i, t) in x.type_decls().pairs() do
      if (x.use_decls().size() > 0) or (i > 0) then g.line(); g.line() end
      _show(g, t)
    end
    g.line()
  
  fun _show(g: _Gen, x: UsePackage) =>
    g.line_start()
    g.write("use ")
    try _show(g, x.prefix() as Id); g.write(" = ") end
    _show(g, x.package())
  
  fun _show(g: _Gen, x: UseFFIDecl) =>
    g.line_start()
    g.write("use @")
    _show(g, x.name())
    _show(g, x.return_type())
    try _show(g, x.params() as Params) else g.write("()") end
    try let q = x.partial() as Question; g.write(" "); _show(g, q) end
    try let e = x.guard() as IfDefCond; g.write(" if "); _show(g, e) end
  
  fun _show(g: _Gen,
    x: (TypeAlias | Interface | Class | Actor | Struct | Primitive | Trait))
  =>
    g.line_start()
    g.write(
      match x
      | let _: TypeAlias => "type "
      | let _: Interface => "interface "
      | let _: Class     => "class "
      | let _: Actor     => "actor "
      | let _: Struct    => "struct "
      | let _: Primitive => "primitive "
      | let _: Trait     => "trait "
      end)
    
    try _show(g, x.at() as At) end
    try let c = x.cap() as Cap; _show(g, c); g.write(" ") end
    _show(g, x.name())
    try _show(g, x.type_params() as TypeParams) end
    try let p = x.provides() as Type; g.write(" is "); _show(g, p) end
    g.push_indent()
    try let d = x.docs() as LitString; g.line(); g.write(d.pos().string()) end // TODO: less cheating...
    try _show(g, x.members() as Members) end
    g.pop_indent()
  
  fun _show(g: _Gen, x: Members) =>
    for f in x.fields().values() do
      _show(g, f)
    end
    for (i, m) in x.methods().pairs() do
      if (x.fields().size() > 0) or (i > 0) then g.line(); g.line() end
      _show(g, m)
    end
  
  fun _show(g: _Gen, x: (FieldLet | FieldVar | FieldEmbed)) =>
    g.line_start()
    g.write(
      match x
      | let _: FieldLet   => "let "
      | let _: FieldVar   => "var "
      | let _: FieldEmbed => "embed "
      end)
    
    _show(g, x.name())
    try let t = x.field_type() as Type; g.write(": "); _show(g, t) end
    try let d = x.default() as Expr; g.write(" = "); _show(g, d) end
  
  fun _show(g: _Gen, x: (MethodFun | MethodNew | MethodBe)) =>
    g.line_start()
    g.write(
      match x
      | let _: MethodFun => "fun "
      | let _: MethodNew => "new "
      | let _: MethodBe  => "be "
      end)
    
    try _show(g, x.cap() as Cap); g.write(" ") end
    _show(g, x.name())
    try _show(g, x.type_params() as TypeParams) end
    try _show(g, x.params() as Params) else g.write("()") end
    try let t = x.return_type() as Type; g.write(": "); _show(g, t) end
    try let q = x.partial() as Question; g.write(" "); _show(g, q) end
    try _show(g, x.guard() as Sequence) end
    if x.body() isnt None then g.write(" =>") end
    g.push_indent()
    g.line_start()
    try g.write((x.docs() as LitString).pos().string()) end // TODO: less cheating...
    try _show_bare(g, x.body() as Sequence) end
    g.pop_indent()
  
  fun _show(g: _Gen, x: TypeParams) =>
    g.write("[")
    for (i, p) in x.list().pairs() do
      if i > 0 then g.write(", ") end
      _show(g, p)
    end
    g.write("]")
  
  fun _show(g: _Gen, x: TypeParam) =>
    _show(g, x.name())
    try let t = x.constraint() as Type; g.write(": "); _show(g, t) end
    try let t = x.default() as Type; g.write(" = "); _show(g, t) end
  
  fun _show(g: _Gen, x: TypeArgs) =>
    g.write("[")
    for (i, a) in x.list().pairs() do
      if i > 0 then g.write(", ") end
      _show(g, a)
    end
    g.write("]")
  
  fun _show(g: _Gen, x: Params) =>
    g.write("(")
    let iter = x.list().values()
    for t in iter do
      _show(g, t)
      if (x.ellipsis() isnt None) or iter.has_next() then g.write(", ") end
    end
    try _show(g, x.ellipsis() as Ellipsis) end
    g.write(")")
  
  fun _show(g: _Gen, x: Param) =>
    _show(g, x.name())
    try let t = x.param_type() as Type; g.write(": "); _show(g, t) end
    try let d = x.default() as Expr; g.write(" = "); _show(g, d) end
  
  fun _show(g: _Gen, x: Sequence) =>
    g.write("(")
    for (i, expr) in x.list().pairs() do
      if i > 0 then g.write("; ") end
      _show(g, expr)
    end
    g.write(")")
  
  fun _show_bare(g: _Gen, x: Sequence) =>
    for (i, expr) in x.list().pairs() do
      g.line_start()
      _show(g, expr)
    end
  
  fun _show(g: _Gen,
    x: (Return | Break | Continue | Error | CompileIntrinsic | CompileError))
  =>
    g.write(
      match x
      | let _: Return           => "return "
      | let _: Break            => "break "
      | let _: Continue         => "continue "
      | let _: Error            => "error "
      | let _: CompileIntrinsic => "compile_intrinsic "
      | let _: CompileError     => "compile_error "
      end)
    
    try _show(g, x.value() as AST) end
  
  fun _show(g: _Gen, x: (LocalLet | LocalVar)) =>
    g.write(
      match x
      | let _: LocalLet => "let "
      | let _: LocalVar => "var "
      end)
    
    _show(g, x.name())
    try let t = x.local_type() as Type; g.write(": "); _show(g, t) end
  
  fun _show(g: _Gen, x: As) =>
    _show(g, x.expr())
    g.write(" as ")
    _show(g, x.as_type())
  
  fun _show(g: _Gen, x: Tuple) =>
    g.write("(")
    for (i, e) in x.elements().pairs() do
      if i > 0 then g.write(", ") end
      _show(g, e) // TODO: parenthesize if more than one expr in seq
    end
    g.write(")")
  
  fun _show(g: _Gen, x: Consume) =>
    g.write("consume ")
    try _show(g, x.cap() as Cap); g.write(" ") end
    _show(g, x.expr())
  
  fun _show(g: _Gen, x: Recover) =>
    g.write("recover")
    try let c = x.cap() as Cap; g.write(" "); _show(g, c) end
    g.push_indent()
    _show_bare(g, x.expr())
    g.pop_indent()
    g.line_start()
    g.write("end")
  
  fun _show(g: _Gen, x: (Not | Neg | NegUnsafe | AddressOf | DigestOf)) =>
    g.write(
      match x
      | let _: Not       => "not "
      | let _: Neg       => "-"
      | let _: NegUnsafe => "-~ "
      | let _: AddressOf => "addressof "
      | let _: DigestOf  => "digestof "
      else "???"
      end)
    
    _show(g, x.expr())
  
  fun _show(g: _Gen, x:
    ( Add | AddUnsafe | Sub | SubUnsafe | Mul | MulUnsafe
    | Div | DivUnsafe | Mod | ModUnsafe | LShift
    | LShiftUnsafe | RShift | RShiftUnsafe | Is | Isnt
    | Eq | EqUnsafe | NE | NEUnsafe | LT | LTUnsafe
    | LE | LEUnsafe | GE | GEUnsafe | GT | GTUnsafe
    | And | Or | XOr | Assign))
  =>
    _show(g, x.left())
    
    g.write(
      match x
      | let _: Add          => " + "
      | let _: AddUnsafe    => " +~ "
      | let _: Sub          => " - "
      | let _: SubUnsafe    => " -~ "
      | let _: Mul          => " * "
      | let _: MulUnsafe    => " *~ "
      | let _: Div          => " / "
      | let _: DivUnsafe    => " /~ "
      | let _: Mod          => " % "
      | let _: ModUnsafe    => " %~ "
      | let _: LShift       => " << "
      | let _: LShiftUnsafe => " <<~ "
      | let _: RShift       => " >> "
      | let _: RShiftUnsafe => " >>~ "
      | let _: Is           => " is "
      | let _: Isnt         => " isnt "
      | let _: Eq           => " == "
      | let _: EqUnsafe     => " ==~ "
      | let _: NE           => " != "
      | let _: NEUnsafe     => " !=~ "
      | let _: LT           => " < "
      | let _: LTUnsafe     => " <~ "
      | let _: LE           => " <= "
      | let _: LEUnsafe     => " <=~ "
      | let _: GE           => " >= "
      | let _: GEUnsafe     => " >=~ "
      | let _: GT           => " > "
      | let _: GTUnsafe     => " >~ "
      | let _: And          => " and "
      | let _: Or           => " or "
      | let _: XOr          => " xor "
      | let _: Assign       => " = "
      end)
    
    _show(g, x.right())
  
  fun _show(g: _Gen, x: (Dot | Chain | Tilde)) =>
    _show(g, x.left())
    
    g.write(
      match x
      | let _: Dot   => "."
      | let _: Chain => ".>"
      | let _: Tilde => "~"
      end)
    
    _show(g, x.right())
  
  fun _show(g: _Gen, x: Qualify) =>
    _show(g, x.left())
    _show(g, x.right())
  
  fun _show(g: _Gen, x: Call) => None // TODO
  fun _show(g: _Gen, x: CallFFI) => None // TODO
  fun _show(g: _Gen, x: Args) => None // TODO
  fun _show(g: _Gen, x: NamedArgs) => None // TODO
  fun _show(g: _Gen, x: NamedArg) => None // TODO
  
  fun _show(g: _Gen, x: IfDef) => None // TODO
  
  fun _show(g: _Gen, x: (IfDefAnd | IfDefOr)) =>
    _show(g, x.left())
    
    g.write(
      match x
      | let _: IfDefAnd => " and "
      | let _: IfDefOr  => " or "
      end)
    
    _show(g, x.right())
  
  fun _show(g: _Gen, x: IfDefNot) =>
    g.write("not ")
    _show(g, x.expr())
  
  fun _show(g: _Gen, x: IfDefFlag) =>
    _show(g, x.name())
  
  fun _show(g: _Gen, x: If) => None // TODO
  fun _show(g: _Gen, x: While) => None // TODO
  fun _show(g: _Gen, x: Repeat) => None // TODO
  fun _show(g: _Gen, x: For) => None // TODO
  fun _show(g: _Gen, x: With) => None // TODO
  
  fun _show(g: _Gen, x: Match) => None // TODO
  fun _show(g: _Gen, x: Cases) => None // TODO
  fun _show(g: _Gen, x: Case) => None // TODO
  fun _show(g: _Gen, x: Try) => None // TODO
  
  fun _show(g: _Gen, x: Lambda) => None // TODO
  fun _show(g: _Gen, x: LambdaCaptures) => None // TODO
  fun _show(g: _Gen, x: LambdaCapture) => None // TODO
  fun _show(g: _Gen, x: Object) => None // TODO
  fun _show(g: _Gen, x: LitArray) => None // TODO
  
  fun _show(g: _Gen, x: Reference) => _show(g, x.name())
  fun _show(g: _Gen, x: DontCare) => g.write("_")
  fun _show(g: _Gen, x: PackageRef) => None // TODO
  fun _show(g: _Gen, x: MethodRef) => None // TODO
  fun _show(g: _Gen, x: TypeRef) => None // TODO
  fun _show(g: _Gen, x: FieldRef) => None // TODO
  fun _show(g: _Gen, x: TupleElementRef) => None // TODO
  fun _show(g: _Gen, x: LocalRef) => None // TODO
  
  fun _show(g: _Gen, x: UnionType) =>
    g.write("(")
    for (i, t) in x.list().pairs() do
      if i > 0 then g.write(" | ") end
      _show(g, t)
    end
    g.write(")")
  
  fun _show(g: _Gen, x: IsectType) =>
    g.write("(")
    for (i, t) in x.list().pairs() do
      if i > 0 then g.write(" & ") end
      _show(g, t)
    end
    g.write(")")
  
  fun _show(g: _Gen, x: TupleType) =>
    if x.list().size() > 1 then g.write("(") end
    for (i, t) in x.list().pairs() do
      if i > 0 then g.write(", ") end
      _show(g, t)
    end
    if x.list().size() > 1 then g.write(")") end
  
  fun _show(g: _Gen, x: ViewpointType) =>
    _show(g, x.left())
    g.write("->")
    _show(g, x.right())
  
  fun _show(g: _Gen, x: LambdaType) =>
    g.write("{")
    try _show(g, x.method_cap() as Cap) end
    try let n = x.name() as Id; g.write(" "); _show(g, n) end
    try _show(g, x.type_params() as TypeParams) end
    g.write("(")
    try
      for (i, t) in (x.param_types() as TupleType).list().pairs() do
        if i > 0 then g.write(", ") end
        _show(g, t)
      end
    end
    g.write(")")
    try let t = x.return_type() as Type; g.write(": "); _show(g, t) end
    try let q = x.partial() as Question; g.write(" "); _show(g, q) end
    g.write("}")
    try let c = x.object_cap() as Cap; g.write(" "); _show(g, c) end
    try _show(g, x.cap_mod() as CapMod) end
  
  fun _show(g: _Gen, x: NominalType) =>
    try _show(g, x.package() as Id); g.write(".") end
    _show(g, x.name())
    try _show(g, x.type_args() as TypeArgs) end
    try let c = x.cap() as (Cap | GenCap); g.write(" "); _show(g, c) end
    try _show(g, x.cap_mod() as CapMod) end
  
  fun _show(g: _Gen, x: TypeParamRef) => None // TODO
  
  fun _show(g: _Gen, x: Iso) => g.write("iso")
  fun _show(g: _Gen, x: Trn) => g.write("trn")
  fun _show(g: _Gen, x: Ref) => g.write("ref")
  fun _show(g: _Gen, x: Val) => g.write("val")
  fun _show(g: _Gen, x: Box) => g.write("box")
  fun _show(g: _Gen, x: Tag) => g.write("tag")
  
  fun _show(g: _Gen, x: CapRead)  => g.write("#read")
  fun _show(g: _Gen, x: CapSend)  => g.write("#send")
  fun _show(g: _Gen, x: CapShare) => g.write("#share")
  fun _show(g: _Gen, x: CapAlias) => g.write("#alias")
  fun _show(g: _Gen, x: CapAny)   => g.write("#any")
  
  fun _show(g: _Gen, x: Aliased)   => g.write("!")
  fun _show(g: _Gen, x: Ephemeral) => g.write("^")
  fun _show(g: _Gen, x: At)        => g.write("@")
  fun _show(g: _Gen, x: Question)  => g.write("?")
  fun _show(g: _Gen, x: Ellipsis)  => g.write("...")
  
  fun _show(g: _Gen, x: Id)   => g.write(x.pos().string()) // TODO: less cheating, here and below...
  fun _show(g: _Gen, x: This) => g.write("this")
  
  fun _show(g: _Gen, x: LitTrue)      => g.write("true")
  fun _show(g: _Gen, x: LitFalse)     => g.write("false")
  fun _show(g: _Gen, x: LitFloat)     => g.write(x.pos().string())
  fun _show(g: _Gen, x: LitInteger)   => g.write(x.pos().string())
  fun _show(g: _Gen, x: LitCharacter) => g.write(x.pos().string()) // TODO: single-quote
  fun _show(g: _Gen, x: LitString)    => g.write(x.pos().string()) // TODO: normal quote
  fun _show(g: _Gen, x: LitLocation)  => g.write("__loc")
  
  // TODO: remove these defaults when everything is implemented:
  fun _show(g: _Gen, x: AST)  => g.write("/*~" + x.string() + "~*/")

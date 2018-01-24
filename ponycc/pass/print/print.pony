
use "collections"
use ".."
use "../../ast"

primitive _GenNewline
primitive _GenIndentPush
primitive _GenIndentPop

type _GenItem is (String | _GenIndentPush | _GenIndentPop | _GenNewline)

class _Gen
  var _list: Array[_GenItem] = []
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
    let last_item = try _list(_list.size() - 1)? else _GenNewline end
    if last_item isnt _GenNewline then line() end

  fun ref string_triple(s: String) =>
    line_start(); write("\"\"\"")
    write(s) // TODO: split on newline and add indent to each line.
    line(); write("\"\"\"")

primitive Print is Pass[Module, String]
  fun name(): String => "print"

  fun apply(x: Module, fn: {(String, Array[PassError] val)} val) =>
    let g = _Gen
    _show(g, x)
    fn.apply(g.string(), []) // TODO: use apply sugar

  fun _show(g: _Gen, x': AST) =>
    match x'
    | let x: Module =>
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

    | let x: UsePackage =>
      g.line_start()
      g.write("use ")
      try _show(g, x.prefix() as Id); g.write(" = ") end
      _show(g, x.package())

    | let x: UseFFIDecl =>
      g.line_start()
      g.write("use @")
      _show(g, x.name())
      _show(g, x.return_type())
      _show(g, x.params())
      try let q = x.partial() as Question; g.write(" "); _show(g, q) end
      try let e = x.guard() as IfDefCond; g.write(" if "); _show(g, e) end

    | let x:
      (TypeAlias | Interface | Class | Actor | Struct | Primitive | Trait)
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
      _show(g, x.members())
      g.pop_indent()

    | let x: Members =>
      for f in x.fields().values() do
        _show(g, f)
      end
      for (i, m) in x.methods().pairs() do
        if (x.fields().size() > 0) or (i > 0) then g.line(); g.line() end
        _show(g, m)
      end

    | let x: (FieldLet | FieldVar | FieldEmbed) =>
      g.line_start()
      g.write(
        match x
        | let _: FieldLet   => "let "
        | let _: FieldVar   => "var "
        | let _: FieldEmbed => "embed "
        end)

      _show(g, x.name())
      g.write(": ")
      _show(g, x.field_type())
      try let d = x.default() as Expr; g.write(" = "); _show(g, d) end

    | let x: (MethodFun | MethodNew | MethodBe) =>
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
      _show(g, x.params())
      try let t = x.return_type() as Type; g.write(": "); _show(g, t) end
      try let q = x.partial() as Question; g.write(" "); _show(g, q) end
      try let s = x.guard() as Sequence; g.write(" if "); _show(g, s) end
      if x.body() isnt None then g.write(" =>") end
      g.push_indent()
      g.line_start()
      try g.write((x.docs() as LitString).pos().string()) end // TODO: less cheating...
      try _show_bare(g, x.body() as Sequence) end
      g.pop_indent()

    | let x: TypeParams =>
      g.write("[")
      for (i, p) in x.list().pairs() do
        if i > 0 then g.write(", ") end
        _show(g, p)
      end
      g.write("]")

    | let x: TypeParam =>
      _show(g, x.name())
      try let t = x.constraint() as Type; g.write(": "); _show(g, t) end
      try let t = x.default() as Type; g.write(" = "); _show(g, t) end

    | let x: TypeArgs =>
      g.write("[")
      for (i, a) in x.list().pairs() do
        if i > 0 then g.write(", ") end
        _show(g, a)
      end
      g.write("]")

    | let x: Params =>
      g.write("(")
      let iter = x.list().values()
      for t in iter do
        _show(g, t)
        if (x.ellipsis() isnt None) or iter.has_next() then g.write(", ") end
      end
      try _show(g, x.ellipsis() as Ellipsis) end
      g.write(")")

    | let x: Param =>
      _show(g, x.name())
      try let t = x.param_type() as Type; g.write(": "); _show(g, t) end
      try let d = x.default() as Expr; g.write(" = "); _show(g, d) end

    | let x: Sequence =>
      if x.list().size() == 0 then return g.write("None") end

      if x.list().size() > 1 then g.write("(") end
      for (i, expr) in x.list().pairs() do
        if i > 0 then g.write("; ") end
        _show(g, expr)
      end
      if x.list().size() > 1 then g.write(")") end

    | let x:
      (Return | Break | Continue | Error | CompileIntrinsic | CompileError)
    =>
      g.write(
        match x
        | let _: Return           => "return"
        | let _: Break            => "break"
        | let _: Continue         => "continue"
        | let _: Error            => "error"
        | let _: CompileIntrinsic => "compile_intrinsic"
        | let _: CompileError     => "compile_error"
        end)

      try let v = x.value() as AST; g.write(" "); _show(g, v) end

    | let x: (LocalLet | LocalVar) =>
      g.write(
        match x
        | let _: LocalLet => "let "
        | let _: LocalVar => "var "
        end)

      _show(g, x.name())
      try let t = x.local_type() as Type; g.write(": "); _show(g, t) end

    | let x: As =>
      _show(g, x.expr())
      g.write(" as ")
      _show(g, x.as_type())

    | let x: Tuple =>
      g.write("(")
      for (i, e) in x.elements().pairs() do
        if i > 0 then g.write(", ") end
        _show(g, e) // TODO: parenthesize if more than one expr in seq
      end
      g.write(")")

    | let x: IdTuple =>
      g.write("(")
      for (i, e) in x.elements().pairs() do
        if i > 0 then g.write(", ") end
        _show(g, e)
      end
      g.write(")")

    | let x: AssignTuple =>
      for (i, e) in x.elements().pairs() do
        if i > 0 then g.write(", ") end
        _show(g, e)
      end

    | let x: Consume =>
      g.write("consume ")
      try _show(g, x.cap() as Cap); g.write(" ") end
      _show(g, x.expr())

    | let x: Recover =>
      g.write("recover")
      try let c = x.cap() as Cap; g.write(" "); _show(g, c) end
      g.push_indent()
      _show_bare(g, x.expr())
      g.pop_indent()
      g.line_start()
      g.write("end")

    | let x: (Not | Neg | NegUnsafe | AddressOf | DigestOf) =>
      g.write(
        match x
        | let _: Not       => "not "
        | let _: Neg       => "-"
        | let _: NegUnsafe => "-~"
        | let _: AddressOf => "addressof "
        | let _: DigestOf  => "digestof "
        end)

        match x.expr() | let s: Sequence =>
          _show_subsequence(g, s)
        else
          _show(g, x.expr())
        end

    | let x:
      ( Add | AddUnsafe | Sub | SubUnsafe | Mul | MulUnsafe
      | Div | DivUnsafe | Mod | ModUnsafe | LShift
      | LShiftUnsafe | RShift | RShiftUnsafe | Is | Isnt
      | Eq | EqUnsafe | NE | NEUnsafe | LT | LTUnsafe
      | LE | LEUnsafe | GE | GEUnsafe | GT | GTUnsafe
      | And | Or | XOr | Assign)
    =>
      match x.left() | let s: Sequence =>
        _show_subsequence(g, s)
      else
        _show(g, x.left())
      end

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


        match x.right() | let s: Sequence =>
          _show_subsequence(g, s)
        else
          _show(g, x.right())
        end

    | let x: (Dot | Chain | Tilde) =>
      _show(g, x.left())

      g.write(
        match x
        | let _: Dot   => "."
        | let _: Chain => ".>"
        | let _: Tilde => "~"
        end)

      _show(g, x.right())

    | let x: Qualify =>
      _show(g, x.left())
      _show(g, x.right())

    | let x: Call =>
      _show(g, x.callable())
      g.write("(")
      _show(g, x.args())
      if (x.args().list().size() > 0) and (x.named_args().list().size() > 0) then
        g.write(" ")
      end
      _show(g, x.named_args())
      g.write(")")

    | let x: CallFFI =>
      g.write("@")
      _show(g, x.name())
      try _show(g, x.type_args() as TypeArgs) end
      g.write("(")
      _show(g, x.args())
      if (x.args().list().size() > 0) and (x.named_args().list().size() > 0) then
        g.write(" ")
      end
      _show(g, x.named_args())
      g.write(")")
      try _show(g, x.partial() as Question) end

    | let x: Args =>
      for (i, a) in x.list().pairs() do
        if i > 0 then g.write(", ") end
        _show(g, a)
      end

    | let x: NamedArgs =>
      for (i, a) in x.list().pairs() do
        if i > 0 then g.write(", ") else g.write("where ") end
        _show(g, a)
      end

    | let x: NamedArg =>
      _show(g, x.name())
      g.write(" = ")
      _show(g, x.value())

    | let x: (IfDefAnd | IfDefOr) =>
      _show(g, x.left())

      g.write(
        match x
        | let _: IfDefAnd => " and "
        | let _: IfDefOr  => " or "
        end)

      _show(g, x.right())

    | let x: IfDefNot =>
      g.write("not ")
      _show(g, x.expr())

    | let x: IfDefFlag =>
      _show(g, x.name())

    | let x: (If | IfDef | IfType) =>
      match x
      | let i: If =>
        g.write("if ")
        _show_if[If](g, i)
      | let i: IfDef =>
        g.write("ifdef ")
        _show_if[IfDef](g, i)
      | let i: IfType =>
        g.write("iftype ")
        _show_if[IfType](g, i)
      end

    | let x: While =>
      g.line_start()
      g.write("while ")
      _show(g, x.condition())
      g.write(" do")
      g.push_indent()
      g.line_start()
      _show_bare(g, x.loop_body())
      g.pop_indent()
      g.line_start()
      match x.else_body() | let s: Sequence =>
        g.write("else")
        g.push_indent()
        g.line_start()
        _show_bare(g, s)
        g.pop_indent()
        g.line_start()
      end
      g.write("end")

    | let x: Repeat =>
      g.line_start()
      g.write("repeat")
      g.push_indent()
      g.line_start()
      _show_bare(g, x.loop_body())
      g.pop_indent()
      g.line_start()
      g.write("until ")
      _show(g, x.condition())
      match x.else_body() | let s: Sequence =>
        g.write(" else")
        g.push_indent()
        g.line_start()
        _show_bare(g, s)
        g.pop_indent()
        g.line_start()
      end
      g.line_start()
      g.write("end")

    | let x: For =>
      g.line_start()
      g.write("for ")
      _show(g, x.refs())
      g.write(" in ")
      _show(g, x.iterator())
      g.write(" do")
      g.push_indent()
      g.line_start()
      _show_bare(g, x.loop_body())
      g.pop_indent()
      g.line_start()
      match x.else_body() | let s: Sequence =>
        g.write("else")
        g.push_indent()
        g.line_start()
        _show_bare(g, s)
        g.pop_indent()
        g.line_start()
      end
      g.write("end")

    | let x: With =>
      g.line_start()
      g.write("with ")
      _show(g, x.assigns())
      g.write(" do")
      g.push_indent()
      g.line_start()
      _show_bare(g, x.body())
      g.pop_indent()
      g.line_start()
      match x.else_body() | let s: Sequence =>
        g.write("else")
        g.push_indent()
        g.line_start()
        _show_bare(g, s)
        g.pop_indent()
        g.line_start()
      end
      g.write("end")

    | let x: Match =>
      g.line_start()
      g.write("match ")
      _show(g, x.expr())
      g.line_start()
      _show(g, x.cases())
      g.line_start()
      match x.else_body() | let s: Sequence =>
        g.write("else")
        g.push_indent()
        g.line_start()
        _show_bare(g, s)
        g.pop_indent()
        g.line_start()
      end
      g.write("end")

    | let x: Cases =>
      var prev_body = true
      for c in x.list().values() do
        if prev_body then g.line_start() else g.write(" ") end
        _show(g, c)
        prev_body = try c.body() as Sequence; true else false end
      end

    | let x: Case =>
      g.write("| ")
      _show(g, x.expr())
      try
        let s = x.guard() as Sequence
        g.write(" if ")
        _show(g, s)
      end
      try
        let s = x.body() as Sequence
        g.write(" =>")
        g.push_indent()
        g.line_start()
        _show_bare(g, s)
        g.pop_indent()
        g.line_start()
      end

    | let x: Try =>
      g.write("try")
      g.push_indent()
      g.line_start()
      _show_bare(g, x.body())
      g.pop_indent()
      g.line_start()
      match x.else_body() | let s: Sequence =>
        g.write("else")
        g.push_indent()
        g.line_start()
        _show_bare(g, s)
        g.pop_indent()
        g.line_start()
      end
      g.line_start()
      match x.then_body() | let s: Sequence =>
        g.write("then")
        g.push_indent()
        g.line_start()
        _show_bare(g, s)
        g.pop_indent()
        g.line_start()
      end
      g.write("end")

    | let x: Lambda =>
      g.write("{")
      try _show(g, x.method_cap() as Cap); g.write(" ") end
      try _show(g, x.name() as Id) end
      try _show(g, x.type_params() as TypeParams) end
      _show(g, x.params())
      try _show(g, x.captures() as LambdaCaptures) end
      try let r = x.return_type() as Type; g.write(": "); _show(g, r) end
      try let q = x.partial() as Question; g.write(" "); _show(g, q) end
      g.write(" =>")
      g.push_indent()
      g.line_start()
      _show_bare(g, x.body())
      g.pop_indent()
      g.line_start()
      g.write("}")
      try let c = x.object_cap() as Cap; g.write(" "); _show(g, c) end

    | let x: LambdaCaptures =>
      g.write("(")
      for (i, c) in x.list().pairs() do
        if i > 0 then g.write(", ") end
        _show(g, c)
      end
      g.write(")")

    | let x: LambdaCapture =>
      _show(g, x.name())
      try let t = x.local_type() as Type; g.write(": "); _show(g, t) end
      try let v = x.value() as Expr; g.write(" = "); _show(g, v) end

    | let x: Object =>
      g.line_start()
      g.write("object")
      try let c = x.cap() as Cap; g.write(" "); _show(g, c) end
      try let p = x.provides() as Type; g.write(" is "); _show(g, p) end
      g.push_indent()
      try _show(g, x.members() as Members) end
      g.pop_indent()
      g.line_start()
      g.write("end")

    | let x: LitArray =>
      g.write("[")
      try let t = x.elem_type() as Type; g.write("as "); _show(g, t); g.write(":") end
      g.push_indent()
      for e in x.sequence().list().values() do
        g.line_start()
        _show(g, e)
      end
      g.pop_indent()
      if x.sequence().list().size() > 0 then g.line_start() end
      g.write("]")

    | let x: Reference => _show(g, x.name())
    | let x: DontCare => g.write("_")
    | let x: PackageRef => _show(g, x.name())
    | let x: MethodRef => None // TODO
    | let x: TypeRef => None // TODO
    | let x: FieldRef => None // TODO
    | let x: TupleElementRef => None // TODO
    | let x: LocalLetRef => _show(g, x.name())
    | let x: LocalVarRef => _show(g, x.name())
    | let x: ParamRef => _show(g, x.name())

    | let x: UnionType =>
      g.write("(")
      for (i, t) in x.list().pairs() do
        if i > 0 then g.write(" | ") end
        _show(g, t)
      end
      g.write(")")

    | let x: IsectType =>
      g.write("(")
      for (i, t) in x.list().pairs() do
        if i > 0 then g.write(" & ") end
        _show(g, t)
      end
      g.write(")")

    | let x: TupleType =>
      if x.list().size() > 1 then g.write("(") end
      for (i, t) in x.list().pairs() do
        if i > 0 then g.write(", ") end
        _show(g, t)
      end
      if x.list().size() > 1 then g.write(")") end

    | let x: ViewpointType =>
      _show(g, x.left())
      g.write("->")
      _show(g, x.right())

    | let x: LambdaType =>
      g.write("{")
      try _show(g, x.method_cap() as Cap) end
      try let n = x.name() as Id; g.write(" "); _show(g, n) end
      try _show(g, x.type_params() as TypeParams) end
      g.write("(")
      for (i, t) in x.param_types().list().pairs() do
        if i > 0 then g.write(", ") end
        _show(g, t)
      end
      g.write(")")
      try let t = x.return_type() as Type; g.write(": "); _show(g, t) end
      try let q = x.partial() as Question; g.write(" "); _show(g, q) end
      g.write("}")
      try let c = x.object_cap() as Cap; g.write(" "); _show(g, c) end
      try _show(g, x.cap_mod() as CapMod) end

    | let x: NominalType =>
      try _show(g, x.package() as Id); g.write(".") end
      _show(g, x.name())
      try _show(g, x.type_args() as TypeArgs) end
      try let c = x.cap() as (Cap | GenCap); g.write(" "); _show(g, c) end
      try _show(g, x.cap_mod() as CapMod) end

    | let x: TypeParamRef => None // TODO

    | let x: ThisType => g.write("this")
    | let x: DontCareType => g.write("_")

    | let x: Iso => g.write("iso")
    | let x: Trn => g.write("trn")
    | let x: Ref => g.write("ref")
    | let x: Val => g.write("val")
    | let x: Box => g.write("box")
    | let x: Tag => g.write("tag")

    | let x: CapRead  => g.write("#read")
    | let x: CapSend  => g.write("#send")
    | let x: CapShare => g.write("#share")
    | let x: CapAlias => g.write("#alias")
    | let x: CapAny   => g.write("#any")

    | let x: Aliased   => g.write("!")
    | let x: Ephemeral => g.write("^")
    | let x: At        => g.write("@")
    | let x: Question  => g.write("?")
    | let x: Ellipsis  => g.write("...")

    | let x: Id   => g.write(x.pos().string()) // TODO: less cheating, here and below...
    | let x: This => g.write("this")

    | let x: LitTrue      => g.write("true")
    | let x: LitFalse     => g.write("false")
    | let x: LitFloat     => g.write(x.pos().string())
    | let x: LitInteger   => g.write(x.pos().string())
    | let x: LitCharacter => g.write(x.pos().string()) // TODO: single-quote
    | let x: LitString    => g.write(x.pos().string()) // TODO: normal quote
    | let x: LitLocation  => g.write("__loc")

    // TODO: remove these defaults when everything is implemented:
    | let x: AST  => g.write("/*~" + x.string() + "~*/")
    end

  fun _show_if[A: (If val | IfDef val | IfType val)](g: _Gen, x: A) =>
    iftype A <: If val then
      _show(g, x.condition())
    elseif A <: IfDef val then
      _show(g, x.condition())
    elseif A <: IfType val then
      _show(g, x.sub())
      g.write(" <: ")
      _show(g, x.super())
    end
    g.write(" then")
    g.push_indent()
    g.line_start()
    _show_bare(g, x.then_body())

    g.pop_indent()
    g.line_start()
    iftype A <: If val then
      _show_ifelse[A](g, x.else_body())
    elseif A <: IfDef val then
      _show_ifelse[A](g, x.else_body())
    elseif A <: IfType val then
      _show_ifelse[A](g, x.else_body())
    end

  fun _show_ifelse[A: (If val | IfDef val | IfType val)](g: _Gen,
    x: (Sequence | A | None))
  =>
    match x
    | let s: Sequence =>
      g.write("else")
      g.push_indent()
      g.line_start()
      _show_bare(g, s)
      g.pop_indent()
      g.line_start()
      g.write("end")
    | let i: A =>
      g.write("elseif ")
      _show_if[A](g, i)
    else
      g.write("end")
    end

  fun _show_subsequence(g: _Gen, x: Sequence) =>
    if x.list().size() == 0 then return g.write("None") end

    g.write("(")
    for (i, expr) in x.list().pairs() do
      if i > 0 then g.write("; ") end
      _show(g, expr)
    end
    g.write(")")

  fun _show_bare(g: _Gen, x: Sequence) =>
    if x.list().size() == 0 then return g.write("None") end

    for (i, expr) in x.list().pairs() do
      g.line_start()
      _show(g, expr)
    end

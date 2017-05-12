
primitive ASTDefs
  fun apply(g: ASTGen) =>
    // Based on treecheckdef.h (at commit: a7babdf2)
    
    g.def("Program")
      .> with_scope()
      .> has("packages", "Array[Package]")
    
    g.def("Package")
      .> with_scope()
      .> has("modules", "Array[Module]",      "Array[Module]")
      .> has("docs",    "(LitString | None)", "None")
    
    g.def("Module")
      .> with_scope()
      .> has("use_decls",  "Array[UseDecl]",     "Array[UseDecl]")
      .> has("type_decls", "Array[TypeDecl]",    "Array[TypeDecl]")
      .> has("docs",       "(LitString | None)", "None")
    
    g.def("UsePackage")
      .> in_union("UseDecl")
      .> has("prefix",  "(Id | None)", "None")
      .> has("package", "String")
    
    g.def("UseFFIDecl")
      .> in_union("UseDecl")
      .> has("body",  "FFIDecl")
      .> has("guard", "(Expr | IfDefCond | None)", "None")
    
    g.def("FFIDecl")
      .> has("name",         "(Id | LitString)")
      .> has("return_type",  "TypeArgs")
      .> has("params",       "(Params | None)")
      .> has("named_params", "None") // TODO: why?
      .> has("partial",      "(Question | None)")
    
    for name in [
      "TypeAlias"; "Interface"; "Trait"; "Primitive"; "Struct"; "Class"; "Actor"
    ].values() do
      g.def(name)
        .> in_union("TypeDecl")
        .> has("name",        "Id")
        .> has("type_params", "(TypeParams | None)", "None")
        .> has("cap",         "(Cap | None)",        "None")
        .> has("provides",    "(Provides | None)",   "None")
        .> has("members",     "(Members | None)",    "None")
        .> has("at",          "(At | None)",         "None")
        .> has("docs",        "(LitString | None)",  "None")
    end
    
    g.def("Provides")
      .> has("types", "Array[Type]", "Array[Type]")
    
    g.def("Members")
      .> has("fields",  "Array[Field]",  "Array[Field]")
      .> has("methods", "Array[Method]", "Array[Method]")
    
    for name in ["FieldLet"; "FieldVar"; "FieldEmbed"].values() do
      g.def(name)
        .> in_union("Field")
        .> with_type()
        .> has("name",       "Id")
        .> has("field_type", "(Type | None)", "None")
        .> has("default",    "(Expr | None)", "None")
    end
    
    for name in ["MethodFun"; "MethodNew"; "MethodBe"].values() do
      g.def(name)
        .> in_union("Method")
        .> with_scope()
        .> has("cap",         "(Cap | None)",        "None")
        .> has("name",        "Id")
        .> has("type_params", "(TypeParams | None)", "None")
        .> has("params",      "(Params | None)",     "None")
        .> has("return_type", "(Type | None)",       "None")
        .> has("partial",     "(Question | None)",   "None")
        .> has("body",        "(RawExprSeq | None)", "None")
        .> has("docs",        "(LitString | None)",  "None")
        .> has("guard",       "(RawExprSeq | None)", "None")
    end
    
    g.def("TypeParams") // TODO: consider removing/inlining this type
      .> has("list", "Array[TypeParam]", "Array[TypeParam]")
    
    g.def("TypeParam")
      .> has("name",       "Id")
      .> has("constraint", "(Type | None)")
      .> has("default",    "(Type | None)")
    
    g.def("TypeArgs") // TODO: consider removing/inlining this type
      .> has("list", "Array[Type]", "Array[Type]")
    
    g.def("Params")
      .> has("list",     "Array[Param]",      "Array[Param]")
      .> has("ellipsis", "(Ellipsis | None)", "None")
    
    g.def("Param")
      .> with_type()
      .> has("name",       "Id")
      .> has("param_type", "(Type | None)", "None")
      .> has("default",    "(Expr | None)", "None")
    
    g.def("ExprSeq")
      .> with_scope()
      .> has("list", "Array[Expr]", "Array[Expr]")
    
    g.def("RawExprSeq")
      .> in_union("Expr")
      .> has("list", "Array[Expr]", "Array[Expr]")
    
    for name in ["Return"; "Break"; "Continue"; "Error"].values() do
      g.def(name)
        .> in_union("Jump", "Expr")
        .> has("value", "RawExprSeq") // TODO: consider using an Expr (here, and in ponyc)?
    end
    
    g.def("CompileIntrinsic")
      .> in_union("Expr")
    
    g.def("CompileError")
      .> in_union("Expr")
      .> with_type()                  // TODO: consider removing the type?
      .> has("message", "RawExprSeq") // TODO: consider using a LitString (here, and in ponyc)?
    
    for name in ["LocalLet"; "LocalVar"].values() do
      g.def(name)
        .> in_union("Local", "Expr")
        .> with_type()
        .> has("name",       "Id")
        .> has("local_type", "(Type | None)")
    end
    
    g.def("MatchCapture")
      .> in_union("Expr")
      .> with_type()
      .> has("name",       "Id")
      .> has("local_type", "Type")
    
    g.def("As")
      .> in_union("Expr")
      .> with_type()
      .> has("expr",    "Expr")
      .> has("as_type", "Type")
    
    g.def("Tuple")
      .> in_union("Expr")
      .> with_type()
      .> has("elements", "Array[RawExprSeq]", "Array[RawExprSeq]")
    
    g.def("Consume")
      .> in_union("Expr")
      .> with_type()
      .> has("cap",  "(Cap | None)")
      .> has("expr", "Expr")
    
    g.def("Recover")
      .> in_union("Expr")
      .> with_type()
      .> has("cap",  "(Cap | None)")
      .> has("expr", "Expr")
    
    for name in [
      "Not"; "Neg"; "NegUnsafe"; "AddressOf"; "DigestOf"
    ].values() do
      g.def(name)
        .> in_union("UnaryOp", "Expr")
        .> with_type()
        .> has("expr", "Expr")
    end
    
    for name in [
      "Add"; "AddUnsafe"; "Sub"; "SubUnsafe"
      "Mul"; "MulUnsafe"; "Div"; "DivUnsafe"; "Mod"; "ModUnsafe"
      "LShift"; "LShiftUnsafe"; "RShift"; "RShiftUnsafe"
      "Eq"; "EqUnsafe"; "NE"; "NEUnsafe"
      "LT"; "LTUnsafe"; "LE"; "LEUnsafe"
      "GE"; "GEUnsafe"; "GT"; "GTUnsafe"
      "Is"; "Isnt"; "And"; "Or"; "XOr"
    ].values() do
      g.def(name)
        .> in_union("BinaryOp", "Expr")
        .> with_type()
        .> has("left",  "Expr")
        .> has("right", "Expr")
    end
    
    g.def("Assign")
      .> in_union("Expr")
      .> with_type()
      .> has("right", "Expr")
      .> has("left",  "Expr")
    
    g.def("Dot")
      .> in_union("Expr")
      .> with_type()
      .> has("left",  "Expr")
      .> has("right", "(Id | LitInteger | TypeArgs)")
    
    g.def("Chain")
      .> in_union("Expr")
      .> with_type()
      .> has("left",  "Expr")
      .> has("right", "Id")
    
    g.def("Tilde")
      .> in_union("Expr")
      .> with_type()
      .> has("left",  "Expr")
      .> has("right", "Id")
    
    g.def("Qualify")
      .> in_union("Expr")
      .> has("left",  "Expr")
      .> has("right", "TypeArgs")
    
    g.def("Call")
      .> in_union("Expr")
      .> with_type()
      .> has("args",       "(Args | None)",      "None")
      .> has("named_args", "(NamedArgs | None)", "None")
      .> has("receiver",   "Expr")
    
    g.def("FFICall")
      .> in_union("Expr")
      .> with_type()
      .> has("name",       "(Id | LitString)")
      .> has("type_args",  "(TypeArgs | None)",  "None")
      .> has("args",       "(Args | None)",      "None")
      .> has("named_args", "(NamedArgs | None)", "None")
      .> has("partial",    "(Question | None)",  "None")
    
    g.def("Args")
      .> has("list", "Array[RawExprSeq]", "Array[RawExprSeq]")
    
    g.def("NamedArgs")
      .> has("list", "Array[NamedArg]", "Array[NamedArg]")
    
    g.def("NamedArg")
      .> has("name",  "Id")
      .> has("value", "RawExprSeq")
    
    g.def("IfDef")
      .> in_union("Expr")
      .> with_scope()
      .> with_type()
      .> has("then_expr", "(Expr | IfDefCond)")
      .> has("then_body", "ExprSeq")
      .> has("else_body", "(Expr | IfDef | None)")
      .> has("else_expr", "(None | IfDefCond)")
    
    for name in ["IfDefAnd"; "IfDefOr"].values() do
      g.def(name)
        .> in_union("IfDefBinaryOp", "IfDefCond")
        .> has("left",  "IfDefCond")
        .> has("right", "IfDefCond")
    end
    
    g.def("IfDefNot")
      .> in_union("IfDefCond")
      .> has("expr", "IfDefCond")
    
    g.def("IfDefFlag")
      .> in_union("IfDefCond")
      .> has("name", "Id")
    
    g.def("If")
      .> in_union("Expr")
      .> with_scope()
      .> with_type()
      .> has("condition", "RawExprSeq")
      .> has("then_body", "ExprSeq")
      .> has("else_body", "(ExprSeq | If | None)", "None")
    
    g.def("While")
      .> in_union("Expr")
      .> with_scope()
      .> with_type()
      .> has("condition", "RawExprSeq")
      .> has("loop_body", "ExprSeq")
      .> has("else_body", "(ExprSeq | None)", "None")
    
    g.def("Repeat")
      .> in_union("Expr")
      .> with_scope()
      .> with_type()
      .> has("loop_body", "ExprSeq")
      .> has("condition", "RawExprSeq")
      .> has("else_body", "(ExprSeq | None)", "None")
    
    g.def("For")
      .> in_union("Expr")
      // not a scope because sugar wraps it in a seq for us
      .> with_type()
      .> has("expr",      "ExprSeq")
      .> has("iterator",  "RawExprSeq")
      .> has("loop_body", "RawExprSeq")
      .> has("else_body", "(ExprSeq | None)", "None")
    
    g.def("With")
      .> in_union("Expr")
      .> with_type()
      .> has("refs",      "Expr")
      .> has("with_body", "RawExprSeq")
      .> has("else_body", "(RawExprSeq | None)", "None")
    
    g.def("Match")
      .> in_union("Expr")
      .> with_scope()
      .> with_type()
      .> has("expr",      "RawExprSeq")
      .> has("cases",     "(Cases | None)",   "None")
      .> has("else_body", "(ExprSeq | None)", "None")
    
    g.def("Cases")
      .> with_scope() // to simplify branch consolidation
      .> with_type()
      .> has("list", "Array[Case]", "Array[Case]")
    
    g.def("Case")
      .> with_scope()
      .> has("expr",  "(Expr | None)",       "None")
      .> has("guard", "(RawExprSeq | None)", "None")
      .> has("body",  "(RawExprSeq | None)", "None")
    
    g.def("Try")
      .> in_union("Expr")
      .> with_type()
      .> has("body",      "ExprSeq")
      .> has("else_body", "(ExprSeq | None)", "None")
      .> has("then_body", "(ExprSeq | None)", "None")
    
    g.def("Lambda")
      .> in_union("Expr")
      .> with_type()
      .> has("method_cap",  "(Cap | None)",            "None")
      .> has("name",        "(Id | None)",             "None")
      .> has("type_params", "(TypeParams | None)",     "None")
      .> has("params",      "(Params | None)",         "None")
      .> has("captures",    "(LambdaCaptures | None)", "None")
      .> has("return_type", "(Type | None)",           "None")
      .> has("partial",     "(Question | None)",       "None")
      .> has("body",        "(RawExprSeq)")
      .> has("object_cap",  "(Cap | None | Question)", "None")
    
    g.def("LambdaCaptures")
      .> has("list", "Array[LambdaCapture]", "Array[LambdaCapture]")
    
    g.def("LambdaCapture")
      .> has("name",       "Id")
      .> has("local_type", "(Type | None)", "None")
      .> has("expr",       "(Expr | None)", "None")
    
    g.def("Object")
      .> in_union("Expr")
      .> has("cap",      "(Cap | None)",      "None")
      .> has("provides", "(Provides | None)", "None")
      .> has("members",  "(Members | None)",  "None")
    
    g.def("LitArray")
      .> in_union("Expr")
      .> has("list", "Array[RawExprSeq]", "Array[RawExprSeq]")
    
    g.def("Reference")
      .> with_type()
      .> has("name", "Id")
      .> in_union("Expr")
    
    g.def("DontCare")
      .> with_type()
      .> in_union("Expr")
    
    g.def("PackageRef")
      .> has("name", "Id")
      .> in_union("Expr")
    
    for name in ["MethodFunRef"; "MethodNewRef"; "MethodBeRef"].values() do
      g.def(name)
        .> in_union("MethodRef", "Expr")
        .> with_scope()
        .> has("receiver", "Expr")
        .> has("name",     "(Id | TypeArgs)")
    end
    
    g.def("TypeRef")
      .> in_union("Expr")
      .> with_type()
      .> has("package", "Expr")
      .> has("name",    "(Id | TypeArgs)") // TODO: Why??
    
    for name in ["FieldLetRef"; "FieldVarRef"; "FieldEmbedRef"].values() do
      g.def(name)
        .> in_union("FieldRef", "Expr")
        .> with_type()
        .> has("receiver", "Expr")
        .> has("name",     "Id")
    end
    
    g.def("TupleElementRef")
      .> in_union("Expr")
      .> with_type()
      .> has("receiver", "Expr")
      .> has("name",     "LitInteger")
    
    for name in ["LocalLetRef"; "LocalVarRef"; "ParamRef"].values() do
      g.def(name)
        .> in_union("LocalRef", "Expr")
        .> with_type()
        .> has("name", "Id")
    end
    
    g.def("UnionType")
      .> in_union("Type")
      .> has("list", "Array[Type]", "Array[Type]")
    
    g.def("IsectType")
      .> in_union("Type")
      .> has("list", "Array[Type]", "Array[Type]")
    
    g.def("TupleType")
      .> in_union("Type")
      .> has("list", "Array[Type]", "Array[Type]")
    
    g.def("ArrowType")
      .> in_union("Type")
      .> has("left",  "Type")
      .> has("right", "Type")
    
    g.def("FunType")
      .> in_union("Type")
      .> has("cap",         "Cap")
      .> has("type_params", "(TypeParams | None)", "None")
      .> has("params",      "(Params | None)",     "None")
      .> has("return_type", "(Type | None)",       "None")
    
    g.def("LambdaType")
      .> in_union("Type")
      .> has("method_cap",  "(Cap | None)",          "None")
      .> has("name",        "(Id | None)",           "None")
      .> has("type_params", "(TypeParams | None)",   "None")
      .> has("param_types", "Array[Type]",           "Array[Type]")
      .> has("return_type", "(Type | None)",         "None")
      .> has("partial",     "(Question | None)",     "None")
      .> has("object_cap",  "(Cap | GenCap | None)", "None")
      .> has("cap_mod",     "(CapMod | None)",       "None")
    
    g.def("NominalType")
      .> in_union("Type")
      .> has("package",   "(Id | None)",           "None")
      .> has("name",      "Id")
      .> has("type_args", "(TypeArgs | None)",     "None")
      .> has("cap",       "(Cap | GenCap | None)", "None")
      .> has("cap_mod",   "(CapMod | None)",       "None")
    
    g.def("TypeParamRef")
      .> in_union("Type")
      .> has("name",    "Id")
      .> has("cap",     "(Cap | GenCap | None)", "None")
      .> has("cap_mod", "(CapMod | None)",       "None")
    
    g.def("ThisType")
      .> in_union("Type")
    
    g.def("DontCareType")
      .> in_union("Type")
    
    g.def("ErrorType")
      .> in_union("Type")
    
    g.def("LiteralType")
      .> in_union("Type")
    
    g.def("LiteralTypeBranch")
      .> in_union("Type")
    
    g.def("OpLiteralType")
      .> in_union("Type")
    
    for name in ["Iso"; "Trn"; "Ref"; "Val"; "Box"; "Tag"].values() do
      g.def(name)
        .> in_union("Cap")
    end
    
    for name in [
      "CapRead"; "CapSend"; "CapShare"; "CapAlias"; "CapAny"
    ].values() do
      g.def(name)
        .> in_union("GenCap")
    end
    
    for name in ["Aliased"; "Ephemeral"].values() do
      g.def(name)
        .> in_union("CapMod")
    end
    
    g.def("At")
    
    g.def("Question")
    
    g.def("Ellipsis")
    
    g.def_wrap("Id", "String")
      .> in_union("Expr")
    
    g.def("This")
      .> in_union("Expr")
    
    for name in ["LitTrue"; "LitFalse"].values() do
      g.def(name)
        .> in_union("LitBool", "Expr")
    end
    
    g.def_wrap("LitFloat", "F64")
      .> in_union("Expr")
    
    g.def_wrap("LitInteger", "I128")
      .> in_union("Expr")
    
    g.def_wrap("LitCharacter", "U8")
      .> in_union("Expr")
    
    g.def_wrap("LitString", "String")
      .> in_union("Expr")
    
    g.def("LitLocation")
      .> in_union("Expr")
      .> with_type()
    
    for name in [
      "EOF"
      "LexError"
      "NewLine"
      "Use"
      "Colon"
      "Semicolon"
      "Comma"
      "Constant"
      "Pipe"
      "Ampersand"
      "Arrow"
      "DoubleArrow"
      "Backslash"
      "LParen"
      "RParen"
      "LBrace"
      "RBrace"
      "LSquare"
      "RSquare"
      "LParenNew"
      "LBraceNew"
      "LSquareNew"
      "SubNew"
      "SubUnsafeNew"
      "In"
      "Until"
      "Do"
      "Else"
      "ElseIf"
      "Then"
      "End"
      "Var"
      "Let"
      "Embed"
      "Where"
    ].values() do
      g.def(name)
        .> in_union("Lexeme")
    end

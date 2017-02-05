
primitive ASTDefs
  fun apply(g: ASTGen) =>
    // Based on treecheckdef.h (at commit: a7babdf2)
    
    g.def("Program").>todo()
    g.def("Package").>todo()
    g.def("Module").>todo()
    
    g.def("Use")
      .> has("prefix", "(Id | None)")
      .> has("body",   "(FFIDecl | None)")
      .> has("guard",  "(Expr | IfDefCond | None)")
    
    g.def("FFIDecl")
      .> has("name",         "(Id | LitString)")
      .> has("return_type",  "TypeArgs")
      .> has("params",       "(Params | None)")
      .> has("named_params", "None")
      .> has("partial",      "(Question | None)")
    
    for name in [
      "TypeAlias", "Interface", "Trait", "Primitive", "Struct", "Class", "Actor"
    ].values() do
      g.def(name)
        .> in_union("Type")
        .> has("name",        "Id")
        .> has("type_params", "(TypeParams | None)", "None")
        .> has("cap",         "(Cap | None)",        "None")
        .> has("provides",    "(Provides | None)",   "None")
        .> has("members",     "(Members | None)",    "None")
        .> has("at",          "(At | None)",         "None")
        .> has("docs",        "(LitString | None)",  "None")
    end
    
    g.def("Provides").>todo()
    g.def("Members").>todo()
    
    for name in ["FieldLet", "FieldVar", "FieldEmbed"].values() do
      g.def(name)
        .> in_union("Field")
        .> with_type()
        .> has("name",       "Id")
        .> has("field_type", "(TypePtr | None)", "None")
        .> has("default",    "(Expr | None)",    "None")
    end
    
    for name in ["MethodFun", "MethodNew", "MethodBe"].values() do
      g.def(name)
        .> in_union("Method")
        .> with_scope()
        .> has("cap",         "(Cap | None)",        "None")
        .> has("name",        "Id")
        .> has("type_params", "(TypeParams | None)", "None")
        .> has("params",      "(Params | None)",     "None")
        .> has("return_type", "(TypePtr | None)",    "None")
        .> has("partial",     "(Question | None)",   "None")
        .> has("body",        "(RawExprSeq | None)", "None")
        .> has("docs",        "(LitString | None)",  "None")
        .> has("guard",       "(RawExprSeq | None)", "None")
    end
    
    g.def("TypeParams").>todo()
    
    g.def("TypeParam")
      .> has("name",       "Id")
      .> has("constraint", "(TypePtr | None)")
      .> has("default",    "(TypePtr | None)")
    
    g.def("TypeArgs").>todo()
    
    g.def("Params").>todo()
    
    g.def("Param")
      .> with_type()
      .> has("name",       "Id")
      .> has("param_type", "(TypePtr | None)")
      .> has("default",    "(Expr | None)")
    
    g.def("ExprSeq").>todo()
    g.def("RawExprSeq").>todo()
    
    for name in ["Return", "Break", "Continue", "Error"].values() do
      g.def(name).>todo()
    end
    
    g.def("CompileError").>todo()
    g.def("Expr").>todo()
    
    for name in ["LocalLet", "LocalVar"].values() do
      g.def(name)
        .> in_union("Local")
        .> with_type()
        .> has("name",       "Id")
        .> has("local_type", "(TypePtr | None)")
    end
    
    g.def("MatchCapture")
      .> with_type()
      .> has("name",       "Id")
      .> has("match_type", "TypePtr")
    
    g.def("Infix").>todo()
    
    g.def("As")
      .> with_type()
      .> has("expr",    "Expr")
      .> has("as_type", "TypePtr")
    
    g.def("Tuple").>todo()
    
    g.def("Consume")
      .> with_type()
      .> has("cap",  "(Cap | Aliased | None)")
      .> has("expr", "Expr")
    
    g.def("Recover")
      .> with_type()
      .> has("cap",   "(Cap | None)")
      .> has("block", "Expr")
    
    for name in [
      "Not", "UMinus", "UMinusUnsafe", "AddressOf", "DigestOf"
    ].values() do
      g.def(name)
        .> in_union("UnaryOperator")
        .> with_type()
        .> has("expr", "Expr")
    end
    
    g.def("Dot")
      .> with_type()
      .> has("left",  "Expr")
      .> has("right", "(Id | LitInteger | TypeArgs)")
    
    g.def("Tilde")
      .> with_type()
      .> has("left",  "Expr")
      .> has("right", "Id")
    
    g.def("Qualify")
      .> has("left",  "Expr")
      .> has("right", "TypeArgs")
    
    g.def("Call")
      .> with_type()
      .> has("args",       "(Args | None)",      "None")
      .> has("named_args", "(NamedArgs | None)", "None")
      .> has("receiver",   "Expr")
    
    g.def("FFICall")
      .> with_type()
      .> has("name",       "(Id | LitString)")
      .> has("type_args",  "(TypeArgs | None)",  "None")
      .> has("args",       "(Args | None)",      "None")
      .> has("named_args", "(NamedArgs | None)", "None")
      .> has("partial",    "(Question | None)",  "None")
    
    g.def("Args").>todo()
    g.def("NamedArgs").>todo()
    
    g.def("NamedArg")
      .> has("name",  "Id")
      .> has("value", "RawExprSeq")
    
    g.def("IfDef")
      .> with_scope()
      .> with_type()
      .> has("then_expr", "(Expr | IfDefCond)")
      .> has("then_body", "ExprSeq")
      .> has("else_body", "(Expr | IfDef | None)")
      .> has("else_expr", "(None | IfDefCond)")
    
    g.def("IfDefCond").>todo()
    
    g.def("IfDefInfix")
      .> has("left",  "IfDefCond")
      .> has("right", "IfDefCond")
    
    g.def("IfDefNot")
      .> has("expr", "IfDefCond")
    
    g.def("IfDefFlag")
      .> has("name", "Id")
    
    g.def("If")
      .> with_scope()
      .> with_type()
      .> has("condition", "RawExprSeq")
      .> has("then_body", "ExprSeq")
      .> has("else_body", "(ExprSeq | If | None)", "None")
    
    g.def("While")
      .> with_scope()
      .> with_type()
      .> has("condition", "RawExprSeq")
      .> has("loop_body", "ExprSeq")
      .> has("else_body", "(ExprSeq | None)", "None")
    
    g.def("Repeat")
      .> with_scope()
      .> with_type()
      .> has("loop_body", "ExprSeq")
      .> has("condition", "RawExprSeq")
      .> has("else_body", "(ExprSeq | None)", "None")
    
    g.def("For")
      // not a scope because sugar wraps it in a seq for us
      .> with_type()
      .> has("expr",      "ExprSeq")
      .> has("iterator",  "RawExprSeq")
      .> has("loop_body", "RawExprSeq")
      .> has("else_body", "(ExprSeq | None)", "None")
    
    g.def("With")
      .> with_type()
      .> has("refs",      "Expr")
      .> has("with_body", "RawExprSeq")
      .> has("else_body", "(RawExprSeq | None)", "None")
    
    g.def("Match")
      .> with_scope()
      .> with_type()
      .> has("expr",      "RawExprSeq")
      .> has("cases",     "(Cases | None)",   "None")
      .> has("else_body", "(ExprSeq | None)", "None")
    
    g.def("Cases").>todo()
      .> with_scope() // to simplify branch consolidation
    
    g.def("Case")
      .> with_scope()
      .> has("expr",  "(Expr | None)",       "None")
      .> has("guard", "(RawExprSeq | None)", "None")
      .> has("body",  "(RawExprSeq | None)", "None")
    
    g.def("Try")
      .> with_type()
      .> has("body",      "ExprSeq")
      .> has("else_body", "(ExprSeq | None)", "None")
      .> has("then_body", "(ExprSeq | None)", "None")
    
    g.def("Lambda")
      .> with_type()
      .> has("method_cap",  "(Cap | None)",            "None")
      .> has("name",        "(Id | None)",             "None")
      .> has("type_params", "(TypeParams | None)",     "None")
      .> has("params",      "(Params | None)",         "None")
      .> has("captures",    "(LambdaCaptures | None)", "None")
      .> has("return_type", "(TypePtr | None)",        "None")
      .> has("partial",     "(Question | None)",       "None")
      .> has("body",        "(RawExprSeq)")
      .> has("object_cap",  "(Cap | None | Question)", "None")
    
    g.def("LambdaCaptures").>todo()
    
    g.def("LambdaCapture")
      .> has("name",       "Id")
      .> has("local_type", "(TypePtr | None)", "None")
      .> has("expr",       "(Expr | None)",    "None")
    
    g.def("LitArray").>todo()
    
    g.def("Object")
      .> has("cap",      "(Cap | None)",      "None")
      .> has("provides", "(Provides | None)", "None")
      .> has("members",  "(Members | None)",  "None")
    
    g.def("Reference")
      .> with_type()
      .> has("name", "Id")
    
    g.def("PackageRef")
      .> has("name", "Id")
    
    for name in ["MethodFunRef", "MethodNewRef", "MethodBeRef"].values() do
      g.def(name)
        .> in_union("MethodRef")
        .> with_scope()
        .> has("receiver", "Expr")
        .> has("name",     "(Id, TypeArgs)")
    end
    
    g.def("TypeRef")
      .> with_type()
      .> has("package", "Expr")
      .> has("name",    "(Id, TypeArgs)") // TODO: Why??
    
    for name in ["FieldLetRef", "FieldVarRef", "FieldEmbedRef"].values() do
      g.def(name)
        .> in_union("FieldRef")
        .> with_type()
        .> has("receiver", "Expr")
        .> has("name",     "Id")
    end
    
    g.def("TupleElementRef")
      .> with_type()
      .> has("receiver", "Expr")
      .> has("name",     "LitInteger")
    
    for name in ["LocalLetRef", "LocalVarRef", "ParamRef"].values() do
      g.def(name)
        .> in_union("LocalRef")
        .> with_type()
        .> has("name", "Id")
    end
    
    g.def("TypePtr").>todo()
    
    g.def("UnionType").>todo()
    g.def("IsectType").>todo()
    g.def("TupleType").>todo()
    
    g.def("ArrowType")
      .> has("left",  "TypePtr")
      .> has("right", "TypePtr")
    
    g.def("FunType")
      .> has("cap",         "Cap")
      .> has("type_params", "(TypeParams | None)", "None")
      .> has("params",      "(Params | None)",     "None")
      .> has("return_type", "(TypePtr | None)",    "None")
    
    g.def("LambdaType")
      .> has("method_cap",  "(Cap | None)",          "None")
      .> has("name",        "(Id | None)",           "None")
      .> has("type_params", "(TypeParams | None)",   "None")
      .> has("params",      "(TypePtrList | None)",  "None")
      .> has("return_type", "(TypePtr | None)",      "None")
      .> has("partial",     "(Question | None)",     "None")
      .> has("object_cap",  "(Cap | GenCap | None)", "None")
      .> has("cap_mod",     "(CapMod | None)",       "None")
    
    g.def("TypePtrList").>todo()
    
    g.def("NominalType")
      .> has("package",   "(Id | None)",           "None")
      .> has("name",      "Id")
      .> has("type_args", "(TypeArgs | None)",     "None")
      .> has("cap",       "(Cap | GenCap | None)", "None")
      .> has("cap_mod",   "(CapMod | None)",       "None")
    
    g.def("TypeParamRef")
      .> has("name",    "Id")
      .> has("cap",     "(Cap | GenCap | None)", "None")
      .> has("cap_mod", "(CapMod | None)",       "None")
    
    g.def("At").>todo()
    
    for name in ["True", "False"].values() do
      g.def(name)
        .> in_union("LitBool")
    end
    
    for name in ["Iso", "Trn", "Ref", "Val", "Box", "Tag"].values() do
      g.def(name)
        .> in_union("Cap")
    end
    
    for name in ["Aliased", "Ephemeral"].values() do
      g.def(name)
        .> in_union("CapMod")
    end
    
    for name in [
      "CtrlTypeIf", "CtrlTypeCases", "CtrlTypeReturn", "CtrlTypeBreak",
      "CtrlTypeContinue", "CtrlTypeError", "CtrlTypeCompileError",
      "CtrlTypeCompileIntrinsic"
    ].values() do
      g.def(name)
        .> in_union("CtrlType")
    end
    
    g.def("DontCareType")
    g.def("Ellipsis")
    g.def("ErrorType")
    
    for name in [
      "CapRead", "CapSend", "CapShare", "CapAlias", "CapAny"
    ].values() do
      g.def(name)
        .> in_union("GenCap")
    end
    
    g.def_wrap("Id", "String")
    g.def_wrap("LitFloat", "F64")
    g.def_wrap("LitInteger", "I128")
    g.def_wrap("LitString", "String")
    
    g.def("LitLocation").>todo()
    g.def("LiteralType").>todo() // TODO: Why??
    g.def("LiteralTypeBranch").>todo() // TODO: Why??
    g.def("OpLiteralType").>todo() // TODO: Why??
    g.def("Question")
    g.def("Semi") // TODO: Why??
    g.def("This")
    g.def("ThisType")

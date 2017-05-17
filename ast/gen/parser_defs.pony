
primitive ParserDefs
  fun apply(g: ParserGen) =>
    // Based on parser.c (at commit: 4daf438)
    
    // Precedence
    //
    // We do not support precedence of infix operators, since that leads to many
    // bugs. Instead we require the use of parentheses to disambiguiate operator
    // interactions. This is checked in the parse fix pass, so we treat all infix
    // operators as having the same precedence during parsing.
    //
    // Overall, the precedences built into the below grammar are as follows.
    //
    // Value operators:
    //   postfix (eg . call) - highest precedence, most tightly binding
    //   prefix (eg not consume)
    //   infix (eg + <<)
    //   assignment (=) - right associative
    //   sequence (consecutive expressions)
    //   tuple elements (,) - lowest precedence
    //
    // Type operators:
    //   viewpoint (->) - right associative, highest precedence
    //   infix (& |)
    //   tuple elements (,) - lowest precedence
    
    g.def("root")
      .> rule("module", ["module"])
    
    // {use} {class}
    g.def("module")
      .> tree("Tk[Module]")
      .> opt_token("package docstring", ["Tk[LitString]"])
      .> seq("use command", ["use"])
      .> seq("type, interface, trait, primitive, class or actor definition", ["type_decl"])
      .> skip("type, interface, trait, primitive, class, actor, member or method", ["Tk[EOF]"])
      // TODO: REORDER so that docstring is the final child
    
    // USE (use_package | use_ffi_decl)
    g.def("use")
      .> restart(["Tk[Use]"; "Tk[TypeAlias]"; "Tk[Interface]"; "Tk[Trait]"; "Tk[Primitive]"; "Tk[Struct]"; "Tk[Class]"; "Tk[Actor]"])
      .> skip("None", ["Tk[Use]"])
      .> rule("package or ffi declaration", ["use_package"; "use_ffi_decl"])
    
    // [ID ASSIGN] STRING
    g.def("use_package")
      .> tree("Tk[UsePackage]")
      .> opt_rule("package name assignment", ["use_package_name"])
      .> token("package path", ["Tk[LitString]"])
    
    // ID ASSIGN
    g.def("use_package_name")
      .> print_inline()
      .> token("None", ["Tk[Id]"])
      .> skip("None", ["Tk[Assign]"])
    
    // AT (ID | STRING) typeparams (LPAREN | LPAREN_NEW) [params] RPAREN [QUESTION] [IF infix]
    g.def("use_ffi_decl")
      .> tree("Tk[UseFFIDecl]")
      .> skip("None", ["Tk[At]"])
      .> token("ffi name", ["Tk[Id]"; "Tk[LitString]"])
      .> rule("return type", ["typeargs"])
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> opt_rule("ffi parameters", ["params"])
      .> skip("None", ["Tk[RParen]"])
      .> opt_token("None", ["Tk[Question]"])
      .> if_token_then_rule("Tk[If]", "use condition", ["infix"])
    
    // (TYPE | INTERFACE | TRAIT | PRIMITIVE | STRUCT | CLASS | ACTOR) [annotations]
    // [AT] ID [typeparams] [CAP] [IS type] [STRING] members
    g.def("type_decl")
      .> restart(["Tk[TypeAlias]"; "Tk[Interface]"; "Tk[Trait]"; "Tk[Primitive]"; "Tk[Struct]"; "Tk[Class]"; "Tk[Actor]"])
      .> token("entity", ["Tk[TypeAlias]"; "Tk[Interface]"; "Tk[Trait]"; "Tk[Primitive]"; "Tk[Struct]"; "Tk[Class]"; "Tk[Actor]"])
      .> annotate()
      .> opt_token("None", ["Tk[At]"])
      .> opt_rule("capability", ["cap"])
      .> token("name", ["Tk[Id]"])
      .> opt_rule("type parameters", ["typeparams"])
      .> if_token_then_rule("Tk[Is]", "provided type", ["type"])
      .> opt_token("docstring", ["Tk[LitString]"])
      .> rule("members", ["members"])
      // Order should be:
      // id cap type_params provides members c_api docstring
      // TODO: REORDER(2, 1, 3, 4, 6, 0, 5)
    
    // {field} {method}
    g.def("members")
      .> tree("Tk[Members]")
      .> seq("field", ["field"])
      .> seq("method", ["method"])
    
    // (VAR | LET | EMBED) ID [COLON type] [ASSIGN infix]
    g.def("field")
      .> token("None", ["Tk[Var]"; "Tk[Let]"; "Tk[Embed]"])
      // TODO: MAP_ID("Tk[Var]", "Tk[FieldVar]")
      // TODO: MAP_ID("Tk[Let]", "Tk[FieldLet]")
      // TODO: MAP_ID("Tk[Embed]", "Tk[FieldEmbed]")
      .> token("field name", ["Tk[Id]"])
      .> skip("mandatory type declaration on field", ["Tk[Colon]"])
      .> rule("field type", ["type"])
      .> if_token_then_rule("Tk[Assign]", "field value", ["infix"])
    
    // (FUN | BE | NEW) [annotations] [CAP] ID [typeparams] (LPAREN | LPAREN_NEW)
    // [params] RPAREN [COLON type] [QUESTION] [ARROW rawseq]
    g.def("method")
      .> token("None", ["Tk[MethodFun]"; "Tk[MethodBe]"; "Tk[MethodNew]"])
      .> annotate()
      .> opt_rule("capability", ["cap"])
      .> token("method name", ["Tk[Id]"])
      .> opt_rule("type parameters", ["typeparams"])
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> opt_rule("parameters", ["params"])
      .> skip("None", ["Tk[RParen]"])
      .> if_token_then_rule("Tk[Colon]", "return type", ["type"])
      .> opt_token("None", ["Tk[Question]"])
      .> if_token_then_rule("Tk[If]", "guard expression", ["rawseq"])
      .> opt_token("None", ["Tk[LitString]"])
      .> if_token_then_rule("Tk[DoubleArrow]", "method body", ["rawseq"])
      // Order should be:
      // cap id type_params params return_type error guard body docstring
      // TODO: REORDER(0, 1, 2, 3, 4, 5, 6, 8, 7)
    
    // postfix [COLON type] [ASSIGN infix]
    g.def("param")
      .> tree("Tk[Param]")
      .> rule("name", ["parampattern"])
      .> if_token_then_rule("Tk[Colon]", "parameter type", ["type"])
      // TODO: UNWRAP(0, "Tk[Reference]")
      .> if_token_then_rule("Tk[Assign]", "default value", ["infix"])
    
    // ELLIPSIS
    g.def("ellipsis")
      .> token("None", ["Tk[Ellipsis]"])
    
    // TRUE | FALSE | INT | FLOAT | STRING
    g.def("literal")
      .> token("literal", ["Tk[LitTrue]"; "Tk[LitFalse]"; "Tk[LitInteger]"; "Tk[LitFloat]"; "Tk[LitString]"; "Tk[LitCharacter]"])
    
    // HASH postfix
    g.def("const_expr")
      .> print_inline()
      .> token("None", ["Tk[Constant]"])
      .> rule("formal argument value", ["postfix"])
    
    // literal
    g.def("typeargliteral")
      .> tree("Tk[Constant]")
      .> print_inline()
      .> rule("type argument", ["literal"])
    
    // HASH postfix
    g.def("typeargconst")
      .> tree("Tk[Constant]")
      .> print_inline()
      .> rule("formal argument value", ["const_expr"])
    
    // type | typeargliteral | typeargconst
    g.def("typearg")
      .> rule("type argument", ["type"; "typeargliteral"; "typeargconst"])
    
    // ID [COLON type] [ASSIGN typearg]
    g.def("typeparam")
      .> tree("Tk[TypeParam]")
      .> token("name", ["Tk[Id]"])
      .> if_token_then_rule("Tk[Colon]", "type constraint", ["type"])
      .> if_token_then_rule("Tk[Assign]", "default type argument", ["typearg"])
    
    // param {COMMA param}
    g.def("params")
      .> tree("Tk[Params]")
      .> rule("parameter", ["param"; "ellipsis"])
      .> while_token_do_rule("Tk[Comma]", "parameter", ["param"; "ellipsis"])
    
    // LSQUARE typeparam {COMMA typeparam} RSQUARE
    g.def("typeparams")
      .> tree("Tk[TypeParams]")
      .> skip("None", ["Tk[LSquare]"; "Tk[LSquareNew]"])
      .> rule("type parameter", ["typeparam"])
      .> while_token_do_rule("Tk[Comma]", "type parameter", ["typeparam"])
      .> terminate("type parameters", ["Tk[RSquare]"])
    
    // LSQUARE type {COMMA type} RSQUARE
    g.def("typeargs")
      .> tree("Tk[TypeArgs]")
      .> skip("None", ["Tk[LSquare]"])
      .> rule("type argument", ["typearg"])
      .> while_token_do_rule("Tk[Comma]", "type argument", ["typearg"])
      .> terminate("type arguments", ["Tk[RSquare]"])
    
    // CAP
    g.def("cap")
      .> token("capability", ["Tk[Iso]"; "Tk[Trn]"; "Tk[Ref]"; "Tk[Val]"; "Tk[Box]"; "Tk[Tag]"])
    
    // GENCAP
    g.def("gencap")
      .> token("generic capability", ["Tk[CapRead]"; "Tk[CapSend]"; "Tk[CapShare]"; "Tk[CapAlias]"; "Tk[CapAny]"])
    
    // ID [DOT ID] [typeargs] [CAP] [EPHEMERAL | ALIASED]
    g.def("nominal")
      .> tree("Tk[NominalType]")
      .> token("name", ["Tk[Id]"])
      // TODO: IFELSE("Tk[Dot]",
      //   TOKEN("name", "Tk[Id]"),
      //   .> tree("Tk[None]")
      //   REORDER(1, 0)
      // )
      .> opt_rule("type arguments", ["typeargs"])
      .> opt_rule("capability", ["cap"; "gencap"])
      .> opt_token("None", ["Tk[Ephemeral]"; "Tk[Aliased]"])
    
    // PIPE type
    g.def("uniontype")
      .> builder("_BuildInfix")
      .> tree("Tk[UnionType]")
      .> skip("None", ["Tk[Pipe]"])
      .> rule("type", ["type"])
    
    // AMP type
    g.def("isecttype")
      .> builder("_BuildInfix")
      .> tree("Tk[IsectType]")
      .> skip("None", ["Tk[Ampersand]"])
      .> rule("type", ["type"])
    
    // type {uniontype | isecttype}
    g.def("infixtype")
      .> rule("type", ["type"])
      .> seq("type", ["uniontype"; "isecttype"])
    
    // COMMA infixtype {COMMA infixtype}
    g.def("tupletype")
      .> builder("_BuildInfix")
      .> token("None", ["Tk[Comma]"])
      // TODO: MAP_ID("Tk[Comma]", "Tk[TupleType]")
      .> rule("type", ["infixtype"])
      .> while_token_do_rule("Tk[Comma]", "type", ["infixtype"])
    
    // (LPAREN | LPAREN_NEW) infixtype [tupletype] RPAREN
    g.def("groupedtype")
      .> print_inline()
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> rule("type", ["infixtype"])
      .> opt_no_dflt_rule("type", ["tupletype"])
      .> skip("None", ["Tk[RParen]"])
      // TODO: deal with SET_FLAG(AST_FLAG_IN_PARENS)
    
    // THIS
    g.def("thistype")
      .> print_inline()
      .> tree("Tk[ThisType]")
      .> skip("None", ["Tk[This]"])
    
    // type (COMMA type)*
    g.def("typelist")
      .> print_inline()
      .> tree("Tk[Params]")
      .> rule("parameter type", ["type"])
      .> while_token_do_rule("Tk[Comma]", "parameter type", ["type"])
    
    // LBRACE [CAP] [ID] [typeparams] (LPAREN | LPAREN_NEW) [typelist] RPAREN
    // [COLON type] [QUESTION] RBRACE [CAP] [EPHEMERAL | ALIASED]
    g.def("lambdatype")
      .> tree("Tk[LambdaType]")
      .> skip("None", ["Tk[LBrace]"])
      .> opt_rule("capability", ["cap"])
      .> opt_token("function name", ["Tk[Id]"])
      .> opt_rule("type parameters", ["typeparams"])
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> opt_rule("parameters", ["typelist"])
      .> skip("None", ["Tk[RParen]"])
      .> if_token_then_rule("Tk[Colon]", "return type", ["type"])
      .> opt_token("None", ["Tk[Question]"])
      .> skip("None", ["Tk[RBrace]"])
      .> opt_rule("capability", ["cap"; "gencap"])
      .> opt_token("None", ["Tk[Ephemeral]"; "Tk[Aliased]"])
    
    // (thistype | cap | typeexpr | nominal | lambdatype)
    g.def("atomtype")
      .> rule("type", ["thistype"; "cap"; "groupedtype"; "nominal"; "lambdatype"])
    
    // ARROW type
    g.def("viewpoint")
      .> print_inline()
      .> builder("_BuildInfix")
      .> token("None", ["Tk[Arrow]"])
      .> rule("viewpoint", ["type"])
    
    // atomtype [viewpoint]
    g.def("type")
      .> rule("type", ["atomtype"])
      .> opt_no_dflt_rule("viewpoint", ["viewpoint"])
    
    // ID [$updatearg] ASSIGN rawseq
    g.def("namedarg")
      .> tree("Tk[NamedArg]")
      .> token("argument name", ["Tk[Id]"])
      .> skip("None", ["Tk[Assign]"])
      .> rule("argument value", ["rawseq"])
    
    // WHERE namedarg {COMMA namedarg}
    g.def("named")
      .> tree("Tk[NamedArgs]")
      .> skip("None", ["Tk[Where]"])
      .> rule("named argument", ["namedarg"])
      .> while_token_do_rule("Tk[Comma]", "named argument", ["namedarg"])
    
    // rawseq {COMMA rawseq}
    g.def("positional")
      .> tree("Tk[Args]")
      .> rule("argument", ["rawseq"])
      .> while_token_do_rule("Tk[Comma]", "argument", ["rawseq"])
    
    // '\' ID {COMMA ID} '\'
    g.def("annotations")
      .> print_inline()
      .> token("None", ["Tk[Backslash]"])
      .> token("annotation", ["Tk[Id]"])
      .> while_token_do_token("Tk[Comma]", "annotation", ["Tk[Id]"])
      .> terminate("annotations", ["Tk[Backslash]"])
    
    // OBJECT [annotations] [CAP] [IS type] members END
    g.def("object")
      .> print_inline()
      .> token("None", ["Tk[Object]"])
      .> annotate()
      .> opt_rule("capability", ["cap"])
      .> if_token_then_rule("Tk[Is]", "provided type", ["type"])
      .> rule("object member", ["members"])
      .> terminate("object literal", ["Tk[End]"])
    
    // ID [COLON type] [ASSIGN infix]
    g.def("lambdacapture")
      .> tree("Tk[LambdaCapture]")
      .> token("name", ["Tk[Id]"])
      .> if_token_then_rule("Tk[Colon]", "capture type", ["type"])
      .> if_token_then_rule("Tk[Assign]", "capture value", ["infix"])
    
    // (LPAREN | LPAREN_NEW) (lambdacapture | thisliteral)
    // {COMMA (lambdacapture | thisliteral)} RPAREN
    g.def("lambdacaptures")
      .> tree("Tk[LambdaCaptures]")
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> rule("capture", ["lambdacapture"; "thisliteral"])
      .> while_token_do_rule("Tk[Comma]", "capture", ["lambdacapture"; "thisliteral"])
      .> skip("None", ["Tk[RParen]"])
    
    // LBRACE [annotations] [CAP] [ID] [typeparams] (LPAREN | LPAREN_NEW) [params]
    // RPAREN [lambdacaptures] [COLON type] [QUESTION] ARROW rawseq RBRACE [CAP]
    g.def("lambda")
      .> print_inline()
      .> tree("Tk[Lambda]")
      .> skip("None", ["Tk[LBrace]"])
      .> annotate()
      .> opt_rule("receiver capability", ["cap"])
      .> opt_token("function name", ["Tk[Id]"])
      .> opt_rule("type parameters", ["typeparams"])
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> opt_rule("parameters", ["params"])
      .> skip("None", ["Tk[RParen]"])
      .> opt_rule("captures", ["lambdacaptures"])
      .> if_token_then_rule("Tk[Colon]", "return type", ["type"])
      .> opt_token("None", ["Tk[Question]"])
      .> skip("None", ["Tk[DoubleArrow]"])
      .> rule("lambda body", ["rawseq"])
      .> terminate("lambda expression", ["Tk[RBrace]"])
      .> opt_rule("reference capability", ["cap"])
    
    // AS type ':'
    g.def("arraytype")
      .> print_inline()
      .> skip("None", ["Tk[As]"])
      .> rule("type", ["type"])
      .> skip("None", ["Tk[Colon]"])
    
    // (LSQUARE | LSQUARE_NEW) rawseq {COMMA rawseq} RSQUARE
    g.def("array")
      .> print_inline()
      .> tree("Tk[LitArray]")
      .> skip("None", ["Tk[LSquare]"; "Tk[LSquareNew]"])
      .> opt_rule("element type", ["arraytype"])
      .> rule("array elements", ["rawseq"])
      .> terminate("array literal", ["Tk[RSquare]"])
    
    // LSQUARE_NEW rawseq {COMMA rawseq} RSQUARE
    g.def("nextarray")
      .> print_inline()
      .> tree("Tk[LitArray]")
      .> skip("None", ["Tk[LSquareNew]"])
      .> opt_rule("element type", ["arraytype"])
      .> rule("array elements", ["rawseq"])
      .> terminate("array literal", ["Tk[RSquare]"])
    
    // COMMA rawseq {COMMA rawseq}
    g.def("tuple")
      .> builder("_BuildInfix")
      .> token("None", ["Tk[Comma]"])
      // TODO: MAP_ID("Tk[Comma]", "Tk[Tuple]")
      .> rule("value", ["rawseq"])
      .> while_token_do_rule("Tk[Comma]", "value", ["rawseq"])
    
    // (LPAREN | LPAREN_NEW) rawseq [tuple] RPAREN
    g.def("groupedexpr")
      .> print_inline()
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> rule("value", ["rawseq"])
      .> opt_no_dflt_rule("value", ["tuple"])
      .> skip("None", ["Tk[RParen]"])
      // TODO: deal with SET_FLAG(AST_FLAG_IN_PARENS)
    
    // LPAREN_NEW rawseq [tuple] RPAREN
    g.def("nextgroupedexpr")
      .> print_inline()
      .> skip("None", ["Tk[LParenNew]"])
      .> rule("value", ["rawseq"])
      .> opt_no_dflt_rule("value", ["tuple"])
      .> skip("None", ["Tk[RParen]"])
      // TODO: deal with SET_FLAG(AST_FLAG_IN_PARENS)
    
    // THIS
    g.def("thisliteral")
      .> token("None", ["Tk[This]"])
    
    // ID
    g.def("ref")
      .> print_inline()
      .> tree("Tk[Reference]")
      .> token("name", ["Tk[Id]"])
    
    // __LOC
    g.def("location")
      .> print_inline()
      .> token("None", ["Tk[LitLocation]"])
    
    // AT (ID | STRING) typeargs (LPAREN | LPAREN_NEW) [positional] RPAREN
    // [QUESTION]
    g.def("ffi")
      .> print_inline()
      .> token("None", ["Tk[At]"])
      // TODO: MAP_ID("Tk[At]", "Tk[Fficall]")
      .> token("ffi name", ["Tk[Id]"; "Tk[LitString]"])
      .> opt_rule("return type", ["typeargs"])
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> opt_rule("ffi arguments", ["positional"])
      .> opt_rule("ffi arguments", ["named"])
      .> terminate("ffi arguments", ["Tk[RParen]"])
      .> opt_token("None", ["Tk[Question]"])
    
    // ref | this | literal | tuple | array | object | lambda | ffi | location
    g.def("atom")
      .> rule("value", ["ref"; "thisliteral"; "literal"; "groupedexpr"; "array"; "object"; "lambda"; "ffi"; "location"])
    
    // ref | this | literal | tuple | array | object | lambda | ffi | location
    g.def("nextatom")
      .> rule("value", ["ref"; "thisliteral"; "literal"; "nextgroupedexpr"; "nextarray"; "object"; "lambda"; "ffi"; "location"])
    
    // DOT ID
    g.def("dot")
      .> builder("_BuildInfix")
      .> token("None", ["Tk[Dot]"])
      .> token("member name", ["Tk[Id]"])
    
    // TILDE ID
    g.def("tilde")
      .> builder("_BuildInfix")
      .> token("None", ["Tk[Tilde]"])
      .> token("method name", ["Tk[Id]"])
    
    // CHAIN ID
    g.def("chain")
      .> builder("_BuildInfix")
      .> token("None", ["Tk[Chain]"])
      .> token("method name", ["Tk[Id]"])
    
    // typeargs
    g.def("qualify")
      .> builder("_BuildInfix")
      .> tree("Tk[Qualify]")
      .> rule("type arguments", ["typeargs"])
    
    // LPAREN [positional] [named] RPAREN
    g.def("call")
      // TODO: INFIX_REVERSE()
      .> tree("Tk[Call]")
      .> skip("None", ["Tk[LParen]"])
      .> opt_rule("argument", ["positional"])
      .> opt_rule("argument", ["named"])
      .> terminate("call arguments", ["Tk[RParen]"])
    
    // atom {dot | tilde | chain | qualify | call}
    g.def("postfix")
      .> rule("value", ["atom"])
      .> seq("postfix expression", ["dot"; "tilde"; "chain"; "qualify"; "call"])
    
    // atom {dot | tilde | chain | qualify | call}
    g.def("nextpostfix")
      .> rule("value", ["nextatom"])
      .> seq("postfix expression", ["dot"; "tilde"; "chain"; "qualify"; "call"])
    
    // (VAR | LET | EMBED) ID [COLON type]
    g.def("local")
      .> print_inline()
      .> token("None", ["Tk[Var]"; "Tk[Let]"; "Tk[Embed]"])
      .> token("variable name", ["Tk[Id]"])
      .> if_token_then_rule("Tk[Colon]", "variable type", ["type"])
    
    // (NOT | AMP | MINUS | MINUS_TILDE | MINUS_NEW | MINUS_TILDE_NEW | DIGESTOF)
    // pattern
    g.def("prefix")
      .> print_inline()
      .> token("prefix", ["Tk[Not]"; "Tk[AddressOf]"; "Tk[Sub]"; "Tk[SubUnsafe]"; "Tk[SubNew]"; "Tk[SubUnsafeNew]"; "Tk[DigestOf]"])
      // TODO: MAP_ID("Tk[Sub]", "Tk[UnarySub]")
      // TODO: MAP_ID("Tk[SubUnsafe]", "Tk[UnarySubUnsafe]")
      // TODO: MAP_ID("Tk[SubNew]", "Tk[UnarySub]")
      // TODO: MAP_ID("Tk[SubUnsafeNew]", "Tk[UnarySubUnsafe]")
      .> rule("expression", ["parampattern"])
    
    // (NOT | AMP | MINUS_NEW | MINUS_TILDE_NEW | DIGESTOF) pattern
    g.def("nextprefix")
      .> print_inline()
      .> token("prefix", ["Tk[Not]"; "Tk[AddressOf]"; "Tk[SubNew]"; "Tk[SubUnsafeNew]"; "Tk[DigestOf]"])
      // TODO: MAP_ID("Tk[SubNew]", "Tk[UnarySub]")
      // TODO: MAP_ID("Tk[SubUnsafeNew]", "Tk[UnarySubUnsafe]")
      .> rule("expression", ["parampattern"])
    
    // (prefix | postfix)
    g.def("parampattern")
      .> rule("pattern", ["prefix"; "postfix"])
    
    // (prefix | postfix)
    g.def("nextparampattern")
      .> rule("pattern", ["nextprefix"; "nextpostfix"])
    
    // (local | prefix | postfix)
    g.def("pattern")
      .> rule("pattern", ["local"; "parampattern"])
    
    // (local | prefix | postfix)
    g.def("nextpattern")
      .> rule("pattern", ["local"; "nextparampattern"])
    
    // (LPAREN | LPAREN_NEW) idseq {COMMA idseq} RPAREN
    g.def("idseqmulti")
      .> print_inline()
      .> tree("Tk[Tuple]")
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> rule("variable name", ["idseq_in_seq"])
      .> while_token_do_rule("Tk[Comma]", "variable name", ["idseq_in_seq"])
      .> skip("None", ["Tk[RParen]"])
    
    // ID
    g.def("idseqsingle")
      .> print_inline()
      .> tree("Tk[Let]")
      .> token("variable name", ["Tk[Id]"])
      .> tree("Tk[None]")  // Type
    
    // idseq
    g.def("idseq_in_seq")
      .> tree("Tk[ExprSeq]")
      .> rule("variable name", ["idseqsingle"; "idseqmulti"])
    
    // ID | (LPAREN | LPAREN_NEW) idseq {COMMA idseq} RPAREN
    g.def("idseq")
      .> rule("variable name", ["idseqsingle"; "idseqmulti"])
    
    // ELSE annotatedseq
    g.def("elseclause")
      .> print_inline()
      .> skip("None", ["Tk[Else]"])
      .> rule("else value", ["annotatedseq"])
    
    // ELSEIF [annotations] rawseq THEN seq [elseif | (ELSE seq)]
    g.def("elseif")
      .> tree("Tk[If]")
      .> skip("None", ["Tk[ElseIf]"])
      .> annotate()
      .> rule("condition expression", ["rawseq"])
      .> skip("None", ["Tk[Then]"])
      .> rule("then value", ["seq"])
      .> opt_rule("else clause", ["elseif"; "elseclause"])
    
    // IF [annotations] rawseq THEN seq [elseif | elseclause] END
    g.def("cond")
      .> print_inline()
      .> token("None", ["Tk[If]"])
      .> annotate()
      .> rule("condition expression", ["rawseq"])
      .> skip("None", ["Tk[Then]"])
      .> rule("then value", ["seq"])
      .> opt_rule("else clause", ["elseif"; "elseclause"])
      .> terminate("if expression", ["Tk[End]"])
    
    // ELSEIF [annotations] infix [$EXTRA infix] THEN seq [elseifdef | elseclause]
    g.def("elseifdef")
      .> tree("Tk[IfDef]")
      .> skip("None", ["Tk[ElseIf]"])
      .> annotate()
      .> rule("condition expression", ["infix"])
      .> skip("None", ["Tk[Then]"])
      .> rule("then value", ["seq"])
      .> opt_rule("else clause", ["elseifdef"; "elseclause"])
      // Order should be:
      // condition then_clause else_clause else_condition
      // TODO: REORDER(0, 2, 3, 1)
    
    // IFDEF [annotations] infix [$EXTRA infix] THEN seq [elseifdef | elseclause]
    // END
    g.def("ifdef")
      .> print_inline()
      .> token("None", ["Tk[IfDef]"])
      .> annotate()
      .> rule("condition expression", ["infix"])
      .> skip("None", ["Tk[Then]"])
      .> rule("then value", ["seq"])
      .> opt_rule("else clause", ["elseifdef"; "elseclause"])
      .> terminate("ifdef expression", ["Tk[End]"])
      // Order should be:
      // condition then_clause else_clause else_condition
      // TODO: REORDER(0, 2, 3, 1)
    
    // ELSEIFTYPE [annotations] type <: type THEN seq [elseiftype | (ELSE seq)]
    g.def("elseiftype")
      .> tree("Tk[IfType]")
      .> skip("None", ["Tk[ElseIf]"])
      .> annotate()
      .> rule("type", ["type"])
      .> skip("None", ["Tk[SubType]"])
      .> rule("type", ["type"])
      .> skip("None", ["Tk[Then]"])
      .> rule("then value", ["seq"])
      .> opt_rule("else clause", ["elseiftype"; "elseclause"])
    
    // IFTYPE [annotations] type <: type THEN seq [elseiftype | (ELSE seq)] END
    g.def("iftype")
      .> print_inline()
      .> token("None", ["Tk[IfType]"])
      .> annotate()
      .> rule("type", ["type"])
      .> skip("None", ["Tk[SubType]"])
      .> rule("type", ["type"])
      .> skip("None", ["Tk[Then]"])
      .> rule("then value", ["seq"])
      .> opt_rule("else clause", ["elseiftype"; "elseclause"])
      .> terminate("iftype expression", ["Tk[End]"])
    
    // PIPE [annotations] [infix] [WHERE rawseq] [ARROW rawseq]
    g.def("caseexpr")
      .> tree("Tk[Case]")
      .> skip("None", ["Tk[Pipe]"])
      .> annotate()
      .> opt_rule("case pattern", ["pattern"])
      .> if_token_then_rule("Tk[If]", "guard expression", ["rawseq"])
      .> if_token_then_rule("Tk[DoubleArrow]", "case body", ["rawseq"])
    
    // {caseexpr}
    g.def("cases")
      .> print_inline()
      .> tree("Tk[Cases]")
      .> seq("cases", ["caseexpr"])
    
    // MATCH [annotations] rawseq cases [ELSE annotatedseq] END
    g.def("match")
      .> print_inline()
      .> token("None", ["Tk[Match]"])
      .> annotate()
      .> rule("match expression", ["rawseq"])
      .> rule("cases", ["cases"])
      .> if_token_then_rule("Tk[Else]", "else clause", ["annotatedseq"])
      .> terminate("match expression", ["Tk[End]"])
    
    // WHILE [annotations] rawseq DO seq [ELSE annotatedseq] END
    g.def("whileloop")
      .> print_inline()
      .> token("None", ["Tk[While]"])
      .> annotate()
      .> rule("condition expression", ["rawseq"])
      .> skip("None", ["Tk[Do]"])
      .> rule("while body", ["seq"])
      .> if_token_then_rule("Tk[Else]", "else clause", ["annotatedseq"])
      .> terminate("while loop", ["Tk[End]"])
    
    // REPEAT [annotations] seq UNTIL annotatedrawseq [ELSE annotatedseq] END
    g.def("repeat")
      .> print_inline()
      .> token("None", ["Tk[Repeat]"])
      .> annotate()
      .> rule("repeat body", ["seq"])
      .> skip("None", ["Tk[Until]"])
      .> rule("condition expression", ["annotatedrawseq"])
      .> if_token_then_rule("Tk[Else]", "else clause", ["annotatedseq"])
      .> terminate("repeat loop", ["Tk[End]"])
    
    // FOR [annotations] idseq IN rawseq DO rawseq [ELSE annotatedseq] END
    // =>
    // (SEQ
    //   (ASSIGN (LET $1) iterator)
    //   (WHILE $1.has_next()
    //     (SEQ (ASSIGN idseq $1.next()) body) else))
    // The body is not a scope since the sugar wraps it in a seq for us.
    g.def("forloop")
      .> print_inline()
      .> token("None", ["Tk[For]"])
      .> annotate()
      .> rule("iterator name", ["idseq"])
      .> skip("None", ["Tk[In]"])
      .> rule("iterator", ["rawseq"])
      .> skip("None", ["Tk[Do]"])
      .> rule("for body", ["rawseq"])
      .> if_token_then_rule("Tk[Else]", "else clause", ["annotatedseq"])
      .> terminate("for loop", ["Tk[End]"])
    
    // idseq = rawseq
    g.def("withelem")
      .> tree("Tk[ExprSeq]")
      .> rule("with name", ["idseq"])
      .> skip("None", ["Tk[Assign]"])
      .> rule("initialiser", ["rawseq"])
    
    // withelem {COMMA withelem}
    g.def("withexpr")
      .> print_inline()
      .> tree("Tk[ExprSeq]")
      .> rule("with expression", ["withelem"])
      .> while_token_do_rule("Tk[Comma]", "with expression", ["withelem"])
    
    // WITH [annotations] withexpr DO rawseq [ELSE annotatedrawseq] END
    // =>
    // (SEQ
    //   (ASSIGN (LET $1 initialiser))*
    //   (TRY_NO_CHECK
    //     (SEQ (ASSIGN idseq $1)* body)
    //     (SEQ (ASSIGN idseq $1)* else)
    //     (SEQ $1.dispose()*)))
    // The body and else clause aren't scopes since the sugar wraps them in seqs
    // for us.
    g.def("with")
      .> print_inline()
      .> token("None", ["Tk[With]"])
      .> annotate()
      .> rule("with expression", ["withexpr"])
      .> skip("None", ["Tk[Do]"])
      .> rule("with body", ["rawseq"])
      .> if_token_then_rule("Tk[Else]", "else clause", ["annotatedrawseq"])
      .> terminate("with expression", ["Tk[End]"])
    
    // TRY [annotations] seq [ELSE annotatedseq] [THEN annotatedseq] END
    g.def("try_block")
      .> print_inline()
      .> token("None", ["Tk[Try]"])
      .> annotate()
      .> rule("try body", ["seq"])
      .> if_token_then_rule("Tk[Else]", "try else body", ["annotatedseq"])
      .> if_token_then_rule("Tk[Then]", "try then body", ["annotatedseq"])
      .> terminate("try expression", ["Tk[End]"])
    
    // RECOVER [annotations] [CAP] rawseq END
    g.def("recover")
      .> print_inline()
      .> token("None", ["Tk[Recover]"])
      .> annotate()
      .> opt_rule("capability", ["cap"])
      .> rule("recover body", ["seq"])
      .> terminate("recover expression", ["Tk[End]"])
    
    // CONSUME [cap] term
    g.def("consume")
      .> print_inline()
      .> token("consume", ["Tk[Consume]"])
      .> opt_rule("capability", ["cap"])
      .> rule("expression", ["term"])
    
    // cond | ifdef | iftype | match | whileloop | repeat | forloop |
    // with | try | recover | consume | pattern | const_expr
    g.def("term")
      .> rule("value", [
        "cond"; "ifdef"; "iftype"; "match"; "whileloop"; "repeat"; "forloop"
        "with"; "try_block"; "recover"; "consume"; "pattern"; "const_expr"
      ])
    
    // cond | ifdef | iftype | match | whileloop | repeat | forloop |
    // with | try | recover | consume | pattern | const_expr
    g.def("nextterm")
      .> rule("value", [
        "cond"; "ifdef"; "iftype"; "match"; "whileloop"; "repeat"; "forloop"
        "with"; "try_block"; "recover"; "consume"; "nextpattern"; "const_expr"
      ])
    
    // AS type
    // For tuple types, use multiple matches.
    // (AS expr type) =>
    // (MATCH expr
    //   (CASES
    //     (CASE
    //       (LET $1 type)
    //       NONE
    //       (SEQ (CONSUME ALIASED $1))))
    //   (SEQ ERROR))
    g.def("asop")
      .> print_inline()
      .> builder("_BuildInfix")
      .> token("as", ["Tk[As]"])
      .> rule("type", ["type"])
    
    // BINOP term
    g.def("binop")
      .> builder("_BuildInfix")
      .> token("binary operator", [
        "Tk[And]"; "Tk[Or]"; "Tk[XOr]"
        "Tk[Add]"; "Tk[Sub]"; "Tk[Mul]"; "Tk[Div]"; "Tk[Mod]"
        "Tk[LShift]"; "Tk[RShift]"; "Tk[LShiftUnsafe]"; "Tk[RShiftUnsafe]"
        "Tk[Is]"; "Tk[Isnt]"; "Tk[Eq]"; "Tk[NE]"; "Tk[LT]"; "Tk[LE]"; "Tk[GE]"; "Tk[GT]"
        "Tk[AddUnsafe]"; "Tk[SubUnsafe]"; "Tk[MulUnsafe]"; "Tk[DivUnsafe]"
        "Tk[ModUnsafe]"; "Tk[EqUnsafe]"; "Tk[NEUnsafe]"
        "Tk[LTUnsafe]"; "Tk[LEUnsafe]"; "Tk[GEUnsafe]"; "Tk[GTUnsafe]"
      ])
      .> rule("value", ["term"])
    
    // term {binop | asop}
    g.def("infix")
      .> rule("value", ["term"])
      .> seq("value", ["binop"; "asop"])
    
    // term {binop | asop}
    g.def("nextinfix")
      .> rule("value", ["nextterm"])
      .> seq("value", ["binop"; "asop"])
    
    // ASSIGNOP assignment
    g.def("assignop")
      .> print_inline()
      // TODO: INFIX_REVERSE()
      .> token("assign operator", ["Tk[Assign]"])
      .> rule("assign rhs", ["assignment"])
    
    // term [assignop]
    g.def("assignment")
      .> rule("value", ["infix"])
      .> opt_no_dflt_rule("value", ["assignop"])
    
    // term [assignop]
    g.def("nextassignment")
      .> rule("value", ["nextinfix"])
      .> opt_no_dflt_rule("value", ["assignop"])
    
    // RETURN | BREAK | CONTINUE | ERROR | COMPILE_INTRINSIC | COMPILE_ERROR
    g.def("jump")
      .> token("statement", ["Tk[Return]"; "Tk[Break]"; "Tk[Continue]"; "Tk[Error]"; "Tk[CompileIntrinsic]"; "Tk[CompileError]"])
      .> opt_rule("return value", ["rawseq"])
    
    // SEMI
    g.def("semi")
      // TODO: IFELSE("Tk[Newline]", NEXT_FLAGS(AST_FLAG_BAD_SEMI), NEXT_FLAGS(0))
      .> token("None", ["Tk[Semicolon]"])
      // TODO: deal with IF("Tk[Newline]", SET_FLAG(AST_FLAG_BAD_SEMI))
    
    // semi (exprseq | jump)
    g.def("semiexpr")
      .> builder("_BuildFlatten")
      .> rule("semicolon", ["semi"])
      .> rule("value", ["exprseq"; "jump"])
    
    // nextexprseq | jump
    g.def("nosemi")
      // TODO: IFELSE("Tk[Newline]", NEXT_FLAGS(0), NEXT_FLAGS(AST_FLAG_MISSING_SEMI))
      .> rule("value", ["nextexprseq"; "jump"])
    
    // nextassignment (semiexpr | nosemi)
    g.def("nextexprseq")
      .> builder("_BuildFlatten")
      .> rule("value", ["nextassignment"])
      .> opt_no_dflt_rule("value", ["semiexpr"; "nosemi"])
      // TODO: NEXT_FLAGS(0)
    
    // assignment (semiexpr | nosemi)
    g.def("exprseq")
      .> builder("_BuildFlatten")
      .> rule("value", ["assignment"])
      .> opt_no_dflt_rule("value", ["semiexpr"; "nosemi"])
      // TODO: NEXT_FLAGS(0)
    
    // (exprseq | jump)
    g.def("rawseq")
      .> tree("Tk[ExprSeq]")
      .> rule("value", ["exprseq"; "jump"])
    
    // rawseq
    g.def("seq")
      .> rule("value", ["rawseq"])
    
    // [annotations] (exprseq | jump)
    g.def("annotatedrawseq")
      .> tree("Tk[ExprSeq]")
      .> annotate()
      .> rule("value", ["exprseq"; "jump"])
    
    // annotatedrawseq
    g.def("annotatedseq")
      .> rule("value", ["annotatedrawseq"])

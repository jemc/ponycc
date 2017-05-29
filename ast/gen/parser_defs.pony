
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
      .> opt_no_dflt_token("package docstring", ["Tk[LitString]"])
      .> seq("use command", ["use"])
      .> seq("type, interface, trait, primitive, class or actor definition", ["type_decl"])
      .> skip("type, interface, trait, primitive, class, actor, member or method", ["Tk[EOF]"])
      .> rotate_left_children(1)
    
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
      .> if_token_then_rule_else_none("Tk[If]", "use condition", ["ifdefinfix"])
    
    // (TYPE | INTERFACE | TRAIT | PRIMITIVE | STRUCT | CLASS | ACTOR) [annotations]
    // [AT] ID [typeparams] [CAP] [IS type] [STRING] members
    g.def("type_decl")
      .> restart(["Tk[TypeAlias]"; "Tk[Interface]"; "Tk[Trait]"; "Tk[Primitive]"; "Tk[Struct]"; "Tk[Class]"; "Tk[Actor]"])
      .> token("entity", ["Tk[TypeAlias]"; "Tk[Interface]"; "Tk[Trait]"; "Tk[Primitive]"; "Tk[Struct]"; "Tk[Class]"; "Tk[Actor]"])
      .> annotate()
      .> opt_rule("capability", ["cap"])
      .> opt_token("None", ["Tk[At]"])
      .> token("name", ["Tk[Id]"])
      .> opt_rule("type parameters", ["typeparams"])
      .> if_token_then_rule_else_none("Tk[Is]", "provided type", ["type"])
      .> opt_token("docstring", ["Tk[LitString]"])
      .> rule("members", ["members"])
      // Order should be:
      // id cap type_params provides members c_api docstring
      .> reorder_children([2; 0; 3; 4; 6; 1; 5])
    
    // {field} {method}
    g.def("members")
      .> tree("Tk[Members]")
      .> seq("field", ["field"])
      .> seq("method", ["method"])
    
    // (VAR | LET | EMBED) ID [COLON type] [ASSIGN infix]
    g.def("field")
      .> token("None", ["Tk[Var]"; "Tk[Let]"; "Tk[Embed]"])
      .> map_tk([
        ("Tk[Var]", "Tk[FieldVar]")
        ("Tk[Let]", "Tk[FieldLet]")
        ("Tk[Embed]", "Tk[FieldEmbed]")
      ])
      .> token("field name", ["Tk[Id]"])
      .> skip("mandatory type declaration on field", ["Tk[Colon]"])
      .> rule("field type", ["type"])
      .> if_token_then_rule_else_none("Tk[Assign]", "field value", ["infix"])
    
    // (FUN | BE | NEW) [annotations] [CAP] ID [typeparams] (LPAREN | LPAREN_NEW)
    // [params] RPAREN [COLON type] [QUESTION] [ARROW seq]
    g.def("method")
      .> token("None", ["Tk[MethodFun]"; "Tk[MethodBe]"; "Tk[MethodNew]"])
      .> annotate()
      .> opt_rule("capability", ["cap"])
      .> token("method name", ["Tk[Id]"])
      .> opt_rule("type parameters", ["typeparams"])
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> opt_rule("parameters", ["params"])
      .> skip("None", ["Tk[RParen]"])
      .> if_token_then_rule_else_none("Tk[Colon]", "return type", ["type"])
      .> opt_token("None", ["Tk[Question]"])
      .> opt_token("None", ["Tk[LitString]"])
      .> if_token_then_rule_else_none("Tk[If]", "guard expression", ["seq"])
      .> if_token_then_rule_else_none("Tk[DoubleArrow]", "method body", ["seq"])
      // Order should be:
      // id cap type_params params return_type error guard body docstring
      .> reorder_children([1; 0; 2; 3; 4; 5; 7; 8; 6])
    
    // LSQUARE typeparam {COMMA typeparam} RSQUARE
    g.def("typeparams")
      .> tree("Tk[TypeParams]")
      .> skip("None", ["Tk[LSquare]"; "Tk[LSquareNew]"])
      .> rule("type parameter", ["typeparam"])
      .> while_token_do_rule("Tk[Comma]", "type parameter", ["typeparam"])
      .> terminate("type parameters", ["Tk[RSquare]"])
    
    // ID [COLON type] [ASSIGN typearg]
    g.def("typeparam")
      .> tree("Tk[TypeParam]")
      .> token("name", ["Tk[Id]"])
      .> if_token_then_rule_else_none("Tk[Colon]", "type constraint", ["type"])
      .> if_token_then_rule_else_none("Tk[Assign]", "default type argument", ["typearg"])
    
    // LSQUARE type {COMMA type} RSQUARE
    g.def("typeargs")
      .> tree("Tk[TypeArgs]")
      .> skip("None", ["Tk[LSquare]"])
      .> rule("type argument", ["typearg"])
      .> while_token_do_rule("Tk[Comma]", "type argument", ["typearg"])
      .> terminate("type arguments", ["Tk[RSquare]"])
    
    // type | typearg_literal | const_expr
    g.def("typearg")
      .> rule("type argument", ["type"; "typearg_literal"; "const_expr"])
    
    // literal
    g.def("typearg_literal")
      .> tree("Tk[Constant]")
      .> print_inline()
      .> rule("type argument literal", ["literal"])
    
    // HASH postfix
    g.def("const_expr")
      .> print_inline()
      .> token("None", ["Tk[Constant]"])
      .> rule("formal argument value", ["postfix"])
    
    // param {COMMA (param | ellipsis)}
    g.def("params")
      .> tree("Tk[Params]")
      .> rule("parameter", ["param"; "ellipsis"])
      .> while_token_do_rule("Tk[Comma]", "parameter", ["param"; "ellipsis"])
    
    // postfix [COLON type] [ASSIGN infix]
    g.def("param")
      .> tree("Tk[Param]")
      .> token("parameter name", ["Tk[Id]"])
      .> if_token_then_rule_else_none("Tk[Colon]", "parameter type", ["type"])
      .> if_token_then_rule_else_none("Tk[Assign]", "default value", ["infix"])
    
    // (assignment | jump) {semiexpr | assignment | jump}
    g.def("seq")
      .> tree("Tk[Sequence]")
      .> rule("value", ["assignment"; "jump"])
      .> seq("value", ["semiexpr"; "nextassignment"; "jump"])
    
    // [annotations] (assignment | jump) {semiexpr | assignment | jump}
    g.def("annotatedseq")
      .> tree("Tk[Sequence]")
      .> annotate()
      .> rule("value", ["assignment"; "jump"])
      .> seq("value", ["semiexpr"; "nextassignment"; "jump"])
    
    // semi (assignment | jump)
    g.def("semiexpr")
      .> rule("semicolon", ["semi"])
      .> rule("value", ["assignment"; "jump"])
    
    // SEMICOLON
    g.def("semi")
      // This rule produces a TkTree *only if* the Tk[Semicolon]
      // is followed by a Tk[NewLine], indicating an illegal semicolon.
      .> skip("None", ["Tk[Semicolon]"])
      .> opt_no_dflt_token("None", ["Tk[NewLine]"])
      .> map_tk([("Tk[NewLine]", "Tk[Semicolon]")])
    
    // (RETURN | BREAK | CONTINUE | ERROR | COMPILE_INTRINSIC | COMPILE_ERROR)
    // [jumpvalue]
    g.def("jump")
      .> token("statement", [
        "Tk[Return]"; "Tk[Break]"; "Tk[Continue]"; "Tk[Error]"
        "Tk[CompileIntrinsic]"; "Tk[CompileError]"
      ])
      .> opt_rule("return value", ["jumpvalue"])
    
    // assignment
    g.def("jumpvalue")
      .> not_token("None", ["Tk[NewLine]"]) // value can't be on the next line
      .> rule("return value", ["assignment"])
    
    // term [assignop]
    g.def("assignment")
      .> rule("value", ["infix"])
      .> opt_no_dflt_rule("value", ["assignop"])
    
    // term [assignop]
    g.def("nextassignment")
      .> rule("value", ["nextinfix"])
      .> opt_no_dflt_rule("value", ["assignop"])
    
    // term {binop | asop}
    g.def("infix")
      .> rule("value", ["term"])
      .> seq("value", ["binop"; "asop"])
    
    // term {binop | asop}
    g.def("nextinfix")
      .> rule("value", ["nextterm"])
      .> seq("value", ["binop"; "asop"])
    
    // ifdef | iftype | if | while | repeat | for | with | match | 
    // try | consume | recover | pattern | const_expr
    g.def("term")
      .> rule("value", [
        "ifdef"; "iftype"; "if"; "while"; "repeat"; "for"; "with"; "match"
        "try"; "recover"; "consume"; "pattern"; "const_expr"
      ])
    
    // ifdef | iftype | if | while | repeat | for | with | match | 
    // try | consume | recover | pattern | const_expr
    g.def("nextterm")
      .> rule("value", [
        "ifdef"; "iftype"; "if"; "while"; "repeat"; "for"; "with"; "match"
        "try"; "recover"; "consume"; "nextpattern"; "const_expr"
      ])
    
    // ifdefterm {ifdefbinop}
    g.def("ifdefinfix")
      .> rule("ifdef condition", ["ifdefterm"])
      .> seq("ifdef binary operator", ["ifdefbinop"])
    
    // ifdefflag | ifdefnot
    g.def("ifdefterm")
      .> rule("ifdef condition", ["ifdefflag"; "ifdefnot"])
    
    // ID | STRING
    g.def("ifdefflag")
      .> tree("Tk[IfDefFlag]")
      .> token("ifdef condition", ["Tk[Id]"; "Tk[LitString]"])
    
    // NOT ifdefterm
    g.def("ifdefnot")
      .> print_inline()
      .> tree("Tk[IfDefNot]")
      .> skip("None", ["Tk[Not]"])
      .> rule("ifdef condition", ["ifdefterm"])
    
    // (AND | OR) ifdefterm
    g.def("ifdefbinop")
      .> builder("_BuildInfix")
      .> token("ifdef binary operator", ["Tk[And]"; "Tk[Or]"])
      .> map_tk([
        ("Tk[And]", "Tk[IfDefAnd]")
        ("Tk[Or]",  "Tk[IfDefOr]")
      ])
      .> rule("ifdef condition", ["ifdefterm"])
    
    // IFDEF [annotations] ifdefinfix THEN seq [elseifdef | elseclause] END
    g.def("ifdef")
      .> print_inline()
      .> token("None", ["Tk[IfDef]"])
      .> annotate()
      .> rule("condition expression", ["ifdefinfix"])
      .> skip("None", ["Tk[Then]"])
      .> rule("then value", ["seq"])
      .> opt_rule("else clause", ["elseifdef"; "elseclause"])
      .> terminate("ifdef expression", ["Tk[End]"])
    
    // ELSEIF [annotations] ifdefinfix THEN seq [elseifdef | elseclause]
    g.def("elseifdef")
      .> tree("Tk[IfDef]")
      .> skip("None", ["Tk[ElseIf]"])
      .> annotate()
      .> rule("condition expression", ["ifdefinfix"])
      .> skip("None", ["Tk[Then]"])
      .> rule("then value", ["seq"])
      .> opt_rule("else clause", ["elseifdef"; "elseclause"])
    
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
    
    // IF [annotations] seq THEN seq [elseif | elseclause] END
    g.def("if")
      .> print_inline()
      .> token("None", ["Tk[If]"])
      .> annotate()
      .> rule("condition expression", ["seq"])
      .> skip("None", ["Tk[Then]"])
      .> rule("then value", ["seq"])
      .> opt_rule("else clause", ["elseif"; "elseclause"])
      .> terminate("if expression", ["Tk[End]"])
    
    // ELSEIF [annotations] seq THEN seq [elseif | (ELSE seq)]
    g.def("elseif")
      .> tree("Tk[If]")
      .> skip("None", ["Tk[ElseIf]"])
      .> annotate()
      .> rule("condition expression", ["seq"])
      .> skip("None", ["Tk[Then]"])
      .> rule("then value", ["seq"])
      .> opt_rule("else clause", ["elseif"; "elseclause"])
    
    // ELSE annotatedseq
    g.def("elseclause")
      .> print_inline()
      .> skip("None", ["Tk[Else]"])
      .> rule("else value", ["annotatedseq"])
    
    // WHILE [annotations] seq DO seq [ELSE annotatedseq] END
    g.def("while")
      .> print_inline()
      .> token("None", ["Tk[While]"])
      .> annotate()
      .> rule("condition expression", ["seq"])
      .> skip("None", ["Tk[Do]"])
      .> rule("while body", ["seq"])
      .> if_token_then_rule("Tk[Else]", "else clause", ["annotatedseq"])
      .> terminate("while loop", ["Tk[End]"])
    
    // REPEAT [annotations] seq UNTIL annotatedseq [ELSE annotatedseq] END
    g.def("repeat")
      .> print_inline()
      .> token("None", ["Tk[Repeat]"])
      .> annotate()
      .> rule("repeat body", ["seq"])
      .> skip("None", ["Tk[Until]"])
      .> rule("condition expression", ["annotatedseq"])
      .> if_token_then_rule("Tk[Else]", "else clause", ["annotatedseq"])
      .> terminate("repeat loop", ["Tk[End]"])
    
    // FOR [annotations] idseq IN seq DO seq [ELSE annotatedseq] END
    g.def("for")
      .> print_inline()
      .> token("None", ["Tk[For]"])
      .> annotate()
      .> rule("iterator name", ["idseq"])
      .> skip("None", ["Tk[In]"])
      .> rule("iterator", ["seq"])
      .> skip("None", ["Tk[Do]"])
      .> rule("for body", ["seq"])
      .> if_token_then_rule("Tk[Else]", "else clause", ["annotatedseq"])
      .> terminate("for loop", ["Tk[End]"])
    
    // WITH [annotations] withexpr DO seq [ELSE annotatedseq] END
    g.def("with")
      .> print_inline()
      .> token("None", ["Tk[With]"])
      .> annotate()
      .> rule("with expression", ["withexpr"])
      .> skip("None", ["Tk[Do]"])
      .> rule("with body", ["seq"])
      .> if_token_then_rule("Tk[Else]", "else clause", ["annotatedseq"])
      .> terminate("with expression", ["Tk[End]"])
    
    // ID | (LPAREN | LPAREN_NEW) idseq {COMMA idseq} RPAREN
    g.def("idseq")
      .> rule("variable name", ["idseqsingle"; "idseqmulti"])
    
    // ID
    g.def("idseqsingle")
      .> print_inline()
      .> token("variable name", ["Tk[Id]"])
    
    // (LPAREN | LPAREN_NEW) idseq {COMMA idseq} RPAREN
    g.def("idseqmulti")
      .> print_inline()
      .> tree("Tk[Tuple]")
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> rule("variable name", ["idseq"])
      .> while_token_do_rule("Tk[Comma]", "variable name", ["idseq"])
      .> skip("None", ["Tk[RParen]"])
      .> map_tk([("Tk[Tuple]", "Tk[IdTuple]")])
    
    // infix = assignment
    g.def("withelem")
      .> tree("Tk[Assign]")
      .> rule("with name", ["infix"])
      .> skip("None", ["Tk[Assign]"])
      .> rule("initialiser", ["assignment"])
    
    // withelem {COMMA withelem}
    g.def("withexpr")
      .> print_inline()
      .> tree("Tk[AssignTuple]")
      .> rule("with expression", ["withelem"])
      .> while_token_do_rule("Tk[Comma]", "with expression", ["withelem"])
    
    // MATCH [annotations] seq cases [ELSE annotatedseq] END
    g.def("match")
      .> print_inline()
      .> token("None", ["Tk[Match]"])
      .> annotate()
      .> rule("match expression", ["seq"])
      .> rule("cases", ["cases"])
      .> if_token_then_rule("Tk[Else]", "else clause", ["annotatedseq"])
      .> terminate("match expression", ["Tk[End]"])
    
    // {caseexpr}
    g.def("cases")
      .> print_inline()
      .> tree("Tk[Cases]")
      .> seq("cases", ["caseexpr"])
    
    // PIPE [annotations] [infix] [WHERE seq] [ARROW seq]
    g.def("caseexpr")
      .> tree("Tk[Case]")
      .> skip("None", ["Tk[Pipe]"])
      .> annotate()
      .> opt_rule("case pattern", ["pattern"])
      .> if_token_then_rule_else_none("Tk[If]", "guard expression", ["seq"])
      .> if_token_then_rule_else_none("Tk[DoubleArrow]", "case body", ["seq"])
    
    // TRY [annotations] seq [ELSE annotatedseq] [THEN annotatedseq] END
    g.def("try")
      .> print_inline()
      .> token("None", ["Tk[Try]"])
      .> annotate()
      .> rule("try body", ["seq"])
      .> if_token_then_rule_else_none("Tk[Else]", "try else body", ["annotatedseq"])
      .> if_token_then_rule_else_none("Tk[Then]", "try then body", ["annotatedseq"])
      .> terminate("try expression", ["Tk[End]"])
    
    // CONSUME [cap] term
    g.def("consume")
      .> print_inline()
      .> token("consume", ["Tk[Consume]"])
      .> opt_rule("capability", ["cap"])
      .> rule("expression", ["term"])
    
    // RECOVER [annotations] [CAP] seq END
    g.def("recover")
      .> print_inline()
      .> token("None", ["Tk[Recover]"])
      .> annotate()
      .> opt_rule("capability", ["cap"])
      .> rule("recover body", ["seq"])
      .> terminate("recover expression", ["Tk[End]"])
    
    // AS type
    g.def("asop")
      .> print_inline()
      .> builder("_BuildInfix")
      .> token("as", ["Tk[As]"])
      .> rule("type", ["type"])
    
    // BINOP term
    g.def("binop")
      .> builder("_BuildInfix")
      .> token("binary operator", [
        "Tk[Add]"; "Tk[AddUnsafe]"; "Tk[Sub]"; "Tk[SubUnsafe]"; "Tk[Mul]"
        "Tk[MulUnsafe]"; "Tk[Div]"; "Tk[DivUnsafe]"; "Tk[Mod]"; "Tk[ModUnsafe]"
        "Tk[LShift]"; "Tk[RShift]"; "Tk[LShiftUnsafe]"; "Tk[RShiftUnsafe]"
        "Tk[Eq]"; "Tk[EqUnsafe]"; "Tk[NE]"; "Tk[NEUnsafe]"
        "Tk[LT]"; "Tk[LTUnsafe]"; "Tk[LE]"; "Tk[LEUnsafe]"
        "Tk[GE]"; "Tk[GEUnsafe]"; "Tk[GT]"; "Tk[GTUnsafe]"
        "Tk[Is]"; "Tk[Isnt]"; "Tk[And]"; "Tk[Or]"; "Tk[XOr]"
      ])
      .> rule("value", ["term"])
    
    // (NOT | ADDRESSOF | DIGESTOF | SUB | SUB_TILDE | SUB_NEW | SUB_TILDE_NEW)
    // pattern
    g.def("prefix")
      .> print_inline()
      .> token("prefix", [
        "Tk[Not]"; "Tk[AddressOf]"; "Tk[DigestOf]"
        "Tk[Sub]"; "Tk[SubUnsafe]"; "Tk[SubNew]"; "Tk[SubUnsafeNew]"
      ])
      .> map_tk([
        ("Tk[Sub]",          "Tk[Neg]")
        ("Tk[SubUnsafe]",    "Tk[NegUnsafe]")
        ("Tk[SubNew]",       "Tk[Neg]")
        ("Tk[SubUnsafeNew]", "Tk[NegUnsafe]")
      ])
      .> rule("expression", ["rhspattern"])
    
    // (NOT | ADDRESSOF | DIGESTOF | SUB_NEW | SUB_TILDE_NEW) pattern
    g.def("nextprefix")
      .> print_inline()
      .> token("prefix", [
        "Tk[Not]"; "Tk[AddressOf]"; "Tk[DigestOf]"
        "Tk[SubNew]"; "Tk[SubUnsafeNew]"
      ])
      .> map_tk([
        ("Tk[SubNew]",       "Tk[Neg]")
        ("Tk[SubUnsafeNew]", "Tk[NegUnsafe]")
      ])
      .> rule("expression", ["rhspattern"])
    
    // (prefix | postfix)
    g.def("rhspattern")
      .> rule("pattern", ["prefix"; "postfix"])
    
    // (prefix | postfix)
    g.def("nextrhspattern")
      .> rule("pattern", ["nextprefix"; "nextpostfix"])
    
    // (local | prefix | postfix)
    g.def("pattern")
      .> rule("pattern", ["local"; "rhspattern"])
    
    // (local | prefix | postfix)
    g.def("nextpattern")
      .> rule("pattern", ["local"; "nextrhspattern"])
    
    // (VAR | LET) ID [COLON type]
    g.def("local")
      .> print_inline()
      .> token("None", ["Tk[Var]"; "Tk[Let]"])
      .> map_tk([
        ("Tk[Var]", "Tk[LocalVar]")
        ("Tk[Let]", "Tk[LocalLet]")
      ])
      .> token("variable name", ["Tk[Id]"])
      .> if_token_then_rule_else_none("Tk[Colon]", "variable type", ["type"])
    
    // ASSIGNOP assignment
    g.def("assignop")
      .> print_inline()
      .> builder("_BuildInfix")
      .> token("assign operator", ["Tk[Assign]"])
      .> rule("assign rhs", ["assignment"])
    
    // atom {dot | tilde | chain | qualify | call}
    g.def("postfix")
      .> rule("value", ["atom"])
      .> seq("postfix expression", ["dot"; "chain"; "tilde"; "qualify"; "call"])
    
    // atom {dot | tilde | chain | qualify | call}
    g.def("nextpostfix")
      .> rule("value", ["nextatom"])
      .> seq("postfix expression", ["dot"; "chain"; "tilde"; "qualify"; "call"])
    
    // DOT ID
    g.def("dot")
      .> builder("_BuildInfix")
      .> token("None", ["Tk[Dot]"])
      .> token("member name", ["Tk[Id]"])
    
    // CHAIN ID
    g.def("chain")
      .> builder("_BuildInfix")
      .> token("None", ["Tk[Chain]"])
      .> token("method name", ["Tk[Id]"])
    
    // TILDE ID
    g.def("tilde")
      .> builder("_BuildInfix")
      .> token("None", ["Tk[Tilde]"])
      .> token("method name", ["Tk[Id]"])
    
    // typeargs
    g.def("qualify")
      .> builder("_BuildInfix")
      .> tree("Tk[Qualify]")
      .> rule("type arguments", ["typeargs"])
    
    // LPAREN [args] [namedargs] RPAREN
    g.def("call")
      .> builder("_BuildInfix")
      .> tree("Tk[Call]")
      .> skip("None", ["Tk[LParen]"])
      .> opt_rule("argument", ["args"], "Tk[Args]")
      .> opt_rule("argument", ["namedargs"], "Tk[NamedArgs]")
      .> terminate("call arguments", ["Tk[RParen]"])
    
    // AT (ID | STRING) typeargs (LPAREN | LPAREN_NEW) [args] RPAREN [QUESTION]
    g.def("callffi")
      .> print_inline()
      .> tree("Tk[CallFFI]")
      .> skip("None", ["Tk[At]"])
      .> token("ffi name", ["Tk[Id]"; "Tk[LitString]"])
      .> opt_rule("return type", ["typeargs"])
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> opt_rule("ffi arguments", ["args"], "Tk[Args]")
      .> opt_rule("ffi arguments", ["namedargs"], "Tk[NamedArgs]")
      .> terminate("ffi arguments", ["Tk[RParen]"])
      .> opt_token("None", ["Tk[Question]"])
    
    // seq {COMMA seq}
    g.def("args")
      .> tree("Tk[Args]")
      .> rule("argument", ["seq"])
      .> while_token_do_rule("Tk[Comma]", "argument", ["seq"])
    
    // WHERE namedarg {COMMA namedarg}
    g.def("namedargs")
      .> tree("Tk[NamedArgs]")
      .> skip("None", ["Tk[Where]"])
      .> rule("named argument", ["namedarg"])
      .> while_token_do_rule("Tk[Comma]", "named argument", ["namedarg"])
    
    // ID ASSIGN seq
    g.def("namedarg")
      .> tree("Tk[NamedArg]")
      .> token("argument name", ["Tk[Id]"])
      .> skip("None", ["Tk[Assign]"])
      .> rule("argument value", ["seq"])
    
    // callffi | lambda | object | array | tuple | this |
    // literal | location | reference | dontcare
    g.def("atom")
      .> rule("value", [
        "callffi"; "lambda"; "object"; "array"; "groupedexpr"; "this"
        "literal"; "location"; "reference"; "dontcare"
      ])
    
    // callffi | lambda | object | array | tuple | this |
    // literal | location | reference | dontcare
    g.def("nextatom")
      .> rule("value", [
        "callffi"; "lambda"; "object"; "nextarray"; "nextgroupedexpr"; "this"
        "literal"; "location"; "reference"; "dontcare"
      ])
    
    // LBRACE [annotations] [CAP] [ID] [typeparams] (LPAREN | LPAREN_NEW) [params]
    // RPAREN [lambdacaptures] [COLON type] [QUESTION] ARROW seq RBRACE [CAP]
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
      .> if_token_then_rule_else_none("Tk[Colon]", "return type", ["type"])
      .> opt_token("None", ["Tk[Question]"])
      .> skip("None", ["Tk[DoubleArrow]"])
      .> rule("lambda body", ["seq"])
      .> terminate("lambda expression", ["Tk[RBrace]"])
      .> opt_rule("reference capability", ["cap"])
    
    // (LPAREN | LPAREN_NEW) (lambdacapture | this)
    // {COMMA (lambdacapture | this)} RPAREN
    g.def("lambdacaptures")
      .> tree("Tk[LambdaCaptures]")
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> rule("capture", ["lambdacapture"; "this"])
      .> while_token_do_rule("Tk[Comma]", "capture", ["lambdacapture"; "this"])
      .> skip("None", ["Tk[RParen]"])
    
    // ID [COLON type] [ASSIGN infix]
    g.def("lambdacapture")
      .> tree("Tk[LambdaCapture]")
      .> token("name", ["Tk[Id]"])
      .> if_token_then_rule_else_none("Tk[Colon]", "capture type", ["type"])
      .> if_token_then_rule_else_none("Tk[Assign]", "capture value", ["infix"])
    
    // OBJECT [annotations] [CAP] [IS type] members END
    g.def("object")
      .> print_inline()
      .> token("None", ["Tk[Object]"])
      .> annotate()
      .> opt_rule("capability", ["cap"])
      .> if_token_then_rule_else_none("Tk[Is]", "provided type", ["type"])
      .> rule("object member", ["members"])
      .> terminate("object literal", ["Tk[End]"])
    
    // (LSQUARE | LSQUARE_NEW) seq {COMMA seq} RSQUARE
    g.def("array")
      .> print_inline()
      .> tree("Tk[LitArray]")
      .> skip("None", ["Tk[LSquare]"; "Tk[LSquareNew]"])
      .> opt_rule("element type", ["arraytype"])
      .> rule("array elements", ["seq"])
      .> terminate("array literal", ["Tk[RSquare]"])
    
    // LSQUARE_NEW seq {COMMA seq} RSQUARE
    g.def("nextarray")
      .> print_inline()
      .> tree("Tk[LitArray]")
      .> skip("None", ["Tk[LSquareNew]"])
      .> opt_rule("element type", ["arraytype"])
      .> rule("array elements", ["seq"])
      .> terminate("array literal", ["Tk[RSquare]"])
    
    // AS type ':'
    g.def("arraytype")
      .> print_inline()
      .> skip("None", ["Tk[As]"])
      .> rule("type", ["type"])
      .> skip("None", ["Tk[Colon]"])
    
    // (LPAREN | LPAREN_NEW) seq [tuple] RPAREN
    g.def("groupedexpr")
      .> print_inline()
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> rule("value", ["seq"])
      .> opt_no_dflt_rule("value", ["tuple"])
      .> skip("None", ["Tk[RParen]"])
    
    // LPAREN_NEW seq [tuple] RPAREN
    g.def("nextgroupedexpr")
      .> print_inline()
      .> skip("None", ["Tk[LParenNew]"])
      .> rule("value", ["seq"])
      .> opt_no_dflt_rule("value", ["tuple"])
      .> skip("None", ["Tk[RParen]"])
    
    // COMMA seq {COMMA seq}
    g.def("tuple")
      .> builder("_BuildInfix")
      .> tree("Tk[Tuple]")
      .> skip("None", ["Tk[Comma]"])
      .> rule("value", ["seq"])
      .> while_token_do_rule("Tk[Comma]", "value", ["seq"])
    
    // THIS
    g.def("this")
      .> token("None", ["Tk[This]"])
    
    // TRUE | FALSE | INT | FLOAT | STRING
    g.def("literal")
      .> token("literal", ["Tk[LitTrue]"; "Tk[LitFalse]"; "Tk[LitInteger]"; "Tk[LitFloat]"; "Tk[LitString]"; "Tk[LitCharacter]"])
    
    // __LOC
    g.def("location")
      .> print_inline()
      .> token("None", ["Tk[LitLocation]"])
    
    // ID
    g.def("reference")
      .> print_inline()
      .> tree("Tk[Reference]")
      .> token("name", ["Tk[Id]"])
    
    // ID
    g.def("dontcare")
      .> print_inline()
      .> token("None", ["Tk[DontCare]"])
    
    // atomtype [viewpoint]
    g.def("type")
      .> rule("type", ["atomtype"])
      .> opt_no_dflt_rule("viewpoint", ["viewpoint"])
    
    // (tupletype | nominal | lambdatype | thistype | cap | gencap)
    g.def("atomtype")
      .> rule("type", ["tupletype"; "nominal"; "lambdatype"; "thistype"; "cap"; "gencap"])
    
    // ARROW type
    g.def("viewpoint")
      .> print_inline()
      .> builder("_BuildInfix")
      .> tree("Tk[ViewpointType]")
      .> skip("None", ["Tk[Arrow]"])
      .> rule("viewpoint", ["type"])
    
    // (LPAREN | LPAREN_NEW) infixtype [commatype] RPAREN
    g.def("tupletype")
      .> print_inline()
      .> tree("Tk[TupleType]") // TODO: In the parser, unwrap single-element TupleTypes, using the TupleType to ensure that parens gave explicit operator precedence.
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> rule("type", ["infixtype"])
      .> opt_no_dflt_rule("type", ["commatype"])
      .> skip("None", ["Tk[RParen]"])
    
    // type {uniontype | isecttype}
    g.def("infixtype")
      .> rule("type", ["type"])
      .> seq("type", ["uniontype"; "isecttype"])
    
    // PIPE type
    g.def("uniontype")
      .> builder("_BuildInfix")
      .> tree("Tk[UnionType]")
      .> skip("None", ["Tk[Pipe]"])
      .> rule("type", ["type"])
      .> while_token_do_rule("Tk[Pipe]", "type", ["type"])
    
    // AMP type
    g.def("isecttype")
      .> builder("_BuildInfix")
      .> tree("Tk[IsectType]")
      .> skip("None", ["Tk[Ampersand]"])
      .> rule("type", ["type"])
      .> while_token_do_rule("Tk[Ampersand]", "type", ["type"])
    
    // COMMA infixtype {COMMA infixtype}
    g.def("commatype")
      .> builder("_BuildInfix")
      .> skip("None", ["Tk[Comma]"])
      .> rule("type", ["infixtype"])
      .> while_token_do_rule("Tk[Comma]", "type", ["infixtype"])
    
    // ID [DOT ID] [typeargs] [CAP] [EPHEMERAL | ALIASED]
    g.def("nominal")
      .> tree("Tk[NominalType]")
      .> rule("nominal type", ["nominalparts"])
    
    // ID [DOT ID] [typeargs] [CAP] [EPHEMERAL | ALIASED]
    g.def("nominalparts")
      .> builder("_BuildCustomNominalType")
      .> token("name", ["Tk[Id]"])
      .> if_token_then_token("Tk[Dot]", "None", ["Tk[Id]"])
      .> opt_rule("type arguments", ["typeargs"])
      .> opt_rule("capability", ["cap"; "gencap"])
      .> opt_token("None", ["Tk[Ephemeral]"; "Tk[Aliased]"])
    
    // LBRACE [CAP] [ID] [typeparams] (LPAREN | LPAREN_NEW) [typelist] RPAREN
    // [COLON type] [QUESTION] RBRACE [CAP] [EPHEMERAL | ALIASED]
    g.def("lambdatype")
      .> tree("Tk[LambdaType]")
      .> skip("None", ["Tk[LBrace]"])
      .> opt_rule("capability", ["cap"])
      .> opt_token("function name", ["Tk[Id]"])
      .> opt_rule("type parameters", ["typeparams"])
      .> skip("None", ["Tk[LParen]"; "Tk[LParenNew]"])
      .> opt_rule("parameters", ["tupletype"])
      .> skip("None", ["Tk[RParen]"])
      .> if_token_then_rule_else_none("Tk[Colon]", "return type", ["type"])
      .> opt_token("None", ["Tk[Question]"])
      .> skip("None", ["Tk[RBrace]"])
      .> opt_rule("capability", ["cap"; "gencap"])
      .> opt_token("None", ["Tk[Ephemeral]"; "Tk[Aliased]"])
    
    // THIS
    g.def("thistype")
      .> print_inline()
      .> tree("Tk[ThisType]")
      .> skip("None", ["Tk[This]"])
    
    // ELLIPSIS
    g.def("ellipsis")
      .> token("None", ["Tk[Ellipsis]"])
    
    // CAP
    g.def("cap")
      .> token("capability", ["Tk[Iso]"; "Tk[Trn]"; "Tk[Ref]"; "Tk[Val]"; "Tk[Box]"; "Tk[Tag]"])
    
    // GENCAP
    g.def("gencap")
      .> token("generic capability", ["Tk[CapRead]"; "Tk[CapSend]"; "Tk[CapShare]"; "Tk[CapAlias]"; "Tk[CapAny]"])
    
    // '\' ID {COMMA ID} '\'
    g.def("annotations")
      .> print_inline()
      .> token("None", ["Tk[Backslash]"])
      .> token("annotation", ["Tk[Id]"])
      .> while_token_do_token("Tk[Comma]", "annotation", ["Tk[Id]"])
      .> terminate("annotations", ["Tk[Backslash]"])

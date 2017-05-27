
use peg = "peg"
use ".."

class val _Lexicon
  // Note that for keywords where one keyword starts with another,
  // the longer one must appear first in this list.
  // For example "ifdef" must appear before "if".
  let keywords: peg.Parser val = recover
    peg.L("_").term(Tk[DontCare])
    
    / peg.L("use").term(Tk[Use])
    / peg.L("type").term(Tk[TypeAlias])
    / peg.L("interface").term(Tk[Interface])
    / peg.L("trait").term(Tk[Trait])
    / peg.L("primitive").term(Tk[Primitive])
    / peg.L("struct").term(Tk[Struct])
    / peg.L("class").term(Tk[Class])
    / peg.L("actor").term(Tk[Actor])
    / peg.L("object").term(Tk[Object])
    
    / peg.L("iso").term(Tk[Iso])
    / peg.L("trn").term(Tk[Trn])
    / peg.L("ref").term(Tk[Ref])
    / peg.L("val").term(Tk[Val])
    / peg.L("box").term(Tk[Box])
    / peg.L("tag").term(Tk[Tag])
    
    / peg.L("as").term(Tk[As])
    / peg.L("isnt").term(Tk[Isnt])
    / peg.L("is").term(Tk[Is])
    
    / peg.L("var").term(Tk[Var])
    / peg.L("let").term(Tk[Let])
    / peg.L("embed").term(Tk[Embed])
    / peg.L("new").term(Tk[MethodNew])
    / peg.L("fun").term(Tk[MethodFun])
    / peg.L("be").term(Tk[MethodBe])
    
    / peg.L("this").term(Tk[This])
    / peg.L("return").term(Tk[Return])
    / peg.L("break").term(Tk[Break])
    / peg.L("continue").term(Tk[Continue])
    / peg.L("consume").term(Tk[Consume])
    / peg.L("recover").term(Tk[Recover])
    
    / peg.L("ifdef").term(Tk[IfDef])
    / peg.L("iftype").term(Tk[IfType])
    / peg.L("if").term(Tk[If])
    / peg.L("then").term(Tk[Then])
    / peg.L("elseif").term(Tk[ElseIf])
    / peg.L("else").term(Tk[Else])
    / peg.L("end").term(Tk[End])
    / peg.L("for").term(Tk[For])
    / peg.L("in").term(Tk[In])
    / peg.L("while").term(Tk[While])
    / peg.L("do").term(Tk[Do])
    / peg.L("repeat").term(Tk[Repeat])
    / peg.L("until").term(Tk[Until])
    / peg.L("match").term(Tk[Match])
    / peg.L("where").term(Tk[Where])
    / peg.L("try").term(Tk[Try])
    / peg.L("with").term(Tk[With])
    / peg.L("error").term(Tk[Error])
    / peg.L("compile_error").term(Tk[CompileError])
    / peg.L("compile_intrinsic").term(Tk[CompileIntrinsic])
    
    / peg.L("not").term(Tk[Not])
    / peg.L("and").term(Tk[And])
    / peg.L("or").term(Tk[Or])
    / peg.L("xor").term(Tk[XOr])
    
    / peg.L("digestof").term(Tk[DigestOf])
    / peg.L("addressof").term(Tk[AddressOf])
    / peg.L("__loc").term(Tk[LitLocation])
    
    / peg.L("true").term(Tk[LitTrue])
    / peg.L("false").term(Tk[LitFalse])
    
    / peg.L("#read").term(Tk[CapRead])
    / peg.L("#send").term(Tk[CapSend])
    / peg.L("#share").term(Tk[CapShare])
    / peg.L("#alias").term(Tk[CapAlias])
    / peg.L("#any").term(Tk[CapAny])
  end
  
  // Note that for symbols where one symbol starts with another,
  // the longer one must appear first in this list.
  // For example ">=" must appear before ">".
  let symbols: peg.Parser val = recover
    peg.L("...").term(Tk[Ellipsis])
    
    / peg.L("==~").term(Tk[Eq])
    / peg.L("!=~").term(Tk[NE])
    / peg.L("<=~").term(Tk[LEUnsafe])
    / peg.L(">=~").term(Tk[GEUnsafe])
    / peg.L("<<~").term(Tk[LShiftUnsafe])
    / peg.L(">>~").term(Tk[RShiftUnsafe])
    
    / peg.L("==").term(Tk[Eq])
    / peg.L("!=").term(Tk[NE])
    / peg.L("<=").term(Tk[LE])
    / peg.L(">=").term(Tk[GE])
    / peg.L("<<").term(Tk[LShift])
    / peg.L(">>").term(Tk[RShift])
    / peg.L("<:").term(Tk[SubType])
    
    / peg.L(".>").term(Tk[Chain])
    / peg.L("->").term(Tk[Arrow])
    / peg.L("=>").term(Tk[DoubleArrow])
    
    / peg.L("+~").term(Tk[AddUnsafe])
    / peg.L("-~").term(Tk[SubUnsafe])
    / peg.L("*~").term(Tk[MulUnsafe])
    / peg.L("/~").term(Tk[DivUnsafe])
    / peg.L("%~").term(Tk[ModUnsafe])
    / peg.L("<~").term(Tk[LTUnsafe])
    / peg.L(">~").term(Tk[GTUnsafe])
    
    / peg.L("+").term(Tk[Add])
    / peg.L("-").term(Tk[Sub])
    / peg.L("*").term(Tk[Mul])
    / peg.L("/").term(Tk[Div])
    / peg.L("%").term(Tk[Mod])
    / peg.L("<").term(Tk[LT])
    / peg.L(">").term(Tk[GT])
    
    / peg.L("{").term(Tk[LBrace])
    / peg.L("}").term(Tk[RBrace])
    / peg.L("(").term(Tk[LParen])
    / peg.L(")").term(Tk[RParen])
    / peg.L("[").term(Tk[LSquare])
    / peg.L("]").term(Tk[RSquare])
    / peg.L(",").term(Tk[Comma])
    
    / peg.L(".").term(Tk[Dot])
    / peg.L("~").term(Tk[Tilde])
    / peg.L(":").term(Tk[Colon])
    / peg.L(";").term(Tk[Semicolon])
    / peg.L("=").term(Tk[Assign])
    
    / peg.L("@").term(Tk[At])
    / peg.L("|").term(Tk[Pipe])
    / peg.L("&").term(Tk[Ampersand])
    / peg.L("^").term(Tk[Ephemeral])
    / peg.L("!").term(Tk[Aliased])
    
    / peg.L("?").term(Tk[Question])
    / peg.L("#").term(Tk[Constant])
    / peg.L("\\").term(Tk[Backslash])
  end
  
  // Note that for symbols where one symbol starts with another,
  // the longer one must appear first in this list.
  // For example "-~" must appear before "-".
  let newline_symbols: peg.Parser val = recover
    peg.L("-~").term(Tk[SubUnsafeNew])
    / peg.L("-").term(Tk[SubNew])
    / peg.L("(").term(Tk[LParenNew])
    / peg.L("[").term(Tk[LSquareNew])
  end


trait val Tk
  fun show(): String ?

// Keyword tokens (whose strings correspond to syntax keywords)
primitive TkDontCare         is Tk fun show(): String => "_"
primitive TkCompileIntrinsic is Tk fun show(): String => "compile_intrinsic"
primitive TkUse              is Tk fun show(): String => "use"
primitive TkType             is Tk fun show(): String => "type"
primitive TkInterface        is Tk fun show(): String => "interface"
primitive TkTrait            is Tk fun show(): String => "trait"
primitive TkPrimitive        is Tk fun show(): String => "primitive"
primitive TkStruct           is Tk fun show(): String => "struct"
primitive TkClass            is Tk fun show(): String => "class"
primitive TkActor            is Tk fun show(): String => "actor"
primitive TkObject           is Tk fun show(): String => "object"
primitive TkLambda           is Tk fun show(): String => "lambda"
primitive TkDelegate         is Tk fun show(): String => "delegate"
primitive TkAs               is Tk fun show(): String => "as"
primitive TkIs               is Tk fun show(): String => "is"
primitive TkIsnt             is Tk fun show(): String => "isnt"
primitive TkVar              is Tk fun show(): String => "var"
primitive TkLet              is Tk fun show(): String => "let"
primitive TkEmbed            is Tk fun show(): String => "embed"
primitive TkNew              is Tk fun show(): String => "new"
primitive TkFun              is Tk fun show(): String => "fun"
primitive TkBe               is Tk fun show(): String => "be"
primitive TkIso              is Tk fun show(): String => "iso"
primitive TkTrn              is Tk fun show(): String => "trn"
primitive TkRef              is Tk fun show(): String => "ref"
primitive TkVal              is Tk fun show(): String => "val"
primitive TkBox              is Tk fun show(): String => "box"
primitive TkTag              is Tk fun show(): String => "tag"
primitive TkThis             is Tk fun show(): String => "this"
primitive TkReturn           is Tk fun show(): String => "return"
primitive TkBreak            is Tk fun show(): String => "break"
primitive TkContinue         is Tk fun show(): String => "continue"
primitive TkConsume          is Tk fun show(): String => "consume"
primitive TkRecover          is Tk fun show(): String => "recover"
primitive TkIf               is Tk fun show(): String => "if"
primitive TkIfdef            is Tk fun show(): String => "ifdef"
primitive TkThen             is Tk fun show(): String => "then"
primitive TkElse             is Tk fun show(): String => "else"
primitive TkElseIf           is Tk fun show(): String => "elseif"
primitive TkEnd              is Tk fun show(): String => "end"
primitive TkFor              is Tk fun show(): String => "for"
primitive TkIn               is Tk fun show(): String => "in"
primitive TkWhile            is Tk fun show(): String => "while"
primitive TkDo               is Tk fun show(): String => "do"
primitive TkRepeat           is Tk fun show(): String => "repeat"
primitive TkUntil            is Tk fun show(): String => "until"
primitive TkMatch            is Tk fun show(): String => "match"
primitive TkWhere            is Tk fun show(): String => "where"
primitive TkTry              is Tk fun show(): String => "try"
primitive TkWith             is Tk fun show(): String => "with"
primitive TkError            is Tk fun show(): String => "error"
primitive TkCompileError     is Tk fun show(): String => "compile_error"
primitive TkNot              is Tk fun show(): String => "not"
primitive TkAnd              is Tk fun show(): String => "and"
primitive TkOr               is Tk fun show(): String => "or"
primitive TkXor              is Tk fun show(): String => "xor"
primitive TkIdentityOf       is Tk fun show(): String => "identityof"
primitive TkAddress          is Tk fun show(): String => "addressof"
primitive TkLocation         is Tk fun show(): String => "__loc"
primitive TkTrue             is Tk fun show(): String => "true"
primitive TkFalse            is Tk fun show(): String => "false"
primitive TkCapRead          is Tk fun show(): String => "#read"
primitive TkCapSend          is Tk fun show(): String => "#send"
primitive TkCapShare         is Tk fun show(): String => "#share"
primitive TkCapAny           is Tk fun show(): String => "#any"
primitive TkTestNoSeq        is Tk fun show(): String => "$noseq"
primitive TkTestSeqScope     is Tk fun show(): String => "$scope"
primitive TkTestTryNoCheck   is Tk fun show(): String => "$try_no_check"
primitive TkTestBorrowed     is Tk fun show(): String => "$borrowed"
primitive TkTestUpdateArg    is Tk fun show(): String => "$updatearg"
primitive TkTestExtra        is Tk fun show(): String => "$extra"
primitive TkIfdefAnd         is Tk fun show(): String => "$ifdefand"
primitive TkIfdefOr          is Tk fun show(): String => "$ifdefor"
primitive TkIfdefNot         is Tk fun show(): String => "$ifdefnot"
primitive TkIfdefFlag        is Tk fun show(): String => "$flag"
primitive TkMatchCapture     is Tk fun show(): String => "$let"

// Symbol tokens (whose strings correspond to syntax glyphs)
primitive TkEllipsis         is Tk fun show(): String => "..."
primitive TkArrow            is Tk fun show(): String => "->"
primitive TkDoubleArrow      is Tk fun show(): String => "=>"
primitive TkLShift           is Tk fun show(): String => "<<"
primitive TkRShift           is Tk fun show(): String => ">>"
primitive TkEq               is Tk fun show(): String => "=="
primitive TkNe               is Tk fun show(): String => "!="
primitive TkLe               is Tk fun show(): String => "<="
primitive TkGe               is Tk fun show(): String => ">="
primitive TkLBrace           is Tk fun show(): String => "{"
primitive TkRBrace           is Tk fun show(): String => "}"
primitive TkLParen           is Tk fun show(): String => "("
primitive TkRParen           is Tk fun show(): String => ")"
primitive TkLSquare          is Tk fun show(): String => "["
primitive TkRSquare          is Tk fun show(): String => "]"
primitive TkComma            is Tk fun show(): String => ","
primitive TkDot              is Tk fun show(): String => "."
primitive TkTilde            is Tk fun show(): String => "~"
primitive TkColon            is Tk fun show(): String => ":"
primitive TkSemi             is Tk fun show(): String => ";"
primitive TkAssign           is Tk fun show(): String => "="
primitive TkPlus             is Tk fun show(): String => "+"
primitive TkMinus            is Tk fun show(): String => "-"
primitive TkMultiply         is Tk fun show(): String => "*"
primitive TkDivide           is Tk fun show(): String => "/"
primitive TkMod              is Tk fun show(): String => "%"
primitive TkAt               is Tk fun show(): String => "@"
primitive TkLt               is Tk fun show(): String => "<"
primitive TkGt               is Tk fun show(): String => ">"
primitive TkPipe             is Tk fun show(): String => "|"
primitive TkIntersectType    is Tk fun show(): String => "&"
primitive TkEphemeral        is Tk fun show(): String => "^"
primitive TkBorrowed         is Tk fun show(): String => "!"
primitive TkQuestion         is Tk fun show(): String => "?"
primitive TkUnaryMinus       is Tk fun show(): String => "-"
primitive TkConstant         is Tk fun show(): String => "#"
primitive TkLParenNew        is Tk fun show(): String => "("
primitive TkLSquareNew       is Tk fun show(): String => "["
primitive TkMinusNew         is Tk fun show(): String => "-"

// Literal tokens (whose strings give a literal value in the source)
primitive TkId               is Tk fun show(): String ? => error
primitive TkString           is Tk fun show(): String ? => error
primitive TkFloat            is Tk fun show(): String ? => error
primitive TkInt              is Tk fun show(): String ? => error

// Abstract tokens (whose strings don't correspond to explicit syntax strings)
primitive TkNone             is Tk fun show(): String => "x"
primitive TkProgram          is Tk fun show(): String => "program"
primitive TkPackage          is Tk fun show(): String => "package"
primitive TkModule           is Tk fun show(): String => "module"
primitive TkMembers          is Tk fun show(): String => "members"
primitive TkFVar             is Tk fun show(): String => "fvar"
primitive TkFLet             is Tk fun show(): String => "flet"
primitive TkFFIDecl          is Tk fun show(): String => "ffidecl"
primitive TkFFICall          is Tk fun show(): String => "fficall"
primitive TkProvides         is Tk fun show(): String => "provides"
primitive TkUnionType        is Tk fun show(): String => "uniontype"
primitive TkTupleType        is Tk fun show(): String => "tupletype"
primitive TkNominal          is Tk fun show(): String => "nominal"
primitive TkThisType         is Tk fun show(): String => "thistype"
primitive TkFunType          is Tk fun show(): String => "funtype"
primitive TkLambdaType       is Tk fun show(): String => "lambdatype"
primitive TkInferType        is Tk fun show(): String => "infer"
primitive TkErrorType        is Tk fun show(): String => "errortype"
primitive TkIsoBind          is Tk fun show(): String => "iso (bind)"
primitive TkTrnBind          is Tk fun show(): String => "trn (bind)"
primitive TkRefBind          is Tk fun show(): String => "ref (bind)"
primitive TkValBind          is Tk fun show(): String => "val (bind)"
primitive TkBoxBind          is Tk fun show(): String => "box (bind)"
primitive TkTagBind          is Tk fun show(): String => "tag (bind)"
primitive TkCapReadBind      is Tk fun show(): String => "#read (bind)"
primitive TkCapSendBind      is Tk fun show(): String => "#send (bind)"
primitive TkCapShareBind     is Tk fun show(): String => "#share (bind)"
primitive TkCapAnyBind       is Tk fun show(): String => "#any (bind)"
primitive TkLiteral          is Tk fun show(): String => "literal"
primitive TkLiteralBranch    is Tk fun show(): String => "branch"
primitive TkOperatorLiteral  is Tk fun show(): String => "opliteral"
primitive TkTypeParams       is Tk fun show(): String => "typeparams"
primitive TkTypeParam        is Tk fun show(): String => "typeparam"
primitive TkValueFormalParam is Tk fun show(): String => "valueformalparam"
primitive TkParams           is Tk fun show(): String => "params"
primitive TkParam            is Tk fun show(): String => "param"
primitive TkTypeArgs         is Tk fun show(): String => "typeargs"
primitive TkValueFormalArg   is Tk fun show(): String => "valueformalarg"
primitive TkPositionalArgs   is Tk fun show(): String => "positionalargs"
primitive TkNamedArgs        is Tk fun show(): String => "namedargs"
primitive TkNamedArg         is Tk fun show(): String => "namedarg"
primitive TkUpdateArg        is Tk fun show(): String => "updatearg"
primitive TkLambdaCaptures   is Tk fun show(): String => "lambdacaptures"
primitive TkLambdaCapture    is Tk fun show(): String => "lambdacapture"
primitive TkSeq              is Tk fun show(): String => "seq"
primitive TkQualify          is Tk fun show(): String => "qualify"
primitive TkCall             is Tk fun show(): String => "call"
primitive TkTuple            is Tk fun show(): String => "tuple"
primitive TkArray            is Tk fun show(): String => "array"
primitive TkCases            is Tk fun show(): String => "cases"
primitive TkCase             is Tk fun show(): String => "case"
primitive TkTryNoCheck       is Tk fun show(): String => "try"
primitive TkReference        is Tk fun show(): String => "reference"
primitive TkPackageRef       is Tk fun show(): String => "packageref"
primitive TkTypeRef          is Tk fun show(): String => "typeref"
primitive TkTypeParamRef     is Tk fun show(): String => "typeparamref"
primitive TkNewRef           is Tk fun show(): String => "newref"
primitive TkNewBeRef         is Tk fun show(): String => "newberef"
primitive TkBeRef            is Tk fun show(): String => "beref"
primitive TkFunRef           is Tk fun show(): String => "funref"
primitive TkFVarRef          is Tk fun show(): String => "fvarref"
primitive TkFLetRef          is Tk fun show(): String => "fletref"
primitive TkEmbedRef         is Tk fun show(): String => "embedref"
primitive TkVarRef           is Tk fun show(): String => "varref"
primitive TkLetRef           is Tk fun show(): String => "letref"
primitive TkParamRef         is Tk fun show(): String => "paramref"
primitive TkNewApp           is Tk fun show(): String => "newapp"
primitive TkBeApp            is Tk fun show(): String => "beapp"
primitive TkFunApp           is Tk fun show(): String => "funapp"

primitive _TkUtil
  fun all_tokens(): Array[Tk] val => recover [as Tk:
    TkDontCare,
    TkCompileIntrinsic,
    TkUse,
    TkType,
    TkInterface,
    TkTrait,
    TkPrimitive,
    TkStruct,
    TkClass,
    TkActor,
    TkObject,
    TkLambda,
    TkDelegate,
    TkAs,
    TkIs,
    TkIsnt,
    TkVar,
    TkLet,
    TkEmbed,
    TkNew,
    TkFun,
    TkBe,
    TkIso,
    TkTrn,
    TkRef,
    TkVal,
    TkBox,
    TkTag,
    TkThis,
    TkReturn,
    TkBreak,
    TkContinue,
    TkConsume,
    TkRecover,
    TkIf,
    TkIfdef,
    TkThen,
    TkElse,
    TkElseIf,
    TkEnd,
    TkFor,
    TkIn,
    TkWhile,
    TkDo,
    TkRepeat,
    TkUntil,
    TkMatch,
    TkWhere,
    TkTry,
    TkWith,
    TkError,
    TkCompileError,
    TkNot,
    TkAnd,
    TkOr,
    TkXor,
    TkIdentityOf,
    TkAddress,
    TkLocation,
    TkTrue,
    TkFalse,
    TkCapRead,
    TkCapSend,
    TkCapShare,
    TkCapAny,
    TkTestNoSeq,
    TkTestSeqScope,
    TkTestTryNoCheck,
    TkTestBorrowed,
    TkTestUpdateArg,
    TkTestExtra,
    TkIfdefAnd,
    TkIfdefOr,
    TkIfdefNot,
    TkIfdefFlag,
    TkMatchCapture,
    TkEllipsis,
    TkArrow,
    TkDoubleArrow,
    TkLShift,
    TkRShift,
    TkEq,
    TkNe,
    TkLe,
    TkGe,
    TkLBrace,
    TkRBrace,
    TkLParen,
    TkRParen,
    TkLSquare,
    TkRSquare,
    TkComma,
    TkDot,
    TkTilde,
    TkColon,
    TkSemi,
    TkAssign,
    TkPlus,
    TkMinus,
    TkMultiply,
    TkDivide,
    TkMod,
    TkAt,
    TkLt,
    TkGt,
    TkPipe,
    TkIntersectType,
    TkEphemeral,
    TkBorrowed,
    TkQuestion,
    TkUnaryMinus,
    TkConstant,
    TkLParenNew,
    TkLSquareNew,
    TkMinusNew,
    TkId,
    TkString,
    TkFloat,
    TkInt,
    TkNone,
    TkProgram,
    TkPackage,
    TkModule,
    TkMembers,
    TkFVar,
    TkFLet,
    TkFFIDecl,
    TkFFICall,
    TkProvides,
    TkUnionType,
    TkTupleType,
    TkNominal,
    TkThisType,
    TkFunType,
    TkLambdaType,
    TkInferType,
    TkErrorType,
    TkIsoBind,
    TkTrnBind,
    TkRefBind,
    TkValBind,
    TkBoxBind,
    TkTagBind,
    TkCapReadBind,
    TkCapSendBind,
    TkCapShareBind,
    TkCapAnyBind,
    TkLiteral,
    TkLiteralBranch,
    TkOperatorLiteral,
    TkTypeParams,
    TkTypeParam,
    TkValueFormalParam,
    TkParams,
    TkParam,
    TkTypeArgs,
    TkValueFormalArg,
    TkPositionalArgs,
    TkNamedArgs,
    TkNamedArg,
    TkUpdateArg,
    TkLambdaCaptures,
    TkLambdaCapture,
    TkSeq,
    TkQualify,
    TkCall,
    TkTuple,
    TkArray,
    TkCases,
    TkCase,
    TkTryNoCheck,
    TkReference,
    TkPackageRef,
    TkTypeRef,
    TkTypeParamRef,
    TkNewRef,
    TkNewBeRef,
    TkBeRef,
    TkFunRef,
    TkFVarRef,
    TkFLetRef,
    TkEmbedRef,
    TkVarRef,
    TkLetRef,
    TkParamRef,
    TkNewApp,
    TkBeApp,
    TkFunApp
  ] end
  
  fun find_by_name(name: String): Tk? =>
    for tk in all_tokens().values() do
      try if tk.show() == name then return tk end end
    end
    error

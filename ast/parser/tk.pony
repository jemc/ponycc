
use peg = "peg"

trait val TkAny is peg.Label
  fun text(): String => string() // Required for peg library, but otherwise unused.
  fun string(): String
  fun desc(): String

primitive Tk[A: (AST | None)] is TkAny
  fun string(): String => ASTInfo.name[A]()
  fun desc():   String => ASTInfo.name[A]()

///
// TODO: remove everything below this line, and `use ".."` instead

trait AST

primitive ASTInfo
  fun name[A: (AST | None)](): String =>
    iftype A <: None then "x"
    elseiftype A <: Program then "Program"
    elseiftype A <: Package then "Package"
    elseiftype A <: Module then "Module"
    elseiftype A <: UsePackage then "UsePackage"
    elseiftype A <: UseFFIDecl then "UseFFIDecl"
    elseiftype A <: FFIDecl then "FFIDecl"
    elseiftype A <: TypeAlias then "TypeAlias"
    elseiftype A <: Interface then "Interface"
    elseiftype A <: Trait then "Trait"
    elseiftype A <: Primitive then "Primitive"
    elseiftype A <: Struct then "Struct"
    elseiftype A <: Class then "Class"
    elseiftype A <: Actor then "Actor"
    elseiftype A <: Members then "Members"
    elseiftype A <: FieldLet then "FieldLet"
    elseiftype A <: FieldVar then "FieldVar"
    elseiftype A <: FieldEmbed then "FieldEmbed"
    elseiftype A <: MethodFun then "MethodFun"
    elseiftype A <: MethodNew then "MethodNew"
    elseiftype A <: MethodBe then "MethodBe"
    elseiftype A <: TypeParams then "TypeParams"
    elseiftype A <: TypeParam then "TypeParam"
    elseiftype A <: TypeArgs then "TypeArgs"
    elseiftype A <: Params then "Params"
    elseiftype A <: Param then "Param"
    elseiftype A <: ExprSeq then "ExprSeq"
    elseiftype A <: RawExprSeq then "RawExprSeq"
    elseiftype A <: Return then "Return"
    elseiftype A <: Break then "Break"
    elseiftype A <: Continue then "Continue"
    elseiftype A <: Error then "Error"
    elseiftype A <: CompileIntrinsic then "CompileIntrinsic"
    elseiftype A <: CompileError then "CompileError"
    elseiftype A <: LocalLet then "LocalLet"
    elseiftype A <: LocalVar then "LocalVar"
    elseiftype A <: MatchCapture then "MatchCapture"
    elseiftype A <: As then "As"
    elseiftype A <: Tuple then "Tuple"
    elseiftype A <: Consume then "Consume"
    elseiftype A <: Recover then "Recover"
    elseiftype A <: Not then "Not"
    elseiftype A <: Neg then "Neg"
    elseiftype A <: NegUnsafe then "NegUnsafe"
    elseiftype A <: AddressOf then "AddressOf"
    elseiftype A <: DigestOf then "DigestOf"
    elseiftype A <: Add then "Add"
    elseiftype A <: AddUnsafe then "AddUnsafe"
    elseiftype A <: Sub then "Sub"
    elseiftype A <: SubUnsafe then "SubUnsafe"
    elseiftype A <: Mul then "Mul"
    elseiftype A <: MulUnsafe then "MulUnsafe"
    elseiftype A <: Div then "Div"
    elseiftype A <: DivUnsafe then "DivUnsafe"
    elseiftype A <: Mod then "Mod"
    elseiftype A <: ModUnsafe then "ModUnsafe"
    elseiftype A <: LShift then "LShift"
    elseiftype A <: LShiftUnsafe then "LShiftUnsafe"
    elseiftype A <: RShift then "RShift"
    elseiftype A <: RShiftUnsafe then "RShiftUnsafe"
    elseiftype A <: Eq then "Eq"
    elseiftype A <: EqUnsafe then "EqUnsafe"
    elseiftype A <: NE then "NE"
    elseiftype A <: NEUnsafe then "NEUnsafe"
    elseiftype A <: LT then "LT"
    elseiftype A <: LTUnsafe then "LTUnsafe"
    elseiftype A <: LE then "LE"
    elseiftype A <: LEUnsafe then "LEUnsafe"
    elseiftype A <: GE then "GE"
    elseiftype A <: GEUnsafe then "GEUnsafe"
    elseiftype A <: GT then "GT"
    elseiftype A <: GTUnsafe then "GTUnsafe"
    elseiftype A <: Is then "Is"
    elseiftype A <: Isnt then "Isnt"
    elseiftype A <: And then "And"
    elseiftype A <: Or then "Or"
    elseiftype A <: XOr then "XOr"
    elseiftype A <: Assign then "Assign"
    elseiftype A <: Dot then "Dot"
    elseiftype A <: Chain then "Chain"
    elseiftype A <: Tilde then "Tilde"
    elseiftype A <: Qualify then "Qualify"
    elseiftype A <: Call then "Call"
    elseiftype A <: FFICall then "FFICall"
    elseiftype A <: Args then "Args"
    elseiftype A <: NamedArgs then "NamedArgs"
    elseiftype A <: NamedArg then "NamedArg"
    elseiftype A <: IfDef then "IfDef"
    elseiftype A <: IfType then "IfType"
    elseiftype A <: IfDefAnd then "IfDefAnd"
    elseiftype A <: IfDefOr then "IfDefOr"
    elseiftype A <: IfDefNot then "IfDefNot"
    elseiftype A <: IfDefFlag then "IfDefFlag"
    elseiftype A <: If then "If"
    elseiftype A <: While then "While"
    elseiftype A <: Repeat then "Repeat"
    elseiftype A <: For then "For"
    elseiftype A <: With then "With"
    elseiftype A <: Match then "Match"
    elseiftype A <: Cases then "Cases"
    elseiftype A <: Case then "Case"
    elseiftype A <: Try then "Try"
    elseiftype A <: Lambda then "Lambda"
    elseiftype A <: LambdaCaptures then "LambdaCaptures"
    elseiftype A <: LambdaCapture then "LambdaCapture"
    elseiftype A <: Object then "Object"
    elseiftype A <: LitArray then "LitArray"
    elseiftype A <: Reference then "Reference"
    elseiftype A <: DontCare then "DontCare"
    elseiftype A <: PackageRef then "PackageRef"
    elseiftype A <: MethodFunRef then "MethodFunRef"
    elseiftype A <: MethodNewRef then "MethodNewRef"
    elseiftype A <: MethodBeRef then "MethodBeRef"
    elseiftype A <: TypeRef then "TypeRef"
    elseiftype A <: FieldLetRef then "FieldLetRef"
    elseiftype A <: FieldVarRef then "FieldVarRef"
    elseiftype A <: FieldEmbedRef then "FieldEmbedRef"
    elseiftype A <: TupleElementRef then "TupleElementRef"
    elseiftype A <: LocalLetRef then "LocalLetRef"
    elseiftype A <: LocalVarRef then "LocalVarRef"
    elseiftype A <: ParamRef then "ParamRef"
    elseiftype A <: UnionType then "UnionType"
    elseiftype A <: IsectType then "IsectType"
    elseiftype A <: TupleType then "TupleType"
    elseiftype A <: ArrowType then "ArrowType"
    elseiftype A <: FunType then "FunType"
    elseiftype A <: LambdaType then "LambdaType"
    elseiftype A <: NominalType then "NominalType"
    elseiftype A <: TypeParamRef then "TypeParamRef"
    elseiftype A <: ThisType then "ThisType"
    elseiftype A <: DontCareType then "DontCareType"
    elseiftype A <: ErrorType then "ErrorType"
    elseiftype A <: LiteralType then "LiteralType"
    elseiftype A <: LiteralTypeBranch then "LiteralTypeBranch"
    elseiftype A <: OpLiteralType then "OpLiteralType"
    elseiftype A <: Iso then "Iso"
    elseiftype A <: Trn then "Trn"
    elseiftype A <: Ref then "Ref"
    elseiftype A <: Val then "Val"
    elseiftype A <: Box then "Box"
    elseiftype A <: Tag then "Tag"
    elseiftype A <: CapRead then "CapRead"
    elseiftype A <: CapSend then "CapSend"
    elseiftype A <: CapShare then "CapShare"
    elseiftype A <: CapAlias then "CapAlias"
    elseiftype A <: CapAny then "CapAny"
    elseiftype A <: Aliased then "Aliased"
    elseiftype A <: Ephemeral then "Ephemeral"
    elseiftype A <: At then "At"
    elseiftype A <: Question then "Question"
    elseiftype A <: Ellipsis then "Ellipsis"
    elseiftype A <: Id then "Id"
    elseiftype A <: This then "This"
    elseiftype A <: LitTrue then "LitTrue"
    elseiftype A <: LitFalse then "LitFalse"
    elseiftype A <: LitFloat then "LitFloat"
    elseiftype A <: LitInteger then "LitInteger"
    elseiftype A <: LitCharacter then "LitCharacter"
    elseiftype A <: LitString then "LitString"
    elseiftype A <: LitLocation then "LitLocation"
    elseiftype A <: EOF then "EOF"
    elseiftype A <: NewLine then "NewLine"
    elseiftype A <: Use then "Use"
    elseiftype A <: Colon then "Colon"
    elseiftype A <: Semicolon then "Semicolon"
    elseiftype A <: Comma then "Comma"
    elseiftype A <: Constant then "Constant"
    elseiftype A <: Pipe then "Pipe"
    elseiftype A <: Ampersand then "Ampersand"
    elseiftype A <: SubType then "SubType"
    elseiftype A <: Arrow then "Arrow"
    elseiftype A <: DoubleArrow then "DoubleArrow"
    elseiftype A <: Backslash then "Backslash"
    elseiftype A <: LParen then "LParen"
    elseiftype A <: RParen then "RParen"
    elseiftype A <: LBrace then "LBrace"
    elseiftype A <: RBrace then "RBrace"
    elseiftype A <: LSquare then "LSquare"
    elseiftype A <: RSquare then "RSquare"
    elseiftype A <: LParenNew then "LParenNew"
    elseiftype A <: LBraceNew then "LBraceNew"
    elseiftype A <: LSquareNew then "LSquareNew"
    elseiftype A <: SubNew then "SubNew"
    elseiftype A <: SubUnsafeNew then "SubUnsafeNew"
    elseiftype A <: In then "In"
    elseiftype A <: Until then "Until"
    elseiftype A <: Do then "Do"
    elseiftype A <: Else then "Else"
    elseiftype A <: ElseIf then "ElseIf"
    elseiftype A <: Then then "Then"
    elseiftype A <: End then "End"
    elseiftype A <: Var then "Var"
    elseiftype A <: Let then "Let"
    elseiftype A <: Embed then "Embed"
    elseiftype A <: Where then "Where"
    else "???"
    end

class Program is AST
class Package is AST
class Module is AST
class UsePackage is AST
class UseFFIDecl is AST
class FFIDecl is AST
class TypeAlias is AST
class Interface is AST
class Trait is AST
class Primitive is AST
class Struct is AST
class Class is AST
class Actor is AST
class Members is AST
class FieldLet is AST
class FieldVar is AST
class FieldEmbed is AST
class MethodFun is AST
class MethodNew is AST
class MethodBe is AST
class TypeParams is AST
class TypeParam is AST
class TypeArgs is AST
class Params is AST
class Param is AST
class ExprSeq is AST
class RawExprSeq is AST
class Return is AST
class Break is AST
class Continue is AST
class Error is AST
class CompileIntrinsic is AST
class CompileError is AST
class LocalLet is AST
class LocalVar is AST
class MatchCapture is AST
class As is AST
class Tuple is AST
class Consume is AST
class Recover is AST
class Not is AST
class Neg is AST
class NegUnsafe is AST
class AddressOf is AST
class DigestOf is AST
class Add is AST
class AddUnsafe is AST
class Sub is AST
class SubUnsafe is AST
class Mul is AST
class MulUnsafe is AST
class Div is AST
class DivUnsafe is AST
class Mod is AST
class ModUnsafe is AST
class LShift is AST
class LShiftUnsafe is AST
class RShift is AST
class RShiftUnsafe is AST
class Eq is AST
class EqUnsafe is AST
class NE is AST
class NEUnsafe is AST
class LT is AST
class LTUnsafe is AST
class LE is AST
class LEUnsafe is AST
class GE is AST
class GEUnsafe is AST
class GT is AST
class GTUnsafe is AST
class Is is AST
class Isnt is AST
class And is AST
class Or is AST
class XOr is AST
class Assign is AST
class Dot is AST
class Chain is AST
class Tilde is AST
class Qualify is AST
class Call is AST
class FFICall is AST
class Args is AST
class NamedArgs is AST
class NamedArg is AST
class IfDef is AST
class IfType is AST
class IfDefAnd is AST
class IfDefOr is AST
class IfDefNot is AST
class IfDefFlag is AST
class If is AST
class While is AST
class Repeat is AST
class For is AST
class With is AST
class Match is AST
class Cases is AST
class Case is AST
class Try is AST
class Lambda is AST
class LambdaCaptures is AST
class LambdaCapture is AST
class Object is AST
class LitArray is AST
class Reference is AST
class DontCare is AST
class PackageRef is AST
class MethodFunRef is AST
class MethodNewRef is AST
class MethodBeRef is AST
class TypeRef is AST
class FieldLetRef is AST
class FieldVarRef is AST
class FieldEmbedRef is AST
class TupleElementRef is AST
class LocalLetRef is AST
class LocalVarRef is AST
class ParamRef is AST
class UnionType is AST
class IsectType is AST
class TupleType is AST
class ArrowType is AST
class FunType is AST
class LambdaType is AST
class NominalType is AST
class TypeParamRef is AST
class ThisType is AST
class DontCareType is AST
class ErrorType is AST
class LiteralType is AST
class LiteralTypeBranch is AST
class OpLiteralType is AST
class Iso is AST
class Trn is AST
class Ref is AST
class Val is AST
class Box is AST
class Tag is AST
class CapRead is AST
class CapSend is AST
class CapShare is AST
class CapAlias is AST
class CapAny is AST
class Aliased is AST
class Ephemeral is AST
class At is AST
class Question is AST
class Ellipsis is AST
class Id is AST
class This is AST
class LitTrue is AST
class LitFalse is AST
class LitFloat is AST
class LitInteger is AST
class LitCharacter is AST
class LitString is AST
class LitLocation is AST
class EOF is AST
class NewLine is AST
class Use is AST
class Colon is AST
class Semicolon is AST
class Comma is AST
class Constant is AST
class Pipe is AST
class Ampersand is AST
class SubType is AST
class Arrow is AST
class DoubleArrow is AST
class Backslash is AST
class LParen is AST
class RParen is AST
class LBrace is AST
class RBrace is AST
class LSquare is AST
class RSquare is AST
class LParenNew is AST
class LBraceNew is AST
class LSquareNew is AST
class SubNew is AST
class SubUnsafeNew is AST
class In is AST
class Until is AST
class Do is AST
class Else is AST
class ElseIf is AST
class Then is AST
class End is AST
class Var is AST
class Let is AST
class Embed is AST
class Where is AST

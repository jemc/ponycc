
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
    elseif A <: Program then "Program"
    elseif A <: Package then "Package"
    elseif A <: Module then "Module"
    elseif A <: UsePackage then "UsePackage"
    elseif A <: UseFFIDecl then "UseFFIDecl"
    elseif A <: TypeAlias then "TypeAlias"
    elseif A <: Interface then "Interface"
    elseif A <: Trait then "Trait"
    elseif A <: Primitive then "Primitive"
    elseif A <: Struct then "Struct"
    elseif A <: Class then "Class"
    elseif A <: Actor then "Actor"
    elseif A <: Members then "Members"
    elseif A <: FieldLet then "FieldLet"
    elseif A <: FieldVar then "FieldVar"
    elseif A <: FieldEmbed then "FieldEmbed"
    elseif A <: MethodFun then "MethodFun"
    elseif A <: MethodNew then "MethodNew"
    elseif A <: MethodBe then "MethodBe"
    elseif A <: TypeParams then "TypeParams"
    elseif A <: TypeParam then "TypeParam"
    elseif A <: TypeArgs then "TypeArgs"
    elseif A <: Params then "Params"
    elseif A <: Param then "Param"
    elseif A <: ExprSeq then "ExprSeq"
    elseif A <: RawExprSeq then "RawExprSeq"
    elseif A <: Return then "Return"
    elseif A <: Break then "Break"
    elseif A <: Continue then "Continue"
    elseif A <: Error then "Error"
    elseif A <: CompileIntrinsic then "CompileIntrinsic"
    elseif A <: CompileError then "CompileError"
    elseif A <: LocalLet then "LocalLet"
    elseif A <: LocalVar then "LocalVar"
    elseif A <: MatchCapture then "MatchCapture"
    elseif A <: As then "As"
    elseif A <: Tuple then "Tuple"
    elseif A <: Consume then "Consume"
    elseif A <: Recover then "Recover"
    elseif A <: Not then "Not"
    elseif A <: Neg then "Neg"
    elseif A <: NegUnsafe then "NegUnsafe"
    elseif A <: AddressOf then "AddressOf"
    elseif A <: DigestOf then "DigestOf"
    elseif A <: Add then "Add"
    elseif A <: AddUnsafe then "AddUnsafe"
    elseif A <: Sub then "Sub"
    elseif A <: SubUnsafe then "SubUnsafe"
    elseif A <: Mul then "Mul"
    elseif A <: MulUnsafe then "MulUnsafe"
    elseif A <: Div then "Div"
    elseif A <: DivUnsafe then "DivUnsafe"
    elseif A <: Mod then "Mod"
    elseif A <: ModUnsafe then "ModUnsafe"
    elseif A <: LShift then "LShift"
    elseif A <: LShiftUnsafe then "LShiftUnsafe"
    elseif A <: RShift then "RShift"
    elseif A <: RShiftUnsafe then "RShiftUnsafe"
    elseif A <: Eq then "Eq"
    elseif A <: EqUnsafe then "EqUnsafe"
    elseif A <: NE then "NE"
    elseif A <: NEUnsafe then "NEUnsafe"
    elseif A <: LT then "LT"
    elseif A <: LTUnsafe then "LTUnsafe"
    elseif A <: LE then "LE"
    elseif A <: LEUnsafe then "LEUnsafe"
    elseif A <: GE then "GE"
    elseif A <: GEUnsafe then "GEUnsafe"
    elseif A <: GT then "GT"
    elseif A <: GTUnsafe then "GTUnsafe"
    elseif A <: Is then "Is"
    elseif A <: Isnt then "Isnt"
    elseif A <: And then "And"
    elseif A <: Or then "Or"
    elseif A <: XOr then "XOr"
    elseif A <: Assign then "Assign"
    elseif A <: Dot then "Dot"
    elseif A <: Chain then "Chain"
    elseif A <: Tilde then "Tilde"
    elseif A <: Qualify then "Qualify"
    elseif A <: Call then "Call"
    elseif A <: FFICall then "FFICall"
    elseif A <: Args then "Args"
    elseif A <: NamedArgs then "NamedArgs"
    elseif A <: NamedArg then "NamedArg"
    elseif A <: IfDef then "IfDef"
    elseif A <: IfType then "IfType"
    elseif A <: IfDefAnd then "IfDefAnd"
    elseif A <: IfDefOr then "IfDefOr"
    elseif A <: IfDefNot then "IfDefNot"
    elseif A <: IfDefFlag then "IfDefFlag"
    elseif A <: If then "If"
    elseif A <: While then "While"
    elseif A <: Repeat then "Repeat"
    elseif A <: For then "For"
    elseif A <: With then "With"
    elseif A <: Match then "Match"
    elseif A <: Cases then "Cases"
    elseif A <: Case then "Case"
    elseif A <: Try then "Try"
    elseif A <: Lambda then "Lambda"
    elseif A <: LambdaCaptures then "LambdaCaptures"
    elseif A <: LambdaCapture then "LambdaCapture"
    elseif A <: Object then "Object"
    elseif A <: LitArray then "LitArray"
    elseif A <: Reference then "Reference"
    elseif A <: DontCare then "DontCare"
    elseif A <: PackageRef then "PackageRef"
    elseif A <: MethodFunRef then "MethodFunRef"
    elseif A <: MethodNewRef then "MethodNewRef"
    elseif A <: MethodBeRef then "MethodBeRef"
    elseif A <: TypeRef then "TypeRef"
    elseif A <: FieldLetRef then "FieldLetRef"
    elseif A <: FieldVarRef then "FieldVarRef"
    elseif A <: FieldEmbedRef then "FieldEmbedRef"
    elseif A <: TupleElementRef then "TupleElementRef"
    elseif A <: LocalLetRef then "LocalLetRef"
    elseif A <: LocalVarRef then "LocalVarRef"
    elseif A <: ParamRef then "ParamRef"
    elseif A <: UnionType then "UnionType"
    elseif A <: IsectType then "IsectType"
    elseif A <: TupleType then "TupleType"
    elseif A <: ArrowType then "ArrowType"
    elseif A <: FunType then "FunType"
    elseif A <: LambdaType then "LambdaType"
    elseif A <: NominalType then "NominalType"
    elseif A <: TypeParamRef then "TypeParamRef"
    elseif A <: ThisType then "ThisType"
    elseif A <: DontCareType then "DontCareType"
    elseif A <: ErrorType then "ErrorType"
    elseif A <: LiteralType then "LiteralType"
    elseif A <: LiteralTypeBranch then "LiteralTypeBranch"
    elseif A <: OpLiteralType then "OpLiteralType"
    elseif A <: Iso then "Iso"
    elseif A <: Trn then "Trn"
    elseif A <: Ref then "Ref"
    elseif A <: Val then "Val"
    elseif A <: Box then "Box"
    elseif A <: Tag then "Tag"
    elseif A <: CapRead then "CapRead"
    elseif A <: CapSend then "CapSend"
    elseif A <: CapShare then "CapShare"
    elseif A <: CapAlias then "CapAlias"
    elseif A <: CapAny then "CapAny"
    elseif A <: Aliased then "Aliased"
    elseif A <: Ephemeral then "Ephemeral"
    elseif A <: At then "At"
    elseif A <: Question then "Question"
    elseif A <: Ellipsis then "Ellipsis"
    elseif A <: Id then "Id"
    elseif A <: This then "This"
    elseif A <: LitTrue then "LitTrue"
    elseif A <: LitFalse then "LitFalse"
    elseif A <: LitFloat then "LitFloat"
    elseif A <: LitInteger then "LitInteger"
    elseif A <: LitCharacter then "LitCharacter"
    elseif A <: LitString then "LitString"
    elseif A <: LitLocation then "LitLocation"
    elseif A <: EOF then "EOF"
    elseif A <: NewLine then "NewLine"
    elseif A <: Use then "Use"
    elseif A <: Colon then "Colon"
    elseif A <: Semicolon then "Semicolon"
    elseif A <: Comma then "Comma"
    elseif A <: Constant then "Constant"
    elseif A <: Pipe then "Pipe"
    elseif A <: Ampersand then "Ampersand"
    elseif A <: SubType then "SubType"
    elseif A <: Arrow then "Arrow"
    elseif A <: DoubleArrow then "DoubleArrow"
    elseif A <: Backslash then "Backslash"
    elseif A <: LParen then "LParen"
    elseif A <: RParen then "RParen"
    elseif A <: LBrace then "LBrace"
    elseif A <: RBrace then "RBrace"
    elseif A <: LSquare then "LSquare"
    elseif A <: RSquare then "RSquare"
    elseif A <: LParenNew then "LParenNew"
    elseif A <: LBraceNew then "LBraceNew"
    elseif A <: LSquareNew then "LSquareNew"
    elseif A <: SubNew then "SubNew"
    elseif A <: SubUnsafeNew then "SubUnsafeNew"
    elseif A <: In then "In"
    elseif A <: Until then "Until"
    elseif A <: Do then "Do"
    elseif A <: Else then "Else"
    elseif A <: ElseIf then "ElseIf"
    elseif A <: Then then "Then"
    elseif A <: End then "End"
    elseif A <: Var then "Var"
    elseif A <: Let then "Let"
    elseif A <: Embed then "Embed"
    elseif A <: Where then "Where"
    else "???"
    end

class Program is AST
class Package is AST
class Module is AST
class UsePackage is AST
class UseFFIDecl is AST
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

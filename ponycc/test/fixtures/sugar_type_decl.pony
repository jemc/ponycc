"""
$SUGAR
$CHECK type_decls-0.cap
Ref
$CHECK type_decls-1.cap
Box
$CHECK type_decls-2.cap
Ref
$CHECK type_decls-3.cap
Box
$CHECK type_decls-4.cap
Val
$CHECK type_decls-5.cap
Ref
$CHECK type_decls-6.cap
Box
$CHECK type_decls-7.cap
Ref
$CHECK type_decls-8.cap
Box
$CHECK type_decls-9.cap
Tag

$CHECK type_decls-0.members
Members([], [])
$CHECK type_decls-2.members
Members([], [])
$CHECK type_decls-4.members
Members([], [MethodNew(Id(create), Val, None, Params([], None),
 None, None, None, Sequence([LitTrue]), None)])
$CHECK type_decls-5.members
Members([], [MethodNew(Id(create), Iso, None, Params([], None),
 None, None, None, Sequence([LitTrue]), None)])
$CHECK type_decls-7.members
Members([], [MethodNew(Id(create), Iso, None, Params([], None),
 None, None, None, Sequence([LitTrue]), None)])
$CHECK type_decls-9.members
Members([], [MethodNew(Id(create), Tag, None, Params([], None),
 None, None, None, Sequence([LitTrue]), None)])

$CHECK type_decls-10.members.methods-0
MethodNew(Id(create), Val, None, Params([], None),
 NominalType(Id(PrimitiveWithMembers), None, None, Val, Ephemeral),
 None, None, Sequence([LitFalse]), None)
$CHECK type_decls-10.members.methods-1
MethodNew(Id(other_new), Val, None, Params([], None),
 NominalType(Id(PrimitiveWithMembers), None, None, Val, Ephemeral),
 None, None, Sequence([LitFalse]), None)
$CHECK type_decls-10.members.methods-2
MethodFun(Id(other_fun), Box, None, Params([], None),
 NominalType(Id(None), None, None, None, None),
 None, None, Sequence([LitFalse]), None)

$CHECK type_decls-11.members.methods-0
MethodNew(Id(create), Ref, None, Params([], None),
 NominalType(Id(StructWithMembers), None, None, Ref, Ephemeral),
 None, None, Sequence([Assign(Reference(Id(a)), LitTrue);
 Assign(Reference(Id(b)), LitFalse); LitFalse]), None)
$CHECK type_decls-11.members.methods-1
MethodNew(Id(other_new), Ref, None, Params([], None),
 NominalType(Id(StructWithMembers), None, None, Ref, Ephemeral),
 None, None, Sequence([Assign(Reference(Id(a)), LitTrue);
 Assign(Reference(Id(b)), LitFalse); LitFalse]), None)
$CHECK type_decls-11.members.methods-2
MethodFun(Id(other_fun), Box, None, Params([], None),
 NominalType(Id(None), None, None, None, None),
 None, None, Sequence([LitFalse]), None)

$CHECK type_decls-12.members.methods-0
MethodNew(Id(create), Ref, None, Params([], None),
 NominalType(Id(ClassWithMembers), None, None, Ref, Ephemeral),
 None, None, Sequence([Assign(Reference(Id(a)), LitTrue);
 Assign(Reference(Id(b)), LitFalse); LitFalse]), None)
$CHECK type_decls-12.members.methods-1
MethodNew(Id(other_new), Ref, None, Params([], None),
 NominalType(Id(ClassWithMembers), None, None, Ref, Ephemeral),
 None, None, Sequence([Assign(Reference(Id(a)), LitTrue);
 Assign(Reference(Id(b)), LitFalse); LitFalse]), None)
$CHECK type_decls-12.members.methods-2
MethodFun(Id(other_fun), Box, None, Params([], None),
 NominalType(Id(None), None, None, None, None),
 None, None, Sequence([LitFalse]), None)

$CHECK type_decls-13.members.methods-0
MethodNew(Id(create), Tag, None, Params([], None),
 NominalType(Id(ActorWithMembers), None, None, Tag, Ephemeral),
 None, None, Sequence([Assign(Reference(Id(a)), LitTrue);
 Assign(Reference(Id(b)), LitFalse); LitFalse]), None)
$CHECK type_decls-13.members.methods-1
MethodNew(Id(other_new), Tag, None, Params([], None),
 NominalType(Id(ActorWithMembers), None, None, Tag, Ephemeral),
 None, None, Sequence([Assign(Reference(Id(a)), LitTrue);
 Assign(Reference(Id(b)), LitFalse); LitFalse]), None)
$CHECK type_decls-13.members.methods-2
MethodFun(Id(other_fun), Box, None, Params([], None),
 NominalType(Id(None), None, None, None, None),
 None, None, Sequence([LitFalse]), None)

"""

interface Interface
interface box InterfaceBox

trait Trait
trait box TraitBox

primitive Primitive

struct Struct
struct box StructBox

class Class
class box ClassBox

actor Actor

primitive PrimitiveWithMembers
  new create() => false
  new other_new() => false
  fun other_fun() => false

struct StructWithMembers
  let a: A = true
  var b: B = false
  embed c: C
  new create() => false
  new other_new() => false
  fun other_fun() => false

class ClassWithMembers
  let a: A = true
  var b: B = false
  embed c: C
  new create() => false
  new other_new() => false
  fun other_fun() => false

actor ActorWithMembers
  let a: A = true
  var b: B = false
  embed c: C
  new create() => false
  new other_new() => false
  fun other_fun() => false
  be other_be() => false

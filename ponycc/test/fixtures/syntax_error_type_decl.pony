"""
$SYNTAX
$ERROR A type alias must specify a type.
type TypeAliasWithoutType
^~~~
$ERROR A type alias cannot specify a default capability.
type box TypeAliasWithCap is X
     ^~~
$ERROR A primitive cannot specify a default capability.
primitive box PrimitiveWithCap
          ^~~
$ERROR An actor cannot specify a default capability.
actor box ActorWithCap
      ^~~
$ERROR A type alias cannot specify a C API.
type @TypeAliasWithCAPI is X
     ^
$ERROR An interface cannot specify a C API.
interface @InterfaceWithCAPI
          ^
$ERROR A trait cannot specify a C API.
trait @TraitWithCAPI
      ^
$ERROR A primitive cannot specify a C API.
primitive @PrimitiveWithCAPI
          ^
$ERROR A struct cannot specify a C API.
struct @StructWithCAPI
       ^
$ERROR A class cannot specify a C API.
class @ClassWithCAPI
      ^
$ERROR A type alias cannot have fields.
  let type_field: X
  ^~~
$ERROR An interface cannot have fields.
  let interface_field: X
  ^~~
$ERROR A trait cannot have fields.
  let trait_field: X
  ^~~
$ERROR A primitive cannot have fields.
  let primitive_field: X
  ^~~
$ERROR A C API type cannot have type parameters.
actor @CAPIWithTypeParameters[X]
                             ^
"""

type TypeAliasWithoutType

type box TypeAliasWithCap is X
interface box InterfaceWithCap
trait box TraitWithCap
primitive box PrimitiveWithCap
struct box StructWithCap
class box ClassWithCap
actor box ActorWithCap

type @TypeAliasWithCAPI is X
interface @InterfaceWithCAPI
trait @TraitWithCAPI
primitive @PrimitiveWithCAPI
struct @StructWithCAPI
class @ClassWithCAPI
actor @ActorWithCAPI

// TODO: support these errors:

// $ERROR A type alias cannot be named Main - Main must be an actor.
// type Main
//      ^~~~
// $ERROR An interface cannot be named Main - Main must be an actor.
// interface Main
//           ^~~~
// $ERROR A trait cannot be named Main - Main must be an actor.
// trait Main
//       ^~~~
// $ERROR A primitive cannot be named Main - Main must be an actor.
// primitive Main
//           ^~~~
// $ERROR A struct cannot be named Main - Main must be an actor.
// struct Main
//        ^~~~
// $ERROR A class cannot be named Main - Main must be an actor.
// class Main
//       ^~~~

// type Main is X
// interface Main
// trait Main
// primitive Main
// struct Main
// class Main
// actor Main

type TypeAliasWithField is X
  let type_field: X

interface InterfaceWithField
  let interface_field: X

trait TraitWithField
  let trait_field: X

primitive PrimitiveWithField
  let primitive_field: X

struct StructWithField
  let struct_field: X

class ClassWithField
  let class_field: X

actor ActorWithField
  let actor_field: X

actor @CAPIWithTypeParameters[X]

"""
$SYNTAX
$ERROR A behaviour cannot specify a receiver capability.
  be val interface_behaviour_with_cap()
     ^~~
$ERROR A behaviour cannot specify a receiver capability.
  be val trait_behaviour_with_cap()
     ^~~
$ERROR A primitive constructor cannot specify a receiver capability.
  new iso primitive_constructor_with_cap() => None
      ^~~
$ERROR A behaviour cannot specify a receiver capability.
  be val actor_behaviour_with_cap() => None
     ^~~
$ERROR Only functions can specify a return type.
  new interface_constructor_with_return_type(): X
                                                ^
$ERROR Only functions can specify a return type.
  be interface_behaviour_with_return_type(): X
                                             ^
$ERROR Only functions can specify a return type.
  new trait_constructor_with_return_type(): X
                                            ^
$ERROR Only functions can specify a return type.
  be trait_behaviour_with_return_type(): X
                                         ^
$ERROR Only functions can specify a return type.
  new primitive_constructor_with_return_type(): X => None
                                                ^
$ERROR Only functions can specify a return type.
  new struct_constructor_with_return_type(): X => None
                                             ^
$ERROR Only functions can specify a return type.
  new class_constructor_with_return_type(): X => None
                                            ^
$ERROR Only functions can specify a return type.
  new actor_constructor_with_return_type(): X => None
                                            ^
$ERROR Only functions can specify a return type.
  be actor_behaviour_with_return_type(): X => None
                                         ^
$ERROR A behaviour cannot be partial.
  be interface_behaviour_partial() ?
                                   ^
$ERROR A behaviour cannot be partial.
  be trait_behaviour_partial() ?
                               ^
$ERROR An actor constructor cannot be partial.
  new actor_constructor_partial() ? => None
                                  ^
$ERROR A behaviour cannot be partial.
  be actor_behaviour_partial() ? => None
                               ^
$ERROR A trait or interface constructor cannot provide a body.
  new interface_constructor_with_body() => None
                                           ^~~~
$ERROR A trait or interface constructor cannot provide a body.
  new trait_constructor_with_body() => None
                                       ^~~~
$ERROR This function must provide a body.
  fun primitive_function_no_body()
  ^~~
$ERROR This constructor must provide a body.
  new primitive_constructor_no_body()
  ^~~
$ERROR This function must provide a body.
  fun struct_function_no_body()
  ^~~
$ERROR This constructor must provide a body.
  new struct_constructor_no_body()
  ^~~
$ERROR This function must provide a body.
  fun class_function_no_body()
  ^~~
$ERROR This constructor must provide a body.
  new class_constructor_no_body()
  ^~~
$ERROR This function must provide a body.
  fun actor_function_no_body()
  ^~~
$ERROR This constructor must provide a body.
  new actor_constructor_no_body()
  ^~~
$ERROR This behaviour must provide a body.
  be actor_behaviour_no_body()
  ^~
$ERROR Method guards are not yet supported in this compiler.
  fun method_with_guard() if false => None
                             ^~~~~
"""

interface InterfaceMethodsWithCap
  fun box interface_function_with_cap()
  new iso interface_constructor_with_cap()
  be val interface_behaviour_with_cap()

trait TraitMethodsWithCap
  fun box trait_function_with_cap()
  new iso trait_constructor_with_cap()
  be val trait_behaviour_with_cap()

primitive PrimitiveMethodsWithCap
  fun box primitive_function_with_cap() => None
  new iso primitive_constructor_with_cap() => None

struct StructMethodsWithCap
  fun box struct_function_with_cap() => None
  new iso struct_constructor_with_cap() => None

class ClassMethodsWithCap
  fun box class_function_with_cap() => None
  new iso class_constructor_with_cap() => None

actor ActorMethodsWithCap
  fun box actor_function_with_cap() => None
  new iso actor_constructor_with_cap() => None
  be val actor_behaviour_with_cap() => None

interface InterfaceMethodsWithReturnType
  fun interface_function_with_return_type(): X
  new interface_constructor_with_return_type(): X
  be interface_behaviour_with_return_type(): X

trait TraitMethodsWithReturnType
  fun trait_function_with_return_type(): X
  new trait_constructor_with_return_type(): X
  be trait_behaviour_with_return_type(): X

primitive PrimitiveMethodsWithReturnType
  fun primitive_function_with_return_type(): X => None
  new primitive_constructor_with_return_type(): X => None

struct StructMethodsWithReturnType
  fun struct_function_with_return_type(): X => None
  new struct_constructor_with_return_type(): X => None

class ClassMethodsWithReturnType
  fun class_function_with_return_type(): X => None
  new class_constructor_with_return_type(): X => None

actor ActorMethodsWithReturnType
  fun actor_function_with_return_type(): X => None
  new actor_constructor_with_return_type(): X => None
  be actor_behaviour_with_return_type(): X => None

interface InterfaceMethodsPartial
  fun interface_function_partial() ?
  new interface_constructor_partial() ?
  be interface_behaviour_partial() ?

trait TraitMethodsPartial
  fun trait_function_partial() ?
  new trait_constructor_partial() ?
  be trait_behaviour_partial() ?

primitive PrimitiveMethodsPartial
  fun primitive_function_partial() ? => None
  new primitive_constructor_partial() ? => None

struct StructMethodsPartial
  fun struct_function_partial() ? => None
  new struct_constructor_partial() ? => None

class ClassMethodsPartial
  fun class_function_partial() ? => None
  new class_constructor_partial() ? => None

actor ActorMethodsPartial
  fun actor_function_partial() ? => None
  new actor_constructor_partial() ? => None
  be actor_behaviour_partial() ? => None

interface InterfaceMethodsWithBody
  fun interface_function_with_body() => None
  new interface_constructor_with_body() => None
  be interface_behaviour_with_body() => None

trait TraitMethodsWithBody
  fun trait_function_with_body() => None
  new trait_constructor_with_body() => None
  be trait_behaviour_with_body() => None

primitive PrimitiveMethodsWithBody
  fun primitive_function_with_body() => None
  new primitive_constructor_with_body() => None

struct StructMethodsWithBody
  fun struct_function_with_body() => None
  new struct_constructor_with_body() => None

class ClassMethodsWithBody
  fun class_function_with_body() => None
  new class_constructor_with_body() => None

actor ActorMethodsWithBody
  fun actor_function_with_body() => None
  new actor_constructor_with_body() => None
  be actor_behaviour_with_body() => None

interface InterfaceMethodsNoBody
  fun interface_function_no_body()
  new interface_constructor_no_body()
  be interface_behaviour_no_body()

trait TraitMethodsNoBody
  fun trait_function_no_body()
  new trait_constructor_no_body()
  be trait_behaviour_no_body()

primitive PrimitiveMethodsNoBody
  fun primitive_function_no_body()
  new primitive_constructor_no_body()

struct StructMethodsNoBody
  fun struct_function_no_body()
  new struct_constructor_no_body()

class ClassMethodsNoBody
  fun class_function_no_body()
  new class_constructor_no_body()

actor ActorMethodsNoBody
  fun actor_function_no_body()
  new actor_constructor_no_body()
  be actor_behaviour_no_body()

primitive P
  fun method_with_guard() if false => None

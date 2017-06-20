"""
$SYNTAX
$ERROR `this` can only be used in a type as a viewpoint.
  fun this_type(): this => None
                   ^~~~
$ERROR `this` can only be used in a type as a viewpoint.
  fun type_arrow_this(): None->this => None
                               ^~~~
$ERROR A tuple cannot be used as a type parameter constraint.
  fun constraint_tuple[A: (U8, U8)]() => None
                          ^
$ERROR A tuple cannot be used as a type parameter constraint.
  fun constraint_union_tuple[A: ((U8, U8) | U64)]() => None
                                 ^
"""

primitive P
  fun this_type(): this => None
  fun this_arrow_type(): this->None => None
  fun type_arrow_this(): None->this => None
  
  fun constraint_tuple[A: (U8, U8)]() => None
  fun constraint_union_tuple[A: ((U8, U8) | U64)]() => None
  fun constraint_type_arg_tuple[A: Array[(U8, U8)]]() => None

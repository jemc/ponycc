"""
$SYNTAX
$ERROR `this` can only be used in a type as a viewpoint.
  fun this_type(): this => None
                   ^~~~
$ERROR `this` can only be used in a type as a viewpoint.
  fun type_arrow_this(): None->this => None
                               ^~~~
"""

primitive P
  fun this_type(): this => None
  fun this_arrow_type(): this->None => None
  fun type_arrow_this(): None->this => None

"""
$NAMES
$ERROR This is a referenced type.
primitive X
          ^
$ERROR This is a reference.
  fun apply(): X => X
               ^
$ERROR This is a reference.
  fun bogus(): Y => Y
               ^
"""

primitive X

primitive P
  fun apply(): X => X
  fun bogus(): Y => Y

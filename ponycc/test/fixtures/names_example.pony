"""
$NAMES
$ERROR This is a referenced type.
primitive X
          ^
$ERROR This is a reference.
  fun apply(): X => X
               ^
"""

primitive X

primitive P
  fun apply(): X => X

"""
$SYNTAX
$ERROR An error cannot have a value expression.
    error "value"
          ^~~~~~~
"""

primitive P
  fun apply() =>
    error
    error "value"

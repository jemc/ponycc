"""
$PRINT
"""

primitive P
  fun apply() =>
    foo(A, B, C)
    foo(where a = A, b = B, c = C)
    foo(A, B where c = C)

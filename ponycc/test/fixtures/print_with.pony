"""
$PRINT
"""

primitive P
  fun apply() =>
    with a = A do
      a
    else
      None
      None
    end
    with a = A, b = B, c = C do
      a
      b
      c
    end

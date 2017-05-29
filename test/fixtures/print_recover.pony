"""
$PRINT
"""

primitive P
  fun apply(x: A) =>
    recover
      A(consume x)
    end
    recover val
      A(consume val x)
    end

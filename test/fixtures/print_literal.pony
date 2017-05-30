"""
$PRINT
"""

primitive P
  fun test_simple() =>
    this
    true
    false
    88
    88.8
    8e8
    "foo"
    'f'
    __loc
  
  fun test_array() =>
    [
      A
      B
      C
    ]
    [as T:
      A
      B
      C
    ]
  
  fun test_tuple() =>
    (A, B, C)
    ((A, B), C)
    (A, (B, C))

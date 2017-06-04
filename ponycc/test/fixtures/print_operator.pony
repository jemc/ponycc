"""
$PRINT
"""

primitive P
  fun test_arithmetic() =>
    7 + 8 + 9
    (7 + 8) + 9
    7 - 8 - 9
    7 - (8 - 9)
    7 * 8 * 9
    (7 * 8) * 9
    7 / 8 / 9
    7 / (8 / 9)
    7 >> 8 >> 9
    (7 >> 8) >> 9
    7 << 8 << 9
    7 << (8 << 9)
    -7 + 8 + 9
    -(7 + 8) + 9
    -(7 + 8 + 9)
  
  fun test_arithmetic_unsafe() =>
    7 +~ 8 +~ 9
    (7 +~ 8) +~ 9
    7 -~ 8 -~ 9
    7 -~ (8 -~ 9)
    7 *~ 8 *~ 9
    (7 *~ 8) *~ 9
    7 /~ 8 /~ 9
    7 /~ (8 /~ 9)
    7 >>~ 8 >>~ 9
    (7 >>~ 8) >>~ 9
    7 <<~ 8 <<~ 9
    7 <<~ (8 <<~ 9)
    -~7 + 8 + 9
    -~(7 + 8) + 9
    -~(7 + 8 + 9)
  
  fun test_comparison(a: A, b: B, c: C) =>
    a == b == c
    (a == b) == c
    a != b != c
    a != (b != c)
    a >= b >= c
    (a >= b) >= c
    a <= b <= c
    a <= (b <= c)
    a > b > c
    (a > b) > c
    a < b < c
    a < (b < c)
  
  fun test_comparison_unsafe(a: A, b: B, c: C) =>
    a ==~ b ==~ c
    (a ==~ b) ==~ c
    a !=~ b !=~ c
    a !=~ (b !=~ c)
    a >=~ b >=~ c
    (a >=~ b) >=~ c
    a <=~ b <=~ c
    a <=~ (b <=~ c)
    a >~ b >~ c
    (a >~ b) >~ c
    a <~ b <~ c
    a <~ (b <~ c)
  
  fun test_logical(a: Bool, b: Bool, c: Bool) =>
    a and b and c
    a and (b or c)
    a or b or c
    (a or b) and c
    a xor b xor c
    (not a) and (not not b) and c
    not (a and (not not (b and c)))
  
  fun test_identity(a: A, b: B, c: C) =>
    a is b is c
    (a is b) is c
    a isnt b isnt c
    a isnt (b isnt c)
    (addressof a) is (addressof addressof b) is c
    addressof (a is (addressof addressof (b is c)))
    (digestof a) is (digestof digestof b) is c
    digestof (a is (digestof digestof (b is c)))

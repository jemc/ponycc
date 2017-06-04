"""
$PRINT
"""

primitive P
  fun apply(x: (A | B | C)) =>
    match x
    | let a: A =>
      a
      a
    | let b: B =>
      b
      b
    | let c: C if c < 0 =>
      c
      c
    else
      None
      None
    end
    match x
    | A | B | C =>
      None
    end

"""
$SYNTAX
$ERROR The final case in a match block must have a body.
    match u | 0 | 1 else None end
                ^
"""

primitive P
  fun apply(u: U64) =>
    match u | 0 | 1 => None else None end
    match u | 0 | 1 else None end

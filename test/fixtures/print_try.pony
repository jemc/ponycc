"""
$PRINT
"""

primitive P
  fun apply(x: (A | B | C)) =>
    try
      x as A
    end
    try
      partial()
    else
      None
    then
      None
    end

"""
$PRINT
"""

class C
  let e: {()}
  let f: {(I32, I32): String ?}
  let g: {val foo(I32, I32): String} val
  
  fun apply() =>
    e = {() =>
      None
    }
    f = {(a: I32, b: I32): String ? =>
      error
    }
    g = {val foo(a: I32, b: I32)(e): String =>
      ""
    } val

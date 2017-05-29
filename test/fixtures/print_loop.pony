"""
$PRINT
"""

primitive P
  fun test_while() =>
    while true do
      break
      break A
    end
    while false do
      continue
      continue A
    else
      None
      None
    end
  
  fun test_repeat() =>
    repeat
      return
      return A
    until true
    end
    repeat
      return
      return A
    until false else
      None
      None
    end

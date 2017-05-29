"""
$PRINT
"""

primitive P
  fun test_if(a: Bool, b: Bool, c: Bool) =>
    if a then
      A
    end
    if a then
      A
    else
      None
    end
    if a then
      A
    elseif b then
      B
    elseif c then
      C
    end
    if a then
      A
    elseif b then
      B
    else
      None
    end
  
  fun test_ifdef() =>
    ifdef "custom" then
      A
    end
    ifdef linux then
      A
    else
      None
    end
    ifdef linux then
      A
    elseif osx then
      B
    elseif windows then
      C
    end
    ifdef linux then
      A
    elseif osx then
      B
    else
      None
    end
  
  fun test_iftype[X: (A | B | C)]() =>
    iftype X <: A then
      A
    end
    iftype X <: A then
      A
    else
      None
    end
    iftype X <: A then
      A
    elseif X <: B then
      B
    elseif X <: C then
      C
    end
    iftype X <: A then
      A
    elseif X <: B then
      B
    else
      None
    end

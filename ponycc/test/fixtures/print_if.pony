"""
$PRINT
"""

primitive P
  fun test_if(a: Bool, b: Bool, c: Bool) =>
    if a then
      A
      A
    end
    if a then
      A
      A
    else
      None
      None
    end
    if a then
      A
      A
    elseif b then
      B
      B
    elseif c then
      C
      C
    end
    if a then
      A
      A
    elseif b then
      B
      B
    else
      None
      None
    end

  fun test_ifdef() =>
    ifdef "custom" then
      A
      A
    end
    ifdef linux then
      A
      A
    else
      compile_error
      compile_error "message"
    end
    ifdef linux then
      A
      A
    elseif osx then
      B
      B
    elseif windows then
      C
      C
    end
    ifdef linux then
      A
      A
    elseif osx then
      B
      B
    else
      compile_intrinsic
      compile_intrinsic None
    end

  fun test_iftype[X: (A | B | C)]() =>
    iftype X <: A then
      A
      A
    end
    iftype X <: A then
      A
      A
    else
      None
      None
    end
    iftype X <: A then
      A
      A
    elseif X <: B then
      B
      B
    elseif X <: C then
      C
      C
    end
    iftype X <: A then
      A
      A
    elseif X <: B then
      B
      B
    else
      None
      None
    end

"""
$PARSE
$ERROR Syntax error: Unterminated lambda expression
      {(n: U64): U64 => n - 1
      ^
$ERROR Expected terminating lambda expression before here
    end
    ^~~
"""

actor Main
  new create(env: Env) =>
    if true then
      {(n: U64): U64 => n - 1
    end

"""
$PARSE
$ERROR Operator precedence is not supported. Parentheses are required.
  fun apple(): U64 => 1 + 2 * 3 + 4 + 5
                            ^
$ERROR Operator precedence is not supported. Parentheses are required.
  fun apple(): U64 => 1 + 2 * 3 + 4 + 5
                                ^
$ERROR Operator precedence is not supported. Parentheses are required.
  fun currant(): U64 => false or false or true and false or true
                                               ^~~
$ERROR Operator precedence is not supported. Parentheses are required.
  fun currant(): U64 => false or false or true and false or true
                                                         ^~
"""

trait T
  fun apple(): U64 => 1 + 2 * 3 + 4 + 5
  fun banana(): U64 => 1 + (2 * 3) + 4 + 5
  fun currant(): U64 => false or false or true and false or true
  fun dewberry(): Bool => false or ((false or true) and false) or true

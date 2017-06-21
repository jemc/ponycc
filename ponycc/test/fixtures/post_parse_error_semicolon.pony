"""
$POST_PARSE
$ERROR Use semicolons only for separating expressions on the same line.
    3;;;
       ^
$ERROR Use semicolons only for separating expressions on the same line.
    4;;
      ^
$ERROR Use semicolons only for separating expressions on the same line.
    5;
     ^
"""

primitive P
  fun apply() =>
    0; 1; 2
    3;;;
    4;;
    5;

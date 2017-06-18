"""
$SYNTAX
$ERROR An ellipsis may only appear in an FFI declaration.
  fun apply(m: String, ...) => None
                       ^~~
"""

use @printf[I32](m: Pointer[U8] tag, ...)

primitive P
  fun apply(m: String, ...) => None

"""
$SYNTAX
$ERROR An FFI declaration parameter may not have a default value.
use @ffi_with_default_params[I32](a: U8 = 0, b: U8 = 1)
                                          ^
$ERROR An FFI declaration parameter may not have a default value.
use @ffi_with_default_params[I32](a: U8 = 0, b: U8 = 1)
                                                     ^
$ERROR An ellipsis may only appear in FFI declaration parameters.
  fun method_with_ellipsis(m: String, ...) => None
                                      ^~~
"""

use @printf[I32](m: Pointer[U8] tag, ...)
use @ffi_with_default_params[I32](a: U8 = 0, b: U8 = 1)

primitive P
  fun method_with_ellipsis(m: String, ...) => None
  fun method_with_default_params(a: U8 = 0, b: U8 = 1) => None

"""
$PRINT
"""

use "collections"
use time = "time"
use @pony_os_errno[I32]()
use @system[I32](command: Pointer[U8] tag) if posix
use @printf[I32](fmt: Pointer[U8] tag, ...)
use @read[ISize](fd: I32, buffer: Pointer[None], size: USize) if not windows

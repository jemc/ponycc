"""
$PRINT
"""

primitive P
  fun apply() =>
    @system[I32]("echo Hello World!".cstring())
    @"partial function"[None](where risky = true)?

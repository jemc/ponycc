"""
$PRINT
"""

type PCI is P[C[I]]

interface val I
  fun apply(a: I32, b: I32): I32
    """
    This is the docstring for a method that has no body, in a test fixture.
    """

trait ref T

primitive P[A: T]

struct S
  """
  This is the docstring for a struct that is used in a test fixture.
  """
  var a: I32 = 0
  var b: I32 = 0

class C[A] is (T & I)
  """
  This is the docstring for a class that is used in a test fixture.
  """

actor Main
  let _env: Env
  embed array: Array[String] = Array[String]
  
  new create(env: Env) =>
    _env = env
  
  be awesome() =>
    None
  
  fun tag name[A: T = C[I]](a: A): String =>
    "NAME"

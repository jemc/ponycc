"""
$PRINT
"""

type PCI is P[C[I]]

interface val I

trait ref T

primitive P[A: T]

struct S
  """
  This is the docstring for a struct that is used in a test fixture.
  """
  let a: I32 = 0
  let b: I32 = 0

class C[A] is (T & I)
  """
  This is the docstring for a class that is used in a test fixture.
  """

actor Main
  let _env: Env
  var index: USize = 0
  
  new create(env: Env) =>
    _env = env
  
  be awesome() =>
    None
  
  fun tag name[A: T = C[I]](a: A): String =>
    "NAME"

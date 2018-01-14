
use "../ast"

class val PassError is Comparable[PassError box]
  let pos: SourcePosAny
  let message: String
  
  new val create(p: SourcePosAny, m: String) => (pos, message) = (p, m)
  
  fun eq(that: PassError box): Bool =>
    (pos == that.pos) and
    (message == that.message)
  
  fun lt(that: PassError box): Bool =>
    (pos < that.pos) or
    ((pos == that.pos) and (message < that.message))

interface val PassAny
  fun name(): String

interface val Pass[A: Any #share, B: Any #share]
  fun name(): String
  fun apply(a: A, fn: {(B, Array[PassError] val)} val)

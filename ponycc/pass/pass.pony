interface val PassAny
  fun name(): String

interface val Pass[A: Any #share, B: Any #share]
  fun name(): String
  fun apply(a: A, fn: {(B, Array[PassError] val)} val)

"""
$PRINT
"""

primitive P
  fun apply(): T =>
    object
    end
    object val is T
      let x: X = X
      
      fun apply(): this->X =>
        x
    end

"""
$SYNTAX
$ERROR A return statement can only appear in a method body.
  let field_default_return: None = (return None)
                                    ^~~~~~
$ERROR A return statement can only appear in a method body.
  fun parameter_default_return(x: None = (return None)) => None
                                          ^~~~~~
$ERROR A return statement in a constructor cannot have a value expression.
  new constructor_return_this() => return this
                                          ^~~~
$ERROR A return statement in a behaviour cannot have a value expression.
  be behaviour_return_this() => return this
                                       ^~~~
$ERROR An error statement cannot have a value expression.
    error "value"
          ^~~~~~~
"""

actor A
  let field_default_return: None = (return None)
  
  fun parameter_default_return(x: None = (return None)) => None
  
  new constructor_return() => return
  new constructor_return_this() => return this
  
  be behaviour_return() => return
  be behaviour_return_this() => return this
  
  fun apply() =>
    error
    error "value"

"""
$SYNTAX
$ERROR A return statement can only appear in a method body.
  let field_default_return: None = (return None)
                                    ^~~~~~
$ERROR A return statement can only appear in a method body.
  fun parameter_default_return(x: None = (return None)) => None
                                          ^~~~~~
$ERROR An error statement cannot have a value expression.
    error "value"
          ^~~~~~~
"""

class C
  let field_default_return: None = (return None)
  
  fun parameter_default_return(x: None = (return None)) => None
  
  fun apply() =>
    error
    error "value"

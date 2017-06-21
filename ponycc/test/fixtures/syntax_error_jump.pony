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
$ERROR A compile intrinsic must be the entire method body.
  fun true_intrinsic() => true; compile_intrinsic
                                ^~~~~~~~~~~~~~~~~
$ERROR A compile intrinsic must be the entire method body.
  fun if_intrinsic() => if true then compile_intrinsic end
                                     ^~~~~~~~~~~~~~~~~
$ERROR A compile intrinsic cannot have a value expression.
  fun intrinsic_true() => compile_intrinsic true
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
  
  fun intrinsic() => compile_intrinsic
  fun true_intrinsic() => true; compile_intrinsic
  fun if_intrinsic() => if true then compile_intrinsic end
  fun intrinsic_true() => compile_intrinsic true
  
  fun apply() =>
    error
    error "value"

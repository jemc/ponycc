"""
$SYNTAX
$ERROR A lambda capture cannot specify a type without a value.
    let lambda_capture_type_no_value = {()(a: Bool) => None }
                                              ^~~~
"""

actor A
  fun apply() =>
    let lambda_capture_value = {()(a = true) => None }
    let lambda_capture_type_value = {()(a: Bool = true) => None }
    let lambda_capture_type_no_value = {()(a: Bool) => None }

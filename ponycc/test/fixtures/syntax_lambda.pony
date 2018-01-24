"""
$SYNTAX
$ERROR A lambda capture cannot specify a type without a value.
    let lambda_capture_type_no_value = {()(a: Bool) => None }
                                              ^~~~
$ERROR A bare lambda cannot specify a receiver capability.
    let bare_lambda_ref_receiver = @{ref(a: I32): I32 => a + 1 }
                                     ^~~
$ERROR A bare lambda cannot have type parameters.
    let bare_lambda_type_params = @{[A: Any](a: I32): I32 => a + 1 }
                                    ^
$ERROR A bare lambda cannot have captures.
    let bare_lambda_captures = @{(a: I32)(b = true): I32 => a + 1 }
                                         ^
$ERROR A bare lambda can only have the `val` capability.
    let bare_lambda_ref_object = @{(a: I32): I32 => a + 1 } ref
                                                            ^~~
$ERROR A bare lambda type cannot specify a receiver capability.
    let bare_lambda_type_ref_receiver: (@{ref(I32): I32} | None) = None
                                          ^~~
$ERROR A bare lambda type cannot have type parameters.
    let bare_lambda_type_type_params: (@{[A: Any](I32): I32} | None) = None
                                         ^
$ERROR A bare lambda type can only have the `val` capability.
    let bare_lambda_type_ref_object: (@{(I32): I32} ref | None) = None
                                                    ^~~
"""

actor A
  fun apply() =>
    let lambda_capture_value = {()(a = true) => None }
    let lambda_capture_type_value = {()(a: Bool = true) => None }
    let lambda_capture_type_no_value = {()(a: Bool) => None }

    let bare_lambda_ref_receiver = @{ref(a: I32): I32 => a + 1 }
    let bare_lambda_type_params = @{[A: Any](a: I32): I32 => a + 1 }
    let bare_lambda_captures = @{(a: I32)(b = true): I32 => a + 1 }
    let bare_lambda_ref_object = @{(a: I32): I32 => a + 1 } ref
    let bare_lambda_val_object = @{(a: I32): I32 => a + 1 } val

    let bare_lambda_type: (@{(I32): I32} | None) = None
    let bare_lambda_type_ref_receiver: (@{ref(I32): I32} | None) = None
    let bare_lambda_type_type_params: (@{[A: Any](I32): I32} | None) = None
    let bare_lambda_type_ref_object: (@{(I32): I32} ref | None) = None
    let bare_lambda_type_val_object: (@{(I32): I32} val | None) = None

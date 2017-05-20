
primitive Foo
  fun apply() =>
    let a: (X & Y & Z & W)
    let a: (X & Y & Z)
    let a: (X & Y)
    // let b: (X & Y | Z)
    // let c: (X | Y | Z)
    // let d: (X | Y & Z)
    // let e: (X & Y , Z)
    // let e: (X , Y , Z)
    // let e: (X , Y | Z)

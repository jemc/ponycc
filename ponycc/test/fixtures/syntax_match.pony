"""
$SYNTAX
$ERROR The final case in a match block must have a body.
    match u | 0 | 1 else None end
                ^
$ERROR A match capture cannot be declared as `var`; use `let` instead.
    match u | var x: X => true end
              ^~~
$ERROR The type of a match capture must be explicitly declared.
    match u | let x => true end
              ^~~
$ERROR A match cannot capture a tuple; use a tuple of match captures instead.
    match u | let x: (A, B) => true end
                     ^
$ERROR A match capture cannot be declared as `var`; use `let` instead.
    match u | (var a: A, let b) => true end
               ^~~
$ERROR The type of a match capture must be explicitly declared.
    match u | (var a: A, let b) => true end
                         ^~~
$ERROR A sequence inside a match capture must have only one element.
    match u | (false; let x: X) => true end
               ^~~~~
$ERROR A sequence inside a match capture must have only one element.
    match u | (false; false) => true end
               ^~~~~
$ERROR A sequence inside a match capture must have only one element.
    match u | (let a: A, false; let b) => true end
                         ^~~~~
$ERROR A sequence inside a match capture must have only one element.
    match u | (true, false; false) => true end
                     ^~~~~
"""

primitive P
  fun apply(u: U64) =>
    match u | 0 | 1 => None else None end
    match u | 0 | 1 else None end
    
    match u | let x: X => true end
    match u | var x: X => true end
    match u | let x => true end
    
    match u | let x: (A, B) => true end
    match u | (let a: A, let b: B) => true end
    match u | (var a: A, let b) => true end
    
    match u | (let x: X) => true end
    match u | (false; let x: X) => true end
    match u | (false; false) => true end
    match u | (let a: A, false; let b) => true end
    match u | (true, false; false) => true end

"""
$ parse
$ERROR unexpected token
  new ref create(token': Token) => token = token'
                 ^~~~~~
"""


primitive Foo
  fun apply() =>
    let a: (X & Y & Z & W)
    let b: (X & Y & Z)
    let c: (X & Y)

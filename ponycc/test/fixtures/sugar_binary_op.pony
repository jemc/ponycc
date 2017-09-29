"""
$SUGAR
$CHECK type_decls-0.members.methods-0.body.list-0
Call(Dot(Call(Dot(LitInteger(1), Id(add)), Args([Sequence([LitInteger(2)])]),
 NamedArgs([]), None), Id(add)), Args([Sequence([LitInteger(3)])]),
 NamedArgs([]), None)

"""

primitive P
  fun apply() =>
    1 + 2 + 3

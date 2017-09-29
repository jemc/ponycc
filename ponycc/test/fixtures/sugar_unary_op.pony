"""
$SUGAR
$CHECK type_decls-0.members.methods-0.body.list-0
Call(Dot(Call(Dot(LitTrue, Id(op_not)), Args([]), NamedArgs([]), None),
 Id(op_not)), Args([]), NamedArgs([]), None)

"""

primitive P
  fun apply() =>
    not not true

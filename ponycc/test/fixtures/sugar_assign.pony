"""
$SUGAR
$CHECK type_decls-0.members.methods-0.body.list-0
Call(Dot(Reference(Id(x)), Id(update)), Args([Sequence([LitInteger(0)])]),
 NamedArgs([NamedArg(Id(value), Sequence([LitTrue]))]), None)

"""

primitive P
  fun apply() =>
    x(0) = true

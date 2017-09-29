"""
$SUGAR
$CHECK type_decls-0.members.methods-0.body.list-0.cases.list-0
Case(LitInteger(0), None, Sequence([LitTrue]))
$CHECK type_decls-0.members.methods-0.body.list-0.cases.list-1
Case(LitInteger(1), None, Sequence([LitTrue]))
$CHECK type_decls-0.members.methods-0.body.list-0.cases.list-2
Case(LitInteger(2), None, Sequence([LitTrue]))
$CHECK type_decls-0.members.methods-0.body.list-0.cases.list-3
Case(LitInteger(3), None, Sequence([LitFalse]))
$CHECK type_decls-0.members.methods-0.body.list-0.cases.list-4
Case(LitInteger(4), None, Sequence([LitFalse]))

"""

primitive P
  fun apply() =>
    match x
    | 0 | 1 | 2 => true
    | 3 | 4     => false
    end

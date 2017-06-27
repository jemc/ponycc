"""
$SUGAR
$CHECK type_decls-0.members.methods-0.body.list-0
Return(This)
$CHECK type_decls-0.members.methods-1.body.list-0
Return(Reference(Id(None)))
$CHECK type_decls-0.members.methods-2.body.list-0
Return(LitTrue)

"""

primitive P
  new create() => return
  fun apply() => return
  fun explicit(): Bool => return true

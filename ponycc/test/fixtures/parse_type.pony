"""
$PARSE
$CHECK type_decls-0.members.methods-0.return_type
NominalType(Id(T), None, None, None, None)

$CHECK type_decls-0.members.methods-1.return_type
NominalType(Id(T), None, None, None, None)

$CHECK type_decls-0.members.methods-2.return_type
TupleType([NominalType(Id(T), None, None, None, None);
 NominalType(Id(Bool), None, None, None, None)])

"""

trait T
  fun single_return(): T => this
  fun single_tuple_return(): (T) => this
  fun multi_tuple_return(): (T, Bool) => (this, true)

"""
$POST_PARSE
$ERROR A method with a body cannot have a docstring in the signature.
  fun apple(): Bool "one bad docstring" => true
                    ^~~~~~~~~~~~~~~~~~~
$ERROR A method with a body cannot have a docstring in the signature.
  fun banana(): Bool "another bad one" => "the real docstring"; true
                     ^~~~~~~~~~~~~~~~~
$CHECK type_decls-0.members.methods-2.docs
LitString(this docstring is okay)

$CHECK type_decls-0.members.methods-2.body
None

$CHECK type_decls-0.members.methods-3.docs
LitString(this one is also fine)

$CHECK type_decls-0.members.methods-3.body
Sequence([LitTrue])

"""

trait T
  fun apple(): Bool "one bad docstring" => true
  fun banana(): Bool "another bad one" => "the real docstring"; true
  fun currant(): Bool "this docstring is okay"
  fun dewberry(): Bool => "this one is also fine"; true

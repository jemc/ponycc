"""
$POST_PARSE
$ERROR A method with a body cannot have a docstring in the signature.
  fun apple(): None "one bad docstring" => None
                    ^~~~~~~~~~~~~~~~~~~
$ERROR A method with a body cannot have a docstring in the signature.
  fun banana(): None "another bad one" => "the real docstring"; None
                     ^~~~~~~~~~~~~~~~~
"""

trait T
  fun apple(): None "one bad docstring" => None
  fun banana(): None "another bad one" => "the real docstring"; None
  fun currant(): None "this docstring is okay"
  fun dewberry(): None => "this one is also fine"; None


use peg = "peg"
use "../ast"

class TkTree
  var tk: TkAny
  var pos: SourcePosAny
  embed children: Array[TkTree] = Array[TkTree]
  // TODO: annotations
  
  new ref create(token: _Token) => (tk, pos) = token
  
  fun string(): String => _show()
  
  fun _show(buf': String iso = recover String end): String iso^ =>
    var buf = consume buf'
    let nonterminal = children.size() > 0
    
    if nonterminal then buf.push('(') end
    buf.append(tk.string())
    
    for child in children.values() do
      buf.push(' ')
      buf = child._show(consume buf)
    end
    
    if nonterminal then buf.push(')') end
    buf

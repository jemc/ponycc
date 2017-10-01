
use coll = "collections/persistent"
use peg = "peg"
use "../../ast"

trait val TkAny is peg.Label
  fun text(): String => string() // Required for peg library, but otherwise unused.
  fun string(): String
  fun desc(): String
  fun _from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])
    : (AST ref | None) ?

primitive Tk[A: (AST | None)] is TkAny
  fun string(): String => ASTInfo.name[A]()
  fun desc():   String => ASTInfo.name[A]()
  fun _from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    errs: Array[(String, SourcePosAny)] = [])
    : (AST ref | None) ?
  =>
    if false then error end // TODO: fix ponyc, then remove this
    iftype A <: AST
    then A.from_iter(iter, pos', errs)
    else None
    end

type _Token is (TkAny, SourcePosAny)

class TkTree
  var tk: TkAny
  var pos: SourcePosAny
  embed children: Array[TkTree] = []
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
  
  fun to_ast(
    errs: Array[(String, SourcePosAny)] = [])
    : (AST | None) ?
  =>
    let ast_children = recover Array[(AST | None)] end
    for child in children.values() do
      ast_children.push(child.to_ast(errs)?)
    end
    
    // TODO: is there a less convoluted way to lift the AST to val?
    var errs' = recover Array[(String, SourcePosAny)] end
    try
      recover val
        let errs'' = Array[(String, SourcePosAny)]
        try
          tk._from_iter((consume ast_children).values(), pos, errs'')?
        else
          for err in errs''.values() do errs'.push(err) end
          error
        end
      end
    else
      for err in (consume errs').values() do errs.push(err) end
      error
    end

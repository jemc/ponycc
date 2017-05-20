
use peg = "peg"
use "../ast"
use "debug"

trait val TkAny is peg.Label
  fun text(): String => string() // Required for peg library, but otherwise unused.
  fun string(): String
  fun desc(): String
  fun _from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    err: {(String, (AST | None))} = {(s: String, a: (AST | None)) => None } ref)
    : AST ?

primitive Tk[A: (AST | None)] is TkAny
  fun string(): String => ASTInfo.name[A]()
  fun desc():   String => ASTInfo.name[A]()
  fun _from_iter(
    iter: Iterator[(AST | None)],
    pos': SourcePosAny = SourcePosNone,
    err: {(String, (AST | None))} = {(s: String, a: (AST | None)) => None } ref)
    : AST ?
  =>
    if false then error end // TODO: fix ponyc, then remove this
    iftype A <: AST
    then A.from_iter(iter, pos', err)
    else error
    end

type _Token is (TkAny, SourcePosAny)

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
  
  fun to_ast(
    err: {(TkAny, String, (AST | None))} =
      {(tk: TkAny, s: String, a: (AST | None)) => None } ref)
    : AST ?
  =>
    let ast_children = Array[(AST | None)]
    for child in children.values() do
      ast_children.push(try child.to_ast(err) else None end)
    end
    tk._from_iter(ast_children.values(), pos,
      {(s: String, a: (AST | None)) => err(tk, s, a) })

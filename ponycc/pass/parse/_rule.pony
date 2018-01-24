
use peg = "peg"

class _RuleState
  let fn_name:    String                 // Name of the current function, for tracing
  let desc:       String                 // Rule description (set by parent)
  var tree:       (TkTree | None) = None // Tree built for this rule
  let restart:    Array[TkAny] = []      // Restart token set, NULL for none
  var default_tk: (TkAny | None) = None  // ID of node to create when an optional token or rule is not found.
                                         // - TkEOF = do not create a default
                                         // - None = rule is not optional
  var matched:    Bool = false           // Has the rule matched yet
  var deferred:   (_Token | None) = None // Deferred token, if any

  new create(n: String, d: String) => (fn_name, desc) = (n, d)

  fun ref add_tree(t: TkTree, build: _Build) =>
    process_deferred_tree()

    if tree is None
    then tree = t
    else build(this, t)
    end

  fun ref add_deferrable_ast(defer: _Token) =>
    if (not matched)
      and (tree is None)
      and (deferred is None)
    then
      deferred = defer
      return
    end

    add_tree(TkTree(defer), _BuildDefault)

  fun ref process_deferred_tree() =>
    try
      tree = TkTree(deferred as _Token)
      deferred = None
    end

primitive _RuleParseError
primitive _RuleNotFound
primitive _RuleRestart

type _RuleResult is (_RuleParseError | _RuleNotFound | _RuleRestart | TkTree | None)

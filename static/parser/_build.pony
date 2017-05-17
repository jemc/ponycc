
interface val _Build
  new val create()
  fun apply(state: _RuleState, tree: TkTree)

primitive _BuildDefault
  fun apply(state: _RuleState, tree: TkTree) =>
    try (state.tree as TkTree).children.push(tree) end

primitive _BuildFlatten
  fun apply(state: _RuleState, tree: TkTree) =>
    _BuildDefault(state, TkTree((tree.tk, tree.pos)))
    for child in tree.children.values() do
      _BuildFlatten(state, child)
    end

primitive _BuildInfix
  fun apply(state: _RuleState, tree: TkTree) =>
    try tree.children.unshift(state.tree as TkTree) end
    state.tree = tree

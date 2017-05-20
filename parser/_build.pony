
interface val _Build
  new val create()
  fun apply(state: _RuleState, tree: TkTree)

primitive _BuildDefault
  fun apply(state: _RuleState, tree: TkTree) =>
    try (state.tree as TkTree).children.push(tree) end

primitive _BuildInfix
  fun apply(state: _RuleState, tree: TkTree) =>
    try tree.children.unshift(state.tree as TkTree) end
    state.tree = tree

primitive _BuildUnwrap[A: TkAny]
  fun apply(state: _RuleState, tree: TkTree) =>
    match tree.tk | let _: A =>
      for child in tree.children.values() do
        _BuildDefault(state, child)
      end
    else
      _BuildDefault(state, tree)
    end

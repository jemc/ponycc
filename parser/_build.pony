
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

primitive _BuildCustomNominalType
  fun apply(state: _RuleState, tree: TkTree) =>
    _BuildDefault(state, TkTree((tree.tk, tree.pos)))
    
    for (i, child) in tree.children.pairs() do
      if (tree.children.size() == 3) and (i == 0)
      then _BuildDefault(state, TkTree((Tk[None], child.pos)))
      end
      _BuildDefault(state, child)
    end

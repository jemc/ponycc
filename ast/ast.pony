
class val AST
  var kind: Tk
  var is_scope: Bool = false
  var value: (I128 | U128 | F64 | String | None)
  let children: Array[AST] = Array[AST]
  
  new iso create(
    kind': Tk = TkNone,
    contents': (Array[AST] val | I128 | U128 | F64 | String | None) = None
  ) =>
    kind = kind'
    value = try
      contents' as (I128 | U128 | F64 | String | None)
    else
      is_scope = _kind_is_scope(kind)
      match contents' | let children': Array[AST] box =>
        children.append(children')
      end
      None
    end
  
  fun eq(that: AST box): Bool =>
    if not (that.kind            is this.kind)            then return false end
    if not (that.is_scope        == this.is_scope)        then return false end
    if not (that.children.size() == this.children.size()) then return false end
    
    let this_iter = that.children.values()
    let that_iter = this.children.values()
    try while this_iter.has_next() do
      if not (that_iter.next() == this_iter.next()) then return false end
    end end
    
    match (that.value, this.value)
    | (let a: I128,   let b: I128)   => a == b
    | (let a: U128,   let b: U128)   => a == b
    | (let a: F64,    let b: F64)    => a == b
    | (let a: String, let b: String) => a == b
    | (let a: None,   let b: None)   => true
    else false
    end
  
  fun tag _kind_is_scope(kind': Tk): Bool =>
    match kind'
    | TkType | TkInterface | TkTrait | TkPrimitive | TkStruct | TkClass
    | TkActor | TkNew | TkFun | TkBe | TkIf | TkIfdef | TkWhile | TkRepeat
    | TkMatch | TkAt | TkProgram | TkPackage | TkModule | TkCases | TkCase
      => true
    else false
    end
  
  fun apply(i: USize): AST ? =>
    children(i)
  
  fun ref push_child(child: AST) =>
    children.push(child)

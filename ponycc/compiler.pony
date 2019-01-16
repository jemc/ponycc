
use "pass"
use "frame"

type _ErrsFn is {(PassAny, Array[PassError] val)} val

interface val _CompilerPrev[I: Any val = None, O: Any val = None]
  fun val _compile(input: I, on_errors': _ErrsFn, on_complete': {(O)} val)

primitive BuildCompiler
  fun apply[I: Any val, O: Any val](p: Pass[I, O]): Compiler[I, O, I] =>
    Compiler[I, O, I](p)

class val Compiler[I: Any val, O: Any val, M: Any val = I]
  let _prev: (_CompilerPrev[I, M] | None)
  let _pass: Pass[M, O]
  let _on_errors: _ErrsFn
  let _on_complete: {(O)} val

  new val create(pass': Pass[M, O]) =>
    _prev = None
    _pass = pass'
    _on_errors = {(_, _) => None }
    _on_complete = {(_) => None }

  new val _create(
    prev': (_CompilerPrev[I, M] | None),
    pass': Pass[M, O],
    on_errors': _ErrsFn =  {(_, _) => None },
    on_complete': {(O)} val =  {(_) => None })
  =>
    _prev = prev'
    _pass = pass'
    _on_errors = on_errors'
    _on_complete = on_complete'

  fun val on_errors(fn: _ErrsFn): Compiler[I, O, M] =>
    """
    Set the errors handling function for the compiler.
    This function will be invoked after finishing a pass if there were errors.

    The first argument to the function will be the pass that was finished.
    The second argument will be the list of all errors encountered in that pass.
    """
    Compiler[I, O, M]._create(_prev, _pass, fn, _on_complete)

  fun val on_complete(fn: {(O)} val): Compiler[I, O, M] =>
    """
    Set the completion handling function for this compiler.
    This function will be invoked after finishing all passes with no errors.

    The only argument to the function will be the finished AST.
    """
    Compiler[I, O, M]._create(_prev, _pass, _on_errors, fn)

  fun val next[O2: Any val](pass': Pass[O, O2]): Compiler[I, O2, O] =>
    """
    Chain another pass onto this compiler, where the input of the new pass
    must be the same type as the output of the currently held pass.

    This should be called before setting on_errors or on_complete, as all
    previously set handler functions will be discarded here.
    """
    Compiler[I, O2, O]._create(this, pass')

  fun val apply(input: I) =>
    _compile(input, _on_errors, _on_complete)

  fun val _compile(input: I, on_errors': _ErrsFn, on_complete': {(O)} val) =>
    let pass' = _pass
    match _prev | let prev': _CompilerPrev[I, M] =>
      prev'._compile(input, on_errors', {(middle)(on_errors', on_complete') =>
        pass'.apply(middle, {(output: O, errs: Array[PassError] val) => // TODO: use apply sugar, use lambda inference
          if errs.size() > 0 then
            on_errors'(pass', errs)
          else
            on_complete'(output)
          end
        })
      })
    else
      match input | let middle: M =>
        pass'.apply(middle, {(output: O, errs: Array[PassError] val) => // TODO: use apply sugar, use lambda inference
          if errs.size() > 0 then
            on_errors'(pass', errs)
          else
            on_complete'(output)
          end
        })
      else
        None // TODO: should call on_errors with an error message here...
      end
    end

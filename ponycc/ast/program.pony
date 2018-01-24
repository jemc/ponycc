actor _ResultCollector[A: Any #share]
  var _finish_fn: {(Array[A] val)} val
  var _results: Array[A] trn = []
  var _expecting: USize = 0

  new create(finish_fn': {(Array[A] val)} val) =>
    _finish_fn = finish_fn'

  be push_expectation() => _expecting = _expecting + 1
  be pop_expectation() => _pop_expectation()
  fun ref _pop_expectation() =>
    if 1 >= (_expecting = _expecting - 1) then complete() end

  be apply(a: A) =>
    _results.push(a)
    _pop_expectation()

  fun ref complete() =>
    _finish_fn(_results = [])
    _finish_fn = {(results) => None }

class val Program
  let _inner: _Program = _Program

  new val create() => None

  fun add_package(e: Package) =>
    _inner.add_package(e)

  fun access_packages(fn: {(Array[Package])} val) =>
    _inner.access_packages(fn)

  fun get_all_type_decls(fn: {(Array[TypeDecl] val)} val) =>
    let collector = _ResultCollector[TypeDecl](fn)
    access_packages({(packages)(collector) =>
      for package in packages.values() do
        collector.push_expectation()
        package.access_type_decls({(type_decls)(collector) =>
          for type_decl in type_decls.values() do
            collector.push_expectation()
            type_decl.access_type_decl({(ast) =>
              collector(ast)
              ast
            })
          end
          collector.pop_expectation()
        })
      end
    })

  fun _get_type_decl_by_idx(idx: USize, fn: {((TypeDecl | None))} val) =>
    access_packages({(packages)(fn, idx) =>
      try
        packages(0)?.access_type_decls({(type_decls)(fn, idx) =>
          try
            type_decls(idx)?.access_type_decl({(ast) =>
              fn(ast)
              ast
            })
          else fn(None)
          end
        })
      else fn(None)
      end
    })

  fun get_child_dynamic_path(path: String, fn: {((AST | None))} val) =>
    let ast_fn: {((AST | None))} val = {(ast')(fn) =>
      var ast: (AST | None) = ast'
      let crumbs = path.split_by(".").values()

      try
        crumbs.next()? // skip the first crumb - it was used already
        for crumb in crumbs do
          let pieces = crumb.split_by("-", 2)

          ast =
            (ast as AST).get_child_dynamic(
              pieces(0)?,
              try pieces(1)?.usize()? else 0 end)?
        end
      else ast = None
      end

      fn(ast)
    }

    let crumbs = path.split_by(".").values()
    try
      let top_pieces = crumbs.next()?.split_by("-", 2)
      match top_pieces(0)?
      | "type_decls" =>
        let idx = top_pieces(1)?.usize()?
        _get_type_decl_by_idx(idx, ast_fn)
      else fn(None)
      end
    else fn(None)
    end

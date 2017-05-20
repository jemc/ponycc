
use peg = "peg"
use "files"
use "inspect"

use "../ast"
use "../parser"

actor Main
  new create(env: Env) =>
    try
      let auth = env.root as AmbientAuth
      let path = env.args(1)
      let file = OpenFile(FilePath(auth, path)) as File
      let content: String = file.read_string(file.size())
      
      env.out.print(path)
      env.out.print(content)
      
      let source = Source(content, path)
      let parser = Parser
      
      try
        Inspect.out(parser(source))
      else
        env.out.print("A parser error occurred.")
      end
    else
      env.out.print("An error occurred opening the example file for parsing.")
    end

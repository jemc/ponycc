
use peg = "peg"
use "files"
use "glob"
use "inspect"
use "ponytest"

use "../ast"
use "../parser"
use "../printer"

actor Main is TestList
  let _env: Env
  new create(env: Env) => _env = env; PonyTest(env, this)
  
  be tests(test: PonyTest) =>
    try
      let auth = _env.root as AmbientAuth
      let test_root = FilePath(auth, Path.dir(__loc.file()))
      let fixtures = Glob.glob(test_root, "fixtures/*.pony")
      
      for path in fixtures.values() do
        let file = OpenFile(path) as File
        let source = Source(file.read_string(file.size()), path.path)
        
        test(TestFixture(source))
      end
    else
      _env.out.print("An error occurred opening the test fixture files.")
    end

class TestFixture is UnitTest
  let source: Source
  
  new iso create(source': Source) => source = source'
  
  fun name(): String =>
    try Path.rel(Path.dir(__loc.file()), source.path())
    else source.path()
    end
  
  fun apply(h: TestHelper) =>
    let env = h.env
    let parser = Parser
    
    try
      let module = parser(source, {(s: String, p: SourcePosAny) =>
        env.out.print(s + ": " + p.string())
      })
      
      env.out.print(Inspect(module))
      env.out.print(Printer(module))
    else
      env.out.print("A parser error occurred.")
    end

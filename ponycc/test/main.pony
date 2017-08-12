
use "files"
use "glob"
use "ponytest"

use "../ast"
use "../frame"

actor Main is TestList
  new create(env: Env) =>
    let test = PonyTest(env, this)
    
    try
      let auth = env.root as AmbientAuth
      let test_root = FilePath(auth, Path.dir(__loc.file()))?
      let fixtures = Glob.glob(test_root, "fixtures/*.pony")
      
      for path in fixtures.values() do
        let file = OpenFile(path) as File
        let source = Source(file.read_string(file.size()), path.path)
        
        test(TestFixture(source))
      end
    else
      env.out.print("An error occurred opening the test fixture files.")
    end
  
  fun tag tests(test: PonyTest) =>
    // All test cases have already been dynamically applied in the constructor,
    // so there is no need to apply anything here.
    None

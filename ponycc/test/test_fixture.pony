
use "collections"
use "files"
use "ponytest"

use "../ast"

class TestFixture is UnitTest
  let source: Source
  
  new iso create(source': Source) => source = source'
  
  fun name(): String =>
    try Path.rel(Path.dir(__loc.file()), source.path())
    else source.path()
    end
  
  fun apply(h: TestHelper) =>
    let env = h.env
    
    // Confirm that the start of the source file is a docstring.
    let triple = "\"\"\""
    var i: ISize = 0
    if (try source.content().find(triple) == 0 else false end) then
      i = triple.size().isize()
    else
      return h.fail("Expected the start of the source file to be a docstring.")
    end
    
    // Parse the list of commands from the source file docstring.
    let commands = List[TestCommandAny iso]
    try
      while true do
        i = i + 1
        let j = source.content().find("\n", i)
        let line: String = source.content().substring(i, j)
        i = j
        
        commands.unshift(
          if line.at(triple)            then break
          elseif line.at("$PRINT")      then TestCommand[_Print](h, line.substring(7))
          elseif line.at("$PARSE")      then TestCommand[_Parse](h, line.substring(7))
          elseif line.at("$POST_PARSE") then TestCommand[_PostParse](h, line.substring(11))
          elseif line.at("$SYNTAX")     then TestCommand[_Syntax](h, line.substring(8))
          elseif line.at("$ERROR")      then TestCommand[_Error](h, line.substring(7))
          elseif line.at("$CHECK")      then TestCommand[_Check](h, line.substring(7))
          else                               commands.shift() .> add_line(line)
          end
        )
      end
    else
      return h.fail("Expected to be able to parse the test plan docstring.")
    end
    
    // Associate ERROR and CHECK commands with their preceding parent commands.
    try
      let errors = List[TestCommand[_Error]]
      let checks = List[TestCommand[_Check]]
      
      for _ in Range(0, commands.size()) do
        match commands.shift()
        | let e: TestCommand[_Error] iso => errors.unshift(consume e)
        | let c: TestCommand[_Check] iso => checks.unshift(consume c)
        | let x: TestCommandAny iso =>
          try while true do x.add_error(errors.shift()) end end
          try while true do x.add_check(checks.shift()) end end
          commands.push(consume x)
        end
      end
    end
    
    // Execute the final list of commands.
    try while true do commands.shift()(source) end end


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
    
    let triple = "\"\"\""
    var i: ISize = 0
    if (try source.content().find(triple) == 0 else false end) then
      i = triple.size().isize()
    else
      return h.fail("Expected the start of the source file to be a docstring.")
    end
    
    let commands = List[TestCommandAny]
    var last_command: (TestCommandAny | None) = None
    var commands_parsed = false
    try
      while true do
        i = i + 1
        let j = source.content().find("\n", i)
        let line: String = source.content().substring(i, j)
        i = j
        
        if line.at(triple)            then commands_parsed = true; break
        elseif line.at("$PRINT")      then last_command = TestCommand[_Print](h, line.substring(7));      commands.unshift(last_command as TestCommandAny)
        elseif line.at("$PARSE")      then last_command = TestCommand[_Parse](h, line.substring(7));      commands.unshift(last_command as TestCommandAny)
        elseif line.at("$POST_PARSE") then last_command = TestCommand[_PostParse](h, line.substring(11)); commands.unshift(last_command as TestCommandAny)
        elseif line.at("$SYNTAX")     then last_command = TestCommand[_Syntax](h, line.substring(8));     commands.unshift(last_command as TestCommandAny)
        elseif line.at("$ERROR")      then last_command = commands(0).add_error(TestCommand[_Error](h, line.substring(7)))
        elseif line.at("$CHECK")      then last_command = commands(0).add_check(TestCommand[_Check](h, line.substring(7)))
        else (last_command as TestCommandAny).add_line(line)
        end
      end
    else
      return h.fail("Expected to be able to parse the test plan docstring.")
    end
    
    for command in commands.values() do
      command(source)
    end

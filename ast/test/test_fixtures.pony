
use ".."

primitive TestFixtures
  fun ast_1(): AST =>
    let env_out_print_ast = lambda(arg: AST): AST =>
      let x: AST = AST(TkNone)
      
      AST(TkCall, recover [as AST:
        AST(TkPositionalArgs, recover [as AST:
          AST(TkSeq, recover [as AST: arg] end)
        ] end),
        x,
        AST(TkDot, recover [as AST:
          AST(TkDot, recover [as AST:
            AST(TkReference, recover [as AST:
              AST(TkId, "env")
            ] end),
            AST(TkId, "out")
          ] end),
          AST(TkId, "print")
        ] end)
      ] end)
    end
    
    let string_ast = lambda(lit: String, rcvr: AST): AST =>
      let x: AST = AST(TkNone)
      
      AST(TkCall, recover [as AST:
        x,
        x,
        AST(TkDot, recover [as AST:
          AST(TkCall, recover [as AST:
            AST(TkPositionalArgs, recover [as AST:
              AST(TkSeq, recover [as AST: rcvr] end)
            ] end),
            x,
            AST(TkReference, recover [as AST: AST(TkId, lit)] end)
          ] end),
          AST(TkId, "string")
        ] end)
      ] end)
    end
    
    let x: AST = AST(TkNone)
    
    AST(TkProgram, recover [as AST:
      AST(TkPackage, recover [as AST:
        AST(TkModule, recover [as AST:
          AST(TkUse, recover [as AST: x, AST(TkString, "builtin"), x] end),
          AST(TkActor, recover [as AST:
            AST(TkId, "Main"),
            x,
            AST(TkTag),
            x,
            AST(TkMembers, recover [as AST:
              AST(TkNew, recover [as AST:
                AST(TkTag),
                AST(TkId, "create"),
                x,
                AST(TkParams, recover [as AST:
                  AST(TkParam, recover [as AST:
                    AST(TkId, "env"),
                    AST(TkNominal, recover [as AST:
                      AST(TkId, "$0"),
                      AST(TkId, "Env"),
                      x,
                      AST(TkVal),
                      x,
                      x
                    ] end),
                    x
                  ] end)
                ] end),
                AST(TkNominal, recover [as AST:
                  AST(TkId, "$1"),
                  AST(TkId, "Main"),
                  x,
                  AST(TkTag),
                  AST(TkEphemeral),
                  x
                ] end),
                x,
                AST(TkSeq, recover [as AST:
                  env_out_print_ast(AST(TkString, "Hello, World!")),
                  env_out_print_ast(AST(TkString, "quote\"slash\\null\x00!")),
                  env_out_print_ast(string_ast("U32", AST(TkInt, U128(88)))),
                  env_out_print_ast(string_ast("F32", AST(TkFloat, F64(99.9))))
                ] end),
                x,
                x
              ] end)
            ] end),
            x,
            x
          ] end)
        ] end)
      ] end)
    ] end)
  
  fun string_1(): String => """
(program:scope
  (package:scope
    (module:scope
      (use x "builtin" x)
      (actor:scope
        (id Main)
        x
        tag
        x
        (members
          (new:scope
            tag
            (id create)
            x
            (params (param (id env) (nominal (id $0) (id Env) x val x x) x))
            (nominal (id $1) (id Main) x tag ^ x)
            x
            (seq
              (call
                (positionalargs (seq "Hello, World!"))
                x
                (. (. (reference (id env)) (id out)) (id print))
              )
              (call
                (positionalargs (seq "quote\"slash\\null\0!"))
                x
                (. (. (reference (id env)) (id out)) (id print))
              )
              (call
                (positionalargs
                  (seq
                    (call
                      x
                      x
                      (.
                        (call (positionalargs (seq 88)) x (reference (id U32)))
                        (id string)
                      )
                    )
                  )
                )
                x
                (. (. (reference (id env)) (id out)) (id print))
              )
              (call
                (positionalargs
                  (seq
                    (call
                      x
                      x
                      (.
                        (call
                          (positionalargs (seq 99.9))
                          x
                          (reference (id F32))
                        )
                        (id string)
                      )
                    )
                  )
                )
                x
                (. (. (reference (id env)) (id out)) (id print))
              )
            )
            x
            x
          )
        )
        x
        x
      )
    )
  )
)
"""

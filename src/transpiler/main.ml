open Batteries
open Lexer
open Types
open Print

let main filename =
    (*let input = read_line stdin in*)
    (*let filebuf = Lexing.from_input input in*)
    let input = open_in filename in
    let filebuf = Lexing.from_input input in
    try
      let ast = Parser.init Lexer.token filebuf in
        print_string (string_of_machine ast)
        (*print_string (string_of_exp ast)*)
    with Parser.Error ->
        Printf.eprintf "At offset %d: syntax error.\n%!" (Lexing.lexeme_start filebuf)

let _ =
  if Array.length Sys.argv < 2 then
    Printf.eprintf "No input\n"
  else
    main Sys.argv.(1)

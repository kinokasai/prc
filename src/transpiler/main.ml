open Core.Std
open Batteries
open Lexer
open Types
open Print
open Js

let main filename callback =
    let input = open_in filename in
    let filebuf = Lexing.from_input input in
    try
      let ast = Parser.init Lexer.token filebuf in
        print_string (callback ast)
        (*print_string (string_of_exp ast)*)
    with Parser.Error ->
        Printf.eprintf "At offset %d: syntax error.\n%!" (Lexing.lexeme_start filebuf)

let command =
    Command.basic
        ~summary:"Parse sol and compile it to js"
        Command.Spec.(
            empty
            +> flag "-print" no_arg~doc:" print sol code"
            +> anon ("filename" %: file)
        )
    (fun print filename () ->
        match print with
            | true -> main filename string_of_machine
            | false -> main filename js_of_machine
    )

let _ =
    Command.run command

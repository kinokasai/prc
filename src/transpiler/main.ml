open Ast_iterator
open Core.Std
open Batteries
open Lexer
open Types
open Print
open Printexc
open Js

let main filename callback =
    let input = open_in filename in
    let filebuf = Lexing.from_input input in
    try
      let ast = Parser.init Lexer.token filebuf in
        print_string (callback ast)
    with
    | Parser.Error ->
        (Printf.eprintf "At offset %d: syntax error.\n%!" (Lexing.lexeme_start
        filebuf);
        exit 2)
    | SyntaxError(str) ->
        print_string str
    | e -> print_string(to_string(e) ^ get_backtrace())

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
            | true -> main filename string_of_ast
            | false -> main filename js_of_ast
    )

let _ =
    Command.run command

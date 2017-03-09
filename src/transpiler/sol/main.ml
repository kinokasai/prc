open Ast_iterator
open Core.Std
open Batteries

open Lexer
open Types
open Printexc
open Js

let lexsub pos str lexeme =
    let len = String.length lexeme in
    let head = String.sub str (pos - 40) (40 - len) and
        tail = String.sub str (pos + len) (40 - len) and
        red = "\027[32m" and
        endc = "\027[0m" in
    head ^ red ^ lexeme ^ endc ^ tail

let compile filename =
    let callback = js_of_ast in
    let input = open_in filename in
    let filebuf = Lexing.from_input input in
    try
      let ast = Parser.init Lexer.token filebuf in
      print_string (callback ast)
    with
    | Parser.Error ->
        (Printf.eprintf "At offset %d: syntax error on token: \"%s\"!\n%s\n"
        (Lexing.lexeme_start filebuf) (Lexing.lexeme filebuf)
        (lexsub (filebuf.Lexing.lex_start_pos) filebuf.Lexing.lex_buffer (Lexing.lexeme filebuf));
        exit 2)
    | SyntaxError(str) ->
        print_string str
    | e -> print_string(to_string(e) ^ get_backtrace())
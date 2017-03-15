open Core.Std
open Batteries

open Lexer
open Types
open Printexc
open Js

let lexsub start end_ str lexeme =
    let head = String.sub str 0 start and
        tail = String.sub str end_ (end_) and
        red = "\027[32m" and
        endc = "\027[0m" in
    head ^ red ^ lexeme ^ endc ^ tail

let compile print filename =
    let iter = if print then Print.string_of_ast else js_of_ast in
    let input = open_in filename in
    let filebuf = Lexing.from_input input in
    try
      let ast = Parser.init Lexer.token filebuf in
      print_string (iter ast)

    with
    | Parser.Error ->
        (Printf.eprintf "At offset %d: syntax error on token: \"%s\"!\n%s\n"
        (Lexing.lexeme_start filebuf) (Lexing.lexeme filebuf)
        (lexsub (Lexing.lexeme_start filebuf) (Lexing.lexeme_end filebuf) filebuf.Lexing.lex_buffer (Lexing.lexeme filebuf));
        exit 2)
    | SyntaxError(str) ->
        print_string str
    | e -> print_string(to_string(e) ^ get_backtrace())
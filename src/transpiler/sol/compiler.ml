open Core.Std
open Batteries

open Lexer
open Ast
open Printexc
open Js
open Shared.Exceptions

let lexsub start end_ str lexeme =
  let head = String.sub str 0 start and
    tail = String.sub str end_ (200) and
    red = "\027[32m" and
    endc = "\027[0m" in
  head ^ red ^ lexeme ^ endc ^ tail

let parse filename =
  let input = open_in filename in
  let filebuf = Lexing.from_input input in
  try
    Parser.init Lexer.token filebuf
  with
  | Parser.Error ->
    (Printf.eprintf "At offset %d: syntax error on token: \"%s\"!\n%s\n"
    (Lexing.lexeme_start filebuf) (Lexing.lexeme filebuf)
    (lexsub (Lexing.lexeme_start filebuf) (Lexing.lexeme_end filebuf) filebuf.Lexing.lex_buffer (Lexing.lexeme filebuf));
    exit 2)
  | SyntaxError(str) ->
    print_string str |> raise Unrecoverable
  | e -> print_string(to_string(e) ^ get_backtrace()) |> raise Unrecoverable

let compile filename ast =
try
  let text = Js.js_of_ast ast in
  Core.Std.Out_channel.write_all filename ~data:text
with
  | Unrecoverable -> raise Unrecoverable
  | e -> print_string(to_string(e) ^ get_backtrace()) |> raise Unrecoverable

let parse_and_compile filename out_name =
  parse filename |> compile out_name
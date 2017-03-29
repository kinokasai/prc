open Lexer
open Parser
open Batteries
open Printexc
open Nm_ast
open Sol_of_normal
(*
let lexsub pos str lexeme =
    let len = String.length lexeme in
    let msg_len = 40 in
    let start = max 0 (pos - msg_len) in
    let end_len = min msg_len (String.length str - start - len) in
    let head = String.sub str start (start) and
        tail = String.sub str (start + start) (end_len) and
        red = "\027[32m" and
        endc = "\027[0m" in
    head ^ red ^ lexeme ^ endc ^ tail*)

let lexsub start end_ str lexeme =
    let head = String.sub str 0 start and
        tail = String.sub str end_ (40) and
        red = "\027[32m" and
        endc = "\027[0m" in
    head ^ red ^ lexeme ^ endc ^ tail

let compile print filename =
  let iter = if print then Sol.Print.string_of_ast else Sol.Js.js_of_ast in
  let input = File.open_in filename in
  let filebuf = Lexing.from_channel input in
  try
    let ast = Parser.init Lexer.token filebuf in
    let sol_ast = sol_of_ast ast in
    print_string (iter sol_ast)
  with
    | Parser.Error ->
        (Printf.eprintf "At offset %d: syntax error on token: \"%s\"!\n%s\n"
        (Lexing.lexeme_start filebuf) (Lexing.lexeme filebuf)
        (*(lexsub (filebuf.Lexing.lex_start_pos) filebuf.Lexing.lex_buffer (Lexing.lexeme filebuf));*)
        (lexsub (Lexing.lexeme_start filebuf) (Lexing.lexeme_end filebuf) filebuf.Lexing.lex_buffer (Lexing.lexeme filebuf));
        exit 2)
    | SyntaxError(str) ->
        print_string str
    | e -> print_string(to_string(e) ^ get_backtrace())
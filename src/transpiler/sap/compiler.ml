open Lexer
open Parser
open Utils
open Batteries
open Normal_of_sap
open Printexc
open Print_sap
open Sap_ast
open Scheduler
open Shared.Exceptions
open Shared.Colors

let lexsub start end_ str lexeme =
    let head = String.sub str 0 start and
        tail = String.sub str end_ (40) and
        red = "\027[32m" and
        endc = "\027[0m" in
    head ^ red ^ lexeme ^ endc ^ tail

let compile print filename =
  let iter = if print then Sol.Print.string_of_ast else Sol.Js.js_of_ast in
  let iter = print_ast in
  let input = File.open_in filename in
  let filebuf = Lexing.from_channel input in
  try
    let ast = Parser.init Lexer.token filebuf in
    let ast = schedule ast in
    ast |> print_ast |> print_endline
    (*let nm_ast = nm_of_ast ast in
    let print_nm = (function true -> "[NORMAL]\n" | false -> "[UNNORMAL]\n") in
    let nm_flag = nm_ast |> is_normal |> print_nm in
    print_string (nm_flag ^ iter nm_ast);*)

  with
    | Parser.Error ->
        (Printf.eprintf "At offset %d: syntax error on token: \"%s\"!\n%s\n"
        (Lexing.lexeme_start filebuf) (Lexing.lexeme filebuf)
        (*(lexsub (filebuf.Lexing.lex_start_pos) filebuf.Lexing.lex_buffer (Lexing.lexeme filebuf));*)
        (lexsub (Lexing.lexeme_start filebuf) (Lexing.lexeme_end filebuf) filebuf.Lexing.lex_buffer (Lexing.lexeme filebuf));
        exit 2)
    | SyntaxError(str) ->
        print_string str
    | CyclicDependencyGraph(str) -> "Cyclic Dependency graph in node " ^ str |> error |> print_endline |> raise Unrecoverable
    | e -> print_string(to_string(e) ^ get_backtrace())
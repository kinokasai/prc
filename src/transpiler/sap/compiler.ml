open Lexer
open Parser
open Utils
open Batteries
open Normal_of_sap
open Printexc
open Print_sap
open Sap_ast
open Scheduler
open Sol_of_normal
open Shared.Colors
open Core.Std
open Shared.Exceptions

let lexsub start end_ str lexeme =
    let head = String.sub str 0 start and
        tail = String.sub str end_ (40) and
        red = "\027[32m" and
        endc = "\027[0m" in
    head ^ red ^ lexeme ^ endc ^ tail

let build name ext =
  "build/" ^ (Filename.chop_extension (Filename.basename name)) ^ ext

let parse filename =
  let input = File.open_in filename in
  let filebuf = Lexing.from_channel input in
  try
    Parser.init Lexer.token filebuf
  with
    | Parser.Error ->
        (Printf.eprintf "At offset %d: syntax error on token: \"%s\"!\n%s\n"
        (Lexing.lexeme_start filebuf) (Lexing.lexeme filebuf)
        (*(lexsub (filebuf.Lexing.lex_start_pos) filebuf.Lexing.lex_buffer (Lexing.lexeme filebuf));*)
        (lexsub (Lexing.lexeme_start filebuf) (Lexing.lexeme_end filebuf) filebuf.Lexing.lex_buffer (Lexing.lexeme filebuf));
        exit 2)
    | SyntaxError(str) ->
        print_string str |> exit 3

let schedule filename ast =
try
  let ast = schedule ast in
  let txt = ast |> Print_sap.print_ast in
  let name = build filename ".scheduled" in
  Out_channel.write_all name ~data:txt;
  ast
with
  | CyclicDependencyGraph(str) -> "Cyclic Dependency graph in node " ^ str |> error |> print_endline; raise Unrecoverable
  | e -> to_string(e) ^ get_backtrace() |> print_endline |> exit 4

let normal_of_ast filename ast =
try
  let ast = nm_of_ast ast in
  let text = ast |> Print_sap.print_ast in
  let name = build filename ".nsap" in
  Out_channel.write_all name ~data:text;
  ast
with
  | Ill_Constructed_Ast -> "Ast is not normalized" |> error |> print_endline |> raise Unrecoverable
  | e -> to_string(e) ^ get_backtrace() |> print_endline |> exit 4

let sol_of_ast filename ast =
try
  let ast = sol_of_ast ast in
  let text = ast |> Sol.Print.string_of_ast in
  let name = build filename ".sol" in
  Out_channel.write_all name ~data:text;
  ast
with
    | No_Interface_Type(str) -> str |> print_endline |> raise Unrecoverable
    | Too_Many_Parameters(str) -> str |> print_endline |> raise Unrecoverable
    | Expected(str) -> str |> error |> print_endline |> raise Unrecoverable
    | e -> to_string(e) ^ get_backtrace() |> print_endline |> exit 4

let compile filename =
  parse filename |> schedule filename |> normal_of_ast filename |> normal_check |> sol_of_ast filename

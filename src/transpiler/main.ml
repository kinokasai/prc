open Core.Std
open Batteries
open Printexc
open Shared.Exceptions

let compile_sol filename out_name ast =
    Sol.Compiler.compile filename out_name ast

let compile_from_sol filename out_name =
    Sol.Compiler.parse filename
    |> compile_sol filename out_name

let compile_sap filename out_name =
  Sap.Compiler.compile filename
  |> compile_sol filename out_name

let command =
    Command.basic
        ~summary:"Parse sol and compile it to js"
        Command.Spec.(
            empty
            +> flag "-o" (optional_with_default "out.js" string) ~doc:" File output name"
            +> flag "-sol" no_arg ~doc:" compile from sol code"
            +> anon ("filename" %: file)
        )
    (fun out_name sol filename _ ->
        try
            let _ = Sys.command "mkdir -p build" in
            let compile = match sol with
                | true -> compile_from_sol
                | false -> compile_sap in
            compile filename out_name
        with
          | Unrecoverable -> "Unrecoverable Error: exiting..." |> print_endline
          | e -> print_string(to_string(e) ^ get_backtrace()); exit 4
    )

let _ =
    Command.run command
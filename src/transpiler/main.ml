open Core.Std
open Batteries
open Printexc

let command =
    Command.basic
        ~summary:"Parse sol and compile it to js"
        Command.Spec.(
            empty
            +> flag "-print-sol" no_arg~doc:" print sol code"
            +> flag "-sol" no_arg~doc:" compile from sol code"
            +> anon ("filename" %: file)
        )
    (fun print sol filename _ ->
        try match sol with
            | false -> Normal.Compiler.compile print filename
            | _ -> Sol.Compiler.compile print filename
        with
            | e -> print_string(to_string(e) ^ get_backtrace())
    )

let _ =
    Command.run command
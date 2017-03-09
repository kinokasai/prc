open Core.Std

let command =
    Command.basic
        ~summary:"Parse sol and compile it to js"
        Command.Spec.(
            empty
            +> flag "-print-sol" no_arg~doc:" print sol code"
            +> anon ("filename" %: file)
        )
    (fun print filename () ->
        match print with
            | _ -> Sol.Main.compile filename
    )

let _ =
    Command.run command
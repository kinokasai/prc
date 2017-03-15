let spaces count =
    let count = if count < 0 then 0 else count in
    Bytes.to_string (Bytes.make count ' ')

let iendl, incendl, decendl, incindent, decindent, reset =
    let count = ref 0 in
    (fun () -> "\n" ^ spaces !count),
    (fun () -> count := !count + 2; "\n" ^ spaces !count),
    (fun () -> count := !count - 2; "\n" ^ spaces !count),
    (fun () -> count := !count + 2; ""),
    (fun () -> count := !count - 2; ""),
    (fun () -> count := 0);;
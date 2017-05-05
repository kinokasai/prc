open BatString
let empty str =
    String.length str == 0

let remove str sub =
    (replace str sub "") |> snd
    
let build name ext =
  "build/" ^ (Filename.chop_extension (Filename.basename name)) ^ ext
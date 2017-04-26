open BatString
let empty str =
    String.length str == 0

let remove str sub =
    (replace str sub "") |> snd
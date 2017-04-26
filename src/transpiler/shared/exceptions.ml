open Colors

exception CyclicDependencyGraph of string
exception Unrecoverable

let error str =
  red ^ "Error: " ^ endc ^ str
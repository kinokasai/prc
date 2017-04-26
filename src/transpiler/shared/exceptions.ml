open Colors

exception CyclicDependencyGraph of string
exception Unrecoverable
exception No_Interface_Type of string
exception Too_Many_Parameters of string
exception Ill_Constructed_Ast
exception Expected of string
exception No_Output of string

let error str =
  red ^ "Error: " ^ endc ^ str

let quote str =
  "`" ^ str ^ "'"
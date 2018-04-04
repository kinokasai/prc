open BatList
open Sap_ast
open Shared.Colors
open Print_sap
open Shared.Exceptions

exception TypeError of exp * kind list * kind

let print_type_err = function
  | TypeError(exp, kindl, kind) -> 
    red ^ "Type Error: " ^ endc ^
    " expected " ^ quote (kindl |> map print_kind |> map quote |> concat " or ") ^
    " got: " ^ quote (print_kind kind) ^
    " in " ^ quote (print_exp exp)

  | _ -> "Ok then"


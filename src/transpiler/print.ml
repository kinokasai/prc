open Types
open Printf
let concat = String.concat;;

let spaces count =
    Bytes.to_string (Bytes.make count ' ')

let iendl, incendl, decendl =
    let count = ref 0 in
    (fun () -> "\n" ^ spaces !count),
    (fun () -> count := !count + 2; "\n" ^ spaces !count),
    (fun () -> count := !count - 2; "\n" ^ spaces !count);;

(*let rec string_of_op = function*)
  (*| Plus -> "Plus"*)
  (*| Minus -> "Minus"*)

(*and string_of_exp = function*)
  (*| Binop(op, e1, e2) -> "Binop " ^ wrap (string_of_op op ^ string_of_exp e1 ^*)
                          (*string_of_exp e2)*)
  (*| Const n -> "Const " ^ string_of_int n*)

let rec string_of_machine = function
    | {id; memory; instances; reset; step} ->
            "machine " ^ id ^ iendl ()
            ^ string_of_memory memory ^ iendl ()
            ^ string_of_instances instances ^ iendl ()
            ^ string_of_reset reset ^ incendl ()
            ^ string_of_step_dec step

and string_of_memory mem =
    "memory " ^ (string_of_vardecs mem)

and string_of_instances inst =
    "instances " ^ (List.map string_of_machdec inst |> concat ", ")

and string_of_reset reset_exp =
    "reset () = " ^ string_of_exp reset_exp

and string_of_step_dec = function
    | StepDec(vd, rvd, exp) ->
            "step(" ^ (string_of_vardecs vd) ^ ") returns ("
            ^ (string_of_vardecs rvd) ^ ") = "
            ^ string_of_exp exp

and string_of_vardecs vds =
    List.map string_of_vardec vds |> concat ", "

and string_of_exp = function
    | Skip -> "skip"
    | _ -> "nop"

and string_of_vardec = function
    | VarDec(id, ty) -> id ^ " : " ^ ty

and string_of_machdec = function
    | MachDec(id, mid) -> id ^ " : " ^ mid

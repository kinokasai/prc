open Ast_iterator
open Types
open Print

let concat = String.concat;;

let map f l sep =
  List.map f l |> concat sep

let wrap s = "(" ^ s ^ ")"

module JS = struct
  let js_exp sub = function
    | Case(id, bl) ->
      let a = "switch" ^ wrap id ^ "{" ^ incendl() in
      let b  = map (sub.branch sub) bl (iendl()) in
      let c = decendl() in
        a ^ b ^ c ^ "}"
    | Reset(id) -> "this." ^ id ^ ".reset()"
    | Skip -> ""
    | StateAssign(id, vl) -> "this." ^ id ^ " = " ^ sub.val sub vl
    | Step(vid, id, vll) ->
      "[" ^ (vid |> concat ", ") ^ "]" ^ " = this." ^ id ^
      ".step(" ^ map (sub.val sub) vll ", " ^ ")"
    | VarAssign(id, vl) -> id ^ " = " ^ sub.val sub vl
end
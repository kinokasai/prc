open Ast_iterator
open Types
open Indent

let concat = String.concat
let rev = List.rev

let map f l sep =
  List.map f l |> concat sep

let wrap s = "(" ^ s ^ ")"

let code = ref []

let append l =
  code := (rev l)@(!code); ()

module JS = struct
  let js_exp sub = function
    (*| Case(id, bl) ->
      let a = concat "" ("switch"::wrap id::"{"::incendl()::[]) in
      let b = 
      let b  = map (sub.branch sub) bl (iendl()) in
      let c = decendl() in
      "}"::c::b::a::!code*)
    | Reset(id) -> append ("this."::id::".reset()"::[])
    | Skip -> ()
    (*append(["skip"])*)
    | StateAssign(id, vl) -> append ("this."::id::" = "::[]);
    (sub.value sub vl)
    | _ -> ()
    (*| Step(vid, id, vll) ->
      "[" ^ (vid |> concat ", ") ^ "]" ^ " = this." ^ id ^
      ".step(" ^ map (sub.val sub) vll ", " ^ ")"
    | VarAssign(id, vl) -> id ^ " = " ^ sub.val sub vl*)

    let js_val sub = function
      | Immediate(i) -> append (string_of_int i::[])
      | Variable(id) -> append (id::[])
end

let code_iter =
  {default_iter with exp = JS.js_exp;
                     value = JS.js_val}
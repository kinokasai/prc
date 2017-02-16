open Types
open Printf
open Helpers
let concat = String.concat;;

let spaces count =
    let count = if count < 0 then 0 else count in
    Bytes.to_string (Bytes.make count ' ')

(* XXX: use [Pprint] [http://gallium.inria.fr/blog/first-release-of-pprint/] *)
let iendl, incendl, decendl, incindent, decindent, reset =
    let count = ref 0 in
    (fun () -> "\n" ^ spaces !count),
    (fun () -> count := !count + 2; "\n" ^ spaces !count),
    (fun () -> count := !count - 2; "\n" ^ spaces !count),
    (fun () -> count := !count + 2; ""),
    (fun () -> count := !count - 2; ""),
    (fun () -> count := 0);;

let gen, reset =
    let id = ref 0 in
    (fun () -> incr id; string_of_int !id),
    (fun () -> id := 0);;

let id_of_machdec = function
    | MachDec(id, mid) -> id

let id_of_vardec = function
    | VarDec(id, ty) -> id

let js_of_machdec = function
    | MachDec(id, mid) -> "this." ^ id ^ " = new " ^ mid ^ "();"

let rec js_of_val = function
    | Variable(id) -> id
    | State(id) -> "this." ^ id
    | Immediate(i) -> string_of_int i
    | Constr(id) -> id
    | Op(id, vll) -> id ^ wrap (List.map js_of_val vll |> concat ", ")

let rec js_of_exp = function
    | VarAssign(id, vl) -> id ^ " = " ^ js_of_val vl
    | StateAssign(id, vl) -> "this." ^ id ^ " = " ^ js_of_val vl
    | Skip -> ""
    | Reset(id) -> "this." ^ id ^ ".reset()"
    | Step(vid, id, vll) ->
            "[" ^ (vid |> concat ", ") ^ "]" ^
            " = this." ^ id ^
            ".step(" ^ (List.map js_of_val vll |> concat ", ") ^ ")"
    | Case(id, bl) ->
            let a = "switch" ^ wrap id ^ " {" ^ incendl() in
            let b = List.map js_of_branch bl |> concat (iendl()) in
            let c = decendl() in
            let d = "}" in
            a ^ b ^ c ^ d

and js_of_branch = function
    | Branch(id, exp) ->
            let a = "case " ^ id ^ ":" ^ incendl() in
            let b = js_of_exp exp ^ ";" ^ iendl() in
            let c = "break;" in
            let d = decindent() in
            a ^ b ^ c ^ d

let js_of_seqexp sexp =
    let a = (List.map js_of_exp sexp |> concat (";" ^ iendl())) in
    let b = if empty a then "" else ";" in
    a ^ b

let js_of_vardecs_id vds =
    List.map id_of_vardec vds |> concat ", "

let js_of_vardecs vds =
    List.map (fun vd -> "var " ^ (id_of_vardec vd) ^ " = undefined;") vds
        |> concat (iendl())

let js_of_step = function
    | {avd; rvd; vd; sexp} ->
            let a = "step = function(" ^ js_of_vardecs_id avd ^ ") {" ^ incendl() in
            let b = js_of_vardecs vd in
            let b' = if String.length b == 0 then "" else iendl() in
            let c = js_of_seqexp sexp ^ iendl() in
            let d = "return [" ^ js_of_vardecs_id rvd ^ "];" in
            let e = decendl() in
            a ^ b ^ b' ^ c ^ d ^ e

let rec js_of_machine = function
    | {id; memory; instances; reset; step} ->
            let a = "function " ^ id ^ "() {" in
            let a' = incendl() in
            let b = js_of_memory memory in
            let c = js_of_instances instances in
            let b' = if empty b then "" else (if empty c then decendl() else iendl()) in
            let c' = if empty c then "" else (if empty b then "" else decendl()) in
            let d = "}" ^ iendl() ^ iendl() in
            let e = id ^ ".prototype.reset = function() {" ^ incendl() in
            let f = js_of_reset reset instances in
            let g = decendl() in
            let h = "}" ^ iendl() ^ iendl() in
            let i = id ^ ".prototype." ^ js_of_step step in
            let j = "}" ^ iendl() in
            a ^ a' ^ b ^ b' ^ c ^ c' ^ d ^ e ^ f ^ g ^ h ^ i ^ j

and js_of_memory mem =
    List.map (fun vd -> "this." ^ (id_of_vardec vd) ^ " = undefined;") mem
        |> concat (iendl())

and js_of_instances inst =
    List.map js_of_machdec inst |> concat (iendl())

and js_of_reset rst instances =
    let code = (fun inst -> "this." ^ (id_of_machdec inst) ^ ".reset();") in
    let a = List.map code instances |> concat (iendl()) in
    let a' = if empty a then "" else iendl() in
    let b = js_of_seqexp rst in
    a ^ a' ^ b

let js_of_type_dec = function
    | TypeDec(id, cl) ->
            let a = "var " ^ id ^ "_enum = Object.freeze({" ^ incendl() in
            let const_val = (fun id -> id ^ ": " ^ (gen())) in
            let b = List.map const_val cl |> concat ("," ^ iendl()) in
            let c = decendl() in
            let d = "});" ^ iendl() in
            a ^ b ^ c ^ d

let js_of_machine_list ml =
    List.map js_of_machine ml |> concat (iendl())

let js_of_type_dec_list tdl =
    List.map js_of_type_dec tdl |> concat (iendl())

let js_of_ast = function
    | {tdl; mdl;} ->
            let a = js_of_type_dec_list tdl ^ iendl() in
            let b = js_of_machine_list mdl ^ iendl() in
            a ^ b

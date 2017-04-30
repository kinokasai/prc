open Shared.Types
open Ast
open Printf
open Helpers
open Shared.Exceptions
open Shared.Colors
open List

exception Empty_Id_List

module Smap = Map.Make(String);;
let tidmap = ref Smap.empty;;
let tmap = ref Smap.empty;;
let interface_event_id = ref None

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

let js_of_constr ty_id c_id = match c_id with
    | "True" -> "true"
    | "False" -> "false"
    | _ -> ty_id ^ "_enum." ^ c_id

let js_of_id_list = function
  | [] -> raise Empty_Id_List
  | [x] -> x
  | x::xs -> "[" ^ ((x::xs) |> concat ", ") ^ "]"

let id_of_machdec md =
    md.mach_id

let id_of_vardec (var_dec:var_dec) =
  var_dec.var_id

let js_of_machdec md =
  "this." ^ md.mach_id ^ " = new " ^ md.type_id ^ "();"

let rec js_of_val = function
  | Litteral(lit) -> lit
  | Constr(cid) -> Smap.find cid !tidmap

let rec js_of_exp = function
  | Op(id, expl) -> id ^ wrap (List.map js_of_exp expl |> concat ", ")
  | State(id) -> "this." ^ id
  | Step(id, expl) -> "this." ^ remove id ".step" ^
            ".step(" ^ (List.map js_of_exp expl |> concat ", ") ^ ")"
  | Variable(id) -> id
  | Value(vl) -> js_of_val vl

let rec js_of_inst = function
    | VarAssign(idl, vl) -> js_of_id_list idl ^ " = " ^ js_of_exp vl
    | StateAssign(id, vl) -> "this." ^ id ^ " = " ^ js_of_exp vl
    | Skip -> ""
    | Reset(id) -> "this." ^ id ^ ".reset()"
    | Case(id, bl) ->
      let f = (fun id -> match !interface_event_id with
                            | Some event_id when id = event_id -> id ^ ".id"
                            | _ -> id) in
      let a = "switch" ^ wrap (f id) ^ " {" ^ incendl() in
      let b = List.map (js_of_branch id) bl |> concat (iendl()) in
      let c = decendl() in
      let d = "}" in
      a ^ b ^ c ^ d

and js_of_branch switch_id = function
  | Branch(constr_id, inst) ->
    (*let _ = print_string (constr.id ^ "\n") in*)
    let full_id = Smap.find constr_id !tidmap in
    let case = "case " ^ full_id ^ ":" ^ incendl() in
    (*let f = (fun vid -> "var " ^ vid ^ " = " ^ switch_id ^ "." ^ vid ^ ";") in
    let constr_vars = List.map f constr.params |> concat (iendl()) in*)
    let inst = iendl() ^ js_of_seqinst inst ^ iendl() in
    let break = "break;" in
    let d = decindent() in
    case (*^ constr_vars*) ^ inst ^ break ^ d
            

and js_of_seqinst sinst =
    let a = (List.map js_of_inst sinst |> concat (";" ^ iendl())) in
    let b = if empty a then "" else ";" in
    a ^ b

let js_of_vardecs_id vds =
    List.map id_of_vardec vds |> concat ", "

let js_of_vardecs vds =
    List.map (fun vd -> "var " ^ (id_of_vardec vd) ^ " = undefined;") vds
        |> concat (iendl())

let js_of_out_vd meml vd =
    let midl = meml |> map id_of_vardec in
    match mem vd.var_id midl with
      | true -> "this." ^ vd.var_id
      | false -> vd.var_id

let js_of_step interface meml = function
  | {avd; rvd; vd; instl} ->
    let _ = if interface then interface_event_id := Some (List.hd avd).var_id in
    let a = "step = function(" ^ js_of_vardecs_id avd ^ ") {" ^ incendl() in
    let b = js_of_vardecs vd in
    let b' = if String.length b == 0 then "" else iendl() in
    let c = js_of_seqinst instl ^ iendl() in
    try
        let d = if interface then "return this;"
                             else "return " ^ js_of_id_list (List.map (js_of_out_vd meml) rvd) ^ ";" in
        let e = decendl() in
        a ^ b ^ b' ^ c ^ d ^ e
    with
        | Empty_Id_List -> No_Output "" |> raise

let js_obj_of_typedec type_id ty = 
  let arg_lits = List.map (fun vd -> vd.var_id ^ ":" ^ vd.var_id) ty.vdl |> concat ", " in
  let args = List.map (fun vd -> vd.var_id) ty.vdl |> concat ", " in
  let func_name = type_id ^ "_type." ^ ty.id ^ " = function(" ^ args ^ ") {" ^ incendl() in
  let arg_lits = if arg_lits = "" then "" else ", " ^ arg_lits in
  let full_id = Smap.find ty.id !tidmap in
  let event_lit = "{id: " ^ full_id ^ arg_lits ^ "}" in
  let ret = "return " ^ event_lit ^ decendl() in
  func_name ^ ret ^ "}\n"

let js_of_type mid tid ty =
  let std = (fun s -> let c = Char.lowercase_ascii (String.get s 0) in
                      String.make 1 c ^ (Batteries.String.lchop s)) in
  let arg_list = List.map (fun vd -> vd.var_id) ty.vdl |> concat ", " in
  let fname = mid ^ ".prototype." ^ std ty.id ^ " = function (" ^ arg_list ^ ") {" ^ incendl() in
  let event_lit = tid ^ "_type." ^ ty.id  ^ "(" ^ arg_list ^ ")" in
  let step_method = "this.step(" ^ event_lit ^ ");" ^ iendl() in
  let ret = "return this;" ^ decendl() in 
  fname ^ step_method ^ ret ^ "}\n"

let js_of_interface mid id =
  let td = Smap.find id !tmap in
    List.map (js_of_type mid id) td |> concat "\n"

let js_of_delta id delta =
  let a = id ^ ".prototype.get_" ^ delta.old_id ^ " = function() {" in
  let b = incendl() in
  let c = "return this." ^ delta.new_id ^ ";" in
  let d = decendl() in
  let e = "}" ^ iendl() ^ iendl() in
  let f = id ^ ".prototype.set_" ^ delta.old_id ^ " = function (new_value) {" in
  let g = incendl() in
  let h = "this." ^ delta.new_id ^ " = new_value;" ^ iendl() in
  let h' = "return this;" in
  let i = decendl() in
  let j = "}" ^ iendl() ^ iendl() in
  a ^ b ^ c ^ d ^ e ^ f ^ g ^ h ^ h' ^ i ^ j

let js_of_deltas id deltas =
  deltas |> map (js_of_delta id) |> concat ""

let rec js_of_machine = function
  | {id; memory; instances; interface; reset; step; deltas} ->
  try
    let is_interface = BatOption.is_some interface in
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
    let i = id ^ ".prototype." ^ js_of_step is_interface memory step in
    let j = "}" ^ iendl() in
    let z = match deltas with
      | None -> ""
      | Some deltas -> js_of_deltas id deltas in
    let k = match interface with
      | None -> ""
      | Some tid -> js_of_interface id tid in
    a ^ a' ^ b ^ b' ^ c ^ c' ^ d ^ e ^ f ^ g ^ h ^ i ^ j ^ z ^ k
with
    | No_Output(str) ->
        "Node " ^ (cwrap blue id) ^ " has no output" |> error |> print_endline;
        raise Unrecoverable

and js_of_memory mem =
    List.map (fun vd -> "this." ^ (id_of_vardec vd) ^ " = undefined;") mem
        |> concat (iendl())

and js_of_instances inst =
    List.map js_of_machdec inst |> concat (iendl())

and js_of_reset rst instances =
    let code = (fun inst -> "this." ^ (id_of_machdec inst) ^ ".reset();") in
    let a = List.map code instances |> concat (iendl()) in
    let a' = if empty a then "" else iendl() in
    let b = js_of_seqinst rst ^ iendl() in
    let c = "return this;" in
    a ^ a' ^ b ^ c

let js_of_type_dec (type_dec: Shared.Types.type_dec) =
    let a = "var " ^ type_dec.id ^ "_enum = Object.freeze({" ^ incendl() in
    let const_val =
      (fun (ty:Shared.Types.ty) ->
        tidmap := Smap.add ty.id (js_of_constr type_dec.id ty.id) !tidmap;
        ty.id ^ ": " ^ (gen())) in
   let b = List.map const_val type_dec.type_list |> concat ("," ^ iendl()) in
   let _ = tmap := Smap.add type_dec.id type_dec.type_list !tmap in
   let c = decendl() in
   let d = "});" ^ iendl() ^ iendl() in
   let obj = "function " ^ type_dec.id ^ "_type() {}" ^ iendl() ^ iendl() in
   let variants = List.map (js_obj_of_typedec type_dec.id) type_dec.type_list |> concat (iendl()) in
   a ^ b ^ c ^ d ^ obj ^ variants

let js_of_machine_list ml =
    List.map js_of_machine ml |> concat (iendl())

let js_of_type_dec_list tdl =
    List.map js_of_type_dec tdl |> concat (iendl())

let init_env () =
    tidmap := Smap.add "True" "true" !tidmap;
    tidmap := Smap.add "False" "false" !tidmap

let js_of_ast : sol_ast -> string = fun ast ->
    let _ = init_env () in
    let a = js_of_type_dec_list ast.tdl ^ iendl() in
    let b = js_of_machine_list ast.mdl ^ iendl() in
    a ^ b
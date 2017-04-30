open Sap_ast
open BatList
open Shared.Exceptions
open Shared.Types

exception ExpectedPattern
exception ExpectedSingle

let fily = Utils.fily
let gidl = ref []
let eqfbyl = ref []
let replaced_id_list = ref []
let replaced = ref None

let gen, reset =
    let id = ref 0 in
    (fun () -> incr id; "t" ^ string_of_int !id),
    (fun () -> id := 0);;

let rec new_id () =
  let id = gen() in
  match mem id !gidl with
    | true -> new_id ()
    | false -> id

let replace_vd vd new_id =
  Shared.Types.{var_id = new_id; type_id = vd.type_id}

let replace_out_vdl out_vdl =
  let rec tmp newl outl =
    match outl with
      | [] -> newl
      | x::xs ->
      try
        let f = (fun tuple -> (fst tuple) = x.var_id) in
        let tuple = !replaced_id_list |> find f in
        let vd = replace_vd x (snd tuple) in
          tmp (vd::newl) xs
      with
        | Not_found -> tmp (x::newl) xs in
  tmp [] out_vdl

let rec nm_of_ast ast =
  let tdl = ast.type_dec_list in
  let ndl = ast.node_list |> List.map nm_of_node in
  {type_dec_list = tdl; node_list = ndl}

and nm_of_eql eql =
  eql |> Demux.demux_eql
      |> List.map nm_of_eq
      |> append !eqfbyl

and nm_of_eq eq =
try
let _ = match !replaced with
  | None -> ()
  | Some id -> replaced_id_list := (hd (Utils.get_ids_from_lhs eq.lhs), id)::!replaced_id_list;
               replaced := None in

{ lhs = eq.lhs;
  rhs = nm_of_exp eq.clk eq.rhs;
  clk = eq.clk}
with
  | ExpectedSingle -> Expected ("Expected Single in equation: " ^ (Print_sap.print_eq eq |> quote)) |> raise

and nm_of_flow clk flw =
  let exp = nm_of_exp clk flw.exp in
  {constr = flw.constr; exp}

and nm_of_exp clk exp =
  match exp with
    | ExpPattern(expl) -> fily ~print:Print_sap.print_exp expl |> nm_of_exp clk
    | Fby(vl, exp) ->
      let id = new_id() in
      let eq = {lhs = Id(id); rhs = Fby(vl, exp); clk} in
      let _ = eqfbyl := eq::!eqfbyl in
      let _ = replaced := Some id in
        Variable(id)
    | Op(id, expl) -> Op(id, expl |> map (nm_of_exp clk))
    | NodeCall(id, expl) -> NodeCall(id, expl |> map (nm_of_exp clk))
    | When(exp, _) -> nm_of_exp clk exp
    (* I think you should add a flow list there *)
    | Merge(id, flwl) -> Merge(id, flwl |> map (nm_of_flow clk))
    | _ -> exp

and nm_of_node node =
  let _ = eqfbyl := [] in
  let _ = gidl := [] in
  let interface = node.interface in
  let id = node.id in
  let in_vdl = node.in_vdl in
  let step_vdl = node.step_vdl in
  let eql = Demux.demux_eql node.eql in
  let idl = Utils.get_ids_eql eql in
  let _ = gidl := idl in
  let eql = nm_of_eql node.eql in
  let out_vdl = replace_out_vdl node.out_vdl in
  {interface; id; in_vdl; out_vdl; step_vdl; eql}
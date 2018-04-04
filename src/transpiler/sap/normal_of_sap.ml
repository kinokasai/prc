open Sap_ast
open BatList
open Shared.Exceptions
open Shared.Types
open Print_sap

exception ExpectedPattern
exception ExpectedSingle

let make_delta old_id new_id =
  {old_id; new_id}

let fily = Utils.fily
let gidl = ref []
let eqfbyl = ref []
let delta_list = ref []
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
        let f = (fun delta -> delta.old_id = x.var_id) in
        let delta = !delta_list |> find f in
        let vd = replace_vd x delta.new_id in
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
let new_eq = { lhs = eq.lhs;
  rhs = nm_of_exp eq.clk eq.rhs;
  clk = eq.clk;
  kind = Monotype("undefined")} in
let _ = match !replaced with
  | None -> ()
  | Some id -> delta_list := make_delta (hd (Utils.get_ids_from_lhs eq.lhs)) id ::!delta_list;
               replaced := None in
  new_eq
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
      let eq = {lhs = Id(id); rhs = Fby(vl, exp); clk; kind = Monotype("undefined")} in
      let _ = eqfbyl := eq::!eqfbyl in
      let _ = replaced := Some id in
        Variable(id)
    | Op(id, expl) -> Op(id, expl |> map (nm_of_exp clk))
    (* You should replace the nodecall *)
    | NodeCall(nid, expl) -> 
      let id = new_id() in(*NodeCall(id, expl |> map (nm_of_exp clk))*)
      let eq = {lhs= Id(id); rhs = NodeCall(nid, expl |> map (nm_of_exp clk)); clk; kind=Monotype("undefined")} in
      let _ = eqfbyl := eq::!eqfbyl in
      let _ = replaced := Some id in
        Variable(id)
    | When(exp, _) -> nm_of_exp clk exp
    (* I think you should add a flow list there *)
    | Merge(id, flwl) -> Merge(id, flwl |> map (nm_of_flow clk))
    | _ -> exp

(*and add_out_eq eql =
  let f = (fun delta -> {lhs = Id(delta.fresh_id);
                         rhs = Variable(delta.new_id);
                         clk = delta.clk}) in
  eql@(!delta_list |> map f)*)

and nm_of_node node =
  let _ = eqfbyl := [] in
  let _ = gidl := [] in
  let _ = delta_list := [] in
  let interface = node.interface in
  let id = node.id in
  let in_vdl = node.in_vdl in
  let step_vdl = node.step_vdl in
  let eql = Demux.demux_eql node.eql in
  (*eql |> map print_eq |> iter print_endline;*)
  let idl = Utils.get_ids_eql eql in
  let _ = gidl := idl in
  let eql = node.eql |> nm_of_eql in
  let out_vdl = node.out_vdl in
  let deltas = Some !delta_list in
  (*let eql = node.eql |> nm_of_eql |> add_out_eq in*)
  (*let out_vdl = replace_out_vdl node.out_vdl in*)
  {interface; id; in_vdl; out_vdl; step_vdl; eql; deltas}
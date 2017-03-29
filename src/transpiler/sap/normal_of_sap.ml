open BatList
open Sap_ast

exception ExpectedSingle
exception ExpectedPattern

let rec demux_exp lhsl exp =
  match exp with
    | ExpPattern(expl) -> demux_pattern lhsl expl
    | _ -> raise ExpectedPattern

and demux_pattern lhsl expl =
  let eq_fun = (fun lhs exp -> {lhs; rhs = exp}) in
    map2 eq_fun lhsl expl

and nm_of_ast ast =
  let tdl = ast.type_dec_list in
  let ndl = ast.node_list |> List.map nm_of_node in
  {type_dec_list = tdl; node_list = ndl}

and nm_of_eql eql =
  eql |> List.map nm_of_eq
      |> List.flatten

and nm_of_eq eq =
  match eq.lhs with
    | Id(id) -> [{lhs = Id(id); rhs = nm_of_exp eq.rhs;}]
    | Pattern(lhsl) -> demux_exp lhsl eq.rhs

and nm_of_exp exp =
  match exp with
    | ExpPattern(_) -> raise ExpectedSingle
    | _ -> exp

and nm_of_node node =
  let interface = node.interface in
  let id = node.id in
  let in_vdl = node.in_vdl in
  let out_vdl = node.out_vdl in
  let step_vdl = node.step_vdl in
  let eql = nm_of_eql node.eql in
  {interface; id; in_vdl; out_vdl; step_vdl; eql}
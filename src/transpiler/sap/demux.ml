open Sap_ast
open BatList
open Shared.Exceptions
open Print_sap

exception ExpectedPatternExp
exception ExpectedPatternLhs
exception ExpectedSingle

let dump = BatPervasives.dump

let make_tmp_eq eq exp =
  let lhs = eq.lhs in
  let rhs = exp in
  let clk = eq.clk in
  let kind = Monotype("undefined") in
  {lhs; rhs; clk; kind}

let get_lhsl = function
  | Pattern(lhsl) -> lhsl
  | _ -> raise ExpectedPatternLhs

let get_lhs = function
  | Id(id) -> [Id(id)]
  | _ -> raise ExpectedSingle

let at i l =
  BatList.at l i

let rec trec newl i l =
  match l with
    | [] -> [rev newl]
    | x :: xs -> trec ((at i x)::newl) (i) xs

let transform whatev i =
  trec [] i whatev

let match_flow_exp flwl expl =
  let f = (fun flw exp -> {constr = flw.constr; exp}) in
  map2 f flwl expl

let rec demux_flwl id flwl =
  let expl = ref [[]] in
  for i = 0 to length (get_expl (hd flwl).exp) - 1 do
    let f = (fun exp -> get_expl exp) in
    let tmp = flwl |>  map (fun flw -> flw.exp) in
    let tmp = tmp |> map f in
    let tmp = transform tmp i in
    expl := tmp@(!expl)
  done;
  let expl = !expl |> rev |> tl in
  let newflwl = Utils.times_list flwl (length expl) |> rev |> tl in
  let newflwl = map2 match_flow_exp newflwl expl in
  let f = (fun flw -> Merge(id, flw)) in
  newflwl |> map f

and merge_check expl =
  let exp = hd expl in
  match exp with
    | Merge(id, flwl) -> get_expl exp
    | ExpPattern(in_expl) when (length expl) = 1 -> merge_check in_expl
    | _ -> expl

and get_expl exp =
  match exp with
  | ExpPattern(expl) ->  merge_check expl
  | Merge(id, flwl) -> let l = demux_flwl id flwl in l
  | When(exp, _) -> get_expl exp
  | _ -> raise (Failure (exp |> print_exp))

let demux eq =
try
  let expl = get_expl eq.rhs in
  let lhsl = match length expl with
    | 1 -> get_lhs eq.lhs
    | _ -> get_lhsl eq.lhs in
  let clk = eq.clk in
  let kind = Monotype("undefined") in
  let f = (fun lhs exp -> {lhs; rhs = exp; clk; kind}) in
  map2 f lhsl expl
with
  | ExpectedPatternExp -> Expected ("Expected Exp Pattern in equation: " ^ (Print_sap.print_eq eq |> quote)) |> raise
  | ExpectedPatternLhs -> Expected ("Expected Lhs Pattern in equation: " ^ (Print_sap.print_eq eq |> quote)) |> raise

let rec demux_merge eq =
  match eq.lhs with
    | Pattern(_) -> demux eq |> map demux_eq |> flatten
    | _ -> [eq]

and demux_eq eq =
  match eq.rhs with
    | Merge(_) -> demux_merge eq
    | ExpPattern(_) -> demux eq |> map demux_eq |> flatten
    | NodeCall(_, expl) -> [eq]
    | When(exp, _) -> make_tmp_eq eq exp |> demux_eq
    | _ -> [eq]

let demux_eql eql =
  eql |> map demux_eq |> flatten
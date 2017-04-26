open Sap_ast
open Shared.Exceptions

let rec assert_flat_lhs lhsl =
  let is_flat = (function Id(_) -> true | _ -> false) in
  lhsl |> List.fold_left (fun acc elt -> acc && is_flat elt) true

and assert_simple_rhs eq =
  match eq.lhs with
    | Pattern(lhsl) ->
      (match eq.rhs with
        | NodeCall(_,_) -> lhsl |> assert_flat_lhs
        | _ -> false)
    | _ -> true

and expect_cexp exp =
  match exp with
    | Merge(id, fll) -> fll |> List.fold_left (fun acc flw -> acc && expect_cexp flw.exp) true
    | _ -> expect_exp exp

and expect_exp exp =
  match exp with
    | When(exp) -> expect_exp exp
    | Op(_, expl) -> expl |> List.fold_left (fun acc exp -> acc && expect_exp exp) true
    | Variable(_) -> true
    | Value(_) -> true
    | _ -> false

and explore_eq eq =
  assert_simple_rhs eq &&
  match eq.rhs with
    | ExpPattern(_) -> false
    | Fby(_, exp) -> expect_exp exp
    | NodeCall(_, expl) -> expl |> List.fold_left (fun acc exp -> acc && expect_exp exp) true
    | _ -> expect_cexp eq.rhs


and explore_node node =
  node.eql
    |> List.fold_left (fun acc eq -> acc && explore_eq eq) true

let rec is_normal ast =
  ast.node_list
    |> List.fold_left (fun acc elt -> acc && explore_node elt) true

let normal_check ast =
  match is_normal ast with
    | true -> ast
    | false -> raise Ill_Constructed_Ast

let remove_if_all cmp l =
  let rec remove_rec cmp l newl =
    match l with
      | [] -> newl
      | x::xs ->
        match cmp x with
          | true -> remove_rec cmp xs newl
          | false -> remove_rec cmp xs (x::newl)
  in
  remove_rec cmp l []


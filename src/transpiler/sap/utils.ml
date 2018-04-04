open Sap_ast
open Shared.Exceptions
open Print_sap

let map = BatList.map
let flatten = BatList.flatten

let rec assert_flat_lhs lhsl =
  let is_flat = (function Id(_) -> true | _ -> false) in
  lhsl |> List.fold_left (fun acc elt -> acc && is_flat elt) true

and assert_simple_rhs eq =
  match eq.lhs with
    | Pattern(lhsl) ->
      (match eq.rhs with
        | NodeCall(_,_) -> lhsl |> assert_flat_lhs
        | Variable(id) -> true (* FIXME: Make sure that id belongs to a NodeCall *)
        | _ -> false)
    | _ -> true

and expect_cexp exp =
  match exp with
    | Merge(id, fll) -> fll |> List.fold_left (fun acc flw -> acc && expect_cexp flw.exp) true
    | _ -> expect_exp exp

and expect_exp exp =
  match exp with
    | When(exp, _) -> expect_exp exp
    | Op(_, expl) -> expl |> List.fold_left (fun acc exp -> acc && expect_exp exp) true
    | Variable(_) -> true
    | Value(_) -> true
    | Plus(lhs, rhs) -> expect_exp lhs && expect_exp rhs
    | Minus(lhs, rhs) -> expect_exp lhs && expect_exp rhs
    | Times(lhs, rhs) -> expect_exp lhs && expect_exp rhs
    | Div(lhs, rhs) -> expect_exp lhs && expect_exp rhs
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

let str_from_list f l =
  let f = (fun str elt -> str ^ ", " ^ (f elt)) in
  l |> List.fold_left f "List:"

(* First and only *)
let fily ?print:(print=BatPervasives.dump) l =
  match List.length l with
    | 1 -> List.hd l
    | _ -> raise (Failure ("Not monome list: " ^ (l |> str_from_list print)))

let rec get_ids_from_lhs = function
  | Id(id) -> [id]
  | Pattern(lhsl) -> lhsl |> map (get_ids_from_lhs) |> flatten

let rec get_ids_eql eql =
  eql |> map (fun eq -> eq.lhs) |> map get_ids_from_lhs |> flatten

let rec get_fbys fbyl eql =
  match eql with
    | [] -> fbyl
    | eq::xs ->
      let fbyl = match eq.rhs with
        | Fby(_,_) -> get_ids_from_lhs eq.lhs |> (@) fbyl 
        | _ -> fbyl in
      get_fbys fbyl xs

let times_list l i =
  let rec f newl l i =
    match i with
      | 0 -> newl
      | _ -> f (l::newl) l (i-1) in
  f [[]] l i
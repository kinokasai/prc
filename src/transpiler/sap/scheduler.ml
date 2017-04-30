open BatList
open Graph
open Sap_ast
open Print_sap
open Shared.Exceptions
open Shared.Colors
open Utils

(* Building the hashmap *)

let rec get_ids_from_lhs = function
  | Id(id) -> [id]
  | Pattern(lhsl) -> lhsl |> map (get_ids_from_lhs) |> flatten

let rec insert_lhs map eq = function
  | Id(id) -> Hashtbl.add map id eq
  | Pattern(lhsl) -> lhsl |> List.iter (insert_lhs map eq)

let insert_eq map eq =
  (*match eq.rhs with
    | Fby(_, _) -> ()
    | _ -> insert_lhs map eq eq.lhs*)
  insert_lhs map eq eq.lhs

let make_hashmap eql =
  let len = length eql in
  let map = Hashtbl.create len in
  eql |> iter (insert_eq map);
  map

(* Debug function *)
let print_hashmap map =
  let f = (fun x y -> print_endline (x ^ " -> " ^ print_eq y)) in
  Hashtbl.iter f map

(* Debug function *)
let print_ids ids =
  print_endline "ids {";
  ids |> iter print_endline;
  print_endline "}"

let rec get_fbys fbyl eql =
  match eql with
    | [] -> fbyl
    | eq::xs ->
      let fbyl = match eq.rhs with
        | Fby(_,_) -> get_ids_from_lhs eq.lhs |> (@) fbyl 
        | _ -> fbyl in
      get_fbys fbyl xs

let get_ids map eql =
  let f = (fun id _ acc -> id::acc) in
  (*let fbys = get_fbys [] eql in
  let pred = (fun id -> mem id fbys) in*)
  Hashtbl.fold f map []  (* |> remove_if_all pred*)

(* Creating the graph *)

module Node = struct
  type t = string
  let compare = Pervasives.compare
  let hash = Hashtbl.hash
  let equal = (=)
  let default = ""
end

module Edge = struct
  type t = string
  let compare = Pervasives.compare
  let equal = (=)
  let default = ""
end
module G = Graph.Persistent.Digraph.Concrete(Node)

module Dot = Graph.Graphviz.Dot(struct
   include G (* use the graph module from above *)
   let edge_attributes _ = []
   let default_edge_attributes _ = []
   let get_subgraph _ = None
   let vertex_attributes _ = []
   let vertex_name v = v
   let default_vertex_attributes _ = []
  let graph_attributes _ = []
end)

module Dfs = Traverse.Dfs(G)

let add_edge_if_dif g v1 v2 =
  match v1 with
  | x when String.equal v1 v2 -> g
  | _ -> G.add_edge g v1 v2

let rev_edge g vert =
  let predl = G.pred g vert in
  let edgel = G.pred_e g vert in
  let rm_edge = (fun graph edge -> G.remove_edge_e graph edge) in
  let add_edge = (fun graph v -> add_edge_if_dif graph vert v) in
  let g = edgel |> fold_left rm_edge g in
  predl |> fold_left add_edge g

let add_nodes map eql =
  let g = G.empty in
  let ids = get_ids map eql in
  let f = (fun acc id -> G.add_vertex acc id) in
  ids |> fold_left f g

let rec get_deps depl = function
  | Op(_, expl)
  | ExpPattern(expl)
  | NodeCall(_, expl) -> expl |> map (get_deps depl) |> flatten
  | Merge(_, flwl) -> flwl |> map (fun flw -> flw.exp) |> map (get_deps depl) |> flatten
  (* The constructor has only one argument *)
  | When(exp, constr) -> get_deps (hd constr.params::depl) exp
  | Variable(id) -> id::depl
  | Fby(_, exp) -> get_deps depl exp
  | _ -> depl

let add_edge g id map eql =
  let eq = Hashtbl.find map id in
  let deps = get_deps [] eq.rhs in
  let ids = get_ids map eql in
  let pred = (fun dep_id -> not (mem dep_id ids)) in
  let deps = deps |> remove_if_all pred in
  let f = (fun graph dep_id -> G.add_edge graph id dep_id) in
  deps |> fold_left f g

let make_graph map eql =
  let g = add_nodes map eql in
  let ids = get_ids map eql in
  let fbys = get_fbys [] eql in
  let f = (fun acc id -> add_edge acc id map eql) in
  let g = ids |> fold_left f g in
  let f = (fun g id -> rev_edge g id) in
  fbys |> fold_left f g

let vert_has_deps g vert =
  let succ = G.succ g vert in
  match length succ with
    | 0 -> false
    | _ -> true

let free_list freel g vert =
  match vert_has_deps g vert with
    | false -> freel := !freel@[vert]
    | true -> ()

let rec tmp freel g =
  match G.is_empty g with
    | true -> freel
    | false ->
      let () = G.iter_vertex (free_list freel g) g in
      let f = (fun graph id -> G.remove_vertex graph id) in
      let g = !freel |> fold_left f g in
      tmp freel g

let get_order g =
  let l = ref [] in
  tmp l g

let causality_check g =
  match Dfs.has_cycle g with
    | true -> raise (CyclicDependencyGraph "")
    | false -> ()

let schedule_node eql node_id =
  try 
    let map = make_hashmap eql in
    let g = make_graph map eql in
    let file = "build/" ^ node_id ^ ".dot" |> open_out_bin in
    Dot.output_graph file g;
    causality_check g;
    let order = !(get_order g) in
    let f = (fun acc id -> acc@Hashtbl.find_all map id) in
    let eql = order |> fold_left f [] |> unique in
    eql
  with
    | CyclicDependencyGraph(_) -> raise (CyclicDependencyGraph (node_id |> cwrap blue))


let schedule ast =
  let f = (fun node -> {interface = node.interface; 
                        id = node.id;
                        in_vdl = node.in_vdl;
                        out_vdl = node.out_vdl; 
                        step_vdl = node.step_vdl;
                        eql = schedule_node node.eql node.id;
                        deltas = node.deltas}) in
  let ndl = ast.node_list |> map f in
  {type_dec_list = ast.type_dec_list; node_list = ndl}
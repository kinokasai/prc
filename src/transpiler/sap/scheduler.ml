open BatList
open Graph
open Sap_ast
open Print_sap
open Shared.Exceptions
open Shared.Colors

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
  let fbys = get_fbys [] eql in
  let pred = (fun id -> mem id fbys) in
  Hashtbl.fold f map [] |> remove_if pred

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
   let vertex_attributes _ = [] (*[`Shape `Box]*)
   let vertex_name v = v
   let default_vertex_attributes _ = []
  let graph_attributes _ = []
end)

module Dfs = Traverse.Dfs(G)

(* Debug function *)
let print_ids ids =
  print_endline "ids {";
  ids |> iter print_endline;
  print_endline "}"

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
  | When(exp) -> get_deps depl exp
  | Variable(id) -> id::depl
  | _ -> depl

let add_edge g id map eql =
  let eq = Hashtbl.find map id in
  let deps = get_deps [] eq.rhs in
  let ids = get_ids map eql in
  let pred = (fun dep_id -> not (mem dep_id ids)) in
  let deps = deps |> remove_if pred in
  let f = (fun graph dep_id -> G.add_edge graph id dep_id) in
  deps |> fold_left f g

let make_graph map eql =
  let g = add_nodes map eql in
  let ids = get_ids map eql in
  let f = (fun acc id -> add_edge acc id map eql) in
  ids |> fold_left f g

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
    let file = open_out_bin "mygraph.dot" in
    Dot.output_graph file g;
    causality_check g;
    let order = !(get_order g)@get_fbys [] eql in
    let f = (fun id -> Hashtbl.find map id) in
    let eql = order |> List.map f |> unique in
    (*eql |> print_eql |> print_endline;*)
    eql
  with
    | CyclicDependencyGraph(_) -> raise (CyclicDependencyGraph (node_id |> cwrap blue))


let schedule ast =
  let f = (fun node -> {interface = node.interface; 
                        id = node.id;
                        in_vdl = node.in_vdl;
                        out_vdl = node.out_vdl; 
                        step_vdl = node.step_vdl;
                        eql = schedule_node node.eql node.id}) in
  let ndl = ast.node_list |> map f in
  {type_dec_list = ast.type_dec_list; node_list = ndl}
open BatList
open Core.Std
open Graph
open Print_sap
open Shared.Types
open Sap_ast
open Sap_exn

(* Typegen functions *)

let gen () =
  let count = ref (-1) in
  count := !count + 1;
  (!count + 97) |> char_of_int |> String.make 1 |> (^) "`"

module TypeMap = Map.Make(String)
module StreamMap = Map.Make(struct type t = kind let compare = compare
                                                 and sexp_of_t = (fun _ -> Sexp.Atom(""))
                                                 and t_of_sexp = (fun a -> Monotype("_ERROR_")) 
                            end)

type state = {
  stream_table: kind TypeMap.t;
  type_table: id list StreamMap.t;
  forwards: kind TypeMap.t;
}

let add_to_stream_map m ty id =
  match StreamMap.find m ty with
    | Some(l) -> StreamMap.add m ty (id::l)
    | None -> m

let print_typemap (map : kind TypeMap.t) =
  let f = (fun x y -> print_endline (x ^ " -> " ^ print_kind y)) in
  TypeMap.iteri map f

let id_from_lhs = function
  | Id(id) -> id
  | Pattern(lhsl) -> "undefined" (* FIXME *)

let state = ref {
                  stream_table = TypeMap.empty;
                  type_table = StreamMap.empty;
                  forwards = TypeMap.empty;
                }

(* Typing functions *)

let get_value_type = function
  | Int(_) -> Monotype("int")
  | Float(_) -> Monotype("float")
  | Constr(_) -> Monotype("_Constr_")

let rec get_type = function
  | Value(vl) -> get_value_type vl
  | Variable(id) ->
       (let ty = TypeMap.find !state.stream_table id in
       match ty with
        | Some(ty) -> ty
        | None -> let new_ty = Monotype(gen()) in
          state := {!state with forwards = TypeMap.add !state.forwards id new_ty};
          state := {!state with stream_table = TypeMap.add !state.stream_table id new_ty};
          state := {!state with type_table = add_to_stream_map (!state.type_table) new_ty id};
          (* state := { !state with unknown = TypeMap.add !state.unknown id new_ty}; *)
          new_ty)

  | Plus(lhs, rhs)
  | Minus(lhs, rhs)
  | Times(lhs, rhs)
  | Div(lhs, rhs) ->
      let lhs_ty = check_types [Monotype("int"); Monotype("float")] lhs in
      check_type lhs_ty rhs
  | _ -> Monotype("_undefined_")


and check_types typelist exp =
  let exp_ty = get_type exp in
  let to_bool = (fun ty -> exp_ty = ty) in
  let fold = (fun acc b -> acc || b) in
  let checked = typelist |> map to_bool |> fold_left fold false in
  match checked with
    | true -> exp_ty
    | false -> raise (TypeError (exp, typelist, exp_ty))

and check_type ty exp =
  check_types [ty] exp

let type_eq eq =
  let kind = get_type eq.rhs in
  let id = id_from_lhs eq.lhs in
  let stream_table = TypeMap.add !state.stream_table id kind  in
  state := {!state with stream_table = stream_table;};
  state := {!state with type_table = add_to_stream_map !state.type_table kind id};
  { eq with kind = kind;}

let type_node node =
  let eql = node.eql |> map type_eq in
  { node with eql = eql;}

let do_type ast =
  {ast with node_list = ast.node_list |> map type_node}

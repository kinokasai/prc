open Shared.Types

type value =
  | Int of string
  | Float of string
  | Constr of constr

type exp =
  | ExpPattern of exp list
  | Fby of value * exp
  | Merge of id * flow list
  | NodeCall of id * exp list
  | Op of id * exp list
  | Value of value
  | Variable of id
  | When of exp * constr

  | Plus of exp * exp
  | Minus of exp * exp
  | Div of exp * exp
  | Times of exp * exp

and flow =
  { 
    constr: id;
    exp : exp;
  }

type clock =
  {
    on_clk : clock option;
    constr_id : id option;
    b_id : id option;
  }

type lhs =
  Id of id
  | Pattern of lhs list

type kind = 
  | Monotype of id
  | Pluritype of kind list

type equation =
  { 
    lhs: lhs;
    rhs: exp;
    clk: clock;
    kind: kind;
  }

type node =
  {
    interface : bool;
    id : id;
    in_vdl : var_dec list;
    out_vdl : var_dec list;
    step_vdl : var_dec list;
    eql : equation list;
    deltas: delta list option;
  }

type ast =
  {
    type_dec_list : type_dec list;
    node_list: node list;
  }

(* Used for transpiling to SOL *)
type memory =
  {
    var_dec : var_dec;
    value : value;
  }
open Shared.Types

type value =
  | Litteral of string
  | Constr of constr

type exp =
  | Op of id * exp list
  | Fby of value * exp
  | ExpPattern of exp list
  | Merge of id * flow list
  | NodeCall of id * exp list
  | Value of value
  | Variable of id
  | When of exp

and flow =
  { 
    constr: constr;
    exp : exp;
  }

type lhs =
  Id of id
  | Pattern of lhs list

type equation =
  { 
    lhs: lhs;
    rhs: exp;
  }

type node =
  {
    interface : bool;
    id : id;
    in_vdl : var_dec list;
    out_vdl : var_dec list;
    step_vdl : var_dec list;
    eql : equation list;
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
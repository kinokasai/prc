open Shared.Types

type value =
  | Litteral of string
  | Constr of constr

type exp =
  | Value of value
  | Variable of id (* You won't know if it's state *)
  | Op of id * exp list
  | When of exp

type cexp =
  | Exp of exp
  | Merge of id * flow list

and flow =
  {
    constr : constr;
    cexp : cexp;
  }

type rhs =
  | CExp of cexp
  | Fby of value * exp
  | NodeCall of id * exp list

type equation = 
  {
    lhs: id list;
    rhs: rhs;
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
    node_list : node list;
  }

type memory =
  {
    var_dec : var_dec;
    value : value;
  }
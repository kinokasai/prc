open Shared.Types

type constant =
  | Litteral of string
  | Constr of constr

type value =
  | Const of constant
  | Variable of id (* You won't know if it's state *)
  | Op of id * value list

type exp =
  | Value of value
  | Fby of constant * value
  | When of constr * value

type equation = 
  {
    lhs: id;
    rhs: exp;
  }

type node =
  {
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
    value : constant;
  }
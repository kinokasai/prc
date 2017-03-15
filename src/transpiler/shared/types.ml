type id = string

(* x : int *)
type var_dec = 
  {
    var_id: id;
    type_id: id;
  }

(* Id(x : int, y: int) *)
type ty =
  {
    id: id;
    vdl: var_dec list;
  }

(* type id = TyFirst(x : int) | TyEmpty *)
type type_dec =
  {
    id: id;
    type_list: ty list;
  }

(* TyFirst(x) *)
type constr =
  {
    id : id;
    params: id list;
  }
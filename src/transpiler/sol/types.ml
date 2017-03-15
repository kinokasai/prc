open Shared.Types

type opcode =
  | Plus | Minus

type value =
    | Constr of id
    | Litteral of string
    | Op of id * value list
    | State of id
    | Step of id * value list
    | Variable of id

type branch = Branch of constr * exp list

and exp =
  | Case of id * branch list
  | Reset of id (* o.reset() *)
  | Skip (* skip *)
  | StateAssign of id * value (* state(x) = 3*)
  | VarAssign of id list * value (* x = 3 *)
;;


type mach_dec = 
  {
    mach_id : id;
    type_id : id;
  }

type step_dec =
    {
        avd : var_dec list;
        rvd : var_dec list;
        vd : var_dec list;
        sexp : exp list;
    }

type machine =
    {
        id : id;
        memory : var_dec list;
        instances : mach_dec list;
        interface : id option;
        reset : exp list;
        step : step_dec;
    }

type sol_ast =
    {
        tdl : type_dec list;
        mdl : machine list;
    }

let wrap s = "(" ^ s ^ ")";;
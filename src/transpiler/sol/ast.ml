open Shared.Types

type value =
  | Constr of id
  | Litteral of string

type exp =
  | Value of value
  | Op of id * exp list
  | State of id
  | Step of id * exp list
  | Variable of id

  | Plus of exp * exp
  | Minus of exp * exp
  | Div of exp * exp
  | Times of exp * exp

type branch = Branch of id * inst list

and inst =
  | Case of id * branch list
  | Reset of id (* o.reset() *)
  | Skip (* skip *)
  | StateAssign of id * exp (* state(x) = 3*)
  | VarAssign of id list * exp (* x = 3 *)
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
        instl : inst list;
    }

type machine =
    {
        id : id;
        memory : var_dec list;
        instances : mach_dec list;
        interface : id option;
        reset : inst list;
        step : step_dec;
        deltas : delta list option;
    }

type sol_ast =
    {
        tdl : type_dec list;
        mdl : machine list;
    }

let wrap s = "(" ^ s ^ ")";;
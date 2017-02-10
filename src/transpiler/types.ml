type opcode =
  | Plus | Minus

type type_dec = TypeDec of string * string list

type id = string

type const =
    | Constructor of bool

type value =
    | Variable of id
    | Constant of const
    | State of id
    | Immediate of int

type exp =
  | VarAssign of id * value (* x := 3 *)
  | StateAssign of id * value
  | Skip
  | Reset of id
  | Step of id list * id * value list
;;


type var_dec = VarDec of id * id
type mach_dec = MachDec of id * id
(* XXX: use a record for [step_dec] *)
type step_dec = StepDec of var_dec list * var_dec list * var_dec list * exp list
type machine =
    {
        id : id;
        memory : var_dec list;
        instances : mach_dec list;
        reset : exp list;
        step : step_dec;
    }

type ast =
    {
        tdl : type_dec list;
        mdl : machine list;
    }
let wrap s = "(" ^ s ^ ")";;

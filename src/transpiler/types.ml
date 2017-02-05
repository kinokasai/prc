type opcode =
  | Plus | Minus

(*type exp =*)
  (*| Const of int*)
  (*| Binop of opcode * exp * exp*)

type id = string

type const =
    | Constructor of bool

type value =
    | Variable of id
    | Constant of const
    | State of id
    | Immediate of int

type exp =
  | VarAssign of id * value
  | StateAssign of id * value
  | SeqExp of exp list
  | Skip
  | Reset of id
  | Step of id list * id * value list
;;


type var_dec = VarDec of id * id
type mach_dec = MachDec of id * id
type step_dec = StepDec of var_dec list * var_dec list * exp
type machine =
    {
        id : id;
        memory : var_dec list;
        instances : mach_dec list;
        reset : exp;
        step : step_dec;
    }


let wrap s = "(" ^ s ^ ")";;

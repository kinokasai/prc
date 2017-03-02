type opcode =
  | Plus | Minus

type type_dec = TypeDec of string * string list

type id = string

type constr = Constr of id

type value =
    | Constr of id
    | Immediate of int
    | Op of id * value list
    | State of id
    | Variable of id

type branch = Branch of id * exp list

and exp =
  | Case of id * branch list
  | Reset of id (* o.reset() *)
  | Skip (* skip *)
  | StateAssign of id * value (* state(x) = 3*)
  | Step of id list * id * value list (* a = o.step(x : int)*)
  | VarAssign of id * value (* x = 3 *)
;;


type var_dec = VarDec of id * id
type mach_dec = MachDec of id * id
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
        reset : exp list;
        step : step_dec;
    }

type ast =
    {
        tdl : type_dec list;
        mdl : machine list;
    }
let wrap s = "(" ^ s ^ ")";;

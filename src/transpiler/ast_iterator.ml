open Types

type iterator = {
  ast: iterator -> ast -> unit;
  branch: iterator -> branch -> unit;
  exp: iterator -> exp -> unit;
  id: iterator -> id -> unit;
  immediate: iterator -> int -> unit;
  machine: iterator -> machine -> unit;
  mach_dec: iterator -> mach_dec -> unit;
  step_dec: iterator -> step_dec -> unit;
  type_dec: iterator -> type_dec -> unit;
  value: iterator -> value -> unit;
  var_dec: iterator -> var_dec -> unit;
}

module L = struct
  (* Value expressions *)
  let iter_exp sub = function
    | Case(_, bl) -> List.iter (sub.branch sub) bl
    | Reset(id) -> sub.id sub id
    | Skip -> ()
    | StateAssign(id, value) -> sub.id sub id; sub.value sub value
    | Step(idl, id, vll) -> List.iter (sub.id sub) idl;
                            sub.id sub id;
                            List.iter (sub.value sub) vll
    | VarAssign(id, value) -> sub.id sub id; sub.value sub value

  let iter_val sub value = match value with
    | Variable(id) -> sub.id sub id
    | Constr(id) -> sub.id sub id
    | State(id) -> sub.id sub id
    | Immediate(i) -> ()
    | Op(id, vll) -> sub.id sub id; List.iter (sub.value sub) vll

end;;

let default_iter =
  {
    ast =
      (fun this {tdl = tdl; mdl = mdl;} ->
        List.iter (this.type_dec this) tdl;
        List.iter (this.machine this) mdl);
    branch =
      (fun this -> function
        | Branch(id, expl) -> List.iter (this.exp this) expl);
    exp = L.iter_exp;
    id = (fun this id -> ());
    immediate = (fun this i -> ());
    machine =
      (fun this {id = id; memory = vdl; instances = inst; reset = expl; step = step_dec} ->
        List.iter (this.var_dec this) vdl;
        List.iter (this.mach_dec this) inst;
        List.iter (this.exp this) expl;
        this.step_dec this step_dec);
    mach_dec =
      (fun this -> function
        | MachDec(_, _) -> ());
    step_dec = 
      (fun this {avd = avdl; rvd = rvdl; vd = vdl; sexp = expl} ->
        List.iter (this.var_dec this) avdl;
        List.iter (this.var_dec this) rvdl;
        List.iter (this.var_dec this) vdl;
        List.iter (this.exp this) expl);
    type_dec =
      (fun this -> function
        | TypeDec(_, _) -> ());
    value = L.iter_val;
    var_dec =
      (fun this -> function
        | VarDec(_, _) -> ());
  }

(* Example of how to use ast traversal *)
let print_id_iter =
  { default_iter with id = (fun this id -> print_string id; print_string "\n")}
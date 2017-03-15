open Types
open BatList

let nidl = ref [];;
let inst_list = ref [];;
let mem_list = ref [];;

let get_id_list eql =
  List.map (fun eq -> eq.lhs) eql

let list_node_ids ndl =
  List.iter (fun node -> nidl := node.id::(!nidl)) ndl

let get_undeclared_id_list dec_idl idl =
  List.filter (fun id -> not (mem id dec_idl)) idl

let id_of_vardec vd =
  Shared.Types.(vd.var_id)

let make_step avd rvd vd sexp =
  Sol.Types.{ avd; rvd; vd; sexp}

let make_undef_var_dec id = 
  Shared.Types.{var_id = id; type_id = "undefined"}

let make_undef_mach_dec id =
  Sol.Types.{mach_id = id; type_id = "undefined"}

let make_mem id vl =
  let var_dec = make_undef_var_dec id in
  {var_dec; value = vl}

let rec make_reset () =
  let inst_res = List.map (fun inst -> Sol.Types.(Reset(inst.mach_id))) !inst_list in
  let mem_reset = List.map
    (fun mem -> Sol.Types.StateAssign(mem.var_dec.var_id, sol_of_const mem.value)) !mem_list in
    inst_res@mem_reset

and sol_of_ast ast =
  let tdl = ast.type_dec_list in
  let ndl = ast.node_list in
  let _ = list_node_ids ndl in
  let mdl = sol_of_node_list ndl in
  Sol.Types.{tdl = tdl; mdl = mdl;}

and sol_of_const = function
    | Litteral(lit) -> Sol.Types.Litteral(lit)

and sol_of_eq_list eql =
  List.map sol_of_eq eql

and sol_of_eq eq =
  match eq.rhs with
    | Value(vl) -> Sol.Types.VarAssign([eq.lhs], sol_of_val vl)
    | Fby(pre, next) -> mem_list := make_mem eq.lhs pre ::!mem_list;
                        Sol.Types.StateAssign(eq.lhs, sol_of_val next)

and sol_of_node_list ndl =
  List.map sol_of_node ndl

and sol_of_node node =
  let _ = inst_list := [] in
  let _ = mem_list := [] in
  let id = node.id in
  let dec_idl = List.map id_of_vardec (node.in_vdl@node.out_vdl) in
  let undec_idl = get_undeclared_id_list dec_idl (get_id_list node.eql) in
  let step_var_decs = List.map make_undef_var_dec undec_idl in
  let step = make_step node.in_vdl node.out_vdl step_var_decs (sol_of_eq_list node.eql) in
  let reset = make_reset () in
  let memories = List.map (fun mem -> mem.var_dec) !mem_list in
  Sol.Types.{id; memory = memories; instances = !inst_list; interface = None; reset = reset; step}

and sol_of_val vl =
  match vl with
    | Const(const) -> sol_of_const const
    | Op(id, vll) when mem id !nidl -> inst_list := make_undef_mach_dec id::!inst_list;
                                       Sol.Types.Step(id, List.map sol_of_val vll)
    | Op(id, vll) when not (mem id (!nidl)) -> Sol.Types.Op(id, List.map sol_of_val vll)
    | Variable(id) -> Sol.Types.Variable(id)
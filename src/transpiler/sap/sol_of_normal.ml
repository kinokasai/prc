open Sap_ast
open BatList
open Shared.Exceptions
open Shared.Colors
open Utils

exception Expected_CExp of string

let nidl = ref [];;
let inst_list = ref [];;
let mem_list = ref [];;
let var_list = ref [];;

let get = BatOption.get

let rec get_ids_from_lhs = function
  | Id(id) -> [id]
  | Pattern(lhsl) -> lhsl |> map (get_ids_from_lhs) |> flatten

let get_id_list eql =
let rec get_ids_rec idl eql =
  match eql with
    | [] -> idl
    | eq::xs ->
      let idl = match eq.rhs with
        | Fby(_,_) -> get_ids_from_lhs eq.lhs |> (@) idl 
        | _ -> idl in
      get_ids_rec idl xs
  in
   get_ids_rec [] eql

let get_id_lhs = function
  | Id(id) -> id
  | _ -> raise Ill_Constructed_Ast

let get_id_from_var_dec vd =
  Shared.Types.(vd.var_id)

let make_undef_var_dec id = 
  Shared.Types.{var_id = id; type_id = "undefined"}

let make_mem id vl =
  let var_dec = make_undef_var_dec id in
  {var_dec; value = vl}

let add_to_mem eq =
  let idl = get_ids_from_lhs eq.lhs in
  match eq.rhs with
    (* idl should only have one element in case of Fby *)
    | Fby(pre, next) -> mem_list := make_mem (hd idl) pre ::!mem_list
    | _ -> var_list := !var_list@idl

let explore_mem_list eql =
  List.iter add_to_mem eql

let make_mach_dec id new_id =
  Sol.Ast.{mach_id = new_id; type_id = id}

let add_to_inst eq =
  match eq.rhs with
    | NodeCall(id, expl) ->
      let new_id = Normal_of_sap.new_id() in
      inst_list := (make_mach_dec id new_id)::!inst_list;
      {lhs = eq.lhs;
      rhs = NodeCall(new_id, expl);
      clk = eq.clk;
      kind = eq.kind}
    | _ -> eq

let explore_inst_list eql =
  List.map add_to_inst eql

let get_interface_type = function
  | [] -> raise (No_Interface_Type "No parameter to build interface on node ")
  | vd::[] -> Some Shared.Types.(vd.type_id)
  | _::_ -> raise (Too_Many_Parameters "Too many parameters to build interface on node ")

let list_node_ids ndl =
  List.iter (fun node -> nidl := node.id::(!nidl)) ndl

let mem_id id mem_list =
  let idl = List.map (fun mem -> Shared.Types.(mem.var_dec.var_id)) mem_list in
  mem id idl

let get_undeclared_id_list dec_idl idl =
  let tmp = List.filter (fun id -> not (mem id dec_idl) && not (mem_id id !mem_list)) idl in
    unique tmp

let change_mem id =
  match mem_id id !mem_list with
    | true -> "state(" ^ id ^ ")"
    | false -> id

let id_of_vardec vd =
  Shared.Types.(vd.var_id)

let rec ctrl_wrap inst clk =
  match clk.b_id with
    | None -> inst
    | Some _ ->
      let branch = Sol.Ast.Branch(get clk.constr_id, [inst]) in
      let inst = Sol.Ast.Case(get clk.b_id, [branch]) in
      match clk.on_clk with
        | None -> inst
        | Some clk -> ctrl_wrap inst clk

let make_step avd rvd vd instl =
  Sol.Ast.{ avd; rvd; vd; instl}

let rec make_id_list = function
  | Id(id) -> [id]
  | Pattern(lhsl) -> lhsl |> List.map make_id_list |> List.flatten

let rec make_reset () =
  let inst_res = List.map (fun inst -> Sol.Ast.(Reset(inst.mach_id))) !inst_list in
  let mem_reset = List.map
    (fun mem -> Sol.Ast.StateAssign(Shared.Types.(mem.var_dec.var_id), sol_of_val mem.value)) !mem_list in
    inst_res@mem_reset

and sol_of_ast ast =
  let tdl = ast.type_dec_list in
  let ndl = ast.node_list in
  let _ = list_node_ids ndl in
  let mdl = sol_of_node_list ndl in
  Sol.Ast.{tdl = tdl; mdl = mdl;}

and sol_of_cexp var_id exp =
  match exp with
    | Merge(id, fll) -> Sol.Ast.Case(id, sol_of_flow_list var_id fll)
    | Fby(_, _)
    | NodeCall(_, _) -> Expected_CExp (Print_sap.print_exp exp |> cwrap blue |> quote) |> raise
    | _ ->  Expected_CExp (Print_sap.print_exp exp |> cwrap blue |> quote) |> raise

and sol_of_eq_list eql =
  List.map sol_of_eq eql

and sol_of_eq eq =
try
  let idl = make_id_list eq.lhs in

  let inst = match eq.rhs with
    (* This is kinda hackish *)
      | Fby(pre, next) -> Sol.Ast.StateAssign(fily idl, sol_of_exp next)
      | NodeCall(id, expl) -> Sol.Ast.VarAssign(idl, Sol.Ast.Step(id, sol_of_exp_list expl))
      | Merge(_, _) -> sol_of_cexp (fily idl) eq.rhs
      | _ -> Sol.Ast.VarAssign(idl, sol_of_exp eq.rhs)
  in
    ctrl_wrap inst eq.clk
with
  | Expected_CExp(exp) ->
    let str = Print_sap.print_eq eq |> cwrap blue |> quote |> (^) "Expected Control exp in eq: " in
    let str = str ^ "\ngot: \n" ^ exp in
    Expected str |> raise

and sol_of_exp_list expl =
  List.map sol_of_exp expl

and sol_of_exp exp =
  match exp with
    | Op(id, expl) when mem id !nidl -> raise (Failure ("Shouldn't use node call as op:" ^ id))
    | Op(id, expl) -> Sol.Ast.Op(id, List.map sol_of_exp expl)

    | Plus(lhs, rhs) -> Sol.Ast.Plus(sol_of_exp lhs, sol_of_exp rhs)
    | Minus(lhs, rhs) -> Sol.Ast.Minus(sol_of_exp lhs, sol_of_exp rhs)
    | Times(lhs, rhs) -> Sol.Ast.Times(sol_of_exp lhs, sol_of_exp rhs)
    | Div(lhs, rhs) -> Sol.Ast.Div(sol_of_exp lhs, sol_of_exp rhs)

    | Value(vl) -> sol_of_val vl
    | Variable(id) when mem_id id !mem_list -> Sol.Ast.State(id)
    | Variable(id) -> Sol.Ast.Variable(id)
    | When(exp, _) -> sol_of_exp exp
    | _ -> exp |> Print_sap.print_exp |> print_endline; raise Ill_Constructed_Ast

and sol_of_flow_list var_id fll =
  List.map (sol_of_flow var_id) fll

and sol_of_flow var_id flow =
  let exp = flow.exp in
  let tmp = match flow.exp with
    | Merge(_, _) -> sol_of_cexp var_id exp
    | _ -> Sol.Ast.VarAssign([var_id], sol_of_exp exp)
   in
  Sol.Ast.Branch(flow.constr, [tmp])

and sol_of_node_list ndl =
  List.map sol_of_node ndl

and sol_of_node node =
try
  let _ = inst_list := [] in
  let _ = mem_list := [] in
  let _ = var_list := [] in
  let _ = explore_mem_list node.eql in
  let eql = explore_inst_list node.eql in
  let interface = if node.interface then get_interface_type node.in_vdl else None in
  let id = node.id in
  let in_idl = node.in_vdl |> map get_id_from_var_dec in
  let f = (fun id -> not (mem id in_idl)) in
  let step_var_decs = !var_list |> filter f |> map make_undef_var_dec in
  let step = make_step node.in_vdl node.out_vdl step_var_decs (sol_of_eq_list eql) in
  let reset = make_reset () in
  let memory = List.map (fun mem -> mem.var_dec) !mem_list in
  let instances = !inst_list in
  let deltas = node.deltas in
  Sol.Ast.{id; memory; instances; interface; reset = reset; step; deltas}
with
  | No_Interface_Type(str) -> raise (No_Interface_Type ((node.id |> cwrap blue) ^ str |> error))
  | Too_Many_Parameters(str) -> raise (Too_Many_Parameters ((node.id |> cwrap blue) ^ str |> error))

and sol_of_val = function
    | Int(lit)
    | Float(lit) -> Sol.Ast.Value(Sol.Ast.Litteral(lit))
    | Constr(constr) -> Sol.Ast.Value(Sol.Ast.Constr(Shared.Types.(constr.id)))
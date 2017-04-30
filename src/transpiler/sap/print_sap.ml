open BatList
open Shared.Types
open Sap_ast
open Sol.Print

let concat = String.concat;;
let get = BatOption.get;;

let iendl, incendl, decendl, incindent, decindent =
	let count = ref 0 in
	(fun () -> "\n" ^ spaces !count),
	(fun () -> count := !count + 2; "\n" ^ spaces !count),
	(fun () -> count := !count - 2; "\n" ^ spaces !count),
	(fun () -> count := !count + 2),
	(fun () -> count := !count -2);;

let rec print_ast ast =
  let tdl = ast.type_dec_list
    |> List.map print_type_dec
    |> concat (iendl()) in
  let ndl = ast.node_list
    |> List.map print_node
    |> concat (iendl()) in
    tdl ^ iendl() ^ ndl

and print_clk clk =
  match clk.constr_id with
    | None -> "base"
    | _ ->
      let on_clk = match clk.on_clk with
       | None -> "base" 
       | _ -> get clk.on_clk |> print_clk in
       on_clk
          ^ " on "
          ^ get clk.constr_id
          ^ (get clk.b_id |> Sol.Ast.wrap)
            

and print_constr constr =
  constr.Shared.Types.id
    ^ " : "
    ^ (constr.params |> concat ", ")

and print_eql eql =
  incindent(); eql |> map print_eq |> concat (";" ^ iendl())

and print_eq eq =
  print_lhs eq.lhs
    ^ " = "
    ^ print_exp eq.rhs
    ^ " :: "
    ^ print_clk eq.clk

and print_exp = function
  | ExpPattern(expl) ->
        "("
      ^ (expl |> map print_exp |> concat ", ")
      ^ ")"
  | Fby(vl, exp) ->
        print_val vl
      ^ " fby "
      ^ print_exp exp
  | Merge(id, fll) ->
        "merge "
      ^ id
      ^ (fll |> map print_flow |> concat (iendl()))
  | NodeCall(id, expl) -> 
      "@" ^ id
    ^ "(" 
    ^ (expl |> map print_exp |> concat ", ")
    ^ ")"
  | Op(id, expl) ->
        id
      ^ "("
      ^ (expl |> map print_exp |> concat ", ")
      ^ ")"
  | Value(vl) -> print_val vl
  | Variable(id) -> id
  | When(exp, constr) ->
      print_exp exp
    ^ " when " ^ print_constr constr

and print_flow flw =
  "(" ^ flw.constr ^ " -> " ^ print_exp flw.exp ^ ")"

and print_interface = function
  | true -> "interface "
  | false -> ""

and print_lhs = function
  | Id(id) -> id
  | Pattern(lhsl) ->
    "(" 
      ^ (lhsl |> map print_lhs |> concat ", ")
      ^ ")"

and print_node node =
  let str =print_interface node.interface
    ^ ("node " ^ node.id ^ "(")
    ^ print_vardecs node.in_vdl
    ^ ") -> ("
    ^ print_vardecs node.out_vdl
    ^ ") with" ^ (iendl())
    ^ print_eql node.eql in
    decindent(); str

and print_ty ty =
  (ty.vdl
    |> List.map print_vardec
    |> concat ", "
    |> (^) (ty.id ^ "(")
    ) ^ ")"

and print_type_dec td =
  td.type_list
    |> map print_ty
    |> concat " | "
    |> (^) ("type " ^ td.id ^ " = ")

and print_val = function
  | Litteral(str) -> str
  | Constr(constr) -> constr.id

and print_vardecs vdl =
  vdl |> map print_vardec |> concat ", "

and print_vardec vd =
  vd.var_id ^ " : " ^ vd.type_id
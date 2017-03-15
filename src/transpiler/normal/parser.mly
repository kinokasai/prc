%{
  open Shared.Types
  open Types
%}

%token SEMICOLON COLON EQUALS COMMA DOT PIPE
%token LPAREN RPAREN LBRACE RBRACE
%token TYPE NODE RETURNS FBY WITH WHEN MERGE
%token EOF
%token <string> LITTERAL CONSTR
%token <string> ID

%start <Types.ast> init
%%

init:
  | tdl = type_dec_list nl = node_list EOF {{type_dec_list = tdl; node_list = nl}}

const:
  | lit = LITTERAL { Litteral(lit) }

exp:
  | value = value { Value(value) }
  | pre = const FBY next = value { Fby(pre, next)}

eq_list:
  | eql = list(eq = eq { eq }) { eql }

eq:
  | lhs = ID EQUALS rhs = exp {{lhs; rhs}}

node_list:
  | nl = list(n = node {n}) { nl }

node:
  | NODE id = ID LPAREN in_vdl = var_decs RPAREN RETURNS LPAREN out_vdl = var_decs RPAREN WITH
    eql = eq_list { {id; in_vdl; out_vdl; step_vdl = []; eql} }

type_dec_list:
    | tdl = list(type_dec) { tdl }

type_dec:
    | TYPE id = ID EQUALS type_list = separated_list(PIPE, ty) { {id; type_list} }

ty:
    | id = CONSTR LPAREN vdl = var_decs RPAREN { {id; vdl} }
    | id = CONSTR { {id; vdl = []} }

value_list:
  | vll = separated_list(COMMA, value) { vll }

value:
  | const = const { Const(const) }
  | id = ID LPAREN vll = value_list RPAREN {Op(id, vll)}
  | id = ID { Variable(id)}

var_decs:
  | vdl = separated_list(COMMA, var_dec) { vdl }

var_dec:
  | var_id = ID COLON type_id = ID { {var_id; type_id} }

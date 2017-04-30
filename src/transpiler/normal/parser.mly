%{
  open Shared.Types
  open Nm_ast
%}

%token SEMICOLON COLON EQUALS COMMA DOT PIPE UNDERSCORE COMMENT
%token LPAREN RPAREN LBRACE RBRACE
%token TYPE NODE RETURNS FBY WITH WHEN MERGE EVERY INTERFACE
%token EOF
%token <string> LITTERAL CONSTR
%token <string> ID

%start <Nm_ast.ast> init
%%

init:
  | tdl = type_dec_list nl = node_list EOF {{type_dec_list = tdl; node_list = nl}}

rhs:
  | cexp = cexp { CExp(cexp) }
  | pre = value FBY next = exp { Fby(pre, next)}
  | id = ID LPAREN expl = exp_list RPAREN EVERY UNDERSCORE { NodeCall(id, expl)}

cexp:
  | exp = exp { Exp(exp) }
  | MERGE id = ID fl = flow_list { Merge(id, fl)}

constr:
    | id = CONSTR LPAREN idl = separated_list(COMMA, ID) RPAREN {{id; params=idl}}
    | id = CONSTR {{id; params=[]}}

eq_list:
  | eql = separated_list(SEMICOLON, eq = eq { eq }) { eql }

eq:
  | lhs = ID EQUALS rhs = rhs { {lhs = [lhs]; rhs} }
  | LPAREN lhs = separated_list(COMMA, ID) RPAREN EQUALS rhs = rhs {{lhs; rhs}}

exp_list:
  | expl = separated_list(COMMA, exp = exp { exp }) { expl }

exp:
  | id = ID LPAREN expl = exp_list RPAREN {Op(id, expl)}
  | id = ID { Variable(id)}
  | vl = value { Value(vl) }
  | exp = exp WHEN constr { When(exp) }

flow_list:
  | fll = list(fl = flow { fl }) { fll }

flow:
  | LPAREN constr = constr RETURNS cexp = cexp RPAREN { {constr; cexp} }

node_list:
  | nl = list(n = node {n}) { nl }

node:
  | interface = boption(INTERFACE) NODE id = ID LPAREN in_vdl = var_decs RPAREN 
    RETURNS LPAREN out_vdl = var_decs RPAREN WITH
    eql = eq_list { {interface; id; in_vdl; out_vdl; step_vdl = []; eql} }

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
  | constr = constr {Constr(constr)}
  | lit = LITTERAL { Litteral(lit) }

var_decs:
  | vdl = separated_list(COMMA, var_dec) { vdl }

var_dec:
  | var_id = ID COLON type_id = ID { {var_id; type_id} }

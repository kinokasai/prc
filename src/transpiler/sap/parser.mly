%{
  open Shared.Types
  open Sap_ast
%}

%token SEMICOLON COLON EQUALS COMMA PIPE
%token LPAREN RPAREN
%token TYPE NODE RETURNS FBY WITH WHEN MERGE INTERFACE ON MATCH END AT
%token EOF
%token PLUS MINUS TIMES DIV
%token <string> LITTERAL CONSTR INT
%token <string> ID

%start <Sap_ast.ast> init
%%

init:
  | tdl = type_dec_list nl = node_list EOF {{type_dec_list = tdl; node_list = nl}}

clock:
  | ck_id = ID {{on_clk = None; constr_id = None; b_id = None;}}
  | ck_id = ID ON constr_id = CONSTR LPAREN b_id = ID RPAREN {{on_clk = None; constr_id = Some constr_id; b_id = Some b_id;}}
  | LPAREN clk = clock RPAREN ON constr_id = CONSTR LPAREN b_id = ID RPAREN {{on_clk = Some clk; constr_id = Some constr_id; b_id = Some b_id}}

constr:
    | id = CONSTR LPAREN idl = separated_list(COMMA, ID) RPAREN {{id; params=idl}}
    | id = CONSTR {{id; params=[]}}

eq_list:
  | eql = separated_list(SEMICOLON, eq = eq { eq }) { eql }

eq:
  | lhs = lhs EQUALS rhs = exp {
      {
        lhs;
        rhs;
        clk = {
          on_clk = None;
          constr_id = None;
          b_id = None
          };
        kind = Monotype("undefined")
       } }
  | lhs = lhs EQUALS rhs = exp COLON COLON clk = clock { {lhs; rhs; clk; kind=Monotype("undefined")}}

exp_list:
  | expl = separated_list(COMMA, exp = exp { exp }) { expl }

exp:
  | pre = value FBY next = exp { Fby(pre, next)}
  | AT id = ID LPAREN expl = exp_list RPAREN{ NodeCall(id, expl)}
  | MERGE id = ID fl = flow_list { Merge(id, fl)}
  | id = ID LPAREN expl = exp_list RPAREN {Op(id, expl)}
  | LPAREN exp = exp RPAREN { exp }
  | LPAREN expl = separated_list(COMMA, exp) RPAREN { ExpPattern(expl)}
  | lhs = exp PLUS rhs = exp { Plus(lhs, rhs) }
  | lhs = exp MINUS rhs = exp { Minus(lhs, rhs) }
  | lhs = exp TIMES rhs = exp { Times(lhs, rhs) }
  | lhs = exp DIV rhs = exp { Div(lhs, rhs) }
  | id = ID { Variable(id)}
  | vl = value { Value(vl) }
  | exp = exp WHEN constr = constr { When(exp, constr) }
  | MATCH id = ID WITH fl = match_list END{ Merge(id, fl) }

match_list:
  | fll = list(mfl = match_flow { mfl }) {fll}

match_flow:
  | PIPE constr = CONSTR RETURNS exp = exp{ {constr; exp} }

flow_list:
  | fll = list(fl = flow { fl }) { fll }

flow:
  | LPAREN constr = CONSTR RETURNS exp = exp RPAREN { {constr; exp} }

lhs:
  | lhs = ID {Id(lhs)}
  | LPAREN lhsl = separated_list(COMMA, lhs) RPAREN { Pattern(lhsl) }

node_list:
  | nl = list(n = node {n}) { nl }

node:
  | interface = boption(INTERFACE) NODE id = ID LPAREN in_vdl = var_decs RPAREN 
    RETURNS LPAREN out_vdl = var_decs RPAREN WITH
    eql = eq_list { {interface; id; in_vdl; out_vdl; step_vdl = []; eql; deltas = None} }

type_dec_list:
    | tdl = list(type_dec) { tdl }

type_dec:
    | TYPE id = ID EQUALS type_list = separated_list(PIPE, ty) { {id; type_list} }

ty:
    | id = CONSTR LPAREN vdl = var_decs RPAREN { {id; vdl} }
    | id = CONSTR { {id; vdl = []} }

value:
  | constr = constr {Constr(constr)}
  | int = INT { Int(int)}
  | lit = LITTERAL { Float(lit) }

var_decs:
  | vdl = separated_list(COMMA, var_dec) { vdl }

var_dec:
  | var_id = ID COLON type_id = ID { {var_id; type_id} }
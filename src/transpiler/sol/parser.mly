%{
  open Types
  open Shared.Types
%}

%token SEMICOLON COLON EQUALS COMMA DOT PIPE
%token EOF
%token LPAREN RPAREN LBRACE RBRACE
%token MACHINE MEMORY RESET STATE STEP INSTANCES RETURNS VAR IN TYPE CASE INTERFACE
%token SKIP
%token <string> CONSTR
%token <string> ID LITTERAL

%start <Types.sol_ast> init
%%

init:
    | tdl = type_dec_list ml = machine_list EOF { {tdl = tdl; mdl = ml;}}

type_dec_list:
    | tdl = list(td = type_dec { td }) { tdl }

type_dec:
    | TYPE id = ID EQUALS type_list = separated_list(PIPE, ty) {{id; type_list}}

ty:
    | id = CONSTR LPAREN vdl = separated_list(COMMA, var_dec) RPAREN {{id; vdl}}
    | id = CONSTR {{id; vdl = []}}

machine_list:
    | ml = list(m = machine { m }) { ml }
    ;

machine:
    | MACHINE i = ident EQUALS
        interface = option(INTERFACE i = ID {i})
        MEMORY m = memory INSTANCES inst = instances
        RESET LPAREN RPAREN EQUALS e = seq_exp
        STEP se = step_dec
        { { id = i; memory = m; instances = inst; interface = interface; reset = e; step = se;} }

memory:
    | vd = var_decs { vd }

mach_dec:
    | mach_id = ID COLON type_id = ID { {mach_id; type_id} }

instances:
    | md = separated_list(COMMA, mach_dec) { md }

var_dec:
    | var_id = ID COLON type_id = ID { {var_id; type_id} }

var_decs:
    | vd = separated_list(COMMA, var_dec) { vd }

step_dec:
    | LPAREN avd = var_decs RPAREN RETURNS LPAREN rvd = var_decs RPAREN
        EQUALS VAR vd = var_decs IN e = seq_exp
        {{ avd = avd; rvd = rvd; vd = vd; sexp = e; }}

seq_exp:
    | seq_exp = separated_list(SEMICOLON, exp) { seq_exp }

exp:
    | SKIP { Skip }
    | id = ID EQUALS vl = value { VarAssign([id], vl) }
    | LPAREN idl = separated_list(COMMA, ID) RPAREN EQUALS vl = value { VarAssign(idl, vl) }
    | STATE LPAREN id = ID RPAREN EQUALS vl = value { StateAssign(id, vl) }
    | id = ID DOT RESET { Reset(id) }
    | CASE LPAREN id = ID RPAREN LBRACE bl = branch_list RBRACE
        { Case(id, bl) }
    ;

branch_list:
    | bl = separated_list(PIPE, branch) { bl }

branch:
    | constr = constr COLON e = seq_exp { Branch(constr, e) }

constr:
    | id = CONSTR LPAREN idl = separated_list(COMMA, ID) RPAREN {{id; params=idl}}
    | id = CONSTR {{id; params=[]}}

val_list:
    | vl = separated_list(COMMA, value) { vl }

value:
    | st = state { st }
    | id = ID DOT STEP LPAREN vll = val_list RPAREN { Step(id, vll) }
    | id = ID LPAREN vl = val_list RPAREN { Op(id, vl) }
    | lit = LITTERAL { Litteral(lit) }
    | id = ID { Variable(id) }
    | cid = CONSTR { Constr(cid) }

state:
    | STATE LPAREN id = ID RPAREN { State(id) }

%inline ident:
    | s = ID { s }

%{
  open Ast
  open Shared.Types
%}

%token SEMICOLON COLON EQUALS COMMA DOT PIPE
%token EOF
%token LPAREN RPAREN LBRACE RBRACE
%token MACHINE MEMORY RESET STATE STEP INSTANCES RETURNS VAR IN TYPE CASE INTERFACE
%token SKIP
%token <string> CONSTR
%token <string> ID LITTERAL STEP_ID

%start <Ast.sol_ast> init
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
        RESET LPAREN RPAREN EQUALS e = seq_inst
        STEP se = step_dec
        { { id = i; memory = m; instances = inst; interface = interface; reset = e; step = se;
            deltas = None} }

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
        EQUALS VAR vd = var_decs IN instl = seq_inst
        {{ avd = avd; rvd = rvd; vd = vd; instl; }}

seq_inst:
    | seq_inst = separated_list(SEMICOLON, inst) { seq_inst }

inst:
    | SKIP { Skip }
    | id = ID EQUALS vl = exp { VarAssign([id], vl) }
    | LPAREN idl = separated_list(COMMA, ID) RPAREN EQUALS vl = exp { VarAssign(idl, vl) }
    | STATE LPAREN id = ID RPAREN EQUALS vl = exp { StateAssign(id, vl) }
    | id = ID DOT RESET { Reset(id) }
    | CASE LPAREN id = ID RPAREN LBRACE bl = branch_list RBRACE
        { Case(id, bl) }
    ;

branch_list:
    | bl = separated_list(PIPE, branch) { bl }

branch:
    | constr = CONSTR COLON e = seq_inst{ Branch(constr, e) }

/* This is definitely weird. Maybe only allow only empty constructors as values? */
constr:
    | id = CONSTR LPAREN idl = separated_list(COMMA, ID) RPAREN {{id; params=idl}}
    | id = CONSTR {{id; params=[]}}

exp_list:
    | vl = separated_list(COMMA, exp) { vl }

exp:
    | st = state { st }
    | id = STEP_ID LPAREN expl = exp_list RPAREN { Step(id, expl) }
    | id = ID LPAREN expl = exp_list RPAREN { Op(id, expl) }
    | id = ID { Variable(id) }
    | vl = value {Value(vl)}

state:
    | STATE LPAREN id = ID RPAREN { State(id) }

value:
    | cid = CONSTR { Constr(cid)}
    | lit = LITTERAL { Litteral(lit)}

%inline ident:
    | s = ID { s }
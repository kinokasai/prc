%{
  open Types
%}

%token SEMICOLON COLON EQUALS COMMA DOT PIPE
%token EOF
%token LPAREN RPAREN LBRACE RBRACE
%token MACHINE MEMORY RESET STATE STEP INSTANCES RETURNS VAR IN TYPE CASE INTERFACE
%token SKIP
%token <string> CONSTR
%token <string> ID

%token <int> INT
%token <float> FLOAT

%start <Types.ast> init
%%

init:
    | tdl = type_dec_list ml = machine_list EOF { {tdl = tdl; mdl = ml;}}

type_dec_list:
    | tdl = list(td = type_dec { td }) { tdl }

type_dec:
    | TYPE id = ID EQUALS cl = separated_list(PIPE, ty) {TypeDec(id, cl)}

ty:
    | id = CONSTR LPAREN vd = separated_list(COMMA, var_dec) RPAREN {Ty(id, vd)}
    | id = CONSTR {Ty(id, [])}

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
    | id = ID COLON mid = ID { MachDec(id, mid) }

instances:
    | md = separated_list(COMMA, mach_dec) { md }

var_dec:
    | id = ID COLON ty = ID { VarDec(id, ty) }

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
    | id = ID EQUALS vl = value { VarAssign(id, vl) }
    | STATE LPAREN id = ID RPAREN EQUALS vl = value { StateAssign(id, vl) }
    | id = ID DOT RESET { Reset(id) }
    | LPAREN vd = separated_list(COMMA, ID) RPAREN
        EQUALS id = ID DOT STEP LPAREN vl = val_list RPAREN { Step(vd, id, vl) }
    | vid = ID EQUALS id = ID DOT STEP LPAREN vl = val_list RPAREN
        { Step([vid], id,vl) }
    | CASE LPAREN id = ID RPAREN LBRACE bl = branch_list RBRACE
        { Case(id, bl) }
    ;

branch_list:
    | bl = separated_list(PIPE, branch) { bl }

branch:
    | constr = constr COLON e = seq_exp { Branch(constr, e) }

constr:
    | id = CONSTR LPAREN idl = separated_list(COMMA, ID) RPAREN {{id; param=idl}}
    | id = CONSTR {{id; param=[]}}

val_list:
    | vl = separated_list(COMMA, value) { vl }

value:
    | st = state { st }
    | id = ID LPAREN vl = val_list RPAREN { Op(id, vl) }
    | i = INT { Immediate(i) }
    | f = FLOAT { Float(f) }
    | id = ID { Variable(id) }
    | cid = CONSTR { Constr(cid) }

state:
    | STATE LPAREN id = ID RPAREN { State(id) }

%inline ident:
    | s = ID { s }
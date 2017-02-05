%{
  open Types
%}

%token ASSIGN
%token SEMICOLON COLON EQUALS COMMA
%token EOF
%token LPAREN RPAREN
%token MACHINE MEMORY RESET STATE STEP INSTANCES RETURNS
%token SKIP
%token <string> ID

%token <int> INT

%start <Types.machine> init
%%

init:
    | m = machine EOF { m }

machine:
    | MACHINE i = ident EQUALS
        MEMORY m = memory INSTANCES inst = instances
        RESET LPAREN RPAREN EQUALS e = exp
        STEP se = step_dec
    (*MEMORY m = memory INSTANCES inst = instances*)
        { { id = i; memory = m; instances = inst; reset = e; step = se;} }

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
    | LPAREN vd = var_decs RPAREN RETURNS LPAREN rvd = var_decs RPAREN
        { StepDec(vd, rvd, Skip) }

exp:
    | SKIP { Skip }
    ;
    (*| e1 = exp op = binop e2 = exp { Binop (op, e1, e2) }*)

%inline ident:
    | s = ID { s }

(*binop:*)
  (*| PLUS { Plus }*)
  (*| MINUS { Minus }*)

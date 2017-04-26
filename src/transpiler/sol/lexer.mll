{
    open Parser

    exception SyntaxError of string
}

let digit = ['0'-'9']
let white_ = [' ' '\t' '\n']+
let num = digit+
let float = digit+ ('.'digit*)?
let simple_ident = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*
let ident = simple_ident('.'simple_ident)?
let step_id = simple_ident".step"
let type_const = ['A'-'Z']['a'-'z' 'A'-'Z']*

rule token = parse
    | white_ { token lexbuf }
    | ';' { SEMICOLON }
    | '(' { LPAREN }
    | ')' { RPAREN }
    | ':' { COLON }
    | ',' { COMMA }
    | '.' { DOT }
    | '|' { PIPE }
    | '{' { LBRACE }
    | '}' { RBRACE }
    | "machine" { MACHINE }
    | "memory" { MEMORY }
    | "instances" { INSTANCES }
    | "interface" { INTERFACE }
    | "reset" { RESET }
    | "step" { STEP }
    | "returns" { RETURNS }
    | "state" { STATE }
    | "skip" { SKIP }
    | "=" { EQUALS }
    | "var" { VAR }
    | "in" { IN }
    | "type" { TYPE }
    | "case" { CASE }
    | step_id as id { STEP_ID id}
    | ident as id { ID id }
    | type_const as tc { CONSTR tc }
    | num as i { LITTERAL i }
    | float as f { LITTERAL f }
    | eof { EOF }
    | _
        { raise (SyntaxError ("Syntax Error: " ^ Lexing.lexeme lexbuf)) }

{
    open Parser

    exception SyntaxError of string
}

let digit = ['0'-'9']
let white_ = [' ' '\t' '\n']+
let num = digit+
let ident = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*
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
    | "machine" { MACHINE }
    | "memory" { MEMORY }
    | "instances" { INSTANCES }
    | "reset" { RESET }
    | "step" { STEP }
    | "returns" { RETURNS }
    | "state" { STATE }
    | "skip" { SKIP }
    | "=" { EQUALS }
    | "var" { VAR }
    | "in" { IN }
    | "type" { TYPE }
    | ident as id { ID id }
    | type_const as tc { CONSTR tc }
    | num as i { INT (int_of_string i) }
    | eof { EOF }
    | _
        { raise (SyntaxError ("Syntax Error: " ^ Lexing.lexeme lexbuf)) }

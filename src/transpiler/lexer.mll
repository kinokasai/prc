{
    open Parser

    exception SyntaxError of string
}

let digit = ['0'-'9']
let white_ = [' ' '\t' '\n']+
let num = digit+
let ident = ['a'-'z' 'A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

rule token = parse
    | white_ { token lexbuf }
    | ';' { SEMICOLON }
    | '(' { LPAREN }
    | ')' { RPAREN }
    | ':' { COLON }
    | ',' { COMMA }
    | '.' { DOT }
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
    | ident as id { ID id }
    | num as i { INT (int_of_string i) }
    | eof { EOF }
    | _
        { raise (SyntaxError ("Syntax Error: " ^ Lexing.lexeme lexbuf)) }

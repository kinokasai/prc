{
    open Parser

    exception SyntaxError of string
}

let digit = ['0'-'9']
let white_ = [' ' '\t' '\n']+
let num = digit+
let ident = ['a'-'z' 'A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9']*

rule token = parse
    | white_ { token lexbuf }
    | ';' { SEMICOLON }
    | '(' { LPAREN }
    | ')' { RPAREN }
    | ':' { COLON }
    | ',' { COMMA }
    | "machine" { MACHINE }
    | "memory" { MEMORY }
    | "instances" { INSTANCES }
    | "reset" { RESET }
    | "step" { STEP }
    | "returns" { RETURNS }
    | ":=" { ASSIGN }
    | "state" { STATE }
    | "skip" { SKIP }
    | "=" { EQUALS }
    | ident as id { ID id }
    | eof { EOF }
    | _
        { raise (SyntaxError ("Syntax Error: " ^ Lexing.lexeme lexbuf)) }

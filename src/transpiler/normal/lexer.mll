{
  open Parser
  exception SyntaxError of string
}

let digit = ['0'-'9']
let white_ = [' ' '\t' '\n']+
let int = digit+
let float = digit+ ('.'digit*)?
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
    | '{' { LBRACE }
    | '}' { RBRACE }
    | '=' { EQUALS }
    | '_' { UNDERSCORE }
    | "type" { TYPE }
    | "node" { NODE }
    | "->" { RETURNS }
    | "with" { WITH }
    | "when" { WHEN }
    | "merge" { MERGE }
    | "fby" { FBY }
    | "every" { EVERY }
    | "interface" { INTERFACE }
    | type_const as constr { CONSTR constr }
    | float as num { LITTERAL num}
    | ident as id { ID id }
    | eof { EOF }
    | _
      { raise (SyntaxError ("Syntax Error: " ^ Lexing.lexeme lexbuf))}
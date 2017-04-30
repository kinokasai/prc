{
  open Parser
  exception SyntaxError of string
}

let digit = ['0'-'9']
let white_ = [' ' '\t' '\n']+
let int = digit+
let float = digit+ ('.'digit*)?
let simple_ident = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*
let ident = simple_ident('.'simple_ident)?
let type_const = ['A'-'Z']['a'-'z' 'A'-'Z']*
let comment = '#'([^ '\n' ]*)

rule token = parse
    | white_ { token lexbuf }
    | ';' { SEMICOLON }
    | '(' { LPAREN }
    | ')' { RPAREN }
    | ':' { COLON }
    | ',' { COMMA }
    | '|' { PIPE }
    | '=' { EQUALS }
    | '@' { AT }
    | "type" { TYPE }
    | "node" { NODE }
    | "->" { RETURNS }
    | "with" { WITH }
    | "when" { WHEN }
    | "merge" { MERGE }
    | "match" { MATCH }
    | "fby" { FBY }
    | "end" { END }
    | "interface" { INTERFACE }
    | "on" { ON }
    | comment { token lexbuf }
    | type_const as constr { CONSTR constr }
    | float as num { LITTERAL num}
    | ident as id { ID id }
    | eof { EOF }
    | _
      { raise (SyntaxError ("Syntax Error: " ^ Lexing.lexeme lexbuf))}
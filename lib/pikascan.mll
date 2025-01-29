{
	open Pikaparse
	open Pikaexceptions
}

(* Scanner specification *)
let identifier = "i" ("ka" ("pika")* ("pi" | ("ch" 'u'+)?))?
let variable_identifier = 'p' identifier
let function_identifier = 'P' identifier

let newline = ['\n' '\r'] | "\r\n"
let whitespace = [' ' '\t']

rule tokenize = parse
| variable_identifier as ident {
	VARIDENT(ident)
}
| function_identifier as ident {
	FUNIDENT(ident)
}
| ("Go, Pikachu!" | "Pikachu, I choose you!") {
	INTRO
}
| ("Well done, Pikachu!" | "Pikachu, return!") {
	OUTRO
}
| "PIK" ('A'+ as a) "..." {
	PIKA(String.length a)
}
| "...CH" ('U'+ as u) {
	CHU(String.length u)
}
| "PIKACHU"		{VARIDENT("PIKACHU")}
| "PIKA"		{FUNIDENT("PIKA")}
| "PI"			{PI}
| "KA"			{KA}
| "PIKACH"		{PIKACH}
| "PI..."		{PIDOTS}
| "...KA..."	{KADOTS}
| "PIKAPIKAPIKA..."	{PIKAPIKAPIKA}
| "!" {BANG}
| "?" {UNBANG}
| whitespace    {tokenize lexbuf}
| newline       {Lexing.new_line lexbuf; tokenize lexbuf}
| eof       {EOF}
| _ as c {raise (Lexing_error (Pikaloc.to_lexeme_position lexbuf, Printf.sprintf "Unrecognised character: \'%c\'" c))}
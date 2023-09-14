/*
* ChuPikaPi Parser specification
*/

%{
	open Pikast
	open Pikaloc
	(* Auxiliary definitions *)
	let (@>) node loc = {node = node; loc = to_code_position loc}
%}

/* Tokens declarations */
%token <string> VARIDENT
%token <string> FUNIDENT
%token <int> PIKA
%token <int> CHU
%token BANG
%token UNBANG
%token INTRO
%token OUTRO
%token PI
%token PIDOTS
%token KA
%token KADOTS
%token PIKAPIKAPIKA
%token PIKACH
%token EOF


//%right PIKA CHU
%left PIKACH
%left PI KA
%left BANG UNBANG


/* Starting symbol */

%start pikaprogram
%type <Pikast.pikaprogram> pikaprogram
%type <Pikast.func> pikafunction
%type <Pikast.stmt> block
%type <Pikast.stmt list> statement_list
%type <Pikast.stmt> statement
%type <Pikast.expr> expr

%%

/* Grammar specification */

pikaprogram:
	| INTRO list(pikafunction) OUTRO EOF {
		Program($2)
	}

pikafunction:
	| FUNIDENT list(preceded(UNBANG, VARIDENT)) BANG? block {
		Fun($1, $2, $3 |> Option.is_some, $4) @> $loc
	}

block:
	| PIKA statement_list CHU {
		Block($2) @> $loc
	}

statement_list:
	| list(statement) {$1}

statement:
	| block {$1}
	| expr {Expr($1) @> $loc}
	| PIDOTS expr statement_list KADOTS statement_list CHU {
		If($2, Block($3) @> $loc, Block($5) @> $loc) @> $loc
	}
	| PIKAPIKAPIKA expr statement_list CHU {
		While($2, Block($3) @> $loc) @> $loc
	}

expr:
	| lexpr	{$1}
	| rexpr	{$1}

lexpr:
	| VARIDENT {VarIdent($1) @> $loc}
	| FUNIDENT {FunIdent($1) @> $loc}

rexpr:
	| expr BANG lexpr {
		Assign($3, $1) @> $loc
	}
	| lexpr UNBANG expr		%prec UNBANG {
		Assign($1, $3) @> $loc
	}
	| expr binop expr {
		Binop($1, $2, $3) @> $loc
	}

%inline binop:
	| PI {Plus}
	| KA {Minus}
	| PIKACH {Lt}
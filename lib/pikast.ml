type 'a annotated_node = { node : 'a; loc : Pikaloc.code_pos [@opaque] }
[@@deriving show]

type identifier = string [@@deriving show]

type pikaprogram = Program of func list [@@deriving show]
and func = func_node annotated_node

and func_node = Fun of identifier * identifier list * bool * stmt
[@@deriving show]

and stmt = stmt_node annotated_node

and stmt_node =
  | Block of stmt list
  | Expr of expr
  | If of expr * stmt * stmt
  | While of expr * stmt
[@@deriving show]

and expr = expr_node annotated_node

and expr_node =
  | VarIdent of identifier
  | FunIdent of identifier
  | Assign of expr * expr
  | Binop of expr * binop * expr
[@@deriving show]

and binop = Plus | Minus | Lt [@@deriving show]

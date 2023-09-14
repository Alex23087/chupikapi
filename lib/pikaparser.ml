open Pikaexceptions

(* rename the arguments as you wish *)
let parse _scanner _lexbuf =
  try Pikaparse.pikaprogram _scanner _lexbuf with
  | Lexing_error _ as sle ->
      (* Printf.fprintf stderr "\n%s: Pikascan.Lexing_error %s\n"
         (Pikaloc.show_lexeme_pos pos)
         msg; *)
      raise sle
  | Syntax_error _ as spe ->
      (* Printf.fprintf stderr "\n%s: Syntax_error (%s)\n"
         (Pikaloc.show_lexeme_pos pos)
         msg; *)
      raise spe
  | Pikaparse.Error ->
      raise (Syntax_error (Pikaloc.to_lexeme_position _lexbuf, "Syntax error"))

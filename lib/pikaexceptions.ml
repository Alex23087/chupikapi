exception Lexing_error of Pikaloc.lexeme_pos * string
exception Semantic_error of Pikaloc.code_pos * string
exception Syntax_error of Pikaloc.lexeme_pos * string

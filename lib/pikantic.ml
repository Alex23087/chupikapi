open Pikaexceptions
open Pikast
open Pikatypes
open Symbol_table
open Utils

let declare_func sym_table funct =
  match ~@!funct with
  | Fun (name, params, return, _) ->
      if (sym_table |> local_lookup) name |> Option.is_some then
        Semantic_error
          (~@@funct, Printf.sprintf "Function \"%s\" declared twice" name)
        |> raise;
      (sym_table |> add_entry) (name, Pikafunc (params |> List.length, return))

let add_variable sym_table id =
  if (sym_table |> local_lookup) id |> Option.is_some |> not then
  (sym_table |> add_entry) (id, Pikaval)

let declare_variable sym_table var =
  match ~@!var with
  | VarIdent id -> add_variable sym_table id
  | _ -> failwith "Impossible"

let rec analyze_expr sym_table expr : pikatype =
  match ~@!expr with
  | VarIdent id | FunIdent id -> (
      match (sym_table |> lookup) id with
      | None ->
          Semantic_error
            (~@@expr, Printf.sprintf "Variable \"%s\" not declared" id)
          |> raise
      | Some t -> (
          match t with
          | Pikafunc (p, r) when p > 0 -> if r then Pikaval else Pikaunit
          | _ -> t))
  | Assign (lhs, rhs) -> (
      match ~@!lhs with
      | VarIdent _ ->
          if analyze_expr sym_table rhs = Pikaval then Pikaval
          else
            Semantic_error (~@@rhs, "Trying to pass a non-Pika value") |> raise
      | FunIdent id -> (
          match lookup sym_table id with
          | Some v -> (
              match v with
              | Pikafunc (params, return) ->
                  (* Printf.printf "Calling %s\n" id; *)
                  let paramn = ref params in
                  let rec analyze_funcall expr =
                    (* Printf.printf "Parameter %d: %s\n" (params - !paramn) (show_expr expr); *)
                    if !paramn = 1 then
                      if analyze_expr sym_table expr = Pikaval then
                        if return then Pikaval else Pikaunit
                      else
                        Semantic_error
                          (~@@expr, "Passing invalid value to function")
                        |> raise
                    else
                      match ~@!expr with
                      | Assign (lhs, rhs) -> (
                          match analyze_expr sym_table lhs with
                          | Pikaval ->
                              decr paramn;
                              analyze_funcall rhs
                          | _ ->
                              Semantic_error
                                (~@@rhs, "Passing invalid value to function")
                              |> raise)
                      | _ ->
                          Semantic_error
                            (~@@rhs, "Not enough parameters passed to function")
                          |> raise
                  in
                  analyze_funcall rhs
              | _ -> failwith "Impossible")
          | None ->
              Semantic_error
                ( ~@@lhs,
                  Printf.sprintf "Referencing undeclared function \"%s\"" id )
              |> raise)
      | _ ->
          Semantic_error
            (~@@lhs, "Trying to pass a value to an unassignable entity")
          |> raise)
  | Binop (lhs, _, rhs) ->
      analyze_expr sym_table lhs >. ();
      analyze_expr sym_table rhs >. ();
      Pikaval

let rec analyze_statement sym_table stmt =
  match ~@!stmt with
  | Block stmts -> stmts |> List.iter (analyze_statement sym_table)
  | Expr expr -> (
      match ~@!expr with
      | VarIdent _ -> declare_variable sym_table expr
      | _ -> analyze_expr sym_table expr >. ())
  | If (guard, thenstmt, elsestmt) ->
      analyze_expr sym_table guard >. ();
      analyze_statement sym_table thenstmt;
      analyze_statement sym_table elsestmt
  | While (guard, bodystmt) ->
      analyze_expr sym_table guard >. ();
      analyze_statement sym_table bodystmt

let analyze_function sym_table funct =
  match ~@!funct with
  | Fun (_, params, _, body) ->
      sym_table |> begin_block;
      params |> List.iter (sym_table |> add_variable);
      analyze_statement sym_table body;
      sym_table |> end_block

let analyze prog =
  match prog with
  | Program funcs ->
      let sym_table = create_table () in
      begin_block sym_table;

      (sym_table |> add_entry) ("PIKACHU", Pikaval);
      (sym_table |> add_entry) ("PIKA", Pikafunc (1, false));

      (* (sym_table |> add_entry) ("PIKA", Pikafunc (0, true)); *)
      funcs |> List.iter (sym_table |> declare_func);

      funcs |> List.iter (sym_table |> analyze_function);

      prog

open Llvm
open Pikast
open Pikaexceptions
open Utils
open Symbol_table

let ctx = global_context ()
let _module : llmodule option ref = ref None
let llmod () = !_module |> Option.get
let _sym_table : llvalue symbol_table option ref = ref None
let sym_table () = !_sym_table |> Option.get
let llpikaval = Llvm.i64_type ctx
let llpikaunit = Llvm.void_type ctx

let llpikafun (params, return) =
  Llvm.function_type
    (if return then llpikaval else llpikaunit)
    (Array.make (params |> List.length) llpikaval)

let counter = ref 0

let get_unique_name () =
  let i = !counter in
  incr counter >. i |> string_of_int

let pdefine_function (id, params, return) =
  if lookup (sym_table ()) id |> Option.is_some then
    Semantic_error
      (dummy_code_pos, Printf.sprintf "Double definition of function \"%s\"" id)
    |> raise;
  let f = Llvm.define_function id (llpikafun (params, return)) (llmod ()) in
  (sym_table () |> add_entry) (id, f)

let pdefine_var builder id =
  let loc = lookup (sym_table ()) id in
  match loc with
  | None ->
      let loc = Llvm.build_alloca llpikaval (get_unique_name ()) builder in
      (sym_table () |> add_entry) (id, loc);
      Llvm.build_store (const_int llpikaval 25) loc builder >. ();
      build_load loc (get_unique_name ()) builder
  | Some loc -> build_load loc (get_unique_name ()) builder

let rec build_statement builder lastval statement : llvalue =
  (* builder |> insertion_block |> block_parent |> global_parent |> string_of_llmodule |> Printf.printf "%s\n\n\n\n%!"; *)
  match ~@!statement with
  | Block stmts ->
      let last = ref lastval in
      sym_table () |> begin_block;
      stmts
      |> List.iter (fun stmt -> last := build_statement builder !last stmt);
      sym_table () |> end_block;
      !last
  | Expr expr -> (
      match ~@!expr with
      | VarIdent id -> pdefine_var builder id
      | _ -> build_expr builder expr)
  | If (guard, thenstmt, elsestmt) ->
      build_if builder (guard, thenstmt, elsestmt);
      lastval
  | While (guard, body) ->
      build_while builder (guard, body);
      lastval

and build_expr builder expr : llvalue =
  match ~@!expr with
  | VarIdent id | FunIdent id ->
      build_load
        (lookup (sym_table ()) id |> Option.get)
        (get_unique_name ()) builder
  | Assign (lhs, rhs) -> (
      match ~@!lhs with
      | VarIdent id ->
          let lval = lookup (sym_table ()) id |> Option.get in
          let rval = build_expr builder rhs in
          build_store rval lval builder >.
          rval
      | FunIdent id ->
          let v = lookup (sym_table ()) id |> Option.get in
          let paramn = Llvm.params v |> Array.length in
          let args = Array.make paramn (const_null llpikaval) in
          let param_counter = ref paramn in
          let rec build_funcall expr =
            if !param_counter = 1 then (
              let p = build_expr builder expr in
              (args |> Array.set) (paramn - !param_counter) p;
              build_call v args
                (if
                   v |> type_of |> element_type |> return_type |> classify_type
                   = TypeKind.Void
                 then ""
                 else get_unique_name ())
                builder)
            else
              match ~@!expr with
              | Assign (lhs, rhs) ->
                  let p = build_expr builder lhs in
                  (args |> Array.set) (paramn - !param_counter) p;
                  decr param_counter;
                  build_funcall rhs
              | _ -> failwith "Impossible"
          in
          build_funcall rhs
      | _ -> failwith "Impossible")
  | Binop (lhs, binop, rhs) -> (
      let lval = build_expr builder lhs in
      let rval = build_expr builder rhs in
      match binop with
      | Plus -> build_nsw_add lval rval (get_unique_name ()) builder
      | Minus -> build_nsw_sub lval rval (get_unique_name ()) builder
      | Lt ->
          let res =
            build_icmp Icmp.Slt lval rval (get_unique_name ()) builder
          in
          build_zext res llpikaval (get_unique_name ()) builder)

and build_if builder (guard, thenstmt, elsestmt) =
  let current_block = builder |> insertion_block in
  let current_function = current_block |> block_parent in

  let guard_block = append_block ctx (get_unique_name ()) current_function in
  let then_block = append_block ctx (get_unique_name ()) current_function in
  let else_block = append_block ctx (get_unique_name ()) current_function in
  let merge_block = append_block ctx (get_unique_name ()) current_function in

  let guard_builder = builder_at_end ctx guard_block in
  let then_builder = builder_at_end ctx then_block in
  let else_builder = builder_at_end ctx else_block in

  build_br guard_block builder >. ();
  let g = build_expr guard_builder guard in
  let c =
    build_icmp Icmp.Ne (const_int llpikaval 0) g (get_unique_name ()) guard_builder
  in
  build_cond_br c then_block else_block guard_builder >. ();

  build_statement then_builder (const_null llpikaunit) thenstmt >. ();
  build_br merge_block then_builder >. ();

  build_statement else_builder (const_null llpikaunit) elsestmt >. ();
  build_br merge_block else_builder >. ();

  position_at_end merge_block builder

and build_while builder (guard, body) =
  let current_block = builder |> insertion_block in
  let current_function = current_block |> block_parent in

  let guard_block = append_block ctx (get_unique_name ()) current_function in
  let body_block = append_block ctx (get_unique_name ()) current_function in
  let merge_block = append_block ctx (get_unique_name ()) current_function in

  let guard_builder = builder_at_end ctx guard_block in
  let body_builder = builder_at_end ctx body_block in

  build_br guard_block builder >. ();
  let g = build_expr guard_builder guard in
  let c =
    build_icmp Icmp.Ne (const_int llpikaval 0) g (get_unique_name ()) guard_builder
  in
  build_cond_br c body_block merge_block guard_builder >. ();

  build_statement body_builder (const_null llpikaunit) body >. ();
  build_br guard_block body_builder >. ();

  position_at_end merge_block builder

let build_function funct =
  match ~@!funct with
  | Fun (fname, params, return, body) ->
      let fvalue = fname |> lookup (sym_table ()) |> Option.get in
      let fbuilder = fvalue |> entry_block |> builder_at_end ctx in
      sym_table () |> begin_block;

      (* Build the parameter block *)
      params
      |> List.iteri (fun i id ->
             add_entry (sym_table ())
               ( id,
                 (* Promote parameters to local variables *)
                 let param_i = Llvm.param fvalue i in
                 let param_i_loc = Llvm.build_alloca llpikaval id fbuilder in
                 Llvm.build_store param_i param_i_loc fbuilder >. param_i_loc ));

      (* Build body block *)
      let lastval = build_statement fbuilder (const_null llpikaunit) body in
      (if return then build_ret lastval fbuilder
      else build_ret_void fbuilder) >. ();

      if
        (* Build terminator if the block does not have one *)
        fbuilder |> has_terminator |> not
      then
        if not return then Llvm.build_ret_void fbuilder >. ()
        else ((llpikaval |> Llvm.const_int) 25 |> Llvm.build_ret) fbuilder >. ();

      sym_table () |> end_block

let pokedex prog ~name =
  match prog with
  | Program funcs ->
      _module := Some (create_module ctx name);
      _sym_table := Some (create_table ());
      sym_table () |> begin_block;

      (sym_table () |> add_entry)
        ("PIKACHU", define_global "PIKACHU" (const_int llpikaval 1) (llmod ()));
      (sym_table () |> add_entry)
        ("PIKA", declare_function "PIKA" (llpikafun ([ 1 ], false)) (llmod ()))
      >. ();

      funcs
      |> List.iter
           (( ~@! )
           >> (fun f -> match f with Fun (a, b, c, _) -> (a, b, c))
           >> pdefine_function);

      funcs |> List.iter build_function;

      llmod ()

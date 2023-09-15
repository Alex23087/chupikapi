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

let pdefine_function (id, params, return) =
  if lookup (sym_table ()) id |> Option.is_some then
    Semantic_error
      (dummy_code_pos, Printf.sprintf "Double definition of function \"%s\"" id)
    |> raise;
  let f = Llvm.define_function id (llpikafun (params, return)) (llmod ()) in
  (sym_table () |> add_entry) (id, f)

let pokedex prog ~name =
  match prog with
  | Program funcs ->
      _module := Some (create_module ctx name);
      _sym_table := Some (create_table ());

      funcs
      |> List.iter
           (( ~@! )
           >> (fun f -> match f with Fun (a, b, c, _) -> (a, b, c))
           >> pdefine_function);

      llmod ()

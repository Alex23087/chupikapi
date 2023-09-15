open Utils

type identifier = string
type 'a symbol_entry = identifier * 'a
type 'a symbol_block = (identifier, 'a) Hashtbl.t
type 'a symbol_table = 'a symbol_block Stack.t

let create_table = Stack.create
let begin_block table = table |> Stack.push (Hashtbl.create 5)
let end_block table = table |> Stack.pop >. ()
let add_entry table (id, key) = (table |> Stack.top |> Hashtbl.add) id key
let local_lookup table = table |> Stack.top |> Hashtbl.find_opt

let lookup table id =
  let lookup_local_block (seq : 'a symbol_block Seq.t) =
    Option.bind (Seq.uncons seq) (fun blk -> Hashtbl.find_opt (fst blk) id)
  in
  let rec lookup_rec (seq : 'a symbol_block Seq.t) =
    match lookup_local_block seq with
    | None -> Option.bind (Seq.uncons seq) (fun (_, xs) -> lookup_rec xs)
    | Some typ -> Some typ
  in
  lookup_rec (Stack.to_seq table)

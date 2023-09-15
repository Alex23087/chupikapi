let ( >> ) f g x = g (f x)

let ( >. ) f g =
  let _ = f in
  g

let ( @> ) node loc = { Pikast.node; Pikast.loc = Pikaloc.to_code_position loc }
let ( ~@@ ) { Pikast.loc; _ } = loc
let ( ~@! ) { Pikast.node; _ } = node

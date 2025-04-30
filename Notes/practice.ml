let map_triple f g h (x, y, z) = (f x, g y, h z)
let apply_twice f x = f (f x)
(* A curried function generator that dynamically creates a function chain based on an initial seed *)
let dynamic_chain seed =
  let rec build_chain n f =
    if n = 0 then f
    else build_chain (n - 1) (fun x -> apply_twice f x)
  in
  build_chain seed

  let is_well_formed lst =
    let rec helper lst depth =
      match lst with
      | [] -> depth = 0  (* Return True if all opened parentheses are closed! *)
      | '(' :: t -> helper t (depth + 1)  (* Increment depth for each '(' *)
      | ')' :: t -> if depth > 0 then helper t (depth - 1) else false 
  (* Decrement depth for each ')' if depth is positive *)
      | _ -> false (* Invalid character*)
    in
    helper lst 0;;

let f x = x
  
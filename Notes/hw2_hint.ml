let match_nothing _ _ = None

let match_empty a f = a f (* aka identity function equivalent to let match_empty a = a*)

let match_nt nt a f = 
  match f with
  | [] -> None
  | h::t -> if h =nt then a t else None

let matchor p q =  (* given two subpatterns gives you the or of the patterns *)
  let rec pm = make_matcher p
  and qm = make_matcher q
  in fun a f -> 
      match pm a f
      | None -> qm a f
      | x -> x
    

let match_cat p q =       (* -> (P|Q) *)
  let pm = make_matcher p
  and qm = make_matcher q
  in fun a f ->           
    pm (fun frag -> qm a frag)f

   (* more effectively written *)

let match_cat p q =   (* -> (PQ) *)
  let pm = make_matcher p
  and qm = make_matcher q
  in fun a -> pm (qm a)     (* (qm a) points to the point inbetween PQ or in other words is an acceptor that accepts the frag at the beginning of Q*)



  (* matcher is the function that goes acceptor -> frag -> frag option*)


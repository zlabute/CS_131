type term = string 
type non_term = string

type ('non_term, 'term) symbol =
  | N of 'non_term
  | T of 'term

type ('non_term, 'term) grammar = 
  non_term * (non_term * ('non_term, 'term) symbol list) list

let subset a b =                          (* 1 *)
  List.for_all (fun x -> List.mem x b) a  

let equal_sets a b =                      (* 2 *) 
  subset a b && subset b a

let set_union a b =                       (* 3 *)
  a @ b

let set_all_union a =                     (* 4 *)
  List.fold_left set_union [] a

let self_member s =                       (* 5 *)
  (* List.exists (fun x -> x == s) s *) (* reasoning explained in the tests file*)
  None

let rec computed_fixed_point eq f x =     (* 6 *)
  if eq (f x) x then x
  else computed_fixed_point eq f (f x) 

let rec do_p_times f p x =                (* 7 *)
  if p = 0 then x
  else do_p_times f (p - 1) (f x)                           

let rec computed_periodic_point  eq f p x =   
  if eq (do_p_times f p x) x then x
  else computed_periodic_point eq f p (f x)

let rec whileseq s p x =                 (* 8 *)
  if not (p x) then []
  else if not (p (s x)) then [x]
  else x :: whileseq s p (s x)

let is_right_side_creating r g =         (* 9 *)
  List.for_all (fun sym ->
    match sym with
    | T _ -> true
    | N n -> List.mem n g
  ) r

let update_rules g (l, r) = 
  if is_right_side_creating r g then
    if List.mem l g then g else l :: g
  else
    g 

let compute_creating_set rules =
  let new_c c = List.fold_left update_rules c rules in 
  computed_fixed_point equal_sets new_c []

let filter_rules g (l, r) = 
  List.mem l g &&
  is_right_side_creating r g 


let filter_blind_alleys g = 
  let (start_sym, rules) = g in 
  let create_set = compute_creating_set rules in
  let filtered_rules = List.filter (filter_rules create_set) rules in
  (start_sym, filtered_rules)





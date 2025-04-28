(* CS 131 Homework 2 *)

type term = string 
type non_term = string

type ('non_term, 'term) symbol =
  | N of 'non_term
  | T of 'term

type ('non_term, 'term) pt =
  | Leaf of 'term
  | Node of 'non_term * ('non_term, 'term) pt list 

type ('non_term, 'term) grammar = 
  non_term * ('non_term -> ('non_term, 'term) symbol list list)



let convert_grammar (start, rules) =

  let prod_table = 
    List.fold_right
      (fun (lhs, rhs) acc ->
        try
          let rhss = List.assoc lhs acc in
          (lhs, rhs::rhss) :: List.remove_assoc lhs acc
        with Not_found ->
          (lhs, [rhs]) :: acc)
        rules
        []
  in 
  (start, fun nt ->
    try List.assoc nt prod_table with Not_found -> [])

let rec parse_tree_leaves = function
  | Leaf t -> [t]
  | Node (_, children) ->
      List.concat (List.map parse_tree_leaves children)




(* make_matcher code *)

let make_matcher (start, prod) = (* Match the rhs to the head of the symbol list*)
  
  let rec match_rhs syms accept frag =
    match syms with
    | [] -> (* if no more symbols; call accept on remaining frag *)
        accept frag

    | sym :: syms_tail -> (* take symbol head and match it *)
      match sym, frag with
      | T valid_terminal, head :: tail when valid_terminal = head ->  (* matches terminal symbol to a matching head of the frag *)
          match_rhs syms_tail accept tail
          
      | T _, _ -> (* If invalid terminal returns nothing and treats as dead end *)
          None

      | N nt, _ -> (* If encounters non_terminal calls try_branches to test expansion of non_terminal *)
          try_branches (prod nt) syms_tail accept frag

  and try_branches branches syms_tail accept frag = (* tests different expansions of each non_terminal exhaustively *)
    match branches with
    | [] -> None
    | branch :: other_branches -> 
        let to_match = branch @ syms_tail in
        match match_rhs to_match accept frag with
        | Some _ as valid -> valid 
        | None         -> try_branches other_branches syms_tail accept frag

  in
  
  fun accept frag -> (* start by expanding the start symbol *)
    try_branches (prod start) [] accept frag




(* //////////////////////////////////////////////////////////////////////////////////// *)


let make_parser (start, prod) =
  let rec parse_rhs syms frag = 
    match syms with 
    | [] ->
      Some ([], frag_)
    
    | T valid_terminal :: syms_tail ->
      (match frag with
        )
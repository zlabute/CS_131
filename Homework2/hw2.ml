(* CS 131 Homework 2 *)

type term = string 
type non_term = string

type ('non_term, 'term) symbol =
  | N of 'non_term
  | T of 'term

type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal

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




(* /////////////////////        make parser            //////////////////////// *)


let make_parser (start, prod) =

  let rec parse_rhs syms frag =
    match syms, frag with
    | [], _ -> (* Empty list no more symbols to parse return empty tree and frag as suffix*)
        Some ([], frag)

    | T valid_terminal :: syms_tail, head :: tail (* encounter a terminal that matches valid_terminal tro the head of the frag and constructs leaves recursively  *)
      when valid_terminal = head ->
        (match parse_rhs syms_tail tail with
         | Some (ts, r) -> Some (Leaf valid_terminal :: ts, r)
         | None -> None)

    | N non_term :: rest_syms, _ -> (* encounter non_terminal and expand with dfs using try_branches corecursive function*)
        try_branches non_term rest_syms frag

    | _, _ -> (* If does not match above patterns there is nothing to be done and syms and frag do not matter *)
        None

  and try_branches non_term rest_syms frag = (* exhaustively expands non_terminals and sub trees *)
    let branches = prod non_term in
    let rec helper = function
      | [] -> None
      | branch :: bs ->
        match parse_rhs branch frag with
          | None -> helper bs
          | Some (sub, r1) ->
              match parse_rhs rest_syms r1 with
              | Some (ts, r2) -> Some (Node (non_term, sub) :: ts, r2)
              | None -> helper bs
    in helper branches

  in
  fun frag ->
    match parse_rhs [N start] frag with
    | Some ([tree], []) -> Some tree
    | _ -> None
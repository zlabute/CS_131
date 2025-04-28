(* Homework 2 Tests *)


type awksub_nonterminals =                (* 9 : tests *) 
| Expr | Lvalue | Incrop | Binop | Num

let awksub_rules =
[Expr, [T"("; N Expr; T")"];
  Expr, [N Num];
  Expr, [N Expr; N Binop; N Expr];
  Expr, [N Lvalue];
  Expr, [N Incrop; N Lvalue];
  Expr, [N Lvalue; N Incrop];
  Lvalue, [T"$"; N Expr];
  Incrop, [T"++"];
  Incrop, [T"--"];
  Binop, [T"+"];
  Binop, [T"-"];
  Num, [T"0"];
  Num, [T"1"];
  Num, [T"2"];
  Num, [T"3"];
  Num, [T"4"];
  Num, [T"5"];
  Num, [T"6"];
  Num, [T"7"];
  Num, [T"8"];
  Num, [T"9"]]

let awksub_grammar = Expr, awksub_rules


let awksub_grammar_2 = convert_grammar awksub_grammar   (* Tests: 1 *)
let (start2, prod2) = awksub_grammar_2

let () =
  assert (start2 = Expr);
  assert (prod2 Expr = [
    [T"("; N Expr; T")"];           
    [N Num];                    
    [N Expr; N Binop; N Expr];  
    [N Lvalue];                   
    [N Incrop; N Lvalue];        
    [N Lvalue; N Incrop]             
  ]);
  
  assert (prod2 Lvalue = [[T"$"; N Expr]]);
  assert (prod2 Incrop = [[T"++"]; [T"--"]]);
  assert (prod2 Binop = [[T"+"]; [T"-"]]);
  assert (prod2 Num = [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"]; [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]]);
  print_endline "convert_grammar tests passed!"

module Simple = struct
  type simple_nt = Start
  let simple_grammar = (Start, [
    (Start, [T"a"; N Start]);
    (Start, [T"b"])
  ])
  let (s2, p2) = convert_grammar simple_grammar
  let () =
    assert (s2 = Start);
    assert (p2 Start = [[T"a"; N Start]; [T"b"]]);
    print_endline "simple grammar test passed!"
end


(*Consider the following BNF grammar with start symbol Expr:

Expr → Term Binop Expr
Expr → Term
Term → Num
Term → Lvalue
Term → Incrop Lvalue
Term → Lvalue Incrop
Term → "(" Expr ")"
Lvalue → "$" Expr
Incrop → "++"
Incrop → "−−"
Binop → "+"
Binop → "−"
Num → "0"
Num → "1"
Num → "2"
Num → "3"
Num → "4"
Num → "5"
Num → "6"
Num → "7"
Num → "8"
Num → "9"
The following test cases use a representation of this grammar.*)

let accept_all string = Some string
let accept_empty_suffix = function
   | _::_ -> None
   | x -> Some x

(* An example grammar for a small subset of Awk.
   This grammar is not the same as Homework 1; it is
   instead the grammar shown above.  *)

type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num

let awkish_grammar =
  (Expr,
   function
     | Expr ->
         [[N Term; N Binop; N Expr];
          [N Term]]
     | Term ->
	 [[N Num];
	  [N Lvalue];
	  [N Incrop; N Lvalue];
	  [N Lvalue; N Incrop];
	  [T"("; N Expr; T")"]]
     | Lvalue ->
	 [[T"$"; N Expr]]
     | Incrop ->
	 [[T"++"];
	  [T"--"]]
     | Binop ->
	 [[T"+"];
	  [T"-"]]
     | Num ->
	 [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
	  [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

  
  

let example1 : (awksub_nonterminals, string) pt =  (* Tests: 2 *)
  Node (Expr, [
    Leaf "(";
    Node (Term, [Leaf "5"]);
    Leaf ")"
  ])

(* Example 2: simple binary expression "3 + 4" *)
let example2 : (awksub_nonterminals, string) pt =
  Node (Expr, [
    Node (Term, [Leaf "3"]);
    Node (Binop, [Leaf "+"]);
    Node (Expr, [Node (Term, [Leaf "4"])])
  ])

(* Example 3: prefix increment "++$5" *)
let example3 : (awksub_nonterminals, string) pt  =
  Node (Expr, [
    Node (Incrop, [Leaf "++"]);
    Node (Lvalue, [Leaf "$"; Node (Expr, [Node (Term, [Leaf "5"])])])
  ])

(* Example 4: postfix decrement "$7--" *)
let example4 : (awksub_nonterminals, string) pt =
  Node (Expr, [
    Node (Lvalue, [Leaf "$"; Node (Expr, [Node (Term, [Leaf "7"])])]);
    Node (Incrop, [Leaf "--"])
  ])

let () =
  assert (parse_tree_leaves example1 = ["("; "5"; ")"]);
  assert (parse_tree_leaves example2 = ["3"; "+"; "4"]);
  assert (parse_tree_leaves example3 = ["++"; "$"; "5"]);
  assert (parse_tree_leaves example4 = ["$"; "7"; "--"]);
  print_endline "parse_tree_leaves test suite passed!"  



    
let test0 =
  ((make_matcher awkish_grammar accept_all ["ouch"]) = None)

let test1 =
  ((make_matcher awkish_grammar accept_all ["9"])
   = Some [])

let test2 =
  ((make_matcher awkish_grammar accept_all ["9"; "+"; "$"; "1"; "+"])
   = Some ["+"])

let test3 =
  ((make_matcher awkish_grammar accept_empty_suffix ["9"; "+"; "$"; "1"; "+"])
   = None)

(* This one might take a bit longer.... *)
let test4 =
 ((make_matcher awkish_grammar accept_all
     ["("; "$"; "8"; ")"; "-"; "$"; "++"; "$"; "--"; "$"; "9"; "+";
      "("; "$"; "++"; "$"; "2"; "+"; "("; "8"; ")"; "-"; "9"; ")";
      "-"; "("; "$"; "$"; "$"; "$"; "$"; "++"; "$"; "$"; "5"; "++";
      "++"; "--"; ")"; "-"; "++"; "$"; "$"; "("; "$"; "8"; "++"; ")";
      "++"; "+"; "0"])
  = Some [])

let test5 =
  (parse_tree_leaves (Node ("+", [Leaf 3; Node ("*", [Leaf 4; Leaf 5])]))
   = [3; 4; 5])

let small_awk_frag = ["$"; "1"; "++"; "-"; "2"]

let test6 =
  ((make_parser awkish_grammar small_awk_frag)
   = Some (Node (Expr,
		 [Node (Term,
			[Node (Lvalue,
			       [Leaf "$";
				Node (Expr,
				      [Node (Term,
					     [Node (Num,
						    [Leaf "1"])])])]);
			 Node (Incrop, [Leaf "++"])]);
		  Node (Binop,
			[Leaf "-"]);
		  Node (Expr,
			[Node (Term,
			       [Node (Num,
				      [Leaf "2"])])])])))
let test7 =
  match make_parser awkish_grammar small_awk_frag with
    | Some tree -> parse_tree_leaves tree = small_awk_frag
    | _ -> false
 

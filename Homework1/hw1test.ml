(* Copyright 2006-2023 Paul Eggert.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  *)

  let subset_test0 = subset [] [1;2;3]  (* 1 : tests *)
  let subset_test1 = subset [3;1;3] [1;2;3]
  let subset_test2 = not (subset [1;3;7] [4;1;3])

  let subset_test3 = subset [[1]] [[1];[2];[3]] (* 1 : tests : original *)
  let subset_test4 = subset ["False"; "True"; "Purple"] ["False"; "True"; "Purple"; "Red"]
  let subset_test5 = subset [`False; `True; `Purple] [`False; `True; `Purple; `Red]
  let subset_test6 = not (subset [`False; `True; `Purple; `Red]  [`False; `True; `Purple])
  let subset_test7 = not (subset [1;2;3] [])



  
  let equal_sets_test0 = equal_sets [1;3] [3;1;3]    (* 2 : tests *)
  let equal_sets_test1 = not (equal_sets [1;3;4] [3;1;3])

  let equal_sets_test2 = equal_sets [] []            (* 2 : tests : original *)
  let equal_sets_test3 = equal_sets [1;2;3;3;4;3] [1;2;3;4]
  let equal_sets_test4 = not (equal_sets [3] [])

  
  
  let set_union_test0 = equal_sets (set_union [] [1;2;3]) [1;2;3]   (* 3 : tests *)
  let set_union_test1 = equal_sets (set_union [3;1;3] [1;2;3]) [1;2;3]
  let set_union_test2 = equal_sets (set_union [] []) []
  
  let set_union_test3 = equal_sets (set_union [3] [3]) [3] (* 3 : tests : original *)
  let set_union_test4 = not (equal_sets (set_union [1;2;3] [4;5;6]) [1;2;3;4;5])
  
  
  let set_all_union_test0 =                  (* 4 : tests *)     
    equal_sets (set_all_union []) []
  let set_all_union_test1 =
    equal_sets (set_all_union [[3;1;3]; [4]; [1;2;3]]) [1;2;3;4]
  let set_all_union_test2 =
    equal_sets (set_all_union [[5;2]; []; [5;2]; [3;5;7]]) [2;3;5;7]

  let set_all_union_test3 =                 (* 4 : tests : original *)
    not (equal_sets (set_all_union [[5;2;3]; [6]]) [7;8;9;4])

  (* let self_member_test0 =                   (* 5 : tests : original *)
    let rec s = [s] in
    self_member s
  let self_member_test1 =                   (* 5 : tests : original *)
    let rec s = [s; []] in
    self_member s
  let self_member_test2 = not (self_member [[]])
  let self_member_test3 = not (self_member [[]; [2]]) *) 

  (* My code for 5 only works when run on -rectypes and only for the test0 and test2 but not for the others this
  indicates to me that in the general case the function is incapable of being written within Ocaml.
  
  More specifically it is because there is no cyclic infinte types by default in Ocaml. As there is no inbuilt native pointer so if you create a 
  cyclic sturcture it will enter an infinite loop. I demonstrated this above by showing you could create the cyclic type but it did not work in 
  the general case. Furthermore becasue of the lack of pointers the == equality does not work as it is only meant for items that already exist in 
  Ocaml and not references to a list or itself. This may work in a different language like python though because it inherently allows for cyclic
  structures that are all stored as references anyways and can be easily checked. 

  Ultimately to conclude you cannot create a working implementation of self_member in Ocaml without creating significant side effects that are
  disallowed in this assignment. Overall my use of search engines and ChatGPT served to confuse me on my conclusion of this as
  there was lots of conflicting information. This once again served as a reminder of how genAI specifically can 
  come to conclusions that it believes will satisfy the query not necesarily stick to the truth. There is also the problem of context
  as there is the context of this assignment which contributes to my conclusion.

  *)
  
  
  let computed_fixed_point_test0 =            (* 6 : tests *) 
    computed_fixed_point (=) (fun x -> x / 2) 1000000000 = 0
  let computed_fixed_point_test1 =
    computed_fixed_point (=) (fun x -> x *. 2.) 1. = infinity
  let computed_fixed_point_test2 =
    computed_fixed_point (=) sqrt 10. = 1.
  let computed_fixed_point_test3 =
    ((computed_fixed_point (fun x y -> abs_float (x -. y) < 1.)
        (fun x -> x /. 2.)
        10.)
    = 1.25)

  let computed_fixed_point_test4 =          (* 6 : tests : original *) 
    computed_fixed_point (=) (fun x -> x) 42 = 42  (* this tests the identity function *)
  let computed_fixed_point_test5 =      
    not (computed_fixed_point (=) (fun x -> x) 42 = 41)  
  let computed_fixed_point_test6 = 
    computed_fixed_point (<) (fun x -> x - 1) 5 = 5
  


  
  let computed_periodic_point_test0 =       (* 7 : tests *) 
    computed_periodic_point (=) (fun x -> x / 2) 0 (-1) = -1
  let computed_periodic_point_test1 =
    computed_periodic_point (=) (fun x -> x *. x -. 1.) 2 0.5 = -1.

  let computed_periodic_point_test2 =       (* 7 : tests : original *) 
    computed_periodic_point (=) (fun x -> x) 1 100 = 100
  let computed_periodic_point_test3 =
    computed_periodic_point (>) (fun x -> x + 2) 3 0 = 0
    


  let whileseq_test_0 =                      (* 8 : tests *) 
     whileseq ((+) 3) ((>) 10) 0  = [0; 3; 6; 9] 

  let whileseq_test_1 =                      (* 8 : tests: original *) 
    whileseq (( * ) 2)  ((>) 16) 1 = [1; 2; 4; 8]
  let whileseq_test_2 = 
    whileseq (fun x -> x / 2)  ((<) 1) 16 = [16; 8; 4; 2]

  
  
  
  (* An example grammar for a small subset of Awk.  *)
  
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
  
  let awksub_test0 =
    filter_blind_alleys awksub_grammar = awksub_grammar
  
  let awksub_test1 =
    filter_blind_alleys (Expr, List.tl awksub_rules) = (Expr, List.tl awksub_rules)
  
  let awksub_test2 =
    filter_blind_alleys (Expr,
        [Expr, [N Num];
        Expr, [N Lvalue];
        Expr, [N Expr; N Lvalue];
        Expr, [N Lvalue; N Expr];
        Expr, [N Expr; N Binop; N Expr];
        Lvalue, [N Lvalue; N Expr];
        Lvalue, [N Expr; N Lvalue];
        Lvalue, [N Incrop; N Lvalue];
        Lvalue, [N Lvalue; N Incrop];
        Incrop, [T"++"]; Incrop, [T"--"];
        Binop, [T"+"]; Binop, [T"-"];
        Num, [T"0"]; Num, [T"1"]; Num, [T"2"]; Num, [T"3"]; Num, [T"4"];
        Num, [T"5"]; Num, [T"6"]; Num, [T"7"]; Num, [T"8"]; Num, [T"9"]])
    = (Expr,
      [Expr, [N Num];
        Expr, [N Expr; N Binop; N Expr];
        Incrop, [T"++"]; Incrop, [T"--"];
        Binop, [T "+"]; Binop, [T "-"];
        Num, [T "0"]; Num, [T "1"]; Num, [T "2"]; Num, [T "3"]; Num, [T "4"];
        Num, [T "5"]; Num, [T "6"]; Num, [T "7"]; Num, [T "8"]; Num, [T "9"]])
  
  let awksub_test3 =
    filter_blind_alleys (Expr, List.tl (List.tl (List.tl awksub_rules))) =
      filter_blind_alleys (Expr, List.tl (List.tl awksub_rules))
  
      
  type giant_nonterminals =
    | Conversation | Sentence | Grunt | Snore | Shout | Quiet
  
  let giant_grammar =
    Conversation,
    [Snore, [T"ZZZ"];
    Quiet, [];
    Grunt, [T"khrgh"];
    Shout, [T"aooogah!"];
    Sentence, [N Quiet];
    Sentence, [N Grunt];
    Sentence, [N Shout];
    Conversation, [N Snore];
    Conversation, [N Sentence; T","; N Conversation]]
  
  let giant_test0 =
    filter_blind_alleys giant_grammar = giant_grammar
  
  let giant_test1 =
    filter_blind_alleys (Sentence, List.tl (snd giant_grammar)) =
      (Sentence,
      [Quiet, []; Grunt, [T "khrgh"]; Shout, [T "aooogah!"];
        Sentence, [N Quiet]; Sentence, [N Grunt]; Sentence, [N Shout]])
  
  let giant_test2 =
    filter_blind_alleys (Sentence, List.tl (List.tl (snd giant_grammar))) =
      (Sentence,
      [Grunt, [T "khrgh"]; Shout, [T "aooogah!"];
        Sentence, [N Grunt]; Sentence, [N Shout]]) 

  let giant_test3 =              (*   9 : tests : original *)
    filter_blind_alleys
      ( Conversation, 
        List.tl (List.tl (List.tl (snd giant_grammar)))
      ) = 
      ( Conversation,
        [ Shout, [T "aooogah!"]
        ; Sentence, [N Shout]
        ]
      )


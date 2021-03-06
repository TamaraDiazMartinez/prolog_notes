% This implementation works, even with open lists, but is slow and resource hungry
% The alternative is reversing the list, then using foldl. 
% I haven't managed to code that (yet?): "reversing the list" must be done 
% simultaneously on all lists with common-length-of-list the value to backtrack over
% and possibly to fail on.
% Additionally, a failing foldl after reverse must not lead to an infinite 
% failure-driven loop. If foldl fails, you have to cut & fail, not redo!

% This code is inspired by the "foldl" code found in library/apply.pl of SWI Prolog 8.3.13,
% but more by form than by function.
% That code for "foldl" in library/apply.pl is under this license:
% https://opensource.org/licenses/BSD-3-Clause
% But it probably goes back to some file of DEC-10 Prolog from the 80s.
% Is this code derivative work of SWI-Prolog's library/apply.pl? Diffcult to say! Opinions
% may differ! In fact there is no other way to code this function than the one given, except
% for changes in variable and predicate names.
% So what license to use here? 
% ronerycoder@gluino.name (me) says this is licensed under 
% https://opensource.org/licenses/0BSD

/*
Run the tests:

?- [foldr_recursive].
true.

?- ['tests/test_foldr.pl'].
true.

?- run_tests.
% PL-Unit: foldr ............... done
% All 15 tests passed
true.
*/

% --- one list

foldr(Goal, List, V0, V) :-
    foldr_(List, Goal, V0, V).

foldr_([], _, V0, V0).
foldr_([H|T], Goal, V0, V) :-
    foldr_(T, Goal, V0, V2),    % non-tail-recursive call
    call(Goal, H, V2, V). 

% --- two lists

foldr(Goal, List1, List2, V0, V) :- 
   foldr_(List1, List2, Goal, V0, V). 

foldr_([], [], _, V0, V0). 
foldr_([H1|T1], [H2|T2], Goal, V0, V) :- 
    foldr_(T1, T2, Goal, V0, V2),     % non-tail-recursive call
    call(Goal, H1, H2, V2, V). 

% --- three lists

foldr(Goal, List1, List2, List3, V0, V) :- 
    foldr_(List1, List2, List3, Goal, V0, V). 

foldr_([], [], [], _, V0, V0). 
foldr_([H1|T1], [H2|T2], [H3|T3], Goal, V0, V) :- 
    foldr_(T1, T2, T3, Goal, V0, V2),     % non-tail-recursive call
    call(Goal, H1, H2, H3, V2, V). 

% --- four lists

foldr(Goal, List1, List2, List3, List4, V0, V) :- 
    foldr_(List1, List2, List3, List4, Goal, V0, V). 

foldr_([], [], [], [], _, V0, V0). 
foldr_([H1|T1], [H2|T2], [H3|T3], [H4|T4], Goal, V0, V) :- 
   foldr_(T1, T2, T3, T4, Goal, V0, V2),     % non-tail-recursive call
   call(Goal, H1, H2, H3, H4, V2, V). 

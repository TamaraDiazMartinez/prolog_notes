% ==============================================================================
% Metapredicates that mostly help in making code readable.
% ==============================================================================
%
% This is not a module! Often, the goals called contain module-private
% predicates, and then the call "from another module" fails. (This could 
% be fixed in the Prolog runtime at some considerable cost of complexity.)
%
% We will just "consult" this file from any module that needs the predicates,
% thus creating "local copies" of said predicates in that module.
%
% Pull it in as follows:
%
% :- include(library('heavycarbon/support/meta_helpers_nonmodular.pl')).
%
% (What does the compiler do with unused in-module code?)
%

% ---
% A better "switch" than an unreadable sequence of ->/2
%
% IT'S SLOW!
% Note that using this instead of directly-inlined "->" slows down a program markedly!
% 30% slowdown if there are lots of these calls is not impossible. In the end, 
% these must be replaced by term rewriting.
% ---

% switch/4

switch(If1,Then1,If2,Then2) :-
   call(If1)
   ->  call(Then1)
   ;   call(If2)
   ->  call(Then2)
   ;   throw(error(programming_error,context(_,"default case of switch; should not happen"))).

% switch/5

switch(If1,Then1,If2,Then2,Else) :-
   call(If1)
   ->  call(Then1)
   ;   call(If2)
   ->  call(Then2)
   ;   call(Else).

% switch/6

switch(If1,Then1,If2,Then2,If3,Then3) :-
   call(If1)
   ->  call(Then1)
   ;   call(If2)
   ->  call(Then2)
   ;   call(If3)
   ->  call(Then3)
   ;   throw(error(programming_error,context(_,"default case of switch; should not happen"))).

% switch/7

switch(If1,Then1,If2,Then2,If3,Then3,Else) :-
   call(If1)
   ->  call(Then1)
   ;   call(If2)
   ->  call(Then2)
   ;   call(If3)
   ->  call(Then3)
   ;   call(Else).

% switch/8

switch(If1,Then1,If2,Then2,If3,Then3,If4,Then4) :-
   call(If1)
   ->  call(Then1)
   ;   call(If2)
   ->  call(Then2)
   ;   call(If3)
   ->  call(Then3)
   ;   call(If4)
   ->  call(Then4)
   ;   throw(error(programming_error,context(_,"default case of switch; should not happen"))).

% switch/9

switch(If1,Then1,If2,Then2,If3,Then3,If4,Then4,Else) :-
   call(If1)
   ->  call(Then1)
   ;   call(If2)
   ->  call(Then2)
   ;   call(If3)
   ->  call(Then3)
   ;   call(If4)
   ->  call(Then4)
   ;   call(Else).

% switch/10

switch(If1,Then1,If2,Then2,If3,Then3,If4,Then4,If5,Then5) :-
   call(If1)
   ->  call(Then1)
   ;   call(If2)
   ->  call(Then2)
   ;   call(If3)
   ->  call(Then3)
   ;   call(If4)
   ->  call(Then4)
   ;   call(If5)
   ->  call(Then5)
   ;   throw(error(programming_error,context(_,"default case of switch; should not happen"))).

% switch/11

switch(If1,Then1,If2,Then2,If3,Then3,If4,Then4,If5,Then5,Else) :-
   call(If1)
   ->  call(Then1)
   ;   call(If2)
   ->  call(Then2)
   ;   call(If3)
   ->  call(Then3)
   ;   call(If4)
   ->  call(Then4)
   ;   call(If5)
   ->  call(Then5)
   ;   call(Else).

% switch/12

switch(If1,Then1,If2,Then2,If3,Then3,If4,Then4,If5,Then5,If6,Then6) :-
   call(If1)
   ->  call(Then1)
   ;   call(If2)
   ->  call(Then2)
   ;   call(If3)
   ->  call(Then3)
   ;   call(If4)
   ->  call(Then4)
   ;   call(If5)
   ->  call(Then5)
   ;   call(If6)
   ->  call(Then6)
   ;   throw(error(programming_error,context(_,"default case of switch; should not happen"))).

% ---
% An implementation of ->/2. Pass three goals.
% ---

if_then_else(Condition,Then,Else) :- 
   call(Condition) -> call(Then) ; call(Else).

% ---
% Reification of an outcome. Pass a Goal and the Thing to be unified with Out
% if the Goal succeeds and the Thing to be unified with Out of the Goal fails
% ---

reify_outcome(Condition,TrueThing,FalseThing,Out) :-
   call(Condition) -> (Out = TrueThing) ; (Out = FalseThing).

% ---
% Simpler reification to just the truth value
% ---

reify(Goal,Truth) :-
   if_then_else(call(Goal),(Truth=true),(Truth=false)).

% ---
% An implementation of ->/2 with an "else" that's true. Pass two goals.
% ---

if_then(Condition,Then) :- 
   call(Condition) -> call(Then) ; true.

% ---
% An implementation of ->/2 with an inverted logic
% ---

unless(Condition,Then) :- 
   call(Condition) -> true ; call(Then).

% ---
% Throw a non-ISO standard exception which is used when a switch
% covers all the cases but you are paranoid enough to fill something into
% the final "else" anyway. This is not an ISO standard exception because
% the "formal" term "cannot happen" is not in the list of allowed terms.
% ---

cannot_happen_error(Msg) :-
   throw(error(cannot_happen,context(_,Msg))).


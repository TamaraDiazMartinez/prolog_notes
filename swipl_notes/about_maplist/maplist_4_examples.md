# Examples for the Prolog predicate `maplist/4` (as run with SWI-Prolog)

- This is a companion page for the SWI-Prolog manual page on [`maplist/4`](https://eu.swi-prolog.org/pldoc/doc_for?object=maplist/4).
- For examples about `maplist/2` (1 goal, 1 iterable), see [this page](maplist_2_examples.md)
- For examples about `maplist/3` (1 goal, 2 iterables),  see [this page](maplist_3_examples.md)

## About

A few examples for the predicate [`maplist/4`](https://www.swi-prolog.org/pldoc/doc_for?object=maplist/4) 
from [library(apply)](https://www.swi-prolog.org/pldoc/man?section=apply) as run with SWI-Prolog.

`library(apply)`: _"This module defines meta-predicates that apply a predicate on all members of a list."_

In order for lists to be printed fully instead of elided at their end with ellipses ("`|...`") you may have
to first call:

````
?- 
set_prolog_flag(answer_write_options,[max_depth(0)]).
````

## Intro

The description for [`maplist/4`](https://www.swi-prolog.org/pldoc/doc_for?object=maplist/4) says:

> `maplist(:Goal, ?List1, ?List2, ?List3)`
>
>     As maplist/2, operating on triples of elements from three lists.

## Examples

### Arbitrary packing and unpacking using the same goal

As long as the packing operation is reversible (i.e. there is a bijective relationship between the pair (List1,List2) and List3), you can pack/unpack with the same goal:

```none
List 1 ---+                                               +---> List 1
          |     Packing                   Unpacking       |
          +-----> via ------> List 3 ------> via    ------+
          |     maplist/4                 maplist/4       |
List 2 ---+                                               +---> List 2
```

For example, a `pack` operation with maps two terms in `X` and `Y` to a compound term `f(X,Y)`:

```none
pack(X,Y,f(X,Y)).
```

Then you can use `maplist/4`:

```none
?- 
maplist(pack,[1,2,3,4],[a,b,c,d],L3).

L3 = [f(1, a), f(2, b), f(3, c), f(4, d)].

?- 
maplist(pack,L1,L2,[f(1, a), f(2, b), f(3, c), f(4, d)]).

L1 = [1, 2, 3, 4],
L2 = [a, b, c, d].
```

### Assembling/Disassembling a list of "key-value" pairs for sorting

The above applies in particular to this common operation, where the "pair", a
term with arity 2 and functor name `-` (as in `-(K,V)` more conveniently written `K-V`) is used:

The little predicate that assembles and disassembles a single Key-Value pair:

```none
ziptwo(K,V,K-V).
```

The sorter. It runs `maplist/4` twice, around the call to `keysort/2`.

```none
sort_them(LK,LV,LO) :-
   maplist(ziptwo,LK,LV,LKV),   % Assemble Key-Value list
   keysort(LKV,LKVSo),
   maplist(ziptwo,_,LO,LKVSo).  % Disassemble Key-Value list
```

Test data and one-liner test:

```none
keylist([b,c,c,a,b,d,b]).
vallist([2,3,2,1,1,4,2]).
sollist([1,2,1,2,3,2,4]).

% One-liner test

go :- keylist(LK),vallist(LV),sort_them(LK,LV,LO),sollist(LO).
```

- Also take a look at [`library(pairs)`](https://www.swi-prolog.org/pldoc/man?section=pairs) for operations on key-value lists.
- Some test code for the SWI-Prolog sorting predicates is [here](../various_code/test_sort_predicates.pl)

### Implementing `foldl/4` with `maplist/4`.

This is somewhat pointless, but I felt like doing that:

- [Explainer](../../other_notes/about_foldl_and_foldr/linear_foldl_with_maplist4.md)
- [Code](../../other_notes/about_foldl_and_foldr/maplist_foldl.pl)


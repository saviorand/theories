:- use_module(library(scasp)).
:- ensure_loaded('../../functions/createBackground.pl').
:- reexport('backgroundv2').

%% Abduction

run :-
    background_abduction(B, Pos, Neg, Predicates),
    create_background(B).

?- run.

#abducible from(X, Z).
#abducible white(X).

% Case: These beans are from this sack
% Query:
% ?- ? from(b1,s1). % Results: true
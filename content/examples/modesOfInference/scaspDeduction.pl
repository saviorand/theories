:- use_module(library(scasp)).
:- ensure_loaded('../../functions/createBackground.pl').
:- reexport('backgroundv2').

%% Deduction

run :-
    background_deduction(B, Pos, Neg, Predicates, Goal),
    create_background(B).

?- run.

% Result: These beans are white 
% Query:
% ?- white(X). % Results: X = b1
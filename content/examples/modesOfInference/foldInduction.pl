:- use_module(library(scasp)).
:- ensure_loaded('../../First-Order-Learner-of-Default/fold.pl').
:- ensure_loaded('../../functions/createBackground.pl').

background_induction(B, Pos, Neg, Predicates, Goal) :-
    % Case: These beans are from this sack
    B = [
        sack(s1),
        bean(b1),
        from_s1(b1)
    ],
    % Result: These beans are white
    Pos = [b1],
    Neg = [],
    Predicates = [sack, bean, from_s1],
    Goal = white.
    % fold.. Rule: all beans from this sack are white

%% Induction

run :-
    background_induction(B, Pos, Neg, Predicates, Goal),
    create_background(B),
    fold(Goal, Pos, Neg, B, Predicates, D, AB, false),
    writeln(D),
    writeln(AB).

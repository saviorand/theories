:- ensure_loaded('../../First-Order-Learner-of-Default/fold.pl').
:- ensure_loaded('../../functions/createBackground.pl').
:- reexport('backgroundv2').

%% Induction

run :-
    background_induction(B, Pos, Neg, Predicates, Goal),
    create_background(B),
    fold(Goal, Pos, Neg, B, Predicates, D, AB, false),
    writeln(D),
    writeln(AB).

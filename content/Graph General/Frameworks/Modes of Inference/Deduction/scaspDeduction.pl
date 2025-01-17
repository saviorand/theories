:- use_module(library(scasp)).
:- ensure_loaded('../../functions/createBackground.pl').

background_deduction(B, Pos, Neg, Predicates, Goal) :-
    B = [
        sack(s1),
        bean(X),
        white(Y),
        from(X,Z),
        % Rule: all beans from this sack are white
        white(X) :- from(X,s1),
        % Case: These beans are from this sack
        from(b1,s1)
    ],
    Pos = [],
    Neg = [],
    Predicates = [sack, bean, white, from, from_s1],
    % Result: These beans are white 
    % Query:
    % white(X). Results: X = b1
    Goal = white.

run :-
    background_deduction(B, Pos, Neg, Predicates, Goal),
    create_background(B).

?- run.

% Result: These beans are white 
% Query:
% ?- white(X). % Results: X = b1
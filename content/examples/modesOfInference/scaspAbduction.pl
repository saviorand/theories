:- use_module(library(scasp)).
:- ensure_loaded('../../functions/createBackground.pl').

background_abduction(B, Pos, Neg, Predicates) :-
    B = [
        from(X, Z),
        % Rule: all beans from this sack are white
        white(X) :- from(X,s1)
    ],
    Pos = [],
    Neg = [],
    Predicates = [sack, bean, white].
    % Goal = from(b1,s1).

run :-
    background_abduction(B, Pos, Neg, Predicates),
    create_background(B).

?- run.

#abducible from(X,Z).

% Result: These beans are white
% Query:
% ?- ??++ white(b1).

% Case: These beans are from this sack
% result: white holds for b1, because by abduction we conclude that from holds for b1, and s1
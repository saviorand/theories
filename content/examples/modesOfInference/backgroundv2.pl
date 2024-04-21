:- module(background, [background_induction/5, background_deduction/5, background_abduction/4]).
:- use_module(library(scasp)).

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


background_abduction(B, Pos, Neg, Predicates) :-
    B = [
        sack(s1),
        bean(X),
        from(X,Z),
        % white(Y),     
        % Rule: all beans from this sack are white
        white(X) :- from(X,s1),
        % Result: These beans are white
        white(b1)
    ],
    Pos = [],
    Neg = [],
    Predicates = [sack, bean, white].
    % Case: These beans are from this sack
    % Goal = from(b1,s1).






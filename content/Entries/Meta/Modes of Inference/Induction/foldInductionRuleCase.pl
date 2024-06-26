:- use_module(library(scasp)).
:- ensure_loaded('../../First-Order-Learner-of-Default/fold.pl').
:- ensure_loaded('../../functions/createBackground.pl').
:- ensure_loaded('../../functions/compareResults.pl').

ontology(O, Predicates) :-
    O = [
        sack(s1),
        bean(b1),
        white(Y)
    ],
    Predicates = [sack, bean, from_s1].

induction(Case, Positive, Negative, Result) :-
    Case = [
        from_s1(b1) % These beans are from this sack
        ],
    Positive = [b1],
    Negative = [],
    Result = white. % These beans are white 

run :-
    ontology(O, Predicates),
    induction(Case, Positive, Negative, Result),
    append(O, Case, OC),
    create_background(OC),
    fold(Result, Positive, Negative, OC, Predicates, D, AB, false),
    expected_model(ExpectedD),
    compare_results(D, ExpectedD),
    writeln('Test passed.').

expected_model(ExpectedD) :-
    ExpectedD = [
        % Rule: all beans from this sack are white
        white(A) :-
            from_s1(A)
    ].

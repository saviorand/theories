:- use_module(library(scasp)).
:- ensure_loaded('../../functions/createBackground.pl').
:- ensure_loaded('../../functions/compareResults.pl').

ontology(O) :-
    O = [
        sack(s1),
        bean(X),
        white(Y),
        from(X,Z)
    ].

deduction(Rule, Case, Result) :-
    Rule = [
        % All beans from this sack are white
        bean(B),
        white(B) :- from(B,s1)
        ],
    Case = [
        from(b1,s1) % These beans are from this sack
        ],
    Result = white(X). % These beans are white 

run :-
    ontology(O),
    deduction(Rule, Case, Result),
    append(O, Rule, OR),
    append(OR, Case, ORC),
    create_background(ORC),
    scasp(Result, [model(M), tree(T)]),
    expected_model(ExpectedM),
    compare_results(M, ExpectedM),
    writeln('Test passed.').

expected_model(ExpectedM) :-
    ExpectedM = [
        white(b1),
        from(b1,s1)
    ].
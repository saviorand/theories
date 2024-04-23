:- use_module(library(scasp)).
:- ensure_loaded('../../functions/createBackground.pl').
:- ensure_loaded('../../functions/compareResults.pl').

ontology(O) :-
    O = [
    ].

abduction(Rule, Case, Result) :-
    Rule = [
        white(X) :- from(X,s1) % All beans from this sack are white
        ],
    Case = [],
    Result = white(b1). % These beans are white 

% Defined on the top level
#abducible from(X,Z).

run :-
    ontology(O),
    abduction(Rule, Case, Result),
    append(O, Rule, OR),
    append(OR, Case, ORC),
    create_background(ORC),
    scasp(Result, [model(M), tree(T)]),
    expected_model(ExpectedM),
    compare_results(M, ExpectedM),
    writeln('Test passed.').

expected_model(ExpectedM) :-
    ExpectedM = [
        not-from(_,_), % what does this mean? not sure why it's included
        white(b1),
        from(b1,s1) % Case: These beans are from this sack (by abduction)
    ].

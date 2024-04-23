:- use_module(library(scasp)).
:- ensure_loaded('../../functions/inference.pl').

ontology(Ontology, Predicates) :-
    Ontology = [
        sack(s1),
        bean(b1),
        white(Y)
    ],
    Predicates = [sack, bean, from_s1].

theory(Case, Result) :-
    Case = [
        from_s1(b1), % These beans are from this sack
        positive(b1)
        ],
    Result = white. % These beans are white 

?- ontology(Ontology, Predicates), theory(Case, Result), inference(induction, Ontology, Predicates, [], Case, Result).
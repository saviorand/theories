:- use_module(library(scasp)).
:- ensure_loaded('../../functions/inference.pl').

% Induction

% ontology(Ontology, Predicates) :-
%     Ontology = [
%         sack(s1),
%         bean(b1),
%         white(Y)
%     ],
%     Predicates = [sack, bean, from_s1].

% theory(Rule, Case, Result) :-
%     Case = [
%         from_s1(b1), % These beans are from this sack
%         positive(b1)
%         ],
%     Result = white. % These beans are white 

% Induced "Rule": All beans from this sack are white
% ?- ontology(Ontology, Predicates), theory([], Case, Result), inference(induction, Ontology, Predicates, [], Case, Result).

% Deduction

% ontology(Ontology, Predicates) :-
%     Ontology = [
%         sack(s1),
%         bean(X),
%         white(Y),
%         from(X,Z)
%     ].

% theory(Rule, Case, Result) :-
%     Rule = [
%         % All beans from this sack are white
%         bean(B),
%         white(B) :- from(B,s1)
%         ],
%     Case = [
%         from(b1,s1) % These beans are from this sack
%         ],
%     Result = white(X). % These beans are white 

% ?- ontology(Ontology, []), theory(Rule, Case, Result), inference(deduction, Ontology, [], Rule, Case, Result).

% Abduction

ontology(Ontology, Predicates) :-
    Ontology = [].

theory(Rule, Case, Result) :-
    Rule = [
        white(X) :- from(X,s1) % All beans from this sack are white
        ],
    Case = [],
    Result = white(b1). % These beans are white 

% Defined on the top level
#abducible from(X,Z).

% Abduced "Case": These beans are from this sack
?- ontology(Ontology, []), theory(Rule, Case, Result), inference(abduction, Ontology, [], Rule, Case, Result). 


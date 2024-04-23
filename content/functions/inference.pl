:- use_module(library(scasp)).
:- ensure_loaded('./functions/createBackground.pl').
:- ensure_loaded('./First-Order-Learner-of-Default/fold.pl').

inference(Type, Ontology, Predicates, Rule, Case, Result) :-
    append(Ontology, Rule, OR),
    append(OR, Case, ORC),
    create_background(ORC),
    extract_pos_neg(ORC, Positive, Negative),
    (Type = deduction -> scasp(Result, [model(M), tree(T)]);
    Type = abduction -> scasp(Result, [model(M), tree(T)]);
    Type = induction -> fold(Result, Positive, Negative, ORC, Predicates, D, AB, false)).

extract_pos_neg(Background, Positive, Negative) :-
    findall(X, member(positive(X), Background), Positive),
    findall(X, member(negative(X), Background), Negative).
:- use_module(library(scasp)).
:- use_module(library(scasp/human)).
:- ensure_loaded('./createBackground.pl').
:- ensure_loaded('..//First-Order-Learner-of-Default/fold.pl').
:- style_check(-singleton).

% inference(Type, Ontology, Goal) :-
%     create_background(Ontology),
%     (Type = deduction -> scasp(Goal, [model(M), tree(T)]), print_justification(M, T);
%     Type = abduction -> scasp(Goal, [model(M), tree(T)]), print_justification(M, T);
%     Type = induction -> extract_predicates(Ontology, Predicates, Goal), 
%     extract_pos_neg(Ontology, Positive, Negative), 
%     fold(Goal, Positive, Negative, Ontology, Predicates, D, AB, false)).

inference(Ontology, Goal) :-
    inference(deduction, Ontology, Goal).

inference(Type, Ontology, Goal) :-
    create_background(Ontology),
    ( var(Type) -> ActualType = deduction ; ActualType = Type ),
    perform_inference(ActualType, Ontology, Goal).    

perform_inference(deduction, Ontology, Goal) :-
    scasp(Goal, [model(M), tree(T)]),
    print_justification(M, T).

perform_inference(abduction, Ontology, Goal) :-
    scasp(Goal, [model(M), tree(T)]),
    print_justification(M, T).

perform_inference(induction, Ontology, Goal) :-
    extract_predicates(Ontology, Predicates, Goal),
    extract_pos_neg(Ontology, Positive, Negative),
    fold(Goal, Positive, Negative, Ontology, Predicates, D, AB, false).

extract_pos_neg(Background, Positive, Negative) :-
    findall(X, member(positive(X), Background), Positive),
    findall(X, member(negative(X), Background), Negative).

extract_predicates(Ontology, UniquePredicates, Goal) :-
    findall(Predicate, (
        member(Term, Ontology),
        functor(Term, Predicate, _),
        \+ member(Predicate, [positive, negative, Goal])  % Exclude positive, negative and goal
    ), Predicates),
    sort(Predicates, UniquePredicates).  % Remove duplicates and sort

print_justification(Model, Tree) :-
    writeln('Model:'),
    with_output_to(string(MOut), human_model(Model, [])),
    writeln(MOut),
    with_output_to(string(TOut), human_justification_tree(Tree, [])),
    writeln('Justification Tree:'),
    writeln(TOut).
:- use_module(library(scasp)).
:- use_module(library(scasp/human)).
:- ensure_loaded('./functions/createBackground.pl').
:- ensure_loaded('./First-Order-Learner-of-Default/fold.pl').
:- style_check(-singleton).

inference(Type, Ontology, Predicates, Rule, Case, Result) :-
    append(Ontology, Rule, OR),
    append(OR, Case, ORC),
    create_background(ORC),
    extract_pos_neg(ORC, Positive, Negative),
    (Type = deduction -> scasp(Result, [model(M), tree(T)]), print_justification(M, T);
    Type = abduction -> scasp(Result, [model(M), tree(T)]), print_justification(M, T);
    Type = induction -> fold(Result, Positive, Negative, ORC, Predicates, D, AB, false)).

extract_pos_neg(Background, Positive, Negative) :-
    findall(X, member(positive(X), Background), Positive),
    findall(X, member(negative(X), Background), Negative).

print_justification(Model, Tree) :-
    writeln('Model:'),
    with_output_to(string(MOut), human_model(Model, [])),
    writeln(MOut),
    with_output_to(string(TOut), human_justification_tree(Tree, [])),
    writeln('Justification Tree:'),
    writeln(TOut).
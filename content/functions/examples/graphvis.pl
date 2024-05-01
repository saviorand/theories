% Dummy predicates for demonstration
predicate(parent).
predicate(child).
predicate(sibling).

% Relationships between predicates
relation(parent, child).
relation(child, sibling).

% Write predicates and their relationships to a DOT file
write_dot_file :-
    open('graph.dot', write, Stream),
    write(Stream, 'digraph prolog_graph {\n'),
    write_predicates(Stream),
    write_relations(Stream),
    write(Stream, '}\n'),
    close(Stream).

write_predicates(Stream) :-
    predicate(Predicate),
    format(Stream, '    "~w";\n', [Predicate]),
    fail.
write_predicates(_).

write_relations(Stream) :-
    relation(X, Y),
    format(Stream, '    "~w" -> "~w";\n', [X, Y]),
    fail.
write_relations(_).

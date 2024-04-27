rule_case_result(Ontology, Rule, Case, Result) :-
    Ontology = [],
    append(Ontology, Rule, OR),
    append(OR, Case, ORC),
    append(ORC, Result, ORCR).
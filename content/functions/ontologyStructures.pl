% In this rule case result example, rule and case are in the Ontology and Result is the Goal
rule_case(Rule, Case, Ontology) :-
    append(Rule, Case, Ontology).

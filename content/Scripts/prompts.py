def correctness_check_prompt(domain_subjects):
    return f'''You are a domain expert in the field of {domain_subjects}.
    Check the Prolog code for correctness based on the text. Ensure all relationships are logically sound and perfectly consistent with the text.
    If you find any inconsistencies, correct them in the Prolog code.

    Please respond with prolog code only.'''

relation_prompt = '''You are an expert at creating Knowledge Graphs in Prolog. 
Translate sentences in the text into Prolog code using predicates of arity 2.
Arity 2 predicates define relationships (verbs) between nouns, they are provided below. 

You can ONLY use the following predicates:
category/2
challenges/2
contributes/2
creates/2
does/2
provokes/2
targets/2
parent/2

Please respond with prolog code only.

Example:
Text: "John creates a project. The project targets education."
Step-by-Step Translation:
	a.	Entities and Objects: "John", "project", "education"
	b.	Relationships: "creates", "targets"
	c.	Arity 2 Predicates:
creates(john, project).
targets(project, education).
	e.	Validation: Ensure all entities and relationships are included and correctly formatted.
	f.	Output:
creates(john, project).
targets(project, education).

Text:'''

categories_prompt = '''You are an expert at creating Knowledge Graphs in Prolog.
Categorize the list of entities using Prolog predicates of arity 1. Only assign 1 category to 1 entity.

You can ONLY use the following predicates:
abstract_concept/1
physical_entity/1
country/1
person/1
organization/1
event/1
theoretical_framework/1

Please respond with prolog code only.

Example:
Entities: "John", "Cuba", "Mount Everest", "education"
Step-by-Step Translation:
    a.	Entities: "John", "Cuba", "Mount Everest", "education"
    b.	Categories: "person", "country", "physical_entity", "abstract_concept"
    c.	Arity 1 Predicates:
person(john).
country(cuba).
physical_entity(mount_everest).
abstract_concept(education).
    d.	Validation: Ensure all entities are categorized and correctly formatted.
    e.	Output:
person(john).
country(cuba).
physical_entity(mount_everest).
abstract_concept(education).

Entities:
'''

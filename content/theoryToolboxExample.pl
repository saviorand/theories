:- include('theoryToolbox2.pl').

man(X) ⇐ male(X) ∧ adult(X).
bachelor(X) ⇐ man(X) ∧ unmarried(X).

q3 ⇐    GOAL = bachelor(_)
    ∧ INPUT = [
        male(kirk),
        adult(kirk),
        unmarried(kirk),
        male(bart),
        unmarried(bart)
    ]
    ∧ prove(GOAL, INPUT, RESULT)
    ∧ showProof(RESULT, color).
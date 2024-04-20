:- ensure_loaded('../../First-Order-Learner-of-Default/fold.pl').
% :- reexport('background').

%% Induction

create_background([]).
create_background([H|T]):-
	asserta(H),
	create_background(T).

run :-
	B = [
        % Case: These beans are from this sack
        sack(s1),
        bean(b1),
        from_s1(b1)
	],
    % Result: These beans are white
	Pos = [b1],
	Neg = [],
	Predicates = [sack, bean, from_s1],
    Goal = white,

	create_background(B),
    % Rule: All beans from this sack are white
	fold(Goal, Pos, Neg, B, Predicates, D, AB, false),
	writeln(D),
	writeln(AB).
	
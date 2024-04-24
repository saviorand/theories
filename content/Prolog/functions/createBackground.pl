create_background([]).
create_background([H|T]):-
	asserta(H),
	create_background(T).
create_background([]).
create_background([H|T]):-
	asserta(H),
	create_background(T).

background :-
	create_background([
        % Case: These beans are from this sack
        sack(s1),
        bean(b1),
        from_s1(b1)
	]).
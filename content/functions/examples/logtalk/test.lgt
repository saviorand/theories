:- object(test).

    :- public(member/2).
    :- public(condition/1).

    condition(X) :- member(X, [1, 2, 3]).
    member(Head, [Head| _]).
    member(Head, [_| Tail]) :-
        member(Head, Tail).

:- end_object.
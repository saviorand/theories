:- module(test1, [test1/0]).
:- reexport('folder/testsubchild').

test1 :-
    writeln('Hello, World! 1').

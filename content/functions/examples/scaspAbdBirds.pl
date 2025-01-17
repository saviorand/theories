:- use_module(library(scasp)).

#abducible wounded_bird(X).
#abducible penguin(X).
#abducible ab(X).

% Sam, Tweety and John are birds.
bird(sam).
bird(tweety).
bird(john).

% penguins and wounded birds are abnormal
ab(X) :- penguin(X).
ab(X) :- wounded_bird(X).

% birds that are not abnormal can fly
flies(X) :- bird(X), not ab(X).
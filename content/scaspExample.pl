:- use_module(library(scasp)).

opera(D) :- not home(D).
home(D):- not opera(D).
home(monday).

false :- baby(D), opera(D).

baby(tuesday).
:- use_module(library(scasp)).

%% Background
#pred sack(X) :: '@(X) is a sack'.
sack(s1).

#pred bean(X) :: '@(X) is a bean'.
bean(X).

#pred white(X) :: '@(X) is white'.
white(Y).

#pred from(X,Z) :: '@(X) is from @(Z)'.
from(X,Z).
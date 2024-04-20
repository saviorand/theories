:- reexport('background').

%% Deduction

% Rule; all beans from this sack are white
white(X) :- from(X,s1).

% Case: These beans are from this sack
from(b1,s1).

% Result: These beans are white 
% Query:
% white(X). Results: X = b1

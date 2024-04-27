:- use_module(library(scasp)).
:- ensure_loaded('../../functions/inference.pl').

% Induction

% ?- inference(induction, [
%     sack(s1),
%     bean(b1),
%     white(Y),
%     from_s1(b1), % Case: These beans are from this sack
%     positive(b1)
% ], white). % Result: These beans are white 
% % Induced "Rule": All beans from this sack are white

% Deduction

% ?- inference(deduction, [
%     sack(s1),
%     bean(X),
%     white(Y),
%     from(X,Z),
%     bean(B),
%     white(B) :- from(B,s1), % Rule: All beans from this sack are white
%     from(b1,s1) % Case: These beans are from this sack
% ], white(X)).
% % Deduced Result: These beans are white

% Abduction

% Abducibles defined on the top level
#abducible from(X,Z).

?- inference(abduction, [
    white(X) :- from(X,s1) % Rule: All beans from this sack are white
    ], white(b1)). % These beans are white 
% Abduced "Case": These beans are from this sack

:- use_module(library(scasp)).
% :- include('theoryToolbox2.pl').

% man(X) ⇐ male(X) ∧ adult(X).
% bachelor(X) ⇐ man(X) ∧ unmarried(X).

% q3 ⇐    GOAL = bachelor(_)
%     ∧ INPUT = [
%         male(kirk),
%         adult(kirk),
%         unmarried(kirk),
%         male(bart),
%         unmarried(bart)
%     ]
%     ∧ prove(GOAL, INPUT, RESULT)
%     ∧ showProof(RESULT, color).

% ?- q3.

% PROOF

% bachelor(kirk) ⇐
%      man(kirk) ⇐
%           male(kirk) ⇐ true
%           adult(kirk) ⇐ true
%      unmarried(kirk) ⇐ true
% true 

#pred male(X) :: '@(X) is male'.
#pred adult(X) :: '@(X) is an adult'.
#pred unmarried(X) :: '@(X) is unmarried'.

#pred man(X) :: '@(X) is a man'.
man(X) :-
    male(X),
    adult(X).

#pred bachelor(X) :: '@(X) is a bachelor'.
bachelor(X) :-
    man(X),
    unmarried(X).

male(kirk).
adult(kirk).
unmarried(kirk).

male(bart).
unmarried(bart).

% s(CASP) justification
% query ←
%    bachelor(kirk) ←
%       man(kirk) ←
%          male(kirk) ∧
%          adult(kirk) ∧
%       unmarried(kirk) ;    
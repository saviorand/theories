:- use_module(library(scasp)).
:- use_module(library(scasp/human)).

#pred player('G', 'X') :: '@(X) played in @(G)'.
#pred winner('Game','Player') :: 'The winner of @(Game) is @(Player)'.
#pred throw('Player','Sign') :: '@(Player) threw @(Sign)'.
#pred beat('Sign','OtherSign') :: '@(Sign) beats @(OtherSign)'.

beat(rock,scissors).
beat(scissors,paper).
beat(paper,rock).

#abducible player(Game, Player).
#abducible throw(Player, Sign).

winner(Game,Player) :-
  player(Game, Player),
  player(Game, OtherPlayer),
  throw(Player,Sign),
  throw(OtherPlayer,OtherSign),
  beat(Sign,OtherSign).

% sCASP encoding of rps
% Reference: Jason's article at https://medium.com/computational-law-diary/how-rules-as-code-makes-laws-better-115ab62ab6c4

% :- use_module(library(scasp)).
%% :- style_check(-discontiguous).
% :- style_check(-singleton).
%% :- set_prolog_flag(scasp_unknown, fail).

% #pred player(X) :: '@(X) is a player'.
% #pred participate_in(Game,Player) :: '@(Player) participated in @(Game)'.
% #pred winner(Game,Player) :: '@(Player) is the winner of @(Game)'.
% #pred throw(Player,Sign) :: '@(Player) threw @(Sign)'.
% #pred beat(Sign,OtherSign) :: '@(Sign) beats @(OtherSign)'.
% #pred game(G) :: '@(G) is a game of rock-paper-scissors'.
% #pred not_same_player(X,Y) :: '@(X) and @(Y) are not the same player'.

% beat(rock,scissors).
% beat(scissors,paper).
% beat(paper,rock).

% not_same_player(X,Y) :-
%     X \= Y.

% game_has_two_different_players(Game,Player,OtherPlayer) :-
%     game(Game),
%     player(Player),
%     not_same_player(Player,OtherPlayer), % In this version, the disequality needs to be here or lower
%     player(OtherPlayer),
%     participate_in(Game,Player),
%     participate_in(Game,OtherPlayer).

% winner2(Game,Player) :-
%   game_has_two_different_players(Game,Player,OtherPlayer),
%   throw(Player,Sign),
%   throw(OtherPlayer,OtherSign),
%   beat(Sign,OtherSign).

% winner(Game,Player) :-
%   game(Game),
%   player(Player), % Ungrounded only works if the disequality is below here, because disequality over unground variables fails.
%   player(OtherPlayer),
%   participate_in(Game,Player),
%   throw(Player,Sign), % not winner/2 only works if the disequality is above here.
%   not_same_player(Player,OtherPlayer),
%   participate_in(Game,OtherPlayer),
%   throw(OtherPlayer,OtherSign),
%   beat(Sign,OtherSign).

% % game(G) - add a list of games.
% % player(P) - add a list of players.
% % player(O) - add another list of players (same as the first list).
% % participate_in(P,G) - remove all combinations of the three lists where P didn't participate in G.
% % throw(P,S) - add a sign column to the first list of players.
% % participate_in(O,G) - remove all combinations of the lists where O not particpating in G
% % throw(O,OS) - add a sign column to the list of other players.
% % beat(S,OS) - remove all combinations of the three lists where S doesn't bean OS.
% % P \= O - remove all combinations of the three lists where P is the same as O.
% % For whatever is left, prove winner(G,P).

% % Now s(CASP) creates a dual program that works like this:
% % If G is not a game, prove not winner(G,P).
% % If G is a game, but P is not a player, prove not winner(G,P).
% % ...
% % skipping to the first one that doesn't work.
% % If G is a game, P is a player, O is a player, P played in G,
% % P threw S, but P = O, prove not winner(G,P).
% % It always seems to fail on the one where the disequality was added
% % as the new consideration.
% % 
% % So that breaks down into these instructions:
% % add a list of games.
% % add a list of players
% % add another list of players
% % remove all combinations of the three lists where the first player didn't play in a game.
% % add a sign to the first list of players
% % discard all combinations where P is not O
% % for anything left, prove not winner(P,G).

% % testgame	bob		bob
% % 					jane
% % testgame bob bob
% % testgame bob jane
% %
% % testgame bob bob bob_participated
% % testgame bob jane bob_participated
% % 
% % testgame bob bob bob_participated rock
% % testgame bob jane bob_participated rock
% %
% % delete first line, because bob = bob.
% % 
% % We are left with one line, which proves not winner(testgame, bob).
% %
% % So the problem is that the two players being the same player is
% % good evidence to exclude them from the definition of winner, but the
% % is not good evidence to include them in the definition of not winner.
% % 
% % The one remaining line should ALSO have been eliminated. Why?
% % because the fact that bob participated in a game with jane and threw
% % rock is insufficient evidence that he didn't win.
% % 
% % In order for the default negation to work, things that need to be
% % considered at the same time need to be in the same predicate?
% % Like, the fact that bob played, and jane played, and they are not
% % the same person, are not factors in and of themselves. They are
% % only meaningful in combination?
% % 
% % Yes. Moving to game_has_two_players, and putting the related things
% % there solves the negation problem for line position. The disequality
% % still needs to be grounded inside the new predicate.
% %
% % I still don't understand why the problem only shows up then, and not
% % earlier. I also still don't understand why the justification is going
% % through the factors three times.
% %
% % OK, how to explain this:
% % Need to figure out if this is being caused because the goal doesn't
% % include the element that is being compared against, or if that would
% % fail, too.
% %
% % No, adding the losing player to winner doesn't fix anything.
% % What about taking it out of the other one? That doesn't work.
% % So the thing that is actually helping might be that moving it into
% % a separate predicate grounds the disequality, somehow?
% %
% % Not clear on the why, still.
% %
% % It feels like you are defining the positive and the default negation
% % at the same time. So the things that you want to include are things
% % that:
% % a) are a necessary condition of the predicate holding, AND
% % b) their negation is, in and of itself, a necessary condition of the
% %    the thing not holding true.
% %
% % So the question to ask is: Must this always be true for the conclusion
% % to hold, and does the conclusion always not hold when this thing is false
% % and the things above it are true.
% % 
% % Or, you can avoid the concern about "things above it" if you limit
% % conditions to things that are necessarily true of the positive scenario,
% % and which are also necessarily false of the default negation of that scenario.
% % 
% %  game(Game), % both are true. A winner needs a game. No game, no winner.
% %  player(Player), % A winner needs the player. If there is no player, there is no winner.
% %  player(OtherPlayer), % A winner needs a player. If there is no player, there is no winner.
% %  participate_in(Game,Player), % A winner must have participated. If there is no participant, there is no winner.
% %  throw(Player,Sign), % A winner requires a throw. If there is no throw, there is no winner.
% %  not_same_player(Player,OtherPlayer), % A winner requires that the players not be the same. But in the context of the above lines, the fact that someone is both players does not mean they are not the winner.
% %  participate_in(Game,OtherPlayer), % A winner must have beaten someone who participated. If there is no other player, there is no winner.
% %  throw(OtherPlayer,OtherSign), % A winner requires that the other person threw a sign. If the other player did not throw a sign, there is no winner.
% %  beat(Sign,OtherSign). % A winner requires a winning relationship between the two throws. If there is no winning relationship, there is no winner.
% %
% % If we compare that to the winner2 above, in winner2 it is true that
% % there being a game with two players is always a necessary condition, AND
% % that the absence of that condition also indicates the absence of a winner.
% %
% % Inside game_has_two_players, the disjunction is necessary of true, and its
% % absence is sufficient for the default negation. If the two players are
% % not different, the predicate is always false.
% %		
% % There is still something about including the things about which you
% % are defining the relationship in the predicate. If I exclude them, things
% % don't work as well...

% % There is a Game in which Bob and Jane played.
% game(testgame).
% player(bob).
% player(jane).
% participate_in(testgame,bob).
% participate_in(testgame,jane).
% throw(bob,rock).
% throw(jane,scissors).

% /** <examples> Your example queries go here, e.g.
% ?- ? winner(testgame,Who).
% */

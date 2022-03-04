%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Revision operators
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

objective(Ac):- collaborative(Ac).
objective(Ac):- primitive(Ac).
objective(Ac):- abstract(Ac).

abstract(-1):- #false.
primitive(-1):- #false.

% Remove a responsibility from an agent keeping nothing fixed
% (that is action-allocations and time may vary)
:- relieve(Ac, Ag), expedite(Ac, Ag, T), step(T).

%:-  relieve(Ac, Ag), expedite(Ac, Ag, T), step(T).
:- relieve(B, A), not agent(A). 

% Schedule a particular action at a particular time.
expedite(Ac, Ag, T):- schedule(Ac, Ag, T).

% Respect the constraints on competence when scheduling
% tasks for agents
:- schedule(Ac, Ag, T), delegate(Ac, _, Crew),  not competent(Ag, Ac).
competent(Ag, Ac):- delegate(Ac, _, Crew), member(Ag, Crew).

% Allocate an action to an agent. Dont care about time.
1{expedite(Ac, Ag, X): step(X)}1:-  delegate(Ac, Ag).

% Shuffle allocations. Keep task structure intact
T1 = T2 :- expedite(Ac, Ag1, T1), previous(Ac, Ag2, T2), shuffle.
shuffled :- delegate(Ac, N, Crew),
	    M = #count{Ag: member(Ag, Crew)},
	    N < M, 
	    expedite(Ac, Ag1, T),
	    not previous(Ac, Ag1, T).

:- shuffle, not shuffled.


% Backpropagate
responsible(Ac, Ag) :- expedite(Ac, Ag, T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 The maxim of minimal change
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:~ expedite(Ac, Ag, T), not previous(Ac, Ag, T), not shuffle. [1@1]
:~ previous(Ac, Ag, T), not expedite(Ac, Ag), not shuffle. [1@1] 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Suppress warnings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

shuffle:- #false.
previous(-1, -1, -1):- #false.
delegate(-1, -1):- #false.
relieve(-1, -1):- #false.
expedite(-1, -1):- #false.
schedule(-1, -1, -1):- #false.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Output/Queries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show .
#show expedite/3.
%#show expedite(Ac, Ag, T, D): expedite(Ac, Ag, T), primitive(Ac), description(Ac, D).
%#show participate(Ac, Ag, T, D): expedite(Ac, Ag, T), collaborative(Ac),  description(Ac, D).
					 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Generate responsibilities/delegate actions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N{responsible(Ac, Ag): member(Ag, Group)}N :-  delegate(Ac, N, Group).
{deploy(X): objective(X)}.

:- not {deploy(Ac): abstract(Ac1), subtask(Ac1, Ac)}1. 

% All mandatory tasks are deployd
:- mandatory(X), not deploy(X).

% Dont deploy non-selected subtasks
:- not mandatory(Ac), deploy(Ac).

% Inherit mandatoriness to substasks
mandatory(Ac2):- sub(Ac1, Ac2), deploy(Ac2), mandatory(Ac1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Suppress warnings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sub(-1,-1):- #false.
subtask(-1,-1):- #false.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Projections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delegated(Ac):-  delegate(Ac, _, _).
expedited_by(Ac, Ag):- expedite(Ac, Ag, T).
expedited_at(Ac, T):- expedite(Ac, _, T).
concurrent(Ac1, Ac2):- expedite(Ac1, Ag1, T), expedite(Ac2, Ag1, T),  Ac1 != Ac2.
something_done(T):- expedite(_,_,T).
someone_does(Ac, T):- expedite(Ac, _, T).
preceded(Ac1):- expedited_at(Ac1, T), expedited_at(Ac2, T-1), step(T).

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Temporalize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


step(1..Y+1):- Y = #count{Ac, Ag: responsible(Ac, Ag)}.
1{expedite(Ac, Ag, T): step(T)}1 :- responsible(Ac, Ag).

:- someone_does(Ac, T), T>1, not preceded(Ac). % Actions form a cohesive time-sequence
:- someone_does(Ac1, T1), someone_does(Ac2, T2), not  T1 < T2, pred(Ac2, Ac1). % Respect the ordering constraints on actions
first :- something_done(1). % Sequence starts at timestep 1.
:- not first.                  % Sequence starts at timestep 1.

% Other requirements
:- concurrent(Ac1, Ac2).  % An agent can only participate in one action at a time
T1 = T2 :- expedited_at(Ac, T1), expedited_at(Ac, T2). % An action only occurs once. % implicit in time compression


% Choose a timestep if none is provided
1{expedite(Ac, Ag, X): step(X)}1:-  delegate(Ac, Ag).


#minimize{T:  expedite(Ac, Ag, T)}.

% Def. agent
agent(X):- member(X, agent).

% Subclass reasoning
subclass(A, B):- is_subclass(A, B).
subclass(A, C):- is_subclass(A, D), subclass(D, C).

% Membership ascriptions
member(A, C):- is_a(A, C).
member(A, C):- is_a(A, D), subclass(D, C).

class(agent).

% https://github.com/Markusdreyer/delegation-sequencing/issues/10
% assigned(Ac):- responsible(Ac, Ag).
% :- not assigned(Ac), objective(Ac).


primitive(a) . 
responsible(a, Ag) :- deploy(a), property(Ag, driver), member(Ag, aecrew). 
description(a, "Attack engine crew turn-out") .
mandatory(a) .

primitive(b) . 
delegate(b, 1, secrew) :- deploy(b) . 
description(b, "Second attack engine crew turn-out") .
mandatory(b) .

primitive(c) . 
delegate(c, 1, ltcrew) :- deploy(c) . 
description(c, "Ladder department turn-out") .
mandatory(c) .

primitive(d) . 
delegate(d, 1, aecrew) :- deploy(d) . 
description(d, "Travel of attack engine crew to 911 address") .
mandatory(d) .

primitive(e) . 
delegate(e, 1, secrew) :- deploy(e) . 
description(e, "Travel of second engine crew to 911 address") .
mandatory(e) .

primitive(f) . 
delegate(f, 1, ltcrew) :- deploy(f) . 
description(f, "Travel of ladder tower crew to 911 address") .
mandatory(f) .

primitive(g) . 
delegate(g, 1, aecrew) :- deploy(g) . 
description(g, "Attack engine crew advance 1.75 inch hose to seat of fire") .
mandatory(g) .

primitive(h) . 
delegate(h, 1, aecrew) :- deploy(h) . 
description(h, "Attack engine driver prepare to pump water") .
mandatory(h) .

primitive(i) . 
delegate(i, 1, aecrew) :- deploy(i) . 
description(i, "Attack fire with tank water aboard attack engine") .
mandatory(i) .

primitive(j) . 
delegate(j, 1, secrew) :- deploy(j) . 
description(j, "Second engine crew member prepare nearest hydrant for hook-up") .
mandatory(j) .

primitive(k) . 
delegate(k, 1, secrew) :- deploy(k) . 
description(k, "Second engine drop 5 inch hose between attack engine and nearest hydrant") .
mandatory(k) .

primitive(l) . 
delegate(l, 1, secrew) :- deploy(l) . 
description(l, "Second engine hook to hydrant and attack engine and prepare to pump water") .
mandatory(l) .

primitive(m) . 
delegate(m, 1, secrew) :- deploy(m) . 
description(m, "Attack fire with hydrant water") .
mandatory(m) .

primitive(n) . 
delegate(n, 1, ltcrew) :- deploy(n) . 
description(n, "Set up ladder tower") .
mandatory(n) .

pred(d, a) .
pred(e, b) .
pred(f, c) .
pred(g, d) .
pred(h, g) .
pred(i, h) .
pred(j, e) .
pred(k, e) .
pred(l, k) .
pred(m, l) .
pred(n, f) .


is_subclass(aecrew, agent).
is_a(john, aecrew).
is_a(frank, aecrew).
is_subclass(secrew, agent).
is_a(jan, secrew).
is_a(liz, secrew).
is_a(kathrinHolmsen, secrew).
is_subclass(ltcrew, agent).
is_a(xi, ltcrew).
is_a(jeremyLin, ltcrew).
is_a(dahn, ltcrew).
is_a(plJrgensen, aecrew).
property(plJrgensen, driver).
is_a(plJrgensen, driver).

:-
	assertz(equip('12AAAFCR5',100,500,100,'comment')),
	assertz(equip('11WERJJJJ',200,600,100,'comment2')),
	assertz(equip('78DEQ2314',300,700,300,'comment3')).

help:-
	write('manual:'),nl,
	write('revenue(X) - to get X as total revenue'), nl,
	write('average_rev(Y) - to get Y as average revenue'), nl,
	write('new_fact(Id, Value, Revenue, Costs, Comm) - to add tuple to the database with respective values'), nl,
	write('remove_fact(Id) - to remove tuple with its Code = Id'), nl,
	write('show - to show current database'), nl.
revenue(X) :-
	findall(Id, equip(Id, _, _, _, _), List),
	revenue(List, X).
revenue([Id | List], X) :-
	revenue(List, X1),
	equip(Id, A, B, C, _),
	X is X1 + B - A - C.
revenue([], X) :-
	X is 0.

average_rev(X) :-
	findall(Id, equip(Id, _, _, _, _), List),
	length(List, N),
	revenue(R),
	X is R / N.
	
new_fact(Id, Value, Revenue, Costs, Comm) :-
  (
  string_length(Id, L),
  L = 9 -> 
  not(equip(Id, _, _, _, _)),
  assertz(equip(Id, Value, Revenue, Costs, Comm));
  write('Error : Code must contain EXACTLY 9 characters')
  ).

remove_fact(Id) :-
  equip(Id, Value, Revenue, Costs, Comm),
  retract(equip(Id, Value, Revenue, Costs, Comm)).
  
show :-
	write('Code, Value, Revenue, Costs, Commentary'), nl,
	findall(Id, equip(Id, _, _, _, _), List),
	show(List).
show([Id | Tail]) :-
	equip(Id, Value, Revenue, Costs, Comm),
	write(Id),write(','),write(Value),write(','),
	write(Revenue),write(','),write(Costs),write(','),write(Comm), nl,
	show(Tail).
show([]).
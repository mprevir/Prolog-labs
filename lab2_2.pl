:- initialization(goal).

goal :-
  new(Dir, directory('.')),
  new(Frame, frame('Select file')),
  new(Browser, browser),
  new(Dialog, dialog),
  send(Dialog, append, button('Open', message(@prolog, procfile, Browser?selection?key))),
  send(Dialog, append, button('Quit', message(@prolog, halt))),
  send(Browser, members(Dir?files)),
  send(Frame, append, Browser),
  send(Dialog, below, Browser),
  send(Frame, open).

procfile(Fname) :-
	write(Fname), nl, flush_output,
	see(Fname), read_list(List), seen,
	write(List), nl, flush_output,
	addwordf(List, Fname).
	
read_list(List) :-
  (
    at_end_of_stream ->
      List = [];
      read(Pair), read_list(List1), List = [Pair | List1]
  ).	
	
addwordf(List, Fname) :-
	new(D, dialog('Word adding')),
	new(Txt1, text_item(key)),
	new(Txt2, text_item(value)),
	send(D, append, Txt1),
	send(D, append, Txt2),
	send(D, append, button('Add', message(@prolog, insert, prolog(List), Txt1?selection, Txt2?selection, Fname))),
	send(D, open).

/*wordadd([K1/V1 | Tail], Key, Value, Fname) :-
	(
		ListIn = [K1/V1 | Tail],
		member(Key/_, ListIn) ->
		ListOut = ListIn;
		(
		Key<K1 ->
		ListOut = [Key/Value | ListIn];
		wordadd(Tail, Key, Value, Fname)
		)
	),
	modify(Fname),
	writelist(ListOut), nl, flush_output, told.*/
	
insert(Key/Val, [], [Key, Val], Fname).
insert(Key/Val, [[Key | LstVal] | T], [[Key, Val | LstVal] | T], Fname) :- !.
insert(Key/Val, [H | T], [H | T1], Fname) :-
    insert([Key, Val], T, T1, Fname).
	
writelist([K | Tail]):-
	write(K),
	nl,
	writelist(Tail).
writelist(_).

%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Mar 2020 10:51
%%%-------------------------------------------------------------------
-module(recursive).
-author("tumilok").

%% API
-export([fac/1, len/1,tail_fac/1, tail_fac/2, tail_len/1, tail_len/2, duplicate/2, tail_duplicate/2, tail_duplicate/3,
  reverse/1, tail_reverse/1, tail_reverse/2, sublist/2, tail_sublist/2, tail_sublist/3, zip/2, tail_zip/2, tail_zip/3,
  quicksort/1, partition/4, lc_quicksort/1]).

fac(0) -> 1;
fac(N) when N > 0 -> N * fac(N-1).

len([]) -> 0;
len([_|T]) -> 1 + len(T).

tail_fac(N) -> tail_fac(N, 1).

tail_fac(0,Acc) -> Acc;
tail_fac(N, Acc) when N > 0 -> tail_fac(N-1,N*Acc).

tail_len(L) -> tail_len(L, 0).

tail_len([], Acc) -> Acc;
tail_len([_|T], Acc) -> tail_len(T, 1 + Acc).

duplicate(0,_) ->
  [];
duplicate(N,Term) when N > 0 ->
  [Term|duplicate(N-1,Term)].

tail_duplicate(N, Term) -> tail_duplicate(N, Term, []).

tail_duplicate(0, _, List) ->
  List;
tail_duplicate(N, Term, List) when N > 0 ->
  tail_duplicate(N-1, Term, [Term|List]).

reverse([]) -> [];
reverse([H|T]) -> reverse(T)++[H].

tail_reverse(L) -> tail_reverse(L,[]).

tail_reverse([],Acc) -> Acc;
tail_reverse([H|T],Acc) -> tail_reverse(T, [H|Acc]).

sublist([], _) -> [];
sublist(_, 0) -> [];
sublist([H|T], N) when N > 0 -> [H|sublist(T, N-1)].

tail_sublist(List, N) -> tail_sublist(List, N, []).

tail_sublist([], _, Sublist) -> Sublist;
tail_sublist(_, 0, Sublist) -> Sublist;
tail_sublist([H|T], N, Sublist) when N > 0 ->
  tail_sublist(T, N-1, Sublist++[H]).

zip([],_) -> [];
zip(_,[]) -> [];
zip([X|Xs],[Y|Ys]) -> [{X,Y}|zip(Xs, Ys)].

tail_zip(Xs, Ys) -> tail_zip(Xs, Ys, []).

tail_zip([],_,Res) -> Res;
tail_zip(_,[],Res) -> Res;
tail_zip([X|Xs],[Y|Ys],Res) -> tail_zip(Xs, Ys,Res ++ [{X,Y}]).

quicksort([]) -> [];
quicksort([Pivot|Rest]) ->
  {Smaller, Larger} = partition(Pivot, Rest, [], []),
  quicksort(Smaller) ++ [Pivot] ++ quicksort(Larger).

partition(_,[], Smaller, Larger) -> {Smaller, Larger};
partition(Pivot, [H|T], Smaller, Larger) ->
  if H =< Pivot -> partition(Pivot, T, [H|Smaller], Larger);
     H >  Pivot -> partition(Pivot, T, Smaller, [H|Larger])
  end.

lc_quicksort([]) -> [];
lc_quicksort([Pivot|Rest]) ->
  lc_quicksort([Smaller || Smaller <- Rest, Smaller =< Pivot])
  ++ [Pivot] ++
    lc_quicksort([Larger || Larger <- Rest, Larger > Pivot]).
%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Mar 2020 14:29
%%%-------------------------------------------------------------------
-module(qsort).
-author("tumilok").

%% API
-export([lessThan/2, grtEqThan/2, qs/1, randomElems/3, compareSpeeds/3]).

lessThan(List, Arg) -> [X || X <- List, X < Arg].

grtEqThan(List, Arg) -> [X || X <- List, X >= Arg].

qs([]) -> [];
qs([Pivot|Tail]) -> qs( lessThan(Tail,Pivot) ) ++ [Pivot] ++ qs( grtEqThan(Tail,Pivot) ).

randomElems(N,Min,Max) -> [random:uniform(Max - Min) + Min || _ <- lists:seq(1, N)].

compareSpeeds(List, Fun1, Fun2) ->
  {T1,_} = timer:tc(Fun1, [List]),
  {T2,_} = timer:tc(Fun2, [List]),
  io:format("First function time: ~b~nSecond function time: ~b~n", [T1,T2]).
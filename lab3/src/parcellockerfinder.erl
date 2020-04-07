%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Apr 2020 22:47
%%%-------------------------------------------------------------------
-module(parcellockerfinder).
-author("tumilok").

%% API
-compile(export_all).

getClosestLocker({Xp, Yp}, [{Xl, Yl}|T], Dist) ->
  case abs(Xp - Xl) + abs(Yp - Yl) =:= Dist of
    true -> {Xl, Yl};
    _ -> getClosestLocker({Xp, Yp}, T, Dist)
  end.

getData(Pairs, N) when N > 0 ->
  receive
    H when is_list(H) ->
      getData(H ++ Pairs, N - 1);
    H ->
      getData([H | Pairs], N - 1)
  end;
getData(Pairs, _) -> Pairs.

findMyParcelLockerSequential(PersonLocation={Xp, Yp}, LockerLocations) ->
  Dist = lists:min([abs(Xp - Xl) + abs(Yp - Yl) ||  {Xl, Yl} <- LockerLocations]),
  {PersonLocation, getClosestLocker(PersonLocation, LockerLocations, Dist)}.

findMyParcelLockerParallel(PersonLocation={Xp, Yp}, LockerLocations, Parent) ->
  Dist = lists:min([abs(Xp - Xl) + abs(Yp - Yl) ||  {Xl, Yl} <- LockerLocations]),
  Parent ! {PersonLocation, getClosestLocker(PersonLocation, LockerLocations, Dist)}.

execSequential([], _, Pairs) -> Pairs;
execSequential([H | T], Lockers, Pairs) ->
  Pair = findMyParcelLockerSequential(H, Lockers),
  execSequential(T, Lockers, [Pair | Pairs]).

execParallel([], _) -> getData([], 1000);
execParallel([H | T], Lockers) ->
  spawn(?MODULE, findMyParcelLockerParallel, [H, Lockers, self()]),
  execParallel(T, Lockers).

execHalfParallel([], _, Pairs, Parent) -> Parent ! Pairs;
execHalfParallel([H|T], Lockers, Pairs, Parent) ->
  execHalfParallel(T, Lockers, [findMyParcelLockerSequential(H, Lockers)|Pairs], Parent).

execHalfParallelAll(_, _, Step, 0, Beginner) -> getData([], Beginner div Step);
execHalfParallelAll(People, Lockers, Step, CoreNum, Beginner) ->
  spawn(?MODULE, execHalfParallel, [lists:sublist(People, Beginner, Step), Lockers, [], self()]),
  execHalfParallelAll(People, Lockers, Step, CoreNum - 1, Beginner + Step).

generateLocations(N, Min, Max) when is_integer(N), is_integer(Min), is_integer(Max)->
  [{rand:uniform(Max) + Min, rand:uniform(Max) + Min} || _ <- lists:seq(1, N)].

test() ->
  People = generateLocations(1000, 0, 10000),
  Lockers = generateLocations(10000, 0, 10000),
  {T1, _} = timer:tc(?MODULE, execSequential, [People, Lockers, []]),
  io:format("Seq time: ~b ~n", [T1]),
  {T2, _} = timer:tc(?MODULE, execParallel, [People, Lockers]),
  io:format("Parallel time: ~b ~n", [T2]),
  {T3, _} = timer:tc(?MODULE, execHalfParallelAll, [People, Lockers, 250, 4, 1]),
  io:format("Half parallel time: ~b ~n", [T3]),
  ok.
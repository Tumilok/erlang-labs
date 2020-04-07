%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Apr 2020 21:52
%%%-------------------------------------------------------------------
-module(pingpong).
-author("tumilok").

%% API
-export([start/0, stop/0, play/1]).

start() ->
  register(ping, spawn(fun() -> ping(0) end)),
  register(pong, spawn(fun pong/0)).

stop() ->
  ping ! stop,
  pong ! stop.

play(N) when is_integer(N) ->
  ping ! N.

ping(Sum) ->
  receive
    N when is_integer(N), N > 0 ->
      io:format("ping - n: ~p, sum: ~p~n", [N, Sum + N]),
      timer:sleep(500),
      pong ! N - 1,
      ping(Sum + N);
    stop -> ok
  after
    20000 -> ok
  end.

pong() ->
  receive
    N when is_integer(N), N > 0 ->
      io:format("pong - n: ~p~n", [N]),
      timer:sleep(500),
      ping ! N - 1,
      pong();
    stop -> ok
  after
    20000 -> ok
  end.
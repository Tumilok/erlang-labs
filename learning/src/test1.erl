%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Mar 2020 23:58
%%%-------------------------------------------------------------------
-module(test1).
-author("tumilok").

%% API
-export([add/2, hello/0, greet_and_add_two/1]).
-import(io, [format/1]).

add(A,B) ->
  A + B.

hello() ->
  format("Hello, world!~n").

greet_and_add_two(X) ->
  hello(),
  add(X, 2).
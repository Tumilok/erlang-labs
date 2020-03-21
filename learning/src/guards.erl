%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Mar 2020 00:36
%%%-------------------------------------------------------------------
-module(guards).
-author("tumilok").

%% API
-export([old_enough/1, right_age/1, wrong_age/1]).

old_enough(X) when X >= 16 -> true;
old_enough(_) -> false.

right_age(X) when X >= 16, X =< 104 ->
  true;
right_age(_) ->
  false.

wrong_age(X) when X < 16; X > 104 ->
  true;
wrong_age(_) ->
  false.
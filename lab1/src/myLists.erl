%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Mar 2020 12:21
%%%-------------------------------------------------------------------
-module(myLists).
-author("tumilok").

%% API
-export([contains/2, duplicateElements/1]).

contains([], _) -> false;
contains([H|T], H) -> true;
contains([_|T], N) -> contains(T, N).

duplicateElements([]) -> [];
duplicateElements([H|T]) -> [H, H] ++ duplicateElements(T).

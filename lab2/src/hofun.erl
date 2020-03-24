%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Mar 2020 15:28
%%%-------------------------------------------------------------------
-module(hofun).
-author("tumilok").

%% API
-export([map/2, filter/2, numToList/1, sum/2, sumOfDigits/1, canDivideSumOfDigitsByThree/1]).

map(_, []) -> [];
map(F, [H|T]) -> [F(H)|map(F,T)].

filter(F, L) -> [X  || X <- L, F(X)].

numToList(0) ->[];
numToList(X) -> [X rem 10 | numToList(X div 10)].

sum(A, B) -> A + B.

sumOfDigits(X) -> lists:foldl(fun sum/2, 0, numToList(X)).

canDivideSumOfDigitsByThree(L) -> filter(fun (X) -> sumOfDigits(X) rem 3 == 0 end, L).



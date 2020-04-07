%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Mar 2020 13:36
%%%-------------------------------------------------------------------
-module(onp).
-author("tumilok").

%% API
-export([onp/1, iterate/2, onp/2, read/1, onp_test/0]).

onp(L) when is_list(L) ->
  iterate(string:tokens(L, " "), []).

iterate([], [Res]) -> Res;
iterate([H|T], Res) -> iterate(T, onp(H, Res)).

onp("+", [X1,X2|S]) -> [X2+X1|S];
onp("-", [X1,X2|S]) -> [X2-X1|S];
onp("*", [X1,X2|S]) -> [X2*X1|S];
onp("/", [X1,X2|S]) -> [X2/X1|S];
onp("pow", [X1,X2|S]) -> [math:pow(X2,X1)|S];
onp("sqrt", [X|S]) -> [math:sqrt(X)|S];
onp("sin", [X|S]) -> [math:sin(X)|S];
onp("cos", [X|S]) -> [math:sin(X)|S];
onp("tan", [X|S]) -> [math:sin(X)|S];
onp(X, S) -> [read(X)|S].

read(N) ->
  case string:to_float(N) of
    {error,no_float} -> list_to_integer(N);
    {F,_} -> F
  end.

onp_test() ->
  12.2 = onp("2 3 * 1 + 4 5 / - 6 +"),                %% 1 + 2 * 3 - 4 / 5 + 6
  57 = onp("1 2 3 4 5 6 7 * + + + + +"),              %% 1 + 2 + 3 + 4 + 5 + 6 * 7
  -62.33333333333333 = onp("4 7 + 3 / 2 19 - *"),     %%( (4 + 7) / 3 ) * (2 - 19)
  -595.0 = onp("17 31 4 + * 26 15 - 2 * 22 - 1 - /"),   %% 17 * (31 + 4) / ( (26 - 15) * 2 - 22 ) - 1
  ok.
%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Mar 2020 12:06
%%%-------------------------------------------------------------------
-module(modules).
-author("tumilok").

%% API
-export([power/2]).

power(_, 0) -> 1;
power(Num1, 1) -> Num1;
power(Num1, Num2) -> Num1 * power(Num1, Num2 - 1).

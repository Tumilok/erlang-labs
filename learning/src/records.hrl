%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Apr 2020 20:28
%%%-------------------------------------------------------------------
-author("tumilok").

%% this is a .hrl (header) file.
-record(included, {some_field,
  some_default = "yeah!",
  unimaginative_name}).
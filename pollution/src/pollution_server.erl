%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Apr 2020 18:51
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("tumilok").

%% API
-export([
  start/0,
  stop/0,
  init/0,
  print/0,
  addStation/2,
  addValue/4,
  removeValue/3,
  getOneValue/3,
  getStationMean/2,
  getDailyMean/2,
  getHourlyMean/2,
  getDailyAverageDataCount/2,
  getDailyOverLimit/3,
  getMaximumGradientStations/1,
  getMinValue/1,
  getMaxValue/1
]).

start() ->
  register(server, spawn(pollution_server, init, [])).

stop() ->
  server ! {self(), terminate},
  receive
    {_, Msg} -> Msg
  end.

init() ->
  Monitor = pollution:createMonitor(),
  loop(Monitor).

print() ->
  server ! {self(), print},
  receive
    {_, Msg} -> Msg
  end.

addStation(Name, Coords) ->
  functionHandler(addStation, {Name, Coords}).

addValue(Key, Date, Type, Val) ->
  functionHandler(addValue, {Key, Date, Type, Val}).

removeValue(Key, Date, Type) ->
  functionHandler(removeValue, {Key, Date, Type}).

getOneValue(Key, Date, Type) ->
  functionHandler(getOneValue, {Key, Date, Type}).

getStationMean(Key, Type) ->
  functionHandler(getStationMean, {Key, Type}).

getDailyMean(Type, Day) ->
  functionHandler(getDailyMean, {Type, Day}).

getHourlyMean(Type, Hour) ->
  functionHandler(getHourlyMean, {Type, Hour}).

getDailyAverageDataCount(Key, Date) ->
  functionHandler(getDailyAverageDataCount, {Key, Date}).

getDailyOverLimit(Date, Type, Limit) ->
  functionHandler(getDailyOverLimit, {Date, Type, Limit}).

getMaximumGradientStations(Type) ->
  functionHandler(getMaximumGradientStations, {Type}).

getMinValue(Type) ->
  functionHandler(getMinValue, {Type}).

getMaxValue(Type) ->
  functionHandler(getMaxValue, {Type}).

functionHandler(Fun, Args) ->
  server ! {self(), Fun, Args},
  receive
    {_, Msg} -> Msg
  after 3000 ->
    timeout
  end.

loop(Monitor) ->
  receive
    {Pid, addStation, {Name, Coords}} ->
      NewMonitor = pollution:addStation(Name, Coords, Monitor),
      Pid ! {self(), ok},
      loop(NewMonitor);
    {Pid, addValue, {Key, Date, Type, Val}} ->
      NewMonitor = pollution:addValue(Key, Date, Type, Val, Monitor),
      Pid ! {self(), ok},
      loop(NewMonitor);
    {Pid, removeValue, {Key, Date, Type}} ->
      NewMonitor = pollution:removeValue(Key, Date, Type, Monitor),
      Pid ! {self(), ok},
      loop(NewMonitor);
    {Pid, getOneValue, {Key, Date, Type}} ->
      Value = pollution:getOneValue(Key, Date, Type, Monitor),
      Pid ! {self(), ok},
      io:format("Value: ~p~n", [Value]),
      loop(Monitor);
    {Pid, getStationMean, {Key, Type}} ->
      Value = pollution:getStationMean(Key, Type, Monitor),
      Pid ! {self(), ok},
      io:format("Staion mean: ~p~n", [Value]),
      loop(Monitor);
    {Pid, getDailyMean, {Type, Day}} ->
      Value = pollution:getDailyMean(Type, Day, Monitor),
      Pid ! {self(), ok},
      io:format("Daily mean: ~p~n", [Value]),
      loop(Monitor);
    {Pid, getHourlyMean, {Type, Hour}} ->
      Value = pollution:getHourlyMean(Type, Hour, Monitor),
      Pid ! {self(), ok},
      io:format("Hourly mean: ~p~n", [Value]),
      loop(Monitor);
    {Pid, getDailyAverageDataCount, {Key, Date}} ->
      Value = pollution:getDailyAverageDataCount(Key, Date, Monitor),
      Pid ! {self(), ok},
      io:format("Daily average data count: ~p~n", [Value]),
      loop(Monitor);
    {Pid, getDailyOverLimit, {Date, Type, Limit}} ->
      Value = pollution:getDailyOverLimit(Date, Type, Limit, Monitor),
      Pid ! {self(), ok},
      io:format("Daily over limit: ~p~n", [Value]),
      loop(Monitor);
    {Pid, getMaximumGradientStations, {Type}} ->
      Value = pollution:getMaximumGradientStations(Type, Monitor),
      Pid ! {self(), ok},
      io:format("Maximum gradient stations: ~p~n", [Value]),
      loop(Monitor);
    {Pid, getMinValue, {Type}} ->
      Value = pollution:getMinValue(Type, Monitor),
      Pid ! {self(), ok},
      io:format("Min value: ~p~n", [Value]),
      loop(Monitor);
    {Pid, getMaxValue, {Type}} ->
      Value = pollution:getMaxValue(Type, Monitor),
      Pid ! {self(), ok},
      io:format("Max value: ~p~n", [Value]),
      loop(Monitor);
    {Pid, print} ->
      io:format("~p~n", [Monitor]),
      Pid ! {self(), ok},
      loop(Monitor);
    {Pid, terminate} ->
      Pid ! {self(), terminated}
  end.
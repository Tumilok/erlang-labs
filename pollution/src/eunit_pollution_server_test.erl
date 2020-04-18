%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Apr 2020 13:04
%%%-------------------------------------------------------------------
-module(eunit_pollution_server_test).
-author("tumilok").

-include_lib("eunit/include/eunit.hrl").

%% API
-export([]).

generateTestMonitorServer() ->
  pollution_server:start(),
  pollution_server:addStation("Aleja Slowackiego", {50.2345, 18.3445}),
  pollution_server:addStation("Kazimierza", {51.2345, 19.3445}),
  pollution_server:addValue({50.2345, 18.3445}, {{2020, 4, 7}, {15, 30, 16}}, "PM10", 59),
  pollution_server:addValue("Aleja Slowackiego", {{2020, 4, 7}, {15, 30, 17}}, "PM2,5", 113),
  pollution_server:addValue("Kazimierza", {{2020, 4, 7}, {15, 30, 18}}, "PM2,5", 117),
  pollution_server:addValue("Kazimierza", {{2020, 4, 7}, {15, 30, 19}}, "PM2,5", 30).

start_stop_test() ->
  ?assertEqual(true, pollution_server:start()),
  ?assertEqual(terminated, pollution_server:stop()).

addStation_test() ->
  pollution_server:start(),
  ?assertEqual(ok, pollution_server:addStation("Aleja Slowackiego", {50.2345, 18.3445})),
  ?assertEqual(ok, pollution_server:addStation("Kazimierza", {51.2345, 19.3445})),
  pollution_server:stop().

addValue_test() ->
  pollution_server:start(),
  pollution_server:addStation("Aleja Slowackiego", {50.2345, 18.3445}),
  pollution_server:addStation("Kazimierza", {51.2345, 19.3445}),
  ?assertEqual(ok, pollution_server:addValue({50.2345, 18.3445}, {{2020, 4, 7}, {15, 30, 16}}, "PM10", 59)),
  ?assertEqual(ok, pollution_server:addValue("Aleja Slowackiego", {{2020, 4, 7}, {15, 30, 17}}, "PM2,5", 113)),
  ?assertEqual(ok, pollution_server:addValue("Kazimierza", {{2020, 4, 7}, {15, 30, 18}}, "PM2,5", 117)),
  ?assertEqual(ok, pollution_server:addValue("Kazimierza", {{2020, 4, 7}, {15, 30, 19}}, "PM2,5", 30)),
  pollution_server:stop().

removeValue_test() ->
  generateTestMonitorServer(),
  ?assertEqual(ok, pollution_server:removeValue({51.2345,19.3445}, {{2020,4,7},{15,30,18}}, "PM2,5")),
  ?assertEqual(ok, pollution_server:removeValue("Aleja Slowackiego", {{2020,4,7},{15,30,16}}, "PM10")),
  pollution_server:stop().

getOneValue_test() ->
  generateTestMonitorServer(),
  ?assertEqual(ok, pollution_server:getOneValue("Aleja Slowackiego", {{2020, 4, 7},{15,30,16}}, "PM10")),
  ?assertEqual(ok, pollution_server:getOneValue({51.2345,19.3445}, {{2020, 4, 7},{15,30,18}}, "PM2,5")),
  pollution_server:stop().

getStationMean_test() ->
  generateTestMonitorServer(),
  ?assertEqual(ok, pollution_server:getStationMean({50.2345,18.3445}, "PM10")),
  ?assertEqual(ok, pollution_server:getStationMean("Kazimierza", "PM2,5")),
  pollution_server:stop().

getDailyMean_test() ->
  generateTestMonitorServer(),
  ?assertEqual(ok, pollution_server:getDailyMean("PM2,5", {2020, 4, 7})),
  ?assertEqual(ok, pollution_server:getDailyMean("PM10", {2020, 4, 7})),
  pollution_server:stop().

getHourlyMean_test() ->
  generateTestMonitorServer(),
  ?assertEqual(ok, pollution_server:getHourlyMean("PM10", 15)),
  ?assertEqual(ok, pollution_server:getHourlyMean("PM2,5", 15)),
  pollution_server:stop().

getDailyAverageDataCount_test() ->
  generateTestMonitorServer(),
  ?assertEqual(ok, pollution_server:getDailyAverageDataCount("Aleja Slowackiego", {2020, 4, 7})),
  ?assertEqual(ok, pollution_server:getDailyAverageDataCount({51.2345,19.3445}, {2020, 4, 7})),
  pollution_server:stop().

getDailyOverLimit_test() ->
  generateTestMonitorServer(),
  ?assertEqual(ok, pollution_server:getDailyOverLimit({2020,4,7}, "PM10", 50)),
  ?assertEqual(ok, pollution_server:getDailyOverLimit({2020,4,7}, "PM10", 70)),
  pollution_server:stop().

getMaximumGradientStations_test() ->
  generateTestMonitorServer(),
  ?assertEqual(ok, pollution_server:getMaximumGradientStations("PM10")),
  ?assertEqual(ok, pollution_server:getMaximumGradientStations("PM2,5")),
  pollution_server:stop().

getMinValue_test() ->
  generateTestMonitorServer(),
  ?assertEqual(ok, pollution_server:getMinValue("PM2,5")),
  ?assertEqual(ok, pollution_server:getMinValue("PM10")),
  pollution_server:stop().

getMaxValue_test() ->
  generateTestMonitorServer(),
  ?assertEqual(ok, pollution_server:getMaxValue("PM10")),
  ?assertEqual(ok, pollution_server:getMaxValue("PM2,5")),
  pollution_server:stop().
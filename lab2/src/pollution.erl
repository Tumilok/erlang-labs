%%%-------------------------------------------------------------------
%%% @author tumilok
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Mar 2020 16:17
%%%-------------------------------------------------------------------
-module(pollution).
-author("tumilok").

-compile(export_all).


-record(station, {coords, name}).
-record(measurement, {type, date}).

writeMessage(name) -> io:format("Error, Name must be a list");
writeMessage(coords) -> io:format("Error, Coordinates must be a tuple");
writeMessage(type) -> io:format("Error, Type must be a list ~n");
writeMessage(date) -> io:format("Error, Date must be a tuple ~n");
writeMessage(val) -> io:format("Error, Val must be a integer or float ~n");
writeMessage(monitor) -> io:format("Error, Monitor is empty ~n").

createMonitor() -> maps:new().

getStationKey([], _) -> null;
getStationKey([#station{name=Key, coords=Coords}|_], Key) -> #station{name=Key, coords=Coords};
getStationKey([#station{name=Name, coords=Key}|_], Key) -> #station{name=Name, coords=Key};
getStationKey([_|T], Key) -> getStationKey(T, Key).

addStation(Name, _, _) when not is_list(Name) -> writeMessage(name);
addStation(_, Coords, _) when not is_tuple(Coords) -> writeMessage(error);
addStation(Name, Coords, Monitor) ->
  NameExists = getStationKey(maps:keys(Monitor), Name),
  CoordsExists = getStationKey(maps:keys(Monitor), Coords),
  case {NameExists, CoordsExists} of
    {null, null} -> Monitor#{#station{name=Name, coords=Coords} => maps:new()};
    {null, _} -> io:format("Error, Coordinates of such a value already exists ~n"),
      Monitor;
    {_, _} -> io:format("Error, Name of such a value already exists ~n"),
      Monitor
  end.

addValue(_, _, Type, _, _) when not is_list(Type) -> writeMessage(type);
addValue(_, _, _, Val, _) when not (is_integer(Val) or is_float(Val)) -> writeMessage(val);
addValue(_, _, _, _, Monitor) when Monitor == #{} -> writeMessage(monitor);
addValue(Key, Date, Type, Val, Monitor) ->
  Value = maps:find(getStationKey(maps:keys(Monitor), Key), Monitor),
  case Value of
    error -> io:format("Station doesn't exist ~n"),
      Monitor;
    {ok, Measurement} ->
      Exists = maps:find(#measurement{type=Type, date=Date}, Measurement),
      case Exists of
        error ->
          case maps:size(Measurement) of
            0 -> maps:put(getStationKey(maps:keys(Monitor), Key), maps:put(#measurement{type=Type, date=Date}, Val, Measurement), Monitor);
            _ -> maps:update(getStationKey(maps:keys(Monitor), Key), maps:put(#measurement{type=Type, date=Date}, Val, Measurement), Monitor)
          end;
        _ -> io:format("Error, Type and Date of such a value already exist ~n"),
          Monitor
      end
  end.


removeValue(_, _, Type, _) when not is_list(Type) -> writeMessage(type);
removeValue(_, _, _, Monitor) when Monitor == #{} -> writeMessage(monitor);
removeValue(Key, Date, Type, Monitor) ->
  Value = maps:find(getStationKey(maps:keys(Monitor), Key), Monitor),
  case Value of
    error -> io:format("Station doesn't exist ~n"),
      Monitor;
    {ok, Measurement} ->
      ToRemove = maps:find(#measurement{type=Type, date=Date}, Measurement),
      case ToRemove of
        error -> io:format("Measurments with such parameters don't exist ~n"),
          Monitor;
        _ -> NewMeasurement = maps:remove(#measurement{type=Type, date=Date}, Measurement),
          maps:update(getStationKey(maps:keys(Monitor), Key), NewMeasurement, Monitor)
      end
  end.

getOneValue(_, _, Type, _) when not is_list(Type) -> writeMessage(type);
getOneValue(_, _, _, Monitor) when Monitor == #{} -> writeMessage(monitor);
getOneValue(Key, Date, Type, Monitor) ->
  Value = maps:find(getStationKey(maps:keys(Monitor), Key), Monitor),
  case Value of
    error -> io:format("Station doesn't exist ~n"),
      error;
    {ok, Measurement} ->
      ToReturn = maps:find(#measurement{type=Type, date=Date}, Measurement),
      case ToReturn of
        error -> io:format("Measurments with such parameters don't exist ~n"),
          error;
        {ok, Val} -> Val
      end
  end.

getStationMean(_, Type, _) when not is_list(Type) -> writeMessage(type);
getStationMean(_, _, Monitor) when Monitor == #{} -> writeMessage(monitor);
getStationMean(Key, Type, Monitor) ->
  Value = maps:find(getStationKey(maps:keys(Monitor), Key), Monitor),
  case Value of
    error -> io:format("Station doesn't exist ~n"),
      error;
    {ok, Measurement} ->
      getMeanByType(maps:to_list(Measurement), Type, 0, 0)
  end.

getMeanByType([], _, Sum, Size) when Size > 0 -> Sum / Size;
getMeanByType([H|T], Type, Sum, Size) ->
  case H of
    {#measurement{type=Type}, Val} -> getMeanByType(T, Type, Sum+Val, Size+1);
    _ -> getMeanByType(T, Type, Sum, Size)
  end.

getDailyMean(Type, _, _) when not is_list(Type) -> writeMessage(type);
getDailyMean(_, Date, _) when not is_tuple(Date) -> writeMessage(date);
getDailyMean(_, _, Monitor) when Monitor == #{} -> writeMessage(monitor);
getDailyMean(Type, Date, Monitor) -> iterateStations(Monitor, maps:keys(Monitor), Type, Date, 0, 0).

iterateStations(_, [], _, _, Sum, Size) when Size > 0 -> Sum / Size;
iterateStations(Monitor, [H|T], Type, Date, Sum, Size) ->
  {ok, Val} = maps:find(H, Monitor),
  {MSum, MSize} = getDailyMeanByType(maps:to_list(Val), Type, Date, {0,0}),
  iterateStations(Monitor, T, Type, Date, Sum + MSum, Size + MSize).


getDailyMeanByType([], _, _, {Sum,Size}) -> {Sum,Size};
getDailyMeanByType([H|T], Type, Date, {Sum,Size}) ->
  case H of
    {#measurement{type=Type, date={Date, _}}, Val} -> getDailyMeanByType(T, Type, Date, {Sum+Val,Size+1});
   _ -> getDailyMeanByType(T, Type, Date, {Sum,Size})
 end.



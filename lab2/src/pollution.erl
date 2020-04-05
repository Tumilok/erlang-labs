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
writeMessage(val) -> io:format("Error, Val must be a integer or float ~n");
writeMessage(monitor) -> io:format("Error, Monitor is empty ~n").

createMonitor() -> maps:new().

getStationKey([], _) -> null;
getStationKey([#station{name=Key, coords=Coords}|_], Key) -> #station{name=Key, coords=Coords};
getStationKey([#station{name=Name, coords=Key}|_], Key) -> #station{name=Name, coords=Key};
getStationKey([_|T], Key) -> getStationKey(T, Key).

getMeasurementKey([], _) -> null;
getMeasurementKey([#measurement{type=Key, date=Date}|_], Key) -> #measurement{type=Key, date=Date};
getMeasurementKey([#measurement{type=Type, date=Key}|_], Key) -> #measurement{type=Type, date=Key};
getMeasurementKey([_|T], Key) -> getMeasurementKey(T, Key).

addStation(Name, _, _) when not is_list(Name) -> writeMessage(name);
addStation(_, Coords, _) when not is_tuple(Coords) -> writeMessage(error);
addStation(Name, Coords, Monitor) ->
  NameExists = getStationKey(maps:keys(Monitor), Name),
  CoordsExists = getStationKey(maps:keys(Monitor), Coords),
  case {NameExists, CoordsExists} of
    {null, null} -> Monitor#{#station{name=Name, coords=Coords} => Monitor};
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
      TestType = getMeasurementKey(maps:keys(Measurement), Type),
      TestDate = getMeasurementKey(maps:keys(Measurement), Date),

      case {TestDate, TestType} of
        {null, null} ->
          case maps:size(Measurement) of
            0 -> maps:put(getStationKey(maps:keys(Monitor), Key), maps:put(#measurement{type=Type, date=Date}, Val, Measurement), Monitor);
            _ -> maps:update(getStationKey(maps:keys(Monitor), Key), maps:put(#measurement{type=Type, date=Date}, Val, Measurement), Monitor)
          end;
        {null, _} -> io:format("Error, Type of such a value already exists ~n"),
          Monitor;
        {_, _} -> io:format("Error, Date of such a value already exists ~n"),
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
        error -> io:format("Station with such parameters doesn't exist ~n"),
          Monitor;
        _ -> NewMeasurement = maps:remove(#measurement{type=Type, date=Date}, Measurement),
          maps:update(getStationKey(maps:keys(Monitor), Key), NewMeasurement, Monitor)
      end
  end.


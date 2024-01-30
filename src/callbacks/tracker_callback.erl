%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2024, REDGREAT
%%% @doc
%%% 定位地址获取
%%% @end
%%% Created : 2024-01-02 10:18
%%%-------------------------------------------------------------------
-module(tracker_callback).
-author("wangcw").

%% API
-export([get_location/4]).

get_location(_PathParameters, QueryParameters, _Headers, _Body) ->
  IMEI = proplists:get_value(<<"imei">>, QueryParameters),
  StartDate = proplists:get_value(<<"startDate">>, QueryParameters),
  EndDate = proplists:get_value(<<"endDate">>, QueryParameters),
  IMEIBinary = case IMEI of
                    <<_/binary>> -> IMEI;
                    _ -> list_to_binary(IMEI)
                 end,
  StartDateBinary = case StartDate of
                         <<_/binary>> -> StartDate;
                         _ -> list_to_binary(StartDate)
                     end,
  EndDateBinary = case EndDate of
                      <<_/binary>> -> EndDate;
                      _ -> list_to_binary(EndDate)
                   end,
  Result = mysql_pool:query(pool_rose,
           "SELECT dev_upload AS tracktime,device_id AS imei, lat, lng, dirct, speed, hight
           FROM carlocdaily
           WHERE device_id = ?
             AND dev_upload >= ?
             AND dev_upload < ?
           LIMIT 10;", [IMEIBinary, StartDateBinary, EndDateBinary]),
  JsonTerm = mysql_utils:as_json(Result),
  JsonString = jason:encode(JsonTerm),
  JsonMap = jiffy:decode(JsonString, [return_maps]),
  {200, [], JsonMap}.

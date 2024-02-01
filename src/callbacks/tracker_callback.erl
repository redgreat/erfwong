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

%%%===================================================================
%%% API functions
%%%===================================================================
-export([get_location/1]).

%% @doc 定位信息获取
get_location(#{query_parameters := QueryParameters} = _Request) ->
  IMEI = proplists:get_value(<<"imei">>, QueryParameters),
  StartDate = proplists:get_value(<<"startDate">>, QueryParameters),
  EndDate = proplists:get_value(<<"endDate">>, QueryParameters),
  case mysql_pool:query(pool_rose,
           "SELECT dev_upload AS tracktime,device_id AS imei, lat, lng, dirct, speed, hight
           FROM carlocdaily
           WHERE device_id = ?
             AND dev_upload >= ?
             AND dev_upload < ?
           LIMIT 10;", [IMEI, StartDate, EndDate]) of
    {ok, Columns, Rows} ->
      ReturnMap = erfwong_utils:return_as_map(Columns, Rows),
      case ReturnMap of
        _ when map_size(ReturnMap) > 0 -> {200, [], ReturnMap};
        #{ } ->
          {404, [], #{
            <<"msg">> => <<"设备号：", IMEI, " 在时间段 ", StartDate, " 到 ", EndDate," 内无数据！">>,
            <<"data">> => <<>>
            }}
      end;
    {error, Reason} ->
      lager:error("SQL执行失败: ~p~n", [Reason]),
      {500, [], #{<<"msg">> => <<"服务器内部错误！">>,
            <<"data">> => <<>>}}
  end.

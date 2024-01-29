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
    ok = mysql_pool:start(),
    case mysql_pool:query(pool_tidb,
          "SELECT dev_upload AS tracktime, device_id AS imei, lat, lng, dirct, speed, hight
          FROM carlocdaily
          WHERE device_id = ?
            AND dev_upload >= ?
            AND dev_upload < ?
          LIMIT 10;", [IMEIBinary, StartDateBinary, EndDateBinary]) of
         {ok, Result} ->
           ResJson = mysql_utils:as_json(Result),
           {200, [], binary_to_list(ResJson)};
         {error, Reason} ->
           io:format("~p~n", [Reason]),
           lager:error("SQL执行失败: ~p~n", [Reason]),
           {404, [], #{
             <<"message">> =>
               <<"设备号：", IMEI/binary, " 在时间段 ", StartDate/binary, " 到 ", EndDate/binary," 内无数据！">>
              }};
         Other ->
          lager:error("SQL查询返回了未知的结果: ~p~n", [Other]),
          {500, [], #{ <<"message">> => <<"内部服务器错误">> }}
    end.

%% mysql_start() ->
%%     {ok, DbHost} = application:get_env(tidbcloud, db_host),
%%     {ok, DbPort} = application:get_env(tidbcloud, db_port),
%%     {ok, DbUser} = application:get_env(tidbcloud, db_user),
%%     {ok, DbPasswd} = application:get_env(tidbcloud, db_password),
%%     {ok, DbName} = application:get_env(tidbcloud, db_name),
%%     {ok, SslCa} = application:get_env(tidbcloud, ssl_ca),
%%     case mysql:start_link([
%%         {host, DbHost}, {port, DbPort}, {user, DbUser}, {password, DbPasswd}, {database, DbName}, {ssl, SslCa}
%%     ]) of
%%         {ok, Pid} ->
%%             lager:info("Successful Start MySQL connection: ~p~n", [Pid]),
%%             {ok, Pid};
%%         {error, Reason} ->
%%             io:format("Failed to Start MySQL connection: ~p~n", [Reason]),
%%             lager:error("Failed to Start MySQL connection: ~p~n", [Reason]),
%%             exit(Reason)
%%     end.
%%
%%
%% mysql_stop(Pid) ->
%%     ok = mysql:stop(Pid).

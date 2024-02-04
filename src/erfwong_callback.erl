%% coding: unicode
%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2024, REDGREAT
%%% @doc
%%% 日常数据提供API 回调模块
%%% @end
%%% Created : 2024-01-02 10:18
%%%-------------------------------------------------------------------
-module(erfwong_callback).
-author("wangcw").

-export([get_location/1]).
%%%===================================================================
%%% API functions
%%%===================================================================

%% @doc
%% 定位信息获取
%% @end
get_location(#{query_parameters := QueryParameters} = _Request) ->
    IMEI = proplists:get_value(<<"imei">>, QueryParameters),
    StartDate = proplists:get_value(<<"startDate">>, QueryParameters),
    EndDate = proplists:get_value(<<"endDate">>, QueryParameters),
    try
        {ok, Columns, Rows} = mysql_pool:query(
            pool_rose,
            "SELECT dev_upload AS tracktime,device_id AS imei, lat, lng, dirct, speed, hight\n"
            "           FROM carlocdaily\n"
            "           WHERE device_id = ?\n"
            "             AND dev_upload >= ?\n"
            "             AND dev_upload < ?\n"
            "           LIMIT 5000;",
            [IMEI, StartDate, EndDate]
        ),
        ReturnMap = erfwong_utils:return_as_map(Columns, Rows),
        case maps:get(<<"data">>, ReturnMap) of
            [] ->
                Msg1 = unicode:characters_to_binary("设备号：'"),
                Msg2 = unicode:characters_to_binary("',在时间段'"),
                Msg3 = unicode:characters_to_binary("'到'"),
                Msg4 = unicode:characters_to_binary("'内无数据！"),
                Msg =
                    <<Msg1/binary, IMEI/binary, Msg2/binary, StartDate/binary, Msg3/binary,
                        EndDate/binary, Msg4/binary>>,
                {404, [], #{
                    <<"msg">> => Msg,
                    <<"data">> => undefined
                }};
            _ ->
                {200, [], ReturnMap}
        end
    catch
        error:Error ->
            lager:error("SQL执行失败: ~p~n", [Error]),
            {500, [], #{
                <<"msg">> => unicode:characters_to_binary("服务器内部错误！"),
                <<"data">> => undefined
            }};
        throw:Thrown ->
            lager:error("服务器内部错误: ~p~n", [Thrown]),
            {500, [], #{
                <<"msg">> => unicode:characters_to_binary("服务器内部错误！"),
                <<"data">> => undefined
            }};
        exit:Reason ->
            lager:error("程序异常退出: ~p~n", [Reason]),
            {500, [], #{
                <<"msg">> => unicode:characters_to_binary("服务器内部错误！"),
                <<"data">> => undefined
            }}
    end.

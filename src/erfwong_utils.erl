%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2024, REDGREAT
%%% @doc
%%% convert json format tools  and so on.
%%% @end
%%% Created : 2024-02-01 10:05
%%%-------------------------------------------------------------------
-module(erfwong_utils).
-author("wangcw").

%% include
-include_lib("stdlib/include/ms_transform.hrl").

%% API
-export([as_map/1, as_map/3, return_as_map/1, return_as_map/2]).

%%%===================================================================
%%% API functions
%%%===================================================================

%% @doc
%% mysql-otp result to map.
%% @end
as_map({ok, ColumnNames, Rows}) ->
    as_map(ColumnNames, Rows, []).

as_map(ColumnNames, [Row | RestRows], Acc) ->
    Map = lists:foldl(
        fun({Key, Value}, AccMap) ->
            {TransformedValue, _IsTime} = transform_value(Key, Value),
            AccMap#{Key => TransformedValue}
        end,
        #{},
        lists:zip(ColumnNames, Row)
    ),
    as_map(ColumnNames, RestRows, [Map | Acc]);
as_map(_ColumnNames, [], Acc) ->
    lists:reverse(Acc).

%% @doc
%% mysql-otp result to map for http return, add ReturnStatus.
%% @end
return_as_map({ok, Columns, Rows}) ->
    return_as_map(Columns, Rows).

return_as_map(Columns, Rows) ->
    ResMap = as_map(Columns, Rows, []),
    ReturnMap = #{
        <<"msg">> => unicode:characters_to_binary("成功"),
        <<"data">> => ResMap
    },
    ReturnMap.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% @private
%% @doc Time convertor, ISO8601.
transform_value(_, {{Y, M, D}, {H, Mi, S}}) when
    is_integer(Y), is_integer(M), is_integer(D), is_integer(H), is_integer(Mi), is_integer(S)
->
    TimeStr = io_lib:fwrite("~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0BZ", [
        Y, M, D, H, Mi, S
    ]),
    {list_to_binary(TimeStr), true};
transform_value(_, Value) ->
    {Value, false}.

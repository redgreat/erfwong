%% coding: unicode
%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2024, REDGREAT
%% @doc
%% 日常数据提供API
%% @end
%%% Created : 2024-01-02 13:03
%%%-------------------------------------------------------------------

-module(erfwong_app).
-author("wangcw").

-behaviour(application).

-include_lib("api_key.hrl").

-export([start/2, stop/1]).
%%%===================================================================
%%% Application callbacks
%%%===================================================================

%% @doc
%% 开启log进程/数据库连接池
%% @end
start(_StartType, _StartArgs) ->
    application:start(lager),
    mysql_pool:start(),
    ets:new(?API_KEY, [named_table, public, set]),
    {ok, ApiKey} = application:get_env(api_cfg, api_key),
    ets:insert(?API_KEY, {ApiKey, true}),
    erfwong_sup:start_link().

%% @doc
%% 关闭app
%% @end
stop(_State) ->
    application:stop(lager),
    mysql_pool:stop(),
    ok.

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
    % case application:get_env(api_cfg, api_key) of
    % {ok, ApiKey} ->
    %     io:format("~p~n", [ApiKey]),
    %     ets:insert(?API_KEY, {ApiKey, true});
    % undefined ->
    %     lager:error("未在配置文件中找到 API_KEY！")
    % end,
    erfwong_sup:start_link(),
    try
        {ok, ApiKey} = application:get_env(api_cfg, api_key),
        ets:new(?API_KEY, [named_table, public, set]),
        ets:insert(?API_KEY, {ApiKey, true}),
        lager:info("API_KEY参数获取成功!")
    catch
        error:Error ->
        lager:error("配置文件中获取API_KEY参数获取失败： ~p~n", [Error])
    end.

%% @doc
%% 关闭app
%% @end
stop(_State) ->
    application:stop(lager),
    mysql_pool:stop(),
    ok.

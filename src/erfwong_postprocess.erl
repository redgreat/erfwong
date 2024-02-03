%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2024, REDGREAT
%% @doc
%% 事后处理中间件
%% @end
%%% Created : 2024-01-08 17:09:40
%%%-------------------------------------------------------------------
-module(erfwong_postprocess).
-author("wangcw").

%% 行为
-behaviour(erf_postprocess_middleware).

%% 函数导出
-export([postprocess/2]).

%%%===================================================================
%%% API
%%%===================================================================

%% @doc
%% Here we exemplify how information previously inserted on the request context
%% can be used to condition the request processing flow.
%% @end
postprocess(#{method := post, context := #{post_init := PostInitT}} = _Request, Response) ->
    PostEndT = erlang:timestamp(),
    Diff = timer:now_diff(PostEndT, PostInitT),
    io:format("Post time diff : ~p~n", [Diff]),
    Response;
postprocess(_Request, Response) ->
    Response.

%%%===================================================================
%%% Internal functions
%%%===================================================================

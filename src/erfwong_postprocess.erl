%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2024, REDGREAT
%% @doc
%%
%% etracker public API
%%
%% @end
%%% Created : 2024-01-08 17:09:40
%%%-------------------------------------------------------------------

%% @doc Behaviour for <code>erf</code>'s postprocessing middlewares.
-module(erfwong_postprocess).

%%% BEHAVIOURS
-behaviour(erf_postprocess_middleware).

%%% EXTERNAL EXPORTS
-export([postprocess/2]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Here we exemplify how information previously inserted on the request context
%% can be used to condition the request processing flow.
%%
%% @end
%%--------------------------------------------------------------------

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
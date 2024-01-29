%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2024, REDGREAT
%% @doc
%%
%% etracker public API
%%
%% @end
%%% Created : 2024-01-08 17:09:52
%%%-------------------------------------------------------------------

%% @doc Behaviour for <code>erf</code>'s preprocessing middlewares.
-module(erfwong_preprocess).

%%% BEHAVIOURS
-behaviour(erf_preprocess_middleware).

%%% EXTERNAL EXPORTS
-export([preprocess/1]).

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
preprocess(#{headers := Headers} = Request) ->
    Authorization = proplists:get_value(<<"x-api-key">>, Headers, undefined),
    case is_authorized(Authorization) of
        false ->
            % For delete operations, if delete is disabled,
            % we skip to the post-process middlewares.
            {stop, {403, [], <<"Missing valid basic authorization header">>}};
        true ->
            PostInitT = erlang:timestamp(),
            Context = maps:get(context, Request, #{}),
            % We store the current timestamp on the the request context
            % for latter use.
            Request#{context => Context#{post_init => PostInitT}}
    end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
is_authorized(undefined) ->
    false;
is_authorized(<<"123456789">>) ->
    true;
is_authorized(_) ->
    false.

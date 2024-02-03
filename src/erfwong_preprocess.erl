%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2024, REDGREAT
%% @doc
%% 事前处理中间件
%% @end
%%% Created : 2024-01-08 17:09:52
%%%-------------------------------------------------------------------
-module(erfwong_preprocess).
-author("wangcw").

-behaviour(erf_preprocess_middleware).

-export([preprocess/1]).

%%%===================================================================
%%% API
%%%===================================================================

%% @doc
%% 事前处理函数.
%% 如果请求路径是 /swagger开始的链接，并且方法为 GET，则不需要 x-api-key
%% @end
preprocess(#{method := Method, path := Path, headers := Headers} = Request) ->
    case {hd(Path), Method} of
        {<<"swagger">>, get} ->
            Request#{context => maps:get(context, Request, #{})};
        _ ->
            Authorization = proplists:get_value(<<"x-api-key">>, Headers, undefined),
            % io:format("Authorization: ~p~n", [Authorization]),
            case is_authorized(Authorization) of
                false ->
                    {stop, {403, [], #{<<"msg">> => unicode:characters_to_binary("鉴权失败！"), <<"data">> => []}}};
                true ->
                    PostInitT = erlang:timestamp(),
                    Context = maps:get(context, Request, #{}),
                    Request#{context => Context#{post_init => PostInitT}}
            end
    end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% @private
%% @doc
%% API_KEY验证内部方法.
%% @end
is_authorized(undefined) ->
    false;
is_authorized(<<"5shvUSrJDZry9gJB3JTpSDvSTJXgcsQkBFjP">>) ->
    true;
is_authorized(_) ->
    false.

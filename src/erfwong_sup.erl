%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2023, REDGREAT
%%% @doc
%%% 守护进程
%%% @end
%%% Created : 2023-09-11 10:53
%%%-------------------------------------------------------------------
-module(erfwong_sup).
-author("wangcw").

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

%%%===================================================================
%%% API functions
%%%===================================================================

%%% @doc 开启守护进程
start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%% @doc Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%% @end

init([]) ->
    {ok, ApiPort} = application:get_env(api_cfg, port),
    ErfWongAPIConf = #{
        name => erfwong_api,
        spec_path => <<"priv/apis/erfwong.json">>,
        static_routes => [{<<"/:Resource">>, {dir, <<"priv/static">>}}],
        callback => erfwong_callback,
        preprocess_middlewares => [erfwong_preprocess],
        postprocess_middlewares => [erfwong_postprocess],
        port => ApiPort,
        swagger_ui => true,
        log_level => error
    },
    ErfWongChildSpec = {
        api_server,
        {erf, start_link, [ErfWongAPIConf]},
        permanent,
        5000,
        worker,
        [erf]
    },
    {ok, {{one_for_one, 5, 10}, [ErfWongChildSpec]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

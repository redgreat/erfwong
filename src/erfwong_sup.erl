%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2023, REDGREAT
%%% @doc
%%%
%%% @end
%%% Created : 2023-09-11 10:53
%%%-------------------------------------------------------------------
-module(erfwong_sup).
-author("wangcw").

%%% BEHAVIOURS
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

%%%===================================================================
%%% API functions
%%%===================================================================

%%% @doc Starts the supervisor
start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%% @private
%% @doc Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.

init([]) ->
    % Users storage
    ets:new(users, [public, named_table]),
    UsersAPIConf = #{
        name => erfwong,
        spec_path => <<"apis/users/users2.json">>,
        callback => users_callback2,
        port => 8080,
        swagger_ui => true,
        log_level => debug
    },
    UsersChildSpec = {
        public_api_server,
        {erf, start_link, [UsersAPIConf]},
        permanent,
        5000,
        worker,
        [erf]
    },
    {ok, {{one_for_one, 5, 10}, [UsersChildSpec]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2023, REDGREAT
%%% @doc
%%%
%%% @end
%%% Created : 11. 9月 2023 10:53
%%%-------------------------------------------------------------------
-module(erfwong_sup).
-author("wangcw").

%%% BEHAVIOURS
-behaviour(supervisor).

%%% START/STOP EXPORTS
-export([start_link/0]).

%%% INTERNAL EXPORTS
-export([init/1]).

%%%-------------------------------------------------------
%%% START/STOP EXPORTS
%%%-------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%%-------------------------------------------------------
%%% INTERNAL EXPORTS
%%%-------------------------------------------------------
init([]) ->
    % Users storage
    ets:new(users, [public, named_table]),
    UsersAPIConf = #{
        name => erfwong,
        spec_path => <<"apis/users/users2.json">>,
        callback => users_callback,
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
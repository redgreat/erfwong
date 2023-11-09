%%%-------------------------------------------------------------------
%% @doc erfwong public API
%% @end
%%%-------------------------------------------------------------------

-module(erfwong_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    erfwong_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2024, REDGREAT
%% @doc
%%
%% erfwong public API
%%
%% @end
%%% Created : 2024-01-02 13:03
%%%-------------------------------------------------------------------

-module(erfwong_app).
-author("wangcw").

-behaviour(application).

-export([start/2, stop/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application is started using
%% application:start/[1,2], and should start the processes of the
%% application. If the application is structured according to the OTP
%% design principles as a supervision tree, this means starting the
%% top supervisor of the tree.
%%
%% @end
%%--------------------------------------------------------------------

start(_StartType, _StartArgs) ->
    application:start(syntax_tools),
    application:start(compiler),
    application:start(goldrush),
    application:start(lager),
    mysql_pool:start(),
    erfwong_sup:start_link().

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application has stopped. It
%% is intended to be the opposite of Module:start/2 and should do
%% any necessary cleaning up. The return value is ignored.
%%
%% @end
%%--------------------------------------------------------------------

stop(_State) ->
    application:stop(syntax_tools),
    application:stop(compiler),
    application:stop(goldrush),
    application:stop(lager),
    mysql_pool:stop(),
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

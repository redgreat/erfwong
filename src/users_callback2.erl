%%%-------------------------------------------------------------------
%%% @author wangcw
%%% @copyright (C) 2024, REDGREAT
%%% @doc
%%%
%%% @end
%%% Created : 02. 1月 2024 10:01
%%%-------------------------------------------------------------------
-module(tb_userinfo_callback2).
-author("wangcw").

%% API
-export([start/0, stop/1, insert/2, delete/2, update/2, select/2]).

-include_lib("mysql/include/mysql.hrl").
-include_lib("lager/include/lager.hrl").

start() ->
    %% application:start(lager).
    {ok, DbHost} = application:get_env(rosemysql, db_host),
    {ok, DbPort} = application:get_env(rosemysql, db_port),
    {ok, DbUser} = application:get_env(rosemysql, db_user),
    {ok, DbPasswd} = application:get_env(rosemysql, db_password),
    {ok, DbName} = application:get_env(rosemysql, db_name),
    {ok, Pid} = mysql:start_link([{host, DbHost}, {port, DbPort}, {user, DbUser}, {password, DbPasswd}, {database, DbName}]),
    Pid.

stop(Pid) ->
    ok = mysql:stop(Pid).

insert(Pid, Data) ->
    case
        mysql:query(Pid, "INSERT INTO tb_userinfo (name, age) VALUES (?, ?)", [Data#user.name, Data#user.age])
    of
        {ok, _} -> ok;
        {error, Reason} -> lager:error("Insert failed: ~p", [Reason])
    end.

delete(Pid, UserId) ->
    case
        mysql:query(Pid, "DELETE FROM tb_userinfo WHERE id = ?", [UserId])
    of
        {ok, _} -> ok;
        {error, Reason} -> lager:error("Insert failed: ~p", [Reason])
    end.

update(Pid, Data) ->
    case
        mysql:query(Pid, "UPDATE tb_userinfo SET name = ?, age = ? WHERE id = ?", [Data#user.name, Data#user.age, Data#user.id])
    of
        {ok, _} -> ok;
        {error, Reason} -> lager:error("Insert failed: ~p", [Reason])
    end.

select(Pid, UserId) ->
    case mysql:query(Pid, "SELECT * FROM tb_userinfo WHERE id = ?", [UserId]) of
        {ok, Result} ->
            Rows = mysql:fetch_all(Result),
            {ok, Rows}; % 返回查询结果
        {error, Reason} ->
            lager:error("Select failed: ~p", [Reason]),
            {error, Reason} % 返回错误原因
    end.

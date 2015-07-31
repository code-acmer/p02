-module(mysql_misc).
-export([init/0]).

init() ->
    DefaultOptions = [{user, app_misc:get_env(default_mysql_user)},
                      {password, app_misc:get_env(default_mysql_password)},
                      {port, app_misc:get_env(default_mysql_port)},
                      {host, app_misc:get_env(default_mysql_host)},
                      {pool_size, app_misc:get_env(default_mysql_pool_size)}],
    [init_db(mochilists:set_defaults(DefaultOptions, options_hook(Conf))) || 
        Conf <- app_misc:get_env(mysql_conf)].

options_hook({db_log, Options}) ->    
    [{pool_id, db_log}, {pool_size, db_log_pool_size()} | proplists:delete(pool_size, Options)];
options_hook({PoolId, Options}) -> 
    [{pool_id, PoolId}|Options].

init_db(Options) ->
    Host = proplists:get_value(host, Options),
    Port = proplists:get_value(port, Options),
    User = proplists:get_value(user, Options),
    Password = proplists:get_value(password, Options),
    DataBase = proplists:get_value(db, Options),
    PoolId = proplists:get_value(pool_id, Options),
    Poolsize = proplists:get_value(pool_size, Options),
    emysql:add_pool(PoolId, Poolsize, User, Password, Host, Port, DataBase, utf8).

%% 根据mod_base_log启动了多少进程就开多大pool_size
%% 并且留一个给非mod_base_log用的
db_log_pool_size() ->
    lists:foldl(fun({FuncName, _Argc}, Sum) ->
                        case lists:suffix("args", atom_to_list(FuncName)) of
                            true ->
                                Sum + 1;
                            false ->
                                Sum
                        end
                end, 1, proplists:get_value(exports, lib_log:module_info())).

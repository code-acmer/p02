-module(gs_rel).
-export([db_compare/0, db_update/0]).

db_compare() ->
    mysql_struct_compare(h149, ucloud).

db_update() ->
    mysql_update(ucloud).

db_conf({DefaultDotApp, UserConfFile}) ->
    %% DefaultDotApp /home/roowe/happytree/server_p04/src/server.app.src
    %% UserConfFile /home/roowe/happytree/server_p04/sh/db_disc_1/sys.config
    %% io:format("~p~n", [{Identity, DefaultDotApp, UserConfFile}]),
    DefaultConf = app_default(file:consult(DefaultDotApp)),
    UserConf = user_conf(file:consult(UserConfFile)),
    lists:foldl(fun({Key, Value}, AccPropList) ->
                        proplists:delete(Key, AccPropList),
                        case lists:keyfind(Key, 1, AccPropList) of
                            false ->
                                [{Key, Value} | AccPropList];
                            {_, Val} ->
                                if 
                                    Val =:= undefined orelse
                                    Val =:= [] ->
                                        [{Key, Value}|proplists:delete(Key, AccPropList)];
                                    true ->
                                        AccPropList
                                end
                        end
                end, UserConf, DefaultConf).

app_default({ok,[{application,server, KVs}]}) ->
    EnvList = proplists:get_value(env, KVs),
    env(EnvList).

user_conf({ok,[AppConfList]}) ->
    EnvList = proplists:get_value(server, AppConfList),
    env(EnvList).

env(EnvList) ->
    MySQLUserInfo = [{user, proplists:get_value(default_mysql_user, EnvList)},
                     {password, proplists:get_value(default_mysql_password, EnvList)},
                     {port, proplists:get_value(default_mysql_port, EnvList)},
                     {host, proplists:get_value(default_mysql_host, EnvList)}],
    DBs = [proplists:get_value(db, DbConf) || {_, DbConf} <- proplists:get_value(mysql_conf, EnvList, [])],
    [{dbs, lists:sort(DBs)} | MySQLUserInfo].


rel_env_conf(h149) ->
    {app_misc:server_root() ++ "src/server.app.src", app_misc:server_root() ++ "sh/db_disc_1/sys.config"};
rel_env_conf(ucloud) ->
    {app_misc:server_root() ++ "config/ucloud/server.app",  app_misc:server_root() ++ "config/ucloud/sys.config"}.

update_env_conf(ucloud) ->
    {app_misc:server_root() ++ "src/server.app.src", app_misc:server_root() ++ "sh/db_disc_1/sys.config"}.

ssh_connect_host(h149) ->
    "root@192.168.1.149";
ssh_connect_host(ucloud) ->
    "root@moyou.me".

cmd_print_ret(Cmd) ->
    %%os:cmd(Cmd).
    io:format("Cmd: ~ts~n", [Cmd]),
    Ret = os:cmd(Cmd),
    io:format("Ret: ~ts~n", [Ret]),
    Ret.

mysql_struct_compare(Source, Target) ->
    %% SSHConnectHost = ssh_connect_host(Source),
    SourceDbConf = db_conf(rel_env_conf(Source)),
    SourceDumpList = dump(Source, SourceDbConf),
    TargetDbConf = db_conf(rel_env_conf(Target)),
    TargetDumpList = dump(Target, TargetDbConf),
    ds_misc:list_dualmap(fun(SourceDumpFile, TargetDumpFile) ->
                                 mysql_struct_compare(SourceDumpFile, TargetDumpFile, SourceDbConf)
                         end, SourceDumpList, TargetDumpList).


mysql_struct_compare_script() ->
    app_misc:server_root() ++ "sh/rel_tool/mysql_struct_compare.sh".

mysql_struct_compare({DbName, SourceDumpFile}, {_, TargetDumpFile}, DbConf) ->
    User = proplists:get_value(user, DbConf),
    Password = proplists:get_value(password, DbConf),
    %% Port = proplists:get_value(port, DbConf),
    Host = proplists:get_value(host, DbConf),
    %% Dbs =  proplists:get_value(dbs, DbConf),
    Cmd = string:join([mysql_struct_compare_script(), Host, User, Password, "p04_source", "p04_target", 
                       SourceDumpFile, TargetDumpFile, DbName], " "),
    cmd_print_ret(Cmd).

dump_script() ->
    app_misc:server_root() ++ "sh/rel_tool/mysql_struct_dump.sh".

dump(Identity, DbConf) ->    
    User = proplists:get_value(user, DbConf),
    Password = proplists:get_value(password, DbConf),
    %% Port = proplists:get_value(port, DbConf),
    Host = proplists:get_value(host, DbConf),
    Dbs =  proplists:get_value(dbs, DbConf),
    [begin 
         SSHHost = ssh_connect_host(Identity),
         Cmd = string:join([dump_script(), SSHHost, Host, User, Password, Db], " "),
         cmd_print_ret(Cmd),
         DumpFile = "/tmp/" ++ "/" ++ SSHHost ++ "_" ++ Db ++ ".sql",
         {Db, DumpFile}
     end || Db <- Dbs].


update_script() ->
    app_misc:server_root() ++ "sh/rel_tool/mysql_struct_update.sh".

mysql_update(Target) ->
    DbConf = db_conf(update_env_conf(Target)),
    User = proplists:get_value(user, DbConf),
    Password = proplists:get_value(password, DbConf),
    %% Port = proplists:get_value(port, DbConf),
    Host = proplists:get_value(host, DbConf),
    Dbs =  proplists:get_value(dbs, DbConf),
    [begin
         Cmd = string:join([update_script(), Host, User, Password, Db, mysql_update_file(Db)], " "),
         cmd_print_ret(Cmd)
     end || Db <- Dbs].

mysql_update_file(Db) ->
    app_misc:server_root() ++ "db_update/" ++ Db ++ ".patch.sql".

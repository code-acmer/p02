%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@moyou.me>
%%% @copyright (C) 2015, liu
%%% @doc
%%% 在线实现定时对数据库的备份，其实就是拷贝文件夹，出问题之后可以覆盖回去
%%% @end
%%% Created :  9 Feb 2015 by liu <liuzhigang@moyou.me>
%%%-------------------------------------------------------------------
-module(lib_mnesia_bup).
-include("define_logger.hrl").
-define(BACKUP_COUNT, 5).
-export([backup/0]).

backup() ->
    case app_misc:get_env(node_type) of
        disc ->
            ServerRoot = app_misc:server_root(),
            BupDir = ServerRoot ++ "/mnesia_backup/",
            case filelib:ensure_dir(BupDir) of
                ok ->
                    case make_copy(BupDir) of
                        ok ->
                            ok;
                        {error, Reason} ->
                            ?WARNING_MSG("make backup error ~p~n", [Reason]),
                            skip
                    end;
                {error, Reason} ->
                    ?WARNING_MSG("ensure BupDir ~p error ~p~n", [BupDir, Reason]),
                    skip
            end;
        _ ->
            skip
    end.

make_copy(BupDir) ->
    Prefix = lists:concat([BupDir, node(), "_"]),
    case filelib:wildcard(Prefix ++ "*") of
        [] ->
            make_copy2(Prefix);
        FileList ->
            {_, Tail} = 
                list_misc:sublist(
                  lists:sort(fun(FileA, FileB) ->
                                     FileA > FileB
                             end, FileList), ?BACKUP_COUNT - 1),
            file_misc:recursive_delete(Tail),
            make_copy2(Prefix)
    end.

make_copy2(Prefix) ->
    Desc = lists:concat([Prefix, time_misc:yyyymmdd(), "_", time_misc:unixtime()]),
    file_misc:recursive_copy(mnesia_misc:dir(), Desc).

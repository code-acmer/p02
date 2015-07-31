-module(reloader_misc).
-export([init/0,
         reload_all/0]).

-include_lib("kernel/include/file.hrl").

-define(RELOADER_TABLE, ets_reloader_info).

%%想一下应该不是全部去reload，可以加一个版本校对，看哪些是需要reload的
init() ->
    ets:new(?RELOADER_TABLE, [named_table, public]),
    lists:foreach(fun({Module, Filename}) ->
                          add_new_file(Module, Filename)
                  end, all_server_beam()),
    ok.

add_new_file(Module, Filename) ->
    case file:read_file_info(Filename) of
        {ok, #file_info{mtime = Mtime}} ->
            ets:insert(?RELOADER_TABLE, {Module, Mtime});
        {error, Reason} ->
            error_logger:error_msg("init read ~p error Reason ~p~n", [Filename, Reason])
    end.

all_server_beam() ->
    [{Module, Filename} || {Module, Filename} <- code:all_loaded(), is_list(Filename), filter_module(Filename)].

reload_all() ->
    [case file:read_file_info(Filename) of
         {ok, #file_info{mtime = Mtime}} ->
             reload(Module, Mtime);
         {error, enoent} ->
             %% The Erlang compiler deletes existing .beam files if
             %% recompiling fails.  Maybe it's worth spitting out a
             %% warning here, but I'd want to limit it to just once.
             gone;
         {error, Reason} ->
             error_logger:error_msg("Error reading ~s's file info: ~p~n",
                                    [Filename, Reason]),
             error
     end || {Module, Filename} <- all_server_beam()],
    error_logger:info_msg("reloader finish ~n", []),
    ok.

reload(Module, Mtime) ->
    LastTime = 
    case ets:lookup(?RELOADER_TABLE, Module) of
        [] ->
            error_logger:info_msg("add new module ~p~n", [Module]),
            ets:insert(?RELOADER_TABLE, {Module, Mtime}),
            0;
        [{_, OldMtime}] ->
            OldMtime
    end,
    if
        Mtime =:= LastTime ->
                                                %error_logger:info_msg("~p the same skip ~n", [Module]),
            skip;
        true ->
            case code:soft_purge(Module) of
                true ->
                    case code:load_file(Module) of
                        {module, Module} ->
                            error_logger:info_msg("reload ~w ok.~n", [Module]),
                            ets:insert(?RELOADER_TABLE, {Module, Mtime}),
                            reload;
                        {error, Reason} ->
                            error_logger:error_msg("load_file ~p fail: ~p.~n", [Module, Reason]),
                            error
                    end;
                false ->
                    error_logger:error_msg("soft_purge ~p fail ~n", [Module])
            end
    end.

filter_module(Filename) ->
    RootPath = app_misc:server_root(),
    lists:prefix(RootPath, Filename).

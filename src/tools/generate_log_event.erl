-module(generate_log_event).


-define(HEADER_PATH, "../include/").

-export([start/0]).

-include("db_base_log_user.hrl").
-include("define_mysql.hrl").


%%-------------------- ensure --------------------
%% 确保deps的App启动
ensure_deps_started() ->
    [ok = ensure_started(App) || App <- [crypto, emysql]].

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

ensure_pool_added(Options) ->
    Db = db_base,
    Poolsize = 1,
    User = proplists:get_value(db_user, Options, "mroot"),
    Password = proplists:get_value(db_password, Options, "mroot"),
    Host = proplists:get_value(db_host, Options, "192.168.1.149"),
    Port = proplists:get_value(db_port, Options, 3306),
    DataBase = proplists:get_value(db_base, Options, "p02_base"),
    case catch emysql:add_pool(Db, Poolsize, User, Password, Host, Port, DataBase, utf8) of
        {'EXIT', pool_already_exists} ->
            ok;
        Other ->
            Other
    end.

-define(TABLE_CONF, #record_mysql_info{
                       db_pool = db_base,
                       table_name = base_log_user,
                       record_name = base_log_user,
                       fields = record_info(fields, base_log_user)
                      }).

start() ->
    ensure_deps_started(),
    %% ensure_pool_added([{db_user, "mroot"}, 
    %%                    {db_password, "mroot"},
    %%                    {db_host, "192.168.1.149"}]), 
    ensure_pool_added([]), 
    data_module:import_from_csv([base_log_user]),
    {ok, L} = db_mysql_base:select(?TABLE_CONF, undefined),
    generate_info_header_file(L),
    halt(), 
    ok.

%% %% @doc 根据文件名和内容生成对应的信息
%% %% @spec
%% %% @end
generate_info_header_file(List) ->
    WarningStr = <<"%% Warning:本文件由"/utf8, (atom_to_binary(?MODULE, unicode))/binary, "自动生成，请不要手动修改\n"/utf8>>,
    IfDefStr = <<"-ifndef(DEFINE_LOG_EVENT_HRL).\n-define(DEFINE_LOG_EVENT_HRL, true).\n\n">>,
    EndIfStr = <<"\n\n-endif.\n\n">>,
    %% 生成宏定义的内容
    DefsStr =
        lists:map(fun(#base_log_user{
                         id = Id,
                         macro = Macro,
                         comment = Comment,
                         arg1_comment = Arg1Comment,
                         arg2_comment = Arg2Comment
                        }) ->
                          <<"-define(", Macro/binary, 
                              ", ", (integer_to_binary(Id))/binary,
                              ").   %% ", 
                              Comment/binary, " || ",
                              Arg1Comment/binary, " || ",
                              Arg2Comment/binary, "\n">>
                  end, List),
    FilePath = filename:join([app_misc:server_root(), "include/define_log_event.hrl"]),
    Ret = file:write_file(FilePath, [WarningStr, IfDefStr, DefsStr, EndIfStr]),
    io:format("write file Ret ~p~n", [Ret]).

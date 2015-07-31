-module(define_mail_to_db).
-include_lib("emysql/include/emysql.hrl").
-include("db_base_mail.hrl").

-export([start/0]).

start() ->
    ok = io:setopts([{encoding, unicode}]),
    ensure_deps_started(),
    %% ensure_pool_added([{db_user, "mroot"}, 
    %%                    {db_password, "mroot"},
    %%                    {db_host, "192.168.1.149"}]), 
    ensure_pool_added([]), 
    HeaderFiles = header_files(),
    AllDataList = 
        lists:foldl(fun(HeaderFile, AccDataList) ->
                            {ok, Bin} = file:read_file(HeaderFile),
                            DefineList = string:tokens(binary_to_list(Bin), "\n"),
                            DataList =
                                lists:foldl(fun(Define, Acc) ->
                                                    Data = get_data_from_define(Define),
                                                    if
                                                        is_tuple(Data) ->
                                                            [Data | Acc];
                                                        true ->
                                                            Acc
                                                    end
                                            end, [], DefineList),
                            DataList ++ AccDataList
                    end, [], HeaderFiles),
    Ret1 = emysql:execute(db_base, "DELETE FROM base_mail"),
    io:format("delete base_mail ~p~n", [Ret1]),
    SQL = sql(AllDataList),
    Ret2 = emysql:execute(db_base, SQL, 100000),
    io:format("Ret ~p~n", [Ret2]),
    ok.

header_files() ->
    [filename:join([app_misc:server_root(), "include/define_mail_text.hrl"])].



sql(List) ->
    Base = "INSERT INTO `base_mail` (`id`, `title`, `content`, `mail_define`) VALUES ",
    ValFun = fun(Macro, Integer, Map) ->
                     lists:concat(["(\"", Integer, "\",\"", 
                                   maps:get(title, Map) , "\",\"", 
                                   maps:get(content, Map) , "\",\"",                                    
                                   Macro, "\") "])
             end,
    Vals = [ValFun(Macro, Integer, Comment) ||
               {Macro, Integer, Comment} <- List],
    [Base | string:join(Vals, ",")].
        

get_data_from_define(Define) ->
    case erl_scan:string(Define, 0, [return_comments]) of
        {ok, [{'-', _},
              {atom, _, define},
              {'(', _},
              {var, _, Macro},
              {',', _},
              {integer, _, Integer},
              {')', _},
              {dot, _},
              {comment, _, Comment}],
         _} ->
            NewComment = string:strip(string:strip(Comment, left, $%), left, $ ),
            Map = string_to_term(NewComment),
            {Macro, Integer, Map};
        _Other ->
            undefined
    end.

string_to_term(String) ->
    case erl_scan:string(String++".") of
        {ok, Tokens, _} ->
            case erl_parse:parse_term(Tokens) of
                {ok, Term} -> 
                    Term;
                Err -> 
                    io:format("~p~n", [Err]),
                    throw({String, Err})
            end;
        Error ->
            io:format("~p~n", [Error]),
            throw({String, Error})
    end.

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

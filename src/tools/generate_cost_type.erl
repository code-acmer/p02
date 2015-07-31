-module(generate_cost_type).
-export([start/0]).

init(DbConf) ->
    ok = application:start(crypto),
    ok = application:start(emysql),
    Db = proplists:get_value(db_base, DbConf),
    Host = proplists:get_value(host, DbConf),
    Port = proplists:get_value(port, DbConf),
    User = proplists:get_value(user, DbConf),
    Password = proplists:get_value(password, DbConf),
    emysql:add_pool(db001, 1, User, Password, Host, Port, Db, utf8).
    %mysql:start_link(db001, Host, User, Password, "p02_base").

start() ->
    InfoList = get_db_config(),
    init(InfoList),
    case emysql:execute(db001, "select * from base_cost_type") of
        {result_packet, _, _, DbInfoList, _} ->
            inner_handle(DbInfoList);
        Other ->
            io:format("error db sql~p~n", [Other])
    end.

get_db_config() ->
    Filename = "./config/make_cost_type.conf",
    case file:consult(Filename) of
        {ok, [Result]} ->
            io:format("Result ~p~n", [Result]),
            Result;
        _ ->
            catch error(not_table_to_record_conf)
    end.

inner_handle(DbInfoList) ->
    FileString = 
        lists:map(fun([Code, Define, Desc]) ->
                          lists:concat(["-define(", bitstring_to_list(Define), ",\t",
                                        Code, ").\t", "%%", bitstring_to_list(Desc), "\n" ])
                  end, DbInfoList),
    Head = "-ifndef(DEFINE_COST_TYPE_HRL).\n-define(DEFINE_COST_TYPE_HRL, true).\n\n",
    Bin = list_to_binary([Head, lists:flatten(FileString), "-endif."]),
    hfile:writelines_new("./include/define_cost_type.hrl", Bin).

    


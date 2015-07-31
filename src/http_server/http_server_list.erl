-module(http_server_list).
-export([init/0,
         get_server_list/1]).

init() ->
    init_server_list().

init_server_list() ->
    ServerListFile = 
        app_misc:server_root() ++ "/config/server_list.conf",
    io:format("ServerListFile ~p~n", [ServerListFile]),
    case file:consult(ServerListFile) of
        {error, Reason} ->
            %throw({read_server_list_file_error, Reason});
            ok;
        {ok, [ConfigList]} ->
            io:format("ConfigList ~p~n", [ConfigList]),
            JsonList = 
                lists:map(fun({Sn, Ip, Port}) ->
                                  {[{sn, Sn}, {ip, unicode:characters_to_binary(Ip)}, {port, Port}]}
                          end, ConfigList),
            io:format("JsonList ~p~n", [JsonList]),
            ReturnJason = jiffy:encode(JsonList, [pretty]),
            mochiglobal:put(server_list, ReturnJason)
    end.

get_server_list([]) ->
    case app_misc:mochi_get(server_list) of
        undefined ->
            <<"[]">>;
        Other ->
            Other
    end;
get_server_list(_) ->
    {fail, <<"error args">>}.

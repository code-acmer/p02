-module(http_admin).
-export([start/1]).

-define(MAX_CONNS, 3000).

start(Port) ->
    may_init(Port),
    app_misc:start(cowboy),
    ServerRoot = app_misc:server_root(),
    Dispatch = cowboy_router:compile([
                                      %% {URIHost, list({URIPath, Handler, Opts})}
                                      {'_', [
                                             {"/", cowboy_static, {file, ServerRoot ++ "/priv/" ++"index.html"}},
                                             {"/style.css", cowboy_static, {file, ServerRoot ++ "/priv/" ++ "style.css"}},
                                             {"/server_state.html", cowboy_static, {file, ServerRoot ++ "/priv/" ++ "server_state.html"}},
                                             {"/get_server_list", http_handler, [center_node]},
                                             {'_', http_handler, []}
                                            ]}
                                     ]),
    cowboy:start_http(http, 10, [{port, Port}, {max_connections, ?MAX_CONNS}],
                      [{env, [{dispatch, Dispatch}]}]).

may_init(Port) ->
    case app_misc:mochi_get(center_node_port) of
        Port ->
            http_server_list:init();
        _ ->
            skip
    end.

-module(center).
-export([start/0,
         update_counter/2]).

-record(counter, {type,
                  counter}).

start() ->
    io:format("center start ~n"),
    case application:get_env(port) of
        undefined ->
            throw({port_not_setting});
        {ok, Port} ->
            io:format("Port ~p~n", [Port]),
            app_misc:mochi_set(center_node_port, Port),
            http_admin:start(Port),
            init_mnesia()
    end.
    
init_mnesia() ->
    case mnesia:system_info(use_dir) of
        false ->
            mnesia:stop(),
            mnesia:create_schema([node()]);
        _ ->
            skip
    end,
    ok = mnesia:start(),
    case mnesia:system_info(tables) of
        [schema] ->
            mnesia:create_table(counter, [{type, set}, {disc_copies, [node()]}, {attributes, record_info(fields, counter)}]);
        _ ->
            skip
    end,
    mnesia:set_master_nodes([node()]),
    ok.

update_counter(UidType, Incr) ->
    Counter = mnesia:dirty_update_counter(counter, UidType, Incr),
    group_leader(whereis(user), self()),
    error_logger:info_msg("UidType  ~p now is ~p ~p~n", [UidType, Counter, erlang:localtime()]),
    Counter.

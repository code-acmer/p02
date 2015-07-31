-module(center_main).
-export([start/0,
         stop_master/1,
         stop/0]).

start() ->
    error_logger:info_msg("start ~p~n", [self()]),
    application:start(p02_center).

stop_master([Node]) ->
    error_logger:info_msg("Node ~p~n", [Node]),
    rpc:call(Node, center_main, stop, []),
    init:stop().

stop() ->
    group_leader(whereis(user), self()),
    error_logger:info_msg("center_node stop ~p~n", [erlang:localtime()]),
    application:stop(p02_center),
    init:stop().
    

-module(test_dungeon).
-export([start/0]).

start() ->
    application:start(hstdlib),
    hloglevel:set(6),
    lib_dungeon:run_all_dungeon(100).

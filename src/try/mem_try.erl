-module(mem_try).

-export([start/1]).

start(Key) ->
    put(Key, lists:seq(1, 10000000)).

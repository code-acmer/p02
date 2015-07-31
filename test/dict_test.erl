-module(dict_test).
-compile(export_all).
test() ->
    lists:foldl(fun(K, D) ->
                        dict:store(K*16, K, D)
                end, dict:new(), lists:seq(1,200)).

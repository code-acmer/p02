-module(random_cache).

-export([
         new/1,
         add/2,
         remove/2,
         get_values/2
        ]).

-define(SIZE, 5000).
-define(CHOOSE_COUNT, 5).

-record(random_cache, {max  = ?SIZE,
                       cur  = 0,
                       list = []
                      }).

new(Size) ->
    #random_cache{max = Size}.


add(Value, #random_cache{max  = Max,
                         cur  = Cur,
                         list = List} = Cache) when Cur < Max ->
    case lists:member(Value, List) of
        false ->
                Cache#random_cache{
                  cur = Cur+1,
                  list = [Value|List]
                 };
        _ ->
            Cache
    end.


remove(Value, #random_cache{cur = Cur,
                            list = List
                           } = Cache) when Cur > 0->
    NewList = lists:delete(Value, List),
    Cache#random_cache{
      cur = Cur - 1,
      list = NewList
     };
remove(_, Cache) ->
    Cache.


get_values(N, #random_cache{cur  = Cur,
                            list = List
                           } = _Cache) when N > Cur ->
    List;
get_values(N, #random_cache{list = List}) ->
    hmisc:rand_n(N, List).


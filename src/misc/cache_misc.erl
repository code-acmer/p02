%% * feature
%% ** time to live 定时清理，由mod_cache负责
%% ** 并发读/写
%% ** 自动从mnesia读
%% ** 不打算实现index_read，上层去维护。查看某个玩家的所有穿戴装备，那么在cache存{{player_equips, PlayerId}, Equips}即可。只是这个set并不是自动的而已。

-module(cache_misc).


-export([
         start/0,
         set/2, set/3,
         get/1, get/2,
         del/1,
         get_with_default/2,
         update_counter/2
        ]).
-include("define_cache.hrl").
-include("define_time.hrl").
-define(DEFAULT_EXPIRATION, 2*60*60).
start() ->
    server_sup:start_child(mod_cache, []).

set(Key, Value) ->
    set(Key, Value, ?DEFAULT_EXPIRATION).

set(Key, Value, Expiration) 
  when is_integer(Expiration)->
    ExpireAfter = time_misc:unixtime() + Expiration,
    true = ets:insert(?CACHE_DATA_TABLE, {Key, Value, ExpireAfter}),
    ok;
set(Key, Value, infinity) ->
    true = ets:insert(?CACHE_DATA_TABLE, {Key, Value, infinity}),
    ok.

get(Table, Key) ->
    case cache_misc:get({Table, Key}) of
        [] ->
            get_from_mnesia(Table, Key);
        Val ->
            Val
    end.

get(Key) ->
    case ets:lookup(?CACHE_DATA_TABLE, Key) of
        [{_Key, Value, _Expiration}] ->
            Value;
        [] -> 
            []
    end.

get_from_mnesia(Table, Key) ->    
    case hdb:dirty_read(Table, Key) of
        [] ->
            [];
        Value ->
            set({Table, Key}, Value),
            Value
    end.

del(Key) ->
    true = ets:delete(?CACHE_DATA_TABLE, Key),
    ok.

get_with_default(Key, CalValFun) ->
    case cache_misc:get(Key) of
        [] ->
            case CalValFun() of
                {expiration, Value, Expiration} ->
                    set(Key, Value, Expiration),
                    Value;
                {val, Value} ->
                    set(Key, Value),
                    Value
            end;
        Val ->
            Val
    end.

update_counter(Key, Counter) ->
    ets:update_counter(?CACHE_DATA_TABLE, Key, Counter).

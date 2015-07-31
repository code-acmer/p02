-module(lib_counter).
-export([init/0, all_uids/0, update_counter/2, update_counter/1, write_new_counter/2]).


-include("define_mnesia.hrl").
-include("common.hrl").
-include("define_counter.hrl").

init() ->
    %%[maybe_init_uid(UidType) || UidType <- ?ALL_COUNTERS],
    ok.

%% use for test
all_uids() ->
    [hdb:dirty_read(counter, Key) || Key <- mnesia:dirty_all_keys(counter)].
    %%[hdb:dirty_read(counter, node_key(UidType)) || UidType <- ?ALL_COUNTERS].
    
update_counter(UidType) ->
    update_counter(UidType, 1).

%%counter就全部远程去拿
update_counter(UidType, Incr)
  when UidType =:= arena_report_uid 
       orelse UidType =:= dungeon_match_uid
       orelse UidType =:= chats_world_uid
       orelse UidType =:= team_uid
       orelse UidType =:= cross_pvp_report_uid
       orelse UidType =:= cross_robot_uid ->
    Id = mnesia:dirty_update_counter(counter, UidType, Incr),
    if
        Id > ?MAX_LOCAL_COUNTER ->
            mnesia:dirty_write(counter, #counter{type = UidType,
                                                 counter = 1});
        true ->
            skip
    end,
    %% 需要测试app_misc:get_env(local_sn_num)性能
    Id * 1000 + app_misc:get_env(local_sn_num);
update_counter(UidType, Incr) ->
    [CountTable] = server_misc:get_local_table(counter),
    ?DEBUG("CountTable: ~p", [CountTable]),
    Id = mnesia:dirty_update_counter(CountTable, UidType, Incr),
    ?DEBUG("Id: ~p", [Id]),
    Id * 1000 + app_misc:get_env(local_sn_num).

write_new_counter(UidType, Num) ->
    mnesia:dirty_write(counter, #counter{type = UidType,
                                         counter = Num}).
%%把一些counter作为本地的counter，不用去远程取，并且可以重置
%% update_counter(UidType, Incr)
%%   when UidType =:= arena_report_uid 
%%        orelse UidType =:= dungeon_match_uid
%%        orelse UidType =:= chats_world_uid
%%        orelse UidType =:= team_uid
%%        orelse UidType =:= cross_pvp_report_uid->
%%     Id = mnesia:dirty_update_counter(counter, node_key(UidType), Incr),
%%     if
%%         Id > ?MAX_LOCAL_COUNTER ->
%%             mnesia:dirty_write(counter, #counter{type = node_key(UidType),
%%                                                  counter = 1});
%%         true ->
%%             skip
%%     end,
%%     Id;
%% update_counter(UidType, Incr) ->
%%     case lists:member(UidType, ?ALL_COUNTERS) of
%%         true ->
%%             Id = mnesia:dirty_update_counter(counter, node_key(UidType), Incr),
%%             check_overflow(UidType, Id),
%%             Id;
%%         false ->
%%             throw({not_exist_counter, "Please add counter to ALL_COUNTERS, this macro in lib_counter.erl"})
%%     end. 


-define(OVERFLOW_VALUES, [8000000, 8300000, 8600000, 8900000, 9100000]).
-define(WILL_OVERFLOW_VALUE, 9999000).
%% -define(OVERFLOW_VALUES, [1, 2, 3, 9, 6]).
%-define(WILL_OVERFLOW_VALUE, 5000000).

%% 如果id快用完，就打日志报警
%% Id div ?RANGE * ?RANGE + 1 =< Id =<  (1+Id div ?RANGE) * ?RANGE - 1 
%% check_overflow(UidType, Id) ->
%%     Pos = Id rem ?RANGE,
%%     if 
%%         Pos >= ?WILL_OVERFLOW_VALUE ->
%%             ?WARNING_MSG("~p will overflow, now is ~p, reinit ~n", [UidType, Id]),
%%             init_uid(UidType, Id div ?RANGE + 1);
%%         true ->
%%             ok
%%     end.
                    
%% node_key(UidType) ->
%%     {UidType, node()}.

%% maybe_init_uid(UidType) ->
%%     Key = node_key(UidType),
%%     case hdb:dirty_read(counter, Key) of
%%         [] ->
%%             init_uid(UidType);
%%         _ ->
%%             ok
%%     end.

%% init_uid(UidType) ->
%%     init_uid(UidType, undefined).

%% init_uid(UidType, OldRangeId) ->
%%     ok = mod_counter:init_new_counter(UidType, OldRangeId).

    

%% >>> (2**31-1)/10000000
%% 214
%% maybe_warning_range_id(RangeId) when RangeId >= 200 ->
%%     ?WARNING_MSG("RangeId ~p will overflow ~n", [RangeId]);
%% maybe_warning_range_id(_) ->
%%     ok.
   
test() ->
    Fun = fun() ->
                  Ids = [lib_counter:update_counter(player_uid, 500000) ||
                            _ <- lists:seq(1, 1)],
                  ?DEBUG("ok ~p~n", [Ids])
          end,
    [spawn(Fun) || _ <- lists:seq(1,50)],
    hdb:dirty_read(counter, {player_uid, '__ALL_NODES__'}).

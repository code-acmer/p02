-module(pp_rank).
-export([handle/3]).

-include("define_info_24.hrl").
-include("pb_24_pb.hrl").
-include("define_logger.hrl").
-include("define_player.hrl").
-include("define_rank.hrl").

%%获取战斗力排行榜
handle(24001, ModPlayerState, _) ->
    WriteTable = hdb:sn_table(battle_ability_rank, ModPlayerState?PLAYER_SN),
    {SelfInfo, RankList} = lib_rank:get_rank_info(WriteTable, 20, ModPlayerState?PLAYER_ID),
    {ok, Bin} = pt_24:write(24001, {SelfInfo, RankList}),
    packet_misc:put_packet(Bin);

%%获取等级排行榜
handle(24002, ModPlayerState, _) ->
    WriteTable = hdb:sn_table(level_rank, ModPlayerState?PLAYER_SN),
    {SelfInfo, RankList} = lib_rank:get_rank_info(WriteTable, 20, ModPlayerState?PLAYER_ID),
    {ok, Bin} = pt_24:write(24002, {SelfInfo, RankList}),
    packet_misc:put_packet(Bin);

%%获取铜钱消费排行榜
handle(24003, ModPlayerState, _) ->
    WriteTable = hdb:sn_table(cost_coin_rank, ModPlayerState?PLAYER_SN),
    {SelfInfo, RankList} = lib_rank:get_rank_info(WriteTable, 20, ModPlayerState?PLAYER_ID),
    {ok, Bin} = pt_24:write(24003, {SelfInfo, RankList}),
    packet_misc:put_packet(Bin);

%%获取金币消费排行榜
handle(24004, ModPlayerState, _) ->
    WriteTable = hdb:sn_table(cost_gold_rank, ModPlayerState?PLAYER_SN),
    ?DEBUG("WriteTable: ~p ~n",[WriteTable]),
    {SelfInfo, RankList} = lib_rank:get_rank_info(WriteTable, 20, ModPlayerState?PLAYER_ID),
    {ok, Bin} = pt_24:write(24004, {SelfInfo, RankList}),
    packet_misc:put_packet(Bin);

%%世界boss开启排行榜
handle(24005, ModPlayerState, _) ->
    WriteTable = hdb:sn_table(world_boss_rank, ModPlayerState?PLAYER_SN),
    {SelfInfo, RankList} = lib_rank:get_rank_info(WriteTable, 20, ModPlayerState?PLAYER_ID),
    {ok, Bin} = pt_24:write(24005, {SelfInfo, RankList}),
    packet_misc:put_packet(Bin);

handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.

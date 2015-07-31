-module(pp_arena).
-export([handle/3]).

-include("define_logger.hrl").
-include("define_player.hrl").
-include("pb_23_pb.hrl").
-include("define_info_23.hrl").
-include("define_arena.hrl").
-include("define_task.hrl").

%%获取异步竞技场信息
handle(23000, #mod_player_state{player = Player}, _) ->
    case lib_arena:get_player_rank(async_arena_rank, Player) of
        [RankInfo] ->
            {ok, Bin} = pt_23:write(23000, RankInfo),
            packet_misc:put_packet(Bin);
        _ ->
            packet_misc:put_info(?INFO_CONF_ERR)
    end;
%%获取异步竞技场推荐
handle(23001, #mod_player_state{player = Player}, _) ->
    case lib_arena:recommend_player(Player) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {_Self, RankList} ->
            {ok, Bin} = pt_23:write(23001, RankList),
            packet_misc:put_packet(Bin)
    end;
%%竞技场挑战(打完才发包吧)
handle(23002, ModPlayerState, #pbarenachallenge{id = Tid,
                                                result = Result,
                                                robot = RobotFlag}) ->
    case lib_arena:player_challenge(async_arena_rank, ModPlayerState, {Tid, Result, RobotFlag}) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {fail, Reason, Arena} ->
            packet_misc:put_info(Reason),
            {ok, Bin2} = pt_23:write(23000, Arena),
            packet_misc:put_packet(Bin2);
        {ok, NewModPlayerState, Arena} ->
            {ok, Bin} = pt_23:write(23002, null),
            packet_misc:put_packet(Bin),
            {ok, Bin2} = pt_23:write(23000, Arena),
            packet_misc:put_packet(Bin2),
            {ok, NewModPlayerState}
    end;
%%获取竞技场的战报信息
handle(23003, ModPlayerState, _) ->
    ReportList = lib_arena:get_arena_report(async_arena_report, ModPlayerState?PLAYER_ID),
    {ok, Bin} = pt_23:write(23003, ReportList),
    packet_misc:put_packet(Bin);
%%获取异步排行榜信息
handle(23005, ModPlayerState, _) ->
    RankList = lib_arena:rank_top(async_arena_rank, ModPlayerState?PLAYER_SN, ?RANK_SEND_SIZE),
    %?DEBUG("RankList ~p~n", [RankList]),
    {ok, Bin} = pt_23:write(23005, RankList),
    packet_misc:put_packet(Bin);

%%购买挑战次数
handle(23006, ModPlayerState, _) ->
    case lib_arena:buy_challenge_times(ModPlayerState?PLAYER) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewPlayer, Rank} ->
            {ok, Bin} = pt_23:write(23000, Rank),
            packet_misc:put_packet(Bin),
            {ok, ModPlayerState#mod_player_state{player = NewPlayer}}
    end;

%%------------------10人PVP也放在这边------------------%%
%%获取自己的的小岛占领信息
handle(23500, ModPlayerState, _) ->
    case lib_cross_pvp:try_load_fighter(ModPlayerState?PLAYER) of
        {ok, Fighter} ->
            {ok, Bin} = pt_23:write(23500, Fighter),
            packet_misc:put_packet(Bin);
        _ ->
            packet_misc:put_info(?INFO_PVP_ISLAND_NOT_FOUND)
    end;

%%挑战
handle(23501, ModPlayerState, #pbarenachallenge{id = IslandId}) ->
    case lib_cross_pvp:attack(ModPlayerState?PLAYER_ID, IslandId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, Island} ->
            {ok, Bin} = pt_23:write(23501, Island),
            packet_misc:put_packet(Bin)
    end;
%%挑战结果
handle(23502, ModPlayerState, #pbarenachallenge{id = IslandId,
                                                %% robot = Robot,
                                                result = Result})
  when is_integer(IslandId) ->
    case lib_cross_pvp:handle_fight_result(ModPlayerState, IslandId, Result) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            RETModPlayerState = lib_task:task_event(NewModPlayerState, {?TASK_ARENA, ?TASK_ARENA_CROSS, 1}),
            {ok, RETModPlayerState};
        _  ->
            ignored
    end;
%%战报
%% handle(23503, ModPlayerState, _) ->
%%     ReportList = lib_cross_pvp:get_player_records(ModPlayerState?PLAYER_ID),
%%     {ok, Bin} = pt_23:write(23503, ReportList),
%%     packet_misc:put_packet(Bin);

%%购买挑战次数
handle(23504, ModPlayerState, _) ->
    case lib_cross_pvp:buy_times(ModPlayerState?PLAYER) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewFighter, NewPlayer} ->
            {ok, Bin} = pt_23:write(23504, NewFighter),
            packet_misc:put_packet(Bin),
            {ok, ModPlayerState#mod_player_state{player = NewPlayer
                                                }}
    end;

handle(23505, ModPlayerState, #pbid32{id = IslandId}) ->
    case lib_cross_pvp:reset_island(ModPlayerState?PLAYER, IslandId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, Island} ->
            {ok, Binary} = pt_23:write(23505, Island),
            packet_misc:put_packet(Binary)
    end;

handle(23506, ModPlayerState, _) ->
    case lib_cross_pvp:try_take_reward(ModPlayerState) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, Binary} = pt_23:write(23506, null),
            packet_misc:put_packet(Binary),
            {ok, NewModPlayerState}
    end;




%%获取历史排名
%% handle(23505, ModPlayerState, _) ->
%%     List = lib_cross_pvp:get_history(ModPlayerState?PLAYER_ID),
%%     {ok, Bin} = pt_23:write(23505, List),
%%     packet_misc:put_packet(Bin);

handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.

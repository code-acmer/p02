-module(lib_gm).
-include("define_player.hrl").
-include("define_goods_type.hrl").
-include("define_logger.hrl").
-include("define_info_9.hrl").
-include("define_info_13.hrl").
-include("define_money_cost.hrl").
-include("define_goods.hrl").
-include("define_dungeon.hrl").
-include("define_task.hrl").
-include("pb_15_pb.hrl").
-include("pb_30_pb.hrl").
-include("define_time.hrl").
-include("define_boss.hrl").
-include("define_mail.hrl").
-include("define_arena.hrl").
-include("define_dungeon_match.hrl").
-include("define_cross_pvp.hrl").
-include("define_league.hrl").
-define(GM_OPEN, 1).
-define(NORMAL_EQUIP, [22110011, 22120011, 22200011, 22300011, 22400011, 22500011, 22700011]).
-define(NORMAL_JEWEL, [270101, 270201, 270301, 270401, 270501, 270601, 270701]).
-export([cmd/2]).

cmd(ModPlayerState, Data) ->
    case app_misc:get_env(can_gmcmd) =:= ?GM_OPEN of
        false ->
            {fail, ?INFO_GM_CMD_ERROR};
        true ->
            case hmisc:split_and_strip(Data, ",", $ ) of
                [] ->
                    {fail, ?INFO_GM_CMD_ERROR};
                [Cmd|ValueList] -> 
                    TermList = to_term(ValueList),
                    handle_cmd(Cmd, TermList, ModPlayerState)
            end
    end.

to_term(ValueList) ->
    [hmisc:string_to_term(Value) || Value <- ValueList].
    
handle_cmd(Cmd, [Num], ModPlayerState) 
  when Cmd =:= "-gold"; Cmd =:= "-coin"; Cmd =:= "-vigor"; Cmd =:= "-fpt"; 
       Cmd =:= "-exp"; Cmd =:= "-combat_point"; Cmd =:= "-honor"; Cmd =:= "-seal";
       Cmd =:= "-cross_coin"; Cmd =:= "-arena_coin"; Cmd =:= "-league_seal" ->
    ?DEBUG("Cmd:~p, Num:~p", [Cmd, Num]),
    Type = 
        case Cmd of
            "-gold" ->
                ?GOODS_TYPE_GOLD;
            "-coin" ->
                ?GOODS_TYPE_COIN;
            "-vigor" ->
                ?GOODS_TYPE_VIGOR;
            "-fpt" ->
                ?GOODS_TYPE_FRIENDPOINT;
            "-exp" ->
                ?GOODS_TYPE_EXP;
            "-combat_point" ->
                ?GOODS_TYPE_COMBAT_POINT;
            "-honor" ->
                ?GOODS_TYPE_HONOR;
            "-seal" ->
                ?GOODS_TYPE_SEAL;
            "-cross_coin" ->
                ?GOODS_TYPE_CROSS_COIN;
            "-arena_coin" ->
                ?GOODS_TYPE_ARENA_COIN;
            "-league_seal" ->
                ?GOODS_TYPE_LEAGUE_SEAL
        end,
    ?DEBUG("Cmd:~p, Num:~p, Type: ~p", [Cmd, Num, Type]),
    NewPlayer = lib_player:add_money(ModPlayerState?PLAYER, Num, Type, ?INCOME_GOLD_GM),
    {ok, ModPlayerState#mod_player_state{player = NewPlayer}};
handle_cmd(Cmd, [Num], ModPlayerState) 
  when Cmd =:= "-eqgold"; Cmd =:= "-eqcoin"; Cmd =:= "-eqvigor"; Cmd =:= "-eqfpt"->
    Pos = 
        case Cmd of
            "-eqgold" ->
                #player.gold;
            "-eqcoin" ->
                #player.coin;
            "-eqvigor" ->
                #player.vigor;
            "-eqfpt" ->
                #player.fpt
        end,
    {ok, ModPlayerState#mod_player_state{player = setelement(Pos, ModPlayerState?PLAYER, Num)}};
handle_cmd("-goods", List, ModPlayerState) ->
    case lib_reward:take_reward(ModPlayerState,to_reward_item(List), ?INCOME_GOLD_GM, false) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        Other ->
            Other
    end;

handle_cmd("-gift", [MultNum, GoldNum], #mod_player_state{
                                           bag = Bag,
                                           player = Player
                                          } = ModPlayerState) ->
    ?DEBUG("MultNum: ~p, GoldNum: ~p", [MultNum, GoldNum]),
    OwnGifts = lib_pay_gifts:rand_own_gift(GoldNum, ModPlayerState?PLAYER_ID),
    GiftsGoods = lib_pay_gifts:own_gift_to_goods(OwnGifts),
    NewGiftsGoods = 
        GiftsGoods#goods{
          base_id = GiftsGoods#goods.base_id div 10 * 10 + MultNum
         },
    pt_15:pack_goods([NewGiftsGoods], [], []),
    BagCnt = Player#player.bag_cnt,
    {ok, ModPlayerState#mod_player_state{
           bag = [NewGiftsGoods | Bag],
           player = Player#player{bag_cnt = BagCnt + 1}
          }};

handle_cmd("-league_lv", [Lv], #mod_player_state{player = Player} = ModPlayerState) ->
    PlayerId = Player#player.id,
    Sn = Player#player.sn,
    case lib_league:get_league_member_by_id(PlayerId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #league_member{league_id = LeagueId} ->
            case lib_league:get_league_info(LeagueId, Sn) of
                [] -> 
                    {fail, ?INFO_CONF_ERR};
                #league{} = League ->
                    lib_league:update_league(League#league{lv = Lv}, Sn),
                    {ok, ModPlayerState}
            end
    end;

% 测试代码
handle_cmd("-cost", [Type, Sum], #mod_player_state{player = Player} = ModPlayerState) ->
   ?DEBUG("Type ~p Sum ~p~n",[Type, Sum]),
   case lib_player:cost_money(Player, Sum, Type, 0) of
       {fail, Reason} ->
           packet_misc:put_info(Reason);
       {ok, NewPlayer} ->
           {ok, ModPlayerState#mod_player_state{player = NewPlayer}}
   end;
       
handle_cmd("-goodslvlup", [Gid, Exp], 
           #mod_player_state{bag = #player_goods{goods_list = GoodsList} = PlayerGoods} = ModPlayerState) ->
    Goods = lists:keyfind(Gid, #goods.id, GoodsList),
    NewGoods = lib_goods:equip_add_exp(Goods, Exp),
    {ok, BinData} = pt_15:write(15001, {ModPlayerState?PLAYER_ID, [], [], [NewGoods]}),
    packet_misc:put_packet(BinData),
    UpdatedGoodsList = lists:keystore(NewGoods#goods.id, #goods.id, GoodsList, NewGoods),
    NewModPlayerState = ModPlayerState#mod_player_state{bag = PlayerGoods#player_goods{goods_list = UpdatedGoodsList}},
    {ok, NewModPlayerState};
handle_cmd("-bag", [Num], ModPlayerState) when Num =< 400 ->
    {ok, ModPlayerState#mod_player_state{player = ModPlayerState?PLAYER#player{bag_limit = Num}}};
handle_cmd("-mail",[] , #mod_player_state{player = Player} = ModPlayerState) ->
    Mail = lib_mail:base_mail(?LUCKY_COIN_REWARD_MAIL, [], [{1,3},{3,5}]),
    lib_mail:send_mail(Player#player.id, Mail),
    case lib_mail:get_mails(Player, []) of
        {Mails, _} when is_list(Mails) ->
            %?QPRINT(Mails),
            {ok, Bin} = pt_19:write(19004, {Mails, []}),
            %% {ok, Player, Bin};
            packet_misc:put_packet(Bin);
        _ ->
           []% mod_player:send_info(ModPlayerSate, ?INFO_MAIL_TOO_FREQUENTLY)
    end,
    {ok, ModPlayerState};
handle_cmd("-addmugen", [Num], #mod_player_state{dungeon_mugen = Mugen} = ModPlayerState) ->
    NewMugen = Mugen#dungeon_mugen{rest = Mugen#dungeon_mugen.rest + Num,
                                   dirty = 1},
    PbMugen = pt_12:to_pbmugendungeon(NewMugen),
    {ok, Bin} = pt:pack(12020, PbMugen),
    packet_misc:put_packet(Bin),
    {ok, ModPlayerState#mod_player_state{dungeon_mugen = NewMugen}};
handle_cmd("-addrelive", [Num], #mod_player_state{dungeon_info = DungeonInfo} = ModPlayerState) ->
    NewDungeonInfo = DungeonInfo#dungeon_info{relive_times = DungeonInfo#dungeon_info.relive_times + Num},
    {ok, ModPlayerState#mod_player_state{dungeon_info = NewDungeonInfo}};
handle_cmd("-addsuperbattle", [], #mod_player_state{super_battle = #super_battle{last_dungeon = Last} = SuperBattle} = ModPlayerState) ->
    case data_base_dungeon_area:get_super_battle_id_range() of
        [] ->
            {fail, ?INFO_CONF_ERR};
        [Min, Max] ->
            Next = if
                       Max =:= Min ->
                           Min;
                       true ->
                           Min + 1
                   end,
            NewSuperBattle = SuperBattle#super_battle{rest = 10,
                                                      last_dungeon = Min,
                                                      next_dungeon = Next,
                                                      dirty = 1},
            {ok, Bin} = pt_12:write(12030, NewSuperBattle),
            packet_misc:put_packet(Bin),
            {ok, ModPlayerState#mod_player_state{super_battle = NewSuperBattle}}
    end;
%% handle_cmd("-delgoods", DelIdList, #mod_player_state{bag = GoodsList,
%%                                                      player = Player} = ModPlayerState) ->
%%     {Count, DelGoods, NewGoodsList} = lib_goods:del_goods(GoodsList, DelIdList),
%%     lib_goods:db_delete_goods(DelGoods),
%%     PbDelList = 
%%         lists:map(fun(Goods) ->
%%                           lib_goods:to_proto(Goods)
%%                   end, DelGoods),
%%     {ok, Bin} = pt:pack(15001, #pbgoodschanged{deleted_list = #pbgoodslist{goods_list = PbDelList}}),
%%     packet_misc:put_packet(Bin),
%%     NewPlayer = Player#player{bag_cnt = Player#player.bag_cnt - Count},   
%%     {ok, ModPlayerState#mod_player_state{bag = NewGoodsList,
%%                                          player = NewPlayer}};
handle_cmd("-boss", [], #mod_player_state{player = Player} = ModPlayerState) ->
    {ok, ModPlayerState#mod_player_state{player = Player#player{open_boss_info = []}}};
handle_cmd("-task", [Id], #mod_player_state{task_list = TaskList} = ModPlayerState) when is_integer(Id) ->
    case data_base_task:get(Id) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_task{subtype = SubType} ->    
            case lists:keytake(SubType, #task.subtype, TaskList) of
                false ->
                    {fail, ?INFO_CONF_ERR};
                {value, Task, Rest} ->
                    NewTask = Task#task{task_id = Id, is_dirty = 1},
                    {ok, BinData} = pt_30:write(30000, {[NewTask], []}),
                    packet_misc:put_packet(BinData),
                    {ok, ModPlayerState#mod_player_state{task_list = [NewTask|Rest]}}
            end
    end;
handle_cmd("-goodslist", [Quality, Color, Level], ModPlayerState) ->
    GoodsInfoList = get_goods_list(Quality, Color, Level),
    case lib_reward:take_reward(ModPlayerState, GoodsInfoList, 110) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState}
    end;
handle_cmd("-jewel", [Lv, Num], ModPlayerState) ->
    GoodsInfoList = get_jewel_list(Lv, Num),
    case lib_reward:take_reward(ModPlayerState, GoodsInfoList) of
        {fail, Reason} ->
            {fail, Reason};
        Other ->
            Other
    end;
handle_cmd("-dailydungeon", [], #mod_player_state{player = Player} = ModPlayerState) ->
    DailyDungeon = lib_dungeon:reset_daily_dungeon(Player),
    {ok, Bin} = pt_12:write(12050, DailyDungeon),
    packet_misc:put_packet(Bin),
    {ok, ModPlayerState#mod_player_state{daily_dungeon = DailyDungeon}};
handle_cmd("-delallgoods", [], #mod_player_state{player = Player,
                                                 bag = GoodsList} = ModPlayerState) ->
    lib_goods:db_delete_goods(GoodsList),
    PbDelList = 
        lists:map(fun(Goods) ->
                          pt_15:to_pbgoods(Goods)
                  end, GoodsList),
    {ok, Bin} = pt:pack(15001, #pbgoodschanged{deleted_list = #pbgoodslist{goods_list = PbDelList}}),
    packet_misc:put_packet(Bin),
    NewPlayer = Player#player{bag_cnt = 0},   
    {ok, ModPlayerState#mod_player_state{bag = [],
                                         player = NewPlayer#player{bag_cnt = 0}}};
handle_cmd("-task", [TaskId], #mod_player_state{task_list = TaskList} = ModPlayerState) ->
    case lists:keytake(TaskId, #task.id, TaskList) of
        false ->
            {fail, ?INFO_CONF_ERR};
        {value, Task, Rest} ->
            NewTask = Task#task{state = ?TASK_DONE,
                                is_dirty = 1},
            {ok, Bin} = pt:pack(30004, #pbtasklist{update = [pt_30:to_pb_task(NewTask)]}),
            packet_misc:put_packet(Bin),
            {ok, ModPlayerState#mod_player_state{task_list = [NewTask|Rest]}}
    end;
handle_cmd("-lv", [Lv], #mod_player_state{player = Player} = ModPlayerState) 
  when is_integer(Lv) andalso Lv < 300 ->
    {ok, ModPlayerState#mod_player_state{player = Player#player{lv = Lv,
                                                                exp = 0}}};
handle_cmd("-yesterday", [], #mod_player_state{player = Player,
                                               sterious_shop = SteriousShop
                                              } = ModPlayerState) ->
    NewPlayer = Player#player{timestamp_daily_reset = Player#player.timestamp_daily_reset - ?ONE_DAY_SECONDS},
    mod_player:stop(Player#player.id, normal),
    {ok, ModPlayerState#mod_player_state{
           player = NewPlayer,
           sterious_shop = SteriousShop#sterious_shop{
                             shop_last_refresh_time = 0,    
                             shop_refresh_num = 0,
                             is_dirty = 1
                            }
          }};

handle_cmd("-reset_challenge_num", [], #mod_player_state{player = Player} = ModPlayerState) ->
    PlayerId = Player#player.id,
    Sn = Player#player.sn,
    case lib_league_fight:get_league_member_challenge(PlayerId, Sn) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        LeagueMemberChallenge ->
            lib_league_fight:write_league_member_challenge(LeagueMemberChallenge#league_member_challenge{
                                                             use_challenge_num = 0
                                                            }, Sn),
            {ok, ModPlayerState}
    end;

handle_cmd("-sterious_shop", [], #mod_player_state{
                                        sterious_shop = SteriousShop
                                              } = ModPlayerState) ->
    {ok, ModPlayerState#mod_player_state{
           sterious_shop = SteriousShop#sterious_shop{
                             shop_last_refresh_time = 0
                            }
          }};

handle_cmd("-bossover",[Id, RestTime], 
           #mod_player_state{boss_list = BossList} = ModPlayerState) when is_integer(RestTime) ->
    case lists:keytake(Id, #bossinfo.boss_id, BossList) of
        false ->
            {ok, ModPlayerState};
        {value, #bossinfo{pid = Pid} = Boss, Rest} ->
            Stop = mod_boss:bossover(Pid, RestTime),
            {ok, ModPlayerState#mod_player_state{boss_list = [Boss#bossinfo{stop = Stop}|Rest]}}
    end;

handle_cmd("-friend", [], ModPlayerState) ->
    PlayerList = mod_player_rec:recommend(ModPlayerState#mod_player_state.player),
    ?QPRINT(PlayerList),
    {ok, ModPlayerState};
handle_cmd("-boss", [Id], ModPlayerState) when is_integer(Id) ->
    case mod_boss_manage:open_boss(0, "gm", ModPlayerState?PLAYER_SN, Id) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, _, _} ->
            {ok, ModPlayerState}
    end;
handle_cmd("-async_arena", [Times], ModPlayerState) when is_integer(Times) ->
    WriteTable = hdb:sn_table(async_arena_rank, ModPlayerState?PLAYER_SN),
    case hdb:dirty_index_read(WriteTable, ModPlayerState?PLAYER_ID, #async_arena_rank.player_id, true) of
        [] ->
            {fail, ?INFO_GM_CMD_ERROR};
        [#async_arena_rank{rest_challenge_times = Rest} = PlayerRank] ->
            NewArena = PlayerRank#async_arena_rank{rest_challenge_times = Rest + Times},
            hdb:dirty_write(WriteTable, NewArena),
            {ok, Bin} = pt_23:write(23000, NewArena),
            packet_misc:put_packet(Bin)
    end;    
handle_cmd("-add_skill", [SkillId], #mod_player_state{
                                       skill_list = SkillList,
                                       player = #player{ id = PlayerId }
                                      } = ModPlayerState) when is_integer(SkillId) ->
    NewSkill = lib_player:to_player_skill(PlayerId, SkillId),
    NewSkillList = [NewSkill | SkillList],
    pb_13:write(13333, NewSkillList),
    {ok, ModPlayerState#mod_player_state{
           skill_list = NewSkillList
          }};

handle_cmd("-add_sigil", [SkillId], #mod_player_state{
                                       skill_list = SkillList
                                      } = ModPlayerState) when is_integer(SkillId) ->
    case lists:keytake(SkillId, #player_skill.skill_id, SkillList) of
        false ->
            {fail, ?INFO_SKILL_NOT_FOUND};
        {value, TSkill, Rest} ->
            NewSkill = TSkill#player_skill{
                         sigil = data_base_combat_skill:get_unique_skills(SkillId)
                        },
            NewSkillList = [NewSkill | Rest],
            pb_13:write(13333, NewSkillList),
            {ok, ModPlayerState#mod_player_state{
                   skill_list = NewSkillList
                  }}
    end;

handle_cmd("-sys_acm", [], ModPlayerState) ->
    mod_sys_acm:new_msg("hello", ModPlayerState?PLAYER_SN),
    {ok, ModPlayerState};

handle_cmd("-win_rate", [Rate], ModPlayerState)
  when is_integer(Rate) andalso Rate =< 100 ->
    Table = lib_dungeon_match:get_player_dungeon_match_table(),
    case hdb:dirty_read(Table, ModPlayerState?PLAYER_ID, true) of
        #player_dungeon_match{} = Match ->
            hdb:dirty_write(Table,
                            Match#player_dungeon_match{win_times = Rate div 10,
                                                       fail_times = (100 - Rate) div 10 }),
            {fail, ?INFO_OK};
        _ ->
            {fail, ?INFO_CONF_ERR}
    end;

handle_cmd("-skill_card", [], ModPlayerState) ->
    Career = ModPlayerState#mod_player_state.player#player.career,
    GoodsList = 
        lists:map(fun(Num) ->
                          {90000000 + 100000*Career + 1000*Num + 1, 1}
                  end, lists:seq(1, 10)),
    case lib_reward:take_reward(ModPlayerState, GoodsList, ?INCOME_GOLD_GM, false) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        Other ->
            Other
    end;

handle_cmd("-rmb", [Num], ModPlayerState) ->
    PlayerId = ModPlayerState#mod_player_state.player#player.id,
    ?DEBUG("-rmb : ~p", [Num]),
    case lib_pay_gifts:recharge(PlayerId, Num*10) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        Other ->
            {fail, ?INFO_OK}
    end;
handle_cmd("-reset_pvp", [], ModPlayerState) ->
    PlayerId = ModPlayerState#mod_player_state.player#player.id,
    mod_cross_pvp:reset_event_timestamp(PlayerId);
handle_cmd("-reset_island", [Id], ModPlayerState) ->
    PlayerId = ModPlayerState#mod_player_state.player#player.id,
    mod_cross_pvp:reset_island(PlayerId, Id);
handle_cmd("-sign", [], ModPlayerState) ->
    lib_cross_pvp:sign_up(ModPlayerState?PLAYER);
handle_cmd("-fashion", [Id], #mod_player_state{player = Player} = ModPlayerState) when is_integer(Id) ->
    {ok, ModPlayerState#mod_player_state{player = Player#player{fashion = Id}}};
%% handle_cmd("-pvp_over", [], ModPlayerState) ->
%%     case hdb:dirty_read(cross_pvp_team, ModPlayerState?PLAYER_ID) of
%%         [] ->
%%             {fail, ?INFO_CONF_ERR};
%%         #cross_pvp_team{team_num = TeamNum} ->
%%             mod_team_pvp:pvp_over(TeamNum)
%%     end;

handle_cmd("-start_count", [], _) ->
    mod_cross_league_fight:fight_end(),
    timer:sleep(1000),
    mod_cross_league_fight:start_arrange_fight();

handle_cmd("-fight_start", [], _ModPlayerState) ->
    mod_cross_league_fight:fight_start();
handle_cmd("-fight_end", [], _ModPlayerState) ->
    mod_cross_league_fight:fight_end();
handle_cmd("-arrange", [], _ModPlayerState) ->
    mod_cross_league_fight:start_arrange_fight();
handle_cmd("-season_end", [], _ModPlayerState) ->
    mod_cross_league_fight:season_end();
handle_cmd("-daily_reward", [], _ModPlayerState) ->
    mod_cross_league_fight:daily_reward();
handle_cmd("-add_score", [LeagueId, Score], _ModPlayerState) ->
    mod_cross_league_fight:add_score(LeagueId,  Score);
            
handle_cmd(Cmd, Parm, _) ->
    ?WARNING_MSG("wrong gmcmd: ~p Parm: ~p~n", [Cmd, Parm]),
    {fail, ?INFO_GM_CMD_ERROR}.

get_goods_list(Quality, Color, Level)  ->
    lists:map(fun(GoodsId) ->
                      NewGoodsId =
                          GoodsId + (Quality-1) + 10*(Color-1) + 100*(Level div 10),
                      {NewGoodsId, 1, 0}
              end, ?NORMAL_EQUIP).

get_jewel_list(Lv, Num) ->
    lists:map(fun(GoodsId) ->
                      {GoodsId + Lv - 1, Num, 0}
              end, ?NORMAL_JEWEL).

to_reward_item([GoodId, Num | List])->
    [{GoodId, Num} | to_reward_item(List)];
to_reward_item([]) ->
    [].

    

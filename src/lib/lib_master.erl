-module(lib_master).
-include("define_league.hrl").
-include("define_info_40.hrl").
-include("define_player.hrl").
-include("define_money_cost.hrl").
-include("define_goods_type.hrl").
-include("define_goods.hrl").
-include("define_logger.hrl").
-include("define_time.hrl").
-include_lib("stdlib/include/qlc.hrl").
-include_lib("g17/include/g17.hrl").
-include("define_g17_guild.hrl").
-include("db_base_guild_lv_exp.hrl").
-include("db_base_vip.hrl").
-include("db_base_skill_card.hrl").
-include("define_master_apprentice.hrl").
-include("define_mail.hrl").

-export([daily_master_reward/0,
         update_login_time/1,
         update_skill_card_status/2,
         sync_skill_card_status/2,
         count_skill_code/3,
         get_skill_code/3,
         get_master_list/1,
         get_master_cards_info/2,
         get_card_by_code/2,
         apprentice_destroy_card/2,
         deported_apprentice/2,
         get_own_cards_info/1,
         get_cards_request_msg/1,
         master_agree_msg/3,
         recv_master_reward/2,
         one_key_delete_msg/1,
         buy_skill_card/3
        ]).

daily_master_reward() ->
    Now = time_misc:unixtime(),
    AllKeys = hdb:dirty_all_keys(master_apprentice),
    Title = 
        unicode:characters_to_binary("师傅每日奖励"),
    Content = 
        unicode:characters_to_binary(lists:concat(["你的徒弟今日刻苦修炼,使你获得了", ?MASTER_DAILY_REWAD_HONOR, "天赋点!"])),
    lists:map(fun(Key) -> 
                      MasterApprentice = get_master_apprentice(Key),
                      send_reward(MasterApprentice, Now, Title, Content)
              end, AllKeys),
    ok.

send_reward(#master_apprentice{
               master_player_id = MasterId,
               master_login_time = MasterLoginTime,
               apprentice_login_time = ApprenticeLoginTime
              }, Now, Title, Content) ->
    case check_time(MasterLoginTime, ApprenticeLoginTime, Now) of
        false ->
            skip;
        true ->
            Mail = lib_mail:mail(?SYSTEM_NAME, Title, Content, [{?GOODS_TYPE_HONOR, ?MASTER_DAILY_REWAD_HONOR}]),
            lib_mail:send_mail(MasterId, Mail)
    end.

check_time(T1, T2, T3) ->
    case time_misc:is_same_day(T1, T2) of
        false ->
            false;
        true ->
            time_misc:is_same_day(T2, T3)
    end.

get_master_apprentice(Id) ->
    hdb:dirty_read(master_apprentice, Id).

get_master_apprentice_by_master_id(Id) ->
    hdb:dirty_index_read(master_apprentice, Id, #master_apprentice.master_player_id, true).

get_master_apprentice_by_apprentice_id(Id) ->
    hdb:dirty_index_read(master_apprentice, Id, #master_apprentice.apprentice_player_id, true).

update_master_apprentice([]) ->
    skip;

update_master_apprentice(Record) 
  when is_record(Record, master_apprentice) ->
    hdb:dirty_write(master_apprentice, Record);

update_master_apprentice(RecordList) 
  when is_list(RecordList) ->
    hdb:dirty_write(master_apprentice, RecordList).  

update_login_time(#player{id = PlayerId} = Player) ->
    update_master_login_time(Player),
    update_apprentice_login_time(PlayerId),
    ok.

update_master_login_time(#player{
                            id = PlayerId,
                            lv = Lv,
                            battle_ability = BattleAbility,
                            vip = PlayerVip
                           }) ->
    case get_master_apprentice_by_master_id(PlayerId) of
        [] ->
            skip;
        RecordList ->
            Now = time_misc:unixtime(), 
            NewRecordList = 
                lists:foldl(fun(Record, Acc) ->
                                    if
                                        Record#master_apprentice.skill_card_status >= ?MASTER_SUCCESS_CARD_NOT_REWARD ->
                                            Acc;
                                        true ->
                                            WorkDay = count_skill_card_work_day(Record, Now, ?MASTER),
                                            ApprenticeLoginTime = Record#master_apprentice.apprentice_login_time,
                                            CardStatus = count_skill_card_status(ApprenticeLoginTime, Now, WorkDay),
                                            NewRecord = Record#master_apprentice{
                                                          skill_card_work_day = WorkDay,
                                                          skill_card_status = CardStatus,
                                                          master_login_time = Now,
                                                          master_lv = Lv,
                                                          master_ability = BattleAbility,
                                                          master_vip = PlayerVip
                                                         },
                                            [load_league_attri(NewRecord, PlayerId) | Acc]
                                    end
                            end, [], RecordList),
            update_master_apprentice(NewRecordList)
    end.

load_league_attri(NewRecord, PlayerId) ->
    case lib_league:get_league_member_by_id(PlayerId) of
        [] ->
            NewRecord;
        #league_member{
           title = Title,
           contribute = Con,
           contribute_lv = ConLv
          } ->
            NewRecord#master_apprentice{
              master_contribute = Con,
              master_contribute_lv = ConLv,
              master_title = Title
             }
    end.

update_apprentice_login_time(PlayerId) ->
    case get_master_apprentice_by_apprentice_id(PlayerId) of
        [] ->
            skip;
        RecordList ->
            Now = time_misc:unixtime(), 
            NewRecordList = 
                lists:foldl(fun(Record, Acc) ->
                                  if
                                      Record#master_apprentice.skill_card_status >= ?MASTER_SUCCESS_CARD_NOT_REWARD ->
                                          Acc;
                                      true ->
                                          WorkDay = count_skill_card_work_day(Record, Now, ?APPRENTICE),
                                          MasterLoginTime = Record#master_apprentice.master_login_time,
                                          CardStatus = count_skill_card_status(MasterLoginTime, Now, WorkDay),
                                          [Record#master_apprentice{
                                             apprentice_login_time = Now,
                                             skill_card_work_day = WorkDay,
                                             skill_card_status = CardStatus
                                            } | Acc]
                                  end
                          end, [], RecordList),
            update_master_apprentice(NewRecordList)
    end.

count_skill_card_work_day(#master_apprentice{
                             master_login_time = MasterLoginTime,
                             apprentice_login_time = ApprenticeLoginTime,
                             skill_card_work_day = WorkDay
                            }, Now, ?MASTER) ->
    WorkDay + count_skill_card_work_day(MasterLoginTime, Now, ApprenticeLoginTime);

count_skill_card_work_day(#master_apprentice{
                             master_login_time = MasterLoginTime,
                             apprentice_login_time = ApprenticeLoginTime,
                             skill_card_work_day = WorkDay
                            }, Now, ?APPRENTICE) ->
    WorkDay + count_skill_card_work_day(ApprenticeLoginTime, Now, MasterLoginTime);

count_skill_card_work_day(Time1, Now, Time2) ->
    case time_misc:is_same_day(Time1, Now) of
        true ->
            0;  %% 再次登入
        false ->
            case time_misc:is_same_day(Now, Time2) of
                true ->
                    1; %% 
                false ->
                    0  %% 另一玩家今天没有登入
            end
    end. 

count_skill_card_status(LoginTime, Now, WorkDay) ->
    if
        WorkDay >= 30 ->
            ?MASTER_SUCCESS_CARD_NOT_REWARD;
        true ->
            case time_misc:is_same_day(LoginTime, Now) of
                true ->
                    ?MASTER_NOT_FREEZE_CARD;
                false ->
                    if 
                        WorkDay =:= 0 ->
                            ?MASTER_NOT_FREEZE_CARD;
                        true ->
                            case time_misc:is_same_day(LoginTime, Now - ?ONE_DAY_SECONDS) of
                                false ->
                                    ?MASTER_FREEZE_CARD;
                                true ->
                                    ?MASTER_NOT_FREEZE_CARD
                            end
                    end
            end
    end.

%% 玩家上线进行对技能卡状态的同步
sync_skill_card_status(#goods{id = GoodsId} = Goods, PlayerId) ->
    List = get_master_apprentice_by_apprentice_id(PlayerId),
    case lists:keyfind(GoodsId, #master_apprentice.apprentice_goods_id, List) of
        false ->
            Goods;
        #master_apprentice{skill_card_status = Status} ->
            if
                Status =:= ?MASTER_FREEZE_CARD ->
                    Goods#goods{
                      card_status = Status,
                      card_pos_1 = 0,
                      card_pos_2 = 0,
                      card_pos_3 = 0
                     };
                true ->
                    Goods#goods{
                      card_status = Status
                     }
            end
    end.

update_skill_card_status(Id, Status) ->
    case get_master_apprentice(Id) of
        [] ->
            skip;
        #master_apprentice{} = Record ->
            update_master_apprentice(Record#master_apprentice{skill_card_status = Status})
    end.
    
count_skill_code(AccId, Sn, SkillId) ->
    lists:concat([AccId, Sn, SkillId]).

%% 生成技能码
get_skill_code(#player{
                  id = PlayerId,
                  accid = AccId,
                  sn = Sn
                 } = Player, GoodsId, GoodsList) ->
    case check_g17_and_league(Player) of
        %% false ->
        %%     {fail, ?INFO_G17_GUILD_NOT_GUILD_MEMBER};
        %% {fail, Reason} ->
        %%     {fail, Reason};
        %% {_G17Guild, _League} ->
        _ ->
            case check_master_condition(Player) of
                {fail, Reason} ->
                    {fail, Reason};
                true ->
                    case lists:keyfind(GoodsId, #goods.id, GoodsList) of
                        false ->
                            {fail, ?INFO_NOT_GOODS};
                        #goods{base_id = BaseId} ->
                            case check_set_card_condition(BaseId, GoodsId, PlayerId) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                true ->
                                    LeagueMember = lib_league:get_league_member_by_id(PlayerId),
                                    SkillCode = count_skill_code(AccId, Sn, GoodsId),
                                    load_master_apprentice(Player, LeagueMember, SkillCode, BaseId, GoodsId),
                                    SkillCode
                            end
                    end
            end
    end.

check_set_card_condition(BaseId, GoodsId, PlayerId) ->
    ?WARNING_MSG("BaseId: ~p, GoodsId: ~p", [BaseId, GoodsId]),
    case data_base_skill_card:get(BaseId) of
        #base_skill_card{star_lv = StarLv} ->
            if
                StarLv >= ?MASTER_CARD_STAR_LIMIT ->
                    check_set_card_condition1(GoodsId, PlayerId);
                true ->
                    {fail, ?INFO_MASTER_NOT_FOUR_STAR_CARD}
            end;                
        _ ->
            {fail, ?INFO_CONF_ERR}            
    end.

check_set_card_condition1(GoodsId, PlayerId) ->
    MasterCards = get_master_apprentice_by_master_id(PlayerId),
    case lists:keyfind(GoodsId, #master_apprentice.master_goods_id, MasterCards) of
        false ->
            true;
        _ ->
            {fail, ?INFO_MASTER_CARD_ALREADY_UES}
    end.    

check_master_condition(#player{
                          id = PlayerId,
                          lv = Lv,
                          vip = Vip                          
                         }) ->
    MANum = length(get_master_apprentice_by_master_id(PlayerId)),
    LimitNum = lib_vip:get_master_prentice(Vip),      
    if
        Lv < ?MASTER_LV_LIMIT ->
            {fail, ?INFO_NOT_ENOUGH_LEVEL};
        Vip < ?MASTER_VIP_LIMIT ->
            {fail, ?INFO_VIP_LEVEL_TOO_LOW};
        MANum >= LimitNum ->
            {fail, ?INFO_MASTER_TEACH_NUM_LIMIT};
        true ->
            true
    end.

check_g17_and_league(Player) ->
    case lib_league:get_my_g17_guild(Player) of
        [] ->
            false;
        #g17_guild_member{
           guild_id = GuildId
          } = G17Guild ->
            case lib_league:get_my_league(Player) of
                {fail, Reason} ->
                    {fail, Reason};
                #league{g17_guild_id = GuildId} = League ->
                    {G17Guild, League};
                _ ->
                    false
            end
    end.

load_master_apprentice(#player{
                          id = Id,
                          accid = AccId,
                          nickname = Name,
                          lv = Lv,
                          vip = Vip,
                          battle_ability = BattleAbility
                         }, #league_member{
                               title = Title,
                               contribute = Con,
                               contribute_lv = ConLv
                              }, SkillCode, BaseId, GoodsId) ->
    MasterApprentice = 
        #master_apprentice{
           id = SkillCode,
           master_player_id = Id,
           master_accid = AccId,
           master_player_name = Name,
           master_login_time = time_misc:unixtime(),
           master_lv = Lv,
           master_ability = BattleAbility,
           master_contribute = Con,
           master_contribute_lv = ConLv,
           master_title = Title,
           master_goods_id = GoodsId,
           master_skill_base_id = BaseId,
           master_vip = Vip
          },
    update_master_apprentice(MasterApprentice).

load_master_apprentice(#player{
                          id = PlayerId,
                          nickname = Name
                         }, MasterApprentice, BaseId, GoodsId) ->
    NewMasterApprentice 
        = MasterApprentice#master_apprentice{
            apprentice_player_id = PlayerId,
            apprentice_login_time = time_misc:unixtime(),
            apprentice_player_name = Name,
            apprentice_goods_id = GoodsId,
            apprentice_skill_base_id = BaseId,
            skill_card_status = ?MASTER_FREEZE_CARD
           },
    update_master_apprentice(NewMasterApprentice).

get_master_list(#player{id = PlayerId}) ->
    case lib_league:get_league_member(PlayerId) of
        [] ->
            [];
        MemberList ->
            ?DEBUG("MemberList: ~p", [MemberList]),
            lists:foldl(fun(#league_member{player_id = Id}, Acc) ->
                                if
                                    PlayerId =:= Id ->
                                        Acc;
                                    true ->
                                        case get_master_list(get_master_apprentice_by_master_id(Id), PlayerId) of
                                            false ->
                                                Acc;
                                            {MasterApprentice, Info} ->
                                                [{MasterApprentice, Info} | Acc]
                                        end
                                end
                        end, [], MemberList)
    end.

get_master_list([], _) ->
    false;

get_master_list([H | _] = MasterApprenticeList, _PlayerId) ->
    Acc = get_master_list1(MasterApprenticeList, []),
    if
        length(Acc) > 0 ->
            {H, Acc};
        true ->
            false
    end.

get_master_list1([], Acc) ->
    Acc;
get_master_list1([#master_apprentice{
                     id = Code,
                     master_skill_base_id = BaseId,
                     apprentice_player_id = ApprenticeId,
                     % apprentice_skill_base_id = BaseId,
                     skill_card_status = CardStatus
                    } | T], Acc) when ApprenticeId =:= 0 ->
    get_master_list1(T, [{Code, BaseId, CardStatus} | Acc]);

get_master_list1([_ | T], Acc) ->
    get_master_list1(T, Acc).

get_master_cards_info(PlayerId, Id) ->
    List = get_master_apprentice_by_master_id(Id),
    LearnNum = length(get_master_apprentice_by_apprentice_id(PlayerId)),
    {List, LearnNum}.

get_skill_baseid_by_career(BaseId, Career) ->
    case data_base_skill_card:get(BaseId) of
        [] ->
            [];
        #base_skill_card{career = Career} ->
            BaseId;
        #base_skill_card{teach_skill = SkillList} ->
            traverse_skill_list(SkillList, Career)
    end.

traverse_skill_list([], _) ->
    [];

traverse_skill_list([H | T], Career) ->
    case data_base_skill_card:get(H) of
        #base_skill_card{career = Career} ->
            H;
        _ ->
            traverse_skill_list(T, Career)
    end.

get_card_by_code(#mod_player_state{
                    player = Player
                    %% bag = GoodsList
                  } = ModPlayerState, Code) ->
    PlayerLv = Player#player.lv,
    PlayerId = Player#player.id,
    %% Career   = Player#player.career,
    case check_apprentice_condition(PlayerId, PlayerLv) of
        {fail, Reason} ->
            {fail, Reason};
        true ->
            case check_get_card_condition(Player, Code) of
                {fail, Reason} ->
                    {fail, Reason};
                #master_apprentice{
                   master_player_id = MasterId
                  } = MasterApprentice ->
                    update_master_apprentice(MasterApprentice),
                    case hmisc:whereis_player_pid(MasterId) of
                        [] ->
                            skip;
                        Pid ->
                            mod_player:notice_master_msg(Pid)
                    end,                    
                    {ok, ModPlayerState}
                %% #master_apprentice{master_skill_base_id = BaseId} = MasterApprentice ->
                %%     %NBaseId = 
                %%     case get_skill_baseid_by_career(BaseId, Career) of
                %%         [] ->
                %%             {fail, ?INFO_CONF_ERR};
                %%         NBaseId ->
                %%             case data_base_goods:get(NBaseId) of
                %%                 [] ->
                %%                     {fail, ?INFO_CONF_ERR};
                %%                 #base_goods{bind = Bind} = BaseGoods ->
                %%                     Goods = lib_goods:base_goods_to_goods(PlayerId, BaseGoods, Bind, 1),
                %%                     load_master_apprentice(Player, MasterApprentice, NBaseId, Goods#goods.id),
                %%                     NGoods = Goods#goods{card_status = ?MASTER_FREEZE_CARD},
                %%                     pt_15:pack_goods([NGoods], [], []),
                %%                     {ok, ModPlayerState#mod_player_state{
                %%                            bag = [NGoods | GoodsList]
                %%                           }}
                %%             end
                %%     end
            end
    end.

check_apprentice_condition(PlayerId, Lv) ->
    CardMaxNum = get_apprentice_learn_num(Lv),
    Cards = get_master_apprentice_by_apprentice_id(PlayerId),
    ?DEBUG("CardMaxNum: ~p, Num: ~p", [CardMaxNum, length(Cards)]),
    if
        CardMaxNum =< length(Cards) ->
            {fail, ?INFO_MASTER_LEARN_NUM_LIMIT};
        true ->
            case get_master_apprentice_by_apprentice_id(PlayerId) of
                [] ->
                    true;
                Info ->
                    case check_master_apprentice(Info) of
                        false ->
                            {fail, ?INFO_MASTER_NOT_SAME_TIME_LEARN};
                        true ->
                            true
                    end
            end
    end.

check_master_apprentice(MasterApprentices) when is_list(MasterApprentices)->
    lists:foldl(fun(#master_apprentice{
                       skill_card_status = Status
                      }, Flag) -> 
                        if
                            Status < ?MASTER_SUCCESS_CARD_NOT_REWARD ->
                                false;
                            true ->
                                Flag
                        end
                end, true, MasterApprentices).
    

check_get_card_condition(Player, Code) ->
    %% case lib_league:get_my_g17_guild(Player) of
    %%     [] ->
    %%         {fail, ?INFO_G17_GUILD_NOT_GUILD_MEMBER};
    %%     #g17_guild{guild_id = Id} ->
    case get_master_apprentice(Code) of
        [] ->
            {fail, ?INFO_MASTER_SKILL_CODE_ERROR};
        #master_apprentice{
           master_accid = AccId
          } = MasterApprentice ->
            %% case lib_league:get_g17_guild_member(AccId) of
            %%     #g17_guild_member{guild_id = Id} ->
            check_get_card_condition1(Player, MasterApprentice);
        _ ->
            {fail, ?INFO_MASTER_NOT_AT_SAME_GUILD}
            %% end
    end.
%% end.

check_get_card_condition1(#player{
                             id = PlayerId,
                             vip = PlayerVip,
                             lv = PlayerLv,
                             nickname = Name
                            }, #master_apprentice{
                                  master_player_id = MasterId,
                                  master_vip = MasterVip,
                                  apprentice_player_id = ApprenticeId,
                                  request_card_msg = Queue
                                 } = MasterApprentice) ->
    ?DEBUG("PlayerVip: ~p MasterVip: ~p", [PlayerVip, MasterVip]),
    if
        PlayerId =:= MasterId ->
            {fail, ?INFO_MASTER_NOT_LEARN_SELF};
        PlayerLv < ?APPRENTICE_LV_LIMIT ->
            {fail, ?INFO_NOT_ENOUGH_LEVEL};
        PlayerId =:= ApprenticeId ->
            {fail, ?INFO_MASTER_ALREADY_LEARN_CARD};
        PlayerVip >= MasterVip ->
            {fail, ?INFO_MASTER_VIP_OVER_ERROR};
        ApprenticeId > 0 ->
            {fail, ?INFO_MASTER_ALREADY_HAS_APPRENTICE};
        true ->
            case lists:keyfind(PlayerId, #master_request_msg.player_id, Queue) of
                false ->
                    MasterApprentice#master_apprentice{
                      request_card_msg = [#master_request_msg{
                                             player_name = Name,
                                             player_id = PlayerId
                                            } | Queue]
                     };
                _ ->
                    {fail, ?INFO_MASTER_ALREADY_REQUEST_CARD}
            end
    end.

%% 徒弟销毁
apprentice_destroy_card(#mod_player_state{
                           bag = GoodsList
                          } = ModPlayerState, Code) ->
    case get_master_apprentice(Code) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #master_apprentice{
           apprentice_goods_id = GoodsId           
          } = MasterApprentice ->
            destroy_card(MasterApprentice),
            NewGoodsList = 
                case lists:keytake(GoodsId, #goods.id, GoodsList) of
                    false ->
                        GoodsList;
                    {value, Val, Rest} ->
                        pt_15:pack_goods([], [], [Val]),
                        Rest
                end,
            {ok, ModPlayerState#mod_player_state{bag = NewGoodsList}}
    end.

destroy_card(#master_apprentice{} = MasterApprentice) ->
    NewMasterApprentice 
        = MasterApprentice#master_apprentice{
            apprentice_player_id = 0,
            apprentice_login_time = 0,
            apprentice_player_name = "",
            apprentice_goods_id = 0,
            skill_card_status = ?MASTER_SELF_CARD,
            skill_card_work_day = 0
           },
    update_master_apprentice(NewMasterApprentice).

%% 驱逐徒弟
deported_apprentice(PlayerId, Code) ->
    case get_master_apprentice(Code) of
        [] ->
            {fail, ?INFO_MASTER_SKILL_CODE_ERROR};
        #master_apprentice{
           master_player_id = PlayerId,
           apprentice_player_id = ApprenticeId,
           apprentice_goods_id = GoodsId
          } = MasterApprentice ->
            destroy_card(MasterApprentice),
            deported_apprentice1(ApprenticeId, GoodsId);
        _ ->
            {fail, ?INFO_CONF_ERR}
    end.

deported_apprentice1(PlayerId, GoodsId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            case hdb:dirty_read(goods, GoodsId) of
                [] ->
                    skip;
                Goods ->
                    lib_goods:db_delete_goods(Goods)
            end;
        Pid ->
            mod_player:delete_goods_by_id(Pid, GoodsId)
    end.

get_apprentice_learn_num(Lv) ->
    get_learn_num(Lv div 10).

get_learn_num(0) ->
    0;
get_learn_num(1) ->
    0;
get_learn_num(2) ->
    1;
get_learn_num(3) ->
    2;
get_learn_num(4) ->
    3;
get_learn_num(_) ->
    3.

get_own_cards_info(#player{
                      id = PlayerId,
                      lv = PlayerLv
                     }) ->
    MasterCards = get_master_apprentice_by_master_id(PlayerId),
    ApprenticeCards = get_master_apprentice_by_apprentice_id(PlayerId),
    {MasterCards, ApprenticeCards, get_apprentice_learn_num(PlayerLv) - length(ApprenticeCards)}.

get_cards_request_msg(PlayerId) ->
    get_master_apprentice_by_master_id(PlayerId).

master_agree_msg(Master, Code, ApprenticeId) ->
    case get_master_apprentice(Code) of
        [] ->
            {fail, ?INFO_MASTER_SKILL_CODE_ERROR};
        #master_apprentice{apprentice_player_id = ApprenticeId} when ApprenticeId > 0 ->
            {fail, ?INFO_MASTER_CARD_ALREADY_UES};
        #master_apprentice{
           master_skill_base_id = BaseId,
           request_card_msg = RequestMsgs
          } = MasterApprentice ->
            case hdb:dirty_read(player, ApprenticeId) of
                [] ->
                    ?DEBUG("PlayerId NotFound : ~p~n",[ApprenticeId]),
                    {fail, ?INFO_CONF_ERR};
                #player{career = Career, lv = PlayerLv} = Player ->
                    case check_apprentice_condition(ApprenticeId, PlayerLv) of
                        {fail, Reason} ->
                            NewRequestMsgs = 
                                case lists:keytake(ApprenticeId, #master_request_msg.player_id, RequestMsgs) of
                                    false ->
                                        RequestMsgs;
                                    {_, _, Rest} ->
                                        Rest
                                end,
                            update_master_apprentice(MasterApprentice#master_apprentice{
                                                       request_card_msg = NewRequestMsgs
                                                      }),
                            {fail, Reason};
                        true ->
                            case get_skill_baseid_by_career(BaseId, Career) of
                                [] ->
                                    {fail, ?INFO_CONF_ERR};
                                NBaseId ->
                                    case data_base_goods:get(NBaseId) of
                                        [] ->
                                            {fail, ?INFO_CONF_ERR};
                                        #base_goods{bind = Bind} = BaseGoods ->
                                            Goods = lib_goods:base_goods_to_goods(ApprenticeId, BaseGoods, Bind, 1),
                                            NewMasterApprentice = 
                                                MasterApprentice#master_apprentice{
                                                  request_card_msg = []
                                                 },
                                            load_master_apprentice(Player, NewMasterApprentice, NBaseId, Goods#goods.id),
                                            NGoods = Goods#goods{card_status = ?MASTER_NOT_FREEZE_CARD},
                                            case hmisc:whereis_player_pid(ApprenticeId) of
                                                [] ->
                                                    hdb:dirty_write(goods, NGoods);
                                                Pid ->
                                                    mod_player:add_goods(Pid, NGoods)
                                            end,
                                            send_to_apprentice(Master, ApprenticeId)
                                    end
                            end
                    end
            end
    end.

send_to_apprentice(#player{nickname = Name}, ApprenticeId) ->
    Title = 
        unicode:characters_to_binary("好消息!"),
    Content1 = 
        unicode:characters_to_binary(lists:concat(["究极玩家愿意收你为徒!"])),
    Content2 = <<Name/binary, Content1/binary>>,
    Mail = lib_mail:mail(?SYSTEM_NAME, Title, Content2, []),
    lib_mail:send_mail(ApprenticeId, Mail).

recv_master_reward(ModPlayerState, Code) ->
    case get_master_apprentice(Code) of
        [] ->
            {fail, ?INFO_MASTER_SKILL_CODE_ERROR};
        #master_apprentice{skill_card_status = Status} 
          when Status =/= ?MASTER_SUCCESS_CARD_NOT_REWARD ->
            {fail, ?INFO_MASTER_RECV_REWARD_ERROR};
        MasterApprentice ->
            NewMasterApprentice = 
                MasterApprentice#master_apprentice{
                  skill_card_status = ?MASTER_SUCCESS_CARD_REWARD
                 },
            update_master_apprentice(NewMasterApprentice),
            %% 奖励以后会改, 暂且这么写死
            lib_reward:take_reward(ModPlayerState, [{270204, 1}], ?INCOME_MASTER_REWARD)
    end.

one_key_delete_msg(Code) ->
    case get_master_apprentice(Code) of
        [] ->
            {fail, ?INFO_MASTER_SKILL_CODE_ERROR};
        MasterApprentice ->
            NewMasterApprentice = 
                MasterApprentice#master_apprentice{
                  request_card_msg = []
                 },
            update_master_apprentice(NewMasterApprentice)
    end.

buy_skill_card(ModPlayerState, Code, Type) ->
    case get_master_apprentice(Code) of
        [] ->
            {fail, ?INFO_MASTER_SKILL_CODE_ERROR};
        MasterApprentice ->
            buy_skill_card1(ModPlayerState, MasterApprentice, Type)
    end.

buy_skill_card1(#mod_player_state{
                   player = Player,
                   bag = GoodsList
                  } = ModPlayerState, #master_apprentice{
                                         apprentice_goods_id = GoodsId,
                                         apprentice_skill_base_id = BaseId
                                        } = MasterApprentice, Type) ->
    case data_base_goods_jewel:get(BaseId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_goods_jewel{
           meterial = Meterial,
           price = Price
          } ->
            Consume = 
                if
                    Type =:= ?MASTER_TYPE_BUG_GOLD ->
                        Price;
                    true ->
                        Meterial
                end,
            case lib_goods:consume_goods(Player, Consume, GoodsList) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NPlayer, NGoodsList, Update, Del} ->
                    case lists:keytake(GoodsId, #goods.id, NGoodsList) of
                        false ->
                            {fail, ?INFO_CONF_ERR};
                        {value, Goods, Rest} ->
                            NGoods = Goods#goods{card_status = ?MASTER_SELF_CARD},                            
                            pt_15:pack_goods([], [{Goods, NGoods} | Update], Del),
                            set_master_apprentice(MasterApprentice),
                            {ok, ModPlayerState#mod_player_state{
                                   player = NPlayer,
                                   bag = [NGoods | Rest]
                                  }}
                    end
            end
    end.    

set_master_apprentice(MasterApprentice) ->
    NewMasterApprentice = 
        MasterApprentice#master_apprentice{
          skill_card_status = ?MASTER_SUCCESS_CARD_NOT_REWARD,
          skill_card_work_day = ?SKILL_CARD_WORK_DAY
         },
    update_master_apprentice(NewMasterApprentice).
    

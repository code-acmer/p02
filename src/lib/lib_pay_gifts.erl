-module(lib_pay_gifts).
%% 充值礼包相关
-include("define_league.hrl").
-include("define_gifts.hrl").
-include("define_player.hrl").
-include("define_logger.hrl").
-include("define_time.hrl").
-include("define_info_40.hrl").
-include("define_goods_type.hrl").
-include("define_money_cost.hrl").
-include("define_mnesia.hrl").
-include("define_chat.hrl").
-include("define_goods_rec.hrl").
-include("define_goods.hrl").
-export([recharge/2]).
-export([daily_delete_league_gifts/1,
         daily_delete_league_gifts/0,
         daily_reset_pay_gifts/1,
         daily_delete_request_gifts_msg/1,
         daily_delete_request_gifts_msg/0,
         daily_reset_bag_gift/1,
         login_gifts/1,
         return_gold/1,
         daily_reset_gifts/1,
         save_gifts/1,
         send_gifts/4,
         one_key_send_gifts/2,
         pass_zero_gift/1,
         recv_league_gifts/2,
         get_league_gifts/1,
         get_league_record/1,
         league_recharge_gold/2,
         get_recharge_gold_record/1,
         boss_send_gifts/2,
         get_league_house/1,
         recharge_send_msg/2,
         get_all_msg/2,
         invite_in_league/2,
         appoint_send_gifts/3,
         get_appoint_send_msg/2,
         request_gifts_msg/2,
         request_player_gifts/2,
         get_request_msg/1,
         agree_request_gifts/2,
         disagree_request_gifts/2,
         get_league_gifts_num/1,
         dirty_gifts/1,
         rand_own_gift/2,
         own_gift_to_goods/1,
         decomposition_gift/2,
         first_login_get_gift/2,
         rand_gift_gold_list/1
        ]).

rand_gift_gold_list(Gold) ->
    AGiftGold = rand_gift_gold(40, 40, 60),
    BGiftGold = rand_gift_gold(25, 40, 60),
    CGiftGold1 = rand_gift_gold(25, 20, 40),
    CGiftGold2 = rand_gift_gold(25, 20, 40),
    DGiftGold1 = rand_gift_gold(10, 1, 60),
    DGiftGold2 = rand_gift_gold(10, 20, 40),
    RandGoldList = 
        [BGiftGold, 25 - BGiftGold, 
         CGiftGold1, CGiftGold2, 25 - CGiftGold1 - CGiftGold2,
         DGiftGold1, DGiftGold2, 10 - DGiftGold1 - DGiftGold2,
         AGiftGold, 40 - AGiftGold
        ],
    {GoldList, _, _} = 
        lists:foldl(fun(Key, {AccList, Count, Sum}) ->
                            NGold = erlang:trunc(Gold * Key div 100) + 1,
                            if
                                Count =< 8 ->
                                    {[NGold | AccList], Count + 1, Sum + NGold};
                                true ->
                                    {[(Gold - Sum) | AccList], Count + 1, Gold}
                            end
                    end, {[], 0, 0}, RandGoldList),
    hmisc:shuffle(GoldList).

rand_gift_gold(Gold, Min, Max) ->
    RandNum = hmisc:rand(Min, Max),
    Gold * RandNum div 100.

daily_delete_league_gifts() ->
    daily_delete_league_gifts(time_misc:unixtime()).

daily_delete_league_gifts(Now) ->
    hdb:dirty_write(server_config, #server_config{k = daily_reset_league_gifts,
                                                  v = Now}),
    hdb:clear_table(league_gifts).


daily_reset_pay_gifts(PayGiftsList) ->
    lists:map(fun(PayGifts) ->
                      {ValueList, AllList} = 
                          if
                              PayGifts#pay_gifts.all_days_value_list =:= [] ->
                                  {[], []};
                              true ->
                                  [V | T] = PayGifts#pay_gifts.all_days_value_list,
                                  {V, T}
                          end,
                      NewRestNum = reset_pay_gifts(PayGifts),
                      ?DEBUG("NewRestNum: ~p, ValueList: ~p, AllList: ~p", [NewRestNum, ValueList, AllList]),
                      dirty_gifts(PayGifts#pay_gifts{
                                    recv_list = [],
                                    day_num = 0,
                                    rest_num = NewRestNum, 
                                    one_days_value_list = ValueList,
                                    all_days_value_list = AllList
                                   })
              end, PayGiftsList).

reset_pay_gifts(#pay_gifts{rest_num = RestNum}) 
  when RestNum rem ?DAY_SEND_GIFTS > 0 ->
    RestNum div ?DAY_SEND_GIFTS * ?DAY_SEND_GIFTS;
reset_pay_gifts(#pay_gifts{
                   rest_num = RestNum,
                   last_send = Last
                  }) 
  when RestNum rem ?DAY_SEND_GIFTS =:= 0 ->
    Now = time_misc:unixtime(),
    case time_misc:is_same_day(Last+?ONE_DAY_SECONDS, Now) of
        true -> %% 昨天发了红包
            ?WARNING_MSG("is_same_day true RestNum: ~p", [RestNum]),
            RestNum;
        false -> %% 昨天没发红包
            ?WARNING_MSG("is_same_day false RestNum: ~p", [RestNum]),
            RestNum - 10
    end.

daily_delete_request_gifts_msg() ->
    daily_delete_request_gifts_msg(time_misc:unixtime()).

daily_delete_request_gifts_msg(Now) ->
    hdb:dirty_write(server_config, #server_config{k = daily_reset_request_gifts_msg,
                                                  v = Now}),
    hdb:clear_table(request_gifts_msg).

daily_reset_bag_gift(BagCache) ->
    {DeList, NewBagCache} = 
        lists:foldl(fun(#goods{timestamp = TimeStamp} = Goods, {De, AccList}) 
                          when TimeStamp > 0 ->
                            Now = time_misc:unixtime(),
                            if
                                TimeStamp =< Now ->
                                    {[Goods | De], AccList};
                                true ->
                                    {De, [Goods | AccList]}
                            end;
                       (Goods, {De, AccList}) ->
                            {De, [Goods | AccList]}
                    end, {[], []}, BagCache),
    ?DEBUG("daily_reset_bag_gift: ~p", [DeList]),
    pt_15:pack_goods([], [], DeList),
    NewBagCache.


%%充值钻石获得礼包(非player进程调用)
recharge(PlayerId, Gold) ->
    NewGifts = new_pay_gifts(PlayerId, Gold),
    ?DEBUG("recharge: ~p", [NewGifts]),
    gifts_to_player(PlayerId, Gold, NewGifts).

gifts_to_player(PlayerId, Gold, NewGifts) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            case hdb:dirty_read(player, PlayerId, true) of
                [] ->
                    ?WARNING_MSG("recharge error player_id ~p~n", [PlayerId]),
                    fail;
                #player{return_gold = OldReturn} = Player ->
                    NewPlayer = 
                        lib_player:add_money(Player#player{return_gold = OldReturn + return_gold(Gold)}, Gold, ?GOODS_TYPE_VGOLD, ?INCOME_RECHARGE),
                    hdb:dirty_write(player, NewPlayer),
                    write_pay_gifts(NewGifts),
                    recharge_send_msg(Player, NewGifts),
                    league_recharge_gold(Player, Gold)
            end;
        Pid ->
            mod_player:recharge(Pid, Gold, NewGifts)
    end.

write_pay_gifts([]) ->
    skip;
write_pay_gifts(NewGifts) ->
    hdb:dirty_write(pay_gifts, NewGifts).

recharge_send_msg(_, []) ->
    skip;
recharge_send_msg(#player{
                     id = PlayerId,
                     nickname = PlayerName,
                     sn = Sn
                    }, _) ->
    case lib_league:get_league_member_by_id(PlayerId) of
        [] ->
            %?WARNING_MSG("no League ..."),
            NickName = <<PlayerName/binary>>,
            mod_sys_acm:new_msg({NickName, PlayerId, 0}, Sn, ?ACM_TYPE_RECHARGE_GIFTS);
        #league_member{
           league_id = LeagueId
          } -> 
            ?WARNING_MSG("... LeagueId: ~p", [LeagueId]),
            NickName = <<PlayerName/binary>>,
            mod_sys_acm:new_msg({NickName, PlayerId, LeagueId}, Sn, ?ACM_TYPE_RECHARGE_GIFTS)
    end.

get_value_list(_, Days) 
  when Days =< 1 ->
    [];

get_value_list(Gold, Days) ->
    lists:foldl(fun(_, AccList) ->
                        [rand_gift_gold_list(Gold) | AccList]
                end, [], lists:seq(1, Days)).

new_pay_gifts(PlayerId, Gold) ->
    Days = gifts_day(Gold),
    if
        Days > 0 ->
            GoldSum = gifts_gold(Gold),
            ?DEBUG("GoldSum: ~p, Days: ~p", [GoldSum, Days]),
            #pay_gifts{id = next_gifts_id(),
                       player_id = PlayerId,
                       sum = GoldSum,
                       per_gold = GoldSum div Days div ?DAY_SEND_GIFTS,
                       over_time = time_misc:get_timestamp_of_tomorrow_start() + ?ONE_DAY_SECONDS*Days,
                       recharge_gold_num = Gold,
                       rest_num = ?DAY_SEND_GIFTS * Days,
                       all_num = ?DAY_SEND_GIFTS * Days,
                       day_num = 0,
                       one_days_value_list = rand_gift_gold_list(GoldSum - (GoldSum div Days) * (Days - 1)),
                       all_days_value_list = get_value_list(GoldSum div Days, Days-1)
                      };
        true ->
            []
    end.

next_gifts_id() ->
    lib_counter:update_counter(pay_gifts_uid).

%%返还钻石
return_gold(Gold) ->
    Gold.
%%礼包总值
gifts_gold(Gold) ->
    Gold div ?GOLD_RECHARGE_BLOCK * ?GOLD_OF_BLOCK.

gifts_day(Gold) when Gold < 200 ->
    0;
gifts_day(Gold) 
  when Gold >= 200 andalso Gold =< 500 ->
    3;
gifts_day(Gold) 
  when Gold > 500 andalso Gold =< 1000 ->
    4;
gifts_day(Gold) 
  when Gold > 1000 andalso Gold =< 2000 ->
    5;
gifts_day(Gold) 
  when Gold > 2000 andalso Gold =< 5000 ->
    6;
gifts_day(Gold) 
  when Gold > 5000 andalso Gold =< 10000 ->
    7;
gifts_day(_Gold) ->
    8.

next_league_gifts_record_id() ->
     lib_counter:update_counter(league_gifts_record).

new_league_gifts_record(GoldSum, #league_gifts{
                                    league_id = LeagueId,
                                    player_name = SenderName
                                   }) ->
    #league_gifts_record{
       id = next_league_gifts_record_id(),
       league_id = LeagueId,
       send_name = SenderName,
       timestamp = time_misc:unixtime(),
       value = GoldSum
      }.

new_league_gifts_record(#league_gifts{
                           player_name = SenderName,
                           league_id = LeagueId
                          }, Player, Gold) ->
    #league_gifts_record{
       id = next_league_gifts_record_id(),
       league_id = LeagueId,
       send_name = SenderName,
       recv_name = Player#player.nickname,
       timestamp = time_misc:unixtime(),
       value = Gold,
       type = 1
      }.

%%登陆获取礼包列表
login_gifts(PlayerId) ->
    hdb:dirty_index_read(pay_gifts, PlayerId, #pay_gifts.player_id, true).

daily_reset_gifts(GiftsList) ->
    Now = time_misc:unixtime(),
    lists:foldl(fun(#pay_gifts{
                       id = Gid,
                       over_time = Over} = Gifts, AccList) ->
                        if
                            Over =< Now ->
                                hdb:dirty_delete(pay_gifts, Gid),
                                AccList; 
                            true ->
                                [Gifts|AccList]
                        end
                end, [], GiftsList).

save_gifts(GiftsList) ->
    lists:map(fun(Gifts) ->
                      hdb:save(Gifts, #pay_gifts.dirty)
              end, GiftsList).

one_key_send_gifts(Player, GiftsList) ->
    List = 
        lists:foldl(fun(Gifts, {Success, Fail}) ->
                            GiftsNum = ?DAY_SEND_GIFTS - Gifts#pay_gifts.day_num, 
                            if
                                GiftsNum  =< 0 ->
                                    {Success, [Gifts | Fail]};
                                true ->                                    
                                    case send_gifts(Player, Gifts#pay_gifts.id, GiftsNum, GiftsList) of
                                        {fail, _} ->
                                            {Success, [Gifts | Fail]};
                                        {ok, [NewGifts | _]} ->
                                            {[NewGifts | Success], Fail}
                                    end
                            end
                    end, {[], []}, GiftsList),
    List.

%% 过滤 0 红包
pass_zero_gift(GiftsList) ->
    lists:foldl(fun(#pay_gifts{rest_num = RestNum} = PayGift, AccList) -> 
                        if
                            RestNum =< 0 ->
                                AccList;
                            true ->
                                [PayGift | AccList]
                        end
                end, [], GiftsList).

%%发放礼包
send_gifts(#player{id = PlayerId, sn = Sn, nickname = PlayerName} = Player, GiftId, GiftsNum, GiftsList) ->
    case check_gifts(GiftId, GiftsNum, GiftsList) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, #pay_gifts{
                one_days_value_list = PerGoldList
               } = NGifts, NGiftsList} ->
            {NPerGoldList, RemianValueList} = list_misc:sublist(PerGoldList, GiftsNum),
            GoldSum = lists:foldl(fun(Key, Sum) -> 
                                          Sum + Key
                                  end, 0, NPerGoldList),
            case lib_league:get_league_member_by_id(PlayerId) of
                [] ->
                    {fail, ?INFO_LEAGUE_NOT_MEMBER};
                #league_member{
                   league_id = LeagueId,
                   send_gold = SendGold
                  } = OldLeagueMember ->
                    LeagueGifts = 
                        case get_league_gifts_by_giftid(GiftId) of
                            #league_gifts{
                               league_id = LeagueId, %% 跨公会做兼容, 同一个公会，则可叠加
                               rest_num = RestNum, 
                               sum = Sum,
                               one_days_value_list = ValueList
                              } = OldLeagueGifts ->
                                OldLeagueGifts#league_gifts{
                                  rest_num = RestNum + GiftsNum,
                                  sum = Sum + GiftsNum,
                                  one_days_value_list = NPerGoldList ++ ValueList
                                 };
                            _ ->  %% 这一步是非同一公会， 或则原公会没有数据
                                update_league_info(LeagueId, Sn),
                                new_league_gifts(Player, NGifts, LeagueId, GiftsNum, NPerGoldList)
                        end,
                    update_league_gifts(LeagueGifts),
                    LeagueGiftsRecord = new_league_gifts_record(GoldSum, LeagueGifts),
                    write_league_gifts_record(LeagueGiftsRecord),
                    NickName = <<PlayerName/binary>>,
                    mod_sys_acm:new_msg({NickName, PlayerId, LeagueId, GoldSum}, Sn, ?ACM_TYPE_SEND_GIFTS),
                    lib_league:update_league_member(OldLeagueMember#league_member{
                                                      send_gold = SendGold + GoldSum,
                                                      player_name = PlayerName
                                                     }),
                    {ok, [NGifts#pay_gifts{
                            one_days_value_list = RemianValueList,
                            last_send = time_misc:unixtime()
                           } | NGiftsList]}
            end
    end.

update_league_info(LeagueId, Sn) ->
    %% ?DEBUG("LeagueId: ~p, Sn: ~p", [LeagueId, Sn]),
    RecvFun = fun() ->
                      League = lib_league:get_league_info(LeagueId, Sn),
                      Num =  League#league.league_gifts_num,
                      NewLeague = League#league{league_gifts_num = Num + 1},
                      lib_league:update_league(NewLeague, Sn),
                      mod_league_cache:update_league(Sn, NewLeague)
              end,
    hdb:transaction(RecvFun).

check_gifts(GiftId, GiftsNum, GiftsList) ->
    case lists:keytake(GiftId, #pay_gifts.id, GiftsList) of
        false ->
            {fail, ?INFO_PAY_GIFTS_NOT_FOUND};
        {value, #pay_gifts{over_time = OverTime,
                           rest_num = RestNum,
                           day_num = DayNum
                          } = Gifts, Rest} ->         
            Now = time_misc:unixtime(),
            if
                DayNum + GiftsNum > ?DAY_SEND_GIFTS ->
                    {fail, ?INFO_PAY_GIFTS_NOT_ENOUGH};
                OverTime < Now ->
                    {fail, ?INFO_PAY_GIFTS_OVER_TIME};
                RestNum < GiftsNum ->
                    {fail, ?INFO_PAY_GIFTS_NOT_ENOUGH};
                true ->
                    NGifts = dirty_gifts(Gifts#pay_gifts{
                                           last_send = Now,
                                           rest_num = RestNum - GiftsNum,
                                           day_num = DayNum + GiftsNum
                                          }),
                    {ok, NGifts, Rest}
            end
    end.
    
new_league_gifts(#player{id = PlayerId,
                         nickname = NickName}, #pay_gifts{id = GiftId,
                                                          sum = GoldType
                                                         }, LeagueId, GiftsNum, NPerGoldList) ->
    #league_gifts{id = GiftId,
                  league_id = LeagueId,
                  player_id = PlayerId,
                  player_name = NickName,
                  rest_num = GiftsNum,
                  sum = GiftsNum,
                  gold_type = GoldType,
                  over_time = time_misc:unixtime() + ?ONE_DAY_SECONDS,
                  one_days_value_list = NPerGoldList
                 }.

dirty_gifts(Gifts)
  when is_record(Gifts, pay_gifts) ->
    Gifts#pay_gifts{dirty = 1}.

%%查看所有工会礼包
get_league_gifts(PlayerId) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId} ->
            get_league_gifts_by_leagueid(LeagueId)
    end.

%%领取工会礼包
recv_league_gifts(#mod_player_state{
                     bag = Bag,
                     player = Player
                    } = ModPlayerState, GiftsId) ->
    PlayerId = Player#player.id,
    case lib_league:get_league_member_by_id(PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{
           league_id = LeagueId,
           recv_gold = OldRecvGold
          } = OldLeagueMember ->
            Now = time_misc:unixtime(),
            RecvFun = 
                fun() -> 
                        case mnesia:wread({league_gifts, GiftsId}) of
                            [] ->
                                {fail, ?INFO_LEAGUE_NOT_FIND_GIFTS};
                            [#league_gifts{rest_num = Num,
                                           league_id = LeagueId,
                                           over_time = OverTime,
                                           recv_list = RecvList,
                                           one_days_value_list = ValueList
                                          } = LeagueGifts] ->
                                NRecvList = 
                                    case hdb:dirty_read(pay_gifts, GiftsId) of
                                        [] ->
                                            RecvList;
                                        #pay_gifts{recv_list = List} ->
                                            List ++ RecvList
                                    end,
                                HasRecv = lists:member(PlayerId, NRecvList),
                                if
                                    HasRecv =:= true ->
                                        {fail, ?INFO_LEAGUE_GIFTS_RECV};
                                    OverTime < Now ->
                                        {fail, ?INFO_PAY_GIFTS_OVER_TIME};
                                    Num =< 0 ->
                                        {fail, ?INFO_LEAGUE_GIFTS_NUM_LIMIT};
                                    ValueList =:= [] ->
                                        {fail, ?INFO_LEAGUE_GIFTS_NUM_LIMIT};
                                    true ->
                                        [KeyGold | T] = ValueList, 
                                        NewLeagueGifts = LeagueGifts#league_gifts{
                                                           rest_num = Num - 1,
                                                           recv_list = [PlayerId | RecvList],
                                                           one_days_value_list = T
                                                          },
                                        mnesia:write(league_gifts, NewLeagueGifts, write),
                                        {ok, KeyGold, NewLeagueGifts}
                                end;
                            _ ->
                                {fail, ?INFO_CONF_ERR}
                        end
                end,
            case hdb:transaction(RecvFun) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, GetGold, NewLeagueGifts} ->
                    {OwnGift, NPlayer} = 
                        first_login_get_gift(rand_own_gift(GetGold, PlayerId), Player),
                    GiftGoods = own_gift_to_goods(OwnGift),
                    Record = new_league_gifts_record(NewLeagueGifts, NPlayer, GetGold),
                    write_league_gifts_record(Record),
                    lib_league:update_league_member(OldLeagueMember#league_member{
                                                      recv_gold = OldRecvGold + GetGold
                                                     }),
                    pt_15:pack_goods([GiftGoods], [], []),
                    acm_send_msg(LeagueId, NPlayer, GiftGoods),
                    {GetGold, ModPlayerState#mod_player_state{
                                bag = [GiftGoods | Bag],
                                player = NPlayer
                               }}
            end
    end.

write_league_gifts_record(Record) ->
    hdb:dirty_write(league_gifts_record, Record).

acm_send_msg(LeagueId, #player{
                          nickname = PlayerName,
                          sn = Sn
                         }, #goods{base_id = BaseId}) ->
    MultNum = BaseId rem 10,
    if 
        MultNum < ?GIFT_THREE_FOLD ->
            skip;
        true -> 
            League = lib_league:get_league_info(LeagueId, Sn),
            LeagueName = League#league.name,
            MsgBin1 = 
                unicode:characters_to_binary(lists:concat(["玩家在"])),
            MsgBin2 = 
                unicode:characters_to_binary(lists:concat(["公会红包中幸运的抽取了 ", MultNum, "倍红包!"])),
            Msg = 
                <<PlayerName/binary, MsgBin1/binary, LeagueName/binary, MsgBin2/binary>>,
            mod_sys_acm:new_msg(Msg, Sn, ?ACM_TYPE_RECEIVE_GIFT)
    end.

%% 第1次潜规则
first_login_get_gift(#own_gift{
                        value = [{_GoodsId, GoodsNum}]
                       } = OwnGift, #player{
                                       vip = 0,
                                       recv_gift_num = ?FIRST_LOGIN_GIFT_ZERO
                                      } = Player) 
  when GoodsNum >= ?GIFT_GOLD_NUM ->
    BaseId = OwnGift#own_gift.goods_id,
    NOwnGift = 
        OwnGift#own_gift{goods_id = BaseId div 10 *10 + ?GIFT_THREE_FOLD},
    {NOwnGift, Player#player{recv_gift_num = ?FIRST_LOGIN_GIFT_ZERO + 1}};

first_login_get_gift(OwnGift, #player{
                                 vip = 0,
                                 recv_gift_num = ?FIRST_LOGIN_GIFT_ZERO
                                } = Player) ->
    {OwnGift, Player};
%% 第5次潜规则
first_login_get_gift(#own_gift{
                        value = [{_GoodsId, GoodsNum}]
                       } = OwnGift, #player{
                                       vip = 0,
                                       recv_gift_num = ?FIRST_LOGIN_GIFT_FIVE
                                      } = Player) 
  when GoodsNum >= ?GIFT_GOLD_NUM ->
    BaseId = OwnGift#own_gift.goods_id,
    NOwnGift = 
        OwnGift#own_gift{goods_id = BaseId div 10 *10 + ?GIFT_FOUR_FOLD},
    {NOwnGift, Player#player{recv_gift_num = ?FIRST_LOGIN_GIFT_FIVE + 1}};

first_login_get_gift(OwnGift, #player{
                                 vip = 0,
                                 recv_gift_num = ?FIRST_LOGIN_GIFT_FIVE
                                } = Player) ->
    {OwnGift, Player};
%% 第7次潜规则
first_login_get_gift(#own_gift{
                        value = [{_GoodsId, GoodsNum}]
                       } = OwnGift, #player{
                                       vip = 0,
                                       recv_gift_num = ?FIRST_LOGIN_GIFT_EVEN
                                      } = Player) 
  when GoodsNum >= ?GIFT_GOLD_NUM ->
    BaseId = OwnGift#own_gift.goods_id,
    NOwnGift = 
        OwnGift#own_gift{goods_id = BaseId div 10 *10 + ?GIFT_FIVE_FOLD},
    {NOwnGift, Player#player{recv_gift_num = ?FIRST_LOGIN_GIFT_EVEN + 1}};

first_login_get_gift(OwnGift, #player{
                                 vip = 0,
                                 recv_gift_num = ?FIRST_LOGIN_GIFT_EVEN
                                } = Player) ->
    {OwnGift, Player};
%% 所有走
first_login_get_gift(OwnGift, #player{
                                 recv_gift_num = RecvGiftNum
                                } = Player) ->
    {OwnGift, Player#player{recv_gift_num = RecvGiftNum + 1}}.

own_gift_to_goods(#own_gift{player_id = PlayerId,
                            goods_id = BaseId,
                            value = Value}) ->
    BaseGoods = 
        case data_base_goods:get(BaseId) of
            [] ->
                #base_goods{};
            #base_goods{} = Base ->
                Base
        end,
    Goods = 
        lib_goods:base_goods_to_goods(PlayerId, BaseGoods, BaseGoods#base_goods.bind, 1),
    Goods#goods{
       value = Value,
       is_dirty = 1
      }.

rand_own_gift(GoldNum, PlayerId) ->
    ServerStart = 
        time_misc:datetime_to_timestamp(app_misc:get_env(server_start_timestamp)),
    NowTimeStamp = time_misc:unixtime(),
    rand_own_gift1(ServerStart, NowTimeStamp, GoldNum, PlayerId).

%% 开服7天内
rand_own_gift1(ServerStart, NowTimeStamp, GoldNum, PlayerId) 
  when NowTimeStamp - ServerStart < ?SERVER_EVEN_DAY*?ONE_DAY_SECONDS ->
    RandNum = hmisc:rand(1,100),
    GiftIdList = data_base_goods:get_all_pay_gift_id(),
    make_own_gift1(RandNum, GoldNum, GiftIdList, PlayerId);

%% 开服15天内，超7天
rand_own_gift1(ServerStart, NowTimeStamp, GoldNum, PlayerId) 
  when NowTimeStamp - ServerStart >= ?SERVER_EVEN_DAY*?ONE_DAY_SECONDS andalso
       NowTimeStamp - ServerStart < ?SERVER_FIFTY_DAY*?ONE_DAY_SECONDS ->
    RandNum = hmisc:rand(1,100),
    GiftIdList = data_base_goods:get_all_pay_gift_id(),
    make_own_gift2(RandNum, GoldNum, GiftIdList, PlayerId);

%% 开服15天之后
rand_own_gift1(ServerStart, NowTimeStamp, GoldNum, PlayerId) 
  when NowTimeStamp - ServerStart >= ?SERVER_FIFTY_DAY*?ONE_DAY_SECONDS ->
    RandNum = hmisc:rand(1,100),
    GiftIdList = data_base_goods:get_all_pay_gift_id(),
    make_own_gift3(RandNum, GoldNum, GiftIdList, PlayerId).


%% 五倍
make_own_gift1(RandNum, GoldNum, GiftIdList, PlayerId)
  when RandNum =< ?GIFT_FIVE_FOLD_IN_EVEN ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_FIVE_FOLD, PlayerId);
%% 四倍
make_own_gift1(RandNum, GoldNum, GiftIdList, PlayerId)
  when ?GIFT_FIVE_FOLD_IN_EVEN < RandNum andalso RandNum =< ?GIFT_FOUR_FOLD_IN_EVEN ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_FOUR_FOLD, PlayerId);
%% 三倍
make_own_gift1(RandNum, GoldNum, GiftIdList, PlayerId)
  when ?GIFT_FOUR_FOLD_IN_EVEN < RandNum andalso RandNum =< ?GIFT_THREE_FOLD_IN_EVEN ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_THREE_FOLD, PlayerId);
%% 两倍
make_own_gift1(RandNum, GoldNum, GiftIdList, PlayerId)
  when ?GIFT_THREE_FOLD_IN_EVEN < RandNum ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_TWO_FOLD, PlayerId).

%% 五倍
make_own_gift2(RandNum, GoldNum, GiftIdList, PlayerId)
  when RandNum =< ?GIFT_FIVE_FOLD_OUT_EVEN ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_FIVE_FOLD, PlayerId);
%% 四倍
make_own_gift2(RandNum, GoldNum, GiftIdList, PlayerId)
  when ?GIFT_FIVE_FOLD_OUT_EVEN < RandNum andalso RandNum =< ?GIFT_FOUR_FOLD_OUT_EVEN ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_FOUR_FOLD, PlayerId);
%% 三倍
make_own_gift2(RandNum, GoldNum, GiftIdList, PlayerId)
  when ?GIFT_FOUR_FOLD_OUT_EVEN < RandNum andalso RandNum =< ?GIFT_THREE_FOLD_OUT_EVEN ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_THREE_FOLD, PlayerId);
%% 两倍
make_own_gift2(RandNum, GoldNum, GiftIdList, PlayerId)
  when ?GIFT_THREE_FOLD_OUT_EVEN < RandNum ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_TWO_FOLD, PlayerId).

%% 五倍
make_own_gift3(RandNum, GoldNum, GiftIdList, PlayerId)
  when RandNum =< ?GIFT_FIVE_FOLD_OUT_FIFTY ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_FIVE_FOLD, PlayerId);
%% 四倍
make_own_gift3(RandNum, GoldNum, GiftIdList, PlayerId)
  when ?GIFT_FIVE_FOLD_OUT_FIFTY < RandNum andalso RandNum =< ?GIFT_FOUR_FOLD_OUT_FIFTY ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_FOUR_FOLD, PlayerId);
%% 三倍
make_own_gift3(RandNum, GoldNum, GiftIdList, PlayerId)
  when ?GIFT_FOUR_FOLD_OUT_FIFTY < RandNum andalso RandNum =< ?GIFT_THREE_FOLD_OUT_FIFTY ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_THREE_FOLD, PlayerId);
%% 两倍
make_own_gift3(RandNum, GoldNum, GiftIdList, PlayerId)
  when ?GIFT_FIVE_FOLD_OUT_FIFTY < RandNum ->
    new_own_gift(GoldNum, GiftIdList, ?GIFT_TWO_FOLD, PlayerId).

new_own_gift(GoldNum, [H|_] = GiftIdList, MultNum, PlayerId) ->
    GiftBaseId = 
        lists:foldl(fun(Id, TId) -> 
                            if
                                Id rem 10 =:= MultNum ->
                                    Id;
                                true ->
                                    TId
                            end
                    end, H, GiftIdList),
    #own_gift{
       id = next_own_gifts_id(),
       player_id = PlayerId,
       goods_id = GiftBaseId,
       value = [{?GOODS_TYPE_BGOLD, GoldNum}]
       %timestamp = time_misc:get_timestamp_of_tomorrow_start() + ?GIFT_OUT_TIME
      }.
next_own_gifts_id() ->
    %lib_counter:update_counter(next_own_gifts_id).
    0.
    
get_league_gifts_record_by_leagueid(LeagueId) ->
    hdb:dirty_index_read(league_gifts_record, LeagueId, #league_gifts_record.league_id, true).

delete_league_gifts_record_list(DeleteKeyList) ->
    hdb:dirty_delete_list(league_gifts_record, DeleteKeyList).

get_league_record(#player{
                     id = PlayerId
                    }) ->
    case lib_league:get_league_member_by_id(PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId} ->
            RecordList = get_league_gifts_record_by_leagueid(LeagueId),
            NRecordList = 
                lists:sort(fun(X, Y) ->
                                   X#league_gifts_record.id > Y#league_gifts_record.id
                           end, RecordList),
            {NewRecordList, DeleteKeyList, LeagueCount} = 
                lists:foldl(fun(LeagueGiftsRecord, {L1, L2, Count}) ->
                                    if
                                        Count >= 50 ->
                                            {L1, [LeagueGiftsRecord#league_gifts_record.id | L2], Count+1};
                                        true ->
                                            {[LeagueGiftsRecord | L1], L2, Count+1}
                                    end
                            end, {[], [], 0}, NRecordList),
            if 
                LeagueCount >= 200 ->
                    delete_league_gifts_record_list(DeleteKeyList);
                true ->
                    skip
            end,
            {ok, lists:reverse(NewRecordList)}
    end.

new_league_gifts_record_boss(GoldSum, #league_gifts{
                                         league_id = LeagueId
                                        }, SenderName) ->
    #league_gifts_record{
       id = next_league_gifts_record_id(),
       league_id = LeagueId,
       send_name = SenderName,
       timestamp = time_misc:unixtime(),
       value = GoldSum
      }.

new_league_gifts_boss(#player{id = PlayerId,
                              nickname = NickName}, GoldSum, GiftsNum, LeagueId) ->
    #league_gifts{id = next_gifts_id(),
                  league_id = LeagueId,
                  player_id = PlayerId,
                  player_name = NickName,
                  rest_num = GiftsNum,
                  sum = GiftsNum,
                  per_gold = GoldSum div GiftsNum,
                  gold_type = GoldSum,
                  over_time = time_misc:unixtime() + ?BOSS_GIFTS_OVERTIME,
                  is_league = 1
                 }.

boss_send_gifts(#player{id = PlayerId, sn = PlayerSn} = Player, SendGoldNum) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{
           league_id = LeagueId,
           title = Title
          } ->
            case Title =:= ?LEAGUE_TITLE_BOSS of
                false ->
                    {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER};
                true ->
                    case lib_league:get_league_info(LeagueId, PlayerSn) of
                        [] ->
                            {fail, ?INFO_CONF_ERR};
                        #league{
                           cur_num = CurNum,
                           bind_gold = GoldSum,
                           name = LeagueName,
                           id = LeagueId
                          } = OldLeague ->
                            if
                                CurNum < ?LEAGUE_MEMBRE_NUM_LIMIT ->
                                    {fail, ?INFO_LEAGUE_MEMBRE_NUM_NO_ENOUGH};
                                SendGoldNum > GoldSum ->
                                    {fail, ?INFO_LEAGUE_GOLD_NO_ENOUGH};
                                true ->
                                    NewLeagueGifts = new_league_gifts_boss(Player, SendGoldNum, CurNum, LeagueId),
                                    update_league_gifts(NewLeagueGifts),
                                    NewRecord = new_league_gifts_record_boss(SendGoldNum, NewLeagueGifts, LeagueName),
                                    write_league_gifts_record(NewRecord),
                                    Sn = Player#player.sn, 
                                    NickName = <<LeagueName/binary>>,
                                    mod_sys_acm:new_msg({NickName, PlayerId, LeagueId, SendGoldNum}, Sn, ?ACM_TYPE_SEND_GIFTS),
                                    lib_league:update_league(OldLeague#league{
                                                               bind_gold = GoldSum - SendGoldNum
                                                              }, PlayerSn),
                                    {ok, GoldSum - SendGoldNum}
                            end
                    end
            end
    end.

update_league_gifts(LeagueGifts) ->
    hdb:dirty_write(league_gifts, LeagueGifts).

next_recharge_gold_record_id() ->
     lib_counter:update_counter(league_recharge_gold_record).

new_recharge_gold_record(PlayerName, LeagueId, Gold) ->
    #league_recharge_gold_record{
       id = next_recharge_gold_record_id(),
       league_id = LeagueId,
       timestamp = time_misc:unixtime(),
       recharge_name = PlayerName,
       value = Gold
      }.

league_recharge_gold(#player{id = PlayerId,
                             nickname = NickName,
                             sn = Sn
                            }, Gold) ->
    case lib_league:get_league_member_by_id(PlayerId) of
        [] ->
            skip;
        #league_member{league_id = LeagueId} ->
            league_recharge_gold(Sn, NickName, erlang:trunc(Gold * ?RECHARGE_GOLD), LeagueId)
    end.

league_recharge_gold(PlayerSn, PlayerName, Gold, LeagueId) ->
    case lib_league:get_league_info(LeagueId, PlayerSn) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #league{bind_gold = OldGold} = League ->
            lib_league:update_league(League#league{
                                       bind_gold = OldGold + Gold
                                      }, PlayerSn),
            Record = new_recharge_gold_record(PlayerName, LeagueId, Gold),
            update_league_recharge_gold_record(Record)
    end.

update_league_recharge_gold_record(Record) ->
    hdb:dirty_write(league_recharge_gold_record, Record).

get_league_recharge_gold_record_by_leagueid(LeagueId) ->
    hdb:dirty_index_read(league_recharge_gold_record, LeagueId, #league_recharge_gold_record.league_id, true).

delete_league_recharge_gold_record(DeleteKeyList) ->
    hdb:dirty_delete_list(league_recharge_gold_record, DeleteKeyList).

get_recharge_gold_record(LeagueId) ->
    RecordList = get_league_recharge_gold_record_by_leagueid(LeagueId),
    NRecordList = 
        lists:sort(fun(X, Y) ->
                           X#league_recharge_gold_record.id > Y#league_recharge_gold_record.id
                   end, RecordList),
    {NewRecordList, DeleteKeyList, RecordCount} = 
        lists:foldl(fun(Record, {L1, L2, Count}) ->
                            if
                                Count >= 50 ->
                                    {L1, [Record#league_recharge_gold_record.id | L2], Count+1};
                                true ->
                                    {[Record | L1], L2, Count+1}
                            end
                    end, {[], [], 0}, NRecordList),
    if
        RecordCount >= 200 ->
            delete_league_recharge_gold_record(DeleteKeyList);
        true ->
            skip
    end,            
    lists:reverse(NewRecordList).

get_league_house(#player{id = PlayerId, sn = Sn}) ->
    case lib_league:get_my_league(PlayerId, Sn) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        {fail, Reson} ->
            {fail, Reson};
        #league{id = LeagueId, bind_gold = GoldSum} ->
            RecordList = get_recharge_gold_record(LeagueId),
            {RecordList, GoldSum}
    end.           

get_all_msg(PlayerId, Type) ->
    case lib_league:get_league_member(PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        AllMember ->
            lists:map(fun(#league_member{
                             player_name = Name,
                             recv_gold = RecvSum,
                             send_gold = SendSum
                            }) -> 
                              if
                                  Type =:= 0 -> %% 领取榜
                                      {Name, RecvSum};
                                  true -> %% 土豪榜
                                      {Name, SendSum}
                              end
                      end, AllMember)
    end.

invite_in_league(#player{
                    id = PlayerId,
                    nickname = NickName,
                    sn = Sn
                   }, Id) ->
    case lib_league:get_league_member_by_id(PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{
           league_id = LeagueId,
           title = Title
          } ->
            if
                Title =/= ?LEAGUE_TITLE_BOSS ->
                    {fail, ?INFO_LEAGUE_NOT_BOSS};
                true ->
                    case lib_league:get_league_info(LeagueId, Sn) of
                        [] ->
                            {fail, ?INFO_CONF_ERR};
                        #league{name = LeagueName} ->
                            case hmisc:whereis_player_pid(Id) of
                                [] ->
                                    {fail, ?INFO_NOT_ONLINE};
                                Pid ->
                                    mod_player:invite_in_league(Pid, {NickName, LeagueName, LeagueId})
                            end
                    end
            end
    end.

get_appoint_send_msg(#mod_player_state{
                        player = #player{id = PlayerId},
                        pay_gifts = GiftsList
                       }, GiftsId) ->
    case lib_league:get_league_member(PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        AllMember ->
            NAllMember = 
                lists:sort(fun(#league_member{player_id = X}, 
                               #league_member{player_id = Y}) -> 
                                   X < Y
                           end, AllMember),
            RecvList = 
                case lists:keytake(GiftsId, #pay_gifts.id, GiftsList) of
                    [] ->
                        [];
                    {value, #pay_gifts{recv_list = PList}, _} ->
                        PList
                end,
            NRecvList = 
                case get_league_gifts_by_giftid(GiftsId) of
                    [] ->
                        [PlayerId | RecvList];
                    #league_gifts{recv_list = List} ->
                        [PlayerId | List] ++ RecvList
                end,
            check_list(NAllMember, lists:usort(NRecvList))
    end.

get_league_gifts_by_giftid(GiftsId) ->
    hdb:dirty_read(league_gifts, GiftsId).

get_league_gifts_by_leagueid(LeagueId) ->
    hdb:dirty_index_read(league_gifts, LeagueId, #league_gifts.league_id, true).

check_list(AllMember, PlayerIdList) ->
    check_list1(AllMember, PlayerIdList, []).

check_list1([], _, AccList) ->
    AccList;
check_list1(L, [], AccList) ->
    lists:foldl(fun(Member, Acc) ->
                        get_league_player_msg(Member) ++ Acc
                end, AccList, L);

check_list1([Member|T1] = T, [PlayerId|T3] = T4, AccList) ->
    if
        Member#league_member.player_id =:= PlayerId ->
            check_list1(T1, T3, AccList);
        Member#league_member.player_id > PlayerId ->
            check_list1(T, T3, AccList);
        true ->
            check_list1(T1, T4, get_league_player_msg(Member) ++ AccList)
    end.

get_league_player_msg(#league_member{
                         player_id = PlayerId,
                         title = Title}) ->  
    case lib_player:get_player(PlayerId) of
        [] ->
            [];
        #player{
           nickname = NickName,
           lv = Lv
          } ->
            [{NickName, Lv, Title, PlayerId}]
    end.
appoint_send_gifts(#player{id = Id}, _, Id) ->
    {fail, ?INFO_PAY_GIFTS_SEND_NOT_SELF};
    
appoint_send_gifts(#mod_player_state{
                      player = #player{ nickname = NickName },
                      pay_gifts = GiftsList
                     } = ModPlayerState, GiftsId, Id) ->
    case lists:keytake(GiftsId, #pay_gifts.id, GiftsList) of
        false ->
            {fail, ?INFO_PAY_GIFTS_NOT_FOUND};
        {value, #pay_gifts{
                   recv_list = RecvList
                  } = OldGifts, Rest} ->
            HasRecv = lists:member(Id, RecvList),
            if
                HasRecv =:= true ->
                    {fail, ?INFO_PAY_GIFTS_APPOINT_SAME};
                true ->
                    case check_gifts(GiftsId, 1, [OldGifts]) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, #pay_gifts{
                                one_days_value_list = [PerGold | ValueList]
                               } = NewGifts, _} ->
                            Title = 
                                unicode:characters_to_binary("红包"),
                            Content1 = 
                                unicode:characters_to_binary("与你同公会的"), 
                            Content2 = 
                                unicode:characters_to_binary(lists:concat(["玩家，给你单独发送了价值", PerGold ,"礼金的红包,提取附件后，将以礼包形式发放，注意查看背包。"])),
                            Content = 
                                <<Content1/binary, NickName/binary, Content2/binary>>,
                            Attachments = 
                                [{?GOODS_TYPE_BGOLD, PerGold}],
                            Mail = 
                                lib_mail:mail(NickName, Title, Content, Attachments),
                            lib_mail:send_mail(Id, Mail),
                            {ok, ModPlayerState#mod_player_state{
                                   pay_gifts = [NewGifts#pay_gifts{
                                                  recv_list = [Id | RecvList],
                                                  one_days_value_list = ValueList,
                                                  last_send = time_misc:unixtime()
                                                 } | Rest]
                                  }}
                    end
            end
    end.

request_gifts_msg(#player{id = PlayerId}, LeagueId) ->
    case lib_league:get_league_member_list(LeagueId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        AllMember ->
            lists:foldl(fun(Member, Acc) ->
                                request_gifts_msg1(Member, PlayerId) ++ Acc
                        end, [], AllMember)
    end.

get_pay_gifts_by_playerid(PlayerId) ->
    hdb:dirty_index_read(pay_gifts, PlayerId, #pay_gifts.player_id, true).

request_gifts_msg1(#league_member{
                      player_id = PlayerId
                     }, PlayerId) ->
    []; %%筛掉自己
request_gifts_msg1(#league_member{
                      player_id = Id,
                      title = Title
                     }, PlayerId) ->
    AllPlayerGifts = get_pay_gifts_by_playerid(PlayerId),
    GiftsNum = 
        lists:foldl(fun(#pay_gifts{ id = GiftsId }, Count) -> 
                            RecvList = 
                                case get_league_gifts_by_giftid(GiftsId) of
                                    [] ->
                                        [];
                                    #league_gifts{recv_list = List} ->
                                        List
                                end,
                            HasRecv = lists:member(PlayerId, RecvList),
                            if
                                HasRecv =:= false ->
                                    Count + 1;
                                true ->
                                    Count
                            end
                    end, 0, AllPlayerGifts),
    if
        GiftsNum =:= 0 -> 
            [];
        Id =:= PlayerId ->
            [];
        true ->
            case lib_player:get_player(Id) of
                [] ->
                    [];
                #player{} = Player ->
                    case get_request_gifts_msg_by_playerid(Id) of
                        [] ->
                            [{Player#player.nickname, Player#player.lv, Title, GiftsNum, Id, 0}];
                        RequestList->
                            RequestGiftsMsg = queue_request_gifts_msg(RequestList, PlayerId),
                            QueueNum = 
                                if
                                    RequestGiftsMsg =:= [] ->
                                        0;
                                    true ->
                                        RequestGiftsMsg#request_gifts_msg.request_num
                                end,
                            IsRequest = 
                                if
                                    QueueNum =:= 0 ->
                                        0;
                                    true ->
                                        1
                                end,
                            NewGiftsNum = 
                                if 
                                    GiftsNum =< QueueNum ->
                                        0;
                                    true ->
                                        GiftsNum - QueueNum
                                end,
                            [{Player#player.nickname, Player#player.lv, Title, NewGiftsNum, Id, IsRequest}]
                    end                   
            end
    end.

get_request_gifts_msg_by_playerid(PlayerId) ->
    hdb:dirty_index_read(request_gifts_msg, PlayerId, #request_gifts_msg.player_id, true).

update_request_gifts_msg(Record) ->
    hdb:dirty_write(request_gifts_msg, Record).

queue_request_gifts_msg([], _) ->
    [];
queue_request_gifts_msg([#request_gifts_msg{
                            request_player_id = PlayerId
                           } = RequestGiftsMsg | _], PlayerId) ->
    RequestGiftsMsg;
queue_request_gifts_msg([_|T], PlayerId) ->
    queue_request_gifts_msg(T, PlayerId).

request_player_gifts(#player{id = PlayerId, nickname = RNickname}, Id) ->
    case get_request_gifts_msg_by_playerid(PlayerId) of
        [] ->
            update_request_gifts_msg(new_request_gifts_msg(Id, PlayerId, RNickname));
        RequestList ->
            case queue_request_gifts_msg(RequestList, PlayerId) of
                [] ->
                    update_request_gifts_msg(new_request_gifts_msg(Id, PlayerId, RNickname));
                _ ->
                    ok
            end%% ,
            
            %% case hmisc:whereis_player_pid(Id) of
            %%     [] ->
            %%         ok;
            %%     Pid ->
            %%         mod_player:request_player_gifts(Pid),
            %%         ok
            %% end
    end.

next_request_gifts_msg_id() ->
    lib_counter:update_counter(request_gifts_msg).

new_request_gifts_msg(PlayerId, RId, RNickname) ->
    #request_gifts_msg{
       id = next_request_gifts_msg_id(),
       player_id = PlayerId,     %%被请求者ID
       request_player_id = RId,  %%请求者ID
       request_num = 1,
       request_name = RNickname,
       is_read = 0
      }.

get_request_msg(#player{id = PlayerId}) ->
    case get_request_gifts_msg_by_playerid(PlayerId) of
        [] ->
            [];
        RequestList ->
            {_AccIdList, AccRequestList} = 
                lists:foldl(fun(#request_gifts_msg{
                                   id = RId,
                                   request_name = Name,
                                   request_num = Num,
                                   request_player_id = Id,
                                   is_read = IsRead
                                  }, {AccId, AccRequest}) -> 
                                    if
                                        IsRead =:= 0 ->
                                            {[RId|AccId], [{Name, Id, Num} | AccRequest]};
                                        true ->
                                            {AccId, AccRequest}
                                    end
                            end, {[], []}, RequestList),
            AccRequestList
    end.

clean_request_gifts_msg(PlayerId, Id) ->
    case get_request_gifts_msg_by_playerid(PlayerId) of
        [] ->
            skip;
        RequestList ->
            clean_request_gifts_msg1(RequestList, Id)
    end.

clean_request_gifts_msg1([], _) ->
    skip;
clean_request_gifts_msg1([#request_gifts_msg{
                             request_player_id = Id
                            } = R | _], Id) ->
    update_request_gifts_msg(R#request_gifts_msg{is_read = 1}),
    skip;
clean_request_gifts_msg1([_ | T], Id) ->
    clean_request_gifts_msg1(T, Id).

agree_request_gifts(#mod_player_state{
                       player = #player{
                                   id = PlayerId,
                                   nickname = NickName
                                  },
                       pay_gifts = GiftsList
                      } = ModPlayerState, Id) ->
    case get_agree_request_gifts(GiftsList, Id) of
        [] ->
            {fail, ?INFO_PAY_GIFTS_RECV_FALSE};
        #pay_gifts{
           id = GiftId, 
           recv_list = RecvList,
           day_num = DayNum,
           rest_num = RestNum,
           one_days_value_list = [PerGold | ValueList]
          } = PayGifts ->
            Title = 
                unicode:characters_to_binary("索要红包成功！"),
            Content1 = 
                unicode:characters_to_binary("与你同公会的"), 
            Content2 = 
                unicode:characters_to_binary(lists:concat(["玩家，给你单独发送了价值", PerGold ,"礼金的红包"])),
            Content = 
                <<Content1/binary, NickName/binary, Content2/binary>>,
            Mail = 
                lib_mail:mail(NickName, Title, Content, [{?GOODS_TYPE_BGOLD, hmisc:rand(1, PerGold)}]),
            lib_mail:send_mail(Id, Mail),
            clean_request_gifts_msg(PlayerId, Id),
            {value, _, Rest} =
                lists:keytake(GiftId, #pay_gifts.id, GiftsList),
            {ok, ModPlayerState#mod_player_state{
                   pay_gifts = [dirty_gifts(
                                  PayGifts#pay_gifts{
                                    recv_list = [Id | RecvList],
                                    day_num = DayNum + 1,
                                    rest_num = RestNum - 1,
                                    one_days_value_list = ValueList,
                                    last_send = time_misc:unixtime()
                                   }) | Rest]
                  }}
    end.

get_agree_request_gifts([], _) ->
    [];
get_agree_request_gifts([#pay_gifts{
                            recv_list = RecvList,
                            day_num = DayNum,
                            one_days_value_list = ValueList
                           } = PayGifts | List], Id) ->
    HasRecv = lists:member(Id, RecvList),
    if
        HasRecv =:= true ->
            get_agree_request_gifts(List, Id);
        ?DAY_SEND_GIFTS =< DayNum ->
            get_agree_request_gifts(List, Id);
        ValueList =:= [] ->
            get_agree_request_gifts(List, Id);
        true ->
            PayGifts
    end.

disagree_request_gifts(#player{
                          nickname = NickName,
                          id = PlayerId
                         }, Id) ->
    Title = 
        unicode:characters_to_binary("索要红包失败！"),
    Content1 = 
        unicode:characters_to_binary("与你同公会的"), 
    Content2 = 
        unicode:characters_to_binary("玩家，拒绝了给你发送红包"),
    Content = 
        <<Content1/binary, NickName/binary, Content2/binary>>,
    Mail = 
        lib_mail:mail(NickName, Title, Content, []),
    lib_mail:send_mail(Id, Mail),
    clean_request_gifts_msg(PlayerId, Id),
    ok.

get_league_gifts_num(#player{id = PlayerId}) ->
    case lib_league:get_league_member_by_id(PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId} ->
            case get_league_gifts_by_leagueid(LeagueId) of
                [] ->
                    {fail, ?INFO_LEAGUE_NOT_FIND_GIFTS};
                LeagueGiftsList ->
                    lists:foldl(fun(#league_gifts{
                                       rest_num = RestNum
                                      }, Sum) ->
                                        Sum + RestNum
                                end, 0, LeagueGiftsList)
            end
    end.

decomposition_gift(#mod_player_state{
                      bag = GoodsList,
                      player = Player
                     } = ModPlayerState, Id) ->
    case lists:keytake(Id, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_CONF_ERR};
        {value, Goods, Rest} ->           
            [{GoodsId, GoldNum}|_] = Goods#goods.value,
            BaseId = Goods#goods.base_id,
            ReturnGold = Player#player.return_gold,
            MultNum = BaseId rem 10,
            {{ok, NModPlayerState}, NMultNum} = 
                if
                    ReturnGold < GoldNum ->
                        {lib_reward:take_reward(ModPlayerState, [{GoodsId, GoldNum}], ?DECOMPOSITION_GIFT), 1};
                    %% ReturnGold =< 0 ->
                    %%     {lib_reward:take_reward(ModPlayerState, [{GoodsId, GoldNum}], ?DECOMPOSITION_GIFT), 1};
                    true ->
                        {lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                 player = Player#player{return_gold = ReturnGold - GoldNum}
                                                }, [{GoodsId, GoldNum*MultNum}], ?DECOMPOSITION_GIFT), MultNum}
                end,
            pt_15:pack_goods([], [], [Goods]),
            lib_goods:db_delete_goods(Goods),
            {ok, NModPlayerState#mod_player_state{bag = Rest}, NMultNum}
    end.

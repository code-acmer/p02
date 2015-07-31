-module(lib_camp).
%% -export([role_init/2,
%%          save_camp/3,
%%          switch_camp/2,
%%          get_player_camp/1
%%         ]).

%% -include("define_camp.hrl").
%% -include("define_player.hrl").
%% -include("define_goods.hrl").
%% -include("define_logger.hrl").
%% -include("define_info_44.hrl").

%% %% 角色数据初始化
%% role_init(PlayerId, GidList) ->
%%     [Gid1, Gid2, Gid3, Gid4] = GidList,
%%     CampList = 
%%         lists:map(fun(I) ->
%%                           #camp{id = I,
%%                                 pos_list = [{1, Gid4},
%%                                             {2, Gid3},
%%                                             {3, Gid2},
%%                                             {4, Gid1},
%%                                             {5, ?CLOSE_POS},
%%                                             {6, ?CLOSE_POS}]
%%                                }
%%                   end, lists:seq(1, ?MAX_CAMP_CNT)),
%%     PlayerCamp = #player_camp{player_id = PlayerId,
%%                               using_camp = 1,
%%                               camp_list = CampList},
%%     update_player_camp(PlayerCamp),
%%     ok.

%% get_player_camp(PlayerId) ->
%%     hdb:dirty_read(player_camp, PlayerId).

%% update_player_camp(PlayerCamp) ->
%%     hdb:dirty_write(player_camp, PlayerCamp).

%% save_camp(#mod_player_state{
%%              player  = Player
%%             } = ModPlayerSate, CampId, PosList) ->
%%     case get_player_camp(Player#player.id) of
%%         #player_camp{
%%            camp_list = CampList
%%           } = PlayerCamp ->
%%             case lists:keyfind(CampId, #camp.id, CampList) of
%%                 false ->
%%                     {fail, ?INFO_CAMP_NOT_FOUND};
%%                 #camp{
%%                   } = Camp ->
%%                     %% ?WARNING_MSG("PosList : ~w~n",[PosList]),
%%                     case check_camp_pos_list(ModPlayerSate, PosList) of
%%                         true ->
%%                             NewCamp = Camp#camp{pos_list = PosList},
%%                             NewCampList = 
%%                                 lists:keyreplace(
%%                                   CampId, #camp.id, CampList, NewCamp),
%%                             NewPlayerCamp = 
%%                                 PlayerCamp#player_camp{
%%                                   camp_list = NewCampList},
%%                             {ok, NewModPlayerState ,UpdatedGoods} = 
%%                                 lib_goods:update_player_camp(ModPlayerSate, PosList),
%%                             update_player_camp(NewPlayerCamp),
%%                             [{1, CoreId} | _] = PosList,
%%                             {ok, NewModPlayerState#mod_player_state{
%%                                    player = Player#player{
%%                                               core = CoreId
%%                                               %% bag_cnt = Player#player.bag_cnt + AddBagCnt
%%                                              }
%%                                   }, NewCamp, UpdatedGoods};
%%                         false ->
%%                             {fail, ?INFO_CAMP_POSITION_CHECK_FAILED}
%%                     end
%%             end;
%%         _ ->
%%             {fail, ?INFO_CAMP_NOT_FOUND}
%%     end.

%% check_camp_pos_list(ModPlayerSate, PosList) ->
%%     ?DEBUG("Player.id :~w,PosList : ~p~n",[ModPlayerSate?PLAYER_ID,PosList]),
%%     GoodsList = lib_goods:get_player_goods_list(ModPlayerSate),
%%     {CheckRet, RetPos, CostRet} = 
%%         lists:foldl(
%%           fun({Pos, Gid}, {Ret, CurPos, CostSum}) ->
%%                   if
%%                       Ret    =:= true andalso 
%%                       CurPos =:= Pos andalso 
%%                       Gid    =/= ?CLOSE_POS -> 
%%                           case lists:keyfind(Gid, #goods.id, GoodsList) of
%%                               false ->
%%                                   {false, CurPos + 1, CostSum};
%%                               #goods{
%%                                  cost = Cost
%%                                 } ->
%%                                   {Ret, CurPos + 1, CostSum+Cost}
%%                           end;
%%                       true ->
%%                           {Ret, CurPos + 1, CostSum}
%%                   end
%%           end, {true, 1, 0}, PosList),
%%     ?DEBUG("CheckRet : ~w RetPos : ~w, CostSum:~w Player.cost : ~w ~n",[CheckRet, RetPos, CostRet,ModPlayerSate?PLAYER#player.cost]),
%%     CostRet =< ModPlayerSate?PLAYER#player.cost andalso RetPos =:= 7 andalso CheckRet.

%% switch_camp(#mod_player_state{
%%                player = Player
%%               } = ModPlayerState, CampId) ->
%%     case get_player_camp(Player#player.id) of
%%         #player_camp{
%%            using_camp = UsingCamp,
%%            camp_list = CampList
%%           } = PlayerCamp when UsingCamp =/= CampId ->
%%             case lists:keyfind(CampId, #camp.id, CampList) of
%%                 false ->
%%                     {fail, ?INFO_CAMP_NOT_FOUND};
%%                 #camp{pos_list = PosList} ->
%%                     case check_camp_pos_list(ModPlayerState, PosList) of
%%                         true ->
%%                             [{1, CoreId} | _] = PosList,
%%                             {ok, NewModPlayerState,UpdatedGoods} = 
%%                                 lib_goods:update_player_camp(
%%                                   ModPlayerState, PosList),
%%                             update_player_camp(
%%                               PlayerCamp#player_camp{using_camp = CampId}),
%%                             {ok, NewModPlayerState#mod_player_state{
%%                                    player = Player#player{
%%                                               core = CoreId
%%                                              }
%%                                   },
%%                              %% bag_cnt = Player#player.bag_cnt + AddBagCnt},
%%                              UpdatedGoods};
%%                         false ->
%%                             {fail, ?INFO_CAMP_POSITION_CHECK_FAILED}
%%                     end
%%             end;
%%         #player_camp{
%%            using_camp = UsingCamp
%%           } when UsingCamp =:= CampId->
%%             ok;
%%         _ ->
%%             {fail, ?INFO_CAMP_NOT_FOUND}
%%     end.


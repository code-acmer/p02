%%%--------------------------------------
%%% @Module  : pt_14
%%% @Created : 2010.10.05
%%% @Description:  14玩家间关系信息
%%%--------------------------------------
-module(pt_14).
-export([write/2,
         pack_friend_equip/1,
         player_detail_to_friend/2,
         player_detail_list_pbfriendlist/1]).

-include("define_logger.hrl").
-include("define_player.hrl").
-include("define_dungeon.hrl").
-include("define_relationship.hrl").
-include("pb_14_pb.hrl").
-include("define_goods.hrl").
-include("define_combat.hrl").

%% 打包好友信息列表
write(14000, {player_detail, PlayerInfoList}) ->    
    PbFriendList = player_detail_list_pbfriendlist(PlayerInfoList),        
    pt:pack(14000, PbFriendList);
write(14000, {combat_attri_list, CombatAttriList}) ->    
    PbFriendList = player_detail_list_pbfriendlist(CombatAttriList),        
    pt:pack(14000, PbFriendList);
write(14000, {UpdateRelaList, DeleteId})
  when is_integer(DeleteId) ->
    L1 = 
        lists:foldl(fun(Rela, AccPbFriend) ->
                            case pack_friend_info(Rela) of
                                [] ->
                                    AccPbFriend;
                                Other ->
                                    [Other|AccPbFriend]
                            end
                    end, [], UpdateRelaList),
    L2 = [#pbfriend{id = DeleteId}],
    %% ?DEBUG("UpdateRelaList : ~p~n", [L1]),
    %% ?DEBUG("Delete : ~p~n", [L2]),
    pt:pack(14000, #pbfriendlist{update_list = L1,
                                 delete_list = L2});
write(14000, {UpdateRelaList, DeleteRelaList}) ->
    L1 = 
        lists:foldl(fun(Rela, AccPbFriend) ->
                            case pack_friend_info(Rela) of
                                [] ->
                                    AccPbFriend;
                                Other ->
                                    [Other|AccPbFriend]
                            end
                    end, [], UpdateRelaList),
    L2 = lists:map(fun(DRela) ->
                           #pbfriend{id = DRela#relationship.tid}
                   end, DeleteRelaList),
    pt:pack(14000, #pbfriendlist{update_list = L1,
                                 delete_list = L2});

%% 推荐好友列表
write(14055, List) ->
    pt:pack(14055, #pbfriendlist{update_list = List});

write(Cmd, _R) ->
    ?INFO_MSG("pp_relationship failed: ~p~n", [Cmd]),
    pt:pack(0, null).


%% @doc 打包好友信息
%% @spec pack_friend_info(Rela | Player) -> {ok, BinData}
%% @end
pack_friend_info(Pb)
  when is_record(Pb, pbfriend) ->
    Pb;
pack_friend_info(Player) 
  when is_record(Player, player) ->
    player_info_to_friend(Player, ?RELATIONSHIP_FRIENDS);
pack_friend_info({Player, Rela}) 
  when is_record(Player, player) ->
    player_info_to_friend(Player, Rela);
%%事实上好友列表返回的应该是少量的信息，否则包会过于大
pack_friend_info(#relationship{tid= Id, rela = Rela}) ->
    case lib_player:get_other_player(Id) of
        [] ->
            [];
        Player ->
            player_info_to_friend(Player, Rela)
    end;
%% pack_friend_info(#relationship{tid= Id, rela = Rela}) ->
%%     case lib_player:get_other_player_detail(Id) of
%%         [] ->
%%             [];
%%         Detail ->
%%             player_detail_to_friend(Detail, Rela)
%%     end;
pack_friend_info(Other) ->
    ?DEBUG("match failed: ~w.~n", [Other]),
    [].

pack_friend_equip(PlayerId) ->
    EquipList = lib_player:get_other_player_equip(PlayerId),
    lists:map(fun(Equip) ->
                      pt_15:to_pbgoods(Equip)
              end, EquipList).

player_detail_to_friend({Player, GoodsList, LeagueInfo, Mugen, SkillList}, Rela) ->
    #player{id = Id,
            nickname = NickName,
            career   = Career,
            lv       = Lv,
            fashion  = Fashion,
            timestamp_login = LoginTime,
            battle_ability = BattleAbility} = Player,
    {MugenPass, MugenScore} = 
        if
            Mugen =:= [] ->
                {0, 0};
            true ->
                {Mugen#dungeon_mugen.have_pass_times, Mugen#dungeon_mugen.score}
        end,
    {Core, PbSkillList} = pt_13:goods_list_to_core_card(GoodsList),
    {LeagueName, LeagueTitle} = league_info(LeagueInfo),
    Talent = 
        lists:map(fun(#player_skill{lv = PlayerSkillLv,
                                    str_lv = StrLv,
                                    skill_id = SkillId}) ->
                          #pbskill{
                             lv       = PlayerSkillLv,
                             skill_id = SkillId,
                             str_lv = StrLv}
                  end, SkillList),
    ?DEBUG("Talent: ~p~n",[Talent]),
    #pbfriend{
       id = Id, 
       nickname = NickName, 
       career = Career,
       level = Lv,
       core = Core,
       fashion  = Fashion,
       off_time = LoginTime,
       skill_list = PbSkillList,
       talent = Talent,
       mugen_pass_times = MugenPass,
       mugen_score = MugenScore,
       battle_ability = BattleAbility,
       rela = Rela,
       league_name = LeagueName,
       league_title = LeagueTitle
      };
player_detail_to_friend(#combat_attri{player_id   = PlayerId,
                                      career      = Career,
                                      nickname    = NickName,
                                      lv          = Lv,
                                      ability     = Ability,
                                      %% high_ability = HighAbility,
                                      league_name = LeagueName,
                                      league_title= LeagueTitle,
                                      final_attri  = Attri,
                                      equips      = Equips,
                                      fashions    = Fashions, 
                                      stunts      = Stunts,
                                      type        = Type
                                     }, Rela) ->
    #pbfriend{
       id = PlayerId, 
       nickname = hmisc:to_binary(NickName), 
       career = Career,
       level = Lv,
       core = lists:map(fun(Goods) ->
                                pt_15:to_pbgoods(Goods)
                        end, Equips),
       skill_list = lists:map(fun(Goods) -> pt_13:goods_to_skill_card(Goods) end, Stunts),
       battle_ability = Ability,
       rela = Rela,
       league_name = LeagueName,
       league_title = LeagueTitle,
       attri = pt_13:to_pbattribute(Attri),
       type = Type,
       fashion = lists:map(fun(Goods) ->
                                   pt_15:to_pbgoods(Goods)
                           end, lib_combat_attri:pass_not_wear_fashion(Fashions))
      }.


player_detail_list_pbfriendlist(PlayerInfoList) ->
    #pbfriendlist{update_list = 
                      lists:map(fun(PlayerDetail) ->
                                        player_detail_to_friend(PlayerDetail, ?RELATIONSHIP_STRANGE)
                                end, PlayerInfoList)
                 }.

player_info_to_friend(Player, Rela) ->
    #pbfriend{
       id              = Player#player.id,
       nickname        = Player#player.nickname,
       level           = Player#player.lv,
       career          = Player#player.career,
       %vip_lv          = Player#player.vip,
       battle_ability  = Player#player.battle_ability,
       rela =          Rela
      }.

league_info([]) ->
    {undefined, undefined};
league_info({_, _} = Other) ->
    Other;
league_info({_, LeagueName, LeagueTitle}) ->
    {LeagueName, LeagueTitle}.

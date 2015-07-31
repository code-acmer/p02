-module(lib_combat_attri).
-include("common.hrl").
-include("define_combat.hrl").
-include("db_base_player.hrl").
-include("define_goods_rec.hrl").
-include("define_goods.hrl").
-include("db_base_goods.hrl").
-include("db_base_goods_strengthen.hrl").
-include("db_base_combat_skill.hrl").
-include("db_base_combat_skill_upgrade.hrl").
-include("db_base_skill_card.hrl").
-include("db_base_fashion_combination.hrl").

-export([
         count_combat_attri/1,
         get_combat_attri/1,
         pass_not_wear_fashion/1
        ]).

get_combat_attri(PlayerId) ->
    case hdb:dirty_read(combat_attri, PlayerId) of
        [] ->
            case count_combat_attri(PlayerId) of
                #combat_attri{} = CombatAttri ->
                    update_combat_attri(CombatAttri),
                    CombatAttri;
                _ ->
                    []
            end;
        #combat_attri{base_attri = BaseAttri,
                      final_attri = FinalAttri} = CombatAttri ->
            NewBaseAttri = hdb:try_upgrade_record(BaseAttri),
            NewFinalAttri = hdb:try_upgrade_record(FinalAttri),
            CombatAttri#combat_attri{
              base_attri = NewBaseAttri,
              final_attri = NewFinalAttri
             }
    end.

update_combat_attri(CombatAttri) ->
    hdb:dirty_write(combat_attri, CombatAttri).

%% this function will call the player process, so do not call it from player process
%% 重新计算玩家属性相关
count_combat_attri(PlayerId) ->
    case lib_player:get_other_player_detail(PlayerId) of
        {Player, GoodsList, LeagueInfo, _Mugen, SkillList} ->
            
            {Stunts, Fashions, Equips, Xunzhangs} = get_stunts_fashions_equips_xunzhang(GoodsList),
            %% Fashions = get_fashions(GoodsList),
            FashionCombinationBaseIds = get_fashion_combination_base_ids(Fashions),
            ?DEBUG("FashionCombinationBaseIds: ~p", [FashionCombinationBaseIds]),
            %?DEBUG("Equips : ~p~n",[Equips]),
            %% Equips = lists:foldl(fun(#goods{container = Container,
            %%                                 position = Position} = Goods, Ret) ->
            %%                              case Container of
            %%                                  ?CONTAINER_EQUIP when Position > 0 ->
            %%                                      [Goods|Ret];
            %%                                  _ ->
            %%                                      Ret
            %%                              end
            %%                      end, [], GoodsList),
            {LeagueName, LeagueTitle}= case LeagueInfo of
                                           [] ->
                                               {"", 0};
                                           {Name, Title} ->
                                               {Name, Title}
                                       end,
            WearFashion = pass_not_wear_fashion(Fashions),
            InitCombatAttri = #combat_attri{player_id = PlayerId,
                                            lv        = Player#player.lv,
                                            career    = Player#player.career,
                                            nickname  = Player#player.nickname,
                                            sn        = Player#player.sn,
                                            ability   = Player#player.battle_ability,
                                            high_ability = Player#player.high_ability,
                                            league_name = LeagueName,
                                            league_title = LeagueTitle,
                                            equips    = Equips,
                                            stunts    = Stunts,
                                            fashions  = WearFashion
                                           },
            ?DEBUG("Equips : ~p~n",[Equips]),
            PlayerSkillRecord = lib_player:get_player_skill_record(PlayerId),
            BaseCombatAttri = count_base_player_attri(InitCombatAttri, Player),
            %% AddXunzhangAttri = count_xunzhang_player_attri(BaseCombatAttri, Xunzhangs),
            %print_base_attri(BaseCombatAttri),
            AddEquipCombatAttri = count_equip_player_attri(BaseCombatAttri, Xunzhangs ++ Equips ++ Fashions),
            %print_base_attri(AddEquipCombatAttri),
            AddSkillCombatAttri = count_skill_player_attri(AddEquipCombatAttri, SkillList),
            %print_base_attri(AddSkillCombatAttri),
            AddSkillRecordCombatAttri = count_skill_record_player_attri(AddSkillCombatAttri, PlayerSkillRecord),
            %print_base_attri(AddSkillRecordCombatAttri),
            AddFashionCombinationAttri = count_fashion_combination_player_attri(AddSkillRecordCombatAttri, FashionCombinationBaseIds),
            
            CountPercentCombatAttri = count_percent_player_attri(AddFashionCombinationAttri),
            FinalCombatAttri = CountPercentCombatAttri#combat_attri{
                                 base_attri  = ceil(CountPercentCombatAttri#combat_attri.base_attri),
                                 final_attri = ceil(CountPercentCombatAttri#combat_attri.final_attri)
                                },
            %print_base_attri(FinalCombatAttri),            
            FinalCombatAttri;
        _  ->
            ignored
    end.

pass_not_wear_fashion(Fashions) ->
    lists:foldl(fun(#goods{
                       container = ?CONTAINER_EQUIP
                      } = Goods, Acc) -> 
                        [Goods|Acc];
                   (_, Acc) ->
                        Acc
                end, [], Fashions).

get_fashion_combination_base_ids(Fashions) ->
    NewFashions = 
        lists:sort(fun(#goods{subtype = A}, #goods{subtype = B}) ->
                           A < B
                   end, Fashions),
    AllIds = data_base_fashion_combination:all(),
    lists:foldl(fun(Id, Ret) ->
                        case data_base_fashion_combination:get(Id) of
                            [] -> 
                                Ret;
                            FashionCombination ->
                                %?DEBUG("FashionCombination: ~p", [FashionCombination]),
                                case check_fashion_condition(FashionCombination, NewFashions) of
                                    true ->
                                        [Id | Ret];
                                    false ->
                                        Ret
                                end
                        end
                end, [], AllIds).

check_fashion_condition(#base_fashion_combination{
                           weapon_id = WeaponId,
                           clothes_id = ClothesId,
                           wing_id = WingId,
                           ornament_id = OrnamentId,
                           wish_id = WishId
                          }, NewFashions) ->
    lists:foldl(fun(Id, Result) ->
                        case Result of
                            false -> 
                                Result;
                            true ->
                                case lists:keytake(Id, #goods.base_id, NewFashions) of
                                    false ->
                                        false;
                                    _ ->
                                        Result
                                end
                        end
                end, true, [WeaponId, ClothesId, WingId, OrnamentId, WishId]).

%% get_fashions(GoodsList) ->
%%     lists:foldl(fun(#goods{type = Type} = Goods, Ret) ->
%%                         case Type of
%%                             ?TYPE_GOODS_FAHSION ->
%%                                 [Goods|Ret];
%%                             _ ->
%%                                 Ret
%%                         end
%%                 end, [], GoodsList).

get_stunts_fashions_equips_xunzhang(GoodsList) ->
    lists:foldl(fun(#goods{type      = Type,
                           subtype   = SubType,
                           container = Container,
                           position  = Position,
                           card_pos_1 = CardPos1} = Goods, {Stunts, Fashions, Equips, Xunzhangs}) ->
                        case Container of
                            ?CONTAINER_EQUIP when Position > 0 ->
                                {Stunts, Fashions, [Goods|Equips], Xunzhangs};
                            _ ->
                                case Type of
                                    ?TYPE_GOODS_FAHSION ->
                                        {Stunts, [Goods|Fashions], Equips, Xunzhangs};
                                    _->
                                        case SubType of
                                            ?XUNZHANG_SUBTYPE ->
                                                {Stunts, Fashions, Equips, [Goods|Xunzhangs]};
                                            _ ->
                                                if
                                                    CardPos1 > 0 ->
                                                        {[Goods|Stunts], Fashions, Equips, Xunzhangs};
                                                    true -> 
                                                        {Stunts, Fashions, Equips, Xunzhangs}
                                                end

                                        end


                                end
                        end
                end, {[], [], [], []}, GoodsList).

print_base_attri(#combat_attri{base_attri = BaseAttri}) ->
    [_|Values] = tuple_to_list(BaseAttri),
    ZipList = lists:zip(all_record:get_fields(attribute), Values),
    ?DEBUG("base_attri : ~p~n",[ZipList]);
print_base_attri(#attribute{} = Attri) ->
    [_|Values] = tuple_to_list(Attri),
    ZipList = lists:zip(all_record:get_fields(attribute), Values),
    ?DEBUG("base_attri : ~p~n",[ZipList]).
     

%% 角色等级基础属性
count_base_player_attri(CombatAttri, #player{lv = Lv} = _Player) ->
    
    case data_base_player:get(Lv) of
        [] ->
            CombatAttri;
        BasePlayer ->
            BaseAttri = to_attribute(BasePlayer),
            CombatAttri#combat_attri{
              base_attri  = BaseAttri
             }
    end.

%% count_xunzhang_player_attri(CombatAttri, Xunzhangs) ->
    
%%     CombatAttri#combat_attri{
%%      }.

%% 装备属性
count_equip_player_attri(#combat_attri{base_attri = BaseAttri} = CombatAttri, Equips) ->
    NewBaseAttri = lists:foldl(fun(Equip, RetAttri) ->
                                       %?DEBUG("Before Add Equip : ~p ~n",[Equip]),
                                       %print_base_attri(RetAttri),
                                       add(RetAttri, to_attribute(Equip))
                               end, BaseAttri, Equips),
    CombatAttri#combat_attri{
      base_attri = NewBaseAttri
     }.

%% 天赋属性
count_skill_player_attri(#combat_attri{base_attri = BaseAttri} = CombatAttri, PlayerSkills) ->
    NewBaseAttri = lists:foldl(fun(Skill, RetAttri) ->
                                       add(RetAttri, to_attribute(Skill))
                               end, BaseAttri, PlayerSkills),
    CombatAttri#combat_attri{
      base_attri = NewBaseAttri
     }.


%% 技能图鉴属性
count_skill_record_player_attri(#combat_attri{base_attri = BaseAttri} = CombatAttri, PlayerSkillRecord) ->
    NewBaseAttri = add(BaseAttri, to_attribute(PlayerSkillRecord)),
    CombatAttri#combat_attri{
      base_attri = NewBaseAttri
     }.

%% 时装套装属性
count_fashion_combination_player_attri(#combat_attri{base_attri = BaseAttri} = CombatAttri, FashionCombinationBaseIds) ->
    NewBaseAttri = lists:foldl(fun(BaseId, RetAttri) ->
                                       BaseGoods = data_base_goods:get(BaseId),
                                       add(RetAttri, to_attribute(BaseGoods))
                               end, BaseAttri, FashionCombinationBaseIds),
    CombatAttri#combat_attri{
      base_attri = NewBaseAttri
     }.
%% 计算百分比属性
count_percent_player_attri(#combat_attri{base_attri = BaseAttri
                                        } = CombatAttri) ->
    NewFinalAttri = add(BaseAttri, percent(BaseAttri, BaseAttri)),
    print_base_attri(BaseAttri),
    print_base_attri(NewFinalAttri),
    CombatAttri#combat_attri{final_attri  = NewFinalAttri
                            }.
    


to_attribute(#ets_base_player{hp_lim      = HpLim,
                              mana_lim    = ManaLim,
                              hp_rec      = HpRec,
                              mana_rec    = ManaRec,
                              attack      = Attack,
                              def         = Def,
                              hit         = Hit,
                              dodge       = Dodge,
                              crit        = Crit,
                              anti_crit   = AntiCrit,
                              stiff       = Stiff,
                              anti_stiff  = AntiStiff,
                              attack_speed = AttackSpeed,
                              move_speed  = MoveSpeed
                             }) ->
    #attribute{hp_lim      = HpLim,
               mana_lim    = ManaLim,
               hp_rec      = HpRec,
               mana_rec    = ManaRec,
               attack      = Attack,
               def         = Def,
               hit         = Hit,
               dodge       = Dodge,
               crit        = Crit,
               anti_crit   = AntiCrit,
               stiff       = Stiff,
               anti_stiff  = AntiStiff,
               attack_speed = AttackSpeed,
               move_speed  = MoveSpeed
              };
to_attribute(#base_goods{hp_lim      = HpLim,
                         mana_lim    = ManaLim,
                         mana_rec    = ManaRec,
                         attack      = Attack,
                         def         = Def,
                         hit         = Hit,
                         dodge       = Dodge,
                         crit        = Crit,
                         anti_crit   = AntiCrit,
                         stiff       = Stiff,
                         anti_stiff  = AntiStiff,
                         attack_speed = AttackSpeed,
                         move_speed  = MoveSpeed,
                         hp_lim_percent    = HpLimPercent,
                         attack_percent	   = AttackPercent,
                         def_percent       = DefPercent,
                         hit_percent	   = HitPercent,
                         dodge_percent	   = DodgePercent,
                         crit_percent	   = CritPercent,
                         anti_crit_percent = AntiCritPercent
                        } = BaseGoods) ->
    %?DEBUG("Id : ~p, BaseGoods Attack : ~p~n",[BaseGoods#base_goods.id, Attack]),
    #attribute{hp_lim      = HpLim,
               mana_lim    = ManaLim,
               mana_rec    = ManaRec,
               attack      = Attack,
               def         = Def,
               hit         = Hit,
               dodge       = Dodge,
               crit        = Crit,
               anti_crit   = AntiCrit,
               stiff       = Stiff,
               anti_stiff  = AntiStiff,
               attack_speed = AttackSpeed,
               move_speed  = MoveSpeed,
               hp_lim_percent    = HpLimPercent,
               attack_percent	 = AttackPercent,
               def_percent       = DefPercent,
               hit_percent	     = HitPercent,
               dodge_percent	 = DodgePercent,
               crit_percent	     = CritPercent,
               anti_crit_percent = AntiCritPercent
              };
to_attribute(#goods{base_id        = GoodsId,
                    str_lv         = StrengthLv,          %%强化等级
                    star_lv        = StarLv,
                    hp             = HpLim,
                    mana_lim       = ManaLim,
                    mana_lim_ext   = ManaLimExt,
                    mana_rec       = ManaRec,
                    mana_rec_ext   = ManaRecExt,
                    hp_ext         = HpLimExt,         %%额外属性
                    attack         = Attack,
                    attack_ext     = AttackExt, 
                    def            = Def,
                    def_ext        = DefExt,
                    hit            = Hit,
                    hit_ext        = HitExt,
                    dodge          = Dodge,          %%闪避
                    dodge_ext      = DodgeExt,
                    crit           = Crit,
                    crit_ext       = CritExt,
                    anti_crit      = AntiCrit,
                    anti_crit_ext  = AntiCritExt,
                    stiff          = Stiff,         %%僵直
                    anti_stiff     = AntiStiff,
                    attack_speed   = AttackSpeed,
                    move_speed     = MoveSpeed,
                    jewels         = Jewels
                   } = Goods) ->
    %?DEBUG("to_attri Goods.base_id : ~p~n",[Goods#goods.base_id]),
    BaseAttri = #attribute{hp_lim      = HpLim,
                           mana_lim    = ManaLim,
                           mana_rec    = ManaRec,
                           attack      = Attack,
                           def         = Def,
                           hit         = Hit,
                           dodge       = Dodge,
                           crit        = Crit,
                           anti_crit   = AntiCrit,
                           stiff       = Stiff,
                           anti_stiff  = AntiStiff,
                           attack_speed = AttackSpeed,
                           move_speed  = MoveSpeed
                          },    
    PercentAttri = case data_base_goods:get(GoodsId) of
                       [] ->
                           #attribute{};
                       #base_goods{
                         } = PercentBaseGoods ->
                           to_percent_attribute(PercentBaseGoods)
                   end,
    print_base_attri(PercentAttri),
    StrengthAttri = case data_base_goods:get(GoodsId) of
                        [] ->
                            #attribute{};
                        #base_goods{
                           strengthen_id = StrengthenId
                          } ->
                            case data_base_goods_strengthen:get(StrengthenId * 1000 + StrengthLv)of
                                [] ->
                                    #attribute{};
                                #base_goods_strengthen{
                                   value = StrengthenValue
                                  } ->
                                    by(BaseAttri, StrengthenValue/100000)
                            end
                    end,
    %print_base_attri(StrengthAttri),
    StarAttri = case data_base_goods:get(GoodsId) of
                    [] ->
                        #attribute{};
                    #base_goods{
                       star_id = StarId
                      } ->
                        case data_base_goods_strengthen:get(StarId * 1000 + StarLv)of
                            [] ->
                                #attribute{};
                            #base_goods_strengthen{
                               value = StarValue
                              } ->
                                by(BaseAttri, StarValue/100000)
                        end
                end,
    %print_base_attri(StarAttri),
    JewelList = tuple_to_list(Jewels),
    JewelsAttri = lists:foldl(fun(JewelId, RetAttri) when JewelId > 0 ->
                                      case data_base_goods:get(JewelId) of
                                          [] ->
                                              RetAttri;
                                          BaseGoods ->
                                              add(RetAttri, to_attribute(BaseGoods))
                                      end;
                                 (_, RetAttri) ->
                                      RetAttri
                              end, #attribute{}, JewelList),
                                                %print_base_attri(JewelsAttri),
    ExtAttri = #attribute{hp_lim      = HpLimExt,
                          mana_lim    = ManaLimExt,
                          mana_rec    = ManaRecExt,
                          attack      = AttackExt,
                          def         = DefExt,
                          hit         = HitExt,
                          dodge       = DodgeExt,
                          crit        = CritExt,
                          anti_crit   = AntiCritExt
                         },
    add(
      add(
        add(
          add(
            add(BaseAttri, StrengthAttri), 
            StarAttri), 
          JewelsAttri), 
        ExtAttri), 
      PercentAttri);
to_attribute(#player_skill{skill_id = SkillId, lv = Lv}) ->
    Empty = #attribute{},
    case data_base_combat_skill:get(SkillId) of
        [] ->
            Empty;
        #base_combat_skill{
           upgrade_id = UpgradeId
          } ->
            case data_base_combat_skill_upgrade:get(UpgradeId + Lv) of
                [] ->
                    Empty;
                #base_combat_skill_upgrade{
                   add_attr = AddAttri
                  }->
                    lists:foldl(fun(Attri, RetAttri) ->
                                        add(RetAttri, to_attribute(Attri))
                                end, Empty, AddAttri)
            end
    end;
to_attribute(#player_skill_record{skill_record_list = SkillRecordList}) ->
    Empty = #attribute{},
    lists:foldl(fun({_SubType, SkillCardId}, RetAttri) ->
                        case data_base_skill_card:get(SkillCardId) of
                            [] ->
                                RetAttri;
                            #base_skill_card{
                               attribute = AddAttri
                              } ->
                                lists:foldl(fun(Attri, AddRetAttri) ->
                                                    add(AddRetAttri, to_attribute(Attri))
                                            end, RetAttri, AddAttri)
                        end
                end, Empty, SkillRecordList);
to_attribute({?HP_LIMIT, Value}) ->
    #attribute{hp_lim = Value};
to_attribute({?ATTACK, Value}) ->
    #attribute{attack = Value};
to_attribute({?DEF, Value}) ->
    #attribute{def = Value};
to_attribute({?HIT, Value}) ->
    #attribute{hit = Value};
to_attribute({?DODGE, Value}) ->
    #attribute{dodge = Value};
to_attribute({?CRIT, Value}) ->
    #attribute{crit = Value};
to_attribute({?ANTI_CRIT, Value}) ->
    #attribute{anti_crit = Value};
to_attribute({?MANA_REC, Value}) ->
    #attribute{mana_rec = Value};
to_attribute(Other) ->
    ?WARNING_MSG("Unknown way to attribute... : ~p~n",[Other]),
    #attribute{}.


%% 只取BASE GOODS的 percent 属性
to_percent_attribute(#base_goods{hp_lim_percent    = HpLimPercent,
                                 attack_percent	   = AttackPercent,
                                 def_percent       = DefPercent,
                                 hit_percent	   = HitPercent,
                                 dodge_percent	   = DodgePercent,
                                 crit_percent	   = CritPercent,
                                 anti_crit_percent = AntiCritPercent
                                } = _BaseGoods) ->
    #attribute{hp_lim_percent    = HpLimPercent,
               attack_percent	 = AttackPercent,
               def_percent       = DefPercent,
               hit_percent	     = HitPercent,
               dodge_percent	 = DodgePercent,
               crit_percent	     = CritPercent,
               anti_crit_percent = AntiCritPercent
              };
to_percent_attribute(_) ->
    #attribute{}.

%%
%% Attri 相加 A + B
%%
add(AttriA, AttriB) ->
    AttriA#attribute{hp_lim             = AttriA#attribute.hp_lim + AttriB#attribute.hp_lim,
                     hp_cur             = AttriA#attribute.hp_cur + AttriB#attribute.hp_cur,
                     mana_lim           = AttriA#attribute.mana_lim + AttriB#attribute.mana_lim,
                     mana_cur           = AttriA#attribute.mana_cur + AttriB#attribute.mana_cur,
                     hp_rec             = AttriA#attribute.hp_rec + AttriB#attribute.hp_rec, 
                     mana_rec           = AttriA#attribute.mana_rec + AttriB#attribute.mana_rec,
                     attack             = AttriA#attribute.attack + AttriB#attribute.attack,
                     def                = AttriA#attribute.def + AttriB#attribute.def,
                     hit                = AttriA#attribute.hit + AttriB#attribute.hit,
                     dodge              = AttriA#attribute.dodge + AttriB#attribute.dodge,
                     crit               = AttriA#attribute.crit + AttriB#attribute.crit, 
                     anti_crit          = AttriA#attribute.anti_crit + AttriB#attribute.anti_crit,
                     stiff              = AttriA#attribute.stiff + AttriB#attribute.stiff,
                     anti_stiff         = AttriA#attribute.anti_stiff + AttriB#attribute.anti_stiff,
                     attack_speed       = AttriA#attribute.attack_speed + AttriB#attribute.attack_speed,
                     move_speed         = AttriA#attribute.move_speed + AttriB#attribute.move_speed,
                     attack_effect      = AttriA#attribute.attack_effect + AttriB#attribute.attack_effect,
                     def_effect         = AttriA#attribute.def_effect + AttriB#attribute.def_effect,
                     hp_lim_percent     = AttriA#attribute.hp_lim_percent + AttriB#attribute.hp_lim_percent,
                     attack_percent	    = AttriA#attribute.attack_percent + AttriB#attribute.attack_percent,
                     def_percent        = AttriA#attribute.def_percent + AttriB#attribute.def_percent,
                     hit_percent	    = AttriA#attribute.hit_percent + AttriB#attribute.hit_percent,
                     dodge_percent	    = AttriA#attribute.dodge_percent + AttriB#attribute.dodge_percent,
                     crit_percent	    = AttriA#attribute.crit_percent + AttriB#attribute.crit_percent,
                     anti_crit_percent  = AttriA#attribute.anti_crit_percent + AttriB#attribute.anti_crit_percent
                    }.
%%
%% Attri 乘以系数
%% 
by(Attri,  N) ->
    #attribute{hp_lim             = Attri#attribute.hp_lim * N,
               hp_cur             = Attri#attribute.hp_cur * N,
               mana_lim           = Attri#attribute.mana_lim * N,
               mana_cur           = Attri#attribute.mana_cur * N,
               hp_rec             = Attri#attribute.hp_rec * N, 
               mana_rec           = Attri#attribute.mana_rec * N,
               attack             = Attri#attribute.attack * N,
               def                = Attri#attribute.def * N,
               hit                = Attri#attribute.hit * N,
               dodge              = Attri#attribute.dodge * N,
               crit               = Attri#attribute.crit * N, 
               anti_crit          = Attri#attribute.anti_crit * N,
               stiff              = Attri#attribute.stiff * N,
               anti_stiff         = Attri#attribute.anti_stiff * N,
               attack_speed       = Attri#attribute.attack_speed * N,
               move_speed         = Attri#attribute.move_speed * N,
               attack_effect      = Attri#attribute.attack_effect * N,
               def_effect         = Attri#attribute.def_effect * N
              }.

%% 计算百分比
percent(Attri, PercentAttri)->
    #attribute{hp_lim = Attri#attribute.hp_lim * (PercentAttri#attribute.hp_lim_percent / 1000),
               attack = Attri#attribute.attack * (PercentAttri#attribute.attack_percent  / 1000),
               def    = Attri#attribute.def * (PercentAttri#attribute.def_percent / 1000),
               hit    = Attri#attribute.hit * (PercentAttri#attribute.hit_percent / 1000),
               dodge  = Attri#attribute.hp_lim * (PercentAttri#attribute.dodge_percent / 1000),
               crit   = Attri#attribute.crit * (PercentAttri#attribute.crit_percent / 1000),
               anti_crit = Attri#attribute.anti_crit * (PercentAttri#attribute.anti_crit_percent / 1000)
              }.

ceil(Attri) ->
    Attri#attribute{hp_lim             = hmisc:ceil(Attri#attribute.hp_lim),
                    hp_cur             = hmisc:ceil(Attri#attribute.hp_cur),
                    mana_lim           = hmisc:ceil(Attri#attribute.mana_lim),
                    mana_cur           = hmisc:ceil(Attri#attribute.mana_cur),
                    hp_rec             = hmisc:ceil(Attri#attribute.hp_rec),
                    mana_rec           = hmisc:ceil(Attri#attribute.mana_rec),
                    attack             = hmisc:ceil(Attri#attribute.attack),
                    def                = hmisc:ceil(Attri#attribute.def),
                    hit                = hmisc:ceil(Attri#attribute.hit),
                    dodge              = hmisc:ceil(Attri#attribute.dodge),
                    crit               = hmisc:ceil(Attri#attribute.crit),
                    anti_crit          = hmisc:ceil(Attri#attribute.anti_crit),
                    stiff              = hmisc:ceil(Attri#attribute.stiff),
                    anti_stiff         = hmisc:ceil(Attri#attribute.anti_stiff),
                    attack_speed       = hmisc:ceil(Attri#attribute.attack_speed),
                    move_speed         = hmisc:ceil(Attri#attribute.move_speed),
                    attack_effect      = hmisc:ceil(Attri#attribute.attack_effect),
                    def_effect         = hmisc:ceil(Attri#attribute.def_effect)
                   }.

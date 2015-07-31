%% @File  pt_55.erl
%% 战斗协议
%% @arno
%%

-module(pt_55).

%% -export([write/2]).

%% -include("define_logger.hrl").
%% -include("define_combat.hrl").
%% -include("define_reward.hrl").
%% -include("pb_55_pb.hrl").

%% %% @doc 返回战报
%% write(55001, [Report])->
%%     PBReport = build_combat_report(Report),
%%     pt:pack(55001, PBReport);
%% write(55001, _) ->
%%     pt:pack(55001, null);
%% write(55002, null) ->
%%     pt:pack(55002, null);
%% write(55003, null) ->
%%     pt:pack(55003, null);
%% write(Cmd, _R) ->
%%     ?WARNING_MSG("pt write error Cmd ~p, Reason ~p~n", [Cmd, _R]),
%%     pt:pack(0, <<>>).

%% build_combat_report(Report) when is_record(Report,combat_report) ->
%%     %% ?COMBAT_OUT("~n~n~n~n~n~w~n~n~n~n~n",[Report]),
%%     #pbcombatreport{
%%        report_id           = Report#combat_report.report_id,
%%        result              = Report#combat_report.result,
%%        final               = Report#combat_report.final,
%%        result_lv           = Report#combat_report.result_lv,
%%        copy_id             = Report#combat_report.copy_id,
%%        version             = Report#combat_report.version,
%%        can_skip            = Report#combat_report.can_skip,
%%        attacker_id         = Report#combat_report.attacker_id,
%%        attacker_unique_id  = Report#combat_report.attacker_unique_id,
%%        attacker_camp_id    = Report#combat_report.attacker_camp_id,
%%        attacker_list       = build_combat_member(Report#combat_report.attacker_member),
%%        attacker_dead       = Report#combat_report.attacker_dead,
%%        defender_id         = Report#combat_report.defender_id,
%%        defender_unique_id  = Report#combat_report.defender_unique_id,
%%        defender_camp_id    = Report#combat_report.defender_camp_id,
%%        defender_list       = build_combat_member(Report#combat_report.defender_member),
%%        defender_dead       = Report#combat_report.defender_dead,
%%        prepare_effect      = build_combat_prepare(Report#combat_report.prepare),
%%        report_list         = build_combat_round_report(Report#combat_report.process),
%%        active_skill_list   = Report#combat_report.active_skill_list,
%%        passive_skill_list  = Report#combat_report.passive_skill_list          
%%       }.

%% build_combat_buff(Buff) 
%%   when is_record(Buff, base_combat_buff) ->
%%     %% ?COMBAT_OUT("Buff Packing>>>~w~n",[Buff]),
%%     #pbcombatbuff{
%%        %% id             = Buff#base_combat_buff.id,
%%        %% buff_id        = Buff#base_combat_buff.buff_id,
%%        %% buff_type      = Buff#base_combat_buff.buff_type,
%%        %% continue_value = Buff#base_combat_buff.continue_value,   
%%        %% op_type        = Buff#base_combat_buff.op_type
%%       };    
%% build_combat_buff(BuffList) when is_list(BuffList) ->
%%     lists:map(fun(Buff) ->
%%                       build_combat_buff(Buff)
%%               end,BuffList).

%% build_combat_member(Member) when is_record(Member,combat_member) -> 
%%     %% ?COMBAT_OUT("Member Packing {hp,hp_lim,mp}>>>~w~n",[{Member#combat_member.hp, Member#combat_member.hp_lim, Member#combat_member.mp}]),
%%     ?COMBAT_OUT(" career : >>>~w~n",[Member#combat_member.career]),
%%     #pbcombatfighter{
%%        unique_id             = Member#combat_member.unique_id,
%%        id                    = Member#combat_member.id,
%%        name                  = hmisc:to_binary(Member#combat_member.name),
%%        lv                    = Member#combat_member.lv,
%%        pos                   = Member#combat_member.pos,
%%        hp_lim                = Member#combat_member.hp_lim,
%%        hp                    = Member#combat_member.hp,
%%        mp                    = Member#combat_member.mp,
%%        stunt_skill_id        = Member#combat_member.stunt_skill_id,
%%        stunt_skill_ids       = Member#combat_member.stunt_skill_ids,
%%        normal_skill_id       = Member#combat_member.normal_skill_id,
%%        passive_skill_ids     = Member#combat_member.passive_skill_ids,
%%        resource_id           = Member#combat_member.resource_id,
%%        fighter_type          = get_fighter_type(Member#combat_member.fighter_type),
%%        career_id             = Member#combat_member.career_id,
%%        career                = Member#combat_member.career,
%%        attacker_resource_id  = Member#combat_member.attacker_resource_id,
%%        deffender_resource_id = Member#combat_member.defender_resource_id,
%%        buffs                 = build_combat_buff(Member#combat_member.buff_list)
%%       };          
%% build_combat_member(MemberList) when is_list(MemberList) ->     
%%     %% ?COMBAT_OUT("MemberList Packing>>>~w~n",[MemberList]),
%%     lists:map(fun(Member) ->
%%                       build_combat_member(Member)
%%               end,MemberList).

%% %% @doc 客户端暂不支持世界BOSS类型
%% get_fighter_type(Type) ->
%%     if
%%         Type =:= ?FIGHTER_TYPE_WORLD_BOSS-> 
%%             ?FIGHTER_TYPE_MONSTER;
%%         true -> 
%%             Type
%%     end.


%% build_combat_effect(EffectPoint,Effect) when is_record(Effect,effect_res) ->
%%     %% if
%%     %%    EffectPoint =:= ?SG_EFFECT_AFTER_DEF -> 
%%     %%         ?COMBAT_OUT("Effect Packing>>>~w~n",[Effect#effect_res.hurt_attri]);
%%     %%     true -> 
%%     %%         ok
%%     %% end,

    


%%     #pbcombateffect{
%%        atk_pos           = Effect#effect_res.atk_pos,
%%        atk_player_id     = Effect#effect_res.atk_id,
%%        def_pos           = Effect#effect_res.def_pos,
%%        def_player_id     = Effect#effect_res.def_id,
%%        effect_point      = Effect#effect_res.effect_point,
%%        effect_type       = Effect#effect_res.effect_type,
%%        passive_skill_id  = Effect#effect_res.passive_skill_id,
%%        hurt_list         = build_combat_hurt_attri(EffectPoint,Effect#effect_res.hurt_attri)
%%       };
%% build_combat_effect(EffectPoint,EffectList) when is_list(EffectList) ->
%%     %% if
%%     %%     EffectPoint =:= ?SG_EXT_EFFECT_ATK ->
%%     %%         ?COMBAT_OUT("fill_report_effect : ~w ~n",[EffectList]);
%%     %%     true -> 
%%     %%         skip
%%     %% end,
%%     lists:map(fun(Effect) ->                      
%%                       build_combat_effect(EffectPoint,Effect)
%%               end,EffectList).

%% %% build_combat_target({MasterTarget,SlaveTarget}) ->
%% %%     lists:map(fun(M) ->
%% %%                       #pbcombattarget{
%% %%                          target_type = ?TARGET_TYPE_MASTER,
%% %%                          pos        = M#combat_role.pos,                       
%% %%                          id         = M#combat_role.fighter_uid
%% %%                         }                      
%% %%               end,MasterTarget)
%% %%         ++
%% %%         lists:map(fun(S) ->
%% %%                           #pbcombattarget{
%% %%                              target_type = ?TARGET_TYPE_SLAVE,
%% %%                              pos        = S#combat_role.pos,   
%% %%                              id         = S#combat_role.fighter_uid
%% %%                             }
%% %%                   end,SlaveTarget).

%% build_combat_target_master({MasterTarget,_SlaveTarget}) ->
%%     lists:map(fun(M) ->
%%                       #pbcombattarget{
%%                          target_type = ?TARGET_TYPE_MASTER,
%%                          pos        = M#combat_role.pos,                       
%%                          id         = M#combat_role.fighter_uid
%%                         }                      
%%               end,MasterTarget).

%% build_combat_target_slave({_MasterTarget,SlaveTarget}) ->    
%%     lists:map(fun(S) ->
%%                       #pbcombattarget{
%%                          target_type = ?TARGET_TYPE_SLAVE,
%%                          pos        = S#combat_role.pos,   
%%                          id         = S#combat_role.fighter_uid
%%                         }
%%               end,SlaveTarget).

%% build_combat_hurt_attri(EffectPoint,HurtAttri) when is_record(HurtAttri,fight_attri_struct) ->
%%     %% ?COMBAT_OUT("CombatHurt Packing>>>Point:~w >>> ~w~n",[EffectPoint,HurtAttri]),
%%     #fight_attri_struct{
%%        flag_death  = FlagDeath,
%%        flag_frozen = FlagFrozen,
%%        flag_swim   = FlagSwin,
%%        flag_meta   = FlagMeta,
%%        flag_meta_rate = FlagMetaRate,
%%        flag_meta_active   = FlagMetaActive,
%%        flag_hit_cnt = HitCnt,
%%        flag_miss   = FlagMiss,
%%        flag_beheaded = FlagBeheaded,
%%        flag_fatal    = FlagFatatl,
%%        flag_parry    = FlagParry,
%%        flag_crit     = FlagCrit,
%%        flag_hide     = FlagHide,
%%        flag_unyielding = FlagUnyielding,
%%        flag_absorb   = FlagAbsorb,
%%        flag_absorb_sub = FlagAbsorbSub,
%%        buffs       = BUFFs
%%       } = HurtAttri,
%%     %% ?COMBAT_OUT("FlagHide : ~w~n",[FlagHide]),
%%     %% <<Flag:32>> = <<FlagDeath:1,FlagFrozen:1,FlagSwin:1,0:29>>,
%%     case EffectPoint of
%%         %% Point when Point =:=?SG_EFFECT_BEFORE_DEF 
%%         %%            orelse Point =:= ?SG_EFFECT_BEFORE_ATK
%%         %%            orelse Point =:= ?SG_EFFECT_ROUND_BEGIN ->
%%         %%     #pbcombathurtattri{
%%         %%        flag_death     = FlagDeath,
%%         %%        hp             = HurtAttri?FINAL_ATTRI_CUR_HP,
%%         %%        mp             = HurtAttri?FINAL_ATTRI_CUR_MP,
%%         %%        buffs          = build_combat_buff(BUFFs)
%%         %%       };
%%         _Other ->
%%             NewFlagMeta = if
%%                           FlagMeta =:= -1 -> 
%%                               FlagMeta;
%%                           FlagMetaActive =:= -1 -> 
%%                               FlagMetaActive;
%%                           true -> 
%%                               0
%%                       end,
%%             #pbcombathurtattri{
%%                hp             = HurtAttri?FINAL_ATTRI_CUR_HP,
%%                hp_lim         = HurtAttri?FINAL_ATTRI_HP_LIM,
%%                mp             = HurtAttri?FINAL_ATTRI_CUR_MP,
%%                flag_death     = FlagDeath,
%%                flag_frozen    = FlagFrozen,
%%                flag_swim      = FlagSwin,
%%                flag_meta      = NewFlagMeta,
%%                flag_meta_rate = FlagMetaRate,
%%                flag_miss      = FlagMiss,
%%                flag_beheaded  = FlagBeheaded,
%%                flag_fatal     = FlagFatatl,
%%                flag_absorb    = FlagAbsorb,
%%                flag_absorb_sub = FlagAbsorbSub,
%%                flag_parry     = FlagParry,
%%                flag_hit_cnt   = HitCnt,
%%                hit_cnt        = HitCnt,
%%                flag_crit      = FlagCrit,
%%                flag_hide      = FlagHide,
%%                flag_unyiedlding = FlagUnyielding,
%%                buffs = build_combat_buff(BUFFs)
%%               }
%%         end;  
%% build_combat_hurt_attri(EffectPoint,HurtAttriList) when is_list(HurtAttriList) ->
%%     lists:map(fun(HurtAttri) ->
%%                       build_combat_hurt_attri(EffectPoint,HurtAttri)
%%               end,HurtAttriList).

%% build_combat_round_report(Round) when is_record(Round,round_report) ->
%%     #pbcombatround{
%%        unique_id        = Round#round_report.unique_id,
%%        id               = Round#round_report.id,
%%        pos              = Round#round_report.pos,
%%        atk_type         = Round#round_report.atk_type,
%%        export_type      = Round#round_report.export_type,
%%        attacker_id      = Round#round_report.attacker_id,
%%        attack_skill     = Round#round_report.attack_skill,
%%        master_targets   = build_combat_target_master(Round#round_report.attack_targets),
%%        slave_targets    = build_combat_target_slave(Round#round_report.attack_targets),
%%        round_begin      = build_combat_effect(?SG_EFFECT_ROUND_BEGIN,   Round#round_report.round_begin),
%%        before_atk       = build_combat_effect(?SG_EFFECT_BEFORE_ATK,    Round#round_report.before_atk),
%%        before_def       = build_combat_effect(?SG_EFFECT_BEFORE_DEF,    Round#round_report.before_def),
%%        hurt             = build_combat_effect(?SG_EFFECT_SKILL_ATKING,  Round#round_report.hurt),
%%        all_buffs        = build_combat_effect(?SG_EFFECT_ALL_BUFFS,     Round#round_report.all_buffs),
%%        at_atking        = build_combat_effect(?SG_EFFECT_AT_ATKING,     Round#round_report.at_atking),
%%        at_defing        = build_combat_effect(?SG_EFFECT_AT_DEFING,     Round#round_report.at_defing),
%%        after_def        = build_combat_effect(?SG_EFFECT_AFTER_DEF,     Round#round_report.after_def),
%%        after_atk        = build_combat_effect(?SG_EFFECT_AFTER_ATK,     Round#round_report.after_atk),
%%        ext_hurt         = build_combat_effect(?SG_EXT_EFFECT_ATK,       Round#round_report.ext_hurt),
%%        round_end        = build_combat_effect(?SG_EFFECT_ROUND_END,     Round#round_report.round_end)
%%       };
%% build_combat_round_report(RoundList) when is_list(RoundList) ->
%%     lists:map(fun(Round) ->
%%                       build_combat_round_report(Round)
%%               end,RoundList).

%% build_reward_item(RewardItemList) when is_list(RewardItemList) ->
%%     lists:map(fun(RewardItem) ->
%%                       #pbrewarditem{
%%                          id          = RewardItem#reward_item.id,
%%                          goods_id    = RewardItem#reward_item.goods_id,
%%                          num         = RewardItem#reward_item.num
%%                         }
%%               end,RewardItemList);
%% build_reward_item(_) ->
%%     [].

%% build_combat_prepare(PrepareEffectList) 
%%   when is_list(PrepareEffectList) ->
%%    %% ?DEBUG("PrepareEffectList : ~w ~n",[PrepareEffectList]),
%%     build_combat_effect(?SG_EFFECT_COMBAT_BEGIN, PrepareEffectList);
%% build_combat_prepare(_) ->
%%     [].

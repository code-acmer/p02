-ifndef(DEFINE_COMBAT_HRL).
-define(DEFINE_COMBAT_HRL, true).

%% ================START OLD DEFINE==========================
%% -include("db_base_combat_skill.hrl").
%% -include("db_base_combat_skill_passive.hrl").
%% -include("db_base_combat_buff.hrl").
%% -include("define_player.hrl").

%% %%
%% %%File : define_combat
%% %%战斗相关头文件定义
%% %%
%% -define(ETS_COMBAT_SKILL, rec_combat_skill).
%% -define(ETS_COMBAT_SKILL_PASSIVE, rec_combat_skill_passive).
%% -define(ETS_PLAYER_COMBAT_ATTRI, rec_player_combat_attri).
%% -define(ETS_PLAYER_COMBAT_ATTRIBUTE_EX, ets_player_combat_attribute_ex).

%% -define(ETS_COMBAT_INFO, ets_combat_info).

%% %% 行动延时
%% -record(action, {pid          = undefined,  %% 战斗单位进程
%%                  delay        = 0,          %% 标准延时
%%                  loss_time    = 0           %% 已流逝时间
%%                 }).

%% -record(rec_ext_effect,{type,				%%附加效果类型
%%                                             %% 1   - buff
%%                                             %% 2   - disbuff
%%                                             %% 3   - 回复类型
%%                                             %% 4   - 特殊伤害
%%                                             %% 5   - 常规攻击
                                           
%%                         target,			%%目标选择方式{_,_,_}
%%                         buff_list,      %% [{rate,buff_id},....]
%%                         value1,		    %%其它值1
%%                         value2,		    %%其它值2
%%                         value3,		    %%
%%                         value4,		    %%
%%                         value5,		    %%
%%                         ext_info        %%附加信息text
%%                        }).

%% -define(EXT_EFFECT_TYPE_BUFF,             1).            %% 加BUFF
%% -define(EXT_EFFECT_TYPE_DISBUFF,          2).            %% 驱散BUFF
%% -define(EXT_EFFECT_TYPE_RECOVER,          3).            %% 回复/特殊伤害
%% -define(EXT_EFFECT_TYPE_STRIKE_BACK,      4).            %% 反击
%% -define(EXT_EFFECT_TYPE_PURSIE_ATTACK,    5).            %% 追击
%% -define(EXT_EFFECT_TYPE_REBORN,           6).            %% 重生
%% -define(EXT_EFFECT_TYPE_ABSORB,           7).            %% 吸收
%% -define(EXT_EFFECT_TYPE_META,             8).            %% 幻化
%% -define(EXT_EFFECT_TYPE_UNYIELDING,       9).            %% 不屈
%% -define(EXT_EFFECT_TYPE_VAMPIRE,         10).            %% 吸血
%% -define(EXT_EFFECT_TYPE_REAP,            11).            %% 收割
%% -define(EXT_EFFECT_TYPE_PUNCTURE,        12).            %% 穿刺
%% -define(EXT_EFFECT_TYPE_DOUBLE_HIT,      13).            %% 连击
%% -define(EXT_EFFECT_TYPE_INSIGHT,         14).            %% 洞察
%% -define(EXT_EFFECT_TYPE_FATAL,           15).            %% 致命
%% -define(EXT_EFFECT_TYPE_FIRM,            16).            %% 刚烈
%% -define(EXT_EFFECT_TYPE_BACK_TO_BITE,    17).            %% 反噬
%% -define(EXT_EFFECT_TYPE_STRENGTHEN,      18).            %% 强化
%% -define(EXT_EFFECT_TYPE_SHIFT,           19).            %% 转移
%% -define(EXT_EFFECT_TYPE_CALL_MONSTER,    20).            %% 召唤怪物
%% -define(EXT_EFFECT_TYPE_WEAKEN,          21).            %% 弱化
%% -define(EXT_EFFECT_TYPE_REBOUND,         22).            %% 反弹
%% -define(EXT_EFFECT_TYPE_ATTRI,           100).           %% 属性检测触发点
%% -define(PROPERTY_COMBAT_BEGIN_BUFF,      1001).          %% 特性战斗开始附加BUFF

%% %%攻击类型区分 attack_type
%% -define(SG_ATK_TYPE_COMMON, 1).     %%普通攻击
%% -define(SG_ATK_TYPE_SKILL,  2).     %%技能攻击

%% %% 攻击方式宏定义 export_type
%% %% 2012.11.15 新增角色战斗中攻击方式的宏定义 by zhangr
%% -define(SG_MELEE_ATTACK,          1).     %% 近身攻击
%% -define(SG_RANGE_ATTACK,          2).     %% 远程物理攻击
%% -define(SG_MAGIC_ATTACK,          3).     %% 法术攻击
%% -define(SG_CURE_MELEE_ATTACK,     4).     %% 治愈术 -近战  不会触发任何闪避
%% -define(SG_CURE_RAGE_ATTACK,      5).     %% 治愈术 -远程  不会触发任何闪避

%% %%
%% -define(TARGET_TYPE_MASTER, 1).
%% -define(TARGET_TYPE_SLAVE,  2).

%% %% 伤害类型
%% -define(SG_HURT_TYPE_SKILL,     1).
%% -define(SG_HURT_TYPE_BUFFER,    2).
%% -define(SG_HURT_TYPE_SKILL_EXT, 3).

%% %% EFFECT TIME
%% -define(COMBAT_SCENE_DELTA,     10000).
%% -define(SG_EFFECT_ROUND_BEGIN,      1).
%% -define(SG_EFFECT_BEFORE_ATK,       2).     %% 攻击前触发    -ATK
%% -define(SG_EFFECT_BEFORE_DEF,       3).     %% 被攻击前触发  -DEF
%% -define(SG_EFFECT_SKILL_ATKING,     4).     %% 技能伤害计算
%% -define(SG_EFFECT_ATTACK,           5).     %% 攻击
%% -define(SG_EFFECT_AT_ATKING,        6).     %% 攻击中触发
%% -define(SG_EFFECT_AT_DEFING,        7).     %% 被攻击中触发
%% -define(SG_EFFECT_AFTER_DEF,        8).     %% 被攻击后触发
%% -define(SG_EFFECT_AFTER_ATK,        9).     %% 攻击后触发
%% -define(SG_EFFECT_POST_DEF,        10).     %% 攻击后触发
%% -define(SG_EFFECT_POST_ATK,        11).     %% 攻击后触发
%% -define(SG_EFFECT_ROUND_END,       12).       
%% -define(SG_EXT_EFFECT_ATK,         13).     %% 额外技能效果 
%% -define(SG_EFFECT_ALL_BUFFS,       14).     
%% -define(SG_EFFECT_COMBAT_BEGIN,    15).     %% 战斗开始时

%% %%combat 战斗相关

%% -define(DEFAULT_ATK_TYPE,?SG_MELEE_ATTACK).      %%默认攻击方式
%% -define(DEFAULT_SELECT_TYPE,0).                  %%默认选择目标方式
%% -define(SG_SELECT_TYPE_0,0).                  %%默认选择目标方式
%% -define(SG_SELECT_TYPE_1,1).                  %%默认选择目标方式

%% %%战斗位置相关
%% -define(MAX_ATK_POS,10).


%% -define(ATK_POS_SHIFT,100).
%% -define(DEF_POS_SHIFT,200).
%% -define(KEEPER_POS,20).

%% %% -record(attribute_ex,{
%% %%           cur_hp = 0,                   %% 当前生命
%% %%           hp_lim = 0,					%% 最大生命值
%% %%           cur_mp = 0,                   %% 怒气值
%% %%           init_rage = 0,                %% 初始怒气值
%% %%           dao = 0,                      %% 道行值
%% %%           force = 0,					%% 武力
%% %%           magic = 0,					%% 法术
%% %%           stunt = 0,					%% 绝技
%% %%           agile = 0,                    %% 敏捷
%% %%           mobi = 0,                     %% 行动力
%% %%           attack = 0,					%% 攻击
%% %%           def = 0,						%% 防御
%% %%           magic_attack = 0,				%% 法术攻击
%% %%           magic_def = 0,				%% 法术防御
%% %%           stunt_attack = 0,				%% 绝技攻击
%% %%           stunt_def = 0,				%% 绝技防御
%% %%           hit = 0,						%% 命中
%% %%           dodge = 0,					%% 躲闪
%% %%           crit = 0,						%% 暴击
%% %%           tenacity = 0,					%% 韧性
%% %%           wreck = 0,                    %% 破击
%% %%           parry = 0,					%% 格挡
%% %%           attack_eff = 0,               %% 攻击效果
%% %%           def_eff = 0,                  %% 防御效果
%% %%           magic_attack_eff = 0,         %% 法术攻击效果
%% %%           magic_def_eff = 0,            %% 法术防御效果
%% %%           stunt_attack_eff = 0,         %% 绝技伤害效果
%% %%           stunt_def_eff = 0,            %% 绝技防御效果
%% %%           fight_soul = 1,               %% 战魂
%% %%           power = 0						%% 战力	
%% %%          }).


%% -record(fight_attri_struct,{
%%           base_attribute   = #attribute_info{},       %%  record - attribute_ex
%%           final_attribute  = #attribute_info{},       %%  record - attribute_ex
%%           buffs            = [],                      %%  buffs [rec_combat_buff,..]
%%           flag_death       = 0,                       %%  死亡
%%           flag_hide        = 0,                       %%  隐身
%%           flag_fire        = 0,                       %%  集火标记 -- 有该标记时，先选择该目标
%%           flag_frozen      = 0,                       %%  冰冻
%%           flag_sleep       = 0,                       %%  睡眠
%%           flag_swim        = 0,                       %%  晕眩
%%           flag_coma        = 0,                       %%  晕迷 -- 假死状态，可复活
%%           flag_silence     = 0,                       %%  沉默 无法释放技能
%%           flag_chaos       = 0,                       %%  混乱状态 目标混乱
%%           flag_fatal       = 0,                       %%  一次攻击的致命标记
%%           rate_fatal       = 0,                       %%  致命比率
%%           flag_meta        = 0,                       %%  触发幻化标记
%%           flag_meta_rate   = 0,                       %%  触发率
%%           flag_meta_active = 0,                       %%  主动技能幻化标记
%%           flag_meta_active_rate = 0,                  %%  主动技能幻化触发率
%%           flag_miss        = 0,                       %%  丢失
%%           flag_dodge       = 0,                       %%  闪避
%%           flag_beheaded    = 0,                       %%  触发斩杀
%%           rate_sworkcut    = 0,                       %%  斩杀比率
%%           flag_wreck       = 0,                       %%  破击
%%           rate_wreck       = 0,                       %%  破击概率
%%           flag_crit        = 0,                       %%  触发暴击
%%           rate_crit        = 0,                       %%  暴击率
%%           flag_parry       = 0,                       %%  触发格档
%%           flag_absorb      = 0,                       %%  触发吸收
%%           flag_unyielding  = 0,                       %%  触发不屈
%%           flag_unyielding_rate  = 0,                  %%  触发不屈
%%           flag_rebound     = 0,                       %%  触发反弹
%%           flag_shift       = 0,                       %%  触发转移
%%           flag_absorb_sub  = 0,                       %%  吸收的伤害值 -- 给客户端表现
%%           flag_vampire     = 0,                       %%  触发吸血
%%           flag_strengthen  = 0,                       %%  触发强化
%%           flag_weaken      = 0,                       %%  触发弱化
%%           flag_back_to_bite = 0,                      %%  触发反噬
%%           flag_firm        = 0,                       %%  触发刚烈          
%%           %% flag_back_to_bite = 0,                      %%  触发反噬
%%           flag_hit_cnt     = 0                        %%  连击数
%%          }).



%% -define(FIGHTER_TYPE_UNKNOWN,    0).
%% -define(FIGHTER_TYPE_PLAYER,     1).      %% 玩家
%% -define(FIGHTER_TYPE_PARTNER,    2).      %% 伙伴
%% -define(FIGHTER_TYPE_BOSS,       3).      %% BOSS
%% -define(FIGHTER_TYPE_WORLD_BOSS, 4).      %% 大BOSS
%% -define(FIGHTER_TYPE_ELITE,      5).      %% 精英
%% -define(FIGHTER_TYPE_MONSTER,    6).      %% 普通怪
%% -define(FIGHTER_TYPE_SOUTHERN,   7).      %% 南蛮入侵怪物类型
%% -define(FIGHTER_TYPE_BEAST,    100).      %% 灵兽

%% -record(fighter,{
%%           unique_id                              = 0,                        %% 
%%           key                                    = 0,                        %% beast uid, partner uid 自增ID， playerid
%%           type                                   = ?FIGHTER_TYPE_UNKNOWN,    %% 战斗单位类型
%%           player_id                              = 0,                        %% 玩家ID
%%           id                                     = 0,                        %% partner_id | beast_id
%%           gender                                 = 0,                        %% 玩家性别
%%           fsm_pid                                = undefined,                %% fsm 进程ID
%%           field_pid                              = undefined,                %% combat_feild的PID
%%           self_pid                               = undefined,                %% 战斗单位状态机 PID
%%           career_id                              = 0,                        %% 职业
%%           pos                                    = 0,                        %% 站位
%%           name                                   = undefined,                        %% 昵称
%%           step                                   = 0,                        %% 阶
%%           lv                                     = 0,                        %% 等级          
%%           five_elements                          = 0,                        %% 五行
%%           star_power                             = 0,                        %% 星力等级
%%           resource_id                            = 0,                        %% 资源                    
%%           fight_attri                            = #fight_attri_struct{},    %% 战斗属性
%%           stunt_skill_id                         = 0,                        %% 绝技技能
%%           stunt_skill_ids                        = [],                       %% 绝技技能列表
%%           normal_skill_id                        = 0,                        %% 普通攻击技能
%%           passive_skill_ids                      = [],                       %% 被动技能
%%           parm0                                  = undefined,                %% 灵兽当前使用的第几纸技
%%           parm1                                  = undefined,                
%%           parm2                                  = undefined,
%%           parm3                                  = undefined,
%%           parm4                                  = undefined,
%%           parm5                                  = undefined,
%%           parm6                                  = undefined,
%%           parm7                                  = undefined,
%%           parm8                                  = undefined,
%%           parm9                                  = undefined
%%          }).

%% %% %%战斗中的宠物信息
%% %% -record(combat_pet,{
%% %%           have_pet = 0,                                                      %%0表示没有 1表示有
%% %%           pet_id = 0,                                                        %%宠物ID
%% %%           pet_lv = 0,
%% %%           pet_name = 0,                                                      %%宠物名字
%% %%           pet_quality = 0,                                                   %%宠物品质(质品值 0灰色1绿色2蓝色3紫色4橙色) 用于宠物名字的显示
%% %%           pet_skill_id,
%% %%           pet_skill_name,                                                    %%宠物名字
%% %%           pet_battle_attribute,	                                             %%宠物战斗属性
%% %%           key                                    = 0,                        %%唯一KEY
%% %%           type                                   = ?FIGHTER_TYPE_UNKNOWN,    %%战斗单位类型
%% %%           id                                     = 0,                        %%玩家ID
%% %%           field_pid                              = undefined,                %% combat_feild的PID
%% %%           self_pid                               = undefined,                %% 战斗单位状态机 PID
%% %%           career_id                              = 0,                        %%职业
%% %%           pos                                    = 0,                        %%站位
%% %%           main_id                                = 0,                        %%
%% %%           name                                   = 0,                        %%昵称
%% %%           lv                                     = 0,                        %%等级
%% %%           unique_id                              = 0,                        %%
%% %%           main_unique_id                         = 0,                        %%
%% %%           five_elements                          = 0,                        %%五行
%% %%           resource_id                            = 0,                        %%资源                    
%% %%           fight_attri                            = #fight_attri_struct{},    %% 战斗属性
%% %%           attack_type                            = ?SG_RANGE_ATTACK,         %% 攻击类型
%% %%           stunt_skill                            = 0,                        %% 绝技技能
%% %%           common_skill                           = 0,                        %% 普通攻击技能
%% %%           passive_skills                         = [],                       %% 被动技能
%% %%           attack_skill                           = 0,                        %% 一次攻击使用的技能   common_skill | special_skill
%% %%           attack_target                             ,                        %% 攻击目标   目标选择方式
%% %%           export_type                            = ?SG_MELEE_ATTACK          %% 输出类型  近战|远程|谋略
%% %%          }).

%% -record(combat_beast,{
%%           have_beast                             = 0,                        %% 是否有灵兽
%%           player_id                              = 0,                        %% 玩家ID
%%           id                                     = 0,                        %% 灵兽id
%%           beast_id                               = 0,                        %% 灵兽BaseID
%%           step                                   = 0,                        %% 灵兽进化阶段
%%           lv                                     = 0,                        %% 等级
%%           key                                    = 0,                        %% 唯一KEY
%%           type                                   = ?FIGHTER_TYPE_UNKNOWN,    %% 战斗单位类型          
%%           field_pid                              = undefined,                %% combat_feild的PID
%%           self_pid                               = undefined,                %% 战斗单位状态机 PID
%%           career_id                              = 0,                        %% 职业
%%           pos                                    = 0,                        %% 站位
%%           main_id                                = 0,                        %%
%%           name                                   = 0,                        %% 昵称
%%           unique_id                              = 0,                        %% 
%%           main_unique_id                         = 0,                        %% 
%%           five_elements                          = 0,                        %% 五行
%%           resource_id                            = 0,                        %% 资源                    
%%           fight_attri                            = #fight_attri_struct{},    %% 战斗属性
%%           attack_type                            = ?SG_ATK_TYPE_COMMON,      %% 攻击类型
%%           stunt_skill                            = 0,                        %% 绝技技能
%%           common_skill                           = 0,                        %% 普通攻击技能
%%           passive_skills                         = [],                       %% 被动技能
%%           attack_skill                           = 0,                        %% 一次攻击使用的技能   common_skill | special_skill
%%           attack_target                             ,                        %% 攻击目标   目标选择方式
%%           export_type                            = ?SG_MELEE_ATTACK          %% 输出类型  近战|远程|谋略
%%          }
%%        ).


%% -define(COMBAT_BASE_ATTRI,#fighter.fight_attri#fight_attri_struct.base_attribute).
%% -define(COMBAT_FINAL_ATTRI,#fighter.fight_attri#fight_attri_struct.final_attribute).
%% -define(BASE_ATTRI,#fight_attri_struct.base_attribute#attribute_info).
%% -define(FINAL_ATTRI,#fight_attri_struct.final_attribute#attribute_info).
%% -define(FIGHT_BUFF,#fight_attri_struct.buffs).

%% -define(FIGHTER_ATTRI,      #fighter.fight_attri).
%% -define(FIGHTER_FIGHT_ATTRI,#fighter.fight_attri#fight_attri_struct).
%% -define(FIGHTER_FINAL_ATTRI,#fighter.fight_attri#fight_attri_struct.final_attribute#attribute_info).
%% -define(FIGHTER_BASE_ATTRI,#fighter.fight_attri#fight_attri_struct.base_attribute#attribute_info).
%% -define(FIGHTER_BUFFER,#fighter.fight_attri#fight_attri_struct.buffs).

%% -define(FINAL_ATTRI_CUR_HP,#fight_attri_struct.final_attribute#attribute_info.cur_hp).
%% -define(FINAL_ATTRI_HP_LIM,#fight_attri_struct.final_attribute#attribute_info.hp_lim).
%% -define(FINAL_ATTRI_CUR_MP,#fight_attri_struct.final_attribute#attribute_info.cur_mp).
%% -define(FINAL_ATTRI_INIT_RAGE,#fight_attri_struct.final_attribute#attribute_info.init_rage).


%% -define(FINAL_ATTRI_REC,#fight_attri_struct.final_attribute).
%% -define(BASE_ATTRI_REC,#fight_attri_struct.base_attribute).

%% -define(FLAG_DEATH,          #fight_attri_struct.flag_death).
%% -define(FLAG_META,           #fight_attri_struct.flag_meta).
%% -define(FLAG_META_RATE,      #fight_attri_struct.flag_meta_rate).
%% -define(FLAG_ABSORB,         #fight_attri_struct.flag_absorb).
%% -define(FLAG_ABSORB_SUB,     #fight_attri_struct.flag_absorb_sub).
%% -define(FLAG_FATAL,          #fight_attri_struct.flag_fatal).
%% -define(FLAG_REBOUND,        #fight_attri_struct.flag_rebound).
%% -define(FLAG_SLEEP,          #fight_attri_struct.flag_sleep).
%% -define(FLAG_SWIM,           #fight_attri_struct.flag_swim).
%% -define(FLAG_FROZEN,         #fight_attri_struct.flag_frozen).
%% -define(FLAG_CHAOS,          #fight_attri_struct.flag_chaos).
%% -define(FLAG_SILENCE,        #fight_attri_struct.flag_silence).
%% -define(FLAG_UNYIELDING,     #fight_attri_struct.flag_unyielding).
%% -define(FLAG_UNYIELDING_RATE,#fight_attri_struct.flag_unyielding_rate).
%% -define(FLAG_HIDE,           #fight_attri_struct.flag_hide).
%% -define(FLAG_FIRE,           #fight_attri_struct.flag_fire).
%% -define(FLAG_BEHEADED,       #fight_attri_struct.flag_beheaded).
%% -define(FLAG_VAMPIRE,        #fight_attri_struct.flag_vampire).
%% -define(FLAG_MISS,           #fight_attri_struct.flag_miss).

%% -define(FLAG,        #fight_attri_struct).

%% -define(DEATH,               1). %%死亡标识
%% -define(ALIVE,               0). %%存活标识

%% -define(HIDE_FLAG_HIDE,  1).
%% -define(HIDE_FLAG_UNHIDE,0).

%% -define(FIGHT_CORLOR_RED, 1).  %%战斗蓝方 一般为战斗发起方
%% -define(FIGHT_CORLOR_BLUE,2). %%战斗红方 防守方

%% %%最大连击数
%% -define(MAX_HIT_COUNT,5).


%% %%
%% -record(combat_role,{
%%           fighter_uid      = 0,                 %%
%%           fighter_id       = 0,                 %%玩家ID
%%           fighter_type     = 0,                 %%角色类型 人物，怪物，马仔等
%%           fighter_pid      = undefined,         %%角色fsm进程
%%           fighter_status   = 0,
%%           color            = 0,                 %%red 为战斗发起方 blue 为被攻击方
%%           pos              = 0,
%%           flag_hide        = 0                  %%隐身标识与选择主目标相关
%%          }).

%% %% @spec
%% %% STANDARD_DELAY: 标准行动延迟时间
%% %% MOBILITY_LIMIT: 行动最大值
%% %% 
%% %% @end
%% -define(STANDARD_DELAY, 12000).
%% -define(MOBILITY_LIMIT, 6).

%% %%
%% %% 战斗消息子协议
%% %% 
%% -define(COMBAT_MSG_INIT,1).             %%战斗初始化
%% -define(COMBAT_MSG_START,2).            %%战斗开始
%% -define(COMBAT_MSG_NEXT_SCHEDULE,3).    %%战斗顺序
%% -define(COMBAT_MSG_FIGHT,4).
%% -define(COMBAT_MSG_OVER,5).
%% -define(COMBAT_MSG_END,6).

%% %%记录整个战斗过程
%% -record(combat_report,
%%         {
%%           result = 0,        				%%错误代码
%%           report_id = 0,     				%%战报ID
%%           final= 0,              			%%战斗结果,0平局,1胜利,2失败(相对主动攻击者)
%%           result_lv = 0,                    %%结果评级 小胜|平平|大胜|惨败....
%%           copy_id = 0,           			%%副本ID  add 2011/11/02
%%           version = 0,					    %%版本号      add 2011/11/02
%%           can_skip = 0,            		    %%战报过程是否可以跳过				
%%           %%攻击方初始化信息
%%           attacker_id=0,					%%攻击方ID
%%           attacker_unique_id = 0, 		    %%攻击方唯一ID
%%           attacker_camp_id=0,				%%攻击方阵法	
%%           attacker_member=[],     		    %% [#combat_member{},....]
%%           attacker_dead=[],                 %% 攻击方死亡列表
%%           attacker_pet, 								

%%           %%防御方初始化信息
%%           defender_id=0,         		    %%防御方ID
%%           defender_unique_id = 0,		    %%防御方唯一ID
%%           defender_camp_id=0,			    %%防御方阵法ID
%%           defender_member =[],			    %%member记录列表,ID,等级,位置,技能,hp,mp
%%           defender_dead = [],               %% 防御方死亡列表
%%           defender_pet, 				
          
%%           active_skill_list = [],           %% 战斗中所有可能使用到的主动技能
%%           passive_skill_list = [],          %% 战斗中所有可能使用到的被动技能
          
%%           prepare = [],                     %% 武将特性效果
%%           %%战斗过程
%%           process=[]              		%%[#round_report{},.....]		
%%         }
%%        ).

%% %%记录战斗过程的战斗伙伴/怪物的初始信息
%% -record(combat_member,                 		%%成员
%%         {	
%%           unique_id = 0,             		%%唯一ID
%%           id        = 0,					%%成员id
%%           name      = "",              		%%名字
%%           lv        = 0,					%%成员等级
%%           pos       = 0,					%%成员在阵法位置
%%           hp_lim    = 0,	    			%%成员最大血气值
%%           hp        = 0,					%%成员气血值
%%           mp        = 0,					%%成员气势值
%%           stunt_skill_id    = 0,			%%成员的绝技技能ID
%%           stunt_skill_ids   = [],           %%所有绝技技能
%%           resource_id = 0,					%%成员资源ID
%%           fighter_type = 0,                 %% 成员类型
%%           career = 0,             		%% 武魂职业
%%           career_id  = 0,                   %% 真实职业
%%           %%add 2011.20.19
%%           attacker_resource_id = 0,  		%%攻击方的技能特效资源ID
%%           defender_resource_id = 0, 		%%被攻击方的技能特效资源ID
%%           buff_list = [],	   		       %%存储玩家的技能buff
%%           gender   = 0,                     %%性别
%%           normal_skill_id   = 0,            %%普攻技能
%%           passive_skill_ids = []            %%被动技能
%%         }
%%        ).
%% %%守护者预留
%% -record(combat_keeper,{
%%           unique_id = 0,
%%           keepid = 0          
%%          }).

%% %% %%记录战斗的buff
%% %% -record(report_buff,
%% %% 			{
%% %% 				buff_unique_id =0,      		%%buff唯一ID(方便战斗过程中使用)
%% %% 				buff_type = 0,          		%%buff类型
%% %% 				buff_resource_id=0      		%%buff资源ID
%% %% 			}
%% %% 	    ).

%% %% %%记录一次攻击的过程
%% %% -record(round_one_hit,       					%%一次攻击/一次buff修正(比如中毒)
%% %% 			{
%% %% 			 	round_seq = 1,					%%回合序号
%% %% 			 	attacker    = [],       		%%攻击列表,role_state列表
%% %% 				defender = []					%%被攻击列表,role_state列表	
%% %% 			 }   			
%% %%    		).

%% %%记录一次攻击过程的一个伙伴/怪物的状态
%% %% -record(round_role_state,						%%一次攻击中一个角色的状态
%% %% 			{
%% %% 			 	unique_id = 0,          		%%角色唯一ID
%% %% 			 	id = 0,              			%%角色ID
%% %% 				main_id = 0,            		%%主角ID   
%% %% 				pos = 0,                		%%在阵法中的位置	  
%% %% 				attack_type = 0,        		%%攻击类型 1.普通攻击 2绝技攻击 3buff影响
%% %% 				skill = 0,						%%施放技能,如果是普通攻击技能设为0
%% %% 				hp = 0,							%%生命值
%% %% 				mp = 0,							%%气势值
%% %% 				hurt_type = 0,          		%%伤害类型((1.血气 2.气势 3法术 4防御 5法术防御 6绝技防御 7闪避 8格挡 9反击 10攻击 11法术攻击 12绝技攻击 13命中 14暴击 15催眠 16晕眩))
%% %% 				hurt = 0,						%%伤害(负数为减少,正数为增加)
%% %% 				state = 0,						%%状态(0=>buff效果 1普通攻击,2普通受击,3闪避,4暴击,5反击,6挡格，7绝技攻击 8绝技受击)  
%% %% 				%%buff_list =[]					%%如果出手方的有气血伤害或增益则一定是受到buff影响了
%% %% 												%%技能列表格式[{skillId,times},{技能ID,剩余次数},...]
%% %% 				buff_change = []				%%记录玩家的buff变化[{1,10},{2,11}] 1表示增加 2表示删除 10和11是buff唯一ID		
%% %% 			 }  
%% %%    		).

%% -record(round_report,{
%%           unique_id      = 0,
%%           id             = 0,
%%           pos            = 0,
%%           atk_type       = 0,
%%           export_type    = 0,
%%           attacker_id    = 0,
%%           attack_skill   = 0,
%%           attack_targets = {[],[]},                  %%攻击目标[{Master,Slave}]
%%           round_begin    = [],                  %%战斗初始化时的效果  [#effect_res{},...]
%%           before_atk     = [],                  %%[#effect_res{},...]
%%           before_def     = [],                  %%[#effect_res{},...]
%%           hurt           = [],                  %%[#effect_res{},...]
%%           at_atking      = [],                  %%[#effect_res{},...]
%%           at_defing      = [],                  %%[#effect_res{},...]
%%           all_buffs      = [],
%%           after_def      = [],                  %%[#effect_res{},...]
%%           after_atk      = [],                  %%[#effect_res{},...]
%%           ext_hurt       = [],                  %%[#effect_res{},...]
%%           round_end      = []                   %%战斗初始化时的效果  [#effect_res{},...]
%%          }
%%        ).

%% -record(effect_res,{
%%           atk_pos          = 0,
%%           atk_id           = 0,          
%%           def_pos          = 0,                        %% #fighter.pos
%%           def_id           = 0,                        %% #fighter.id
%%           passive_skill_id = 0,
%%           effect_point     = 0,                        %% 触发点
%%           effect_type      = 0,                        %% 触发类型  反击|连击|追击...
%%           hurt_attri       = []     %% 造成的属性变化  #fight_attri_struct
%%          }).

%% -record(ext_effect_res,{
%%           target        = 0,    %% #fighter.id
%%           effect_point  = 0,    %% 触发点
%%           effect_type   = 0,    %% 触发类型  反击|连击|追击...
%%           hurt_attri    = []     %% 造成的属性变化  #fight_attri_struct
%%          }).

%% %% %%怪物奖励和副本奖励
%% %% -record(combat_reward,
%% %% 			{
%% %% 				exp = 0,						%%经验奖励
%% %% 				mon_drop_list = [],      		%%都是reward_item记录,在define_dungeon.hrl中定义
%% %% 				dungeon_reward_list = [],		%%副本奖励列表
%% %% 				unique_id = 0            		%%用于前端跟后端领取奖励的确认
%% %% 			}
%% %% 		).

%% %% %%战斗buff
%% %% -record(
%% %%    		xxx_combat_buff,
%% %% 			{
%% %% 			 	oprate_type=0, 					%%int:8     操作类型(1增加buff,2移除buff)
%% %% 	      	 	buff_type=0						%%int:8  buff类型(1.直接攻击 2.气势 3法术 4防御 5法术防御 6绝技防御 7闪避 8格挡 9反击 10攻击 11法术攻击 12绝技攻击 13命中 14暴击 15催眠 16晕眩 17血气)
%% %% 			}
%% %%       ).

%% %% %%战斗回合数据
%% %% -record(
%% %% 	  		xxx_combat_round,
%% %% 			{
%% %% 			 	times = 0,						%%回合数
%% %% 			 	order = [] 						%%{flag,unique_id}  flag为当前回合是否已经出战过,1表示战斗过 0没有出战过,死亡的时候也要设为0
%% %% 			 }
%% %% 	  ).

%% %% %%战斗伤害(暂时没有使用!)
%% %% -record(
%% %%    			xxx_combat_hurt,
%% %% 			{
%% %% 			 	type = 0, 						%%伤害类型
%% %% 				value = 0 						%%数值
%% %%  			} 
%% %%    		).

%% -record(combat_field,{
%%           id             = 0,           %% 战场Id
%%           fsm_pid        = undefined,   %% 战斗FSM进程
%%           pid            = undefined,   %% 战斗进程
%%           room_state     = 0,           %% 房间状态
%%           room_id        = 0,           %% 房间号
%%           type           = 0,           %% 类型
%%           action_seq     = [],          %% 行动序列
%%           spend_time     = 0,           %% 战斗费时
%%           red_id         = 0,           %% 进攻方INFO player|ets_arena_member|...
%%           red_players    = [],          %% 进攻方 -record combat_role
%%           red_dead       = [],          %% 进攻方已死亡的角色 包括伙伴
%%           red_camp       = 0,           %% 阵法ID
%%           red_damage     = 0,           %% 攻击方的总输出伤害值
%%           blue_id        = 0,           %% 防御方INFO player|ets_arena_member|...
%%           blue_players   = [],          %% 防御方
%%           blue_dead      = [],          %% 防御方已死亡的角色
%%           blue_camp      = 0,           %% 阵法ID
%%           blue_damage    = 0,           %% 防御方的总输出伤害值
%%           roundcnt       = 0,           %% 总回合数
%%           bgid           = 0,           %% 战斗背景
%%           monster        = undefined,   %% 怪物
%%           pos            = undefined,   %% 地图中位置
%%           info           = undefined,   %% 额外信息
%%           report         = #combat_report{},
%%           start_time     = 0,
%%           event          = undefined
%%          }).

%% -record(combat_fsm_field,{
%%           id             = 0,           %% 战场Id
%%           start_time     = 0,
%%           last_round_end_time = 0,      %% 上个回合结束时间
%%           fsm_pid        = undefined,   %% 战斗进程
%%           field_pid      = undefined,
%%           event          = undefined
%%          }).

%% %% -ifdef(debug).
%% %% -define(COMBAT_OUT(Format, Args),
%% %%         io:format("~w:~w:~w combat>>>" ++ Format, [?MODULE,?LINE,self()] ++ Args)).
%% %% -else.
%% -define(COMBAT_OUT(Format, Args),
%%         ok).
%% %% -endif.

%% %% io:format("~w:~w:~w combat>>>" ++ Format, [?MODULE,?LINE,self()] ++ Args)).
%% %% ?DEBUG("Combat>>>> : " ++ Format, Args)).

%% %% -define(COMBAT_OUT(Format, Args),
%% %%         ok).
%% -define(SG_FIGHT_TYPE_UNDEFINED,             0).
%% -define(SG_FIGHT_TYPE_PVP,                   1).
%% -define(SG_FIGHT_TYPE_PVE,                   2).
%% -define(SG_FIGHT_TYPE_ARENA,                 3).
%% -define(SG_FIGHT_TYPE_ARENA_PVE,             4).
%% -define(SG_FIGHT_TYPE_KILO_RIDE,             5).
%% -define(SG_FIGHT_TYPE_WORLD_BOSS,            6).
%% -define(SG_FIGHT_TYPE_WARSCRAFT_SNATCH,      7).
%% -define(SG_FIGHT_TYPE_WARSCRAFT_OCCUPY,      8).
%% -define(SG_FIGHT_TYPE_KILL_MON,              9).
%% -define(SG_FIGHT_TYPE_ENSLAVE,              10).
%% -define(SG_FIGHT_TYPE_REBEL,                11).
%% -define(SG_FIGHT_TYPE_RESCUE,               12).
%% -define(SG_FIGHT_TYPE_GUILD_FIGHT,          13).
%% -define(SG_FIGHT_TYPE_SOUTHERN,             14).
%% -define(SG_FIGHT_TYPE_PARTNER_RANK,         15).
%% -define(SG_FIGHT_TYPE_FIRST_OF_WORLD,       16).

%% -define(SG_IGNORED_SPECIAL,  0).
%% -define(SG_DO_SPECIAL,       1).

%% -define(SG_MELEE_SKILL_ID, 30100011).  %% 近程攻击技能
%% -define(SG_RANGE_SKILL_ID, 30100001).  %% 远程攻击技能
%% -define(SG_MAGIC_SKILL_ID, 30100001).  %% 谋略攻击技能

%% -define(SG_DEFAULE_SKILL_ID, 30000000).  %% 在技能无法找到相应数据时使用该技能

%% -define(DEFAULT_SKILL_MASTER_RATIO, 1000). %% 技能主目标系数
%% -define(DEFAULT_SKILL_SLAVE_RATIO,  500).  %% 技能次目标系统

%% -define(SG_DEFAULE_AGLIE,       100).
%% -define(SG_DEFAULE_MOBI,        100).

%% -define(COMBAT_HIT,               1).

%% -define(COMBAT_BUFF_OP_NO_ACTION, 0).
%% -define(COMBAT_BUFF_OP_ADD,       1).        %% 战斗BUFF操作
%% -define(COMBAT_BUFF_OP_CONTINUE,  2).
%% -define(COMBAT_BUFF_OP_REMOVE,    3).

%% -define(DEFAULT_ATK_TARGET, {9, 0, 0}).     %% 默认攻击目标选择方式
%% -define(DEFAULT_DEF_TARGET, {5, 0, 0}).     %% 默认防守目标选择方式

%% -define(DEFAULT_CHAOS_TARGET, {1001, 1, 0}).     %% 混乱后的目标选择方式 -全体随机选取一个进行攻击


%% -define(COMBAT_RESULT_PEASE,   0).
%% -define(COMBAT_RESULT_WIN,     1).
%% -define(COMBAT_RESULT_LOSS,    2).

%% -define(SKILL_RECOVER_TYPE_HP,        1).
%% -define(SKILL_RECOVER_TYPE_HP_RATE,   2).
%% -define(SKILL_RECOVER_TYPE_MP,        3).
%% -define(SKILL_RECOVER_TYPE_MP_RATE,   4).

%% -record(combat_info,{combat_uuid        = undefined,
%%                      combat_pid         = undefined,
%%                      combat_state       = 0,
%%                      combat_time        = 0
%%                     }).

%% -record(combat_event,{atk_role                      , %% 攻击方                 
%%                       skill                         , %% 使用的技能
%%                       atk_type                      , %% 攻击类型  1普攻 | 2绝招
%%                       export_type                   , %% 1-近战 | 2-远程 | 3-谋略
%%                       master_target                 , %% 主目标
%%                       slave_target                  , %% 次目标
%%                       target_select_type            , %% 技能目标选择方式
%%                       selected_target               , %% 当前正在处理的目标 [{TargetType, CombatRole}...]
%%                       master_ratio                  , %% 技能主目标系数
%%                       slave_ratio                   , %% 技能次目标系数
%%                       final_damage                  , %% 伤害值 #fight_attri_struct
%%                       miss_targets                  , %% 闪避成功的目标
%%                       round_report                  , %% 战报
%%                       red_init_list                 , %% 需要初始化的列表 - 进攻方   -- 战斗初始化
%%                       red_newcoming_flag            , %% 新参战标识
%%                       blue_init_list                , %% 需要初始化的列表 - 防御方   -- 战斗初始化
%%                       blue_newcoming_flag            , %% 新参战标识
%%                       final,                           %% 战斗结果                  -- 战斗结算
%%                       ext_targets                     %% 额外效果目标集
%%                      }).

%% -record(combat_target,{type                  , %% ?TARGET_TYPE_MASTER |             ?TARGET_TYPE_SLAVE
%%                        role                           %% combat_role         
%%                       }).

%% -record(effect_parm,{atk_pid          = undefined,
%%                      def_pid          = undefined,
%%                      target_type      = 0,
%%                      atk_type         = 0,
%%                      export_type      = 0,
%%                      effect           = undefined,
%%                      effect_time      = 0,
%%                      slave_target_pid = undefined,
%%                      final_damge      = undefined,
%%                      miss_targets     = undefined,         %% 闪避成功的目标
%%                      passive_skill_id = 0,
%%                      fsm_pid          = undefined,
%%                      field_pid        = undefined,
%%                      round_report     = undefined,
%%                      skill_id         = 0,                 %% 技能影响效果
%%                      ext_target       = undefined          %% 技能附加效果的目标集 一个ext一个 {[M],[S]}
%%                     }).

%% %%%%%%% COMBAT_BUFF %%%%%%%%%%%%%%%%%

%% %%Combat Buff define
%% %%BUFF TYPE
%% -define(BUFF_TYPE_ATTRI_CHANGE,  1).
%% -define(BUFF_TYPE_LAST,          2).

%% %%Effect point
%% -define(BUFF_EFFECT_ROUND_BEGIN, 1).
%% -define(BUFF_EFFECT_ATTACK_ATK,  2).
%% -define(BUFF_EFFECT_ATTACK_DEF,  3).
%% -define(BUFF_EFFECT_DEFENCE_ATK, 4).
%% -define(BUFF_EFFECT_DEFENCE_DEF, 5).
%% -define(BUFF_EFFECT_ROUND_END,   6).
%% -define(BUFF_EFFECT_IMMEDIATALY, 7). %%立即生效

%% -define(BUFF_TYPE_ATTRI,         1). %% 属性类BUFF - 暂未进行处理
%% -define(BUFF_TYPE_CONTROL,       2). %% 控制类BUFF - 暂未进行处理
%% -define(BUFF_TYPE_SLEEP,         3). %% 睡眠类BUFF
%% -define(BUFF_TYPE_ABSORB,        4). %% 吸收类BUFF

%% %%0-增益 1-负面
%% -define(COMBAT_BUFF_TYPE_UP,     0).
%% -define(COMBAT_BUFF_TYPE_DOWN,   1).

%% -define(COMBAT_BUFF_DISPEL,      0).  %% 可驱散
%% -define(COMBAT_BUFF_UNDISPEL,    1).  %% 不可驱散

%% %%Continue_type
%% -define(BUFF_CONTINUE_TYPE_ROUND,1).
%% -define(BUFF_CONTINUE_TYPE_TIMES,2).


%% %% 玩家战斗属性信息
%% -record(combat_attri, {player_id   = 0,				  %% 所属玩家
%%                        parter_id   = 0,				  %% 所属伙伴，玩家自己则为0
%%                        beast_id    = 0,                %% 灵兽ID，类型
%%                        career      = 0,                %% 职业
%%                        step        = 0,                %% 
%%                        lv          = 0,                %% 等级
%%                        type        = 0,                %% 
%%                        star_lv     = 0,                %% 星力等级
%%                        base_attri  = undefined,        %% 基本属性值 从base_player中取出 #attribute_info
%%                        final_attri = undefined,        %% 最终战斗属性 每次刷新需要重新演算一次
%%                        power       = 0                 %% 战斗力
%%                       }).

%% -define(A_DAY_SECOND,     (60 * 60 * 24)).
%% -define(A_DAY_TIMEOUT,    (?A_DAY_SECOND * 1000)).

%% -record(combat_result, {combat_type     = undefined,
%%                         result          = 0,        %% 战斗结果 
%%                         attacker_id     = 0,        %% 攻击方Id
%%                         attack_damage   = 0,        %% 攻击输出总量
%%                         attacker_alive_attri = undefined,
%%                         defender_id     = 0,        %% 防御方Id auto_mon_id , challenge_layer, mon_scene_id
%%                         defend_damage   = 0,        %% 防御方输出总量
%%                         defender_alive_attri = undefined,
%%                         point           = 0,        %% 评分
%%                         star            = 0,        %% 评价星级
%%                         robot           = 0,        %% 是否机器人 1 - 机器人
%%                         fight_report_uuid = undefined %% 战报UUID
%%                        }).

%% -define(FIRST_OF_WORLD_LV,      60).
%%===================END OLD DEFINE=====================================



%% NEW COMBAT DEFINE

-record(combat_attri, {player_id   = 0,
                       version     = combat_attri_version:current_version(),
                       sn          = 0,
                       career      = 0,
                       nickname    = "",
                       lv          = 0,
                       ability     = 0,
                       high_ability = 0,
                       league_id   = 0,
                       league_name = "",
                       league_title= 0,
                       base_attri  = 0,
                       final_attri = 0,
                       equips      = [],
                       stunts      = [],
                       fashions    = [],
                       type        = 0       %% 属性类型 0 默认为玩家， 1 为机器人
         }).

-record(attribute, {hp_lim             = 0,
                    version            = attribute_version:current_version(),
                    hp_cur             = 0,
                    mana_lim           = 0,
                    mana_cur           = 0,
                    hp_rec             = 0, 
                    mana_rec           = 0,
                    attack             = 0,
                    def                = 0,
                    hit                = 0,
                    dodge              = 0,
                    crit               = 0, 
                    anti_crit          = 0,
                    stiff              = 0,
                    anti_stiff         = 0,
                    attack_speed       = 0,
                    move_speed         = 0,
                    attack_effect      = 0,
                    def_effect         = 0,
                    hp_lim_percent     = 0,  %% 生命百分比
                    attack_percent	   = 0,  %% 攻击百分比
                    def_percent        = 0,  %%	防御百分比
                    hit_percent	       = 0,  %% 命中百分比
                    dodge_percent	   = 0,  %% 闪避百分比
                    crit_percent	   = 0,  %% 暴击百分比
                    anti_crit_percent  = 0   %% 抗暴百分比
                   }).


%% 血量	2001
%% 攻击	2015
%% 防御	2016
%% 命中	2017
%% 闪避	2018
%% 暴击	2019
%% 抗暴	2020
%% 精神	2006
-define(HP_LIMIT,        2001).
-define(ATTACK,          2015).
-define(DEF,             2016).
-define(HIT,             2017).
-define(DODGE,           2018).
-define(CRIT,            2019).
-define(ANTI_CRIT,       2020).
-define(MANA_REC,        2006).


-define(COMBAT_ATTRI_TYPE_ROBOT, 1).

-endif.

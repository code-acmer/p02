
-ifndef(DEFINE_PLAYER_HRL).
-define(DEFINE_PLAYER_HRL, true).

-include("db_base_player.hrl").
-include("db_log_uplevel.hrl").

%% 基本数据ETS表定义
-define(ETS_RELA,         ets_rela).
-define(ETS_BASE_PLAYER,  ets_base_player).
-define(ETS_BLACKLIST,    ets_blacklist).

-define(MAX_INT_32, 2147483647).

%% 玩家性别宏定义
%% 2012.12.20@zhangr
-define(MALE,          1).      %% 男性
-define(FEMALE,        2).      %% 女性 

%% 玩家职业宏定义
%% 2012.11.12调整宏定义，
-define(YAGAMI,             1).      %% 八神
-define(MAI,                2).      %% 火舞  

-define(PLAYER_CUR_STATE, player_cur_state). %%标示玩家目前状态

-define(PLAYER_STATE_FREE, 0).
-define(PLAYER_STATE_IN_TEAM, 1).
-define(PLAYER_STATE_IN_DUNGEON, 2).

%% 玩家一些默认属性的定义
-define(DEFAULT_PHYSICAL_STRENGTH, 200).
-define(DEFAULT_STAMINA_ADDED, 40).
-define(DEFAULT_SPEED, 250).
-define(DEFAULT_CELL_NUM,    9).
-define(DEFAULT_STORE_NUM,   9).
-define(MAX_CELL_NUM,       48).
-define(MAX_STORE_CELL_NUM, 60).
-define(PS_RECOVER_TIME,  1800).    %% 体力恢复时间
-define(HOLD_SPEED_COST,    30).    %% 加速挂机花费元宝

%% 战斗属性加成标记。1表示是基础的，2表示准备的，3表示奇门遁甲、内功的
-define(BAT_ATTR_TOTAL,    0).  %% 表示所有的
-define(BAT_ATTR_BASE,     1).
-define(BAT_ATTR_EQUIP,    2).
-define(BAT_ATTR_MERIDIAN, 3).
-define(BAT_ATTR_BUFF,     4).
-define(BAT_ATTR_PET,      5).
-define(BAT_ATTR_PET_TEAM, 6).
-define(BAT_ATTR_MIND,     7).
-define(BAT_ATTR_TITLE,    8).
-define(BAT_ATTR_MAGIC,    9).

%% 伙伴状态标记。0表示正常，1表示出战，2表示训练
-define(PARTER_STATE_NORMAL,   0).
-define(PARTER_STATE_FIGHTING, 1).
-define(PARTER_STATE_TRAINING, 2).

%% buff类型定义
-define(HP_BAG_BUFF, 1).                %% 自动恢复生命
-define(MULTIPLE_INCOME_BUFF, 2).	%% N倍收益
-define(SINGLE_GAIN_BUFF, 3).		%% 单体属性增益
-define(GROUP_GAIN_BUFF, 4).		%% 群体属性增益
-define(STRENGH_ADD_BUFF, 5).		%% 体力增加
-define(BUFF_ATTACK_BOSS, 6).		%% BOSS战buff

%% buff消耗类型定义
-define(BUFF_USE_VAL, 1).			%% 减值类型
-define(BUFF_USE_TIMES, 2).			%% 减次数类型
-define(BUFF_USE_TIME, 3).			%% 减时间类型
-define(BUFF_USE_BOSS, 4).			%% BOSS战buff

%% buff所影响的属性的定义
-define(BUFF_HP_LIM, 1).		%% 1到15是战斗相关属性
-define(BUFF_ATTACK, 2).
-define(BUFF_DEF, 3).
-define(BUFF_MAGIC_ATTACK, 4).
-define(BUFF_MAGIC_DEF, 5).
-define(BUFF_STUNT_ATTACK, 6).
-define(BUFF_STUNT_DEF, 7).
-define(BUFF_HIT, 8).
-define(BUFF_DODGE, 9).
-define(BUFF_CRIT, 10).
-define(BUFF_PARRY, 11).
-define(BUFF_COUNTER, 12).
-define(BUFF_FORCE, 13).
-define(BUFF_MAGIC, 14).
-define(BUFF_STUNT, 15).
-define(BUFF_STRENGH, 16).		%% 体力包
-define(BUFF_HP, 17).			%% 气血包
-define(BUFF_EXP, 18).			%% 加倍经验
-define(BUFF_COIN, 19).			%% 加倍金钱
-define(BUFF_EXPERIENCE, 20).	%% 加倍历练
-define(BUFF_MORALE, 21).		%% 气势

%% 金钱消费价格定义
-define(COIN_TRAINED_COST, 1000).
-define(GOLD_TRAINED_COST, 2).

-record(battle_attribute,
        {key,                            %% 唯一键，由玩家id，伙伴id，类型组成。
         player_id   = 0,                %% 所属玩家
         parter_id   = 0,                %% 所属伙伴，玩家自己则为0, 对所有人都有作用则为-1
         beast_id    = 0,                %% 灵兽ID，类型
         career      = 0,                %% 职业
         step        = 0,
         lv          = 0,                %% 等级
         type        = 0,
         star_lv     = 0,                %% 星力等级
         base_attri  = undefined,        %% 基本属性值 从base_player中取出 #attribute_info
         final_attri = undefined,        %% 最终战斗属性 每次刷新需要重新演算一次
         power       = 0                 %% 战斗力
        }).

%% 定义字段与位置
-define(BATTLE_ATT_HP,           #battle_attribute.final_attri#attribute_info.hp).
-define(BATTLE_ATT_ATTACK,       #battle_attribute.final_attri#attribute_info.attack).
-define(BATTLE_ATT_DEF,          #battle_attribute.final_attri#attribute_info.def).
-define(BATTLE_ATT_MAGIC_ATTACK, #battle_attribute.final_attri#attribute_info.magic_attack).
-define(BATTLE_ATT_MAGIC_DEF,    #battle_attribute.final_attri#attribute_info.magic_def).
-define(BATTLE_ATT_STUNT_ATTACK, #battle_attribute.final_attri#attribute_info.stunt_attack).
-define(BATTLE_ATT_STUNT_DEF,    #battle_attribute.final_attri#attribute_info.stunt_def).
-define(BATTLE_ATT_HIT,          #battle_attribute.final_attri#attribute_info.hit).
-define(BATTLE_ATT_DODGE,        #battle_attribute.final_attri#attribute_info.dodge).
-define(BATTLE_ATT_CRIT,         #battle_attribute.final_attri#attribute_info.crit).
-define(BATTLE_ATT_PARRY,        #battle_attribute.final_attri#attribute_info.parry).
-define(BATTLE_ATT_COUNTER,      #battle_attribute.final_attri#attribute_info.counter).
-define(BATTLE_ATT_FORCE,        #battle_attribute.final_attri#attribute_info.force).
-define(BATTLE_ATT_MAGIC,        #battle_attribute.final_attri#attribute_info.magic).
-define(BATTLE_ATT_STUNT,        #battle_attribute.final_attri#attribute_info.stunt).
-define(BATTLE_ATT_MORALE,       #battle_attribute.final_attri#attribute_info.morale).


-define(BATTLE_ATTRIBUTE_DEF, 
        [{hp_lim,        #battle_attribute.final_attri#attribute_info.hp_lim},
         {attack,        #battle_attribute.final_attri#attribute_info.attack},
         {def,           #battle_attribute.final_attri#attribute_info.def},
         {magic_attack,  #battle_attribute.final_attri#attribute_info.magic_attack},
         {magic_def,     #battle_attribute.final_attri#attribute_info.magic_def},
         {stunt_attack,  #battle_attribute.final_attri#attribute_info.stunt_attack},
         {stunt_def,     #battle_attribute.final_attri#attribute_info.stunt_def},
         {hit,           #battle_attribute.final_attri#attribute_info.hit},
         {dodge,         #battle_attribute.final_attri#attribute_info.dodge},
         {crit,          #battle_attribute.final_attri#attribute_info.crit},
         {parry,         #battle_attribute.final_attri#attribute_info.parry},
         {counter,       #battle_attribute.final_attri#attribute_info.counter},
         {force,         #battle_attribute.final_attri#attribute_info.force},
         {magic,         #battle_attribute.final_attri#attribute_info.magic},
         {stunt,         #battle_attribute.final_attri#attribute_info.stunt},
         {morale,        #battle_attribute.final_attri#attribute_info.morale}]).


%%用户的其他附加信息(对应player.other)
-record(player_other, {
          buffs,		      %% 玩家身上的buff的列表
          camp = [],                  % 阵法[{CampId,Lv,isuse,position}],position为[{1,-1},{2,-1}...]格式{位置,角色ID}
          socket = undefined,	      % 当前用户的socket
          socket2 = undefined,        % 当前用户的子socket2
          socket3 = undefined,	      % 当前用户的子socket3
          pid_socket = undefined,     % socket管理进程pid
          pid = undefined,          	% 用户进程Pid
          pid_bag = undefined,		% 背包模块进程Pid
          pid_send = [],				% 消息发送进程Pid(可多个)
          pid_send2 = [],				% socket2的消息发送进程Pid
          pid_send3 = [],				% socket3的消息发送进程Pid
          pid_dungeon = undefined,  	% 副本（竞技场）进程Pid
          pid_scene = undefined,	  	% 当前场景Pid
          pid_task = undefined,		% 当前任务Pid
          node = undefined,			% 进程所在节点    
          blacklist = false,			%是否受黑名单监控	
          out_pet = [],				% 出战的宠物	
          player_dungeon_now,			% 玩家副本信息	
          pet_attribute = #battle_attribute{},  % 宠物属性对玩家角色的属性加成列表[生命,攻击,防御,法术攻击,法术防御,绝技攻击,绝技防御,命中,闪避,暴击,格挡,反击]
          pet_skill_mult_attribute = #battle_attribute{},	% 宠物技能对玩家战斗属性的加成[生命,攻击,防御,法术攻击,法术防御,绝技攻击,绝技防御,命中,闪避,暴击,格挡,反击] 
          double_sit_id=0,			% 与该玩家双修的玩家id，为0时表示没有双修
          in_carry_scene = 0,   		% 是否在运镖场景 	
          hold_info                             % 挂机信息
         }).

%% 玩家BUFF	
-record(player_buff,
        {
          buff_id = 0,                            %% base_buff表的buff_id	
          unique_id = 0,                          %% 唯一码。唯一码相同的buff不能叠加	
          type = 0,                               %% buff类型，1、自动恢复生命2、N倍收益3、单体属性增益4、群体属性增益5、体力增加	
          use_type = 0,                           %% 消耗类型，1表示值消耗，2表示次数消耗，3表示24点移除类型。	
          start_time = 0,			  %% 加buff的时间
          value_last = 0,			  %% 剩余值,如果使用类型是1或2，则存储一个动态变化的值。
          value_init = 0,                         %% 初始值	
          add_id = 0				  %% 叠加码，如果为0则不能叠加
        }).	

%% 试炼定义
-record(trial_data,
        {
          trial_id              = 0,     %% 试练ID
          done_times            = 0,     %% 完成次数
          done_tag              = 0,     %% 完成标记
          can_get_back          = 0,     %% 是否可取回
          add_can_get_back_time = 0}
       ).

%% 成就系统定义
-record(achieve_data, 
        {
          achieve_id=0, 
          done_tag=false,
          done_times=0,
          done_time=0
         }).

-define(ADD_PS_BUFF_TIME, [43200, 64800]).		%% 一天中加体力buff的时间
-define(PS_BUFF_ID, 33900001).					%% 体力buff的ID


%% @spec
%% 数据计算的通用数据结构，装备等所有的数据结构均需要转化成本数据结构使用
%% @end
-record(attribute_info, {	
          cur_hp             = 0,                      %% 当前气血
          hp_lim             = 0,                      %% 气血上限	
          cur_mp             = 0,                      %% 当前怒气值
          init_rage          = 0,                      %% 初始怒气
          dao                = 0,                      %% 道行值
          force              = 0,                      %% 武力	
          magic              = 0,                      %% 法术	
          stunt              = 0,                      %% 绝技	
          agile              = 0,                      %% 敏捷	
          mobi               = 0,                      %% 行动力	
          attack             = 0,                      %% 普通攻击	
          def                = 0,                      %% 防御	
          magic_attack       = 0,                      %% 法术攻击	
          magic_def          = 0,                      %% 法术防御	
          stunt_attack       = 0,                      %% 绝技攻击	
          stunt_def          = 0,                      %% 绝技防御	
          hit                = 0,                      %% 命中率	
          dodge              = 0,                      %% 躲避率	
          crit               = 0,                      %% 暴击率	
          tenacity           = 0,                      %% 韧性率	
          wreck              = 0,                      %% 破击率	
          parry              = 0,                      %% 格挡率	
          counter            = 0,                      %% 反击率
          pursie_attack      = 0,                      %% 追击率
          absorb             = 0,                      %% 可吸收值
          meta               = 0,                      %% 幻化率
          meta_cnt           = 0,                      %% 幻化次数
          unyieleding        = 0,                      %% 不屈
          double_hit         = 0,                      %% 连击概率
          hit_cnt            = 0,                      %% 连击数
          vampire            = 0,                      %% 吸血率
          vampire_rate       = 0,                      %% 吸血量          
          firm               = 0,                      %% 刚烈
          back_to_bite       = 0,                      %% 反噬
          strengthen         = 0,                      %% 强化率
          weaken             = 0,                      %% 弱化率
          shift              = 0,                      %% 转移概率
          shift_rate         = 0,                      %% 转移量
          rebound            = 0,                      %% 反弹率
          rebound_rate       = 0,                      %% 反弹量          
          beheaded           = 0,                      %% 斩杀率率
          beheaded_rate      = 0,                      %% 斩杀比率 - 血量判断
          fatal              = 0,                      %% 致命
          fatal_rate         = 0,                      %% 致命比率 - 血量判断
          call_mon           = 0,                      %% 召唤怪物          
          call_sum           = 0,                      %% 召唤数量
          call_cnt           = 0,                      %% 召唤次数
          attack_eff         = 1000,                   %% 攻击效果
          def_eff            = 1000,                   %% 防御效果
          magic_attack_eff   = 1000,                   %% 魔法攻击效果
          magic_def_eff      = 1000,                   %% 魔法防御效果
          stunt_attack_eff   = 1000,                   %% 绝技攻击效果
          stunt_def_eff      = 1000,                   %% 绝技防御效果
          power              = 0                       %% 战斗力
         }).

-define(PLAYER_OFFLINE, 0).        %% 玩家离线
-define(PLAYER_ONLINE,  1).        %% 玩家在线

%% 角色状态数据
%% 角色状态（0正常、1禁止、2战斗中、3死亡、4蓝名、5挂机、6打坐、7凝神修炼、8采矿、9答题、10挂机中、11温泉中）
-define(PLAYER_STATUS_NORMAL,      0).    %% 正常状态
-define(PLAYER_STATUS_BANNED,      1).    %% 禁止状态
-define(PLAYER_STATUS_COMBAT,      2).    %% 战斗中
-define(PLAYER_STATUS_DEATH,       3).    %% 死亡中
-define(PLAYER_STATUS_BLUE,        4).    %% 蓝名
-define(PLAYER_STATUS_PRACTICE,    6).    %% 打坐中
-define(PLAYER_STATUS_D_PRACTICE,  7).    %% 双人修炼中
-define(PLAYER_STATUS_MINING,      8).    %% 采矿中
-define(PLAYER_STATUS_EXAMING,     9).    %% 答题中
-define(PLAYER_STATUS_RAID,       10).    %% 挂机中
-define(PLAYER_STATUS_BOSS,       15).    %% 世界BOSS中

%% 经验来源类型
%% (FromWhere: 0、为任务收入, 1、为单人打怪收入, 2、为使用物品收入, 3、GM命令
%% 12为组队打怪收入, 13自动打坐收入, 14、离线修炼)
-define(EXP_TYPE_TASKS,      0).
-define(EXP_TYPE_MONSTER,    1).
-define(EXP_TYPE_GOODS,      2).
-define(EXP_TYPE_GM,         3).
-define(EXP_TYPE_TEAM,      12).
-define(EXP_TYPE_SIT,       13).
-define(EXP_TYPE_OFFLINE,   14).

%% 等级最大值
-define(PLAYER_MAX_LEVEL,         data_base_player:get_player_max_lv()).

-define(MAX_SCENE_PLAYER,     30).

-define(MAX_PLAYER_PASSIVE_CNT, 3).

-define(NOT_RECHARGE,       0). 
-define(ALREADY_RECHARGE,   1).
-define(RECHARGE_RECV_GIFT, 2).

%% 角色基本信息	
-record(player,
        {	
          id = 0,                %% 角色ID(自增)	
          version = player_version:current_version(), %% 版本号
          accid = "",            %% 平台账号ID	
          accname = "",          %% 平台账号	
          nickname = "",         %% 角色名
          career = 0,            %% 职业 1，2，3，4（分别是天行、武尊、羽芒、落星）
          lv = 1,                %% 等级	
          exp = 0,               %% 经验
          vip = 0,               %% vip等级，0是没有vip，然后分1-10级
          vip_exp = 0,           %% vip值，超过一定值即为不同级别的vip。此值可有多种途径增加，充值是途径之一
          vip_due_time = 0,      %% vip到期时间戳
          gm_power = 0,          %% GM权限，1为GM，0为非GM
          sn = 1,                %% 服务器号
          %% 资源
          coin = 0,              %% 铜钱
          cost_coin = 0,         %% 花费的铜钱总数 
          gold = 0,              %% 元宝
          cost_gold = 0,         %% 花费的元宝总数
          
          league_seal = 0,       %% 公会印章
          seal = 0,              %% 征途印章
          cross_coin = 0,        %% 跨服竞技场货币
          arena_coin = 0,        %% 竞技场货币
          bind_gold = 0,         %% 绑定元宝
          cost = 0,              %% cost for equipment
          vigor = 0,             %% 体力
          buy_vigor_times = 0,   %% 每天购买体力次数
          combat_point = 0,      %% 竞技点
          honor = 0,             %% 荣誉点
          fpt = 0,               %% 友情值
          friends_limit = 0,     %% 好友上限值
          friends_cnt   = 0,     %% 当前好友数量
          bag_limit = 0,         %% 包裹数量上限
          bag_cnt   = 0,         %% 背包当前数据量
          day_buy_num = 0,       %% 玩家日购买商品数（普通商城）

          %% 其他标识
          online_flag = 0,                        %% 在线标记，0不在线1在线
          timestamp_login = 0,                    %% 玩家登入时间戳
          timestamp_logout = 0,                   %% 玩家登出时间戳
          total_login_days = 0,                   %% 累积登录天数，默认值为0,第一天登陆是会被timestamp_daily_reset加1
          timestamp_login_reward = 0,             %% 登录奖励领取时间	
          timestamp_daily_reset = 0,              %% 每日重置时间	
          first_login = 1,                        %% 是否第一次登录
          vip_flag = 0,                           %% vip领取标记（二进制标记）
          login_reward_flag = 0,                  %% 登录奖励领取标记（二进制标记）
          last_dungeon = {31000101, 0},           %% 最后通关的副本id（普通副本）
          dungeon_reward = [],                    %% 通关副本奖励
          
          %% 技能相关
          skill_setting = [],                     %% 技能设置
          normal_skill_ids = [],                  %% 普通技能s
          stunt_skill_ids = [],                   %% 绝技技能s
          passive_skill_ids = [],                 %% 被去技能s
          mail_flag = 0,                          %% 是否领取节日活动邮件
          help_battle_id = 0,                     %% 好友助战ID
          total_gold = 0,                         %% 累计元宝充值数量
          last_fashion = 0,                       %% 最后激活的时装ID
          fashion      = 0,                       %% 当前穿在身上的时装ID
          have_dungeoned = [],                    %% 当前打过的副本
          friends_ext = 0, %% 购买的好友个数
          beginner_step = 0,
          status = 0, %% 0是正常，1是封号
          unlock_role_timestamp = 0,
          goods_update_timestamp = 0,
          week_login_days = 0,                    %% 周累积登陆天数
          month_login_days = 0,                   %% 月累积登陆天数
          month_login_flag = 0,                   %% 
          open_boss_info = [],
          battle_ability = 0,                     %% 当前战斗力
          high_ability = 0,                       %% 最高战斗力
          boss_open_times = 0,
          last_add_league_time = 0,
          return_gold = 0,                        %% 双倍礼金额度
          create_timestamp = 0,                   %% 创角时间
          gold_choujiang_num = 0,                 %% 钻石抽奖的次数
          recv_gift_num = 0,
          live_ness = 0,                          %% 活跃度
          first_recharge_flag = 0,                %% 首充标识
          cdk = 0,                                %% 兑换礼包码
          device_id = "",                         %% 设备码
          qq = "",                                %% 绑定的QQ号
          q_coin = 0,                             %% q币
          high_pvp_rank = 0                       %% 历史排名最高
        }).

%% -record(combat_attri, {
%%           player_id = 0,
%%           version = combat_attri_version:current_version()
%%          }).

-record(help_battle,
        {
          player_id = 0,                           %% 玩家ID
          version = help_battle_version:current_version(),
          value     = 0,                           %% 好友助战增加的好友值，
          friend_count = 0,                        %% 好友借组你参战数量
          strangers_count = 0                      %% 陌生人借组你参战数量
        }).

%% 玩家进程的state结构
-record(mod_player_state, {player,                            %% 玩家数据
                           bag,                               %% 背包缓存
                           fashion,                           %% 时装缓存
                           relationship,                      %% 好友数据缓存
                           pid,                               %% 玩家进程id
                           socket,                            %% 玩家Socket
                           client_pid,                        %% tcp客户端回调接口
                           session,                           %% 登录验证
                           session_timestamp = 0,             %% 登录验证时间戳信息
                           rc4,
                           task_list = [],
                           dungeon_list = [],                 %% 副本缓存
                           dungeon_mugen = [],                %% 极限格斗缓存
                           dungeon_info = [],                 %% 记录副本相关信息                           
                           super_battle = [],
                           daily_dungeon = [],
                           boss_list = [],
                           cur_boss_pid,
                           %team_info,                         %%{teampid, state} 玩家当前组队的状态
                           mugen_reward,
                           skill_list = [],
                           skill_record = [],
                           source_dungeon = [],
                           operators_mail_list = [],
                           player_cost_state,               %% 数据库最后 cost 记录
                           sterious_shop,                   %% 玩家神秘商店数据          
                           ordinary_shop,                   %% 普通商城玩家日购买商品信息 
                           main_shop,                       %% 竞技商城玩家日购买商品信息 
                           activity_record,                 %% 抢购时玩家消费记录
                           vice_shop,                       %% 玩家竞技场神秘商店数据
                           choujiang_info,
                           league_info = [],
                           pay_gifts = [],
                           advance_reward = [],
                           vip_reward,
                           general_store_list = []
                          }).
-record(player_cost_state,{cost_coin_last = 0,                %% 数据库最后更新记录
                           cost_gold_last = 0                %% 数据库最后更新记录
                          }).

-record(player_month_sign,{player_id,
                           version = player_month_sign_version:current_version(),
                           timestamp = 0, %% 最后一次签到时间
                           sign_num = 0 %% 签到次数
                          }).
-record(vip_reward, {player_id = 0,
                     version = vip_reward_version:current_version(),
                     recv_list = [],
                     dirty = 0}).  %%领过的VIP存成一个列表
%% 定义玩家进程、通讯进程和包裹进程的宏
-define(PLAYER,                   #mod_player_state.player).
-define(PLAYER_ACCID,             #mod_player_state.player#player.accid).
-define(PLAYER_ACCNAME,           #mod_player_state.player#player.accname).
-define(PLAYER_SN,                #mod_player_state.player#player.sn).
-define(PLAYER_ID,                #mod_player_state.player#player.id).
-define(PLAYER_LV,                #mod_player_state.player#player.lv).
-define(PLAYER_VIP,               #mod_player_state.player#player.vip).
-define(PLAYER_NAME,              #mod_player_state.player#player.nickname).
-define(PLAYER_COIN,              #mod_player_state.player#player.coin).
-define(PLAYER_GOLD,              #mod_player_state.player#player.gold).
-define(PLAYER_COST,              #mod_player_state.player#player.cost).
-define(PLAYER_VIGOR,             #mod_player_state.player#player.vigor).
-define(PLAYER_FPT,               #mod_player_state.player#player.fpt).
-define(PLAYER_FRIENDS_LIMIT,     #mod_player_state.player#player.friends_limit).
-define(PLAYER_FRIENDS_CNT,       #mod_player_state.player#player.friends_cnt).

-define(PLAYER_BAG_LIMIT,         #mod_player_state.player#player.bag_limit).

-define(PLAYER_TIME_LOGIN,        #mod_player_state.player#player.timestamp_login).
-define(PLAYER_TIME_LOGOUT,       #mod_player_state.player#player.timestamp_logout).
-define(PLAYER_PID,               #mod_player_state.pid).
-define(PLAYER_SEND_PID,          #mod_player_state.client_pid).
-define(PLAYER_BAG,               #mod_player_state.bag).
-define(PLAYER_RELA,              #mod_player_state.relationship).
-define(PLAYER_SOCKET,            #mod_player_state.socket).

-define(PLAYER_SAVE_DELAY,        3000).     %% 3秒后回写数据库
-define(PLAYER_SAVE_SPAN,        600000).     %% 10分钟保存一次Player数据
-define(PLAYER_STOP_TIME,        ?ONE_HOUR_SECONDS).     %% 一段时间内没有操作，就关掉玩家进程
%-define(PLAYER_STOP_TIME,        30000).     %% 五分钟没有操作，就关掉玩家进程
-define(VIGOR_RECOVER_TIME,      360).    %%恢复一点体力的时间(/s)

-define(MAX_FRIEND_POINT, 10000).

-define(BUY_VIGOR_GOLD, 6).
-define(BUY_FRIEND_EXT_GOLD, 6).
-define(BUY_BAG_EXT_GOLD, 6).

-define(REFRESH_SHOP_GOLD, 50).
-define(REFRESH_SHOP_SEAL, 50).

-define(COST_OP_TYPE_ADD, 1).
-define(COST_OP_TYPE_SUB, 2).

-record(player_skill,      {id = 0,
                            version = player_skill_version:current_version(),
                            skill_id = 0,
                            player_id = 0,
                            lv = 1,      %%升级等级默认是1级
                            str_lv = 0,  %%强化等级默认是0级
                            type = 0,
                            sigil = [],
                            status = 0,   %%预留字段
                            dirty = 0
                           }).

-define(LAST_PACKET_NUM_HIGH, 15).
-define(LAST_PACKET_NUM_LOW, 5).

-record(player_skill_record, {player_id = 0,
                              version = player_skill_record_version:current_version(),
                              skill_record_list = [],
                              dirty = 0
                             }).

-define(FIRST_RECHARGE_BASE_ID, 25029900).

-record(player_response, {player,
                          fashion
                         }).

-endif.

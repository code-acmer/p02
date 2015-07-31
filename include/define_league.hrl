-ifndef(DEFINE_LEAGUE_HRL).
-define(DEFINE_LEAGUE_HRL,true).

-define(LEAGUE_TITLE_BOSS, 1). %%会长
-define(LEAGUE_TITLE_DEPUTY_BOSS, 2). %%副会长
-define(LEAGUE_TITLE_MEMBER, 3). %%普通成员
-define(LEAGUE_TITLE_OFFICIAL, 4). %%官员
-define(LEAGUE_TITLE_ELITE, 5). %%精英

-define(LEAGUE_MAX_NUM, 50).
-define(LEAGUE_MAX_LEAGUE_NAME_LENGTH, 10).  %%名字长度
-define(LEAGUE_MAX_LEAGUE_DECRA_LENGTH, 30). %%宣言长度

-define(SEND_LEAGUE_COUNT, 100).
-define(CREATE_LEAGUE_MIN_LV, 20).
-define(CREATE_LEAGUE_COST_GOLD, 100).

-define(MAX_COUNT_DEPUTY_BOSS, 2).
-define(MAX_COUNT_OFFICIAL, 5).

-define(PAGE_UP, 1).
-define(PAGE_DOWN, 2).

-define(LEAGUE_INVITE, 1). %% 接受邀请加入
-define(LEAGUE_NOT_INVITE, 0). %% 主动加入

-define(LEAGUE_MEMBRE_NUM_LIMIT, 0). %% 会长发放公会礼金，公会人数限制

-record(league, {id,
                 version = league_version:current_version(),
                 name = "",              %%工会名称
                 cur_num = 0,            %%当前人数
                 max_num = 0,            %%人数上限
                 lv = 1,                 %%工会等级
                 ability_sum = 0,        %%总战斗力
                 join_ability = 0,       %%加入要求的战斗力
                 declaration = "",       %%工会宣言
                 president = "",         %%会长名字
                 rank = 0,               %%把排名加上去，然后定时去维护这个
                 bind_gold = 0,          %%公会礼金 
                 league_gifts_num = 0,   %%工会中的批次红包数
                 apply_league_fight = 0, %%0表示未报名,1表示报名 需月清
                 league_group = 0,       %%段位 需月清
                 league_exp = 0,         %%公会经验值
                 g17_guild_id = 0,
                 g17_guild_name = ""
                }).

-record(league_member, {player_id,
                        version = league_member_version:current_version(),
                        league_id = 0,
                        title = ?LEAGUE_TITLE_MEMBER,
                        contribute = 0,                   %%贡献
                        contribute_lv = 0,                %% 贡献等级
                        send_gold = 0,                    %%发放的金额总数
                        recv_gold = 0,                    %%领取的金额总数
                        player_name = "",
                        g17_join_timestamp = 0            %% G17最后加入时间截
                        }).

-record(league_gifts_record, {id,
                              version = league_gifts_record_version:current_version(),
                              league_id = 0,
                              timestamp = 0,
                              send_name = "",
                              recv_name = "",
                              type = 0, %% 发送0, 接受1
                              value = 0,
                              double = 0 %% 领取的是否双倍
                             }).

-record(league_recharge_gold_record, {id,
                                      version = league_recharge_gold_record_version:current_version(),
                                      league_id = 0,
                                      timestamp = 0,
                                      recharge_name = "",
                                      value = 0                                      
                                     }).

-record(league_relation, {league_id, 
                          version = league_relation_version:current_version(),
                          league_group = 0, %% 我方所在段位
                          league_sn = 0, %% 我方所在服
                          league_score = 0, %% 我方公会积分
                          league_name = [], %% 我方公会名字
                          ability_sum = 0,  %% 我方总战斗力
                          league_lv = 0, %% 我方公会等级
                          cur_num = 0,   %% 我方当前人数
                          max_num = 0,   %% 我方公会人数上限
                          fight_record = [], %% 我方战斗记录 0输, 1赢
                          league_rank = 0, %% 我方在青铜段排名,或其它
                          league_thing = 0, %% 我方公会物资
                          league_point = 0, %% 我方攻下的据点数量
                          not_enemy = false, %% 是否被轮空
                          enemy_league_id = 0, %% 敌方公会Id
                          enemy_league_sn = 0 %% 敌方所在服
                         }).

-record(league_fight_point, {id = 0,
                             version = league_fight_point_version:current_version(),
                             league_id = 0,
                             status = 0, %% 据点状态, 0 守卫状态, 1 占领状态
                             pos = 0, %% 据点位置
                             protect_info = [], %% 玩家守卫信息{name, id}
                             occurpy_info = [], %% 敌方占领信息{name, id}
                             record_list = [],  %% [mdb_challenge_info ... ]
                             attack_info = [] %% 当前攻击状态 {timestamp, Id}
                            }).

-record(league_apply_info, {league_id,
                            version = league_apply_info_version:current_version(),
                            league_sn = 0,
                            ability_sum = 0
                           }).

-record(league_member_challenge, {player_id = 0,
                                  version = league_member_challenge_version:current_version(),
                                  league_id = 0,
                                  grap_thing = 0,
                                  grap_num = 0,
                                  use_challenge_num = 0, %% 已经用掉的挑战次数
                                  attack_info = [] %% 当前攻击状态 {timestamp, Id}
                                 }).

-record(league_challenge_record, {player_id = 0,
                                  version = league_challenge_record_version:current_version(),
                                  league_id = 0,
                                  record_list = [], %% [mdb_challenge_info ... ]
                                  player_name = ""
                                 }).
-record(mdb_challenge_info, {
          id = 0, %% 挑战者Id
          version = mdb_challenge_info_version:current_version(),
          name = "",
          result = 0,
          timestamp = 0,
          thing_num = 0
         }).

-define(POINT_ZERO, 0).
-define(POINT_ONE, 11).
-define(POINT_TWO, 12).
-define(POINT_THREE,13).
-define(POINT_FOUR, 14).
-define(POINT_FIVE, 15).

-define(TEN_FIGHT_SUCCESS, 10). %% 连续胜利场数最高值
-define(FIVE_FIGHT_FAIL, 5). %% 连续失败场数最高值

-define(FIGHT_WIN_TYPE,  1). %% 打赢
-define(FIGHT_FAIL_TYPE, 0). %% 打输

-define(FIGHT_WIN_INTEGRAL,  10). %% 战斗胜利基础加分
-define(FIGHT_FAIL_INTEGRAL,  5). %% 战斗失败基础减分

-define(EXTREME_GROUP, 200). %% 至尊组 [200 ~ ...)
-define(MASTER_GROUP,  145). %% 大师组 [145, 200)
-define(GOLD_GROUP,    100). %% 钻石组 [100, 145)
-define(PLATINUM_GROUP, 65). %% 白金组
-define(AURUM_GROUP,    45). %% 黄金组
-define(SILVER_GROUP,   30). %% 白银组
-define(STEEL_GROUP,    20). %% 赤钢组
-define(FERRUM_GROUP,   10). %% 黑铁组
-define(BRONZE_GROUP,    0). %% 青铜组


-define(POINT_LIST, [?POINT_ONE, 
                     ?POINT_TWO, 
                     ?POINT_THREE, 
                     ?POINT_FOUR, 
                     ?POINT_FIVE]).
-define(GROUP_LIST, [?EXTREME_GROUP, 
                     ?MASTER_GROUP,
                     ?GOLD_GROUP,
                     ?PLATINUM_GROUP,
                     ?AURUM_GROUP,
                     ?SILVER_GROUP,
                     ?STEEL_GROUP,
                     ?FERRUM_GROUP,
                     ?BRONZE_GROUP]).
-define(GROUP_MAX_NUM, 9). %% 段位的数量

-define(ALREADY_APPLY_FIGHT, 1). %%已经申请作战 
-define(GRAB_NUM, 5). %% 掠夺别人最大次数

-define(LEAGUE_CHALLENGE_FAIL, 2). %% 挑战失败
-define(LEAGUE_CHALLENGE_WIN, 1). %% 挑战成功
-define(LEAGUE_CHALLENGE_DRAW, 0). %% 挑战平局

-define(LEAGUE_THING, 10). %% 单人挑战 基础奖励物资
-define(LEAGUE_REWARD_THING, 100). %% 单人挑战 基础奖励物资

-define(CHALLENGE_FAIL_REWARD, 3). %% 单人挑战失败 奖励0.3
-define(CHALLENGE_MAX_NUM, 4). %% 单人挑战的最大次数

-define(POINT_MAX_NUM, 5). %% 最大据点数
-define(POINT_OCC_STATUS, 1). %% 据点被占领状态
-define(POINT_PRO_STATUS, 0). %% 据点被保护状态

-define(LEAGUE_CHALLENGE_ABILITY_RANK, 10). %% 挑战据点,所需最高战斗力排名前10
-define(POINT_CHALLENGE_MAX_NUM, 2). %% 据点被挑战的最大次数

-define(LEAGUE_APPLY_MEMBER_LIMIT, 10). %% 工会战报名的人数限制
-define(CHALLENGE_POINT_USE_NUM, 2). %% 挑战一次据点所需消耗单挑挑战次数

-define(LEAGUE_MAX_DEFENDER, 2).  %% 防御据点的最大人数
-define(MAX_ATTACK_POINT_TIMES, 1). %% 可攻击据点的最大次数

-define(HOUR_13, 13). %% 基数天13点开始战斗 

%% -define(APPLY_STATUS, 1). %% 报名等待
%% -define(NOT_ENEMY_STATUS, 2). %% 轮空等待
%% -define(IN_FIGHT_STATUS, 3). %% 处于战斗中
%% -define(WRITH_FIGHT_STATUS, 4). %% 处于战斗等待中
%% -define(NO_FIGHT_STATUS, 5). %% 不在战斗期间内
%% -define(NO_APPLY_STATUS, 6). %% 没有报名

-define(FIGHT_END_DATA, 28). %% 每月28号以后结束

-endif.


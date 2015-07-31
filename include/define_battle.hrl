-ifndef(DEFINE_BATTLE_HRL).
-define(DEFINE_BATTLE_HRL,true).



%%%------------------------------------
%%% @Module  :	define_battle
%%% @Created :  2011.9.10
%%% @Author  :  Liang
%%% @Description: record & marco belong to battle 
%%%------------------------------------
-record(ets_process,				 		%%战报缓存表(used in lib_battle_log)
			{
		 		id = 0,					 	%%唯一ID
				process_id = 0,      		%%战报ID
				player_id = 0,		 		%%玩家ID
				seq_id = 0,			 		%%序列ID(用于循环写)
				other_unique_id = 0, 		%%其他唯一ID,如队伍ID
				type = 0,			 		%%战斗类型
				is_write_file = 0,   		%%是否已经保存为文件
				process =0           		%%战斗过程
		 	}
		).
-define(ETS_PROCESS,ets_process).			%%战报缓存表 

-define(CACHE_COUNT,5).						%%每个玩家在ETS表缓存的战报数
-define(FILE_PATH,"../battle/").    		%%文件路径

%%配置策略:按天写文件夹/按小时写文件夹策略
-define(FILE_CIRCLE_TYPE,?FILE_CIRCLE_TYPE_HOUR).			
-define(FILE_CIRCLE_TYPE_DATE,1).			%%每天一文件夹
-define(FILE_CIRCLE_TYPE_HOUR,2).			%%每小时一文件夹

-define(WRITE_FILE_DELAY,1).				%%延迟写文件(通过前端通知再写文件)
-define(WRITE_FILE_NOW,2).					%%即时写文件		

%%配置策略:写数据库/写文件策略
-define(WRITE_STRATEGY,?WRITE_STRATEGY_FILE).
-define(WRITE_STRATEGY_DB,1).				%%写数据库
-define(WRITE_STRATEGY_FILE,2).				%%写文件

%%战报类型
-define(BATTLE_TYPE_SINGLE_DUNGEON,1).		%%单人副本
-define(BATTLE_TYPE_TEAM,2).				%%守关
-define(BATTLE_TYPE_ARENA,3).				%%竞技场
-define(BATTLE_TYPE_CARRY,4).				%%劫镖
-define(BATTLE_TYPE_TOWER,5).               %%闯塔

%%每种重要缓存的数量
-define(SINGLE_DUNGEON_CACHE_COUNT,1).		%%单人副本战报缓存数
-define(TEAM_CACHE_COUNT,all).				%%守关战报缓存数
-define(ARENA_CACHE_COUNT,5).				%%竞技场战报缓存数
-define(CARRY_CACHE_COUNT,1).				%%运镖战报缓存数
-define(TOWER_CACHE_COUNT,1).				%%闯塔战报缓存数

%% %% 战斗所需的属性
%% -record(battle_state, {
%%     id,
%%     name = [],
%%     scene,                      %% 所属场景
%%     lv, 
%%     career = 0,
%%     hp, 
%%     hp_lim,
%%     mp, 
%%     mp_lim, 
%%     att_max,
%%     att_min,
%%     def,                        %% 防御值
%%     x,                          %% 默认出生X
%%     y,                          %% 默认出生y
%%     att_area,                   %% 攻击范围  
%%     pid = undefined,            %% 玩家进程
%%     bid = undefined,            %% 战斗进程
%%     battle_status = [],         %% Buff效果
%%     sign = 0,                   %% 标示是怪还是人 1:怪， 2：人
%%     hit = 0,
%%     dodge = 0,
%%     crit = 0,
%%     hurt_add = 0,               %% 附加加伤害
%%     skill,
%%     pk_mode = 0,
%%     realm = 0,
%%     guild_id = 0,
%% 	type = 0,
%%     pid_team = undefined,
%%     status = 0,                  %% 状态 
%%     evil = 0,
%% 	leader = 0,
%% 	relation = []
%% }).

%%采集所需属性
-record(collect_status, {
    id,
    name,
    scene,                  %% 所属场景
    lv, 
    hp, 
	mp,
    hp_lim,
    x,                      %% 默认出生X
    y,                      %% 默认出生y
    pid = undefined,        %% 玩家进程
    cid = undefined,        %% 采集进程
    collect_status = [],     %% 采集状态
	type=0,
    pid_team = undefined 
}).

-endif.

-ifndef(DEFINE_HOLD_DUNGEON).
-define(DEFINE_HOLD_DUNGEON, true).

-record(hold_info, {hold_start, 				%% 挂机开始时间
					hold_dungeon, 				%% 挂机副本ID
					total_hold_times, 			%% 欲挂机次数
					each_battle_times, 			%% 每次挂机战斗次数
					cur_hold_times, 			%% 当前是第几次挂机
					cur_battle_times, 			%% 当前挂机的第几次战斗
					cur_battle_tag,			    %% 下次战斗标记
                    hold_finish,                %% 挂机结束时间
                    reward_list,                %% 已经获得奖励列表信息
                    dungeon_monster,            %% 副本怪物
                    dungeon_reward}).           %% 副本奖励

%% 挂机时的状态
-define(BATTLE_TAG_CONTINUE,       0).
-define(BATTLE_TAG_BATTLE_FINISH,  1).
-define(BATTLE_TAG_DUNGEON_FINISH, 2).
-define(BATTLE_TAG_FULL_OF_BAG,    3).
-define(BATTLE_TAG_OUT_OF_VIGOR,   4).
-define(BATTLE_TAG_TIMES_OUT,      5).
-define(BATTLE_TAG_INFO_NOT_FOUND, 6).

-endif.


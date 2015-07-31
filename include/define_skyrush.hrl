-ifndef(DEFINE_SKYRUSH_HRL).
-define(DEFINE_SKYRUSH_HRL,true).



%%帮派战奖励物品列表,修改时需要与?SKYRUSH_AWARD_ZERO同步
-define(SKYRUSH_AWARD_GOODS,
		[[{28702, 8}, {23303, 5}, {28023, 10}, {24000, 10}, {23406, 5}, {23400, 5}, {23403, 5}],
		 [{28702, 6}, {23303, 4}, {28023, 8}, {24000, 8}, {23406, 4}, {23400, 4}, {23403, 4}],
		 [{28702, 4}, {23303, 3}, {28023, 6}, {24000, 6}, {23406, 3}, {23400, 3}, {23403, 3}],
		 [{28702, 3}, {23303, 2}, {28023, 4}, {24000, 4}, {23406, 2}, {23400, 2}, {23403, 2}],
		 [{28702, 2}, {23303, 1}, {28023, 2}, {24000, 2}, {23406, 1}, {23400, 1}, {23403, 1}]]).
%%默认没有数据时的直接返回值,修改时需要与?SKYRUSH_AWARD_GOODS同步
-define(SKYRUSH_AWARD_ZERO, 
		[{28702, 0}, {23303, 0}, {28023, 0}, {24000, 0}, {23406, 0}, {23400, 0}, {23403, 0}]).
-define(AWARDGOODS_NUM_LIMIT, 3).%%获取同一样物品的最大数量限制

%%======================= 神岛空战 ================================
-record(skyrush, {boss_num = {3, [{43001, 1}, {43002, 1}, {43003, 1}]},				%%空岛上的boss数量
				  white_flags = {0, []},			%%目前在战场上的白旗数据
				  green_flags = {0, []},			%%目前在战场上的绿旗数据
				  blue_flags = {0, []},				%%目前在战场上的蓝旗数据
				  purple_flags = {0, []},			%%目前在战场上的紫旗数据
				  one_exist_flags = {0, []},		%%当前战场上开着的旗	({旗色，[{time, player_id}]})
				  two_exist_flags = {0, []},		%%当前战场上开着的旗	({旗色，[{time, player_id}]})	
				  three_exist_flags = {0, []},		%%当前战场上开着的旗	({旗色，[{time, player_id}]})	  	  
				  drop_flags = [],					%%丢落的旗数据
				  count = 0,						%%刷出旗的历史记录
				  purple_reflesh = 0,				%%是否该刷紫旗了,0为不刷，1为刷
				  
				  white_nuts = {0, []},				%%目前在战场上的白魔核数据
				  green_nuts = {0, []},				%%目前在战场上的绿魔核数据
				  blue_nuts = {0, []},				%%目前在战场上的蓝魔核数据
				  purple_nuts = {0, []},			%%目前在战场上的紫魔核数据
				  
				  point_l_read = [], 				 %%{Time, PlayerId, GuildId, GuildName}
				  point_h_read = [],
				  point_l = {0, ""},				%%占有中级据点的帮派ID
				  point_h = {0, ""}		      	 	%%占有高级据点的帮派ID
				}).
-record(g_feats_elem, {guild_id = 0,				%%帮派id
					   guild_name = "",				%%帮派名字
					   guild_feats = 0				%%帮派功勋
					  }).

-record(mem_feats_elem, {player_id = 0,				%%玩家Id
						 player_name = "",
						 guild_id = 0,  			%%玩家所属帮派
						 kill_foe = 0,				%%杀敌数
						 die_count = 0,				%%死亡次数
						 get_flags = 0,				%%夺旗数
						 magic_nut = 0,				%%魔核数
						 feats = 0					%%此次战斗功勋
					  }).
-record(fns_elem, {player_id = 0,					%%玩家id
					 type = 0						%%白1，绿2，蓝3，紫4
					}).
-record(df_elem, {time = 30,						%%掉落倒数时间(30秒)
				  coord = {0,0},					%%丢落的坐标
				  type = 0							%%旗类型
				 }).
-record(guild_skyrush_rank, {guild_id = 0,
							 guild_name = "",
							 lv = 0,
							 jion_m_num = 0,
							 feat_last = 0,
							 feat_week = 0,
							 feat_all = 0,
							 last_join_time = 0}).

-record(guild_mem_skyrush_rank, {player_id = 0,
								 player_name = "",
								 guild_id = 0,
								 career = 0,
								 sex = 0,
								 lv = 0,
								 kill_foe = 0,
								 die_num = 0,
								 get_flags = 0,
								 magic_nut = 0,
								 feats = 0
								 }).
%%======================= 神岛空战 ================================

-endif.

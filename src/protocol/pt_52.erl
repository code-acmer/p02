
-module(pt_52).
%% -export([
%%          write/2
%%         ]).

%% -include("common.hrl").
%% -include("define_southern.hrl").
%% -include("pb_52_pb.hrl").


%% %% %% 获取世界BOSS信息
%% %% read(52001, _)->
%% %% 	{ok, get_boss_data};

%% %% %% 请求战斗
%% %% read(52003, <<Tag:8>>)->
%% %% 	{ok, Tag};

%% %% %% 鼓舞
%% %% read(52004, <<Tag:8>>)->
%% %% 	{ok, Tag};

%% %% %% 欲火重生
%% %% read(52005, <<IsAuto:8>>)->
%% %% 	{ok, IsAuto};

%% %% %%
%% %% read(52007, BattleIDString)->
%% %% 	{BID, _} = pt:read_string(BattleIDString),
%% %% 	{ok, BID};

%% %% %% 领取世界boss奖励
%% %% read(52010, <<Tag:32>>)->
%% %% 	{ok, Tag};

%% %% %% 普通复活
%% %% read(52011, _)->
%% %% 	{ok, reborn};

%% %% %% 请求场景内死了的玩家
%% %% read(52012, _)->
%% %% 	{ok, get_alive_player};

%% %% %% 请求boss等级
%% %% read(52015, _) ->
%% %% 	{ok, get_boss_lv};

%% %% read(_Cmd, R) ->
%% %%  	?ERROR_MSG("{error, no_match}~p~n",[R]),
%% %%     {error, no_match}.

%% %% %% 世界BOSS信息
%% %% write(52001, {Tag, Time, BossResID, BossNameString, BossLv, BossHP, BossHPLim, Harm, Per, CDTime, CanRebornTimes, LastRebornTimes})->
%% %% 	NameBin = pt:write_string(BossNameString),
%% %% 	{ok, pt:pack(52001,<<Tag:8, Time:32, BossResID:32, NameBin/binary, BossLv:16, BossHP:32, BossHPLim:32, Harm:32, Per:32, CDTime:32, CanRebornTimes:32, LastRebornTimes:32>>)};

%% %% %% 排名数据
%% %% write(52002, Players)->
%% %% 	Len = length(Players),
%% %% 	Fun = 
%% %% 		fun({ID, Harm, Percent, Name, _PlayerLv}) ->
%% %% 				NameBin = pt:write_string(Name),
%% %% 				<<ID:64, Harm:32, Percent:32, NameBin/binary>>
%% %% 		end,
%% %% 	Bin = tool:to_binary([Fun(Item)||Item<-Players]),
%% %% 	{ok, pt:pack(52002, <<Len:16, Bin/binary>>)};

%% %% %% 请求战斗
%% %% write(52003, {Tag, Tag2, CD, Harm, Coin, Pre, NewPer, Battle})->
%% %% 	BattleBin = pt:write_string(Battle),
%% %% 	{ok, pt:pack(52003,<<Tag:8, Tag2:8, CD:32, Harm:32, Coin:32, Pre:32, NewPer:32, BattleBin/binary>>)};


%% %% %% 鼓舞
%% %% write(52004, {Tag, Per})->
%% %% 	{ok, pt:pack(52004,<<Tag:8, Per:32>>)};


%% %% %% 浴火重生
%% %% write(52005, Tag)->
%% %% 	{ok, pt:pack(52005,<<Tag:8>>)};

%% %% %% boss新血量广播
%% %% write(52006, HP)->
%% %% 	{ok, pt:pack(52006,<<HP:32>>)};

%% %% %% 开始CD
%% %% write(52007, {Tag, CD})->
%% %% 	{ok, pt:pack(52007,<<Tag:8, CD:32>>)};

%% %% %% 世界boss活动结束
%% %% write(52008, Tag)->
%% %% 	{ok, pt:pack(52008, <<Tag:8>>)};

%% %% %% 世界boss战奖励
%% %% write(52009, _BossRewards)->
%% %% 	%% Len1 = length(BossRewards),
%% %% 	%% Fun = 
%% %% 	%% 	fun(#boss_reward{reward_id=ID, reward_tag=Tag, rewards=Rewards}) ->
%% %% 	%% 			Len2 = length(Rewards),
%% %% 	%% 			Bin2 = tool:to_binary([<<Type:8, Num:32, GoodsID:32>>||#reward_item{type=Type, num=Num, goods_id=GoodsID}<-Rewards]),
%% %% 	%% 			<<ID:32, Tag:8, Len2:16, Bin2/binary>>
%% %% 	%% 	end,
%% %% 	%% Bin1 = tool:to_binary([Fun(Item)||Item<-BossRewards]),
%% %% 	pt:pack(52009, null);

%% %% %%  领取世界boss奖励结果
%% %% write(52010, {ID, Tag})->
%% %% 	{ok, pt:pack(52010, <<ID:32, Tag:8>>)};


%% %% %%  普通复活
%% %% write(52011, {Tag})->
%% %% 	{ok, pt:pack(52011, <<Tag:8>>)};


%% %% %%  请求场景内死了的玩家
%% %% write(52012, List)->
%% %% 	Len = length(List),
%% %% 	Bin = tool:to_binary([<<PlayerID:64>>||PlayerID<-List]),
%% %% 	{ok, pt:pack(52012, <<Len:16, Bin/binary>>)};

%% %% %%  玩家生存状态
%% %% write(52013, {PlayerID, Tag, X, Y})->
%% %% 	{ok, pt:pack(52013, <<PlayerID:64, Tag:8, X:32, Y:32>>)};

%% %% %%  boss战消息
%% %% write(52014, {Order, Coin, Pre, BossName})->
%% %% 	BossNameBin = pt:write_string(BossName),
%% %% 	{ok, pt:pack(52014, <<Order:32, Coin:32, Pre:32, BossNameBin/binary>>)};

%% %% %% boss等级
%% %% write(52015, Bosses) ->
%% %% 	Len = length(Bosses),
%% %% 	Bin = tool:to_binary([<<ID:32, Lv:32>>||{ID, Lv}<-Bosses]),
%% %% 	{ok, pt:pack(52015, <<Len:16, Bin/binary>>)};


%% write(52001, BossState) ->
%%     ?DEBUG("BossIcon : ~w~n",[BossState#mod_boss_state.boss_icon]),
%%     PbData = #pbbossstate{
%%                 boss_scene_id = BossState#mod_boss_state.boss_scene_id,
%%                 ready_start   = BossState#mod_boss_state.ready_start,
%%                 boss_name     = tool:to_binary(BossState#mod_boss_state.boss_name),
%%                 boss_lv       = BossState#mod_boss_state.boss_lv,
%%                 boss_hp       = BossState#mod_boss_state.boss_hp,
%%                 boss_hp_lim   = BossState#mod_boss_state.boss_hp_lim,
%%                 boss_line     = BossState#mod_boss_state.boss_line,
%%                 is_on         = BossState#mod_boss_state.is_on,
%%                 start_time    = BossState#mod_boss_state.start_time,
%%                 %% mon           = BossState#mod_boss_state.mon,
%%                 born_x        = BossState#mod_boss_state.born_x,
%%                 born_y        = BossState#mod_boss_state.born_y,
%%                 is_boss_die   = BossState#mod_boss_state.is_boss_die,
%%                 boss_order    = BossState#mod_boss_state.boss_order,
%%                 boss_icon     = BossState#mod_boss_state.boss_icon
%%                },
%%     pt:pack(52001, PbData);
%% write(52002, DicPlayerBoss) ->
%%     PbData = inner_dic_player_boss_to_pbdicplayerboss(DicPlayerBoss),
%%     pt:pack(52002, PbData);
%% write(52004, Result) ->
%%     PbData = #pbid32{
%%                 id = Result
%%                },
%%     pt:pack(52004, PbData);
%% write(52005, NewHp) ->
%%     PbData = #pbid32{
%%                 id = NewHp
%%                },
%%     pt:pack(52005, PbData);
%% write(52006, RankList) ->
%%     PbData = #pbranklist{
%%                 ranklist = inner_to_pb_rank_list(RankList)
%%                },
%%     pt:pack(52006, PbData);
%% write(52007, DicPlayerBoss) ->
%%     PbData = inner_dic_player_boss_to_pbdicplayerboss(DicPlayerBoss),
%%     pt:pack(52007, PbData);

%% write(52008, MonId) ->
%%     PbData = #pbid32{
%%                 id = MonId
%%                },
%%     pt:pack(52008, PbData);

%% write(52100, SouthernInfo) ->
%%     PbData = #pbsoutherninfo{
%%                 player_id         = SouthernInfo#rec_southern_info.player_id,
%%                 nickname          = tool:to_binary(SouthernInfo#rec_southern_info.nickname),
%%                 lv                = SouthernInfo#rec_southern_info.lv,
%%                 reborn_times      = SouthernInfo#rec_southern_info.reborn_times,
%%                 last_reborn_time  = SouthernInfo#rec_southern_info.last_reborn_time,
%%                 damage            = SouthernInfo#rec_southern_info.damage,
%%                 encourage_lv      = SouthernInfo#rec_southern_info.encourage_lv,
%%                 coin_total        = SouthernInfo#rec_southern_info.coin_total,
%%                 state             = SouthernInfo#rec_southern_info.state
%%                },
%%     pt:pack(52100, PbData);

%% write(52101, SouthernState) ->
%%     PbData = #pbsouthernstate{
%%                 boss_scene_id       = SouthernState#mod_southern_state.boss_scene_id,
%%                 activity_start_time = SouthernState#mod_southern_state.activity_start_time,
%%                 activity_state_time = SouthernState#mod_southern_state.activity_state_time,
%%                 activity_remain_time= SouthernState#mod_southern_state.activity_remain_time,
%%                 activity_state      = SouthernState#mod_southern_state.activity_state,
%%                 next_refresh_time   = SouthernState#mod_southern_state.next_refresh_time,
%%                 next_refresh_layer  = SouthernState#mod_southern_state.next_refresh_layer
%%                },
%%     pt:pack(52101, PbData);

%% write(52102, SouthernBossList) ->
%%     PbData = #pbsouthernbosslist{
%%                 boss_list = lists:map(fun(Boss) ->
%%                                               #pbsouthernboss{
%%                                                  boss_hp      = Boss#rec_southern_boss.boss_hp,
%%                                                  boss_hp_lim  = Boss#rec_southern_boss.boss_hp_lim,
%%                                                  auto_mon_id  = Boss#rec_southern_boss.auto_mon_id,
%%                                                  status       = Boss#rec_southern_boss.status
%%                                                 }
%%                                       end, SouthernBossList)
%%                },
%%     pt:pack(52102, PbData);
%% %% @doc 获取所有状态信息
%% write(52200, FowStateInfo) ->
%%     pt:pack(52200, FowStateInfo);
%% %% @doc 更新某一场比赛的状态
%% write(52201, UpdateList) ->
%%     pt:pack(52201, #pbfowstate{tryout_list = UpdateList});
%% %% @doc 更新状态
%% write(52202, {State, Countdown}) ->
%%     pt:pack(52201, #pbfowstate{state = State, timestamp = Countdown});
%% %% @doc 打包跨服战参赛者信息
%% write(52500, Data) ->
%%     pt:pack(52500, Data);
%% %% @doc 打包跨服战报信息
%% write(52501, Data) ->
%%     pt:pack(52501, Data);
%% write(Cmd, _R) ->
%% 	?ERROR_MSG("~s_errorcmd_[~p] ", [misc:time_format(misc_timer:now()), Cmd]),
%%     pt:pack(0, <<>>).

%% inner_to_pb_rank_list(RankList)
%%   when is_list(RankList) ->
%%     lists:map(fun(RankItem) ->
%%                       inner_dic_player_boss_to_pbdicplayerboss(RankItem)
%%               end, RankList).

%% inner_dic_player_boss_to_pbdicplayerboss(DicPlayerBoss) ->
%%     #pbdicplayerboss{
%%        player_id     = DicPlayerBoss#dic_player_boss.player_id,
%%        nickname      = tool:to_binary(DicPlayerBoss#dic_player_boss.nickname),
%%        lv            = DicPlayerBoss#dic_player_boss.lv,
%%        reborn_times  = DicPlayerBoss#dic_player_boss.reborn_times,
%%        last_reborn_time = DicPlayerBoss#dic_player_boss.last_reborn_time,
%%        damage        = DicPlayerBoss#dic_player_boss.damage,
%%        encourage_lv  = DicPlayerBoss#dic_player_boss.encourage_lv,
%%        coin_total    = DicPlayerBoss#dic_player_boss.coin_total,
%%        state         = DicPlayerBoss#dic_player_boss.state,
%%        rank          = DicPlayerBoss#dic_player_boss.rank
%%       }.


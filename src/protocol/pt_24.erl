-module(pt_24).
-include("pb_24_pb.hrl").
-include("define_logger.hrl").
-include("define_player.hrl").
-include("define_rank.hrl").

-export([write/2]).

write(24001, {SelfInfo, RankList}) ->
    PbRankList = to_pb_rank_list_ability(SelfInfo, RankList),
    pt:pack(24001, PbRankList);

write(24002, {SelfInfo, RankList}) ->
    PbRankList = to_pb_rank_list_level(SelfInfo, RankList),
    pt:pack(24002, PbRankList);

write(24003, {SelfInfo, RankList}) ->
    PbRankList = to_pb_rank_list_cost_coin(SelfInfo, RankList),
    pt:pack(24003, PbRankList);
%%%%%
write(24004, {SelfInfo, RankList}) ->
    PbRankList = to_pb_rank_list_cost_gold(SelfInfo, RankList),
    pt:pack(24004, PbRankList);
write(24005, {SelfInfo, RankList}) ->
    PbRankList = to_pb_rank_list_cost_gold(SelfInfo, RankList), %%显然是一样的
    pt:pack(24005, PbRankList);


write(Cmd, Other) ->
    ?WARNING_MSG("write cmd ~p error Other ~p~n", [Cmd, Other]),
    pt:pack(0, <<>>).

to_pb_rank_list_ability(SelfInfo, RankList) ->
    {SelfRank, Value} = 
        case SelfInfo of
            {0, _} ->
                {0, 0};
            {Rank, {Ability, _}} ->
                {Rank, Ability}
        end,
    PbRankList =
        lists:map(fun(#rank{value = Val,
                              ext = Ext}) ->
                            to_pbrank_info(ability, Val, Ext) 
                    end, RankList),
    to_pb_rank_list(SelfRank, Value, PbRankList).

to_pb_rank_list_level(SelfInfo, RankList) ->
    {SelfRank, Value} = 
        case SelfInfo of
            {0, _} ->
                {0, 0};
            {Rank, {Level, _, _}} ->
                {Rank, Level}
        end,
    PbRankList = 
        lists:map(fun(#rank{value = Val,
                              ext = Ext}) ->
                            to_pbrank_info(level, Val, Ext) 
                    end, RankList),
    to_pb_rank_list(SelfRank, Value, PbRankList).

to_pb_rank_list_cost_coin(SelfInfo, RankList) ->
    ?DEBUG("SelfInfo ~p~n", [SelfInfo]),
    {SelfRank, Value} = 
        case SelfInfo of
            {0, _} ->
                {0, 0};
            {Rank, {CostCoin, _}} ->
                {Rank, CostCoin}
        end,
    PbRankList = 
        lists:map(fun(#rank{value = Val,
                              ext = Ext}) ->
                            to_pbrank_info(cost_coin, Val, Ext) 
                    end, RankList),
    to_pb_rank_list(SelfRank, Value, PbRankList).


to_pb_rank_list_cost_gold(SelfInfo, RankList) ->
    ?DEBUG("SelfInfo ~p~n", [SelfInfo]),
    {SelfRank, Value} = 
        case SelfInfo of
            {0, _} ->
                {0, 0};
            {Rank, {CostGold, _}} ->
                {Rank, CostGold}
        end,
    PbRankList = 
        lists:map(fun(#rank{value = Val,
                              ext = Ext}) ->
                            to_pbrank_info(cost_gold, Val, Ext) 
                    end, RankList),
    to_pb_rank_list(SelfRank, Value, PbRankList).



to_pb_rank_list(Rank, Value, PbRankList) ->
    #pbranklist{rank = Rank,
                value = Value,
                rank_list = PbRankList}.

to_pbrank_info(ability, {Ability, PlayerId}, {NickName, Career, Level}) ->
    #pbrankinfo{player_id = PlayerId,
                career = Career,
                nickname = NickName,
                value = Ability,
                level = Level};

to_pbrank_info(level, {Level, _, PlayerId}, {NickName, Career, _Ability}) ->
    #pbrankinfo{player_id = PlayerId,
                career = Career,
                nickname = NickName,
                value = Level};

to_pbrank_info(cost_coin, {CostCoin, PlayerId},  {NickName, Career, _Ability, Level}) ->
    #pbrankinfo{player_id = PlayerId,
                career = Career,
                nickname = NickName,
                value = CostCoin,
                level = Level};

to_pbrank_info(cost_gold, {CostGold, PlayerId},  {NickName, Career, _Ability, Level}) ->
    #pbrankinfo{player_id = PlayerId,
                career = Career,
                nickname = NickName,
                value = CostGold,
                level = Level}.
































%% %%创建队伍
%% write(24000, [Res, TeamName, Auto]) ->
%%     TeamNameBin = pt:write_string(TeamName),
%%     Data = <<Res:16, TeamNameBin/binary, Auto:8>>,  %%新创建的队伍，默认自动入队
%%     {ok, pt:pack(24000, Data)};

%% %%加入队伍
%% write(24002, Res) ->
%%     Data = <<Res:16>>,
%%     {ok, pt:pack(24002, Data)};

%% %%向队长发送加入队伍请求
%% write(24003, [Id, Lv, Career, Realm, Nick]) ->
%%     NickBin = pt:write_string(Nick),
%%     Data = <<Id:32, Lv:16, Career:16, Realm:16, NickBin/binary>>,
%%     {ok, pt:pack(24003, Data)};

%% %%队长处理加入队伍请求
%% write(24004, Res)->
%%     Data = <<Res:16>>,
%%     {ok, pt:pack(24004, Data)};

%% %%离开队伍
%% write(24005, Res)->
%%     Data = <<Res:16>>,
%%     {ok, pt:pack(24005, Data)};

%% %%邀请加入队伍
%% write(24006, Res)->
%%     Data = <<Res:16>>,
%%     %% io:format("24006__~p~n",[Res]),	
%%     {ok, pt:pack(24006, Data)};

%% %%向被邀请人发出邀请
%% write(24007, [Id, Nick, TeamName]) ->
%%     NickBin = pt:write_string(Nick),
%%     TeamNameBin = pt:write_string(TeamName),
%%     Data = <<Id:32, NickBin/binary, TeamNameBin/binary>>,
%%     {ok, pt:pack(24007, Data)};

%% %%邀请人邀请进队伍
%% write(24008, Res) ->
%%     Data = <<Res:16>>,
%%     {ok, pt:pack(24008, Data)};

%% %%踢出队员
%% write(24009, Res) ->
%%     Data = <<Res:16>>,
%%     {ok, pt:pack(24009, Data)};

%% %%向队员发送队伍信息
%% write(24010, [TeamId, TeamName, Member]) ->
%%     TeamNameBin = pt:write_string(TeamName),
%%     N = length(Member),
%%     F = fun([Id, Lv, Career, Realm, Nick, Sta, Hp, HpLim, Mp, MpLim, Sex]) ->
%% 		NickBin = pt:write_string(Nick),		
%%   		<<Id:32, Lv:16, Career:16, Realm:8, NickBin/binary, Sta:8, 
%%                   Hp:32, HpLim:32, Mp:32, MpLim:32, Sex:8>>
%%         end,
%%     LN = tool:to_binary([F(X) || X <- Member]),
%%     Data1 = <<TeamId:32, TeamNameBin/binary, N:16, LN/binary>>,
%%     {ok, pt:pack(24010, Data1)};

%% %%向队员发送有人离队的信息
%% write(24011, Id) ->
%%     Data = <<Id:32>>,
%%     {ok, pt:pack(24011, Data)};

%% %%向队员发送更换队长的信息
%% write(24012, [Id, Auto]) ->
%%     Data = <<Id:32, Auto:8>>,
%%     {ok, pt:pack(24012, Data)};

%% %%委任队长
%% write(24013, Res) ->
%%     Data = <<Res:16>>,
%%     {ok, pt:pack(24013, Data)};

%% %%更改队名
%% write(24014, Res) ->
%%     Data = <<Res:16>>,
%%     {ok, pt:pack(24014, Data)};

%% %%通知队员队名更改了
%% write(24015, TeamName) ->
%%     TeamNameBin = pt:write_string(TeamName),
%%     Data = <<TeamNameBin/binary>>,
%%     {ok, pt:pack(24015, Data)};

%% %%队伍资料
%% write(24016, [Id, MbNum, Nick, TeamName, Auto]) ->
%%     NickBin = pt:write_string(Nick),
%%     TeamNameBin = pt:write_string(TeamName),
%%     Data = <<Id:32, MbNum:16, NickBin/binary, TeamNameBin/binary, Auto:8>>,
%%     {ok, pt:pack(24016, Data)};

%% %%通知队员队伍解散
%% write(24017, []) ->
%%     {ok, pt:pack(24017, <<>>)};

%% %% 场景队伍信息
%% write(24018, []) ->
%%     NL = 0,
%%     Data = <<NL:16>>,
%%     {ok, pt:pack(24018, Data)};
%% write(24018, Data) ->
%%     NL = length(Data),
%%     F = fun([Id, Nick, Lv, Career, Realm, Num, Auto]) ->
%%                 NickBin = pt:write_string(Nick),
%%                 <<Id:32, NickBin/binary, Lv:16, Career:16, Realm:16, Num:16, Auto:8>>
%%         end,
%%     Data1 = tool:to_binary([F(X)||X <- Data]),
%%     Data2 = <<NL:16, Data1/binary>>,
%%     {ok, pt:pack(24018, Data2)};

%% %% 修改 Pk模式
%% write(24019, T) ->
%%     {ok, pt:pack(24019, <<T:8>>)};

%% %% 向队员发送投骰子信息
%% write(24020, [UserName, MaxNum, GoodsTypeId, TeamRandDropInfo]) ->
%%     UserNameBin = pt:write_string(UserName),
%%     N = length(TeamRandDropInfo),
%%     F = fun({Num, _Pid, _Id, Name, _Realm, _Career, _Sex, _GoodsPid}) ->
%% 		NameBin = pt:write_string(Name),
%%   		<<NameBin/binary, Num:8>>
%%         end,
%%     LN = tool:to_binary([F(T) || T <- TeamRandDropInfo]),
%%     Data = <<UserNameBin/binary, MaxNum:8, GoodsTypeId:32, N:16, LN/binary>>,
%%     {ok, pt:pack(24020, Data)};

%% %% 更新队员信息
%% write(24021, [Id, Sta, Lv, Hp, HpLim, Mp, MpLim]) ->
%%     Data = <<Id:32, Sta:8, Lv:16, Hp:32, HpLim:32, Mp:32, MpLim:32>>,
%%     {ok, pt:pack(24021, Data)};

%% %% 更新队员场景位置信息
%% write(24022, [PlayerId, X, Y, SceneId]) ->
%%     Data = <<PlayerId:32, X:16, Y:16, SceneId:32>>,
%%     {ok, pt:pack(24022, Data)};

%% %%队员下线
%% write(24023, Id) ->
%%     Data = <<Id:32>>,
%%     {ok, pt:pack(24023, Data)};

%% %%发送给队伍进入副本或封神台信息
%% write(24030, Sid) ->
%%     %% ?DEBUG("24030__111_~p/",[Sid]),
%%     {ok, pt:pack(24030, <<Sid:32>>)};


%% %%小黑板登记信息
%% write(24050, Res) ->
%%     %% ?DEBUG("24050_000000000000: [~p]", [Res]),
%%     {ok, pt:pack(24050, <<Res:8>>)};

%% %%小黑板查询
%% write(24051, []) ->
%%     NL = 0,
%%     Data = <<NL:16>>,
%%     {ok, pt:pack(24051, Data)};
%% write(24051, L) ->
%%     %% ?DEBUG("35002_return_L_~p ~n",[L]),
%%     L2 = lists:delete([],L),
%%     %% ?DEBUG("35002_return_L2_~p ~n",[L2]),
%%     N = length(L2),
%%     %% ?DEBUG("35002_return_N_~p ~n",[N]),
%%     Data = 
%%         try
%%             F = fun(BBM) ->
%%                         Id = BBM#ets_blackboard.id,
%%                         NickBin = pt:write_string(BBM#ets_blackboard.nickname),
%%                         Leader = BBM#ets_blackboard.id,
%%                         Cdn1 = BBM#ets_blackboard.condition_1,
%%                         Cdn2 = BBM#ets_blackboard.condition_2,
%%                         Cdn3 = BBM#ets_blackboard.condition_3,
%%                         Min_lv = BBM#ets_blackboard.min_lv,
%%                         Max_lv = BBM#ets_blackboard.max_lv,
%%                         Career = BBM#ets_blackboard.career,
%%                         Lv = BBM#ets_blackboard.lv,
%%                         Sex = BBM#ets_blackboard.sex,
%%                         <<Id:32, NickBin/binary, Leader:8, Cdn1:8, Cdn2:8, Cdn3:8, Min_lv:8, Max_lv:8, Career:8, Lv:8, Sex:8>>
%%                 end,
%%             LB = tool:to_binary([F(X) || X <- L2, X /= []]),
%%             <<N:16, LB/binary>>
%%         catch
%%             _:_ -> 
%%                 ?WARNING_MSG("35002 List[~p],List2[~p],Num[~p]", [L, L2, N]),
%%                 <<0:16, <<>>/binary>>
%%         end,	
%%     {ok, pt:pack(24051, Data)};

%% %%自动入队修改
%% write(24052, [Res, T]) ->
%%     {ok, pt:pack(24052, <<Res:8, T:8>>)};

%% write(Cmd, _R) ->
%%     ?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(misc_timer:now()), Cmd]),
%%     {ok, pt:pack(0, <<>>)}.


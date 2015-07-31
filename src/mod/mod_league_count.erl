%%%-------------------------------------------------------------------
%%% @author li <lijunqiang@moyou.me>
%%% @copyright (C) 2015, li
%%% @doc
%%%
%%% @end
%%% Created : 17 Apr 2015 by li <lijunqiang@moyou.me>
%%%-------------------------------------------------------------------
-module(mod_league_count).

-behaviour(gen_server).

-include("define_logger.hrl").
-include("define_league.hrl").
-include("define_mnesia.hrl").
-include("define_time.hrl").
-include("define_mail.hrl").
-include("db_base_guild_rank_integral.hrl").
-include("define_goods_type.hrl").

%% API
-export([start_link/0, 
         get_bucket_list/0,
         test/0,
         test_start/0,
         clear_all_table/0,
         gm/3,
         start_count_data/0,
         season_end/0,
         auto_defend/0,
         daily_reward/0
        ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {match_list = [], %% 重新定制全服匹配
                result_list = [],  %% 结算的结果[{sn1, data_list1}, ... ], 发给各自的服, 发放奖励
                bucket_rank_list = []  %% 全服排行榜
               }).

%% 测试
test() ->
    AllDbSn = server_misc:mnesia_sn_list(),
    lists:map(fun(Num) -> 
                      Sn = hmisc:rand(1, length(AllDbSn)),
                      hdb:dirty_write(get_league_table(Sn), #league{
                                                               id = Num,
                                                               ability_sum = hmisc:rand(1, Num)
                                                              }),
                      hdb:dirty_write(get_league_relation_table(Sn), #league_relation{
                                                                        league_id = Num,
                                                                        league_sn = Sn,
                                                                        league_name = lists:concat(["hello_", Num])
                                                                       }),
                      lib_league_fight:update_league_fight_point_table(Num)
              end, lists:seq(1, 10001)),
    ok.

clear_all_table() ->
    DbSnList = server_misc:mnesia_sn_list(),
    lists:map(fun(Sn) ->
                      hdb:clear_table(get_league_table(Sn)),
                      hdb:clear_table(get_league_relation_table(Sn)),
                      mod_league_reward:reset_member_challenge_table(Sn),
                      hdb:clear_table(get_apply_info_table(Sn))                      
              end, DbSnList),
    hdb:clear_table(league_recharge_gold_record),
    hdb:clear_table(league_gifts_record),
    hdb:clear_table(league_fight_point),
    hdb:clear_table(league_member).

get_apply_info_table(Sn) ->
    list_to_atom(lists:concat([league_apply_info, "_", Sn])).

test_start() ->
    gen_server:cast(?MODULE, start_count_data).

%% 赛季结算
season_end() ->
    gen_server:cast(?MODULE, cmd_season_end).

gm(LeagueId, LeagueSn, Score) ->
    Table = get_league_relation_table(LeagueSn),
    LeagueRelation = hdb:dirty_read(Table, LeagueId),
    ?DEBUG("LeagueRelation: ~p", [LeagueRelation]),
    hdb:dirty_write(Table, LeagueRelation#league_relation{
                             league_score = Score
                            }).

auto_defend() ->
    gen_server:cast(?MODULE, cmd_auto_defend).

daily_reward() ->
    gen_server:cast(?MODULE, cmd_daily_reward).

%%%===================================================================
%%% API
%%%===================================================================

start_count_data() ->
    gen_server:cast(?MODULE, start_count_data).

get_bucket_list() ->
    gen_server:call(?MODULE, get_bucket_list).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    %erlang:send_after(100, self(), init_state),
    {ok, #state{}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(get_bucket_list, _From, #state{bucket_rank_list = BucketList} = State) ->
    Reply = {ok, BucketList},
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------

handle_cast(start_count_data, State) ->
    erlang:send_after(100, self(), cmd_center_count),
    {noreply, State};

handle_cast(cmd_season_end, State) ->
    do_season_end(),
    EmptyState =#state{match_list = [], %% 重新定制全服匹配
                       result_list = [],  %% 结算的结果[{sn1, data_list1}, ... ], 发给各自的服, 发放奖励
                       bucket_rank_list = []  %% 全服排行榜
                      }, 
    {noreply, EmptyState};

handle_cast(cmd_auto_defend, State) ->
    do_auto_defend(),
    {noreply, State};
handle_cast(cmd_daily_reward, State) ->
    do_daily_reward(),
    {noreply, State};
handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(cmd_center_count, State) ->
    DataGbTree = read_all_data(),
    ResultList = count_all_data(DataGbTree),
    ?DEBUG("ResultList: ~p", [ResultList]),
    NResultList = sort_by_score(ResultList),
    {RankList, NewResultList} = reset_league_rank(NResultList),
    ?DEBUG("Len:~p, Len:~p", [length(ResultList), length(NewResultList)]),
    FinalList = data_separate_by_sn(NewResultList),
    send_result_by_sn(FinalList),
    update_rank_data(RankList),
    erlang:send_after(300, self(), reset_match_league),
    {noreply, State#state{
                match_list = NewResultList, %% 保存临时数据
                result_list = FinalList,
                bucket_rank_list = RankList
               }};

%% handle_info(cmd_db_sn, #state{
%%                           result_list = FinalList,
%%                           bucket_rank_list = RankList
%%                          } = State) ->
    
%%     %% 这里要等待分节点处理完 league 然后再进行从新匹配, 预防league数据错误
%%     erlang:send_after(2000, self(), reset_match_league),
%%     {noreply, State};

handle_info(reset_match_league, #state{match_list = NewResultList} = State) ->
    %?WARNING_MSG("reset_match_league ... "),
    MatchList = reset_match(merge_apply_info() ++ NewResultList),    
    FinalMatchList = data_separate_by_sn(MatchList), 
    write_db_by_sn(FinalMatchList),
    reset_member_challenge(),
    clear_challenge_record_table(),
    %reset_point_table(),
    fight_win_reward(),
    erlang:send_after(300, self(), cmd_fill_point),
    {noreply, State#state{match_list = FinalMatchList}};

handle_info(cmd_fill_point, State) ->
    %?WARNING_MSG("cmd_fill_point...."),
    mod_league_reward:fill_point(),
    {noreply, State};

handle_info(init_state, State) ->
    Now = time_misc:unixtime(),
    case hdb:dirty_read(server_config, daily_reset_league_gifts) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = league_relation,
                                                          v = Now}),
            {noreply, State};
        #server_config{v = Last} ->
            case check_init_time(Now, Last) of
                false ->
                    hdb:dirty_write(server_config, #server_config{k = league_relation,
                                                                  v = Now}),
                    erlang:send_after(100, self(), cmd_center_count),
                    {noreply, State};
                true ->
                    MatchList = merge_apply_info() ++ init_read_all_data(),
                    ResultList = sort_by_score(MatchList),
                    {RankList, NewResultList} = reset_league_rank(ResultList),
                    FinalList = data_separate_by_sn(NewResultList),
                    %send_result_by_sn(FinalList),
                    {noreply, State#state{
                                match_list = MatchList, 
                                result_list = FinalList,
                                bucket_rank_list = RankList
                               }}
            end
    end;

handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(Reason, #state{match_list = MatchList}) ->
    ?WARNING_MSG("Reason: ~p", [Reason]),
    write_db_by_sn(MatchList),
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

check_init_time(_Now, _Last) ->
    false.

get_league_apply_info_table(DbSn) ->
    list_to_atom(lists:concat([league_apply_info, "_", DbSn])).

init_read_all_data() ->
    DbSnList = server_misc:mnesia_sn_list(),
    lists:foldl(fun(DbSn, AccList) ->
                        AllKeys = 
                            hdb:dirty_all_keys(get_league_relation_table(DbSn)),
                        LeagueRelationList = 
                            hdb:dirty_read_list(get_league_relation_table(DbSn), AllKeys),
                        lists:foldl(fun(L, Acc) ->
                                            L ++ Acc
                                    end, AccList, LeagueRelationList)
                end, [], DbSnList).

read_all_data() ->
    DbSnList = server_misc:mnesia_sn_list(),
    lists:foldl(fun(DbSn, OldGbTrees) ->
                        LeagueRelationTable = get_league_relation_table(DbSn),
                        AllKeys = 
                            hdb:dirty_all_keys(LeagueRelationTable),
                        LeagueRelationInfo = 
                            hdb:dirty_read_list(LeagueRelationTable, AllKeys),
                        LeagueRelationList = 
                            lists:foldl(fun(L, Acc) ->
                                                L ++ Acc
                                        end, [], LeagueRelationInfo),
                        lists:foldl(fun(R, AccGbTrees) -> 
                                            %% 机器人假工会兼容, 解决不同服出现相同的 league_id
                                            case gb_trees:lookup(R#league_relation.league_id, AccGbTrees) of
                                                none ->
                                                    gb_trees:insert(R#league_relation.league_id, R, AccGbTrees);                                     
                                                Other ->
                                                    ?WARNING_MSG("Other: ~p", [Other]),
                                                    hdb:dirty_delete(LeagueRelationTable, R#league_relation.league_id),
                                                    AccGbTrees
                                            end
                                    end, OldGbTrees, LeagueRelationList)
                end, gb_trees:empty(), DbSnList).

get_league_table(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    list_to_atom(lists:concat([league, "_", DbSn])).   

%% 计算敌我双方最后结果
count_all_data(DataGbTree) ->
    count_all_data1(DataGbTree, []).

count_all_data1(DataGbTree, Acc) ->
    case gb_trees:is_empty(DataGbTree) of
        true ->
            Acc;
        false ->
            {LeagueId, LeagueRelation} = gb_trees:smallest(DataGbTree),
            case LeagueRelation#league_relation.not_enemy of
                true -> %% 处理轮空数据
                    NewDataGbTree = gb_trees:delete(LeagueId, DataGbTree),
                    NewLeague = count_all_data2(LeagueRelation),
                    count_all_data1(NewDataGbTree, [NewLeague | Acc]);
                false ->
                    EnemyLeagueId = LeagueRelation#league_relation.enemy_league_id,
                    NDataGbTree = gb_trees:delete(LeagueId, DataGbTree),
                    case gb_trees:lookup(EnemyLeagueId, NDataGbTree) of
                        none -> %% 防止出现错误数据
                            %?WARNING_MSG("count_all_data error LeagueId: ~p, Sn: ~p", [EnemyLeagueId, LeagueRelation#league_relation.enemy_league_sn]),
                            count_all_data1(NDataGbTree, [LeagueRelation | Acc]);
                        {_, EnemyLeagueRelation} ->
                            NewDataGbTree = gb_trees:delete(EnemyLeagueId, NDataGbTree),
                            LeagueList = count_all_data2(LeagueRelation, EnemyLeagueRelation),
                            count_all_data1(NewDataGbTree, LeagueList ++ Acc)
                    end
            end
    end.

%% 轮空奖励
count_all_data2(#league_relation{
                   league_id = LeagueId,
                   league_sn = LeagueSn,
                   league_thing = LeagueThing,
                   league_score = Score,
                   fight_record = FightList
                  } = LeagueRelation) ->
    case hdb:dirty_read(get_league_table(LeagueSn), LeagueId) of
        [] ->
            %?WARNING_MSG("count_all_data2 league error !!!! league_id: ~p", [LeagueId]),
            LeagueRelation;
        #league{cur_num = MemberNum} ->
            LeagueRelation#league_relation{
              %% 这里有策划给的奖励坑 !! 后期或修改
              league_thing = MemberNum * LeagueThing * 2,
              not_enemy = true,
              %% 积分按照一次胜
              league_score = Score + ?FIGHT_WIN_INTEGRAL,
              fight_record = [?FIGHT_WIN_TYPE | FightList]
             }
    end.

count_all_data2(League, EnemyLeague) ->
    LeagueThing = League#league_relation.league_thing,
    LeaguePoint = League#league_relation.league_point,
    AbilitySum = League#league_relation.ability_sum,
    EnemyLeagueThing = EnemyLeague#league_relation.league_thing,
    EnemyLeaguePoint = EnemyLeague#league_relation.league_point,
    EnemyAbilitySum = EnemyLeague#league_relation.ability_sum,
    
    %LeagueValue = LeagueThing * lists:nth(LeaguePoint, ?POINT_LIST),
    LeagueValue =
        if
            LeaguePoint =:= ?POINT_ZERO ->
                LeagueThing;
            true -> 
                %% 向下取整
                LeagueThing * lists:nth(LeaguePoint, ?POINT_LIST) div 10
        end,
    %EnemyLeagueValue = EnemyLeagueThing * lists:nth(EnemyLeaguePoint, ?POINT_LIST),
    EnemyLeagueValue =
        if
            EnemyLeaguePoint =:= ?POINT_ZERO ->
                EnemyLeagueThing;
            true -> 
                %% 向下取整
               EnemyLeagueThing * lists:nth(EnemyLeaguePoint, ?POINT_LIST) div 10
        end,
    ?WARNING_MSG("LeagueValue: ~p, EnemyLeagueValue: ~p", [LeagueValue, EnemyLeagueValue]),
    ?DEBUG("League AbilitySum: ~p, EnemyAbilitySum: ~p", [AbilitySum, EnemyAbilitySum]),
    if
        LeagueValue =:= EnemyLeagueValue andalso LeagueValue =:= 0 ->
            ?DEBUG("LeagueValue: ~p", [LeagueValue]),
            [count_fail(League), count_fail(EnemyLeague)];
        LeagueValue =:= EnemyLeagueValue ->
            if
                %% 如果公会获取物资相等, 则再按照战斗力低取胜 
                AbilitySum > EnemyAbilitySum ->
                    ?DEBUG("League AbilitySum: ~p, EnemyAbilitySum: ~p", [AbilitySum, EnemyAbilitySum]),
                    [count_fail(League), count_success(EnemyLeague)];
                true ->
                    ?DEBUG("EnemyLeague"),
                    [count_success(League), count_fail(EnemyLeague)]
            end;
        LeagueValue > EnemyLeagueValue ->
            [count_success(League), count_fail(EnemyLeague)];
        true ->
            [count_fail(League), count_success(EnemyLeague)]
    end.

%% 失败者计算
count_fail(#league_relation{
              fight_record = FightList,
              league_score = LeagueScore
             } = League) ->
    FailNum = traverse_list(FightList, ?FIGHT_FAIL_TYPE),
    NLeagueScore = 
        if
            FailNum =:= 1 -> %% 只输一场
                LeagueScore - ?FIGHT_FAIL_INTEGRAL;
            FailNum > ?FIVE_FIGHT_FAIL -> %% 连输 5 场以上
                LeagueScore - ?FIGHT_FAIL_INTEGRAL - ?FIVE_FIGHT_FAIL;
            true -> %% 连输 5 场以内
                LeagueScore - ?FIGHT_FAIL_INTEGRAL - FailNum
        end,
    NewLeagueScore = 
        if
            NLeagueScore < 0 ->
                0;
            true ->
                NLeagueScore
        end,
    League#league_relation{
      fight_record = [?FIGHT_FAIL_TYPE | FightList],
      league_score = NewLeagueScore
     }.

%% 胜利者计算
count_success(#league_relation{
                 fight_record = FightList,
                 league_score = LeagueScore
                } = League) ->
    WinNum = traverse_list(FightList, ?FIGHT_WIN_TYPE),
    NewLeagueScore = 
        if
            WinNum =:= 1 -> %% 只胜一场
                LeagueScore + ?FIGHT_WIN_INTEGRAL;
            WinNum > ?TEN_FIGHT_SUCCESS -> %% 连胜 10 场以上
                LeagueScore + ?FIGHT_WIN_INTEGRAL + ?TEN_FIGHT_SUCCESS;
            true -> %% 连胜 10 场以内
                LeagueScore + ?FIGHT_WIN_INTEGRAL + WinNum
        end,
    League#league_relation{
      fight_record = [?FIGHT_WIN_TYPE | FightList],
      league_score = NewLeagueScore
     }.

traverse_list(FightList, Type) ->
    traverse_list1(FightList, Type, 1).

traverse_list1([], _, Count) ->
    Count;
traverse_list1([Type | T], Type, Count) ->
    traverse_list1(T, Type, Count + 1);
traverse_list1(_, _, Count) ->
    Count.

%% 结算数据由服进行分类
data_separate_by_sn([]) ->
    [];
data_separate_by_sn(ResultList) ->
    NResultList = 
        lists:sort(fun(X, Y) ->
                           X#league_relation.league_sn < Y#league_relation.league_sn
                   end, ResultList),
    [#league_relation{league_sn = FirstSn} | _] = NResultList,
    {{LastSn, LastAcc}, LastAccList} = 
        lists:foldl(fun(#league_relation{
                           league_sn = LeagueSn
                          } = Record, {{Sn, Acc}, AccList}) ->
                            if
                                LeagueSn =:= Sn ->
                                    {{Sn, [Record | Acc]}, AccList};
                                true ->
                                    {{LeagueSn, [Record]}, [{Sn, Acc} | AccList]}
                            end
                    end, {{FirstSn, []}, []}, NResultList),
    [{LastSn, LastAcc} | LastAccList].

%% 按照积分进行排序 从大到小排序, 若积分相等,则再按照战斗力排序 从大到小排序
sort_by_score(ResultList) ->
    lists:sort(fun(X, Y) when X#league_relation.league_score < Y#league_relation.league_score ->
                       true;
                  (X, Y) when X#league_relation.league_score =:= Y#league_relation.league_score ->
                       X#league_relation.ability_sum < Y#league_relation.ability_sum;
                  (_, _) ->
                       false
               end, ResultList).

merge_apply_info() ->
    DbSnList = server_misc:mnesia_sn_list(),
    lists:foldl(fun(DbSn, AccList) ->
                        AllKeys = 
                            hdb:dirty_all_keys(get_league_apply_info_table(DbSn)),
                        List = 
                            hdb:dirty_read_list(get_league_apply_info_table(DbSn), AllKeys),
                        ?DEBUG("merge_apply_info  List: ~p", [List]),
                        hdb:dirty_delete_list(get_league_apply_info_table(DbSn), AllKeys),
                        lists:foldl(fun(L, Acc) ->
                                            NL = lists:foldl(fun(LeagueApplyInfo, NAcc) ->
                                                                     get_apply_info(LeagueApplyInfo) ++ NAcc
                                                             end, [], L),
                                            NL ++ Acc
                                    end, AccList, List)
                end, [], DbSnList).

get_apply_info(#league_apply_info{
                  league_id = LeagueId,
                  league_sn = LeagueSn,
                  ability_sum = AbilitySum
                 }) ->
    case hdb:dirty_read(get_league_table(LeagueSn), LeagueId) of
        [] ->
            ?WARNING_MSG("LeagueId Over Time ... "),
            [];
        #league{
           cur_num = CurNum,
           max_num = MaxNum,
           %ability_sum = AbilityNum,
           name = LeagueName,
           lv = LeagueLv
          } ->            
            [#league_relation{
                league_id = LeagueId,
                league_sn = LeagueSn,
                cur_num = CurNum,
                max_num = MaxNum,
                ability_sum = AbilitySum,
                league_name = LeagueName,
                league_lv = LeagueLv
               }]
    end.

%% 重新定制匹配关系
reset_match(ResultList) ->
    NewResultList = 
        lists:foldl(fun(#league_relation{
                           league_id = LeagueId,
                           league_sn = LeagueSn
                          } = LeagueRelation, Acc) ->
                            case hdb:dirty_read(get_league_table(LeagueSn), LeagueId) of
                                [] ->
                                    Acc;
                                #league{
                                   cur_num = CurNum,
                                   lv = LeagueLv,
                                   %ability_sum = AbilityNum,
                                   league_group = LeagueGroup
                                  } ->
                                    [LeagueRelation#league_relation{
                                       league_group = LeagueGroup,
                                       league_lv = LeagueLv,
                                       %ability_sum = AbilityNum,
                                       cur_num = CurNum
                                      } | Acc]
                            end
                    end, [], ResultList),
    reset_match(NewResultList, []).

reset_match([], AccList) ->
    AccList;
reset_match([League], AccList) ->
    %% 处理轮空数据
    NewLeague = reset_data(League), 
    [NewLeague | AccList];
reset_match([League, EnemyLeague | T], AccList) ->
    NewLeague = reset_data(League, EnemyLeague),
    NewEnemyLeague = reset_data(EnemyLeague, League),
    reset_match(T, [NewLeague, NewEnemyLeague | AccList]).

reset_data(League) ->
    League#league_relation{
      not_enemy = true  %% 被轮空
     }.

reset_data(League, EnemyLeague) ->
    EnemyLeagueId = EnemyLeague#league_relation.league_id,
    EnemyLeagueSn = EnemyLeague#league_relation.league_sn,
    League#league_relation{
      enemy_league_id = EnemyLeagueId,
      enemy_league_sn = EnemyLeagueSn,
      not_enemy = false,
      league_thing = 0,
      league_point = 0
     }.

%% 重新定制全服排行榜 段位从高到低, 积分从大到小, 名次从小到大
reset_league_rank(ResultList) ->
    %?WARNING_MSG("ResultList: ~p", [lists:reverse(ResultList)]),
    reset_league_rank1(lists:reverse(ResultList), ?GROUP_LIST, [], [], []).

reset_league_rank1([], [_|GT] = _GroupList, DataList, BucketList, OldDataList) ->
    {RankDict, AddDataList} = new_rank_bucket(DataList),
    NBucketList = 
        lists:map(fun(_) ->
                          {RBL, _} = new_rank_bucket([]),
                          RBL
                  end, GT),
    NewDataList = AddDataList ++ OldDataList,
    {NBucketList ++ [RankDict | BucketList], NewDataList};   

reset_league_rank1([RH|RT] = ResultList, [GH|GT] = GroupList, DataList, BucketList, OldDataList) ->
    case RH#league_relation.league_score >= GH of
        true ->
            reset_league_rank1(RT, GroupList, [RH | DataList], BucketList, OldDataList);
        false ->
            %?WARNING_MSG("DataList: ~p", [DataList]),
            {RankDict, AddDataList} = new_rank_bucket(DataList),
            NewDataList = AddDataList ++ OldDataList,
            reset_league_rank1(ResultList, GT, [], [RankDict | BucketList], NewDataList)
    end.

new_rank_bucket(DataList) ->
    {BucketList, _, NewDataList} = 
        lists:foldl(fun(LeagueRelation, {AccBucket, RankCount, AccList}) ->
                            NewLeagueReleation = LeagueRelation#league_relation{
                                                   league_rank = RankCount
                                                  },
                            NewAccList = [NewLeagueReleation | AccList],
                            NewAccBucket = 
                                bucket_misc:insert(RankCount, NewLeagueReleation, AccBucket),
                            {NewAccBucket, RankCount+1, NewAccList}
                    end, {bucket_misc:new(?SEND_LEAGUE_COUNT), 1, []}, lists:reverse(DataList)),
    {BucketList, NewDataList}.

get_league_relation_table(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    list_to_atom(lists:concat([league_relation, "_", DbSn])).

%% 匹配好的数据保存致分服表
write_db_by_sn(MatchList) ->
    lists:map(fun({Sn, LeagueRelationInfo}) -> 
                      WriteTable = get_league_relation_table(Sn),
                      hdb:dirty_write(WriteTable, LeagueRelationInfo)
              end, MatchList).

reset_member_challenge() -> 
    mod_league_reward:reset_member_challenge().

clear_challenge_record_table() ->
    hdb:clear_table(league_challenge_record).

fight_win_reward() ->
    mod_league_reward:fight_win_reward().

%% reset_point_table() ->
%%     mod_league_reward:reset_point_table().

get_reward_processname_by_sn(Sn) ->
    list_to_atom(lists:concat([mod_league_reward, "_", Sn])).

%% 将计算的结果分发给各个服
send_result_by_sn(FinalList) ->
    lists:map(fun({Sn, DataList}) ->
                      ProcessName = get_reward_processname_by_sn(Sn),
                      mod_league_reward:update_league_data(ProcessName, DataList)
              end, FinalList).

%% 更新所有服的排行榜
update_rank_data(RankList) ->
    mod_league_rank:update_rank_data(RankList).


do_season_end() ->
    ServerCount = length(server_misc:mnesia_sn_list()),
    lists:map(fun(SN) ->
                      hdb:clear_table(list_to_atom(lists:concat([league_apply_info, "_", SN]))),
                      hdb:clear_table(list_to_atom(lists:concat([league_member_challenge, "_", SN]))),
                      hdb:clear_table(list_to_atom(lists:concat([league_relation, "_", SN])))
              end, lists:seq(1, ServerCount)),
    hdb:clear_table(league_challenge_record),
    hdb:clear_table(league_fight_point),
    %% hdb:clear_table(league_member_challenge),
    %% hdb:clear_table(league_challenge_record),
    hdb:clear_table(mdb_challenge_info),    
    reset_flag(),
    
    ok.

reset_flag() ->
    ServerCount = length(server_misc:mnesia_sn_list()),
    lists:map(fun(SN) ->
                      LeagueList = hdb:tab2list(list_to_atom(lists:concat([league, "_", SN]))),
                      lists:map(fun(League) ->
                                        case League of
                                            League when is_record(League, league) ->
                                                hdb:dirty_write(list_to_atom(lists:concat([league, "_", SN])), League#league{apply_league_fight = 0
                                                                                                                             });
                                            _ ->
                                                ignored
                                        end
                                end, LeagueList)
              end, lists:seq(1, ServerCount)).


do_daily_reward() ->
    ServerCount = length(server_misc:mnesia_sn_list()),
    lists:map(fun(SN) ->
                      LeagueList = hdb:tab2list(list_to_atom(lists:concat([league_relation, "_", SN]))),
                      lists:map(fun(League) ->
                                        case League of
                                            #league_relation{
                                               league_id = LeagueId,
                                               league_score = Score
                                              } ->
                                                Rewards = get_daily_reward(Score),
                                                Mail = lib_mail:mail(?SYSTEM_NAME, <<"军团战每日工资"/utf8>>, <<"">>, Rewards),

                                                Members = lib_league:get_league_member_list(LeagueId),
                                                PlayerIds = lists:map(fun(Member) ->
                                                                              element(#league_member.player_id, Member)
                                                                      end, Members),
                                                lib_mail:send_mail(PlayerIds, Mail),
                                                ok;
                                            _ ->
                                                ignored
                                        end
                                end, LeagueList)
              end, lists:seq(1, ServerCount)),
    ok.

get_daily_reward(Score) ->
    Group = lib_league_fight:get_group_by_score(Score),
    case data_base_guild_rank_integral:get(Group) of
        [] ->
            [];
        #base_guild_rank_integral{rank_wage = Wage
                                 }->
            [{?GOODS_TYPE_LEAGUE_SEAL, Wage}]
    end.

do_auto_defend() ->
    %% ServerCount = length(server_misc:mnesia_sn_list()),
    %% lists:map(fun(SN) ->
    %%                   LeagueList = hdb:tab2list(list_to_atom(lists:concat([league_relation, "_", SN]))),
    %%                   lists:map(fun(League) ->
    %%                                     case League of
    %%                                         #league_relation{
    %%                                            league_id = LeagueId,
    %%                                            league_group = Group
    %%                                           } ->
    %%                                             Rewards = get_daily_reward(Group),
    %%                                             Mail = lib_mail:mail(?SYSTEM_NAME, <<"军团战每日工资"/utf8>>, <<"">>, Rewards),

    %%                                             Members = lib_league:get_league_member_list(LeagueId),
    %%                                             PlayerIds = lists:map(fun(Member) ->
    %%                                                                           element(#league_member.player_id, Member)
    %%                                                                   end, Members),
    %%                                             lib_mail:send_mail(PlayerIds, Mail),
    %%                                             ok;
    %%                                         _ ->
    %%                                             ignored
    %%                                     end
    %%                             end, LeagueList)
    %%           end, lists:seq(1, ServerCount)),
    ok.

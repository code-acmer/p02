%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@moyou.me>
%%% @copyright (C) 2015, liu
%%% @doc
%%% 跨服竞技场的主进程模块，初始化分组(顺带管理team_pvp进程)
%%% @end
%%% Created :  4 Mar 2015 by liu <liuzhigang@moyou.me>
%%%-------------------------------------------------------------------
-module(mod_cross_pvp).

-behaviour(gen_server).

-include("define_mnesia.hrl").
-include("define_cross_pvp.hrl").
-include("define_time.hrl").
-include("define_logger.hrl").
-include("define_player.hrl").
-include("db_base_kuafupvp_robot_attribute.hrl").
-include("define_try_catch.hrl").
-include("define_server.hrl").

%% API
-export([start_link/1]).
-export([
         %% get_workd_pid/1, 
         sign_up/0,
         build_islands/0,
         join_special_team/2, 
         get_robot_id/1,
         daily_clean_up/0,
         reset_event_timestamp/1,
         update_player/1,
         reset_island/2
        ]).
%% -export([get_team/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).


-record(state, {worker = 0}).

%%%===================================================================
%%% API
%%%===================================================================

%%
process_name(WorkerId) ->
    %% Pname = hmisc:create_process_name(?MODULE, [WorkerId]),
    ProcName = server_app:get_proc_name(?MODULE, WorkerId),
    {n, g, ProcName}.

%% 根据playerid进行哈希，稳定指定特别进程
get_workd_pid(PlayerId) ->
    WorkerId = (PlayerId rem ?CROSS_PVP_WORKER_NUM) + 1,
    case gproc:where(process_name(WorkerId)) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            []
    end.

get_main_pid() ->
    case gproc:where(process_name(0)) of
        Pid when is_pid(Pid) ->
            Pid; 
        _ ->
            []
    end.

do_join_pvp(Player) ->
    case get_workd_pid(Player#player.id) of
        [] ->
            ignored;
        Pid ->
            gen_server:cast(Pid, {cmd_do_join_pvp, Player})
    end.

do_build_island(Fighter) ->
    case get_workd_pid(Fighter#cross_pvp_fighter.player_id) of
        [] ->
            ignored;
        Pid ->
            gen_server:cast(Pid, {cmd_do_build_island, Fighter})
    end.

do_delete(PlayerId) ->
    case get_workd_pid(PlayerId) of
        [] ->
            ignored;
        Pid ->
            gen_server:cast(Pid, {cmd_do_delete, PlayerId})
    end.

update_player(#player{id = PlayerId} = Player) ->
    case get_workd_pid(PlayerId) of
        [] ->
            ignored;
        Pid ->
            gen_server:cast(Pid, {cmd_do_update_player, Player})
    end.

build_islands() ->
    Pid = get_main_pid(),
    gen_server:cast(Pid, cmd_build_islands).

%% 全服报名
sign_up() ->
    Pid = get_main_pid(),
    gen_server:cast(Pid, cmd_do_sign_up).

join_special_team(Player, Type) ->
    case mod_cross_pvp_center:pid(Player#player.id) of
        [] ->
            skip;
        Pid ->
            gen_server:cast(Pid, {join_special_team, Player, Type})
    end.

daily_clean_up() ->
    Pid = get_main_pid(),
    gen_server:cast(Pid, cmd_daily_clean_up).

reset_event_timestamp(PlayerId) ->
    Pid = get_workd_pid(PlayerId),
    gen_server:cast(Pid, {cmd_reset_event_timestamp, PlayerId}).

reset_island(PlayerId, IslandId) ->
    Pid = get_workd_pid(PlayerId),
    gen_server:cast(Pid, {cmd_do_reset_island, PlayerId, IslandId}).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(WorkerId) ->
    gen_server:start_link({via, gproc, process_name(WorkerId)}, ?MODULE, [WorkerId], []).

init([WorkerId]) ->
    %% ?DEBUG("WorkerId : ~p~n", [WorkerId]),
    case WorkerId of
        0 ->
            gen_server:cast(self(), cmd_init);
        _->
            ignored
    end,
    {ok, #state{worker = WorkerId}}.

handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).
handle_cast(Cmd, State) ->
    ?DO_HANDLE_CAST(Cmd, State).
handle_info(Cmd, State) ->
    ?DO_HANDLE_INFO(Cmd, State).


do_handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

do_handle_cast(cmd_init, State) ->
    %% Now = time_misc:unixtime(),
    %% NextTimeStart = get_next_start_seconds(Now) + ?TEN_MINITE_SECONDS, %% 给10分钟发奖励(考虑看child是否全关闭)
    %% erlang:send_after(NextTimeStart * 1000, self(), end_sign),
    %% init_team(Now),
    {noreply, State};
do_handle_cast(cmd_build_islands, State) ->
    hdb:dirty_foldl(fun(#cross_pvp_fighter{} = Fighter, null) ->
                            do_build_island(Fighter),
                            null
                    end, null, cross_pvp_fighter),
    {noreply, State};
do_handle_cast({cmd_do_build_island, Fighter}, State) ->
    lib_cross_pvp:build_islands(Fighter),
    {noreply, State};
do_handle_cast(cmd_do_sign_up, State) ->
    do_sign_up(),
    {noreply, State};
do_handle_cast({cmd_do_join_pvp, Player}, State) ->
    lib_cross_pvp:do_join_pvp(Player),
    {noreply, State};
do_handle_cast(cmd_daily_clean_up, State) ->
    Now = time_misc:unixtime(),
    hdb:dirty_foldl(fun(Fighter, null) ->
                            Timestamp = element(#cross_pvp_fighter.timestamp, Fighter),
                            if
                                Now > (Timestamp + 3* ?ONE_DAY_SECONDS) ->
                                    do_delete(element(#cross_pvp_fighter.player_id, Fighter)),
                                    null;
                                true -> 
                                    null
                            end
                    end, null , cross_pvp_fighter),
    {noreply, State};
do_handle_cast({cmd_do_delete, PlayerId}, State) ->
    lib_cross_pvp:delete_cross_pvp_fighter(PlayerId),
    {noreply, State};
do_handle_cast({cmd_reset_event_timestamp, PlayerId}, State) ->
    lib_cross_pvp:reset_event_timestamp(PlayerId),
    {noreply, State};
do_handle_cast({cmd_do_update_player, Player}, State) ->
    lib_cross_pvp:update_player(Player),
    {noreply, State};
do_handle_cast({cmd_do_reset_island, PlayerId, IslandId}, State) ->
    lib_cross_pvp:reset_island_occupy_timestamp(PlayerId, IslandId),
    {noreply, State};
do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(end_sign, State) ->
    ?WARNING_MSG("end sign begin ~n", []),
    %% send_last_reward(), %%结算上一轮的结果
    %% timer:sleep(1000),
    %% %%hdb:clear_table(cross_pvp_team),  %%不能删除，因为还有用
    %% %% make_team(),
    %% hdb:clear_table(cross_pvp_report),
    ?WARNING_MSG("end sign over ~n", []),
    {noreply, State};
do_handle_info(_Info, State) ->
    {noreply, State}.

terminate(Reason, _State) ->
    ?WARNING_MSG("~p terminate Reason ~p~n", [?MODULE, Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% init_team(_Now) ->
%%     start_pvp_process().

%% start_pvp_process() ->
%%     {Min, Max} = get_team_num_area(),
%%     start_pvp_process2(Min, Max).
%% start_pvp_process(Min, Max) ->
%%     start_pvp_process2(Min, Max).

%% start_pvp_process2(Min, Max) ->
%%     if
%%         Max - Min =< 0 ->
%%             skip;
%%         true ->
%%             [cross_pvp_sup:start_child(Num) || Num <- lists:seq(Min, Max)]
%%     end.

%% 全服报名参战
do_sign_up() ->
    Now = time_misc:unixtime(),
    hdb:dirty_foldl(fun(#player{timestamp_logout = TimestampLogout,
                                lv = Lv
                               } = Player, _) ->
                            if
                                TimestampLogout + 3*?ONE_DAY_SECONDS > Now 
                                andalso Lv >= 1 ->
                                    do_join_pvp(Player);
                                true -> 
                                    null
                            end
                    end, null, player),
    ok.

%% get_next_start_seconds(Now) ->    
%%     EndSign = lib_cross_pvp:pvp_time(Now, ?SIGN_END_TIME), %%报名结束的时候准备开进程了
%%     if
%%         Now >= EndSign ->
%%             EndSign + ?ONE_DAY_SECONDS - Now;
%%         true ->
%%             EndSign - Now
%%     end.

%% send_last_reward() ->
%%     Fun = 
%%         fun(ChildPid) ->
%%                 MRef = erlang:monitor(process, ChildPid),
%%                 ChildPid ! match_over,
%%                 MRef
%%         end,
%%     Mrefs = [Mref || Mref <- cross_pvp_sup:broadcast_all_child(Fun)],
%%     [receive
%%          {'DOWN', MRef, process, _, normal} ->
%%              erlang:demonitor(MRef, [flush]),
%%              ok;
%%          {'DOWN', MRef, process, _, Reason} -> 
%%              erlang:demonitor(MRef, [flush]),
%%              exit(Reason)
%%      end || {_Pid, MRef} <- Mrefs],
%%     ok.

%% new_team(Player, TeamNum, Type) ->
%%     trans_team_to_now([Player], TeamNum, Type),
%%     cross_pvp_sup:start_child(TeamNum).
    
%% new_team(Player, TeamNum, Type) ->
%%     write_player_to_team(Player, TeamNum, 1),
%%     hdb:dirty_write(cross_team_player_count,
%%                     #cross_team_player_count{team_id = TeamNum,
%%                                              team_type = Type,
%%                                              avg_ability = element(#player.high_ability, Player),
%%                                              num = 1}),
%%     cross_pvp_sup:start_child(TeamNum).

%% inner_join_special_team(Player, Type) ->
%%     {MinTeamNum, MaxTeamNum} = get_team_num_area(),
%%     case join_special_team_2(Player, Type, MinTeamNum, MaxTeamNum) of
%%         true ->
%%             true;
%%         false ->
%%             NewNum = get_next_team_num(),
%%             if
%%                 MinTeamNum =:= 0 ->
%%                     hdb:dirty_write(server_config, #server_config{k = ?CROSS_PVP_MAX_TEAM_NUM, v = NewNum});
%%                 true ->
%%                     skip
%%             end,
%%             new_team(Player, NewNum, Type)
%%     end.

%% join_special_team_2(_, _, 0, 0) ->
%%     skip;
%% join_special_team_2(_, _, Counter, TeamCount) 
%%   when Counter > TeamCount->
%%     false;
%% join_special_team_2(Player, Type, Counter, TeamCount) ->
%%     case hdb:dirty_read(cross_team_player_count, Counter) of
%%         [] ->
%%             ?WARNING_MSG("team ~p not found cross_team_player_count ~n", [Counter]),
%%             join_special_team_2(Player, Type, Counter + 1, TeamCount);
%%         #cross_team_player_count{num = NowNum,
%%                                  team_type = TeamType}
%%           when NowNum < ?EVERY_TEAM_NUM
%%                andalso TeamType =:= Type ->
%%             case may_join_team(Player, Counter) of
%%                 false ->
%%                     join_special_team_2(Player, Type, Counter + 1, TeamCount);
%%                 true ->
%%                     true
%%             end;
%%         _ ->
%%             join_special_team_2(Player, Type, Counter + 1, TeamCount)
%%     end.

%% may_join_team(#player{id = PlayerId} = Player, Counter) -> %%counter 就是队伍编号
%%     case hdb:dirty_index_read(cross_pvp_team, Counter, #cross_pvp_team.team_num) of
%%         [] ->
%%             ?WARNING_MSG("team ~p find no people ~n", [Counter]),
%%             false;
%%         TeamPlayerList ->
%%             case check_player_ability(TeamPlayerList, Player#player.high_ability) of
%%                 true ->
%%                     mod_team_pvp:new_member(Counter, PlayerId),
%%                     Member = write_player_to_team(Player, Counter, length(TeamPlayerList) + 1),
%%                     write_team_info_1(Counter, [Member|TeamPlayerList]),
%%                     true;
%%                 false ->
%%                     false
%%             end
%%     end.

%% check_player_ability([], _Ability) ->
%%     true;
%% check_player_ability([TeamMember|Tail], Ability) ->
%%     TeamMemberAbility = TeamMember#cross_pvp_team.battle_ability,
%%     case if_in_ability(TeamMemberAbility, Ability) of
%%         true ->
%%             check_player_ability(Tail, Ability);
%%         false ->
%%             false
%%     end.
    



%% make_player_team(#cross_pvp_fighter{player_id = PlayerId} = CrossPvpFighter) ->
%%     case lib_cross_pvp:get_enemeies(PlayerId) of
%%         [] ->
%%             [];
%%         Enemies ->
%%             ok
%%     end,
%%     ok.



%% write_player_list_to_team(_TeamNum, []) ->
%%     skip;
%% write_player_list_to_team(TeamNum, MemberList) ->
%%     write_team_info_1(TeamNum, MemberList),
%%     lists:foldl(fun(Member, Rank) ->
%%                         write_player_to_team(Member, TeamNum, Rank),
%%                         Rank + 1
%%                 end, 1, lists:sort(fun(Player1, Player2) ->
%%                                            element(#player.high_ability, Player1) >
%%                                                element(#player.high_ability, Player2)
%%                                    end, MemberList)).
       
%% write_player_to_team(#player{id = PlayerId,
%%                              nickname = Name,
%%                              career = Career,
%%                              sn = Sn,
%%                              battle_ability = Ability}, TeamNum, Rank) ->
%%     Team = #cross_pvp_team{player_id = PlayerId,
%%                            name = Name,
%%                            career = Career,
%%                            sn = Sn,
%%                            battle_ability = Ability,
%%                            team_num = TeamNum,
%%                            left_times = ?DEFAULT_LEFT_TIMES,
%%                            rank = Rank
%%                           },
%%     hdb:dirty_write(cross_pvp_team, Team),
%%     Team;

%% write_player_to_team(Player, TeamNum, Rank) ->
%%     Team = #cross_pvp_team{player_id = element(#player.id, Player),
%%                            name = element(#player.nickname, Player),
%%                            career = element(#player.career, Player),
%%                            sn = element(#player.sn, Player),
%%                            battle_ability = element(#player.battle_ability, Player),
%%                            team_num = TeamNum,
%%                            left_times = ?DEFAULT_LEFT_TIMES,
%%                            rank = Rank
%%                           },
%%     hdb:dirty_write(cross_pvp_team, Team),
%%     Team.

%%--------------------开始分组--------------------------%%
%% make_team() ->
%%     {MinNum, MaxNum} = get_team_num_area(),
%%     handle_last_turn(MinNum, MaxNum),  %%这里是要处理上一轮的组队信息(已经是merge过了，存在的老组都有team_info，其他都删了)
%%     %%记得要维护min_team, max_team
%%     NewBeginTeamNum = init_begin_team_num(),
%%     MaxTeamNum = handle_now_turn(MinNum, MaxNum, NewBeginTeamNum), %%本次分组的处理
%%     ?DEBUG("NewBeginTeamNum ~p, MaxTeamNum ~p~n", [NewBeginTeamNum, MaxTeamNum]),
%%     %%写新的队伍信息
%%     %%hdb:clear_table(cross_team_player_count),
%%     delete_last_team_info(MinNum, MaxNum),
%%     %%写counter
%%     hdb:dirty_write(server_config, #server_config{k = ?CROSS_PVP_MIN_TEAM_NUM, v = NewBeginTeamNum}),
%%     lib_counter:write_new_counter(cross_pvp_team_uid, MaxTeamNum),
%%     hdb:dirty_write(server_config, #server_config{k = ?CROSS_PVP_MAX_TEAM_NUM, v = MaxTeamNum}),
%%     new_round(),
%%     start_pvp_process(NewBeginTeamNum, MaxTeamNum).

%% handle_last_turn(0, 0) ->
%%     skip;
%% handle_last_turn(TeamNum, MaxNum) when TeamNum > MaxNum ->
%%     skip;
%% handle_last_turn(TeamNum, MaxNum) ->
%%     case hdb:dirty_read(cross_team_player_count, TeamNum, true) of
%%         #cross_team_player_count{team_type = ?TEAM_TYPE_NORMAL} ->
%%             NewTeamNum = handle_last_team(TeamNum),
%%             handle_last_turn(NewTeamNum, MaxNum);
%%         _ ->
%%             %%删除其他组的信息
%%             delete_team_list(hdb:dirty_index_read(cross_pvp_team, TeamNum, #cross_pvp_team.team_num)),
%%             delete_team_info(TeamNum),
%%             %%?DEBUG("TeamNum ~p MaxNum ~p~n", [TeamNum, MaxNum]),
%%             handle_last_turn(TeamNum + 1, MaxNum)
%%     end.

%% handle_last_team(TeamNum) ->
%%     case hdb:dirty_index_read(cross_pvp_team, TeamNum, #cross_pvp_team.team_num) of
%%         [] ->
%%             ?WARNING_MSG("not found cross_pvp_team ~p~n", [TeamNum]),
%%             delete_team_info(TeamNum),
%%             TeamNum + 1;
%%         TeamList ->
%%             {RestTeam, RestNum, AccAbility} = check_team_ability(TeamList),
%%             AvgAbility = 
%%                 if
%%                     RestNum =:= 0 ->
%%                         0;
%%                     true ->
%%                         AccAbility div RestNum
%%                 end,
%%             if
%%                 RestNum >= ?MIN_KEEP_TEAM_NUM ->
%%                     hdb:dirty_write(cross_team_player_count, 
%%                                     #cross_team_player_count{team_id = TeamNum,
%%                                                              num = RestNum,
%%                                                              avg_ability = AvgAbility
%%                                                             }),
%%                     TeamNum + 1;
%%                 RestNum >= ?MIN_MERGE_TEAM_NUM ->
%%                     may_merge(TeamNum + 1, RestNum, AvgAbility),
%%                     TeamNum + 2;
%%                 true ->
%%                     delete_team_list(RestTeam),
%%                     delete_team_info(TeamNum),
%%                     TeamNum + 1
%%             end
%%     end.

%% may_merge(TeamNum, OldNum, AvgAbility) ->
%%     case hdb:dirty_index_read(cross_pvp_team, TeamNum, #cross_pvp_team.team_num) of
%%         [] ->
%%             delete_team_info(TeamNum),
%%             false;
%%         Members ->
%%             {RestTeam, RestNum, AccAbility} = check_team_ability(Members),
%%             AvgAbility2 = 
%%                 if
%%                     RestNum =:= 0 ->
%%                         0;
%%                     true ->
%%                         AccAbility div RestNum
%%                 end,
%%             if
%%                 RestNum >= ?MIN_KEEP_TEAM_NUM ->
%%                     hdb:dirty_write(cross_team_player_count, 
%%                                     #cross_team_player_count{team_id = TeamNum,
%%                                                              num = RestNum,
%%                                                              avg_ability = AvgAbility2
%%                                                             }),
%%                     false;
%%                 RestNum >= ?MIN_MERGE_TEAM_NUM ->
%%                     case if_in_ability(AvgAbility, AvgAbility2) of
%%                         true ->
%%                             ?DEBUG("merge ~p and ~p~n", [TeamNum - 1, TeamNum]),
%%                             lists:foreach(fun(Team) ->
%%                                                   hdb:dirty_write(cross_pvp_team, Team#cross_pvp_team{team_num = TeamNum - 1})
%%                                           end, RestTeam),
%%                             AllNum = RestNum + OldNum,
%%                             hdb:dirty_write(cross_team_player_count, 
%%                                             #cross_team_player_count{team_id = TeamNum - 1,
%%                                                                      num = AllNum,
%%                                                                      avg_ability = (AccAbility + OldNum*AvgAbility) div AllNum
%%                                                                     }),
%%                             delete_team_info(TeamNum),
%%                             true;
%%                         false ->
%%                             hdb:dirty_write(cross_team_player_count, 
%%                                             #cross_team_player_count{team_id = TeamNum,
%%                                                                      num = RestNum,
%%                                                                      avg_ability = AvgAbility2
%%                                                                     }),
%%                             false
%%                     end;
%%                 true ->
%%                     delete_team_list(RestTeam),
%%                     delete_team_info(TeamNum),
%%                     false
%%             end
%%     end.

%% check_team_ability(MemberList) ->
%%     Now = time_misc:unixtime(),
%%     NewMemberList = 
%%         lists:foldl(fun
%%                         (#cross_pvp_team{is_robot = ?IS_ROBOT_1}, AccList) ->
%%                            AccList;
%%                         (#cross_pvp_team{player_id = PlayerId} = Member, AccList) ->
%%                             case hdb:dirty_read(player, PlayerId) of
%%                                 [] ->
%%                                     ?WARNING_MSG("not found player ~p~n", [PlayerId]),
%%                                     AccList;
%%                                 Player when is_tuple(Player) ->
%%                                     case Now - element(#player.timestamp_login, Player) =< ?ONE_DAY_SECONDS*3 of
%%                                         true ->
%%                                             Ability = element(#player.high_ability, Player),
%%                                             NewMember = Member#cross_pvp_team{battle_ability = Ability},
%%                                             [NewMember|AccList];
%%                                         _ ->
%%                                             AccList
%%                                     end;
%%                                  _->
%%                                     AccList
%%                             end
%%                     end, [], MemberList),
%%     check_team_ability2(NewMemberList).

%% check_team_ability2(MemberList) ->
%%     case lists:keysort(#cross_pvp_team.battle_ability, MemberList) of
%%         [] ->
%%             {[], 0, 0};
%%         [H|[]] ->
%%             {[H], 1, H#cross_pvp_team.battle_ability};
%%         [#cross_pvp_team{battle_ability = B1} = H, #cross_pvp_team{battle_ability = B2} = M] ->
%%             case if_in_ability(B1, B2) of
%%                 true ->
%%                     {[H, M], 2, B1+B2};
%%                 false ->
%%                     {[], 0, 0}
%%             end;
%%        [H|Tail] ->
%%             [T|Rest] = lists:reverse(Tail),
%%             {AllAbility, Num} = lists:foldl(fun(#cross_pvp_team{battle_ability = Ability}, {AccAbility, AccNum}) ->
%%                                                     {Ability + AccAbility, AccNum + 1}
%%                                             end, {0, 0}, Rest),
%%             AvgAbility = AllAbility div Num,
%%             {NewList, NewNum, NewAbility} = 
%%                 lists:foldl(fun(#cross_pvp_team{
%%                                    player_id = PlayerId,
%%                                    battle_ability = TarAbility} = Member, {AccList, AccNum, AccAbility}) ->
%%                                     case if_in_ability(TarAbility, AvgAbility) of
%%                                         false ->
%%                                             ?DEBUG("PlayerId ~p is out ~n", [PlayerId]),
%%                                             delete_from_team(Member),
%%                                             {AccList, AccNum, AccAbility};
%%                                         true ->
%%                                             {[Member|AccList], AccNum + 1, AccAbility + TarAbility}
%%                                     end
%%                             end, {[], 0, 0}, [H, T|Rest]),
%%             {NewList, NewNum, NewAbility}
%%     end.

%% handle_now_turn(0, 0, NewBeginTeamNum) ->
%%     {NextTeamNum, []} = handle_now_turn_1(NewBeginTeamNum, [], ?ABILITY_LIST),
%%     NextTeamNum;
%% handle_now_turn(MinNum, MaxNum, NewBeginTeamNum) ->
%%     AllTeamList = 
%%         lists:foldl(fun(TeamNum, AccList) ->
%%                             case hdb:dirty_index_read(cross_pvp_team, TeamNum, #cross_pvp_team.team_num) of
%%                                 [] ->
%%                                     AccList;
%%                                 TarList ->
%%                                     [TarList|AccList]
%%                             end
%%                     end, [], lists:seq(MinNum, MaxNum)),
%%     {NextTeamNum, NewTeamList} = handle_now_turn_1(NewBeginTeamNum, AllTeamList, ?ABILITY_LIST),
%%     MaxTeamNum = 
%%         lists:foldl(fun
%%                         ([], AccTeamNum) ->
%%                            AccTeamNum;
%%                         (MemberList, AccTeamNum) ->
%%                             trans_team_to_now(MemberList, AccTeamNum),
%%                             AccTeamNum + 1
%%                    end, NextTeamNum, NewTeamList),
%%     MaxTeamNum.
    

%% %%递归 AbilityList
%% handle_now_turn_1(NextTeamNum, AllTeamList, []) ->
%%     {NextTeamNum, AllTeamList};
%% handle_now_turn_1(NextTeamNum, AllTeamList, AbilityList) ->
%%     {PlayerList, RestAbilityList} = get_player_cache(AbilityList),
%%     ?DEBUG("PlayerList size ~p~n", [length(PlayerList)]),
%%     {NewTeamNum, NTeamList} = handle_now_turn_2(NextTeamNum, AllTeamList, PlayerList),
%%     handle_now_turn_1(NewTeamNum, NTeamList, RestAbilityList).

%% %%递归散人
%% handle_now_turn_2(NextTeamNum, AllTeamList, []) ->
%%     {NextTeamNum, AllTeamList};
%% handle_now_turn_2(NextTeamNum, AllTeamList, PlayerList) ->
%%     %%?DEBUG("AllTeamList ~p~n", [AllTeamList]),
%%     {NTeamList, NPlayerList, NewTeamNum} = 
%%         lists:foldl(fun
%%                         ([], {AccTeamList, AccPlayerList, AccTeamNum}) ->
%%                            {AccTeamList, AccPlayerList, AccTeamNum};
%%                         ([#cross_pvp_team{team_num = TeamNum}|_] = Team, {AccTeamList, AccPlayerList, AccTeamNum}) ->
%%                             Num = length(Team),

%%                             {NTeam, NNum, NPlayerList} = find_enemy(Team, Num, TeamNum, AccPlayerList),

%%                             case inner_fill_member(AccTeamNum, NTeam, NNum, TeamNum, NPlayerList) of
%%                                 {[], NewPlayerList} ->
%%                                     {AccTeamList, NewPlayerList, AccTeamNum + 1};
%%                                 {NewTeam, NewPlayerList} ->
%%                                     {[NewTeam|AccTeamList], NewPlayerList, AccTeamNum}
%%                             end
%%                    end, {[], PlayerList, NextTeamNum}, AllTeamList),
%%     ?DEBUG("size1 ~p size2 ~p~n", [length(PlayerList), length(NPlayerList)]),
%%     NewNextTeamNum = inner_handle_cache(NewTeamNum, NPlayerList),
%%     {NewNextTeamNum, NTeamList}.
    
%% %%小组拉人
%% inner_fill_member(NextTeamNum, MemberList, Num, TeamNum, PlayerList) ->
%%     inner_fill_member_1(NextTeamNum, MemberList, Num, TeamNum, PlayerList, []).

%% inner_fill_member_1(NextTeamNum, MemberList, Num, _, PlayerList, AccList) when Num >= ?EVERY_TEAM_NUM ->   %%人数填满之后就走吧
%%     trans_team_to_now(MemberList, NextTeamNum),
%%     {[], PlayerList ++ AccList};
%% inner_fill_member_1(_NextTeamNum, MemberList, _Num, _, [], AccList) ->
%%     {MemberList, AccList};
%% inner_fill_member_1(NextTeamNum, MemberList, Num, TeamNum, [H|Rest], AccList) ->
%%     case is_player_in_ability(H, MemberList) of
%%         false ->
%%             inner_fill_member_1(NextTeamNum, MemberList, Num, TeamNum, Rest, [H|AccList]);
%%         true ->
%%             NewMember = write_player_to_team(H, TeamNum, Num + 1),
%%             inner_fill_member_1(NextTeamNum, [NewMember|MemberList], Num + 1, TeamNum, Rest, AccList)
%%     end.

%% %%寻找合适的仇敌
%% find_enemy(MemberList, Num, _TeamNum, []) ->
%%     {MemberList, Num, []};
%% find_enemy(MemberList, Num, _, PlayerList) when Num >= ?EVERY_TEAM_NUM ->
%%     {MemberList, Num, PlayerList};
%% find_enemy(MemberList, Num, TeamNum, PlayerList) ->
%%     {EnemyList, RestPlayerLIst} = 
%%         lists:foldl(fun(Player, {AccEnemy, AccPlayer}) ->
%%                             case is_player_enemy(Player, MemberList) of
%%                                 false ->
%%                                     {AccEnemy, [Player|AccPlayer]};
%%                                 true ->
%%                                     {[Player|AccEnemy], AccPlayer}
%%                             end
%%                     end, {[], []}, PlayerList),
%%     {NewMemberList, NewNum, RestEnemyList} = fill_enemy_1(MemberList, Num, TeamNum, EnemyList),
%%     {NewMemberList, NewNum, RestEnemyList ++ RestPlayerLIst}.
    

%% fill_enemy_1(MemberList, Num, _, []) ->
%%     {MemberList, Num, []};
%% fill_enemy_1(MemberList, Num, _, EnemyList) 
%%   when Num >= ?EVERY_TEAM_NUM ->
%%     {MemberList, Num, EnemyList};
%% fill_enemy_1(MemberList, Num, TeamNum, [H|Rest]) ->
%%     case is_player_in_ability(H, MemberList) of
%%         false ->
%%             fill_enemy_1(MemberList, Num, TeamNum, Rest);
%%         true ->
%%             NewMember = write_player_to_team(H, TeamNum, Num + 1),
%%             fill_enemy_1([NewMember|MemberList], Num + 1, TeamNum, Rest)
%%     end.

%% %%判断一个人是否和队伍的任意人由仇敌关系
%% is_player_enemy(Player, MemberList) ->
%%     PlayerId = element(#player.id, Player),
%%     EnemyIds = lib_cross_pvp:get_enemy_ids(PlayerId),
%%     is_player_enemy_1(EnemyIds, MemberList, false).

%% is_player_enemy_1(_EnemyIds, [], Bool) ->
%%     Bool;
%% is_player_enemy_1(EnemyIds, [Member|Rest], Bool) ->
%%     case lists:member(Member#cross_pvp_team.player_id, EnemyIds) of
%%         false ->
%%             is_player_enemy_1(EnemyIds, Rest, Bool);
%%         true ->
%%             true
%%     end.
    

%% is_player_in_ability(Player, MemberList) ->
%%     Ability = element(#player.high_ability, Player),
%%     is_player_in_ability_1(Ability, MemberList).

%% is_player_in_ability_1(_Ability, []) ->
%%     true;
%% is_player_in_ability_1(Ability, [H|Rest]) ->
%%     TarAbility = 
%%         if
%%             is_record(H, cross_pvp_team) ->
%%                 H#cross_pvp_team.battle_ability;
%%             true ->
%%                 element(#player.high_ability, H)
%%         end,
%%     case if_in_ability(Ability, TarAbility) of
%%         false ->
%%             false;
%%         true ->
%%             is_player_in_ability_1(Ability, Rest) 
%%     end.

%% %%处理没进组的散人
%% inner_handle_cache(NextTeamNum, []) ->
%%     NextTeamNum;
%% inner_handle_cache(NextTeamNum, PlayerList) ->
%%     inner_handle_cache_1(NextTeamNum, PlayerList, [], 0).

%% inner_handle_cache_1(NextTeamNum, [], AccMemberList, _) ->
%%     trans_team_to_now(AccMemberList, NextTeamNum),
%%     %%write_player_list_to_team(NextTeamNum, AccMemberList),
%%     NextTeamNum + 1;
%% inner_handle_cache_1(NextTeamNum, PlayerList, AccMemberList, AccCount) when AccCount >= ?EVERY_TEAM_NUM ->
%%     %%write_player_list_to_team(NextTeamNum, AccMemberList),
%%     trans_team_to_now(AccMemberList, NextTeamNum),
%%     inner_handle_cache_1(NextTeamNum + 1, PlayerList, [], 0);
%% inner_handle_cache_1(NextTeamNum, [Player|Rest], AccMemberList, AccCount) ->
%%     case is_player_in_ability(Player, AccMemberList) of
%%         true ->
%%             %% AList = 
%%             %%     lists:map(fun
%%             %%                   (H) 
%%             %%               when is_record(H, cross_pvp_team) ->
%%             %%                      H#cross_pvp_team.battle_ability;
%%             %%                   (H) ->
%%             %%                      element(#player.high_ability, H)
%%             %%              end, AccMemberList),
%%             %% ?WARNING_MSG("Player in team Id ~p ABility ~p ~p~n",
%%             %%              [element(#player.id, Player), element(#player.battle_ability, Player), AList]),
%%             inner_handle_cache_1(NextTeamNum, Rest, [Player|AccMemberList], AccCount + 1);
%%         false ->
%%             trans_team_to_now(AccMemberList, NextTeamNum),
%%             %%write_player_list_to_team(NextTeamNum, AccMemberList),
%%             inner_handle_cache_1(NextTeamNum + 1, Rest, [Player], 1)
%%     end.    

%% %% write_team_info(From, To) when From > To ->
%% %%     skip;
%% %% write_team_info(From, To) ->
%% %%     TeamMembers = hdb:dirty_index_read(cross_pvp_team, From, #cross_pvp_team.team_num),
%% %%     write_team_info_1(From, TeamMembers),
%% %%     write_team_info(From + 1, To).

%% write_team_info_1(_, []) ->
%%     skip;
%% write_team_info_1(TeamNum, Members) ->
%%     {AllAbility, Num} = 
%%         lists:foldl(fun
%%                         (#cross_pvp_team{battle_ability = Ability}, {AccAbility, AccNum}) ->
%%                             {AccAbility + Ability, AccNum + 1};
%%                         (Player, {AccAbility, AccNum}) ->
%%                             {AccAbility + element(#player.high_ability, Player), AccNum + 1}
%%                     end, {0, 0}, Members),
%%     hdb:dirty_write(cross_team_player_count, #cross_team_player_count{team_id = TeamNum,
%%                                                                       num = Num,
%%                                                                       avg_ability = AllAbility div Num}).
%% %%把上一届的team变成这一届的
%% trans_team_to_now(MemberList, TeamNum) ->
%%     trans_team_to_now_1(MemberList, TeamNum, ?TEAM_TYPE_NORMAL).
%% trans_team_to_now(MemberList, TeamNum, TeamType) ->
%%     trans_team_to_now_1(MemberList, TeamNum, TeamType).

%% trans_team_to_now_1([], _TeamNum, _) ->
%%     skip;
%% trans_team_to_now_1(MemberList, TeamNum, TeamType) ->
%%     {AllAbility, Num} = 
%%         lists:foldl(fun
%%                         (#cross_pvp_team{battle_ability = Ability}, {AccAbility, AccNum}) ->
%%                             {AccAbility + Ability, AccNum + 1};
%%                         (Player, {AccAbility, AccNum}) ->
%%                             {AccAbility + element(#player.high_ability, Player), AccNum + 1}
%%                    end, {0, 0}, MemberList),
%%         case MemberList of
%%             [#cross_pvp_team{}|_] ->
%%                 NewMemberList = 
%%                     lists:sort(fun(A, B) ->
%%                                        A#cross_pvp_team.battle_ability > B#cross_pvp_team.battle_ability
%%                                end, MemberList),
%%                 lists:foldl(fun(Member, AccRank) ->
%%                                     hdb:dirty_write(cross_pvp_team, Member#cross_pvp_team{rank = AccRank,
%%                                                                                           team_num = TeamNum}),
%%                                     AccRank + 1
%%                             end, 1, NewMemberList);
%%             _ ->
%%                 SortPlayer =
%%                     lists:sort(fun(A, B) ->
%%                                        element(#player.high_ability, A) > element(#player.high_ability, B)
%%                                end, MemberList),
%%                 lists:foldl(fun(Player, Rank) ->
%%                                     write_player_to_team(Player, TeamNum, Rank),
%%                                     Rank + 1
%%                             end, 1, SortPlayer)
%%         end,
%%     AvgAbility = AllAbility div Num,
%%     hdb:dirty_write(cross_team_player_count, #cross_team_player_count{team_id = TeamNum,
%%                                                                       num = Num,
%%                                                                       team_type = TeamType,
%%                                                                       avg_ability = AllAbility div Num}),
%%     if
%%         Num >= ?EVERY_TEAM_NUM ->
%%             skip;
%%         true ->
%%             case data_base_kuafupvp_robot_attribute:get(AvgAbility) of
%%                 [] ->
%%                     skip;
%%                 #base_kuafupvp_robot_attribute{robot_id = Id,
%%                                                career = Career,
%%                                                lv = Lv,
%%                                                battle_ability = Ability} ->
%%                     lists:foreach(fun(Rank) ->
%%                                           hdb:dirty_write(cross_pvp_team, 
%%                                                           #cross_pvp_team{
%%                                                              player_id = next_robot_id(),
%%                                                              name = get_robot_name(),
%%                                                              career = Career,
%%                                                              lv = Lv,
%%                                                              battle_ability = Ability,
%%                                                              is_robot = ?IS_ROBOT_1,
%%                                                              robot_id = Id,
%%                                                              rank = Rank,
%%                                                              team_num = TeamNum})
%%                                   end, lists:seq(Num+1, ?EVERY_TEAM_NUM))
%%             end
%%     end.



%% next_robot_id() ->
%%     {robot, lib_counter:update_counter(cross_robot_uid)}.

get_robot_id(Id) ->
    {robot, Id}.

%% delete_last_team_info(0, 0) ->
%%     skip;
%% delete_last_team_info(Min, Max) ->
%%     lists:foreach(fun(Num) ->
%%                           delete_team_info(Num)
%%                   end, lists:seq(Min, Max)).
    
%% get_player_cache([]) ->
%%     {[], []};
%% get_player_cache([H|Tail]) ->
%%     case select_player(H) of
%%         [] ->
%%             get_player_cache(Tail); 
%%         List ->
%%             NewList = 
%%                 lists:filter(fun(Player) ->
%%                                      Id = element(#player.id, Player),
%%                                      case hdb:dirty_read(cross_pvp_team, Id) of
%%                                          [] ->
%%                                              true;
%%                                          _ ->
%%                                              false
%%                                      end
%%                              end, List),
%%             {NewList, Tail}
%%     end.
%% %%获取本轮开始的队伍号
%% new_team_num() ->
%%     lib_counter:update_counter(cross_pvp_team_uid, 1).

%% get_next_team_num() ->
%%     Next = new_team_num(),
%%     hdb:dirty_write(server_config, #server_config{k = ?CROSS_PVP_MAX_TEAM_NUM, v = Next}),
%%     Next.

%% init_begin_team_num() ->
%%     Num = new_team_num(),
%%     NewNum = 
%%         if
%%             Num >= 100000000 ->
%%                 lib_counter:write_new_counter(cross_pvp_team_uid, 1),
%%                 1;
%%             true ->
%%                 Num
%%         end,
%%     hdb:dirty_write(server_config, #server_config{k = ?CROSS_PVP_MIN_TEAM_NUM, v = NewNum}),
%%     NewNum.

%% get_team_num_area() ->
%%     case {hdb:dirty_read(server_config, ?CROSS_PVP_MIN_TEAM_NUM), 
%%           hdb:dirty_read(server_config, ?CROSS_PVP_MAX_TEAM_NUM)} of
%%         {[], _} ->
%%             {0, 0};
%%         {_, []} ->
%%             {0, 0};
%%         {#server_config{v = Min}, #server_config{v = Max}}->
%%             {Min, Max}
%%     end.

%% new_round() ->
%%     case hdb:dirty_read(server_config, ?CROSS_PVP_ROUND) of
%%         [] ->
%%             hdb:dirty_write(server_config, #server_config{k = ?CROSS_PVP_ROUND,
%%                                                           v = 1});
%%         #server_config{v = Count} ->
%%             hdb:dirty_write(server_config, #server_config{k = ?CROSS_PVP_ROUND,
%%                                                           v = Count + 1})
%%     end.

%% delete_team_list(TeamMemberList) ->
%%     lists:foreach(fun(TeamMember) ->
%%                           delete_from_team(TeamMember)    
%%                   end, TeamMemberList).

%% delete_from_team(#cross_pvp_team{player_id = PlayerId}) ->
%%     hdb:dirty_delete(cross_pvp_team, PlayerId).

%% delete_team_info(TeamNum) ->
%%     hdb:dirty_delete(cross_team_player_count, TeamNum).

%%--------------------结束分组--------------------------%%

%% -include_lib("stdlib/include/ms_transform.hrl").
%% select_player({Min, Max}) ->
%%     Now = time_misc:unixtime(),
%%     Ms = ets:fun2ms(fun(Player) 
%%                           when element(#player.high_ability, Player) >= Min andalso
%%                                element(#player.high_ability, Player) =< Max andalso
%%                                Now - element(#player.timestamp_login, Player) =< ?ONE_DAY_SECONDS*3
%%                                andalso 
%%                                ((Now - element(#player.create_timestamp, Player) >= ?ONE_DAY_SECONDS*3)
%%                                 orelse 
%%                                   (element(#player.create_timestamp, Player) > 4000)) ->
%%                             Player
%%                     end),
%%     Fun = fun() ->
%%                   mnesia:select(player, Ms)
%%           end,
%%     PlayerList = mnesia:activity(async_dirty, Fun, [], mnesia_frag),
%%     FilterList = lists:filter(fun(Player) ->
%%                                       PlayerId = element(#player.id, Player),
%%                                       case hdb:dirty_read(cross_pvp_team, PlayerId) of
%%                                           [] ->
%%                                               true;
%%                                           _ ->
%%                                               false
%%                                       end
%%                               end, PlayerList),
%%     SortFun = fun(Player1, Player2) ->
%%                       element(#player.high_ability, Player1) >= element(#player.high_ability, Player2)
%%               end,
%%     lists:sort(SortFun, FilterList).


%% %%-----------------test----------------------%%
%% get_team(Num) ->
%%     hdb:dirty_index_read(cross_pvp_team, Num, #cross_pvp_team.team_num).

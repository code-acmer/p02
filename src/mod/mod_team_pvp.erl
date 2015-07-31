%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@moyou.me>
%%% @copyright (C) 2015, liu
%%% @doc
%%% 每10个人组成的小组都单独用一个进程处理
%%% @end
%%% Created :  4 Mar 2015 by liu <liuzhigang@moyou.me>
%%%-------------------------------------------------------------------
-module(mod_team_pvp).

%% -behaviour(gen_server).

%% -include("define_cross_pvp.hrl").
%% -include("define_logger.hrl").
%% -include("define_info_23.hrl").
%% -include("define_arena.hrl").
%% -include("define_mail_text.hrl").
%% -include("db_base_kuafupvp_rank_reward.hrl").
%% -include("define_mnesia.hrl").
%% -include("define_player.hrl").
%% -include("define_money_cost.hrl").

%% %% API
%% -export([start_link/1]).
%% -export([challenge/3,
%%          challenge_result/4,
%%          buy_challenge_times/1,
%%          new_member/2
%%         ]).
%% %% gen_server callbacks
%% -export([init/1, handle_call/3, handle_cast/2, handle_info/2,
%%          terminate/2, code_change/3]).
%% %%for test gm
%% -export([pvp_over/1]).

%% -define(SERVER, ?MODULE).

%% -record(state, {team_num = 0,
%%                 team = [], %%队员id
%%                 num = 0,  %%玩家的人数
%%                 fight_info = []}).

%% %%%===================================================================
%% %%% API
%% %%%===================================================================
%% challenge(TeamNum, PlayerId, TarId) ->
%%     call(TeamNum, {challenge, PlayerId, TarId}).

%% challenge_result(TeamNum, PlayerId, TarId, Result) ->
%%     call(TeamNum, {challenge_result, PlayerId, TarId, Result}).

%% buy_challenge_times(Player) ->
%%     case hdb:dirty_read(cross_pvp_team, Player#player.id, true) of
%%         [] ->
%%             {fail, ?INFO_CONF_ERR};
%%         #cross_pvp_team{team_num = TeamNum} ->
%%             call(TeamNum, {buy_challenge_times, Player})
%%     end.

%% new_member(TeamNum, PlayerId) ->
%%     cast(TeamNum, {new_member, PlayerId}).

%% pvp_over(TeamNum) ->
%%     cast(TeamNum, pvp_over).
%% %%--------------------------------------------------------------------
%% %% @doc
%% %% Starts the server
%% %%
%% %% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% %% @end
%% %%--------------------------------------------------------------------
%% start_link(TeamNum) ->
%%     gen_server:start_link({via, gproc, process_name(TeamNum)}, ?MODULE, [TeamNum], []).

%% %%%===================================================================
%% %%% gen_server callbacks
%% %%%===================================================================

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Initializes the server
%% %%
%% %% @spec init(Args) -> {ok, State} |
%% %%                     {ok, State, Timeout} |
%% %%                     ignore |
%% %%                     {stop, Reason}
%% %% @end
%% %%--------------------------------------------------------------------
%% init([TeamNum]) ->
%%     gen_server:cast(self(), init),
%%     {ok, #state{team_num = TeamNum}}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Handling call messages
%% %%
%% %% @spec handle_call(Request, From, State) ->
%% %%                                   {reply, Reply, State} |
%% %%                                   {reply, Reply, State, Timeout} |
%% %%                                   {noreply, State} |
%% %%                                   {noreply, State, Timeout} |
%% %%                                   {stop, Reason, Reply, State} |
%% %%                                   {stop, Reason, State}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_call({challenge, PlayerId, TarId}, _, #state{team = Team,
%%                                                     fight_info = FightInfo} = State) ->
%%     case lists:member(TarId, Team) of
%%         false ->
%%             {reply, {fail, ?INFO_CONF_ERR}, State};
%%         true ->
%%             case inner_handle_challenge(PlayerId, TarId, FightInfo) of
%%                 {ok, NewFightInfo} ->
%%                     {reply, ok, State#state{fight_info = NewFightInfo}};
%%                 Other ->
%%                     {reply, Other, State}
%%             end
%%     end;
%% handle_call({challenge_result, PlayerId, TarId, Result}, _, #state{team = _Team,
%%                                                                    fight_info = FightInfo} = State) ->
%%     case inner_handle_result(PlayerId, TarId, Result, FightInfo) of
%%         {ok, NewFightInfo} ->
%%             {reply, ok, State#state{fight_info = NewFightInfo}};
%%         Other ->
%%             {reply, Other, State}
%%     end;
%% handle_call({buy_challenge_times, Player}, _, State) ->
%%     Reply = 
%%         case catch inner_handle_buy_times(Player) of
%%             {fail, Reason} ->
%%                 {fail, Reason};
%%             {ok, NewPvp, NewPlayer} ->
%%                 {ok, NewPvp, NewPlayer};
%%             Other ->
%%                 ?WARNING_MSG("Other ~p~n", [Other]),
%%                 {fail, ?INFO_SERVER_DATA_ERROR}
%%         end,
%%     {reply, Reply, State};
%% handle_call(_Request, _From, State) ->
%%     Reply = ok,
%%     {reply, Reply, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Handling cast messages
%% %%
%% %% @spec handle_cast(Msg, State) -> {noreply, State} |
%% %%                                  {noreply, State, Timeout} |
%% %%                                  {stop, Reason, State}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_cast(init, State) ->
%%     case hdb:dirty_index_read(cross_pvp_team, State#state.team_num, #cross_pvp_team.team_num, true) of
%%         [] ->
%%             {stop, normal, State};
%%         PvpPlayer ->
%%             {PlayerIdList, Count} = 
%%                 lists:foldl(fun(#cross_pvp_team{player_id = PlayerId,
%%                                                 is_robot = IsRobot}, {AccList, AccNum}) ->
%%                                     if

%%                                         IsRobot =:= ?IS_ROBOT_1 ->
%%                                             {[PlayerId|AccList], AccNum};
%%                                         true ->
%%                                             {[PlayerId|AccList], AccNum + 1}
%%                                     end
%%                             end, {[], 0}, PvpPlayer),
%%             erlang:send_after(?AUTO_CHALLENGE_TIME*1000, self(), auto_challenge),
%%             erlang:send_after(?AUTO_ADD_SCORE*1000, self(), auto_add_score),
%%             {noreply, State#state{team = PlayerIdList,
%%                                   num = Count}}
%%     end;
%% handle_cast({new_member, PlayerId}, #state{team = PlayerIdList} = State) ->
%%     {noreply, State#state{team = [PlayerId|PlayerIdList]}};
%% handle_cast(pvp_over, #state{fight_info = FightInfo} = State) ->
%%     NewFightInfo = inner_auto_challenge(FightInfo, 0),
%%     {noreply, State#state{fight_info = NewFightInfo}};
%% handle_cast(_Msg, State) ->
%%     {noreply, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Handling all non call/cast messages
%% %%
%% %% @spec handle_info(Info, State) -> {noreply, State} |
%% %%                                   {noreply, State, Timeout} |
%% %%                                   {stop, Reason, State}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_info(auto_challenge, #state{fight_info = FightInfo} = State) ->
%%     NewFightInfo = inner_auto_challenge(FightInfo, ?AUTO_CHALLENGE_TIME),
%%     %%?WARNING_MSG("auto_challenge FightInfo ~p~n", [FightInfo]),
%%     erlang:send_after(?AUTO_CHALLENGE_TIME*1000, self(), auto_challenge),
%%     {noreply, State#state{fight_info = NewFightInfo}};
%% handle_info(match_over, #state{fight_info = FightInfo} = State) ->
%%     ?WARNING_MSG("match_over ~n", []),
%%     inner_auto_challenge(FightInfo, 0),
%%     inner_send_reward(State#state.team_num),
%%     {stop, normal, State#state{fight_info = []}};
%% handle_info(auto_add_score, #state{team_num = TeamNum} = State) ->
%%     inner_add_score(TeamNum),
%%     erlang:send_after(?AUTO_ADD_SCORE*1000, self(), auto_add_score),
%%     {noreply, State};
%% handle_info(_Info, State) ->
%%     {noreply, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% This function is called by a gen_server when it is about to
%% %% terminate. It should be the opposite of Module:init/1 and do any
%% %% necessary cleaning up. When it returns, the gen_server terminates
%% %% with Reason. The return value is ignored.
%% %%
%% %% @spec terminate(Reason, State) -> void()
%% %% @end
%% %%--------------------------------------------------------------------
%% terminate(Reason, #state{fight_info = FightInfo}) ->
%%     ?DEBUG("~p terminate Reason ~p~n", [?MODULE, Reason]),
%%     inner_auto_challenge(FightInfo, 0),
%%     ok.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Convert process state when code is changed
%% %%
%% %% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% %% @end
%% %%--------------------------------------------------------------------
%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.

%% %%%===================================================================
%% %%% Internal functions
%% %%%===================================================================
%% process_name(TeamNum) ->
%%     {n, g, {team_pvp, TeamNum}}.

%% team_pid(TeamNum) ->
%%     case gproc:where(process_name(TeamNum)) of
%%         Pid when is_pid(Pid) ->
%%             Pid;
%%         _ ->
%%             []
%%     end.

%% inner_handle_challenge(PlayerId, TarId, FightInfo) ->
%%     case traval(PlayerId, TarId, FightInfo) of
%%         true ->
%%             {ok, [{PlayerId, TarId, time_misc:unixtime()}|FightInfo]};
%%         Other ->
%%             Other
%%     end.

%% traval(_PlayerId, _TarId, []) ->
%%     true;
%% traval(PlayerId, _TarId, [{PlayerId, _, _}|_]) ->
%%     {fail, ?INFO_CHALLENGE_SELF_BUSY};
%% traval(_PlayerId, TarId, [{_, TarId, _}|_]) ->
%%     {fail, ?INFO_CHALLENGE_TAR_BUSY};
%% traval(PlayerId, TarId, [_|T]) ->
%%     traval(PlayerId, TarId, T).

%% inner_handle_result(PlayerId, TarId, Result, FightInfo) ->
%%     case lists:keytake(PlayerId, 1, FightInfo) of
%%         false ->
%%             {fail, ?INFO_CONF_ERR};
%%         {value, {_, TarId, _}, Rest} ->
%%             case write_db_data(PlayerId, TarId, Result) of
%%                 ok ->
%%                     {ok, Rest};
%%                 Other ->
%%                     Other
%%             end;
%%         _ ->
%%             {fail, ?INFO_CONF_ERR}
%%     end.

%% write_db_data(PlayerId, TarId, Result) ->
%%     case {hdb:dirty_read(cross_pvp_team, PlayerId, true), hdb:dirty_read(cross_pvp_team, TarId, true)} of
%%         {#cross_pvp_team{win_times = Win,
%%                          fail_times = Fail,
%%                          name = Name1,
%%                          rank = Rank1} = P1, 
%%          #cross_pvp_team{name = Name2,
%%                          rank = Rank2} = P2} ->
%%             Report = 
%%                 #async_arena_report{id = next_report_id(),
%%                                     attack_id = PlayerId,
%%                                     nickname = Name1,
%%                                     deffender_id = TarId,
%%                                     deffender_name = Name2,
%%                                     result = Result,
%%                                     attack_rank = Rank1,
%%                                     defender_rank = Rank2,
%%                                     timestamp = time_misc:unixtime()},
%%             if
%%                 Result =:= ?CHALLENGE_PVP_WIN andalso Rank1 > Rank2 ->
%%                     %%add_challenge_friend(PlayerId, TarId),
%%                     write_report(Report, ?RANK_UP),
%%                     NewP1 = 
%%                         P1#cross_pvp_team{win_times = Win + 1,
%%                                           rank = Rank2},
%%                     NewP2 = 
%%                         P2#cross_pvp_team{rank = Rank1},
%%                     write_enemy_info(PlayerId, TarId),
%%                     hdb:dirty_write(cross_pvp_team, NewP1),
%%                     hdb:dirty_write(cross_pvp_team, NewP2);
%%                 Result =:= ?CHALLENGE_PVP_WIN ->
%%                     %%add_challenge_friend(PlayerId, TarId),
%%                     write_report(Report, ?RANK_NO_CHANGE),
%%                     write_enemy_info(PlayerId, TarId),
%%                     NewP1 = P1#cross_pvp_team{win_times = Win + 1},
%%                     hdb:dirty_write(cross_pvp_team, NewP1);
%%                 true ->
%%                     write_report(Report, ?RANK_NO_CHANGE),
%%                     NewP1 = P1#cross_pvp_team{fail_times = Fail + 1},
%%                     hdb:dirty_write(cross_pvp_team, NewP1)
%%             end;
%%         _ ->
%%             {fail, ?INFO_CONF_ERR}
%%     end.

%% write_report(Report, RankType) ->
%%     hdb:dirty_write(cross_pvp_report, Report#async_arena_report{rank_change_type = RankType}).

%% next_report_id() ->
%%     lib_counter:update_counter(cross_pvp_report_uid, 1).


%% write_enemy_info(PlayerId, TarId) ->
%%     case hdb:dirty_read(cross_pvp_enemy, {PlayerId, TarId}) of
%%         [] ->
%%             hdb:dirty_write(cross_pvp_enemy, 
%%                             #cross_pvp_enemy{key = {PlayerId, TarId},
%%                                              player_id = PlayerId,
%%                                              tar_id = TarId
%%                                             });
%%         _ ->
%%             skip
%%     end.

%% %% add_challenge_friend(PlayerId, TarId) ->
%% %%     case hdb:dirty_read(cross_pvp_friend, PlayerId, true) of
%% %%         [] ->
%% %%             hdb:dirty_write(#cross_pvp_friend{player_id = PlayerId,
%% %%                                               friend_list = [{TarId, 1}]});
%% %%         #cross_pvp_friend{friend_list = Friends} = OldFriend ->
%% %%             NewFriends = 
%% %%                 case lists:keytake(TarId, 1, Friends) of
%% %%                     false ->
%% %%                         [{TarId, 1}|Friends];
%% %%                     {value, {_, Count}, Rest} ->
%% %%                         [{TarId, Count+1}|Rest]
%% %%                 end,
%% %%             hdb:dirty_write(cross_pvp_friend,
%% %%                             OldFriend#cross_pvp_friend{friend_list = NewFriends})
%% %%     end.

%% inner_auto_challenge([], _Delay) ->
%%     [];
%% inner_auto_challenge(FightInfo, Delay) ->
%%     Now = time_misc:unixtime(),
%%     inner_auto_challenge2(Now, FightInfo, Delay, []).
    
%% inner_auto_challenge2(_Now, [], _Delay, AccFightInfo) ->
%%     AccFightInfo;
%% inner_auto_challenge2(Now, [{PlayerId, TarId, Timestamp}|Tail], Delay, AccFightInfo) ->
%%     case Now - Timestamp >= Delay of
%%         true ->
%%             write_db_data(PlayerId, TarId, ?CHALLENGE_PVP_FAIL),
%%             inner_auto_challenge2(Now, Tail, Delay, AccFightInfo);
%%         false ->
%%             inner_auto_challenge2(Now, Tail, Delay, [{PlayerId, TarId, Timestamp}|AccFightInfo])
%%     end.

%% inner_send_reward(TeamNum) ->
%%     Team = hdb:dirty_index_read(cross_pvp_team, TeamNum, #cross_pvp_team.team_num),
%%     Now = time_misc:unixtime(),
%%     Round =
%%         case hdb:dirty_read(server_config, ?CROSS_PVP_ROUND) of
%%             [] ->
%%                 0;
%%             #server_config{v = Count} ->
%%                 Count
%%         end,
%%     SortTeam = 
%%         lists:sort(fun(#cross_pvp_team{score = ScoreA}, #cross_pvp_team{score = ScoreB}) ->
%%                            ScoreA >= ScoreB
%%                    end, Team),
%%     lists:foldl(fun(#cross_pvp_team{player_id = PlayerId,
%%                                     win_times = WinTimes,
%%                                     is_robot = Robot,
%%                                     enemy = Enemy}, Rank) ->
%%                           if
%%                               Robot =:= ?IS_ROBOT_1 ->
%%                                   Rank + 1;
%%                               WinTimes =:= 0 andalso Enemy =:= [] ->
%%                                   Rank + 1;
%%                               true ->
%%                                   inner_send_reward2(PlayerId, Rank, Now, Round),
%%                                   Rank + 1
%%                           end
%%                   end, 1, SortTeam).

%% inner_send_reward2(PlayerId, Rank, Now, Round) ->
%%     case data_base_kuafupvp_rank_reward:get(Rank) of
%%         [] ->
%%             skip;
%%         #base_kuafupvp_rank_reward{reward = Reward} ->
%%             write_history(PlayerId, Rank, Now, Round),
%%             BaseMail = lib_mail:base_mail(?CROSS_PVP_RANK_REWARD_MAIL, [Rank], Reward),
%%             lib_mail:send_mail(PlayerId, BaseMail)
%%     end.

%% write_history(PlayerId, Rank, Now, Round) ->
%%     NextId = lib_counter:update_counter(cross_pvp_history_uid),
%%     hdb:dirty_write(cross_pvp_history,
%%                     #cross_pvp_history{id = NextId,
%%                                        player_id = PlayerId,
%%                                        rank = Rank,
%%                                        round = Round,
%%                                        timestamp = Now}).

%% call(TeamNum, Request) ->
%%     case team_pid(TeamNum) of
%%         [] ->
%%             {fail, ?INFO_SERVER_DATA_ERROR};
%%         Pid ->
%%             gen_server:call(Pid, Request)
%%     end.

%% cast(TeamNum, Request) ->
%%     case team_pid(TeamNum) of
%%         [] ->
%%             {fail, ?INFO_SERVER_DATA_ERROR};
%%         Pid ->
%%             gen_server:cast(Pid, Request)
%%     end.

%% inner_handle_buy_times(Player) ->
%%     MaxBuyTimes = lib_vip:max_cross_buy_times(Player#player.vip),
%%     case hdb:dirty_read(cross_pvp_team, Player#player.id) of
%%         [] ->
%%             {fail, ?INFO_CONF_ERR};
%%         #cross_pvp_team{left_times = Lefts,
%%                         buy_times = BuyTimes} = PvpPlayer when BuyTimes < MaxBuyTimes ->
%%             case lib_vip:get_vip_cost(cross_arena_cost, BuyTimes + 1) of
%%                 error ->
%%                     {fail, ?INFO_CONF_ERR};
%%                 {CostType, CostNum} ->
%%                     case lib_player:cost_money(Player, CostNum, CostType, ?COST_CROSS_CHALLENGE_BUY_TIMES) of
%%                         {fail, Reason} ->
%%                             {fail, Reason};
%%                         {ok, NewPlayer} ->
%%                             NewPvp = PvpPlayer#cross_pvp_team{left_times = Lefts + ?EACH_BUY_TIMES_CROSS,
%%                                                               buy_times = BuyTimes + 1},
%%                             hdb:dirty_write(cross_pvp_team, NewPvp),
%%                             {ok, NewPvp, NewPlayer}
%%                     end
%%             end;
%%         _ ->
%%             {fail, ?INFO_ARENA_BUY_TIMES_LIMIT}
%%     end.

%% inner_add_score(TeamNum) ->
%%     Members = hdb:dirty_index_read(cross_pvp_team, TeamNum, #cross_pvp_team.team_num),
%%     {H, M, _} = time_misc:local_hms(),
%%     Rate = get_rate({H, M}),
%%     lists:foreach(fun
%%                       (#cross_pvp_team{is_robot = ?IS_ROBOT_1}) ->
%%                           skip;
%%                       (#cross_pvp_team{rank = Rank,
%%                                        score = Score} = Member)->
%%                           AddScore = get_rank_score(Rank),
%%                           hdb:dirty_write(cross_pvp_team, Member#cross_pvp_team{score = Score + trunc(AddScore * Rate)})
%%                   end, Members).

%% get_rate(Time)
%%   when Time > {0, 0} andalso Time =< {1, 0} ->
%%     0.5;
%% get_rate(Time)
%%   when Time > {1, 0} andalso Time =< {6, 0} ->
%%     0.2;
%% get_rate(Time)
%%   when Time > {6, 0} andalso Time =< {11, 0} ->
%%     0.5;
%% get_rate(Time)
%%   when Time > {11, 0} andalso Time =< {13, 0} ->
%%     1.5;
%% get_rate(Time)
%%   when Time > {13, 0} andalso Time =< {18, 0} ->
%%     0.8;
%% get_rate(Time)
%%   when Time > {18, 0} andalso Time =< {21, 30} ->
%%     1.5;
%% get_rate(_) ->
%%     0.

%% get_rank_score(1) ->
%%     100;
%% get_rank_score(2) ->
%%     80;
%% get_rank_score(3) ->
%%     50;
%% get_rank_score(4) ->
%%     30;
%% get_rank_score(5) ->
%%     20;
%% get_rank_score(_) ->
%%     10.

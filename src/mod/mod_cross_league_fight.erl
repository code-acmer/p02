%%%-------------------------------------------------------------------
%%% @author Arno <>
%%% @copyright (C) 2015, Arno
%%% @doc
%%% 跨服帮派战 核心服务
%%% @end
%%% Created :  7 May 2015 by Arno <>
%%%-------------------------------------------------------------------
-module(mod_cross_league_fight).
-include("common.hrl").
-include("define_try_catch.hrl").
-include("define_cross_league_fight.hrl").
-include("define_mnesia.hrl").

-behaviour(gen_server).

-export([
         start_arrange_fight/0,
         fight_end/0,
         season_end/0,
         daily_reward/0,
         add_score/2,
         test/0,
         get_fight_status/0,
         set_fight_status/1,
         fight_start/0
        ]).
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

test() ->
    %% L = lists:seq(1, 10000),
    %% T1 = time_misc:unixtime(),
    %% lists:foldl(fun(_, []) -> 
    %%                     lists:map(fun(_) ->
    %%                                       ok
    %%                               end, L),
    %%                     []
    %%             end, [], L),
    %% T2 = time_misc:unixtime(),
    %% io:format("T2 - T1 : ~p", [T2 - T1]).
    ok.

%%%===================================================================
%%% API
%%%===================================================================

%% 开始匹配对手
start_arrange_fight() ->
    %% set_fight_status(?FIGHT_STATUS_READY),
    gen_server:cast(get_main_pid(), cmd_start_arrange_fight).

%% 
add_score(LeagueId, AddScore) ->
    case lib_league_fight:get_fight_league(LeagueId) of
        [] ->
            ignored;
        #fight_league{
           score = Score
          } = FightLeague ->
            lib_league_fight:update_fight_league(FightLeague#fight_league{score = Score + AddScore
                                                                         })
    end.

fight_start() ->
    set_fight_status(?FIGHT_STATUS_RUINNG).

%% 单场结算
fight_end() ->
    set_fight_status(?FIGHT_STATUS_ENDING),
    gen_server:cast(get_main_pid(), cmd_fight_end).

%% 赛季结算
season_end() ->
    set_fight_status(?FIGHT_STATUS_CLOSED),
    gen_server:cast(get_main_pid(), cmd_season_end).

%% 日常结算
daily_reward() ->
    gen_server:cast(get_main_pid(), cmd_daily_reward).

%% 处理每场奖励结算处理
fight_end_reward(Group, FightLeague) ->
    gen_server:cast(get_worker_pid(Group), {cmd_fight_end_reward, FightLeague}).

%% 重置军团处理
reset_fight_league(Group, FightLeague) ->
    gen_server:cast(get_worker_pid(Group), {cmd_reset_fight_league, FightLeague}).

%% 开始已经安排好的军团进行初始化操作
start_league_fight(Group, Arranged) ->
    gen_server:cast(get_worker_pid(Group), {cmd_start_league_fight, Arranged}).


get_fight_status() ->
    gen_server:call(get_main_pid(), req_get_fight_status).

set_fight_status(Status) ->
    Now = time_misc:unixtime(),
    ?WARNING_MSG("set_fight_status: ~p date: ~p", [Status, time_misc:timestamp_to_datetime(Now)]),
    gen_server:cast(get_main_pid(), {cmd_set_fight_status, Status}).

get_worker_pid(_Group) ->
    ?SERVER.
get_main_pid() ->
    ?SERVER.

%%%======== END API ==================================================
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
init([]) ->
    Status = get_league_fight_state(),
    {ok, #league_fight_state{status = Status}}.

%%%========================
%% PROTECTED CODE
handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).
handle_cast(Cmd, State) ->
    ?DO_HANDLE_CAST(Cmd, State).
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State).
%% PROTECTED END
%%%========================
do_handle_call(req_get_fight_status, _From, State) ->    
    {reply, State#league_fight_state.status, State};
do_handle_call(Req, _From, State) ->
    ?WARNING_MSG("ignored Req : ~p ~n", [Req]),
    {reply, ok, State}.


do_handle_cast(cmd_start_arrange_fight, State) ->
    LuckyGuys = 
        lists:foldl(fun(Group, Ret) ->
                            case get_fight_leagues_by_group(Group) of
                                [] ->
                                    Ret;
                                FightLeagues ->
                                    ?DEBUG("Ret: ~p, arrange_fight FightLeagues: ~p", [Ret, FightLeagues]),
                                    {Arranged, Unarranged} = arrange_fight(Ret ++ FightLeagues),
                                    start_league_fight(Group, Arranged),
                                    Unarranged
                            end
                    end, [], lists:reverse(lists:seq(1, ?GROUP_MAX))),
    do_lucky_guys(LuckyGuys),
    mod_cross_league_fight:set_fight_status(?FIGHT_STATUS_READY),
    {noreply, State};
do_handle_cast({cmd_start_league_fight, Arranged}, State) ->
    do_start_league_fight(Arranged),
    {noreply, State};
do_handle_cast(cmd_fight_end, State) ->
    do_fight_end(),
    erlang:send_after(300, self(), reset_rank_data),
    {noreply, State};
%% do_handle_cast(cmd_recount_group, State) ->
%%     do_recount_group(),
%%     {noreply, State};
do_handle_cast(cmd_season_end, State) ->
    do_seaon_end(),
    {noreply, State};
do_handle_cast(cmd_daily_reward, State) ->
    lib_league_fight:do_daily_reward(),
    {noreply, State};
do_handle_cast({cmd_reset_fight_league, FightLeague}, State) ->
    lib_league_fight:reset_fight_league(FightLeague),
    {noreply, State};
do_handle_cast({cmd_fight_end_reward, FightLeague}, State) ->
    lib_league_fight:fight_end_reward(FightLeague),
    {noreply, State};
do_handle_cast({cmd_set_fight_status, Status}, State) ->
    set_league_fight_status(Status),
    NewState = State#league_fight_state{
                 status = Status
                },
    {noreply, NewState};
do_handle_cast(Cmd, State) ->
    ?WARNING_MSG("ignored Cmd : ~p ~n", [Cmd]),
    {noreply, State}.
do_handle_info(reset_rank_data, State) ->
    ?DEBUG("reset_rank_data..."),
    mod_league_rank:reset_rank_data(),
    {noreply, State};
do_handle_info(Info, State) ->
    ?WARNING_MSG("ignored Info : ~p ~n", [Info]),
    {noreply, State}.

terminate(_Reason, #league_fight_state{status = Status}) ->
    set_league_fight_status(Status),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

get_fight_leagues_by_group(Group) ->
    hdb:dirty_index_read(fight_league, Group, #fight_league.group).

arrange_fight(Leagues) ->
    SortFun = fun(A, B) ->
                      A#fight_league.score > B#fight_league.score
              end,
    SortedLeagues = lists:sort(SortFun, Leagues),
    arrange_fight(SortedLeagues, [], []).

arrange_fight([], Arranged, Unarranged) ->
    {Arranged, Unarranged};
arrange_fight([League], Arranged, Unarranged) ->
    {Arranged, [League|Unarranged]};
arrange_fight([LeagueA, LeagueB | Leagues], Arranged, Unarranged) ->
    arrange_fight(Leagues, [{LeagueA, LeagueB}|Arranged], Unarranged).


do_start_league_fight(Arranged) ->
    ?DEBUG("Arranged: ~p", [Arranged]),
    lists:map(fun({LeagueAtk, LeagueDef}) ->
                      NewLeagueAtk = LeagueAtk#fight_league{
                                       enemy_league_id   = LeagueDef#fight_league.league_id,
                                       enemy_league_sn   = LeagueDef#fight_league.sn,
                                       enemy_league_name = LeagueDef#fight_league.league_name
                                      },
                      NewLeagueDef = LeagueDef#fight_league{
                                       enemy_league_id   = LeagueAtk#fight_league.league_id,
                                       enemy_league_sn   = LeagueAtk#fight_league.sn,
                                       enemy_league_name = LeagueAtk#fight_league.league_name
                                      },
                      hdb:dirty_write(fight_league, NewLeagueAtk),
                      hdb:dirty_write(fight_league, NewLeagueDef)
              end, Arranged).

%% 轮空帮派处理
do_lucky_guys(LuckyGuys) ->
    %% hdb:dirty_write(fight_league, LuckyGuys#fight_league{
    %%                                 enemy_league_id   = 0,
    %%                                 enemy_league_sn   = 0,
    %%                                 enemy_league_name = ""
    %%                                }),
    ?DEBUG("LuckyGuys : ~p~n",[LuckyGuys]),
    ok.

%% 结算积分
do_fight_end() ->
    hdb:clear_table(fight_member),
    FightLeagues = hdb:tab2list(fight_league),
    %% 处理完所有胜负判断与物资加成，积分增加, 以及分组调整
    %% NewFightLeagues = lists:map(fun(FightLeague) ->
    %%                                    lib_league_fight:handle_fight_end(FightLeague, FightLeagues)
    %%                            end, FightLeagues),
    NewFightLeagues = inner_handle_fight_end(FightLeagues),
    ?DEBUG("NewFightLeague : ~p~n", [NewFightLeagues]),
    SortFun = fun(LA, LB) ->
                      if 
                          LA#fight_league.score > LB#fight_league.score ->
                              true;
                          LA#fight_league.score == LB#fight_league.score andalso 
                          LA#fight_league.ability_sum >= LB#fight_league.ability_sum ->
                              true;
                          true ->
                              false
                      end
              end,
    SortedLeagues = lists:sort(SortFun, NewFightLeagues),
    ?DEBUG("SortedLeagues : ~p~n", [SortedLeagues]),
    lists:foldl(fun(#fight_league{group = Group} = League, {Rank, LastGroup}) ->
                        NewRank = case Group =:= LastGroup of
                                      true ->
                                          Rank;
                                      _ ->
                                          %% 下一级处理
                                          1
                                  end,
                        NewLeague = League#fight_league{rank = NewRank},
                        ?DEBUG("fight_end_reward for league :~p~n",[NewLeague]),
                        fight_end_reward(Group, NewLeague),
                        ?DEBUG("reset_fight_league for league :~p~n",[NewLeague]),
                        reset_fight_league(Group, NewLeague),
                        {NewRank + 1, Group}
                end, {1, ?GROUP_MAX}, SortedLeagues),
    ok.

inner_handle_fight_end(Leagues) ->
    inner_handle_fight_end(Leagues, []).
inner_handle_fight_end([], Handled) ->
    Handled;
inner_handle_fight_end([#fight_league{
                           enemy_league_id = EnemyLeagueId
                          } = FightLeague | RestLeagues], Handled) ->
    case lists:keytake(EnemyLeagueId, #fight_league.league_id, RestLeagues) of
        {value, EnemyLeague, NewRestLeagues} ->
            {NewAtkLeague, NewDefLeague} = lib_league_fight:handle_fight_end(FightLeague, EnemyLeague),
            inner_handle_fight_end(NewRestLeagues, [NewAtkLeague, NewDefLeague|Handled]);
        _  ->
            NewAtkLeague = lib_league_fight:handle_lucky_guys(FightLeague),
            inner_handle_fight_end(RestLeagues, [NewAtkLeague | Handled])
    end.

do_seaon_end() ->
    lib_league_fight:backup_fight_league(), 
    hdb:clear_table(fight_league),
    hdb:clear_table(fight_member).


%% do_reset_fight_league(SortedLeagues) ->
%%     lists:foldl(fun(League, Rank) ->
%%                         lib_league_fight:reset_fight_league(League#fight_league{rank = Rank
%%                                                                                }),
%%                         Rank + 1
%%                 end, 1, SortedLeagues),
%%     ok.

get_league_fight_state() ->
    case get_value_from_server_config(league_fight_state) of
        [] ->
            0;
        #server_config{v = Status}->
            Status
    end.

get_value_from_server_config(league_fight_state) ->
    hdb:dirty_read(server_config, league_fight_state).

set_league_fight_status(Status) ->
    hdb:dirty_write(server_config, #server_config{k = league_fight_state,
                                                  v = Status}).

%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%% 本模块主要是用来针对运行一些定时的计算(要注意处理服务器首次登陆问题)
%%% 主要是引用gs_cron依赖库
%%% @end
%%% Created : 23 Sep 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_timer).

-include("define_logger.hrl").
-include("define_boss.hrl").
-include("define_mnesia.hrl").
-include("define_time.hrl").
-include("define_try_catch.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

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
    ensure_gs_cron_start(),
    erlang:send_after(0, self(), init_job),
    {ok, #state{}}.

handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).
handle_cast(Cmd,  State) ->
    ?DO_HANDLE_CAST(Cmd, State).
handle_info(Cmd, State) ->
    ?DO_HANDLE_INFO(Cmd, State).

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
do_handle_call(_Request, _From, State) ->
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
do_handle_cast(_Msg, State) ->
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
do_handle_info(init_job, State) ->
    init_job(),
    {noreply, State};
do_handle_info(_Info, State) ->
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
terminate(Reason, _State) ->
    ?WARNING_MSG("~p stop Reason ~p~n", [?SERVER, Reason]),
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
ensure_gs_cron_start() ->
    case application:start(gs_cron) of
        ok ->
            ok;
        {error,{already_started, _}} ->
            skip;
        Other ->
            throw({start_gs_cron_error, Other})
    end.

init_job() ->
    daily_reset_player_job(),
    sys_boss_job(),
    mails_job(),
    %% league_job(),
    %% daily_reset_league_gifts_job(),
    mnesia_bup_job()
    %% daily_reset_request_gifts_msg_job(),
    %% daily_reset_league_fight_job(),
    %% month_season_end(),
    %% daily_start_arrange_fight_job(),
    %% daily_start_fight_job(),
    %% daily_league_fight_reward_job(),
    %% daily_master_reward().
    .

sys_boss_job() ->
    AllBossId = data_base_dungeon_world_boss:sys_boss_id(),
    SnList = server_misc:mnesia_sn_list(),
    lists:foreach(fun(BossId) ->
                          add_boss_job(BossId, SnList)
                  end, AllBossId).

add_boss_job(BossId, SnList) ->
    case data_base_dungeon_world_boss:get(BossId) of
        #base_dungeon_world_boss{open_time = OpenTime} 
          when OpenTime =/= [] ->
            lists:foreach(fun(DbSn) ->
                                  ServerName = list_to_atom(lists:concat([daily_system_boss, DbSn, "_", BossId])),
                                  gs_cron:cron({ServerName, daily, 
                                                [{TimeInfo, {mod_boss_manage, sys_open_boss, [0, "system", DbSn, BossId]}} || TimeInfo <- OpenTime]
                                               })
                          end, SnList);
        _ ->
            skip
    end.


daily_reset_player_job() ->
    BroadcastFun = fun(Pid) -> mod_player:daily_reset(Pid) end,
    gs_cron:cron({mod_player_daily_reset_cron_server, daily,
                  [{{0, 0, 5}, {player_sup, broadcast_all_player, [BroadcastFun]}}]}).

mails_job() ->
    gs_cron:cron({gs_daily_del_mails, daily,
                  [{{5, 2, 0}, {lib_mail, daily_delete_mails, []}}]
                 }).

league_job() ->
    gs_cron:cron({gs_sync_league_data, daily,
                  [{{23, 59, 30}, {lib_league, update_league_data, []}}]
                 }).

daily_reset_league_gifts_job() ->
    Now = time_misc:unixtime(),
    case hdb:dirty_read(server_config, daily_reset_league_gifts) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = daily_reset_league_gifts,
                                                          v = Now}),
            [];
        #server_config{v = Last} ->
            case time_misc:is_same_day(Now, Last) of
                false ->
                    lib_pay_gifts:daily_delete_league_gifts(Now);
                true ->
                    skip
            end
    end,
    gs_cron:cron({daily_reset_league_gifts, daily,
                  [{{0, 0, 30}, {lib_pay_gifts, daily_delete_league_gifts, []}}]
                 }).

daily_reset_request_gifts_msg_job() ->
    Now = time_misc:unixtime(),
    case hdb:dirty_read(server_config, daily_reset_request_gifts_msg) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = daily_reset_request_gifts_msg,
                                                          v = Now}),
            [];
        #server_config{v = Last} ->
            if
                Now - Last >= ?ONE_DAY_SECONDS ->
                    lib_pay_gifts:daily_delete_request_gifts_msg(Now);
                true ->
                    skip
            end
    end,
    gs_cron:cron({daily_reset_request_gifts_msg, daily,
                  [{{0, 1, 0}, {lib_pay_gifts, daily_delete_request_gifts_msg, []}}]
                 }).

daily_reset_league_fight_job() ->
    Now = time_misc:unixtime(),
    case hdb:dirty_read(server_config, daily_reset_league_fight_job) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = daily_reset_league_fight_job,
                                                          v = Now}),
            lib_league_fight:daily_reset_league_fight_job(Now);
        #server_config{v = Last} ->
            skip
    end,
    gs_cron:cron({daily_reset_league_fight_job, daily,
                  [{{23, 59, 40}, {lib_league_fight, daily_reset_league_fight_job, []}}]
                 }).

daily_start_arrange_fight_job() ->
    Now = time_misc:unixtime(),
    case hdb:dirty_read(server_config, daily_start_arrange_fight_job) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = daily_start_arrange_fight_job,
                                                          v = Now}),
            lib_league_fight:daily_start_arrange_fight_job(Now);
        #server_config{v = Last} ->
            case time_misc:is_same_day(Now, Last) of
                false ->
                    lib_league_fight:daily_start_arrange_fight_job(Now);
                true ->
                    ?WARNING_MSG("daily_start_arrange_fight_job, skip ... "),
                    skip
            end
    end,
    gs_cron:cron({daily_start_arrange_fight_job, daily,
                  [{{0, 0, 1}, {lib_league_fight, daily_start_arrange_fight_job, []}}]
                 }).

daily_start_fight_job() ->
    Now = time_misc:unixtime(),
    case hdb:dirty_read(server_config, daily_start_fight_job) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = daily_start_fight_job,
                                                          v = Now}),
            lib_league_fight:daily_start_fight_job(Now);
        #server_config{v = Last} ->
            case time_misc:is_same_day(Now, Last) of
                false ->
                    lib_league_fight:daily_start_fight_job(Now);
                true ->
                    ?WARNING_MSG("daily_start_fight_job, skip ... "),
                    skip
            end
    end,
    gs_cron:cron({daily_start_fight_job, daily,
                  [{{13, 0, 0}, {lib_league_fight, daily_start_fight_job, []}}]
                 }).

daily_league_fight_reward_job() ->
    Now = time_misc:unixtime(),
    case hdb:dirty_read(server_config, daily_league_fight_reward_job) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = daily_league_fight_reward_job,
                                                          v = Now}),
            lib_league_fight:daily_league_fight_reward_job(Now);
        #server_config{v = Last} ->
            case time_misc:is_same_day(Now, Last) of
                false ->
                    lib_league_fight:daily_league_fight_reward_job(Now);
                true ->
                    ?WARNING_MSG("daily_league_fight_reward_job, skip ... "),
                    skip
            end
    end,
    gs_cron:cron({daily_league_fight_reward_job, daily,
                  [{{0, 0, 1}, {lib_league_fight, daily_league_fight_reward_job, []}}]
                 }).


month_season_end() ->
    Now = time_misc:unixtime(),
    case hdb:dirty_read(server_config, month_season_end) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = month_season_end,
                                                          v = Now}),
            lib_league_fight:month_season_end(Now);
        #server_config{v = Last} ->
            case time_misc:is_same_day(Now, Last) of
                false ->
                    lib_league_fight:month_season_end(Now);
                true ->
                    ?WARNING_MSG("month_season_end"),
                    skip
            end
    end,
    gs_cron:cron({month_season_end, daily,
                  [{{23, 59, 59}, {lib_league_fight, month_season_end, []}}]
                 }).

mnesia_bup_job() ->
    gs_cron:cron({gs_mnesia_backup, daily,
                  [{{4, 30, 0}, {lib_mnesia_bup, backup, []}}]
                 }).

daily_master_reward() ->
    gs_cron:cron({daily_master_reward, daily,
                  [{{23, 59, 55}, {lib_master, daily_master_reward, []}}]
                 }).


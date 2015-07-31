%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created : 12 Sep 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_arena).

-include("define_arena.hrl").
-include("define_logger.hrl").
-include("define_player.hrl").
-include("define_info_23.hrl").
-include("define_money_cost.hrl").
-include("define_try_catch.hrl").
-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-export([new_player/2,
         reset_player/2,
         challenge/5,
         buy_challenge_times/2]).

-define(SERVER, ?MODULE).

-record(state, {table}).

%%%===================================================================
%%% API
%%%===================================================================
new_player(Table, Player) ->
    gen_server:cast(Table, {new_player, Player}).

reset_player(Table, Player) ->
    gen_server:cast(Table, {reset_player, Player}).

challenge(Table, Player, TarId, RobotFlag, Result) ->
    gen_server:call(Table, {challenge, Player, TarId, RobotFlag, Result}).

buy_challenge_times(Table, Player) ->
    gen_server:call(Table, {buy_challenge_times, Player}).
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
%%用table名字作为服务名，async_arena_rank管理多个服的排行榜，由外部告诉我要操作的数据库表
start_link(Table) ->
    gen_server:start_link({local, Table}, ?MODULE, [Table], []).

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
init([Table]) ->
    erlang:send_after(0, self(), init),
    {ok, #state{table = Table}}.

handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).
handle_cast(Cmd, State) ->
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
do_handle_call({challenge, Player, TarId, RobotFlag, Result}, _, #state{table = Table} = State) ->
    Reply = lib_arena:challenge(Table, Player, TarId, RobotFlag, Result),
    {reply, Reply, State};
do_handle_call({buy_challenge_times, Player}, _, #state{table = Table} = State) ->
    Reply =
        case catch inner_handle_buy_times(Table, Player) of
            {fail, Reason} ->
                {fail, Reason};
            {ok, NewPlayer, NewRank} ->
                {ok,NewPlayer, NewRank};
            Other ->
                ?WARNING_MSG("Other ~p~n", [Other]),
                {fail, ?INFO_CONF_ERR}
        end,
    {reply, Reply, State};
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
do_handle_cast({new_player, Player}, #state{table = Table} = State) ->
    lib_arena:new_player(Table, Player),
    {noreply, State};

do_handle_cast({reset_player, #player{id = PlayerId, sn = Sn} = Player}, #state{table = Table} = State) ->
    ?DEBUG("daily_reset PlayerId ~p~n", [PlayerId]),
    WriteTable = hdb:sn_table(Table, Sn),
    case hdb:dirty_index_read(WriteTable, PlayerId, #async_arena_rank.player_id, true) of
        [#async_arena_rank{} = Async] ->
            NewAsync =
                Async#async_arena_rank{challenge_times = 0,
                                       buy_times = 0,
                                       rest_challenge_times = ?DAILI_CHALLENGE_TIMES
                                      },
            hdb:dirty_write(WriteTable, NewAsync);
        [] ->
            %% lib_arena:new_player(async_arena_rank, Player);
            [];
        Other ->
            ?WARNING_MSG("async_arena_rank error ~p~n", [Other])
    end,
    {noreply, State};

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
do_handle_info(init, #state{table = Table} = State) ->
    init_table(Table),
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
terminate(_Reason, _State) ->
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
init_table(sync_arena_rank) ->
    ignore;
init_table(async_arena_rank) ->
    SnList = server_misc:mnesia_sn_list(),
    AllRobotIds = data_base_pvp_robot_attribute:get_all_id(),
    [add_robot(list_to_atom(lists:concat([async_arena_rank, '_', DbSn])), AllRobotIds)
               || DbSn <- SnList].

add_robot(WriteTable, AllRobotIds) ->
    case hdb:size(WriteTable) of
        0 ->
            hdb:clear_table(WriteTable),
            write_robot(WriteTable, AllRobotIds);
        _ ->
            ignore
    end.

write_robot(_, []) ->
    skip;
write_robot(WriteTable, [Id|Tail]) ->
    case data_base_pvp_robot_attribute:get(Id) of
        [] ->
            skip;
        #base_pvp_robot_attribute{robot_id = RobotId,
                                  name = Name,
                                  career = Career,
                                  lv = Lv,
                                  battle_ability = BattleAbility} ->
            hdb:dirty_write(WriteTable, #async_arena_rank{rank = Id,
                                                          nickname = Name,
                                                          lv = Lv,
                                                          career = Career,
                                                          battle_ability = BattleAbility,
                                                          is_robot = ?RANK_ROBOT,
                                                          robot_id = RobotId})
    end,
    write_robot(WriteTable, Tail).


inner_handle_buy_times(Table, #player{id = PlayerId,
                                      vip = Vip,
                                      sn = Sn} = Player) ->
    WriteTable = hdb:sn_table(Table, Sn),
    case hdb:dirty_index_read(WriteTable, PlayerId, #async_arena_rank.player_id, true) of
        [#async_arena_rank{buy_times = BuyTimes,
                           rest_challenge_times = Rest} = Rank] ->
            CanBuyTimes = lib_vip:buy_arena_times(Vip),
            if
                BuyTimes >= CanBuyTimes ->
                    {fail, ?INFO_ARENA_BUY_TIMES_LIMIT};
                true ->
                    {CostType, CostNum} = lib_vip:get_vip_cost(pvp_challange_times_cost, BuyTimes + 1),
                    case lib_player:cost_money(Player, CostNum, CostType, ?COST_ASYNC_CHALLENGE_BUY_TIMES) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewPlayer} ->
                            NewRank = Rank#async_arena_rank{buy_times = BuyTimes + 1,
                                                            rest_challenge_times = Rest + ?EACH_BUY_TIMES},
                            hdb:dirty_write(WriteTable, NewRank),
                            {ok, NewPlayer, NewRank}
                    end
            end;
        Other ->
            ?WARNING_MSG("Other ~p~n", [Other]),
            {fail, ?INFO_CONF_ERR}
    end.

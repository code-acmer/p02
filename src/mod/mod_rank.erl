%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created : 29 Jul 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_rank).

-behaviour(gen_server).

-include("define_rank.hrl").
-include("define_player.hrl").
-include("define_logger.hrl").

%% API
-export([start_link/5]).
-export([insert/4,
         reset/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {table,
                origin_table,
                max_size = 0,
                reset_type,
                reward_fun
               }).

%%%===================================================================
%%% API
%%%===================================================================
%%所有的排行榜插入都用进程控制,table在外部决定用哪个rank_1
insert(Table, PlayerId, Value, Ext) ->
    gen_server:cast(server_name(Table), {insert, PlayerId, Value, Ext}).

reset(Table) ->
    Process = server_name(Table),
    gen_server:cast(Process, reset).
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
%%所有的排行榜插入都用进程控制,table在外部决定用哪个rank_1
start_link(OriginTable, WriteTable, MaxSize, ResetType, RewardFlag) ->
    server_name(WriteTable),
    gen_server:start_link({local, server_name(WriteTable)}, ?MODULE, 
                          [OriginTable, WriteTable, MaxSize, ResetType, RewardFlag], []).

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
init([OriginTable, Table, MaxSize, ResetType, RewardFlag]) ->
    gen_server:cast(server_name(Table), maybe_reset),
    RewardFun = 
        if
            RewardFlag =:= ?RANK_REWARD_FALSE ->
                undefined;
            true ->
                fun() ->
                        lib_rank_reset:send_reward(OriginTable, Table) 
                end    
        end,
    {ok, #state{table = Table,
                origin_table = OriginTable,
                max_size = MaxSize,
                reset_type = ResetType,
                reward_fun = RewardFun}}.

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
handle_cast({insert, PlayerId, Value, Ext}, #state{table = Table,
                                                   max_size = MaxSize} = State) ->
    lib_rank:insert(Table, MaxSize, PlayerId, Value, Ext),
    {noreply, State, 0};

%%undefined 类型就是不重置，也不发奖
handle_cast(maybe_reset, #state{reset_type = undefined} = State) ->
    {noreply, State};
handle_cast(maybe_reset, #state{table = Table,
                                origin_table = OriginTable,
                                reset_type = ResetType,
                                reward_fun = RewardFun} = State) ->
    lib_rank_reset:reset_table(OriginTable, Table, ResetType, RewardFun),
    gs_cron:cron({gs_server_name(Table), ResetType, [{crontab_conf(ResetType), {?MODULE, reset, [Table]}}]}),
    {noreply, State};

handle_cast(reset, #state{table = Table,
                          origin_table = OriginTable,
                          reset_type = ResetType,
                          reward_fun = RewardFun} = State) ->
    lib_rank_reset:reset_table(OriginTable, Table, ResetType, RewardFun),
    {noreply, State};

handle_cast(Msg, State) ->
    ?WARNING_MSG("RECV UNEXPECTED CAST ~p~n", [Msg]),
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
handle_info(timeout, #state{table = Table,
                            max_size = MaxSize} = State) ->
    lib_rank:clean_over_flow(Table, MaxSize),
    {noreply, State};
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
terminate(Reason, State) ->
    ?WARNING_MSG("~p terminate Reason ~p~n", [State#state.table, Reason]),
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
server_name(WriteTable) ->
    list_to_atom(lists:concat([?MODULE, "_", WriteTable])).

gs_server_name(WriteTable) ->
    list_to_atom(lists:concat(["gs_cron_", ?MODULE, "_", WriteTable])).

crontab_conf(monthly) ->
    {1, 0, 1};
crontab_conf(weekly) ->
    {1, 0, 1};
crontab_conf(daily) ->
    {21, 0, 0}.

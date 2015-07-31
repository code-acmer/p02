%%%-------------------------------------------------------------------
%%% @author li <lijunqiang@moyou.me>
%%% @copyright (C) 2015, li
%%% @doc
%%%
%%% @end
%%% Created : 17 Apr 2015 by li <lijunqiang@moyou.me>
%%%-------------------------------------------------------------------
-module(mod_league_rank).

-behaviour(gen_server).

-include("define_logger.hrl").
-include("define_league.hrl").
-include("define_try_catch.hrl").

%% API
-export([start_link/1, 
         get_rank_data/4,
         update_rank_data/1,
         reset_rank_data/0
        ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {bucket_rank_list = []}).

%%%===================================================================
%%% API
%%%===================================================================

get_rank_data(Sn, GroupNum, LastRank, Type) ->
    gen_server:call(get_processname(Sn), {get_rank_data, GroupNum, LastRank, Type}).

update_rank_data(BucketList) ->
    AllDbSn = server_misc:mnesia_sn_list(),
    lists:map(fun(Sn) -> 
                      ProcessName = get_processname(Sn),
                      gen_server:cast(ProcessName, {updata_rank_data, BucketList})
              end, AllDbSn).

reset_rank_data() ->
    AllDbSn = server_misc:mnesia_sn_list(),
    lists:map(fun(Sn) -> 
                      ProcessName = get_processname(Sn),
                      gen_server:cast(ProcessName, reset_rank_data)
              end, AllDbSn).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------

server_name(DbSn) ->
    server_misc:server_name(?MODULE, DbSn).

start_link(DbSn) ->
    Server = server_name(DbSn),
    gen_server:start_link({local, Server}, ?MODULE, [], []).


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
    {ok, #state{}, 1000}.

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
do_handle_call({get_rank_data, Group, LastRank, Type}, _From, #state{bucket_rank_list = BucketList} = State) ->
    %% 段位从 1 开始
    Len = length(BucketList),
    Reply = 
        if
            Group > Len orelse Group =< 0 ->
                {ok, [], 0};
            true ->
                Bucket = lists:nth(Group, BucketList),
                LeagueRelation = inner_get_data(LastRank, Type, Bucket),
                {ok, LeagueRelation, bucket_misc:size(Bucket)}
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

do_handle_cast({updata_rank_data, BucketList}, State) ->
    {noreply, State#state{bucket_rank_list = BucketList}};

do_handle_cast(reset_rank_data, State) ->
    lib_league_fight:reset_rank_data(),
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
do_handle_info(timeout, State) ->
    lib_league_fight:reset_rank_data(),
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

get_processname(Sn) ->
    list_to_atom(lists:concat([mod_league_rank, "_", Sn])).

inner_get_data(LastRank, ?PAGE_UP, Bucket) ->
    bucket_misc:get_data_smaller(LastRank, ?SEND_LEAGUE_COUNT, Bucket);
inner_get_data(LastRank, ?PAGE_DOWN, Bucket) ->
    bucket_misc:get_data_bigger(LastRank, ?SEND_LEAGUE_COUNT, Bucket);
inner_get_data(_, _, _) ->
    [].

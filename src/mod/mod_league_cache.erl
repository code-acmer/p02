%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@moyou.me>
%%% @copyright (C) 2014, liu
%%% @doc 主要是把工会列表做一个冗余处理储存
%%%
%%% @end
%%% Created : 16 Dec 2014 by liu <liuzhigang@moyou.me>
%%%-------------------------------------------------------------------
-module(mod_league_cache).

-behaviour(gen_server).

-include("define_league.hrl").
-include("define_info_40.hrl").
-include("define_logger.hrl").
-include_lib("stdlib/include/qlc.hrl").
-include("define_try_catch.hrl").

%% API
-export([start_link/1]).

-export([get_data/3,
         update_league/2,
         delete_league/2,
         sync_data/1,
         sync_data_with_dbsn/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-define(ETS_LEAGUE_CACHE, ets_league_cache).

-record(state, {mnesia_table,
                bucket}).

%%%===================================================================
%%% API
%%%===================================================================
get_data(Sn, LastRank, Type) ->
    ServerName = server_name(server_misc:get_mnesia_sn(Sn)),
    gen_server:call(ServerName, {get_data, LastRank, Type}).

sync_data(Sn) ->
    ServerName = server_name(server_misc:get_mnesia_sn(Sn)),
    gen_server:cast(ServerName, sync_data).

sync_data_with_dbsn(DbSn) ->
    ServerName = server_name(DbSn),
    gen_server:cast(ServerName, sync_data).

update_league(Sn, League) ->
    ServerName = server_name(server_misc:get_mnesia_sn(Sn)),
    gen_server:cast(ServerName, {update_league, League}).

delete_league(Sn, Rank) ->
    ServerName = server_name(server_misc:get_mnesia_sn(Sn)),
    gen_server:cast(ServerName, {delete_league, Rank}).

server_name(DbSn) ->
    list_to_atom(lists:concat([?MODULE, "_", DbSn])).
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(DbSn) -> 
    gen_server:start_link({local, server_name(DbSn)}, ?MODULE, [DbSn], []).

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
init([DbSn]) ->
    gen_server:cast(self(), sync_data),
    {ok, #state{mnesia_table = lib_league:get_write_table_with_dbsn(DbSn)}}.

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
do_handle_call({get_data, LastRank, Type}, _, #state{bucket = Bucket} = State) ->
    LeagueList = inner_get_data(LastRank, Type, Bucket),
    {reply, {ok, LeagueList, bucket_misc:size(Bucket)}, State};
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
do_handle_cast(sync_data, #state{mnesia_table = MnesiaTable} = State) ->
    Before = os:timestamp(),
    Bucket = store(MnesiaTable), %%整个字典和页数返回
    After = os:timestamp(),
    ?DEBUG("sync league data cost ~p microseconds", [timer:now_diff(After, Before)]),
    {noreply, State#state{bucket = Bucket}};
do_handle_cast({update_league, League}, #state{bucket = Bucket} = State) ->
    NewBucket = bucket_misc:insert(League#league.rank, League, Bucket),
    {noreply, State#state{bucket = NewBucket}};
do_handle_cast({delete_league, Rank}, #state{bucket = Bucket} = State) ->
    NewBucket = bucket_misc:delete(Rank, Bucket),
    {noreply, State#state{bucket = NewBucket}};
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
store(MnesiaTable) ->
    {atomic, LeagueList} = mnesia:transaction(fun() -> qlc:e(qlc:q([League || League <- mnesia:table(MnesiaTable)])) end),
    lists:foldl(fun(#league{rank = Rank} = League, AccBucket) ->
                        bucket_misc:insert(Rank, League, AccBucket)
                end, bucket_misc:new(?SEND_LEAGUE_COUNT), LeagueList).

inner_get_data(LastRank, ?PAGE_UP, Bucket) ->
    bucket_misc:get_data_smaller(LastRank, ?SEND_LEAGUE_COUNT, Bucket);
inner_get_data(LastRank, ?PAGE_DOWN, Bucket) ->
    bucket_misc:get_data_bigger(LastRank, ?SEND_LEAGUE_COUNT, Bucket);
inner_get_data(_, _, _) ->
    [].


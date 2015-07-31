%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created : 22 Aug 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_counter).
-include("define_logger.hrl").
-include("define_mnesia.hrl").
-include("define_counter.hrl").
-behaviour(gen_server).
%% API
-export([start_link/0]).

-export([init_new_counter/2,
         stop/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {center_node}).

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
init_new_counter(UidType, OldRangeId) ->
    gen_server:call(?SERVER, {init_new_counter, UidType, OldRangeId}).
stop() ->
    gen_server:call(?SERVER, stop).
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
    CenterList = app_misc:get_env(center_node),
    ?DEBUG("CenterList ~p~n", [CenterList]),
    %net_kernel:allow([Center]),  %%防止除了中心节点的其他节点的访问
    true = if_center_alive(CenterList),
    % net_kernel:monitor_nodes(true, [nodedown_reason, {node_type, all}]),
    {ok, #state{center_node = CenterList}}.

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
handle_call(stop, _, State) ->
    {stop, normal, ok, State};
handle_call({init_new_counter, UidType, OldRangeId}, _, #state{center_node = CenterList} = State) ->
    NewCenterList = 
        case inner_handle_new_counter(UidType, OldRangeId, CenterList) of
            ignore ->
                CenterList;
            {ok, CenterNode} ->
                [CenterNode|CenterList -- [CenterNode]]
        end,
    {reply, ok, State#state{center_node = NewCenterList}};
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
%% handle_info({nodedown, Node, Reason}, #state{center_node = CenterList} = State) ->
%%     %%有节点退出了，看是不是中心节点不在了
%%     case net_adm:ping(Node) of
%%         pong ->
%%             ?WARNING_MSG("monitor nodedown Node ~p Reason ~p but can reconnect~n", [Node, Reason]),
%%             {noreply, State};
%%         pang ->
%%             ?ERROR_MSG("monitor nodedown Node ~p Reason ~p~n", [Node, Reason]),
%%             {stop, normal, State} 
%%     end;
handle_info(_Info, State) ->
    ?WARNING_MSG("unexpected info ~p~n", [_Info]),
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
    ?WARNING_MSG("mod_counter stop Reason ~p~n", [Reason]),
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
inner_handle_new_counter(UidType, OldRangeId, CenterList) ->
    RangeId = 
        case hdb:dirty_read(counter, {UidType, ?ALL_NODES}) of
            [] ->
                undefined;
            #counter{counter = Counter} ->
                Counter
        end,
    if
        RangeId =:= OldRangeId ->
            rpc_get_counter(CenterList, OldRangeId, UidType);
        true ->
            ?WARNING_MSG("ignore UidType ~p, OldRangeId ~p Now RangeId ~p~n", [UidType, OldRangeId, RangeId]),
            ignore
    end.

if_center_alive([]) ->
    false;
if_center_alive([H|T]) ->
    case net_adm:ping(H) of
        pong ->
            true;
        pang ->
            if_center_alive(T)
    end.

rpc_get_counter([], _OldRangeId, _UidType) ->
    throw({call_center_error, not_alive_center_nodes});
rpc_get_counter([CenterNode|T], OldRangeId, UidType) ->
    case catch rpc:call(CenterNode, center, update_counter, [UidType, 1]) of
        NewRangeId when is_integer(NewRangeId) ->
            hdb:dirty_write(counter, #counter{type = {UidType, ?ALL_NODES},
                                              counter = NewRangeId}),
            hdb:dirty_write(counter, #counter{type = {UidType, node()},
                                              counter = (NewRangeId-1) * ?RANGE + 1}),
            ?WARNING_MSG("update uid UidType ~p, OldRangeId ~p NewRangeId ~p~n", [UidType, OldRangeId, NewRangeId]),
            {ok, CenterNode};
        Other ->
            ?WARNING_MSG("cannot get counter from ~p Reason ~p~n", [CenterNode, Other]),
            rpc_get_counter(T, OldRangeId, UidType)
    end.

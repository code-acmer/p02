-module(mod_node_monitor).

-behaviour(gen_server).

-export([start_link/0]).

-export([notify_node_up/0, notify_joined_cluster/0, notify_left_cluster/1]).
-export([partitions/0, partitions/1, subscribe/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-include("common.hrl").

-define(SERVER, ?MODULE).
-define(SERVER_UP_RPC_TIMEOUT, 2000).
-define(SERVER_DOWN_PING_INTERVAL, 1000).

-record(state, {
          monitors, 
          partitions, 
          subscribers, 
          down_ping_timer, 
          autoheal
         }).

start_link() -> 
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


%%----------------------------------------------------------------------------
%% Cluster notifications
%%----------------------------------------------------------------------------

notify_node_up() ->
    Nodes = mnesia_misc:cluster_nodes(running) -- [node()],
    gen_server:abcast(Nodes, ?SERVER,
                      {node_up, node(), mnesia_misc:node_type()}),
    ?PRINT("notify_node_up ~w~n", [Nodes]),
    %% register other active servers with this server
    DiskNodes = mnesia_misc:cluster_nodes(disc),
    [gen_server:cast(?SERVER, {node_up, N, case lists:member(N, DiskNodes) of
                                               true  -> disc;
                                               false -> ram
                                           end}) || N <- Nodes],
    ok.

notify_joined_cluster() ->
    Nodes = mnesia_misc:cluster_nodes(running) -- [node()],
    ?PRINT("notify_joined_cluster ~w~n", [Nodes]),
    gen_server:abcast(Nodes, ?SERVER,
                      {joined_cluster, node(), mnesia_misc:node_type()}),
    ok.

notify_left_cluster(Node) ->
    Nodes = mnesia_misc:cluster_nodes(running),
    ?PRINT("notify_left_cluster ~w~n", [Nodes]),
    gen_server:abcast(Nodes, ?SERVER, {left_cluster, Node}),
    ok.

%%----------------------------------------------------------------------------
%% Server calls
%%----------------------------------------------------------------------------

partitions() ->
    gen_server:call(?SERVER, partitions, infinity).

partitions(Nodes) ->
    {Replies, _} = gen_server:multi_call(Nodes, ?SERVER, partitions, infinity),
    Replies.

subscribe(Pid) ->
    gen_server:cast(?SERVER, {subscribe, Pid}).

%%----------------------------------------------------------------------------
%% gen_server callbacks
%%----------------------------------------------------------------------------

init([]) ->
    %% We trap exits so that the supervisor will not just kill us. We
    %% want to be sure that we are not going to be killed while
    %% writing out the cluster status files - bad things can then
    %% happen.
    process_flag(trap_exit, true),
    net_kernel:monitor_nodes(true),
    {ok, _} = mnesia:subscribe(system),
    {ok, #state{monitors    = pmon:new(),
                subscribers = pmon:new(),
                partitions  = [],
                autoheal    = lib_autoheal:init()}}.

handle_call(partitions, _From, State = #state{partitions = Partitions}) ->
    {reply, Partitions, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% Note: when updating the status file, we can't simply write the
%% mnesia information since the message can (and will) overtake the
%% mnesia propagation.
%% 从文件读取集群信息，该消息比mnesia传播还要快
handle_cast({node_up, Node, NodeType},
            State = #state{monitors = Monitors}) ->
    ?PRINT("server on node ~p up~n", [Node]),
    case pmon:is_monitored({server, Node}, Monitors) of
        true  -> 
            {noreply, State};
        false -> 
            {AllNodes, DiscNodes, RunningNodes} = lib_node_monitor:read_cluster_status(),
            lib_node_monitor:write_cluster_status(
              {lib_node_monitor:add_node(Node, AllNodes),
               case NodeType of
                   disc -> 
                       lib_node_monitor:add_node(Node, DiscNodes);
                   ram  -> 
                       DiscNodes
               end,
               lib_node_monitor:add_node(Node, RunningNodes)}),
            ok = handle_live_server(Node),
            {noreply, State#state{
                        monitors = pmon:monitor({server, Node}, Monitors)}}
    end;
handle_cast({joined_cluster, Node, NodeType}, State) ->
    lib_node_monitor:joined_cluster(Node, NodeType),
    {noreply, State};
handle_cast({left_cluster, Node}, State) ->
    ?PRINT("left_cluster ~p~n", [Node]),
    lib_node_monitor:left_cluster(Node),
    {noreply, State};
handle_cast({subscribe, Pid}, State = #state{subscribers = Subscribers}) ->
    {noreply, State#state{subscribers = pmon:monitor(Pid, Subscribers)}};
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({'DOWN', _MRef, process, {server, Node}, _Reason},
            State = #state{monitors = Monitors, subscribers = Subscribers}) ->
    ?PRINT("server on node ~p down~n", [Node]),
    lib_node_monitor:node_down(Node),
    ok = handle_dead_server(Node),
    [P ! {node_down, Node} || P <- pmon:monitored(Subscribers)],
    {noreply, handle_dead_server_state(
                Node,
                State#state{monitors = pmon:erase({server, Node}, Monitors)})};

handle_info({'DOWN', _MRef, process, Pid, _Reason},
            State = #state{subscribers = Subscribers}) ->
    {noreply, State#state{subscribers = pmon:erase(Pid, Subscribers)}};

handle_info({nodedown, Node}, State) ->
    ok = handle_dead_node(Node),
    {noreply, State};

handle_info({mnesia_system_event,
             {inconsistent_database, running_partitioned_network, Node}},
            State = #state{partitions = Partitions,
                           monitors   = Monitors,
                           autoheal   = AState}) ->
    %% We will not get a node_up from this node - yet we should treat it as
    %% up (mostly).
    ?PRINT("mnesia_system_event ~p~n", [Node]),
    State1 = case pmon:is_monitored({server, Node}, Monitors) of
                 true  -> State;
                 false -> State#state{
                            monitors = pmon:monitor({server, Node}, Monitors)}
             end,
    ok = handle_live_server(Node),
    Partitions1 = ordsets:to_list(
                    ordsets:add_element(Node, ordsets:from_list(Partitions))),
    {noreply, State1#state{partitions = Partitions1,
                           autoheal   = lib_autoheal:maybe_start(AState)}};

handle_info({autoheal_msg, Msg}, State = #state{autoheal   = AState,
                                                partitions = Partitions}) ->
    AState1 = lib_autoheal:handle_msg(Msg, AState, Partitions),
    {noreply, State#state{autoheal = AState1}};

handle_info(ping_nodes, State) ->
    %% We ping nodes when some are down to ensure that we find out
    %% about healed partitions quickly. We ping all nodes rather than
    %% just the ones we know are down for simplicity; it's not expensive
    %% to ping the nodes that are up, after all.
    State1 = State#state{down_ping_timer = undefined},
    Self = self(),
    %% all_nodes_up() both pings all the nodes and tells us if we need to again.
    %%
    %% We ping in a separate process since in a partition it might
    %% take some noticeable length of time and we don't want to block
    %% the node monitor for that long.
    spawn_link(fun () ->
                       case lib_node_monitor:all_nodes_up() of
                           true  -> 
                               ok;
                           false -> 
                               Self ! ping_again
                       end
               end),
    {noreply, State1};

handle_info(ping_again, State) ->
    {noreply, ensure_ping_timer(State)};

handle_info(_Info, State) ->
    ?WARNING_MSG("~p", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->    
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------------------------------
%% Functions that call the module specific hooks when nodes go up/down
%%----------------------------------------------------------------------------

%% TODO: This may turn out to be a performance hog when there are lots
%% of nodes.  We really only need to execute some of these statements
%% on *one* node, rather than all of them.
handle_dead_server(Node) ->
    ok = rabbit_networking:on_node_down(Node),
    ok = rabbit_amqqueue:on_node_down(Node),
    ok = rabbit_alarm:on_node_down(Node),
    ok = mnesia_misc:on_node_down(Node),
    ok.

handle_dead_node(_Node) ->
    %% In general in mod_node_monitor we care about whether the
    %% server application is up rather than the node; we do this so
    %% that we can respond in the same way to "server_ctl stop_app"
    %% and "server_ctl stop" as much as possible.
    %%
    %% However, for pause_minority mode we can't do this, since we
    %% depend on looking at whether other nodes are up to decide
    %% whether to come back up ourselves - if we decide that based on
    %% the rabbit application we would go down and never come back.
    case app_misc:get_env(cluster_partition_handling, ignore) of
        pause_minority ->
            case majority() of
                true  -> ok;
                false -> await_cluster_recovery()
            end;
        ignore ->
            ok;
        autoheal ->
            ok;
        Term ->
            ?PRINT("cluster_partition_handling ~p unrecognised, "
                               "assuming 'ignore'~n", [Term]),
            ok
    end.

await_cluster_recovery() ->
    ?PRINT("Cluster minority status detected - awaiting recovery~n", []),
    Nodes = mnesia_misc:cluster_nodes(all),
    lib_node_monitor:run_outside_applications(
      fun () ->
              main:stop(),
              wait_for_cluster_recovery(Nodes)
      end),
    ok.



wait_for_cluster_recovery(Nodes) ->
    case majority() of
        true  -> main:start();
        false -> timer:sleep(?SERVER_DOWN_PING_INTERVAL),
                 wait_for_cluster_recovery(Nodes)
    end.

handle_dead_server_state(Node, State = #state{partitions = Partitions,
                                              autoheal   = Autoheal}) ->
    %% If we have been partitioned, and we are now in the only remaining
    %% partition, we no longer care about partitions - forget them. Note
    %% that we do not attempt to deal with individual (other) partitions
    %% going away. It's only safe to forget anything about partitions when
    %% there are no partitions.
    Partitions1 = case Partitions -- (Partitions -- lib_node_monitor:alive_server_nodes()) of
                      [] -> [];
                      _  -> Partitions
                  end,
    ensure_ping_timer(
      State#state{partitions = Partitions1,
                  autoheal   = lib_autoheal:node_down(Node, Autoheal)}).

ensure_ping_timer(State) ->
    timer_misc:ensure_timer(
      State, #state.down_ping_timer, ?SERVER_DOWN_PING_INTERVAL, ping_nodes).

handle_live_server(Node) ->
    ok = mnesia_misc:on_node_up(Node).


majority() ->
    Nodes = mnesia_misc:cluster_nodes(all),
    length(lib_node_monitor:alive_nodes(Nodes)) / length(Nodes) > 0.5.

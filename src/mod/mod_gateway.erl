%%%-------------------------------------------------------------------
%%% @author Arno <>
%%% @copyright (C) 2013, Arno
%%% @doc
%%%
%%% @end
%%% Created : 20 Nov 2013 by Arno <>
%%%-------------------------------------------------------------------
-module(mod_gateway).

-behaviour(gen_server).

%% API
-export([start_link/0,
         get_node_list/0,
         stop/0,
         get_mnesia_node/0,
         start_all_nodes/0,
         stop_all_nodes/0
        ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-include("define_logger.hrl").
-include("define_mnesia.hrl").

-define(SERVER, ?MODULE). 

-record(state, {node_list = []
               }).

%%%===================================================================
%%% API
%%%===================================================================
stop() ->
    gen_server:cast(?MODULE, stop).

get_node_list() ->
    gen_server:call(?MODULE, get_node_list).

get_mnesia_node() ->
    gen_server:call(?MODULE, get_mnesia_node).

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
    NodeList = case inner_get_node_list() of
                   {error, _} ->
                       [];
                   Nodes ->
                       Nodes
               end,
    inner_connect_nodes(NodeList),
    erlang:send_after(60 * 1000, self(), connect_nodes),
    erlang:send_after(180 * 1000, self(), push_node_status),
    {ok, #state{node_list = NodeList}}.

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
handle_call(get_node_list, _From, State) ->
    Reply = lists:map(fun({Node, _Ip, _Port, _Type}) ->
                              Node
                      end, State#state.node_list),
    {reply, Reply, State};
handle_call(get_mnesia_node, _From, State) ->
    Reply = lists:map(fun({Node, _Ip, _Port, Type}) ->
                              {Type, Node}
                      end, State#state.node_list),
    {reply, Reply, State};
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
handle_cast(stop, State) ->
    
    {stop, normal, State};
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
handle_info(connect_nodes, State) ->
    NodeList = case inner_get_node_list() of
                   {error, _} ->
                       State#state.node_list;
                   Nodes ->
                       Nodes
               end,
    inner_connect_nodes(NodeList),
    erlang:send_after(60 * 1000, self(), connect_nodes),
    {noreply, State};
handle_info(push_node_status, State) ->
    inner_push_node_status(),
    erlang:send_after(60 * 1000, self(), push_node_status),
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
terminate(_Reason, _State) ->
    inner_close_node(),
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

inner_connect_nodes(NodeList) ->
    lists:foreach(fun({Node, _Ip, _Port, _Type}) ->
                          if
                              Node =/= node() -> 
                                  case net_adm:ping(Node) of
                                      pang ->
                                          ?INFO_MSG("Node : ~w is not online. ~n",[Node]),
                                          %% failed
                                          ok;
                                      pong ->
                                          %% success
                                          ok
                                  end;
                              true -> 
                                  ignore
                          end
                  end, NodeList).

inner_push_node_status() ->
    Ip = proplists:get_value(ip, app_misc:get_env(game_listener)),
    Port = proplists:get_value(port, app_misc:get_env(game_listener)),
    case catch mod_monitor:get_player_count() of
        Num  
          when is_integer(Num) ->
            Node = node(),
            IsClosed = app_misc:get_env(is_closed, 0),
            hdb:dirty_write(node_status, #node_status{node = Node,
                                                      ip   = Ip,
                                                      port = Port,
                                                      is_close = IsClosed,
                                                      num  = Num
                                                     });
        Other ->
            ?WARNING_MSG("get_player_count failed! Other:~w~n",[Other]),
            Node = node(),
            hdb:dirty_write(node_status, #node_status{node = Node,
                                                      ip   = Ip,
                                                      port = Port,
                                                      is_close = 1,
                                                      num  = 0
                                                     })
    end.

inner_close_node() ->
    Node = node(),
    case hdb:dirty_read(node_status, Node) of
        [] ->
            ignore;
        NodeStatus ->
            hdb:dirty_write(node_status, NodeStatus#node_status{num = 0,
                                                                is_close = 1
                                                               })
    end.

inner_get_node_list() ->
    %% Url = "http://192.168.1.99/node_list.php",
    case lib_http_client:request(app_misc:get_env(server_list_url)) of
        {ok, _Status, _ResponseHeaders, Body} ->
            decode_body(Body);
        {error, HTTPReason} ->
            ?WARNING_MSG("http_client send request error ~p~n", [HTTPReason]),
            {error, HTTPReason}
    end.


decode_body(Body) ->
    try 
        case mochijson:decode(Body) of
            {array, NodeList} -> 
                lists:foldl(fun({struct, InfoList}, Ret) ->
                                    Node = case lists:keyfind("node", 1, InfoList) of
                                               {_, SrcNodeName} ->
                                                   hmisc:to_atom(SrcNodeName);
                                               false ->
                                                   undefined
                                           end,
                                    Ip   = case lists:keyfind("ip", 1, InfoList) of
                                               {_, SrcIp} ->
                                                   SrcIp;
                                               false ->
                                                   undefined
                                           end,
                                    Port = case lists:keyfind("port", 1, InfoList) of
                                               {_, SrcPort} ->
                                                   hmisc:to_integer(SrcPort);
                                               false ->
                                                   undefined
                                           end,
                                    Type = case lists:keyfind("type", 1, InfoList) of
                                               {_, SrcType} ->
                                                   hmisc:to_atom(SrcType);
                                               false ->
                                                   undefined
                                           end,
                                    if
                                        Node =/= undefined andalso
                                        Ip   =/= undefined andalso 
                                        Port =/= undefined andalso
                                        Type =/= undefined -> 
                                            [{Node, Ip, Port, Type}|Ret];
                                        true -> 
                                            Ret
                                    end
                            end, [],NodeList);
            _ ->
                ?WARNING_MSG("inner_get_node_list failed Body:~p~n",[Body]),
                []
        end
    catch _:R ->
            ?WARNING_MSG("deocde node_list failed! R:~w, Statck:~p~n", [R, erlang:get_stacktrace()]),
            []
    end.

stop_all_nodes() ->
    Nodes = [node()|nodes()],
    stop_all_nodes([], Nodes, 0).

start_all_nodes() ->
    Nodes = [node()|nodes()],
    start_all_nodes(Nodes).


stop_all_nodes(Success, [], _N) ->
    {ok, Success};
stop_all_nodes(Success, FailedNode, 3) ->
    ?WARNING_MSG("try stop nodes failed Fail Nodes : ~p~n", [FailedNode]),
    %%?WARNING_MSG("trying to restart stopped nodes : ~p~n", [Success]),
    %% start_other_nodes(Success),
    error;
stop_all_nodes(Success, Nodes, N) ->
    {SuccessRet, Failed}= lists:foldl(fun(Node, {SuccessNode, FailedNode}) ->
                                              case catch rpc:call(Node, main, server_started, []) of
                                                  true ->
                                                      case catch rpc:call(Node, main, server_stop, [5]) of
                                                          ok ->
                                                              {[Node|SuccessNode], FailedNode};
                                                          _Other ->
                                                              ?WARNING_MSG("stop_other_nodes failed!!! OTHER : ~p~n",[_Other]),
                                                              {SuccessNode, [Node|FailedNode]}
                                                      end;
                                                  _ ->
                                                      ?WARNING_MSG("node ~w server is aleady stopped.~n",[Node]),
                                                      {[Node|SuccessNode], FailedNode}
                                              end
                                      end, {[], []}, Nodes),
    stop_all_nodes(SuccessRet ++ Success, Failed, N + 1).

    
start_all_nodes(Nodes) ->
    lists:foreach(fun(Node) ->
                          case catch rpc:call(Node, main, server_started, []) of
                              false->
                                  case catch rpc:call(Node, main, server_start, []) of
                                      ok ->
                                          ?WARNING_MSG("Node : ~w start success~n",[Node]);
                                      R ->
                                          ?WARNING_MSG("Node : ~w start failed R : ~p ~n",[Node, R])
                                  end;
                              _ ->
                                  ?WARNING_MSG("node : ~w server is aleady started.~n",[Node])
                          end
                  end, Nodes).
                                             

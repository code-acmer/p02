%%% @author Roowe <bestluoliwe@gmail.com>
%%% @copyright (C) 2013, Roowe
%%% @doc
%%%
%%% @end
%%% Created : 22 Dec 2013 by Roowe <bestluoliwe@gmail.com>

-module(lib_node_monitor).
-export([prepare_cluster_status_files/0]).

-export([read_cluster_status/0, write_cluster_status/1, update_cluster_status/0, reset_cluster_status/0]).

-export([add_node/2, del_node/2]).

-export([joined_cluster/2, left_cluster/1, node_down/1]).

-export([cluster_status_filename/0, running_nodes_filename/0]).

-export([alive_nodes/1, all_server_nodes_up/0, all_nodes_up/0, alive_server_nodes/0]).


-export([run_outside_applications/1]).

prepare_cluster_status_files() ->
    mnesia_misc:ensure_mnesia_dir(),
    Corrupt = fun(F) -> 
                      throw({error, corrupt_cluster_status_files, F}) 
              end,
    RunningNodes1 = 
        case try_read_file(running_nodes_filename()) of
            {ok, [Nodes]} when is_list(Nodes) -> 
                Nodes;
            {ok, Other} -> 
                Corrupt(Other);
            {error, enoent} -> 
                []
        end,
    ThisNode = [node()],
    %% The running nodes file might contain a set or a list, in case
    %% of the legacy file
    RunningNodes2 = lists:usort(ThisNode ++ RunningNodes1),
    {AllNodes1, DiscNodes} =
        case try_read_file(cluster_status_filename()) of
            {ok, [{AllNodes, DiscNodes0}]} ->
                {AllNodes, DiscNodes0};
            {ok, [AllNodes0]} when is_list(AllNodes0) ->
                {legacy_cluster_nodes(AllNodes0), legacy_disc_nodes(AllNodes0)};
            {ok, Files} ->
                Corrupt(Files);
            {error, enoent} ->
                LegacyNodes = legacy_cluster_nodes([]),
                {LegacyNodes, LegacyNodes}
        end,
    AllNodes2 = lists:usort(AllNodes1 ++ RunningNodes2),
    ok = write_cluster_status({AllNodes2, DiscNodes, RunningNodes2}).

%%----------------------------------------------------------------------------
%% Cluster file operations
%%----------------------------------------------------------------------------

%% The cluster file information is kept in two files.  The "cluster
%% status file" contains all the clustered nodes and the disc nodes.
%% The "running nodes file" contains the currently running nodes or
%% the running nodes at shutdown when the node is down.
%%
%% We strive to keep the files up to date and we rely on this
%% assumption in various situations. Obviously when mnesia is offline
%% the information we have will be outdated, but it cannot be
%% otherwise.

running_nodes_filename() ->
    filename:join(mnesia_misc:dir(), "nodes_running_at_shutdown").

cluster_status_filename() ->
    mnesia_misc:dir() ++ "/cluster_nodes.config".

write_cluster_status({All, Disc, Running}) ->
    ClusterStatusFN = cluster_status_filename(),
    Res = case file_misc:write_term_file(ClusterStatusFN, [{All, Disc}]) of
              ok ->
                  RunningNodesFN = running_nodes_filename(),
                  {RunningNodesFN,
                   file_misc:write_term_file(RunningNodesFN, [Running])};
              E1 = {error, _} ->
                  {ClusterStatusFN, E1}
          end,
    case Res of
        {_, ok} ->
            ok;
        {FN, {error, E2}} -> 
            throw({error, {could_not_write_file, FN, E2}})
    end.

read_cluster_status() ->
    case {try_read_file(cluster_status_filename()),
          try_read_file(running_nodes_filename())} of
        {{ok, [{All, Disc}]}, {ok, [Running]}} when is_list(Running) ->
            {All, Disc, Running};
        {Stat, Run} ->
            throw({error, {corrupt_or_missing_cluster_files, Stat, Run}})
    end.

update_cluster_status() ->
    {ok, Status} = mnesia_misc:cluster_status_from_mnesia(),
    write_cluster_status(Status).

reset_cluster_status() ->
    write_cluster_status({[node()], [node()], [node()]}).

try_read_file(FileName) ->
    case file:consult(FileName) of
        {ok, Term} -> 
            {ok, Term};
        {error, enoent} -> 
            {error, enoent};
        {error, E} -> 
            throw({error, {cannot_read_file, FileName, E}})
    end.

legacy_cluster_nodes(Nodes) ->
    %% We get all the info that we can, including the nodes from
    %% mnesia, which will be there if the node is a disc node (empty
    %% list otherwise)
    lists:usort(Nodes ++ mnesia:system_info(db_nodes)).

legacy_disc_nodes(AllNodes) ->
    case AllNodes == [] orelse lists:member(node(), AllNodes) of
        true  -> 
            [node()];
        false -> 
            []
    end.

add_node(Node, Nodes) ->
    lists:usort([Node | Nodes]).

del_node(Node, Nodes) -> 
    Nodes -- [Node].

joined_cluster(Node, NodeType) ->
    {AllNodes, DiscNodes, RunningNodes} = read_cluster_status(),
    write_cluster_status({add_node(Node, AllNodes),
                          case NodeType of
                              disc -> 
                                  add_node(Node, DiscNodes);
                              ram  -> 
                                  DiscNodes
                          end,
                          RunningNodes}).


left_cluster(Node) ->
    {AllNodes, DiscNodes, RunningNodes} = read_cluster_status(),
    write_cluster_status({del_node(Node, AllNodes), 
                          del_node(Node, DiscNodes),
                          del_node(Node, RunningNodes)}).

node_down(Node) ->
    {AllNodes, DiscNodes, RunningNodes} = read_cluster_status(),
    write_cluster_status({AllNodes, DiscNodes, del_node(Node, RunningNodes)}).


%% mnesia:system_info(db_nodes) (and hence
%% mnesia_misc:cluster_nodes(running)) does not give reliable
%% results when partitioned. So we have a small set of replacement
%% functions here. "server" in a function's name implies we test if
%% the server application is up, not just the node.



all_nodes_up() ->
    Nodes = mnesia_misc:cluster_nodes(all),
    length(alive_nodes(Nodes)) =:= length(Nodes).

all_server_nodes_up() ->
    Nodes = mnesia_misc:cluster_nodes(all),
    length(alive_server_nodes(Nodes)) =:= length(Nodes).

alive_nodes(Nodes) ->
    [N || N <- Nodes, pong =:= net_adm:ping(N)].

alive_server_nodes(Nodes) ->
    [N || N <- alive_nodes(Nodes), main:is_running(N)].

alive_server_nodes() -> 
    alive_server_nodes(mnesia_misc:cluster_nodes(all)).


run_outside_applications(Fun) ->
    spawn(fun () ->
                  %% If our group leader is inside an application we are about
                  %% to stop, application:stop/1 does not return.
                  group_leader(whereis(init), self()),
                  %% Ensure only one such process at a time, the
                  %% exit(badarg) is harmless if one is already running
                  try register(server_outside_app_process, self()) of
                      true-> 
                          Fun()
                  catch error:badarg ->
                          ok
                  end
          end).

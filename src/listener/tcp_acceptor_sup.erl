%%%-----------------------------------
%%% @Module  : tcp_acceptor_sup
%%% @Created : 2011.06.01 
%%% @Description: tcp acceptor 监控树
%%%-----------------------------------
-module(tcp_acceptor_sup).
-behaviour(supervisor).
-export([start_link/1, init/1, start_child/2]).

start_link(Module) ->
    supervisor:start_link({local, accept_sup(Module)}, ?MODULE, [Module]).

accept_sup(Module) ->
    list_to_atom(atom_to_list(?MODULE) ++ "_" ++ atom_to_list(Module)).

start_child(Module, ListenSocket) ->    
    supervisor:start_child(accept_sup(Module), [ListenSocket]).

init([Module]) ->
    {ok, {{simple_one_for_one, 10, 10},
          [{tcp_acceptor, {tcp_acceptor, start_link, [Module]},
            transient, brutal_kill, worker, [tcp_acceptor]}]}}.

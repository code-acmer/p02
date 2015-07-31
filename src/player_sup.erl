%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created : 31 Jul 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(player_sup).

-behaviour(supervisor).
%% API
-export([start_link/0]).
-export([start_link/1]).
-export([start_child/1]).
-export([start_child/2]).
-export([broadcast_all_player/2]).
-export([broadcast_all_player/1]).
-export([]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

-define(SN_NUM, 3).

-include("define_logger.hrl").

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_link(ServerName) ->
    supervisor:start_link({local, ServerName}, ?MODULE, []).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @spec init(Args) -> {ok, {SupFlags, [ChildSpec]}} |
%%                     ignore |
%%                     {error, Reason}
%% @end
%%--------------------------------------------------------------------
%% init([]) ->
%%     {ok, { {simple_one_for_one, 5, 10}, [] }}.

init([]) ->
    %% for child
    {ok,
     {{simple_one_for_one, 10, 10},
      [
       %% TCP Client
       {undefined,
        {mod_player, start_link, []},
        temporary,
        16#ffffffff,
        worker,
        [mod_player]
       }
      ]
     }
    }.

%%%===================================================================
%%% Internal functions
%%%===================================================================
start_child(Client) ->
    supervisor:start_child(?MODULE, [Client]).

start_child(ServerName, Client) ->
    ?DEBUG("ServerName: ~p", [ServerName]),
    supervisor:start_child(ServerName, [Client]).


broadcast_all_player(Fun,Sn) 
  when is_function(Fun)->
    [Fun(PlayerPid) || {_, PlayerPid, _, _} <- supervisor:which_children(server_name(Sn))];

broadcast_all_player(_, _) ->
    skip.

broadcast_all_player(Fun)
  when is_function(Fun)->
    lists:map(fun(Sn) ->
                      [Fun(PlayerPid) || {_, PlayerPid, _, _} <- supervisor:which_children(server_name(Sn))]
              end, server_misc:mnesia_sn_list());

broadcast_all_player(_) ->
    skip.

server_name(DbSn) ->
    server_misc:server_name(?MODULE, DbSn).


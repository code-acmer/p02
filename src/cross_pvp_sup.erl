%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created : 31 Jul 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(cross_pvp_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).
-export([start_child/1,
         broadcast_all_child/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

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
       {undefined,
        {mod_team_pvp, start_link, []},
        temporary,
        16#ffffffff,
        worker,
        [mod_team_pvp]
       }
      ]
     }
    }.

%%%===================================================================
%%% Internal functions
%%%===================================================================
start_child(TeamNum) ->
    supervisor:start_child(?MODULE, [TeamNum]).

broadcast_all_child(Fun) 
  when is_function(Fun)->
    [Fun(Pid) || {_, Pid, _, _} <- supervisor:which_children(?MODULE)];
broadcast_all_child(_) ->
    [].

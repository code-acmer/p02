%%%-------------------------------------------------------------------
%%% @author human <humanzhigang@gzleshu.com>
%%% @copyright (C) 2014, human
%%% @doc
%%%
%%% @end
%%% Created : 29 Sep 2014 by human <humanzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(robot_ping_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

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
    supervisor:start_link({local, ?MODULE}, ?MODULE, [{"127.0.0.1", 8801, 33, 1}]).

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
init([{Ip, Port, RobotNum, ServerNum}]) ->
    %% application:start(hstdlib),
    %% application:start(ibrowse),
    %% hloglevel:set(6),
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = 2000,
    Type = worker,

    AChild = {undefined, {robot_ping, start_link, [Ip, Port, RobotNum, ServerNum]},
              Restart, Shutdown, Type, [robot_ping]},

    {ok, {SupFlags, [AChild]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

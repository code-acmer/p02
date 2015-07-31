%%%-------------------------------------------------------------------
%%% @author human <humanzhigang@gzleshu.com>
%%% @copyright (C) 2015, human
%%% @doc
%%%
%%% @end
%%% Created : 10 Mar 2015 by human <humanzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(player_center_sup).

-behaviour(supervisor).
-include("define_logger.hrl").

%% API
-export([start_link/0
        ]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

-define(SN_NUM, 3).

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
init([]) ->
    {ok, { {one_for_one, 5, 10}, player_sup_msg()} }.

%%%===================================================================
%%% Internal functions
%%%===================================================================

player_sup_msg() ->
    [player_sup_msg1(server_misc:server_name(player_sup, Sn),
                     player_sup, 
                     [server_misc:server_name(player_sup, Sn)])
     || Sn <- server_misc:mnesia_sn_list()].

player_sup_msg1(ProcessName, ModuleName, Args) ->
    {ProcessName,
     {ModuleName, start_link, Args},
     permanent, 
     infinity, 
     supervisor, 
     [ModuleName]
    }.

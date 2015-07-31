
-module(server_sup).

-behaviour(supervisor).

-include("define_logger.hrl").

%% API
-export([start_link/0,
         start_child/2,
         start_child/3,
         start_sup_child/2%% ,
         %% start_sup_child/3
        ]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10}, [
                                  %% ?CHILD(mod_player_recommened, worker),
                                  %% ?CHILD(mod_monitor, worker),
                                  %% ?CHILD(mod_h_log, worker),
                                  %% ?CHILD(mod_mnesia_statistics, worker)
                                 ]} }.

start_child(ModuleName, Args) ->
    {ok,_} = supervisor:start_child(
               server_sup,
               {ModuleName,
                {ModuleName, start_link, Args},
                permanent, 10000, worker, [ModuleName]}),
    ok.

start_child(Name, ModuleName, Args) ->
    {ok,_} = supervisor:start_child(
               server_sup,
               {Name,
                {ModuleName, start_link, Args},
                permanent, 10000, worker, [ModuleName]}),
    ok.

start_sup_child(ModuleName, Args) ->
    {ok,_} = supervisor:start_child(
               server_sup,
               {ModuleName,
                {ModuleName, start_link, Args},
                permanent, infinity, supervisor, [ModuleName]}),
    ok.

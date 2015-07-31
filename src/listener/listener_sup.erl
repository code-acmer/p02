
-module(listener_sup).

-behaviour(supervisor).

%% API
-export([
         start_link/2,
         start_child/2
        ]).

%% Supervisor callbacks
-export([init/1]).

%% -define(CLIENT_SUP_TCP, tcp_client_sup).
%% -define(CLIENT_SUP_UDP, udp_client_sup).
%% -define(MAX_RESTART,    5).
%% -define(MAX_TIME,      60).
-include("define_network.hrl").

-define(SERVER, ?MODULE).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================
%% default start link
start_child(Module, Socket) ->
    supervisor:start_child(child_sup(Module), [Socket]).

start_link(ListenPort, Module) ->
    ListenName = list_to_atom(atom_to_list(Module) ++ "_" ++ atom_to_list(?MODULE)),
    supervisor:start_link({local, ListenName}, ?MODULE, [ListenPort, Module]).

child_sup(Module) ->
    list_to_atom("listener_sup_" ++ atom_to_list(Module)).


%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([Port, Module]) ->
    %% for listener port
    TcpListener =
        {listener_sup,
         {tcp_listener, start_link, [Port, Module]},
         permanent,
         2000,
         worker,
         [tcp_listener]
        },
    TcpClientSupervisor = 
        {child_sup(Module),
         {supervisor, start_link, 
          [{local, child_sup(Module)}, ?MODULE, [Module]]},
         permanent,
         infinity,
         supervisor,
         []
        },
    {ok,
     {{one_for_one, ?MAX_RESTART, ?MAX_TIME},
      [TcpListener, TcpClientSupervisor]
     }
    };
init([Module]) ->
    %% for child
    {ok,
     {_SupFlags = {simple_one_for_one, ?MAX_RESTART, ?MAX_TIME},
      [
       %% TCP Client
       {undefined,
        {Module, start_link, []},
        temporary,
        2000,
        worker,
        []
       }
      ]
     }
    }.


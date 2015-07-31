-module(p02_center_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(StartType, _StartArgs) ->
    error_logger:info_msg("p02_center_app start on ~p StartType ~p~n", [node(), StartType]),
    center:start(),
    p02_center_sup:start_link().

stop(State) ->
    error_logger:info_msg("p02_center_app stop on ~p State ~p~n", [node(), State]),
    ok.


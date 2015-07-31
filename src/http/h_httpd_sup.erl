%%% @author Roowe <bestluoliwe@gmail.com>
%%% @copyright (C) 2013, Roowe
%%% @doc
%%%
%%% @end
%%% Created :  3 Nov 2013 by Roowe <bestluoliwe@gmail.com>

-module(h_httpd_sup).
-behaviour(supervisor).

-export([start_link/2]).
-export([init/1]).

start_link(Port, Mod) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [Port, Mod]).

init([Port, Mod]) ->
    Web = web_specs(Mod, Port),
    Processes = [Web],
    Strategy = {one_for_one, 10, 10},
    {ok,
     {Strategy, Processes}}.

web_specs(Mod, Port) ->
    WebConfig = [{ip, {0,0,0,0}}, {port, Port}],
    {Mod,
     {Mod, start, [WebConfig]},
     permanent, 5000, worker, dynamic}.


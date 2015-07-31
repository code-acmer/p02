%%%-------------------------------------------------------------------
%%% @author Roowe <bestluoliwe@gmail.com>
%%% @copyright (C) 2013, Roowe
%%% @doc
%%%
%%% @end
%%% Created : 18 Oct 2013 by Roowe <bestluoliwe@gmail.com>
%%%-------------------------------------------------------------------
-module(server_test).

%% Note: This directive should only be used in test suites.
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

%%--------------------------------------------------------------------
%% TEST SERVER CALLBACK FUNCTIONS
%%--------------------------------------------------------------------
%% -define(setup(F), {setup, fun start/0, fun stop/1, F}).

%% start() ->
%%     ok = application:start(hstdlib),
%%     ok = application:start(mysql),
%%     ok = application:start(leshu_db),
%%     ok = application:start(server).

%% stop(_) ->
%%     application:stop(server),
%%     application:stop(mysql),
%%     application:stop(leshu_db),
%%     application:stop(hstdlib).

%% is_start(_) ->
%%     [?_assertNot(undefined == whereis(hstdlib_sup)),
%%      ?_assertNot(undefined == whereis(common02_sup)),
%%      ?_assertNot(undefined == whereis(leshu_db_sup)),
%%      ?_assertNot(undefined == whereis(server_sup))].

%% server_start_test_() ->
%%     {"server start test",
%%      ?setup(fun is_start/1)}.
%%     %% ok = application:start(server),
%%     %% ?assertEqual(config:get_tcp_listener_ip(), 1),
%%     %% ?assertEqual(config:get_tcp_listener_port(), 1),


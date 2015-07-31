%%%-------------------------------------------------------------------
%%% @author zhangr <zhangr011@gmail.com>
%%% @copyright (C) 2013, zhangr
%%% @doc
%%%
%%% @end
%%% Created : 18 Oct 2013 by zhangr
%%%-------------------------------------------------------------------
-module(dynamic_config_test).

%% Note: This directive should only be used in test suites.
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

%% -define(setup(F), {setup, fun start/0, fun stop/1, F}).

%% start() ->
%%     ok = application:start(hstdlib).

%% stop(_) ->
%%     application:stop(hstdlib).

%% enviroment_test_() ->
%%     {"check start test",
%%      fun is_start/1}.

%% dynamic_compile_test_() ->
%%     {"dynamic compile test",
%%      fun dynamic_compile/0}.

%% dynamic_log_test_() ->
%%     {"dynamic log test",
%%      fun dynamic_log/0}.

%% %%% ACTUAL TESTS %%%
%% is_start(_) ->
%%     [?_assertNot(undefined == whereis(hstdlib))].

%% dynamic_compile() ->
%%     dynamic_config:start(),
%%     [?assertEqual(config:get_can_gmcmd(), 0),
%%      ?assertEqual(config:get_game_name(), [])].
%%     %% ?assertNotEqual(config:get_tcp_listener_ip(), undefined),
%%     %% ?assertNotEqual(config:get_tcp_listener_port(), undefined),
%%     %% ?assertNotEqual(config:get_data_words_version(), undefined),
%%     %% ?assertEqual(config:get_can_gmcmd(), 1).

%% dynamic_log() ->
%%     loglevel:set(3),
%%     logger:error_msg(?MODULE, ?LINE, "~p~n", [big_problem]),
%%     logger:error_msg(?MODULE, ?LINE, "~p~n", [1]),
%%     [?assertEqual(true, true)].


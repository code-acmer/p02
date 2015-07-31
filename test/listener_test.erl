%%%-------------------------------------------------------------------
%%% @author zhangr <zhangr011@gmail.com>
%%% @copyright (C) 2013, zhangr
%%% @doc
%%%
%%% @end
%%% Created : 18 Oct 2013 by zhangr
%%%-------------------------------------------------------------------
-module(listener_test).

%% Note: This directive should only be used in test suites.
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

-define(setup(F), {setup, fun start/0, fun stop/1, F}).

start() ->
    ok = application:start(hstdlib),
    hloglevel:set(6).

stop(_) ->
    application:stop(hstdlib).

%%% TESTS DESCRIPTIONS %%%
enviroment_test_() ->
    {"Check enviroment",
     ?setup(fun is_start/1)}.

listener_test_() ->
    {"Check listener's start",
     ?setup(fun listener_start/1)}.

is_start(_) ->
    [?_assertNot(undefined == whereis(hstdlib_sup))].

listener_start(_) ->
    %% listener_sup:start_link(8802, tcp_client_handler),
    [?_assertNot(undefined =/= whereis(listener_sup))].


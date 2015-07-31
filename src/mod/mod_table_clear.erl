%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc %%这个server主要是用来定时做一些数据表的清理工作
%%%
%%% @end
%%% Created : 22 Aug 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_table_clear).

-include("define_mnesia.hrl").
-include("define_logger.hrl").
-include("define_try_catch.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-define(RESET_TABLE, [{lucky_coin, daily}]). %%表和方式，表不多先放在这里，很多的话考虑动态传进来add

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    erlang:send_after(0, self(), auto_reset),
    {ok, #state{}}.

handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).
handle_cast(Cmd,  State) ->
    ?DO_HANDLE_CAST(Cmd, State).
handle_info(Cmd, State) ->
    ?DO_HANDLE_INFO(Cmd, State).
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
do_handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
do_handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
do_handle_info(auto_reset, State) ->
    TomorrowSec = time_misc:get_seconds_to_tomorrow(),
    erlang:send_after(TomorrowSec*1000, self(), auto_reset),
    reset(),
    {noreply, State};
do_handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
reset() ->
    Now = time_misc:unixtime(),
    [reset2(Tab, Type, Now) || {Tab, Type} <- ?RESET_TABLE].

reset2(Table, Type, Now) ->
    case hdb:dirty_read(server_config, Table) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = Table,
                                                          v = Now}),
            hdb:clear_table(Table);
        #server_config{v = LastTime} ->
            case is_time_to_reset(LastTime, Type, Now) of
                true ->
                    hdb:clear_table(Table);
                _ ->
                    skip
            end
    end.

is_time_to_reset(LastTime, daily, Now) ->
    not time_misc:is_same_day(LastTime, Now);
is_time_to_reset(LastTime, weekly, Now) ->
    not time_misc:is_same_week(LastTime, Now);
is_time_to_reset(LastTime, monthly, Now) ->
    not time_misc:is_same_month(LastTime, Now);
is_time_to_reset(_, Type, _) ->
    ?WARNING_MSG("not support reset type ~p~n", [Type]),
    false.

%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created : 15 Jul 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_sys_acm).

-behaviour(gen_server).

-include("define_logger.hrl").
-include("define_player.hrl").
-include("define_try_catch.hrl").

%% API
-export([start_link/1]).
-export([new_msg/2,
         new_msg/3]).

-export([get_state/1]). %%for test

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-define(AUTO_SEND_TIME, 5000).   %%检查发送公告的时间

-record(state, {msg_list = [], sn = 1}).

%%%===================================================================
%%% API
%%%===================================================================
%%为了区分红包公告
new_msg(Msg, Sn) ->
    new_msg(Msg, Sn, 0).
new_msg(Msg, Sn, Type) ->
    NewMsg = 
        if
            is_list(Msg) ->
                unicode:characters_to_binary(Msg);
            true ->
                Msg
        end,    
    gen_server:cast(server_name_sn(Sn), {new_msg, NewMsg, Type}).
get_state(Sn) ->
    gen_server:call(server_name_sn(Sn), get_state).
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Sn) ->
    gen_server:start_link({local, server_name(Sn)}, ?MODULE, [Sn], []).

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
init([Sn]) ->
    {ok, #state{sn = Sn}}.

handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).

handle_cast(Cmd, State) ->
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
do_handle_call(get_state, _, State) ->
    {reply, State, State};
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
do_handle_cast({new_msg, Msg, Type}, #state{msg_list = List} = State) ->
    {noreply, State#state{msg_list = [{Msg, time_misc:unixtime(), Type}|List]}, 200};
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
do_handle_info(timeout, State) ->
    NewState = try_send_acm(State),
    {noreply, NewState};
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
    ?WARNING_MSG("mod_sys_acm terminate Reason ~p~n", [_Reason]),
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
try_send_acm(#state{
                msg_list = MsgList,
                sn = Sn
               } = State) ->
    if
        MsgList =:= [] ->
            State;
        true ->
            {ok, Bin} = pt_11:write(11080, MsgList),
            SendFun = 
                fun(Pid) ->
                        mod_player:send_to_client(Pid, Bin)  
                end,
            player_sup:broadcast_all_player(SendFun, Sn),
            State#state{msg_list = []}
    end.

server_name(DbSn) ->
    server_misc:server_name(?MODULE, DbSn).

server_name_sn(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    server_name(DbSn).

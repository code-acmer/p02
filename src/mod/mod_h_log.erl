%%%-------------------------------------------------------------------
%%% @author Arno <>
%%% @copyright (C) 2013, Arno
%%% @doc
%%%
%%% @end
%%% Created : 24 Jan 2013 by Arno <>
%%%-------------------------------------------------------------------
-module(mod_h_log).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% log api
-export([
         log_login/1,
         log_twist_eggs/1,
         log_gold_diff/1,
         log_cost_diff/1,
         log_mail/1,
         log_goods_in_out/1,
         log_goods_operate/1
        ]).

-include("define_logger.hrl").

-define(SERVER, ?MODULE). 

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% Log API
log_login(LoginInfo) ->
     gen_server:cast(?SERVER, {cmd_log_login, LoginInfo}).

log_twist_eggs(TwistInfo) ->
    gen_server:cast(?SERVER, {log_twist_eggs, TwistInfo}).
log_cost_diff(Data) ->
    gen_server:cast(?SERVER, {log_cost_diff, Data}).

log_gold_diff(Data) ->
    gen_server:cast(?SERVER, {log_gold_diff, Data}).
    
log_mail(Data) ->
    gen_server:cast(?SERVER, {log_mail, Data}).

log_goods_operate(Data) -> 
    gen_server:cast(?SERVER, {log_goods_operate, Data}).

log_goods_in_out(Data) ->
    gen_server:cast(?SERVER, {log_goods_in_out, Data}).
%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast({cmd_log_login, LoginInfo}=Msg, State) ->
    ReplyState =
        with_try(fun() ->
                         lib_log:log_login(LoginInfo)
                 end, Msg, State),
    {noreply, ReplyState};

handle_cast({cmd_log_logout, LogoutInfo}, State) ->
    try
        lib_log:log_logout(LogoutInfo)
    catch
        _:R ->
            ?WARNING_MSG(
               "log_logout failed: ~p~n~p~n", [R, erlang:get_stacktrace()])
    end,
    {noreply, State};

handle_cast({cmd_log_level_up, LevelUpInfo}, State) ->
    try
        lib_log:log_level_up(LevelUpInfo)
    catch
        _:R ->
            ?WARNING_MSG(
               "log level up failed: ~p~n~p~n", [R, erlang:get_stacktrace()])
    end,
    {noreply, State};
%% mod_log_srv:log(log_login_progress, {AId, RId})
%% handle_cast({log_login_progress, {AccId, RId}}, State) ->
%%     %% 客户端加载进程日志
%%     try
%%         lib_log:log_login_progress(AccId, RId)
%%     catch _:R ->
%%             ?WARNING_MSG(
%%                "log_login_progress error Reason:~w, stack:~p~n",
%%                [R, erlang:get_stacktrace()])
%%     end,
%%     {noreply, State};
handle_cast({LogFunName, Data}=Msg, State) ->
    ReplyState =
        with_try(fun() ->
                         lib_log:LogFunName(Data)
                 end, Msg, State),
    {noreply, ReplyState};

%% handle_cast({cmd_log_twist_eggs, TwistInfo} = Msg, State) ->
%%     %%扭蛋相关日志
%%     ReplyState =
%%         with_try(fun() ->
%%                          lib_log:log_twist_eggs(TwistInfo)
%%                  end, Msg, State),
%%     {noreply, ReplyState};
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

with_try(Fun, Msg, State) ->
    try
        Fun()
    catch Error:Reason ->
            ?WARNING_MSG("\e[1;31mLog ~w, Error ~w, Reason: ~w, Stack: ~p~n\e[0;38m",
                         [Msg, Error, Reason, erlang:get_stacktrace()])
    end,
    State.

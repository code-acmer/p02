%%%-------------------------------------------------------------------
%%% @author Arno <>
%%% @copyright (C) 2015, Arno
%%% @doc
%%%%%
%% 用于管理Q币的发放数量与总量控制 
%% 每个服务器各自己有自己的进程
%%
%%% @end
%%% Created :  2 Jul 2015 by Arno <>
%%%-------------------------------------------------------------------
-module(mod_q_coin_srv).
-include("common.hrl").
-include("define_mnesia.hrl").
-include("define_try_catch.hrl").
-include("define_time.hrl").

-behaviour(gen_server).


-export([get_q_coin/2,
         add_q_coin/2,
         show_q_coin/1,
         count_all_player_q_coin/0
        ]).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(q_coin_srv_state, {q_coin = 0,
                           worker_id}).

%%%===================================================================
%%% API
%%%===================================================================
get_q_coin(Sn, NeedNum) ->
    gen_server:call(get_workd_pid(Sn), {req_get_q_coin, NeedNum}).
add_q_coin(Sn, Num) ->
    gen_server:cast(get_workd_pid(Sn), {cmd_add_q_coin, Num}).
show_q_coin(Sn) ->
    gen_server:call(get_workd_pid(Sn), req_show_q_coin).
reset_q_coin(Sn) ->
    gen_server:call(get_workd_pid(Sn), req_reset_q_coin).

%%
process_name(WorkerId) ->
    %% Pname = hmisc:create_process_name(?MODULE, [WorkerId]),
    ProcName = server_app:get_proc_name(?MODULE, WorkerId),
    {n, g, ProcName}.

%% 根据playerid进行哈希，稳定指定特别进程
get_workd_pid(Sn) ->
    case gproc:where(process_name(Sn)) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            []
    end.

get_main_pid() ->
    case gproc:where(process_name(0)) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            []
    end.
start_link(Sn) ->
    gen_server:start_link({via, gproc, process_name(Sn)}, ?MODULE, [Sn], []).

init([Sn]) ->
    case Sn of
        0 ->
            %% 调度进程            
            TomorrowSec = time_misc:get_seconds_to_tomorrow(),
            erlang:send_after(TomorrowSec*1000, self(), cmd_add_q_coin_timer),
            erlang:send_after(3000, self(), cmd_init_coin_timer),
            ok;
        _ ->
            ignored
    end,
    QCoin = case get_q_coin_num(Sn) of
                [] ->
                    0;
                #server_config{v = Value} ->
                    Value
            end,
    {ok, #q_coin_srv_state{worker_id = Sn,
                           q_coin = QCoin
                          }}.

handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).
handle_cast(Cmd, State) ->
    ?DO_HANDLE_CAST(Cmd, State).
handle_info(Cmd, State) ->
    ?DO_HANDLE_INFO(Cmd, State).

do_handle_call({req_get_q_coin, NeedNum}, _From, #q_coin_srv_state{worker_id = Sn,
                                                                   q_coin = QCoin} = State) ->
    {Reply, NewState} = if
                            NeedNum < QCoin ->
                                {NeedNum, State#q_coin_srv_state{q_coin = QCoin - NeedNum}};
                            NeedNum >= QCoin andalso QCoin > 0 ->
                                {NeedNum, State#q_coin_srv_state{q_coin = 0}};
                            true -> 
                                {0, State}
                        end,
    save_q_coin_num(Sn, NewState#q_coin_srv_state.q_coin),
    {reply, Reply, NewState};
do_handle_call(req_show_q_coin, _From, State) ->
    Reply = State#q_coin_srv_state.q_coin,
    {reply, Reply, State};
do_handle_call(req_reset_q_coin, _From, State) ->
    delete_q_coin_num(State#q_coin_srv_state.worker_id),
    {reply, ok, State#q_coin_srv_state{q_coin = 0}};
do_handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.
do_handle_cast({cmd_add_q_coin, Num}, #q_coin_srv_state{q_coin = OldQCoin} = State) ->
    ?WARNING_MSG("cmd_add_q_coin, addNum : ~p, oldNum:~p time:~p~n",[Num, OldQCoin, time_misc:timestamp_to_datetime(time_misc:unixtime())]),
    NewNum = abs(Num),
    NewState = State#q_coin_srv_state{q_coin = OldQCoin + NewNum
                                     },
    save_q_coin_num(NewState#q_coin_srv_state.worker_id, NewState#q_coin_srv_state.q_coin),
    {noreply, NewState};
do_handle_cast(cmd_reset_q_qcoin, State) ->
    {noreply, State};
do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(cmd_load_q_coin, State) ->
    NewQCoin = case get_q_coin_num(State#q_coin_srv_state.worker_id) of
                   [] ->
                       0;
                   #server_config{v = Value} ->
                       Value
               end,
    {noreply, State#q_coin_srv_state{q_coin = NewQCoin}};
do_handle_info(cmd_init_coin_timer, State) ->
    case get_q_coin_day() of
        [] ->
            %% INIT Q COIN NUM
            Num = get_q_coin_num_by_day(1),
            ServerCount = get_server_num(),
            lists:foreach(fun(I) ->
                                  reset_q_coin(I),
                                  add_q_coin(I, Num)
                          end, lists:seq(1, ServerCount)),
            save_q_coin_day(1);
        #server_config{v = Day}->
            %% DO Nothing
            Day
    end,
    {noreply, State};
do_handle_info(cmd_add_q_coin_timer, State) ->
    case get_q_coin_day() of
        #server_config{v = Day} ->
            NewDay = Day + 1,
            Num = get_q_coin_num_by_day(NewDay),
            ServerCount = get_server_num(),
            lists:foreach(fun(I) ->
                                  add_q_coin(I, Num)
                          end, lists:seq(1, ServerCount)),
            save_q_coin_day(NewDay);
        _ ->
            ignored
    end,
    erlang:send_after(?ONE_DAY_SECONDS*1000, self(), cmd_add_q_coin_timer),
    {noreply, State};
do_handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    save_q_coin_num(State#q_coin_srv_state.worker_id, State#q_coin_srv_state.q_coin),
    ok.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


get_q_coin_day() ->
    hdb:dirty_read(server_config, q_coin_day).

save_q_coin_day(Day) ->
    hdb:dirty_write(server_config, #server_config{k = q_coin_day, v = Day}).

get_q_coin_num(Sn) ->
    hdb:dirty_read(server_config, {q_coin_num, Sn}).
delete_q_coin_num(Sn) ->
    hdb:dirty_delete(server_config, {q_coin_num, Sn}).
save_q_coin_num(Sn, QCoin) ->
    hdb:dirty_write(server_config, #server_config{k = {q_coin_num, Sn},
                                                  v = QCoin
                                                 }).

%% 1	8000
%% 2	7000
%% 3	7000
%% 4	7000
%% 5	7000
%% 6	7000
%% 7	7000
%% 8	7000
get_q_coin_num_by_day(1) ->
    8000;
get_q_coin_num_by_day(N) when N > 1 andalso N < 9 ->
    7000;
get_q_coin_num_by_day(_) ->
    0.


get_server_num() ->
    DbSnList = server_misc:mnesia_sn_list(),
    [MaxSn|_] = lists:sort(fun(A, B) -> A > B end,DbSnList),
    MaxSn.


count_all_player_q_coin() ->
    hdb:dirty_foldl(fun(#player{accid = AccId, 
                                qq = QQ, 
                                q_coin = QCoin
                               }, Acc) -> 
                            case lists:keyfind(AccId, 1, Acc) of
                                false ->
                                    [{AccId, QQ, QCoin} | Acc];
                                {AccId, OldQQ, OldQCoin} when OldQQ =:= "" ->
                                    lists:keyreplace(AccId, 1, Acc, {AccId, QQ, OldQCoin + QCoin});
                                {AccId, OldQQ, OldQCoin} ->
                                    %% [{AccId, OldQQ, OldQCoin + QCoin} | Acc]
                                    lists:keyreplace(AccId, 1, Acc, {AccId, OldQQ, OldQCoin + QCoin})
                            end                                            
                    end, [], player).

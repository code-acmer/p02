%%%-------------------------------------------------------------------
%%% @author Arno <>
%%% @copyright (C) 2015, Arno
%%% @doc
%%% 属性计算与获取服务
%%% @end
%%% Created : 25 May 2015 by Arno <>
%%%-------------------------------------------------------------------
-module(mod_combat_attri).

-behaviour(gen_server).
-include("common.hrl").
-include("define_try_catch.hrl").
-include("define_server.hrl").
-include("define_combat.hrl").

-export([
         update_combat_attri/1,
         get_combat_attri/1
        ]).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {worker = 0}).

%%%===================================================================
%%% API
%%%===================================================================
%%
process_name(WorkerId) ->
    server_app:get_proc_name(?MODULE, WorkerId).
    
%% 根据playerid进行哈希，稳定指定特别进程
get_workd_pid(PlayerId) ->
    WorkerId = (PlayerId rem ?COMBAT_ATTRI_WORKER_NUM) + 1,
    case whereis(process_name(WorkerId)) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            []
    end.
get_main_pid() ->
    case whereis(process_name(0)) of
        Pid when is_pid(Pid) ->
            Pid; 
        _ ->
            []
    end.

update_combat_attri(PlayerId) ->
    case get_workd_pid(PlayerId) of
        Pid when is_pid(Pid) ->
            gen_server:cast(Pid, {cmd_update_combat_attri, PlayerId});
        [] ->
            ignored
    end.

get_combat_attri(PlayerId) ->
    case get_workd_pid(PlayerId) of
        Pid when is_pid(Pid) ->
            gen_server:call(Pid, {req_get_combat_attri, PlayerId});
        [] ->
            ignored
    end.


%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(WorkerId) ->
    ProcName = process_name(WorkerId),
    gen_server:start_link({local, ProcName}, ?MODULE, [WorkerId], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([WorkerId]) ->
    {ok, #state{worker = WorkerId}}.

handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).
handle_cast(Cmd, State) ->
    ?DO_HANDLE_CAST(Cmd, State).
handle_info(Cmd, State) ->
    ?DO_HANDLE_INFO(Cmd, State).

do_handle_call({req_get_combat_attri, PlayerId} , _From, State) ->
    Reply = case inner_get_combat_attri(PlayerId) of
                [] ->
                    case lib_combat_attri:count_combat_attri(PlayerId) of
                        #combat_attri{} = CombatAttri ->
                            inner_save_combat_attri(CombatAttri),
                            CombatAttri;
                        _->
                            {fail, 1}
                    end;
                CombatAttri ->
                    CombatAttri
            end,
    {reply, Reply, State};
do_handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

do_handle_cast({cmd_update_combat_attri, PlayerId}, State) ->
    case lib_combat_attri:count_combat_attri(PlayerId) of
        #combat_attri{player_id = PlayerId
                     } = CombatAttri ->
            hdb:dirty_write(combat_attri, CombatAttri);
        _ ->
            ignored
    end,
    {noreply, State};
do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Info, State) ->
    {noreply, State}.

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


inner_get_combat_attri(PlayerId) ->
    case hdb:dirty_read(combat_attri, PlayerId) of
        #combat_attri{
           equips = Equips,
           stunts = Stunts,
           fashions = Fashions,           
           base_attri = BaseAttri,
           final_attri = FinalAttri
          }= CombatAttri ->
            NewEquips = hdb:try_upgrade_record(Equips),
            NewStunts = hdb:try_upgrade_record(Stunts),
            NewFashions = hdb:try_upgrade_record(Fashions),
            NewBaseAttri = hdb:try_upgrade_record(BaseAttri),
            NewFinalAttri = hdb:try_upgrade_record(FinalAttri),
            CombatAttri#combat_attri{
              equips = NewEquips,
              stunts = NewStunts,
              fashions = NewFashions,
              base_attri = NewBaseAttri,
              final_attri = NewFinalAttri
             };
        Other ->
            Other
    end.
inner_save_combat_attri(CombatAttri) ->
    hdb:dirty_write(combat_attri, CombatAttri).

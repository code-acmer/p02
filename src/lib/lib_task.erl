-module(lib_task).
-export([task_event/2,
         login/1,
         auto_save/1,
         give_up/2,
         daily_reset/3,
         create_role_add_main/1,
         lvlup_may_add_task/2,
         take_reward/2,
         filter_end_task/1]).

-include("define_task.hrl").
-include("define_goods.hrl").
-include("define_dungeon.hrl").
-include("define_goods_type.hrl").
-include("define_logger.hrl").
-include("define_info_30.hrl").
-include("define_player.hrl").
-include("db_base_task.hrl").
-include("define_money_cost.hrl").
-include("pb_30_pb.hrl").
-include("define_log.hrl").

%%-----------------角色登陆请求任务数据-----------------
%%创建角色加一个主线
create_role_add_main(#player{id = Id, lv = Lv, career = Career}) ->
    Now = time_misc:unixtime(),
    ConfigTasks = get_cur_lv_task(Lv),
    lists:foreach(fun(Task) ->
                          %NewTask = init_may_finish(Task, base_task_to_task(Id, Task)),
                          NewTask = base_task_to_task(Id, Task),
                          hdb:dirty_write(task, NewTask#task{last_op = Now})
                  end, ConfigTasks),
    [add_task_link_first_task(Id, LinkId) || LinkId <- all_link_ids(Career)].

%%任务出生可能就完成了
%% init_may_finish(#base_task{
%%                    id = BaseId,
%%                    condition = []}, #task{task_id = BaseId} = Task) ->
%%     Task#task{state = ?TASK_DONE};
%% init_may_finish(_, Task) ->
%%     Task.
all_link_ids(_Career) ->
    ?ALL_LINK_TASK_BEGIN_ID.
    %%[skill_link(Career)|?ALL_LINK_TASK_BEGIN_ID].

%% skill_link(?YAGAMI) ->
%%     ?SKILL_LINK_YAGAMI;
%% skill_link(?MAI) ->
%%     ?SKILL_LINK_MAI.

add_task_link_first_task(PlayerId, Id) ->
    case data_base_task:get(Id) of
        [] ->
            skip;
        BaseTask ->
            Task = base_task_to_task(PlayerId, BaseTask),
            hdb:dirty_write(task, Task)
    end.

login(Player) ->
    hdb:dirty_index_read(task, Player#player.id, #task.player_id, true).

auto_save(TaskList) ->
    lists:map(fun
                  (#task{is_dirty = 1} = Task) ->
                      NewTask = Task#task{is_dirty = 0},
                      hdb:dirty_write(task, NewTask),
                      NewTask;
                  (Task) ->
                      Task
              end, TaskList).

daily_reset(ModPlayerState, TaskList, SendFlag) ->
    ConfigTasks = get_cur_lv_task(ModPlayerState?PLAYER_LV),
    {NewTaskList, UpdateInfo, DelList} = try_to_reset(TaskList, ModPlayerState?PLAYER_LV),
    Add = may_add_task(ModPlayerState?PLAYER_ID, ConfigTasks, NewTaskList),
    %%应对策划中途加的任务链(在define里面有一个ALL_LINK_TASK_BEGIN_ID，加上去,领奖处理一下)
    {NewLinkTasks, LinkUpdate, HandleLinkTaskList} = may_add_new_link_task(ModPlayerState, NewTaskList),
    ?DEBUG("LinkUpdate ~p~n", [LinkUpdate]),
    may_send_change(ModPlayerState, {NewLinkTasks ++ Add, LinkUpdate ++ UpdateInfo, DelList}, SendFlag),
    ?DEBUG("DelList ~p~n", [DelList]),
    db_delete_task(DelList),
    ModPlayerState#mod_player_state{task_list = Add ++ HandleLinkTaskList}.

may_add_new_link_task(#mod_player_state{player = #player{id = PlayerId,
                                                         career = Career}} = ModPlayerState, TaskList) ->
    lists:foldl(fun(BaseId, {AccTask, AccUpdate, AccTaskList}) ->
                        case data_base_task:get(BaseId) of
                            [] ->
                                {AccTask, AccUpdate, AccTaskList};
                            #base_task{subtype = SubType} = BaseTask  ->
                                case lists:keytake(SubType, #task.subtype, AccTaskList) of
                                    %%找不到的话应该是新的
                                    false ->
                                        Task = base_task_to_task(PlayerId, BaseTask),
                                        NewTask = 
                                            case is_task_done(BaseTask, ModPlayerState) of
                                                false ->
                                                    Task;
                                                _ ->
                                                    Task#task{state = ?TASK_DONE}
                                            end,
                                        NTask = dirty(NewTask),
                                        {[NTask|AccTask], AccUpdate, [NTask|AccTaskList]};
                                    {value, Task, Rest} -> %%找的到的也去处理一下是否有新的
                                        case may_update_link_task(Task) of
                                            skip ->
                                                {AccTask, AccUpdate, AccTaskList};
                                            NewTask ->
                                                {AccTask, [{Task, NewTask}|AccUpdate], [dirty(NewTask)|Rest]}
                                        end
                                end 
                        end
                end, {[], [], TaskList}, all_link_ids(Career)).

may_update_link_task(#task{state = ?TASK_RECEIVE_REWARD,
                           task_id = TaskId} = Task) ->
    case data_base_task:get(TaskId) of
        [] ->
            skip;
        #base_task{next = NextId} ->
            case data_base_task:get(NextId) of
                [] ->
                    skip;
                _ ->
                    ?PRINT("Task id ~p trans to ~p~n", [Task#task.task_id, NextId]),
                    Task#task{task_id = NextId, schedule = 0, state = ?TASK_NOT_DONE}
            end
    end;
may_update_link_task(_) ->
    skip.

may_add_task(PlayerId, ConfigTasks, TaskList) ->
    lists:foldl(fun(#base_task{id = BaseId} = BaseTask, AccAdd) ->
                        case lists:keyfind(BaseId, #task.task_id, TaskList) of
                            false ->
                                NewTask = dirty(base_task_to_task(PlayerId, BaseTask)),
                                %NTask = init_may_finish(BaseTask, NewTask),
                                NTask = NewTask,
                                [NTask#task{last_op = time_misc:unixtime()}|AccAdd];
                            _ ->
                                AccAdd
                        end
                end, [], ConfigTasks).

may_send_change(_, _, false) ->
    skip;
may_send_change(ModPlayerState, {Add, UpdateInfo, Del}, true) ->
    PbUpdateList = 
        lists:foldl(fun({OldTask, NewTask}, AccUpdate) ->
                            case record_misc:record_modified(pt_30:to_pb_task(OldTask), 
                                                       pt_30:to_pb_task(NewTask)) of
                                [] ->
                                    AccUpdate;
                                SendTask ->
                                    [SendTask#pbtask{id = NewTask#task.id}|AccUpdate]
                            end
                    end, [], UpdateInfo),
    PbUpdate = pt_30:to_pb_task(Add) ++ PbUpdateList,
    PbDel = 
        lists:map(fun(#task{id = Id}) ->
                          #pbtask{id = Id}
                  end, Del),
    if
        PbUpdate =:= [] andalso PbDel =:= [] ->
            skip;
        true ->
            {ok, Bin} = pt:pack(30004, #pbtasklist{update = PbUpdate,
                                                   delete = PbDel}),
            packet_misc:directly_send_packet(ModPlayerState?PLAYER_SEND_PID, 0, Bin)
    end.

get_next_id() ->
    lib_counter:update_counter(task_uid).

get_cur_lv_task(PlayerLv) ->
    case data_base_task:get_task_but_main() of
        [] ->
            [];
        IdList ->
            lists:foldl(fun(BaseId, AccTask) ->
                                case data_base_task:get(BaseId) of
                                    #base_task{level = [Min, Max]} = Task when PlayerLv =< Max andalso PlayerLv >= Min ->
                                        [Task|AccTask];
                                    #base_task{level = []} = Task ->
                                        [Task|AccTask];
                                    _ ->
                                        AccTask
                                end
                        end, [], IdList)
    end.
try_to_reset(TaskList, PlayerLv) ->
    lists:foldl(fun(#task{task_id = Id} = Task, {AccTasks, AccUpdate, AccDel}) ->    %%符合条件的去reset，不符合就删了
                        case data_base_task:get(Id) of
                            [] ->
                                {AccTasks, AccUpdate, [Task|AccDel]};
                            #base_task{type = ?TASK_TYPE_DAILY,
                                       level = [Min, Max]} when PlayerLv < Min orelse PlayerLv > Max ->   %%过了等级的日常就删了，反正没机会重置了
                                {AccTasks, AccUpdate, [Task|AccDel]};
                            #base_task{type = ?TASK_TYPE_DAILY}->
                                NewTask = dirty(reset_task(Task)),
                                {[NewTask|AccTasks], [{Task, NewTask}|AccUpdate], AccDel};
                            _ ->
                                {[Task|AccTasks], AccUpdate, AccDel}
                        end
                end, {[], [], []}, TaskList).

dirty(Task) ->
    Task#task{is_dirty = 1}.

reset_task(Task) ->
    Task#task{state = ?TASK_NOT_DONE, schedule = 0}.

check_task_in_time(#base_task{type = ?TASK_TYPE_DAILY}) ->
    true;
check_task_in_time(#base_task{
                      type = ?TASK_TYPE_ACTIVITY,
                      circle_type = CircleType,
                      time = TimeInfo}) ->
    lists:foldl(fun(Info, AccBool) ->
                        TaskTime = 
                            case CircleType of
                                ?CIRCLE_TYPE_NORMAL ->
                                    {Begin, Con} = Info,
                                    time_misc:cal_begin_end_new(Begin, Con);
                                ?CIRCLE_TYPE_DAY ->
                                    time_misc:cal_day_cycle_new(Info);
                                ?CIRCLE_TYPE_WEEK ->
                                    time_misc:cal_week_cycle_new(Info);
                                ?CIRCLE_TYPE_MONTH ->
                                    time_misc:cal_month_cycle_new(Info);
                                ?CIRCLE_TYPE_BEGIN_END ->
                                    {BeginTime, ConTime} = Info,
                                    time_misc:cal_begin_end_new(BeginTime, ConTime);
                                _ ->
                                    undefined
                            end,
                        case TaskTime of
                            undefined ->
                                AccBool;
                            {_Begin, _End} ->
                                true
                        end
                end, false, TimeInfo).

base_task_to_task(PlayerId, BaseTask) ->
    #base_task{
       id = Id,
       type = Type,
       subtype = SubType
      } = BaseTask,            
    #task{
       id = get_next_id(),
       player_id = PlayerId,
       task_id = Id,
       type = Type,
       subtype = SubType
      }.

%%这里是做任务的接口，触发任务事件(目前有5种)先cast一个事件到mod_player，之后跑到这里检查任务
task_event(#mod_player_state{player = Player,
                             task_list = TaskList} = ModPlayerState, TaskInfo) ->
    {NewTaskList, UpdateInfo} = get_to_check_all_tasks(Player#player.lv, TaskList, TaskInfo),
    NewModPlayerState = ModPlayerState#mod_player_state{task_list = NewTaskList},
    may_send_change(NewModPlayerState, {[], UpdateInfo, []}, true),
    NewModPlayerState.

%%返回要完成的任务和更新的任务
get_to_check_all_tasks(PlayerLv, TaskList, TaskInfo) ->
    lists:foldl(fun(Task, {AccTasks, UpdateInfo}) ->
                        case try_to_finish_task(PlayerLv, Task, TaskInfo) of
                            false ->
                                {[Task|AccTasks], UpdateInfo};
                            {_, NewTask} -> 
                                NTask = dirty(NewTask),
                                {[NTask|AccTasks], [{Task, NTask}|UpdateInfo]}
                        end
                end, {[], []}, TaskList).

try_to_finish_task(PlayerLv, Task, TaskInfo) ->
    Now = time_misc:unixtime(),
    case check_task_can_be_done(PlayerLv, Task, TaskInfo, Now) of
        false ->
            %?PRINT("cannot be done Task ~p, TaskInfo~p~n", [Task, TaskInfo]),
            false;
        {BaseTask, #task{schedule = Schedule} = NTask} ->
            case is_task_finish(Schedule, BaseTask#base_task.condition, TaskInfo) of
                {update, NewSchedule} ->
                    {update, NTask#task{schedule = NewSchedule,
                                        last_op = Now}};
                {true, NewSchedule} ->
                    NewTask = NTask#task{schedule = NewSchedule, state = ?TASK_DONE, last_op = Now},
                    {finish, NewTask};
                no_change ->
                    false 
            end
    end.
%%检查等级是否符合
%% check_task_can_be_done(_, #task{state = ?TASK_DONE}, _) ->
%%     false;
check_task_can_be_done(PlayerLv, #task{task_id = Id} = Task, TaskInfo, Now) ->
    case data_base_task:get(Id) of
        [] ->
            false;
        #base_task{level = ReqLv,
                   condition = Condition,
                   end_time = End} = BaseTask ->
            case check_end(End) of
                false ->
                    case check_player_lv(PlayerLv, ReqLv) of
                        true ->
                            case check_task_key(Condition, TaskInfo) of
                                true ->
                                    check_task_can_be_done2(BaseTask, Task, Now);
                                false ->
                                    false
                            end;
                        false ->
                            false
                    end;
                true ->
                    false
            end
    end.

%%检查是否过期了
check_end([]) ->
    false;
check_end([Time]) ->
    Now = hmisctime:unixtime(),
    Now > hmisctime:datetime_to_timestamp(Time).
%%活动任务要处理
check_task_can_be_done2(#base_task{time = Time,
                                   type = ?TASK_TYPE_ACTIVITY,
                                   circle_type = CircleType} = BaseTask, #task{state = State,
                                                                               last_op = LastOp} = Task, Now) ->
    if
        State =:= ?TASK_DONE ->
            false;
        State =:= ?TASK_NOT_DONE->
            {BaseTask, Task};
        State =:= ?TASK_RECEIVE_REWARD -> %%领完奖了看能不能重置
            case check_begin_end_time(CircleType, Time, LastOp, Now) of
                true ->
                    {BaseTask, reset_task(Task)};
                false ->
                    false
            end
    end;

check_task_can_be_done2(BaseTask, #task{state = ?TASK_NOT_DONE} = Task, _) ->
    {BaseTask, Task};
check_task_can_be_done2(_BaseTask, _Task, _) ->
    false.

check_begin_end_time(CircleType, TimeInfo, LastOp, Now) ->
    lists:foldl(fun(Info, AccBool) ->
                        TaskTime = 
                            case CircleType of
                                ?CIRCLE_TYPE_NORMAL ->
                                    {BeginTime, ConTime} = Info,
                                    hmisctime:cal_begin_end_new(BeginTime, ConTime);
                                ?CIRCLE_TYPE_DAY ->
                                    hmisctime:cal_day_cycle_new(Info);
                                ?CIRCLE_TYPE_WEEK ->
                                    hmisctime:cal_week_cycle_new(Info);
                                ?CIRCLE_TYPE_MONTH ->
                                    hmisctime:cal_month_cycle_new(Info);
                                ?CIRCLE_TYPE_BEGIN_END ->
                                    {BeginTime, ConTime} = Info,
                                    hmisctime:cal_begin_end_new(BeginTime, ConTime);
                                _ ->
                                    undefined
                            end,
                        case TaskTime of
                            undefined ->
                                AccBool;
                            {Begin, End} ->
                                if
                                    Begin < Now andalso Now < End andalso 
                                    not(Begin < LastOp andalso LastOp < End) ->
                                        true;
                                    true ->
                                        AccBool
                                end
                        end
                end, false, TimeInfo).

%%检查事件是否和任务一致
check_task_key({?TASK_DUNGEON, 0, _, _, _}, {?TASK_DUNGEON, _DungeonId, _, _, _}) ->
    true;
check_task_key({?TASK_DUNGEON, DungeonId, _, _, _}, {?TASK_DUNGEON, DungeonId, _, _, _}) ->
    true;
check_task_key({?TASK_MONSTER, 0, _}, {?TASK_MONSTER, _MonstersId, _}) ->
    true;
check_task_key({?TASK_MONSTER, MonstersId, _}, {?TASK_MONSTER, MonstersId, _}) ->
    true;
check_task_key({?TASK_FUNTION, FuntionId, _}, {?TASK_FUNTION, FuntionId, _}) ->
    true;
check_task_key({?TASK_LV, _}, {?TASK_LV, _}) ->
    true;
check_task_key({?TASK_GOODS, GoodsId, _}, {?TASK_GOODS, GoodsId, _}) ->
    true;
check_task_key({?TASK_DUNGEON_AREA, AreaId, Difficulty, _}, {?TASK_DUNGEON_AREA, AreaId, Difficulty, _}) ->
    true;
check_task_key({?TASK_MUGEN, _}, {?TASK_MUGEN, _}) ->
    true;
check_task_key({?TASK_FRIEND, _}, {?TASK_FRIEND, _}) ->
    true;
check_task_key({?TASK_ARENA, Type, _}, {?TASK_ARENA, Type, _}) ->
    true;
check_task_key({?TASK_SUPER_BATTLE, _}, {?TASK_SUPER_BATTLE, _}) ->
    true;
check_task_key({?TASK_TEAM_DUNGEON, ?TEAM_TYPE_TEAM, _}, {?TASK_TEAM_DUNGEON, ?TEAM_TYPE_TEAM, _}) ->
    true;  
check_task_key(_, _) ->
    false.

%% check_req_time([]) ->
%%     true;
%% check_req_time({Begin, End}) ->
%%     Now = hmisctime:unixtime(),
%%     Begin =< Now andalso Now =< End.
%%任务Level变成了是否能领，所以不用检查能不能做
check_player_lv(_, _) ->
    true.

%检查任务是否完成(目前进度，需要条件，事件)
is_task_finish(Schedule, {?TASK_DUNGEON, _, OTimes, OPassTime, OScore}, {?TASK_DUNGEON, _, Times, PassTime, Score}) ->
    if
        PassTime >= OPassTime andalso Score >= OScore ->
            NewSchedule = Schedule + Times,
            if
                NewSchedule >= OTimes ->
                    {true, NewSchedule};
                true ->
                    {update, NewSchedule}
            end;
        true ->
            no_change
    end;
is_task_finish(Schedule, {Type, _, Sum}, {Type, _, Count})
  when Type =:= ?TASK_MONSTER orelse Type =:= ?TASK_FUNTION orelse Type =:= ?TASK_GOODS ->
    NewSchedule = Schedule + Count,
    if
        NewSchedule >= Sum -> 
            {true, NewSchedule};
        true ->
            {update, NewSchedule}
    end;
is_task_finish(_, {?TASK_LV, ReqLv}, {?TASK_LV, Lv}) ->
    if
        Lv >= ReqLv ->
            {true, Lv};
        true ->
            no_change
    end;
is_task_finish(Schedule, {?TASK_DUNGEON_AREA, _, _, NeedTimes}, {?TASK_DUNGEON_AREA, _, _, Count}) ->
    NewSchedule = Schedule + Count,
    if
        NewSchedule >= NeedTimes ->
            {true, NewSchedule};
        true ->
            {update, NewSchedule}
    end;
is_task_finish(_, {?TASK_MUGEN, Level}, {?TASK_MUGEN, NowLevel}) ->
    if
        NowLevel >= Level ->
            {true, NowLevel};
        true ->
            no_change
    end;
is_task_finish(_, {?TASK_FRIEND, NeedNum}, {?TASK_FRIEND, Count}) ->
    if
        Count >= NeedNum ->
            {true, Count};
        true ->
            {update, Count}
    end;
is_task_finish(Schedule, {?TASK_ARENA, _, NeedNum}, {?TASK_ARENA, _, Count}) ->
    NewSchedule = Schedule + Count,
    if
        NewSchedule >= NeedNum ->
            {true, NewSchedule};
        true ->
            {update, NewSchedule}
    end;
is_task_finish(_, {?TASK_SUPER_BATTLE, Level}, {?TASK_SUPER_BATTLE, NowLevel}) ->
    if
        NowLevel >= Level ->
            {true, NowLevel};
        true ->
            {update, NowLevel}
    end;
is_task_finish(Schedule, {?TASK_TEAM_DUNGEON, TeamType, NeedNum}, {?TASK_TEAM_DUNGEON, TeamType, Count}) ->
    NewSchedule = Schedule + Count,    
    if 
        TeamType =:= ?TEAM_TYPE_TEAM andalso NewSchedule >= NeedNum  ->
            {true, Count};
        true ->
           no_change
    end;           

is_task_finish(_, _, _) ->
    no_change.

update_task(Task, Tasks) 
  when is_record(Task, task)->
    lists:keystore(Task#task.id, #task.id, Tasks, Task#task{is_dirty = 1});
update_task(TaskList, Tasks) 
  when is_list(TaskList)->
    lists:foldl(fun(Task, AccTasks) ->
                        update_task(Task, AccTasks)
                end, Tasks, TaskList).

db_delete_task(Task) when is_record(Task, task) ->
    hdb:dirty_delete(task, Task#task.id);
db_delete_task(TaskList) when is_list(TaskList) ->
    lists:foreach(fun(Task) ->
                          db_delete_task(Task)
                  end, TaskList).

delete_task(DelTask, Tasks) 
  when is_record(DelTask, task)->
    hdb:dirty_delete(task, DelTask#task.id),
    lists:keydelete(DelTask#task.id, #task.id, Tasks);
delete_task(DelTaskList, Tasks) 
  when is_list(DelTaskList)->
    lists:foldl(fun(Task, AccTasks) ->
                        delete_task(Task, AccTasks)
                end, Tasks, DelTaskList).


%% send(_, [], []) ->
%%     skip;
%% send(ModPlayerState, Update, Del) ->
%%     {ok, BinData} = pt_30:write(30000, {Update, Del}),
%%     mod_player:send(ModPlayerState, BinData).

%%放弃任务要慎重，不要把不该放弃的放弃了
give_up(TaskId, TaskList) ->
    case lists:keyfind(TaskId, #task.id, TaskList) of
        false ->
            {fail, ?INFO_TASK_UNKNOWN_TASK};
        #task{task_id = BaseId} = Task ->
            case data_base_task:get(BaseId) of
                [] ->
                    {fail, ?INFO_TASK_UNKNOWN_TASK};
                #base_task{give_up = ?TASK_CAN_GIVE_UP} ->
                    NewTaskList = delete_task(Task, TaskList),
                    {Task, NewTaskList};
                _ ->
                    {fail, ?INFO_TASK_CAN_NOT_GIVE_UP}
            end
    end.

lvlup_may_add_task(#mod_player_state{task_list = TaskList,
                                     player = Player} = ModPlayerState, _OldLv) ->
    NewLv = Player#player.lv,
    Add =
        lists:foldl(fun(Id, AccAdd) ->
                            case data_base_task:get(Id) of
                                #base_task{level = [Min, Max]} = BaseTask 
                                when NewLv =< Max andalso NewLv >= Min ->
                                    case lists:keyfind(Id, #task.task_id, TaskList) of  %%防止乱搞
                                        false ->
                                            NewTask = base_task_to_task(Player#player.id, BaseTask),
                                                %NTask = init_may_finish(BaseTask, NewTask),
                                            NTask = NewTask,
                                            [NTask#task{last_op = time_misc:unixtime()}|AccAdd];
                                        _ ->
                                            AccAdd
                                    end;
                                _ ->
                                    AccAdd
                            end
                    end, [], data_base_task:get_task_but_main()),
    ?DEBUG("Add ~p~n", [Add]),
    {ok, Bin} = pt:pack(30004, #pbtasklist{update = pt_30:to_pb_task(Add)}),
    packet_misc:put_packet(Bin),
    ModPlayerState#mod_player_state{task_list = update_task(Add, TaskList)}.

%%客户端主动检测部分任务达成，然后跟服务器说这个任务做完了
take_reward(#mod_player_state{task_list = TaskList} = ModPlayerState, TaskId) ->
    case lists:keytake(TaskId, #task.id, TaskList) of
        false ->
            {fail, ?INFO_CONF_ERR};
        {value, #task{id = TaskId,
                      task_id = BaseId,
                      state = TaskState} = Task, RestTaskList} ->
            case data_base_task:get(BaseId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_task{condition = Condition} = BaseTask ->
                    case Condition of
                        {?TASK_BATTLE, _, _} ->
                            take_reward2(Task, RestTaskList, BaseTask, ModPlayerState);
                        _ ->
                            if
                                TaskState =:= ?TASK_DONE ->
                                    take_reward2(Task, RestTaskList, BaseTask, ModPlayerState);
                                true ->
                                    case is_task_done(BaseTask, ModPlayerState) of
                                        true ->
                                            take_reward2(Task, RestTaskList, BaseTask, ModPlayerState);
                                        false ->
                                            {fail, ?ERROR_TASK_CONTENT_NOT_DONE}
                                    end
                            end
                    end
            end
    end.

take_reward2(Task, RestTaskList, #base_task{reward = Reward,
                                            liveness_reward = LiveNess,
                                            next = Next} = BaseTask, ModPlayerState) ->
    %?QPRINT(BaseTask),
    case lib_reward:take_reward(ModPlayerState, Reward, ?INCOME_TASK_REWARD) of
        {ok, NewModPlayerState} ->
            NewLv = NewModPlayerState?PLAYER_LV,
            NewPlayer = add_live_ness(NewModPlayerState?PLAYER, LiveNess),
            %% 记录日常任务完成日志
            case BaseTask#base_task.type of
                ?TASK_TYPE_DAILY ->
                    lib_log_player:log_system({ModPlayerState?PLAYER_ID, ?LOG_DAILTY_TASK, BaseTask#base_task.id, 0, 0});
                _ ->
                    ignored
            end,
            case may_over_level(BaseTask, NewLv) of
                false ->
                    NTask = 
                        case may_add_next_task(Task, Next, NewModPlayerState) of
                            skip ->
                                Task#task{state = ?TASK_RECEIVE_REWARD,
                                          last_op = time_misc:unixtime()};
                            NewTask ->
                                NewTask
                        end,
                    may_send_change(NewModPlayerState, {[], [{Task, NTask}], []}, true),
                    NewTaskList = [dirty(NTask)|RestTaskList],
                    {ok, NewModPlayerState#mod_player_state{task_list = NewTaskList,
                                                            player = NewPlayer}};
                true ->
                    hdb:dirty_delete(task, Task#task.id),
                    may_send_change(NewModPlayerState, {[], [], [Task]}, true),
                    {ok, NewModPlayerState#mod_player_state{task_list = RestTaskList,
                                                            player = NewPlayer}}
            end;
        Other ->
            Other
    end.

add_live_ness(#player{live_ness = Old} = Player, Sum) when is_integer(Sum) ->
    Player#player{live_ness = Old + Sum}.

may_over_level(#base_task{type = ?TASK_TYPE_DAILY,
                          level = Level}, Lv) ->
    case Level of
        [] ->
            false;
        [_Min, Max] ->
            Lv > Max
    end;
may_over_level(_, _Lv) ->
    false.
%%中途加入的任务链要在这里处理
may_add_next_task(_, 0, _) ->
    skip;
may_add_next_task(#task{type = ?TASK_TYPE_MAIN} = Task, Next, _) ->
    case data_base_task:get(Next) of
        [] ->
            skip;
        _ ->
            Task#task{task_id = Next, schedule = 0, state = ?TASK_NOT_DONE}
    end;
may_add_next_task(#task{type = ?TASK_TYPE_ACHIEVE} = Task, Next, ModPlayerState) ->
    case data_base_task:get(Next) of
        [] ->
            skip;
        NextBase ->
            case is_task_done(NextBase, ModPlayerState) of
                false ->
                    Task#task{task_id = NextBase#base_task.id, schedule = 0, state = ?TASK_NOT_DONE};
                true ->
                    Task#task{task_id = NextBase#base_task.id, schedule = 0, state = ?TASK_DONE}
            end
    end;
may_add_next_task(Task, Next, _) ->
    ?WARNING_MSG("config may error Task ~p NextId~ p~n", [Task, Next]),
    skip.

%%过滤过期的活动,再发给客户端
filter_end_task(TaskList) ->
    lists:filter(fun(#task{task_id = BaseId}) ->
                         case data_base_task:get(BaseId) of
                             [] ->
                                 false;
                             #base_task{end_time = End} ->
                                 case check_end(End) of
                                     false ->
                                         true;
                                     true ->
                                         false
                                 end
                         end
                 end, TaskList).

is_task_done(#base_task{condition = {?TASK_LV, ReqLv}}, ModPlayerState) ->
    PlayerLv = ModPlayerState?PLAYER_LV,
    if
        ReqLv =< PlayerLv ->
            true;
        true ->
            false
    end;
is_task_done(#base_task{condition = {?TASK_HAS_GOODS, BaseId, Sum, ?TASK_HAS_GOODS_TYPE_NORMAL, _}}, #mod_player_state{bag = GoodsList}) ->
    GoodsSum = lib_goods:get_goods_count(GoodsList, BaseId),
    if
        GoodsSum >= Sum ->
            true;
        true ->
            false
    end;
is_task_done(#base_task{condition = {?TASK_HAS_GOODS, BaseId, Sum, ?TASK_HAS_GOODS_TYPE_STR, StrLv}}, #mod_player_state{bag = GoodsList}) ->
    GoodsSum = 
        lists:foldl(fun
                        (#goods{
                            base_id = OBaseId,
                            str_lv = OStr,
                            sum = OSum}, AccCount) when OStr >= StrLv andalso (BaseId =:= 0 orelse OBaseId =:= BaseId) ->
                            AccCount + OSum;
                        (_, AccCount) ->
                            AccCount
                    end, 0, GoodsList),
    if
        GoodsSum >= Sum ->
            true;
        true ->
            false
    end;
is_task_done(#base_task{condition = {?TASK_HAS_GOODS, BaseId, Sum, ?TASK_HAS_GOODS_TYPE_STAR, StarLv}}, #mod_player_state{bag = GoodsList}) ->
    GoodsSum = 
        lists:foldl(fun
                        (#goods{
                            base_id = OBaseId,
                            star_lv = OStar,
                            sum = OSum}, AccCount) when OStar >= StarLv andalso (BaseId =:= 0 orelse OBaseId =:= BaseId) ->
                            AccCount + OSum;
                        (_, AccCount) ->
                            AccCount
                    end, 0, GoodsList),
    if
        GoodsSum >= Sum ->
            true;
        true ->
            false
    end;
is_task_done(#base_task{condition = {?TASK_MUGEN, Level}}, #mod_player_state{dungeon_mugen = #dungeon_mugen{max_pass_rec = Max}}) ->
    if
        Max >= Level ->
            true;
        true ->
            false
    end;
is_task_done(#base_task{condition = {?TASK_SUPER_BATTLE, Level}}, #mod_player_state{super_battle = #super_battle{have_pass_times = Max}}) ->
    if
        Max >= Level ->
            true;
        true ->
            false
    end;
%%不给配通关分数和时间，因为不知道用这个分数通了几关
is_task_done(#base_task{condition = {?TASK_DUNGEON, DungeonId, OTimes, _, _}}, #mod_player_state{dungeon_list = DungeonList}) ->
    case lists:keyfind(DungeonId, #dungeon.base_id, DungeonList) of
        #dungeon{done = Times} ->
            if
                Times >= OTimes ->
                    true;
                true ->
                    false
            end;
        false ->
            false
    end;
is_task_done(#base_task{condition = {?TASK_TEAM_DUNGEON, Typeteam, Number}}, #mod_player_state{dungeon_list = DungeonList, dungeon_info = DungeonInfo}) ->
    TypeTeamNow = DungeonInfo#dungeon_info.team_type,
    case lists:keyfind(Number, #dungeon.done, DungeonList) of 
       #dungeon{done = Done} -> 
            if
                Done >= Number andalso TypeTeamNow =:= Typeteam ->
                    true;
                true ->
                    false                                 
            end;
        false ->
            false
    end;    

is_task_done(#base_task{condition = {?TASK_FRIEND, Need}}, #mod_player_state{player = Player}) ->
    FriendNum = Player#player.friends_cnt,
    if
        FriendNum >= Need ->
            true;
        true ->
            false
    end;
is_task_done(#base_task{condition = {?TASK_SKILL, SkillId, ?TASK_SKILL_TYPE_STR, Lv}}, #mod_player_state{skill_list = SkillList}) ->
    case find_skill(SkillId, SkillList) of
        #player_skill{str_lv = OStr} when OStr >= Lv ->
            true;
        _ ->
            false
    end;
is_task_done(#base_task{condition = {?TASK_SKILL, SkillId, ?TASK_SKILL_TYPE_LUP, Lv}}, #mod_player_state{skill_list = SkillList}) ->
    case find_skill(SkillId, SkillList) of
        #player_skill{lv = OLv} when OLv >= Lv ->
            true;
        _ ->
            false
    end;
%%战斗技巧类领奖直接跳过条件判定
is_task_done(#base_task{condition = {?TASK_BATTLE, _, _}}, _) ->
    false;
is_task_done(#base_task{condition = Condition}, _) ->
    ?DEBUG("task achieve error condition ~p~n", [Condition]),
    false.

find_skill(_, []) ->
    [];
find_skill(SkillId, [H|Tail]) ->
    if
        H#player_skill.skill_id =:= SkillId ->
            H;
        true ->
            case lists:member(SkillId, H#player_skill.sigil) of                
                true ->
                    H;
                false ->
                    find_skill(SkillId, Tail)
            end
    end.

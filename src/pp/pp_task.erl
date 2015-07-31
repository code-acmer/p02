%%%------------------------------------
%%% @Module     : pp_task
%%% @Created    : 2010.10.06
%%% @Description: 任务模块
%%%------------------------------------
-module(pp_task).
-export([handle/3]).

-include("define_logger.hrl").
-include("pb_30_pb.hrl").
-include("define_task.hrl").
-include("define_goods_type.hrl").
-include("define_player.hrl").
-include("define_info_30.hrl").
-include("pb_13_pb.hrl").

%%查看任务
handle(30000, #mod_player_state{task_list = TaskList} = ModPlayerState, _) ->
    NewTaskList = lib_task:filter_end_task(TaskList),
    {ok, BinData} = pt_30:write(30000, {NewTaskList, []}),
    packet_misc:put_packet(BinData),
    ok;
handle(30001, #mod_player_state{task_list = TaskList} = ModPlayerState, #pbid32{id = Id}) ->
    case lib_task:give_up(Id, TaskList) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {DelTask, NewTaskList} ->
            {ok, BinData} = pt_30:write(30000, {[], [DelTask]}),
            packet_misc:put_packet(BinData),
            {ok, ModPlayerState#mod_player_state{task_list = NewTaskList}}
    end;
handle(30005, ModPlayerState, #pbid32{id = Id}) ->
    case lib_task:take_reward(ModPlayerState, Id) of
        {fail ,Reason} ->
            packet_misc:put_info(Reason);
        Other ->
            Other
    end;
handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.


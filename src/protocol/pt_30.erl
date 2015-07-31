-module(pt_30).
-export([write/2,
        to_pb_task/1]).

-include("define_logger.hrl").
-include("define_task.hrl").
-include("pb_30_pb.hrl").

write(30000, {Update, Del}) ->
    PbUPdateList = to_pb_task(Update),
    PbDel = to_pb_task(Del),
    pt:pack(30000, #pbtasklist{update = PbUPdateList,
                               delete = PbDel});
write(Cmd, _R) ->
    ?WARNING_MSG("pt write error Cmd ~p Reason ~p~n", [Cmd, _R]),
    pt:pack(0, <<>>).

to_pb_task(Task) 
  when is_record(Task, task) ->
    #task{
       id = Id,
       task_id = TaskId,
       player_id = PlayerId,
       type = Type,
       schedule = Schedule,
       state = State,
       last_op = LastOp} = Task,
    #pbtask{
       id = Id,
       task_id = TaskId,
       player_id = PlayerId,
       type = Type,
       schedule = Schedule,
       state = State,
       last_op = LastOp
      };
to_pb_task(TaskList) 
  when is_list(TaskList) ->
    lists:map(fun(Task) ->
                      to_pb_task(Task)
              end, TaskList).

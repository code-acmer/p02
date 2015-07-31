-module(ai_main).
-include("define_logger.hrl").
-export([start/2,
         add/2,
         add_list/2,
         start_robot/1]).

start(Group, Num) ->
    application:start(ibrowse),
    application:start(hstdlib),
    ssl:start(),
    hloglevel:set(3),
    [robot_group:start_link(GroupId, Num) || GroupId <- lists:seq(1, Group)],
    put(group_count, Group),
    %spawn(fun()-> etop:start([{output, text}, {interval, 3}, {lines, 20}, {sort, memory}]) end),
    ok.

add(Group, Num) ->
    case get(group_count) of
        undefined ->
            io:format("please start first ~n", []),
            skip;
        Count ->
            put(group_count, Group + Count),
            [robot_group:start_link(GroupId, Num) || GroupId <- lists:seq(Count + 1, Group + Count)]
    end.

add_list(Group, Num) ->
    lists:foreach(fun(_) ->
                          timer:sleep(3000),
                          add(20, Num)
                  end, lists:seq(1, Group div 20)),
    io:format("run over ~n", []).

start_robot(GroupId) ->
    robot_group:start_link(GroupId, 1).

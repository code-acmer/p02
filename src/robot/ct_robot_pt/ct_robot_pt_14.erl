-module(ct_robot_pt_14).

-export([send/2, recv/3]).
-include("define_robot.hrl").

send(Cmd, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.

%% recv(14000, Robot, #pbfriendlist{update_list = UpdateList,
%%                                  delete_list = DelList}) ->
%%     NewFriendList =
%%         lists:foldl(fun(#pbfriend{id = Id} = PbFriend, AccFriendList) ->
%%                             lists:keystore(Id, #pbfriend.id, AccFriendList, PbFriend)
%%                     end, Robot#ct_robot.friendslist, UpdateList),
%%     NFriendList = 
%%         lists:foldl(fun(#pbfriend{id = Id}, AccFriendList) ->
%%                             lists:keydelete(Id, #pbfriend.id, AccFriendList)
%%                     end, NewFriendList, DelList),
%%     {ok, Robot#ct_robot{friendslist = NFriendList}};

recv(14000, Robot, PbFriendList) ->
    {ok, Robot#ct_robot{pbfriendlist = PbFriendList}};
recv(Cmd, _, _) ->
    {recv_fail, {recv_cmd_not_match, Cmd}}.

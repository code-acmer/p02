-module(robot_pt_send_11).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).

pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(11010) ->
    #pbchat{msg = "abc"};
pack_rec(11012) ->
    #pbid32{id = 1};
pack_rec(11015) ->
    <<>>;
pack_rec(11020) ->
    #pbchat{msg = "abc"};
pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.




pack_rec_args(11010, [Msg]) ->
    #pbchat{msg = Msg};
pack_rec_args(11013, [RecvId, Msg]) ->   %%私聊
    #pbchat{recv_id = RecvId, msg = Msg};
pack_rec_args(11015,[FriendId]) ->
    #pbchat{recv_id = FriendId};

pack_rec_args(11016,[Title, Content])->
    #pbfeedbackmsg{title = Title, content = Content};
pack_rec_args(11021, [Id]) ->
    #pbid32{id = Id};
pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.

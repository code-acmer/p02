-module(robot_pt_send_19).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).
pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(19001) ->
    #pbmail{
        recv_name = "hello",
        title = "title",
        content = "content"
    };

pack_rec(19003) ->
    #pbid32{id = 21};
pack_rec(19004) ->    
    <<>>;

pack_rec(19005) ->
    #pbmail{
        recv_id = 100087157,
        recv_name = "hello",
        content = "content"
    };
pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.

pack_rec_args(19002, [Id]) ->
    #pbmail{id=Id, type=1};
pack_rec_args(19003, [Id]) ->
    #pbid32{id=Id};
pack_rec_args(19005, [Id]) ->
    #pbmail{recv_id = Id,
            content = "hello",
            goodslist = [#pbmailgoods{goodsid = 3,
                                      goodsum = 100}, 
                         #pbmailgoods{goodsid = 1,
                                      goodsum = 100}]
           };
pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.

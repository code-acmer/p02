%%%-----------------------------------
%%% @Module  : pt_12
%%% @Created : 2013.11.07
%%% @Description: 12 关卡信息
%%%-----------------------------------
-module(pt_34).
-export([write/2]).

%%
%%客户端 -> 服务端 ----------------------------
%%
-include_lib("define_logger.hrl").
-include_lib("pb_34_pb.hrl").
-include("define_goods.hrl").

write(34001, {Activities, Count}) ->
    PbActivity = to_pb_activity(Activities),
    pt:pack(34001, #pbactivitylist{activity    = PbActivity,
                                   mails_count = Count});

write(34002, GoodsList) ->
    PbTwistEgg = to_pb_twist_egg(GoodsList),
    pt:pack(34002, #pbtwistegglist{twist_egg = PbTwistEgg});

write(Cmd, _R) ->
    ?WARNING_MSG("pt write error Cmd ~p, Reason ~p~n", [Cmd, _R]),
    pt:pack(0, <<>>).

to_pb_activity(Activities) ->
	lists:map(
		fun({Id, Desc, Category, StartTime, EndTime, ServerNow, 
             Type, Notice, NoticeStartTime, NoticeEndTime, Interval}) -> 
			#pbactivity{id = Id, 
                        activity_desc     = Desc,
                        start_time        = StartTime,
                        category          = Category,
                        end_time          = EndTime,
                        server_now        = ServerNow,
                        type              = Type,
                        notice            = Notice,
                        notice_start_time = NoticeStartTime,
                        notice_end_time   = NoticeEndTime,
                        interval          = Interval

                        }
		end, Activities).

to_pb_twist_egg(GoodsList) ->
    lists:map(
        fun({Goods, AddAttFlag}) -> 
            #pbtwistegg{goods_id = Goods#goods.id,
                        add_att_flag = AddAttFlag} 
        end, GoodsList).
	   

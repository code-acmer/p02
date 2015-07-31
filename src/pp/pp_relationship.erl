%%%--------------------------------------
%%% @Module  : pp_relationship
%%% @Created : 2010.10.05
%%% @Description:  管理玩家间的关系 
%%%--------------------------------------
-module(pp_relationship).
 %% -export([handle/3]).

 %% -include("define_logger.hrl").
 %% -include("pb_14_pb.hrl").
 %% -include("define_info_14.hrl").
 %% -include("define_relationship.hrl").
 %% -include("define_player.hrl").

%% %% %% @doc 请求我的所有好友
%% handle(14000, Status, _) ->
%%     %% 确保有数据
%%     L1 = hdb:dirty_index_read(relationship, Status#player.id, 1),
%%     ?DEBUG_RELA("friend info: ~w~n", [L1]),
%%     {ok, BinData} = pt_14:write(14000, {L1, []}),
%%     {binary, BinData};

%% %% %% @doc 发送好友请求
%% %% %% Type:加好友的类型(1:常规加好友,2:黑名单里加好友,3:仇人里加好友)
%% %% %% _Uid:用户ID
%% handle(14001, Status, #pbfriend{id = Id}) ->
%%     case Status#player.id of
%%         Id ->
%%             {info, ?INFO_FRIEND_CAN_NOT_ADD_MYSELF};
%%         SID ->
%%             %% 
%%             lib_relationship:request_friend(SID, ID)
%%     end;
		
%% %% %% @doc 回应好友请求
%% %% %% Type:加好友的类型(1:常规加好友,2:黑名单里加好友,3:仇人里加好友)
%% %% %% Res:拒绝或接受请求(0表示拒绝/1表示接受)
%% %% %% Uid:用户ID
%% handle(14002, Status, [_Type, Res, Uid]) ->
%%      case res of
%%          0 ->
%%              Data1 = [2, Res, Status#player.id,Status#player.lv, Status#player.sex,
%%                      Status#player.career, Status#player.nickname],
%%             {ok, BinData} = pt_14:write(14002, Data1),
%%             lib_send:send_to_uid(Uid, BinData);
%%         1 ->
%%             {_,IsExit} = lib_relationship:check_rela_is_exists(Status#player.id, Uid, 1),
%%             case IsExit of
%%                 false ->
%% 					His_Friend_Full = lib_relationship:friend_num_remote(Uid),
%% 					%% 此处会返回对方好友是否已满，true满,false不满
%% 					L_len_rsp = lib_relationship:get_idA_list(Status#player.id, 1),
%% 					%% VIP额外添加好友上限
%% 					{ok,Award} = lib_vip:get_friend_count_award(Status#player.vip), 
%% 					NewMaxFriends = Award + ?MAX_FRIENDS,
%% 					if 
%% 						His_Friend_Full ->
%% 							{ok, BinDataReq} = pt_14:write(14002, [2, 5]),
%%             				lib_send:send_to_uid(Uid, BinDataReq),
%% 							{ok, BinDataRsp} = pt_14:write(14002, [1, 5]),
%% 							lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinDataRsp),
%% 							ok;
%% 						erlang:length(L_len_rsp) >= NewMaxFriends ->
%% 							{ok, BinDataReq} = pt_14:write(14002, [2, 4]),
%%             				lib_send:send_to_uid(Uid, BinDataReq),
%% 							{ok, BinDataRsp} = pt_14:write(14002, [1, 4]),
%% 							lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinDataRsp),
%% 							ok;
%% 						true ->
%% 							%%通知成就系统
%% 							try begin
%% 									L_len_rsp = lib_relationship:get_idA_list(Status#player.id, 1),
%% 									FriendNum = length(L_len_rsp),
%% 									lib_achieve:add_achieve(Status#player.other#player_other.pid, Status#player.id, add_friend, FriendNum, 1)
%% 								end
%% 							of _ -> ok
%% 							catch _:R -> ?ERROR_MSG("R=~p, Stack=~p~n", [R, erlang:get_stacktrace()])
%% 							end,
%% 							?DEBUG("sfs!!!!!!!!!!!!!!!!", []), 
%%                     		lib_relationship:add(Status#player.id, Uid, 1),
%% %%						handle(14000, Status, []),
%% %%                    		 	case lib_relationship:is_exists(Status#player.id, Uid, 2) of
%% %%                         		{RecordId2, true} ->
%% %% %% ?DEBUG("14002_~p/~p ~n",[Status#player.id, xxxx3]),
%% %%                             		lib_relationship:delete(RecordId2),
%% %%                             		handle(14007, Status, []);
%% %%                         		{ok, false} -> ok
%% %%                     		end,
%%                    		 	case lib_relationship:get_ets_rela_record(Status#player.id, Uid, 2) of 
%%                         		[]->
%% 									?DEBUG("not in black", []),
%% 									ok;
%% 								Record->
%% %% ?DEBUG("14002_~p/~p ~n",[Status#player.id, xxxx2]),
%% 									?DEBUG("in black", []),
%%                             		lib_relationship:delete(Record#ets_rela.id),
%%                             		handle(14007, Status, [])
%%                     		end,
%%                     		handle(14000, Status, []),
%%                     		Data = [Res, Status#player.id,Status#player.lv, Status#player.sex, 
%% 							 		Status#player.career, Status#player.nickname],
%% 							Data1 = [1|Data],
%%                     		{ok, BinData1} = pt_14:write(14002, Data1),
%% 							lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData1),
%% 							Data2 = [2|Data],
%%                     		{ok, BinData2} = pt_14:write(14002, Data2),
%% 							Id = lib_relationship:get_id(Status#player.id, Uid, 1),
%% 							response_friend_request(BinData2, Uid, Status#player.id, Id), %%回应好友请求后， 要求请求方做相关处理
%% 							ok
%% 					end;
%%                 _ -> ok
%%             end
%%     end;

%% %% @DOC 删除好友关系
%% %% Rec_id 要删除的记录号pp_relationship:handle(14003, Status1, 388).
%% handle(14003, Status, #pbfriend{rid = Rec_id}) ->
%%     ?DEBUG_RELA("14003_record_id: ~w/ ~n", [Rec_id]),
%%     case hdb:dirty_read(relationship, Rec_id) of
%%         {ok, false} ->
%%             %% 目标不是你的好友，无法取消
%%             {info, ?INFO_FRIEND_NOT_FRIEND};
%%         {Id, true} ->
%%             %% 取消关注的操作
%%             hdb:dirty_delete(relationship, Id),
%%             {ok, BinData} = pt_14:write(14000, {[], Id}),
%%             {info, BinData}
%%     end;

%% %% @doc 请求好友详细信息
%% handle(14056, Status, #pbid64{id = ID}) ->
%%     case lib_relationship:get_ets_rela_record(
%%            Status#player.id, ID, ?RELATIONSHIP_FRIENDS) of
%%         [] ->
%%             %% 不在好友列表中，无法发送
%%             {info, ?INFO_FRIEND_NOT_FRIEND};
%%         Real ->
%%             Now = hmisctime:unixtime(),
%%             Info = #pbfriend{
%%                       rid = Real#relationship.id,
%%                       id = Real#relationship.tid
%%                      },
%%             {ok, BinData} = pt_14:write(14000, {[Info], []}),
%%             {binary, BinData}
%%     end;
	
%% %% 不匹配的协议
%% handle(_Cmd, _, _Data) ->
%%     ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
%%     {error, "pp_handle no match"}.


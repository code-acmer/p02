%%%-----------------------------------
%%% @Module  : pt_10
%%% @Created : 2011.10.05
%%% @Description: 10帐户信息
%%%-----------------------------------
-module(pt_10).
-export([write/2]).

-include("define_logger.hrl").
-include("pb_10_pb.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%% %%用户登陆
%% read(10000, <<Sn:16, Accid:64, Tstamp:32, Bin/binary>>) ->
%%     {Accname, Bin1} = pt:read_string(Bin),
%%     {Ticket, _} = pt:read_string(Bin1),
%%     {ok, login, #pt_10000_client{
%%                    server_id = Sn,
%%                    acc_id = Accid,
%%                    time_stamp = Tstamp,
%%                    acc_name = Accname,
%%                    login_ticket = Ticket}};

%% %%退出
%% read(10001, _) ->
%%     {ok, logout};

%% %%获取角色列表
%% read(10002, _R) ->
%%     {ok, lists, []};

%% %%创建角色
%% read(10003, <<Sn:16, Realm:8, Career:8, Sex:8, Bin/binary>>) ->
%%     {Name, _} = pt:read_string(Bin),
%%     {ok, create, #pt_10003_client{
%%                     server_id = Sn,
%%                     realm = Realm,
%%                     career = Career,
%%                     sex = Sex,
%%                     nickname = Name
%%                    }};

%% %%选择角色进入游戏
%% read(10004, <<Sn:16, Id:64>>) ->
%%     {ok, enter, {Sn, Id}};

%% %%删除角色
%% read(10005, <<Id:64>>) ->
%%     {ok, delete, Id};

%% %%心跳包
%% read(9006, _) ->
%%     {ok, heartbeat};

%% %%建立多socket
%% read(10008,<<Sn:16, Accid:64, N:8>>) ->
%% 	{ok,mult_socket,[Sn, Accid, N]};

%% %%按照accid创建一个角色，或自动分配一个角色(accid=0)
%% read(10010, <<Sn:16, Accid:64>>) ->
%%     {ok, new_role, {Sn, Accid}};

%% %%进入角色创建页面
%% read(10020, _) ->
%%     {ok, getin_createpage};

%% %%进入角色创建页面，点击页面事件
%% read(10021, _) ->
%% 	{ok, click_create_page_event};

%% %%创建角色后进入游戏的方式
%% read(10022, <<Type:8>>) ->
%% 	{ok, enter_game_type, Type};

%% %%子socket心跳包
%% read(1000, _) ->
%%     {ok, heartbeat};

%% %%子socekt断开通知
%% read(10031,<<N:8>>) ->
%% 	{ok,[N]};

%% read(_Cmd, _R) ->
%%     {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%登陆返回
write(10000, [Code, RoleList, TGameTime]) ->
	{N, LB} = case RoleList of
                  [] ->
                      {0, <<>>};			
                  _ ->	
                      F = fun([PlayerId, Status, Name, Sex, Lv, 
                               Realm, Career, Sn]) ->
                                  NameBin = pt:write_string(Name),
                                  <<PlayerId:64, 
                                    Status:8, 
                                    Realm:8,
                                    Career:8, 
                                    Sex:8, 
                                    Lv:8, 
                                    Sn:16,
                                    NameBin/binary>>
                          end,
                      {length(RoleList), hmisc:to_binary([F(X) || X <- RoleList])}
         end,
    Data = <<Code:16, TGameTime:32, N:16, LB/binary>>,
    pt:pack(10000, Data);


%%登陆退出
write(10001, _) ->
    Data = <<>>,
    pt:pack(10001, Data);

%% 打包角色列表
write(10002, []) ->
    N = 0,
    LB = <<>>,
    pt:pack(10002, <<N:16, LB/binary>>);
write(10002, L) ->
    N = length(L),
    F = fun([PlayerId, Status, Name, Sex, Lv, Realm, Career, Sn]) ->
			NameBin = pt:write_string(Name),
            <<PlayerId:64, 
			  Status:8, 
			  Realm:8,
			  Career:8, 
			  Sex:8, 
			  Lv:8, 
			  Sn:16,
			  NameBin/binary>>
    end,
    LB = hmisc:to_binary([F(X) || X <- L]),
    pt:pack(10002, <<N:16, LB/binary>>);

%%创建角色
write(10003, {Code, RoleId}) ->
    Data = <<Code:16, RoleId:64>>,
    pt:pack(10003, Data);

%%选择角色进入游戏
write(10004, Code) ->
    Data = <<Code:16>>,
    pt:pack(10004, Data);

%%删除角色
write(10005, Code) ->
    Data = <<Code:16>>,
    pt:pack(10005, Data);

%%心跳包
write(9006, _) ->
    pt:pack(9006, null);

%% 被下线通知
write(10007, null) ->
    pt:pack(10007, null);
write(10007, Code) ->
    pt:pack(10007, #pbuserresult{result = Code});

%%子socket建立状态
write(10008, {Code, N}) ->
	Data = <<Code:16, N:8>>,
	pt:pack(10008, Data);

%%登陆过程监测
write(10009, [N])->
    %% T1 = util:longunixtime(),
    %% Dt = case get(myTime) of
    %% 		    undefined -> 0;
    %% 		    Val -> Val
    %%      end,
    %% io:format("10009__/~p/  ~p/ ~n",[N, T1-Dt]),	
    %% put(myTime, T1),			
	Data = <<N:16>>,
	pt:pack(10009,Data); 

%% 返回：按照accid创建一个角色，或自动分配一个角色(accid=0)
write(10010, {NewAccid, RoleId, Accname}) ->
	%% AccnameBin = pt:write_string(Accname),
    %% Data = <<NewAccid:64,
	%% 		 RoleId:64,
	%% 		 AccnameBin/binary>>,	
    PBData = #pbuserlogininfo{
                user_id = RoleId,
                acc_id = NewAccid,
                acc_name = Accname
               },
    pt:pack(10010, PBData);

write(10100, Pub) ->
    ProtoMsg = #pbrc4{pub = Pub
                     },
    pt:pack(10100, ProtoMsg);
%%子socket心跳包
write(10030, _) ->
    Data = <<>>,
    pt:pack(10030, Data);

write(Cmd, _R) ->
    ?WARNING_MSG("pt write error Cmd ~p, Reason ~p~n", [Cmd, _R]),
    pt:pack(0, <<>>).


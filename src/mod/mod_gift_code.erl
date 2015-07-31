%%%-------------------------------------------------------------------
%%% @author Zhangr <>
%%% @copyright (C) 2013, Zhangr
%%% @doc
%%%
%%% @end
%%% Created : 15 Jul 2013 by Zhangr <>
%%%-------------------------------------------------------------------
-module(mod_gift_code).

%% -behaviour(gen_server).

%% %% API
%% -export([start_link/0]).

%% %% gen_server callbacks
%% -export([init/1, handle_call/3, handle_cast/2, handle_info/2,
%%          terminate/2, code_change/3]).

%% -export([role_init/1,
%%          role_login/1,
%%          role_logout/1,
%%          check_gift_accepted/2,
%%          update_gift_acceted/3,
%%          check_gift_code/4,
%%          check_accepted/2,
%%          update_accepted/2]).

%% -define(SERVER, ?MODULE). 

%% -include("define_logger.hrl").
%% -include("define_info_15.hrl").
%% -include("define_reward.hrl").
%% -include("define_gift.hrl").

%% -record(state, {}).

%% %%%===================================================================
%% %%% API
%% %%%===================================================================

%% %% @doc 初始化副本信息
%% role_init(PlayerId) ->
%%     case hetsutil:lookup_one(?ETS_PLAYER_GIFT, PlayerId) of
%%         [] ->
%%             case db_game:insert(player_gift, 
%%                                 config:get_one_server_no(),
%%                                 [id],
%%                                 [PlayerId]) of
%%                 1 ->
%%                     %% 插入成功后才返回指定值
%%                     Info = #ets_player_gift{id = PlayerId},
%%                     ets_util:insert(?ETS_PLAYER_GIFT, Info),
%%                     {ok, Info};
%%                 _ ->
%%                     %% 插入失败了
%%                     {fail, ?INFO_GOODS_GIFT_FAILED}
%%             end;
%%         Info ->
%%             %% 返回指定值
%%             {ok, Info}
%%     end.

%% %% @doc 登录处理
%% role_login(PlayerId) ->
%%     case db_game:select_row(player_gift, "*", [{id, PlayerId}], [], [1]) of
%%         [] ->
%%             %% 没数据了
%%             pass;
%%         DataList ->
%%             Info = list_to_tuple([ets_player_gift | DataList]),
%%             hetsutil:insert(?ETS_PLAYER_GIFT, Info)
%%     end.

%% %% @doc 退出处理
%% role_logout(PlayerId) ->
%%     ets_util:delete(?ETS_PLAYER_GIFT, PlayerId).

%% %% @doc 检测礼包是否可领取
%% check_gift_accepted(_PlayerId, undefined) ->
%%     true;
%% check_gift_accepted(PlayerId, GiftId) ->
%%     gen_server:call(?SERVER,
%%                     {check_gift_accepted, PlayerId, GiftId}).
%% update_gift_acceted(PlayerId, GiftId, AcCode) ->
%%     gen_server:call(?SERVER,
%%                     {update_gift_acceted, PlayerId, GiftId, AcCode}).

%% check_gift_code(Channel, AccName, GiftType, CheckFlag) ->
%%     gen_server:call(?SERVER, 
%%                     {check_gift_code, Channel, AccName, GiftType, CheckFlag}).

%% %% @doc 查询指定id的礼包是否可领取
%% check_accepted(GiftId, Info) ->
%%     if
%%         GiftId < 64 -> 
%%             Info#ets_player_gift.gift1 band (1 bsl GiftId) > 0;
%%         GiftId < 128 ->
%%             Info#ets_player_gift.gift2 band (1 bsl (GiftId - 64)) > 0;
%%         GiftId < 192 ->
%%             Info#ets_player_gift.gift3 band (1 bsl (GiftId - 128)) > 0;
%%         GiftId < 256 ->
%%             Info#ets_player_gift.gift4 band (1 bsl (GiftId - 192)) > 0;
%%         GiftId < 320 ->
%%             Info#ets_player_gift.gift5 band (1 bsl (GiftId - 256)) > 0;
%%         true -> 
%%             %% default, accepted
%%             true
%%     end.

%% %% @doc 更新指定id的礼包为已领取状态
%% update_accepted(GiftId, Info) ->
%%     NewInfo = 
%%         if
%%             GiftId < 64 ->
%%                 NewGift = Info#ets_player_gift.gift1 bor (1 bsl GiftId),
%%                 Info#ets_player_gift{gift1 = NewGift};
%%             GiftId < 128 ->
%%                 NewGift = Info#ets_player_gift.gift2 bor (1 bsl (GiftId - 64)),
%%                 Info#ets_player_gift{gift2 = NewGift};
%%             GiftId < 192 ->
%%                 NewGift = Info#ets_player_gift.gift3 bor (1 bsl (GiftId - 128)),
%%                 Info#ets_player_gift{gift3 = NewGift};
%%             GiftId < 256 ->
%%                 NewGift = Info#ets_player_gift.gift4 bor (1 bsl (GiftId - 192)),
%%                 Info#ets_player_gift{gift4 = NewGift};
%%             GiftId < 320 ->
%%                 NewGift = Info#ets_player_gift.gift5 bor (1 bsl (GiftId - 256)),
%%                 Info#ets_player_gift{gift5 = NewGift};
%%             true -> 
%%                 %% default to not modified
%%                 Info
%%         end,
%%     ets_util:insert(?ETS_PLAYER_GIFT, NewInfo),
%%     db_game:update(player_gift, 
%%                    [{gift1, NewInfo#ets_player_gift.gift1},
%%                     {gift2, NewInfo#ets_player_gift.gift2},
%%                     {gift3, NewInfo#ets_player_gift.gift3},
%%                     {gift4, NewInfo#ets_player_gift.gift4},
%%                     {gift5, NewInfo#ets_player_gift.gift5}],
%%                    [{id, NewInfo#ets_player_gift.id}]),
%%     NewInfo.


%% %%--------------------------------------------------------------------
%% %% @doc
%% %% Starts the server
%% %%
%% %% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% %% @end
%% %%--------------------------------------------------------------------
%% start_link() ->
%%     gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% %%%===================================================================
%% %%% gen_server callbacks
%% %%%===================================================================

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Initializes the server
%% %%
%% %% @spec init(Args) -> {ok, State} |
%% %%                     {ok, State, Timeout} |
%% %%                     ignore |
%% %%                     {stop, Reason}
%% %% @end
%% %%--------------------------------------------------------------------
%% init([]) ->
%%     {ok, #state{}}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Handling call messages
%% %%
%% %% @spec handle_call(Request, From, State) ->
%% %%                                   {reply, Reply, State} |
%% %%                                   {reply, Reply, State, Timeout} |
%% %%                                   {noreply, State} |
%% %%                                   {noreply, State, Timeout} |
%% %%                                   {stop, Reason, Reply, State} |
%% %%                                   {stop, Reason, State}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_call({check_gift_accepted, PlayerId, GiftId}, _From, State) ->
%%     Reply = 
%%         try
%%             case ets_util:lookup_one(?ETS_PLAYER_GIFT, PlayerId) of
%%                 [] ->
%%                     %% 数据未获取到，返回已经领取过了
%%                     true;
%%                 Info ->
%%                     check_accepted(GiftId, Info)
%%             end
%%         catch
%%             _:Res ->
%%                 ?ERROR_MSG("check gift accepted failed: ~p~n~p~n.",
%%                            [Res, erlang:get_stacktrace()]),
%%                 true
%%         end,
%%     {reply, Reply, State};
%% handle_call({update_gift_acceted, PlayerId, GiftId, AcCode}, _From, State) ->
%%     Reply =
%%         try
%%             case ets_util:lookup_one(?ETS_PLAYER_GIFT, PlayerId) of
%%                 [] ->
%%                     fail;
%%                 Info ->
%%                     update_accepted(GiftId, Info),
%%                     if
%%                         GiftId =:= ?NEW_PLAYER_GIFT_ID ->
%%                             lib_activation_code:delete_activation_code(AcCode);
%%                         true ->
%%                             ignore
%%                     end,
%%                     ok
%%             end
%%         catch
%%             _:Res ->
%%                 ?ERROR_MSG("update gift accepted failed: ~p~n~p~n",
%%                            [Res, erlang:get_stacktrace()]),
%%                 fail
%%         end,
%%     {reply, Reply, State};
%% %% handle_call({check_gift_code, _Channel, _AccName, _GiftType, CheckFlag}, _From, State) ->
%% %%     Reply =
%% %%         try
%% %%             %% 验证码正确，那么返回真，否则返回假
%% %%             %% util:md5(misc:to_list(Channel) ++ 
%% %%             %%              misc:to_list(AccName) ++ 
%% %%             %%              misc:to_list(GiftType)) =:= CheckFlag
%% %%             {IsAllNum, Length}=
%% %%                 lists:foldl(fun(Char, {Res, Len}) ->
%% %%                                     if 
%% %%                                         Char >= $0 andalso 
%% %%                                         Char =< $9 andalso 
%% %%                                         Res ->
%% %%                                             {true, Len+1};
%% %%                                         true ->
%% %%                                             {false, Len+1}
%% %%                                     end
%% %%                             end, {true, 0}, CheckFlag),
%% %%             if 
%% %%                 Length =:= 10 andalso IsAllNum ->
%% %%                     true;
%% %%                 true ->
%% %%                     false
%% %%             end
%% %%         catch
%% %%             _:Res ->
%% %%                 %% 都报错了，那么一定验证不通过
%% %%                 ?ERROR_MSG("check flag failed: ~p~n~p~n.", [Res, erlang:get_stacktrace()]),
%% %%                 false
%% %%         end,
%% %%     {reply, Reply, State};
%% handle_call({check_gift_code, _Channel, _AccName, _GiftType, CheckFlag}, _From, State)->
%%     Reply = try
%%                 %% AcCode = list_to_binary(CheckFlag),
%%                 lib_activation_code:is_legal_activation_code(CheckFlag)
%%             catch _:Res ->
%%                     ?ERROR_MSG("check gift code failed: ~p~n~p~n", [Res, erlang:get_stacktrace()]),
%%                     false
%%             end,
%%     {reply, Reply, State};
%% handle_call(_Request, _From, State) ->
%%     Reply = ok,
%%     {reply, Reply, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Handling cast messages
%% %%
%% %% @spec handle_cast(Msg, State) -> {noreply, State} |
%% %%                                  {noreply, State, Timeout} |
%% %%                                  {stop, Reason, State}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_cast(_Msg, State) ->
%%     {noreply, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Handling all non call/cast messages
%% %%
%% %% @spec handle_info(Info, State) -> {noreply, State} |
%% %%                                   {noreply, State, Timeout} |
%% %%                                   {stop, Reason, State}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_info(_Info, State) ->
%%     {noreply, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% This function is called by a gen_server when it is about to
%% %% terminate. It should be the opposite of Module:init/1 and do any
%% %% necessary cleaning up. When it returns, the gen_server terminates
%% %% with Reason. The return value is ignored.
%% %%
%% %% @spec terminate(Reason, State) -> void()
%% %% @end
%% %%--------------------------------------------------------------------
%% terminate(_Reason, _State) ->
%%     ok.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Convert process state when code is changed
%% %%
%% %% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% %% @end
%% %%--------------------------------------------------------------------
%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.

%% %%%===================================================================
%% %%% Internal functions
%% %%%===================================================================



%% %%%-------------------------------------------------------------------
%% %%% @author human <humanzhigang@gzleshu.com>
%% %%% @copyright (C) 2014, human
%% %%% @doc
%% %%%
%% %%% @end
%% %%% Created :  6 Nov 2014 by human <humanzhigang@gzleshu.com>
%% %%%-------------------------------------------------------------------
 -module(mod_activity_shop).

-behaviour(gen_server).

%% API
-export([start_link/0,
         reload_base_shop/0,
         buy_shop/3
        ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 
-include("common.hrl").
-include("db_base_shop.hrl").
-include("db_base_shop_activity.hrl").
-include("define_goods.hrl").
-include("define_time.hrl").
-include("define_mnesia.hrl").
-include("define_info_15.hrl").
-include("define_try_catch.hrl").

-record(state, {
          shop_msg_list = [], %% 商品信息
          activity_id = [], %% 活动 id
          is_dirty = 0,   %% 活动是否更新
          timer_ref = []  %% 定时器的引用
         }).

%%%===================================================================
%%% API
%%%===================================================================
buy_shop(ActivityId, ShopId, Num)->
    gen_server:call(?MODULE, {buy_shop, ActivityId, ShopId, Num}).

reload_base_shop()->
    gen_server:cast(?MODULE, reload_base_shop).



%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    erlang:send_after(5, self(), init_state),
    {ok, #state{}, 1000}.

handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).
handle_cast(Cmd,  State) ->
    ?DO_HANDLE_CAST(Cmd, State).
handle_info(Cmd, State) ->
    ?DO_HANDLE_INFO(Cmd, State).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
do_handle_call({buy_shop, PlayerActivityId, ShopId, Num}, _From, #state{
                                                               shop_msg_list = ShopMsgList,
                                                               activity_id = ActivityId
                                                              } = State) ->
    if
        PlayerActivityId =/= ActivityId ->
            {reply, {fail, ?INFO_ACTIVITY_SHOP_OVERDUE}, State};
        true ->
            case lists:keytake(ShopId, #activity_shop_msg.base_id, ShopMsgList) of
                false ->
                    {reply, {fail, ?INFO_SHOP_NO_FIND}, State};
                {value, #activity_shop_msg{
                           buy_num = BuyNum,
                           num_limit = NumLimit
                          } = ActivityShopMsg, Rest} when BuyNum + Num =< NumLimit->
                    {reply, ok, State#state{
                                  shop_msg_list = [dirty_activity_shop_msg(ActivityShopMsg#activity_shop_msg{
                                                                             buy_num = BuyNum + Num
                                                                            }) | Rest]
                                 }, 1000};
                _ ->
                    {reply, {fail, ?INFO_SHOP_NUM_LIMIT}, State}
            end
    end;
do_handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------

do_handle_cast(reload_base_shop, #state{
                                 timer_ref = TimerRef
                                }=State) ->
    ?DEBUG("TimerRef ~p", [TimerRef]),
    lists:map(fun(T)->
                      erlang:cancel_timer(T)
              end, TimerRef),
    reloader_misc:reload_all(),
    erlang:send_after(5, self(), init_state),
    {noreply, State#state{
                timer_ref = []
               }, 1000};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------

do_handle_info(init_state, State) ->
    ShopMsgList = read_table(activity_shop_msg),
    ?DEBUG("init_state ShopMsgList : ~p", [ShopMsgList]),
    erlang:send_after(5, self(), get_next_activity),
    {noreply, State#state{
                shop_msg_list = ShopMsgList
               }};

do_handle_info(get_next_activity, #state{
                                  timer_ref = TimerRef
                                } = State) ->
    %?WARNING_MSG("get_next_activity"),
    Now = time_misc:unixtime(),
    case get_activity(Now) of
        {now, ActivityId, EndStemp} ->  %% 这里不能清除数据库中的数据
            T = erlang:send_after((EndStemp - Now + 1)*1000, self(), end_of_activity), %% 活动最后一秒
            NewState = get_activity_shop(State#state{
                                           activity_id = ActivityId,
                                           timer_ref = [T | TimerRef]
                                          }),
            {noreply,dirty_state(NewState), 1000};
        {next, NextOpenStemp} ->
            ?WARNING_MSG("next activity at open: ~p",[time_misc:timestamp_to_datetime(NextOpenStemp)]),
            T = erlang:send_after((NextOpenStemp-Now)*1000, self(), get_next_activity),
            clean_db_activity_shop(),
            {noreply, State#state{
                        shop_msg_list = [],
                        activity_id = [],
                        timer_ref = [T | TimerRef]
                       }, 1000};
        [] ->
            %?WARNING_MSG("All Activity End!"),
            clean_db_activity_shop(),
            {noreply, State#state{
                        shop_msg_list = [],
                        activity_id = []
                       }, 1000}
    end;

do_handle_info(end_of_activity, State) ->
    ?DEBUG(" end_of_activity ..."),
    clean_db_activity_shop(),
    erlang:send_after(100, self(), get_next_activity),
    {noreply, State#state{
                shop_msg_list = [],
                activity_id = []
               }, 1000};

do_handle_info(timeout, #state{
                          shop_msg_list = ShopMsgList
                         }=State) ->
    ?DEBUG("timeout: ~p", [ShopMsgList]),
    if
        State#state.is_dirty =:= 1 ->
            hdb:clear_table(activity_shop_msg);
        true ->
            skip
    end,
    NewShopMsgList = save_to_db(ShopMsgList),
    {noreply, State#state{
                is_dirty = 0,
                shop_msg_list = NewShopMsgList
               }};

do_handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(Reason, #state{
                      shop_msg_list = ShopMsgList
                     }) ->
    ?WARNING_MSG("terminate Reason: ~p",[Reason]),
    save_to_db(ShopMsgList),
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 获取当前活动信息,若当前没有则获取最近的下一个活动信息
get_activity(Now)->
    AllActivityId = data_base_shop_activity:get_all_id(),
    get_activity1(AllActivityId, Now).

get_activity1([], _Now) ->
    [];
get_activity1([Id | List], Now)->
    case data_base_shop_activity:get(Id) of
        [] ->
            [];
        #base_shop_activity{
           start_time = StartTime,
           last_time = LastTime
          } ->
            case time_misc:cal_begin_end_stamp(StartTime, LastTime) of
                undefined ->
                    ?WARNING_MSG("ErrorTime : start_time : ~p, last_time : ~p", [StartTime, LastTime]),
                    get_activity1(List, Now);
                {OpenStemp, EndStemp} ->
                    if 
                        OpenStemp =< Now andalso Now =< EndStemp ->
                            {now, Id, EndStemp};
                        Now =< OpenStemp ->
                            {next, OpenStemp};
                        true ->
                            get_activity1(List, Now)
                    end
            end
    end.

%% 获取活动（抢购）商城各个商品信息
get_activity_shop(#state{
                     activity_id = ActivityId
                    } = State) ->
    OldShopList = get_activity_shop_by_db(),
    clean_db_activity_shop(),
    case data_base_shop_activity:get(ActivityId) of
        [] ->
            ?WARNING_MSG(" activity id error : ~p", [ActivityId]),
           State#state{
             shop_msg_list = []
            };
        #base_shop_activity{
           shop_ids = List %%找出所有的商品ID
          } ->
            {NewShopList, _} = 
                lists:foldl(fun(ShopId, {AccList, ShopList}) ->
                                    case data_base_shop:get(ShopId) of 
                                        [] ->
                                            ?WARNING_MSG("not find base_shop ...ShopId : ~p", [ShopId]),
                                            {AccList, ShopList};
                                        BaseShop ->
                                            {ActivityShopMsg, NShopList} = check_activity_shop(BaseShop, ShopList, ActivityId),
                                            {[dirty_activity_shop_msg(ActivityShopMsg) | AccList], NShopList}
                                    end
                            end,
                            {[], OldShopList}, List),
            State#state{
             shop_msg_list = NewShopList
            }
    end.
check_activity_shop(#base_shop{
                       id = BaseId,
                       goods_id = GoodsId,
                       total = Total
                      }, ShopList, ActivityId) ->
    case lists:keytake(BaseId, #activity_shop_msg.base_id, ShopList) of
        {value, #activity_shop_msg{
                   goods_id = GoodsId,
                   activity_id = ActivityId
                  }=ActivityShopMsg , Rest}  ->  %% base_id 和 goods_id 相同则继承
            {dirty_activity_shop_msg(ActivityShopMsg), Rest};
        _ -> %% 原来的列表中没有或者goods_id不一致 则重构 
            {dirty_activity_shop_msg(#activity_shop_msg{
                                        base_id = BaseId,
                                        goods_id = GoodsId,
                                        num_limit = Total,
                                        activity_id = ActivityId
                                       }), ShopList}
    end.

get_activity_shop_by_db()->
    hdb:read_table(activity_shop_msg).
    
clean_db_activity_shop() ->
    hdb:clear_table(activity_shop_msg).

save_to_db(ShopMsgList)->
    ?DEBUG("activity shop save_to_db"),
    lists:map(fun(ActivityShopMsg) 
                    when is_record(ActivityShopMsg, activity_shop_msg) ->
                      hdb:save(ActivityShopMsg, #activity_shop_msg.is_dirty);
                 (_) ->
                      ?WARNING_MSG("save to db ActivityShopMsg error")
              end, ShopMsgList).

dirty_activity_shop_msg(ActivityShopMsg) 
  when is_record(ActivityShopMsg, activity_shop_msg) ->
    ActivityShopMsg#activity_shop_msg{
      is_dirty = 1
     }.

dirty_state(State) 
  when is_record(State, state) ->
    State#state{
      is_dirty = 1
     }.

read_table(Table) ->
    case hdb:dirty_read(server_config, Table) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = Table}),
            [];
        #server_config{} -> 
            hdb:read_table(Table)
    end.

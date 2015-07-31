%%%-------------------------------------------------------------------
%%% @author Zhangr <zhangr011@gmail.com>
%%% @copyright (C) 2013, Zhangr
%%% @doc
%%%
%%% @end
%%% Created : 11 Nov 2013 by Zhangr <zhangr011@gmail.com>
%%%-------------------------------------------------------------------
-module(mod_player_recommened).

-behaviour(gen_server).

-include("define_logger.hrl").
-include("define_time.hrl").
-include("define_relationship.hrl").
-include("define_player.hrl").
-include("define_goods.hrl").
-define(STARTER_ROBOT_PLAYER, 10000).
-define(DEFAULT_CORE_BASE_ID, 50100001).

%% API
-export([start_link/0]).
-export([update/1, query_recommened/2]).

-export([gm_clear/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER,        ?MODULE). 
-define(REFRESH_DELTA, ?TEN_MINITE_SECONDS * 1000).
-define(ETS_PLAYER_RECOMMENED, ets_player_recommened).

-record(state, {}).
-record(player_recommened,
        {
          lv_type = 0,    %%等级类型
          id_list = []    %%玩家ID
        }).

%%%===================================================================
%%% API
%%%===================================================================
gm_clear() ->
    mnesia:clear_table(player_rec).

update(Player) ->
    gen_server:cast(?SERVER, {cmd_update, Player}).
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
    ets:new(?ETS_PLAYER_RECOMMENED, [{keypos, #player_recommened.lv_type}, set, named_table, public]),
    erlang:send_after(5000, self(), cmd_delay_update),
    {ok, #state{}}.

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
%%给外部调用的接口
query_recommened(PlayerId, Lv) ->
    LvType = get_lv_type(Lv),
    IdList = get_recommened_id_list(LvType),
    FIdList = lists:filter(fun(Id)
                                 when Id =:= PlayerId ->
                                   false;
                              (_) ->
                                   true
                           end, IdList),
    hdb:dirty_read_list(player_rec, FIdList).


handle_call(cmd_query, _From, State) ->
    {reply, State, State};
handle_call(_Request, _From, State) ->
    ?WARNING_MSG("bad matched: ~p~n", [_Request]),
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
handle_cast({cmd_update_all, #player{id = Id} = Player}, State) ->
    
    hdb:dirty_write(player_rec, Player),
    lists:foreach(fun(X) -> 
                          add_id_list(Id,X) 
                  end, lists:seq(1, 14)),
    {noreply, State};

handle_cast({cmd_update, #player{
                            id = Id,
                            lv = Lv
                           }=Player}, State) ->
    NewState =
        if
            Lv >= ?FRIEND_MIN_LV ->
                %% 更新好友推荐列表，只有玩家达到一定的级别才会记录
                %% 测试用，测试环境下是没有mnesia数据库节点的
                hdb:dirty_write(player_rec, Player),
                LvType = get_lv_type(Lv),
                add_id_list(Id, LvType);
            true ->
                State
        end,
    {noreply, NewState};

handle_cast(_Msg, State) ->
    ?WARNING_MSG("cmd not matched: ~p~n", [_Msg]),
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
handle_info(cmd_delay_update, State) ->
    %% dirty code here
    %% 由于并不是处理通用的，所以没有去每个模块添加对应的方法，直接在这里写了 roowe
    
    %% lists:foreach(fun(Id) ->
    %%                       AddInitFun = fun() ->
    %%                                            case lib_goods:add_init_equip(Id, [?DEFAULT_CORE_BASE_ID]) of
    %%                                                {ok, #goods{id=CoreId}} ->
    %%                                                    CoreId;
    %%                                                _ ->
    %%                                                    0
    %%                                            end
    %%                                    end,
    %%                       CoreId = case hdb:dirty_read(player_goods, Id) of
    %%                                    [] ->
    %%                                        AddInitFun();
    %%                                    #player_goods{
    %%                                       goods_list = GoodsList
    %%                                      } ->
    %%                                        case lists:keyfind(?DEFAULT_CORE_BASE_ID, #goods.goods_id, GoodsList) of
    %%                                            false ->
    %%                                                AddInitFun();
    %%                                            #goods{id=TmpCoreId} ->
    %%                                                TmpCoreId
    %%                                        end
    %%                                end,
    %%                       Player = #player{
    %%                                   id       = Id,
    %%                                   nickname = hmisc:rand_str(),
    %%                                   career   = 1,
    %%                                   lv       = hmisc:rand(1, 50),
    %%                                   core     = CoreId,
    %%                                   fashion  = 10901000,
    %%                                   timestamp_login = hmisctime:unixtime()},
    %%                       gen_server:cast(self(), {cmd_update_all, Player})
    %%               end, lists:seq(?STARTER_ROBOT_PLAYER, ?STARTER_ROBOT_PLAYER+2)), 
    
    {noreply, State};
handle_info(_Info, State) ->
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
terminate(Reason, _State) ->
    ?DEBUG("terminate Reason ~p~n", [Reason]),
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
%%对ETS表的操作

add_id_list(Id,LvType) ->
    %%在player_lvtype找到Lv_Type的字段 将Id写进去
    case ets:lookup(?ETS_PLAYER_RECOMMENED, LvType) of
        [] ->
            ets:insert(?ETS_PLAYER_RECOMMENED, #player_recommened{
                                                  lv_type = LvType,
                                                  id_list = [Id]
                                                 });        
        [#player_recommened{
            id_list = IdList
           } = PlayerRecommened] ->
            NewIdList = inner_cache(Id, IdList),
            ets:insert(?ETS_PLAYER_RECOMMENED, PlayerRecommened#player_recommened{
                                                 id_list = NewIdList
                                                })            
    end.

get_recommened_id_list(LvType) ->
    %%在player_lvtype找到Lv_Type的字段 返回id_list
    case ets:lookup(?ETS_PLAYER_RECOMMENED, LvType) of
        [] ->
            [];
        [#player_recommened{
            id_list = IdList
           }] ->
            IdList
    end.


get_lv_type(Lv) ->
    if
        Lv >= 300 ->
            14;
        Lv >= 250 ->
            13;
        Lv >= 200 ->
            12;
        Lv >= 150 ->
            11;
        Lv >= 100 ->
            10;
        Lv >= 90 ->
            9;
        Lv >= 80 ->
            8;
        Lv >= 70 ->
            7;
        Lv >= 60 ->
            6;
        Lv >= 50 ->
            5;
        Lv >= 40 ->
            4;
        Lv >= 30 ->
            3;
        Lv >= 20 ->
            2;
        true ->
            1
    end.
%%%===================================================================
%%% Internal functions
%%%===================================================================

%% @doc 添加一个角色到对应的列表中
%% @spec
%% @end
inner_cache(PlayerId, []) ->
    [PlayerId];
inner_cache(PlayerId, [H1 | []] = IdList) 
  when PlayerId =/= H1 ->
    [PlayerId | IdList];
inner_cache(PlayerId, [H1, H2 | []] = IdList) 
  when PlayerId =/= H1 andalso PlayerId =/= H2 ->
    [PlayerId | IdList];
inner_cache(PlayerId, [H1, H2, H3 | []] = IdList) 
  when PlayerId =/= H1 andalso PlayerId =/= H2 andalso
       PlayerId =/= H3 ->
    [PlayerId | IdList];
inner_cache(PlayerId, [H1, H2, H3, H4 | []] = IdList)
  when PlayerId =/= H1 andalso PlayerId =/= H2 andalso
       PlayerId =/= H3 andalso PlayerId =/= H4 ->
    [PlayerId | IdList];
inner_cache(PlayerId, [H1, H2, H3, H4, H5 | []] = IdList)
  when PlayerId =/= H1 andalso PlayerId =/= H2 andalso
       PlayerId =/= H3 andalso PlayerId =/= H4 andalso
       PlayerId =/= H5 ->
    [PlayerId | IdList];
inner_cache(PlayerId,
            [H1, H2, H3, H4, H5, H6 | []] = IdList)
  when PlayerId =/= H1 andalso PlayerId =/= H2 andalso
       PlayerId =/= H3 andalso PlayerId =/= H4 andalso
       PlayerId =/= H5 andalso PlayerId =/= H6 ->
    [PlayerId | IdList];
inner_cache(PlayerId,
            [H1, H2, H3, H4, H5, H6, H7 | []]
            = IdList) 
  when PlayerId =/= H1 andalso PlayerId =/= H2 andalso
       PlayerId =/= H3 andalso PlayerId =/= H4 andalso
       PlayerId =/= H5 andalso PlayerId =/= H6 andalso
       PlayerId =/= H7 ->
    [PlayerId | IdList];
inner_cache(PlayerId,
            [H1, H2, H3, H4, H5, H6, H7, H8 | []] = IdList) 
  when PlayerId =/= H1 andalso PlayerId =/= H2 andalso
       PlayerId =/= H3 andalso PlayerId =/= H4 andalso
       PlayerId =/= H5 andalso PlayerId =/= H6 andalso
       PlayerId =/= H7 andalso PlayerId =/= H8->
    [PlayerId | IdList];
inner_cache(PlayerId,
            [H1, H2, H3, H4, H5, H6, H7, H8, H9 | []] = IdList) 
  when PlayerId =/= H1 andalso PlayerId =/= H2 andalso
       PlayerId =/= H3 andalso PlayerId =/= H4 andalso
       PlayerId =/= H5 andalso PlayerId =/= H6 andalso
       PlayerId =/= H7 andalso PlayerId =/= H8 andalso
       PlayerId =/= H9 ->
    [PlayerId | IdList];
inner_cache(PlayerId,
            [H1, H2, H3, H4, H5, H6, H7, H8, H9, H10 | []] = IdList) 
  when PlayerId =/= H1 andalso PlayerId =/= H2 andalso
       PlayerId =/= H3 andalso PlayerId =/= H4 andalso
       PlayerId =/= H5 andalso PlayerId =/= H6 andalso
       PlayerId =/= H7 andalso PlayerId =/= H8 andalso
       PlayerId =/= H9 andalso PlayerId =/= H10 ->
    [PlayerId | IdList];
inner_cache(PlayerId,
            [H1, H2, H3, H4, H5, H6, H7, H8, H9, H10 | _Tail]) 
  when PlayerId =/= H1 andalso PlayerId =/= H2 andalso
       PlayerId =/= H3 andalso PlayerId =/= H4 andalso
       PlayerId =/= H5 andalso PlayerId =/= H6 andalso
       PlayerId =/= H7 andalso PlayerId =/= H8 andalso
       PlayerId =/= H9 andalso PlayerId =/= H10 ->
    [PlayerId, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10];
inner_cache(_PlayerId, IdList) ->
    IdList.

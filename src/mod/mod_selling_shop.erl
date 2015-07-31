%%%-------------------------------------------------------------------
%%% @author human <humanzhigang@gzleshu.com>
%%% @copyright (C) 2014, human
%%% @doc
%%%
%%% @end
%%% Created : 30 Oct 2014 by human <humanzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_selling_shop).

-behaviour(gen_server).

%% API
-export([start_link/0, 
         get_ordinary_shop_list/0,
         get_main_shop_list/0,
         update_ordinary_shop/2,
         update_main_shop/2
        ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER,  ?MODULE). 

-include("define_player.hrl").
-include("define_goods.hrl").
-include("db_base_shop.hrl").
-include("define_logger.hrl").
-include("define_time.hrl").
-include("define_mnesia.hrl").
-include("define_try_catch.hrl").

-record(state, {
          shop_msg_list = [], %% 普通商城热卖
          main_shop_msg_list = [] %% 竞技商城热卖
         }).

%%%===================================================================
%%% API
%%%===================================================================

get_ordinary_shop_list()->
    gen_server:call(?MODULE, get_ordinary_shop_list).

update_ordinary_shop(ShopId, Num)->
    gen_server:cast(?MODULE, {update_ordinary_shop, ShopId, Num}).

get_main_shop_list()->
    gen_server:call(?MODULE, get_main_shop_list).

update_main_shop(ShopId, Num)->
    gen_server:cast(?MODULE, {update_main_shop, ShopId, Num}).
    
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
    process_flag(trap_exit, true),
    erlang:send_after(10, self(), init_shop),
    %% timer:sleep(5000),
    {ok, #state{}}.

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
do_handle_call(get_ordinary_shop_list, _From, State) ->
    Reply = State#state.shop_msg_list,
    {reply, Reply, State};

do_handle_call(get_main_shop_list, _From, State) ->
    Reply = State#state.main_shop_msg_list,
    {reply, Reply, State};

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

do_handle_cast({update_ordinary_shop, ShopId, Num}, #state{
                                                        shop_msg_list = ShopList
                                                       } = State) ->
    NewShopList = 
        case lists:keytake(ShopId, #ordinary_shop_msg.base_id, ShopList) of
            false ->
                [dirty_ordinary_shopmsg(#ordinary_shop_msg{
                                           base_id = ShopId,
                                           buy_num = Num
                                          }) | ShopList];
            {value, ShopMsg, Rest}->
                [dirty_ordinary_shopmsg(ShopMsg#ordinary_shop_msg{
                                          buy_num = ShopMsg#ordinary_shop_msg.buy_num + Num
                                         }) | Rest]
        end,
    {noreply, State#state{shop_msg_list = NewShopList}};

do_handle_cast({update_main_shop, ShopId, Num}, #state{
                                                main_shop_msg_list = ShopList
                                               } = State) ->
    NewShopList = 
        case lists:keytake(ShopId, #main_shop_msg.base_id, ShopList) of
            false ->
                [dirty_main_shopmsg(#main_shop_msg{
                                           base_id = ShopId,
                                           buy_num = Num
                                          }) | ShopList];
            {value, ShopMsg, Rest}->
                [dirty_main_shopmsg(ShopMsg#main_shop_msg{
                                      buy_num = ShopMsg#main_shop_msg.buy_num + Num
                                     }) | Rest]
        end,
    {noreply, State#state{main_shop_msg_list = NewShopList}};

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
do_handle_info(init_shop, State) ->
    OrdinaryShop = reset_table(ordinary_shop_msg),
    MainShop = reset_table(main_shop_msg),
    set_timer(),
    {noreply, State#state{
                shop_msg_list = OrdinaryShop,
                main_shop_msg_list = MainShop
               }};

do_handle_info(reset_ordinary_shop, State) ->
    erlang:send_after(?ONE_WEEK_SECONDS * 1000, self(), reset_ordinary_shop),
    ?WARNING_MSG("clear_table ~p~n", [ordinary_shop_msg]),
    hdb:clear_table(ordinary_shop_msg),
    hdb:clear_table(main_shop_msg),
    {noreply, State#state{
                shop_msg_list = [],
                main_shop_msg_list = []
               }};

do_handle_info(save_ordinary_shop, #state{
                                   shop_msg_list = OrdinaryShop,
                                   main_shop_msg_list = MainShop
                                  }=State) ->
    erlang:send_after(?ORDINARY_SHOP_SAVE_TIME, self(), save_ordinary_shop),
    {noreply, State#state{
                shop_msg_list = 
                    lists:map(fun(ShopMsg) ->
                                      lib_shop:save_ordinary_shop(ShopMsg)
                              end, OrdinaryShop),
                main_shop_msg_list = 
                    lists:map(fun(ShopMsg) ->
                                      lib_shop:save_main_shop(ShopMsg)
                              end, MainShop)
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
terminate(_Reason, #state{
                      shop_msg_list = ShopList,
                      main_shop_msg_list = MainShopList
                     }) ->
    lists:map(fun(OrdinaryShopMsg)->
                      lib_shop:save_ordinary_shop(OrdinaryShopMsg)
              end, ShopList),
    lists:map(fun(MainShopMsg)->
                      lib_shop:save_main_shop(MainShopMsg)
              end, MainShopList),
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

set_timer()->
    erlang:send_after(?ORDINARY_SHOP_SAVE_TIME, self(), save_ordinary_shop),
    Seconds = time_misc:get_seconds_to_next_week(),
    erlang:send_after(Seconds*1000, self(), reset_ordinary_shop).

dirty_ordinary_shopmsg(OrdinaryShopMsg) 
  when is_record(OrdinaryShopMsg, ordinary_shop_msg) ->
    OrdinaryShopMsg#ordinary_shop_msg{
      is_dirty = 1
     }.

dirty_main_shopmsg(MainShopMsg) 
  when is_record(MainShopMsg, main_shop_msg) ->
    MainShopMsg#main_shop_msg{
      is_dirty = 1
     }.

reset_table(Table) ->
    Now = time_misc:unixtime(),
    case hdb:dirty_read(server_config, Table) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = Table,
                                                          v = Now}),
            [];
        #server_config{
           v = LastTime
          } = ServerConfig ->            
            case time_misc:is_same_week(LastTime, Now) of
                false ->
                    hdb:clear_table(Table),
                    hdb:dirty_write(server_config, ServerConfig#server_config{
                                                     v = Now
                                                    }),
                    [];
                true ->
                    hdb:read_table(Table)
            end
    end.

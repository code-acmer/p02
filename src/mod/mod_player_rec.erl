%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created :  2 Sep 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_player_rec).

-behaviour(gen_server).

-include("define_recommend.hrl").
-include("define_player.hrl").
-include("define_logger.hrl").
-include("define_try_catch.hrl").

%% API
-export([start_link/1]).

-export([new_player/1,
         recommend/1,
         recommend/2,
         update_ability/4
        ]).

-export([test/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {server}).

%%%===================================================================
%%% API
%%%===================================================================
server_name(DbSn) ->
    server_misc:server_name(?MODULE, DbSn).

new_player(#player{id = Id, sn = Sn, battle_ability = Ability}) ->
    ?DEBUG("add player : ~p~n",[Id]),
    gen_server:cast(player_sn_to_server(Sn), {new_player, Id, Ability}).

recommend(#player{id = Id, sn = Sn, battle_ability = Ability}) ->
    gen_server:call(player_sn_to_server(Sn), {recommend, Id, Ability, ?DEFAULT_REC_NUM}).

recommend(#player{id = Id, sn = Sn, battle_ability = Ability}, Num) ->
    gen_server:call(player_sn_to_server(Sn), {recommend, Id, Ability, Num}).

update_ability(PlayerId, Sn, OldAbility, NewAbility) ->
    gen_server:cast(player_sn_to_server(Sn), {cmd_update_ability, PlayerId, OldAbility, NewAbility}).
    %% ok.

test() ->
    Key = hdb:dirty_first(player),
    test2(Key).

test2('$end_of_table') ->
    skip;
test2(Key) ->
    Player = hdb:dirty_read(player, Key),
    new_player(Player),
    test2(hdb:dirty_next(player, Key)).
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(DbSn) ->
    Server = server_name(DbSn),
    gen_server:start_link({local, Server}, ?MODULE, [Server], []).

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
init([Server]) ->
    {ok, #state{server = Server}}.

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
do_handle_call({recommend, Id, Ability, Num}, _, #state{server = Server} = State) ->
    Reply = inner_handle_recommend(Server, Id, Ability, Num),
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
do_handle_cast({new_player, Id, Ability}, #state{server = Server} = State) ->
    inner_add_player(Server, Id, Ability),
    {noreply, State};
do_handle_cast({cmd_update_ability, Id, OldAbility, NewAbility}, #state{server = Server} = State) ->
    inner_update_ability(Server, Id, OldAbility, NewAbility),
    {noreply, State};
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
do_handle_info(_Info, State) ->
    ?WARNING_MSG("mod_player_rec recv info ~p~n", [_Info]),
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
terminate(_Reason, #state{server = Server}) ->
    ?ERROR_MSG("~p terminate Reason ~p~n", [Server, _Reason]),
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
inner_add_player(Server, PlayerId, Ability) ->
    case key(Server, Ability) of
        error ->
            skip;
        Key ->
            NewValue = 
                case cache_misc:get(Key) of
                    [] ->
                        %% ListRand = list_rand:new(?MAX_LEVEL_NUM, ?GET_LEVEL_NUM),
                        %% list_rand:in(PlayerId, ListRand);
                        Cache = random_cache:new(?MAX_LEVEL_NUM),
                        random_cache:add(PlayerId, Cache);
                    Cache ->
                        random_cache:add(PlayerId, Cache)
                end,
            cache_misc:set(Key, NewValue, infinity)
    end.

%% inner_handle_recommend(Server, Id, Ability) ->
%%     [Min, Max] = get_ability_range(Server, Ability, ?DEFAULT_RANGE),
%%     RecList = 
%%         lists:foldl(fun(TLv, AccList) ->
%%                             GetList = get_recommend_player(Server, TLv),
%%                             GetList ++ AccList
%%                     end, [], lists:seq(Min, Max)),
%%     %%去掉重复的和自己的，由于RecList长度比较短，性能应该不会有问题
%%     lists:usort(lists:sublist(RecList, ?DEFAULT_REC_NUM)) -- [Id].

inner_handle_recommend(Server, Id, Ability, Num) ->
    case key(Server, Ability) of
        error ->
            [];
        Key ->
            case cache_misc:get(Key) of
                [] ->
                    [];
                Cache->
                    random_cache:get_values(Num, Cache) -- [Id]
            end
            %% lists:usort(inner_handle_recommend2(Key, Num, [], ?DEFAULT_REC_TIMES)) -- [Id]
    end.

%% inner_handle_recommend2(_Key, 0, AccIds, _) ->
%%     AccIds;
%% inner_handle_recommend2({_, 0}, 0, AccIds, _) ->
%%     AccIds;
%% inner_handle_recommend2(_, _, AccIds, 0) ->
%%     AccIds;
%% inner_handle_recommend2({Server, AbilityId} = Key, Num, AccIds, AccTimes) ->
%%     case cache_misc:get(Key) of
%%         [] ->
%%             %% inner_handle_recommend2({Server, AbilityId - 1}, Num, AccIds, AccTimes - 1);
%%             [];
%%         ListRand ->
%%             {OutList, NewListRand} = list_rand:cur(ListRand, Num),
%%             GetSize = length(OutList),
%%             cache_misc:set(Key, NewListRand, infinity),
%%             inner_handle_recommend2({Server, AbilityId - 1}, Num - GetSize, AccIds ++ OutList, AccTimes - 1)
%%     end.

key(Server, Ability) ->
    case data_base_ability:get(Ability) of
        [] ->
            error;
        Num ->
            {Server, Num}
    end.


inner_update_ability(Server, Id, OldAbility, NewAbility) -> 
    OldKey = key(Server, OldAbility),
    NewKey = key(Server, NewAbility),
    if
        OldKey =/= NewKey -> 
            case cache_misc:get(OldKey) of
                [] ->
                    ignored;
                Cache ->
                    NewCache = random_cache:remove(Id, Cache),
                    cache_misc:set(OldKey, NewCache, infinity)
            end,
            inner_add_player(Server, Id, NewAbility);
        true -> 
            ignored
    end.



%% get_ability_range(Server, Ability, Range) ->
%%     Min = Ability * (100-Range) div 100,
%%     Max = Ability * (100+Range) div 100,
%%     [Min, Max].

%% get_recommend_player(Server, Lv) ->
%%     Key = key(Server, Lv),
%%     case cache_misc:get(Key) of
%%         [] ->
%%             [];
%%         ListRand ->
%%             {OutList, NewListRand} = list_rand:cur(ListRand),
%%             cache_misc:set(Key, NewListRand, infinity),
%%             OutList
%%     end.

player_sn_to_server(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    server_name(DbSn).

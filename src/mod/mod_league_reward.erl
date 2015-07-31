%%%-------------------------------------------------------------------
%%% @author li <lijunqiang@moyou.me>
%%% @copyright (C) 2015, li
%%% @doc
%%%
%%% @end
%%% Created : 17 Apr 2015 by li <lijunqiang@moyou.me>
%%%-------------------------------------------------------------------
-module(mod_league_reward).

-behaviour(gen_server).

-include("define_logger.hrl").
-include("define_league.hrl").
-include("define_mnesia.hrl").
-include("define_time.hrl").
-include("define_player.hrl").
-include("db_base_guild_rank_integral.hrl").
-include("define_info_40.hrl").
-include("define_goods_type.hrl").
-include("define_money_cost.hrl").
-include("define_goods_rec.hrl").
-include("define_goods.hrl").

%% API
-export([start_link/1, 
         update_league_data/2,
         reset_point_table/0,
         reset_member_challenge/0,
         daily_send_league_reward/0,
         fight_win_reward/0,
         fill_point/0,
         reset_member_challenge_table/1
        ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {sn = 0}).

%%%===================================================================
%%% API
%%%===================================================================

update_league_data(ProcessName, LeagueRelationList) ->
    gen_server:cast(ProcessName, {updata_league_data, LeagueRelationList}).

%% 结算奖励之后清除据点表
reset_point_table() ->
    DbSnList = server_misc:mnesia_sn_list(),
    lists:map(fun(Sn) ->
                      ProcessName = get_reward_processname_by_sn(Sn),
                      gen_server:cast(ProcessName, reset_point_table)
              end, DbSnList).

%% 操作时间： 开战之前
reset_member_challenge() ->
    DbSnList = server_misc:mnesia_sn_list(),
    lists:map(fun(Sn) ->
                      ProcessName = get_reward_processname_by_sn(Sn),
                      gen_server:cast(ProcessName, reset_member_challenge)
              end, DbSnList).

%% 操作时间： 每日发放奖励
daily_send_league_reward() ->
    DbSnList = server_misc:mnesia_sn_list(),
    lists:map(fun(Sn) ->
                      ProcessName = get_reward_processname_by_sn(Sn),
                      gen_server:cast(ProcessName, send_league_reward)
              end, DbSnList).

%% 战斗结束结算奖励
fight_win_reward() ->
    DbSnList = server_misc:mnesia_sn_list(),
    lists:map(fun(Sn) ->
                      ProcessName = get_reward_processname_by_sn(Sn),
                      gen_server:cast(ProcessName, fight_win_reward)
              end, DbSnList).

fill_point() ->
    DbSnList = server_misc:mnesia_sn_list(),
    lists:map(fun(Sn) ->
                      ProcessName = get_reward_processname_by_sn(Sn),
                      gen_server:cast(ProcessName, cmd_fill_point)
              end, DbSnList).
    
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
server_name(DbSn) ->
    server_misc:server_name(?MODULE, DbSn).

start_link(DbSn) ->
    Server = server_name(DbSn),
    gen_server:start_link({local, Server}, ?MODULE, [DbSn], []).

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
init([DbSn]) ->
    {ok, #state{sn = DbSn}}.

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
handle_call(_Request, _From, State) ->
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
handle_cast({updata_league_data, LeagueRelationList}, #state{sn = Sn} = State) ->
    update_league_table(LeagueRelationList, Sn),
    {noreply, State};

handle_cast(reset_point_table, #state{sn = Sn} = State) ->
    reset_league_point_table(Sn),
    {noreply, State};

handle_cast(reset_member_challenge, #state{sn = Sn} = State) ->
    reset_member_challenge_table(Sn),
    {noreply, State};

handle_cast(send_league_reward, #state{sn = Sn} = State) ->
    day_send_reward(Sn),    
    {noreply, State};

handle_cast(fight_win_reward, #state{sn = Sn} = State) ->
    send_fight_win_reward(Sn),    
    {noreply, State};

handle_cast(cmd_fill_point, #state{sn = Sn} = State) ->
    cmd_fill_point(Sn),
    {noreply, State};

handle_cast(_, State) ->
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

handle_info(timeout, State) ->
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
terminate(_Reason, _State) ->
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

get_league_table(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    list_to_atom(lists:concat([league, "_", DbSn])).

get_league_relation_table(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    list_to_atom(lists:concat([league_relation, "_", DbSn])).

get_league_member_challenge_table(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    list_to_atom(lists:concat([league_member_challenge, "_", DbSn])).

update_league_table(LeagueRelationList, Sn) ->
    AllExp = data_base_guild_lv_exp:get_all_exp(),
    Table = get_league_table(Sn),
    lists:map(fun(#league_relation{
                     league_id = LeagueId,
                     league_group = LeagueGroup,
                     league_thing = LeagueThing
                    }) ->
                      Fun = fun() ->
                                    case mnesia:wread({Table, LeagueId}) of
                                        [] ->
                                            skip;
                                        [#league{league_exp = Exp} = League] ->
                                            NewLeague = League#league{
                                                          %% 经验值与公会物资数值相等
                                                          league_exp = Exp + LeagueThing,
                                                          lv = count_league_lv(Exp + LeagueThing, AllExp),
                                                          league_group = LeagueGroup
                                                         },
                                            mnesia:write(Table, NewLeague, write);
                                        Other ->
                                            ?DEBUG("Other: ~p", [Other])
                                    end
                            end,
                      hdb:transaction(Fun)
              end, LeagueRelationList).

count_league_lv(Thing, AllExp) ->
    count_league_lv(Thing, AllExp, 0).

count_league_lv(Thing, [H | T], LvCount) when Thing >= H ->
    count_league_lv(Thing, T, LvCount + 1);
count_league_lv(_, _, LvCount) ->
    LvCount.

reset_league_point_table(Sn) ->
    Table = get_league_relation_table(Sn),
    AllKeys = hdb:dirty_all_keys(Table),
    lists:map(fun(LeagueId) ->
                      lib_league_fight:update_league_fight_point_table(LeagueId)
              end, AllKeys).    

reset_member_challenge_table(Sn) ->
    Table = get_league_relation_table(Sn),
    %?DEBUG("Table: ~p", [Table]),
    AllKeys = hdb:dirty_all_keys(Table),
    %% ?DEBUG("AllKeys: ~p", [AllKeys]),
    lists:map(fun(LeagueId) ->
                      AllMember = hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id, true),
                      reset_member_challenge_table(AllMember, Sn)
              end, AllKeys).

reset_member_challenge_table(AllMember, Sn) ->
    Table = get_league_member_challenge_table(Sn),
    %hdb:clear_table(Table), 
    lists:map(fun(#league_member{
                     player_id = PlayerId,
                     league_id = LeagueId
                    }) ->
                      ?DEBUG("PlayerId: ~p, Sn: ~p, LeagueId: ~p", [PlayerId, Sn, LeagueId]),
                      hdb:dirty_write(Table, #league_member_challenge{
                                                player_id = PlayerId,
                                                league_id = LeagueId,
                                                grap_thing = 0,
                                                grap_num = ?GRAB_NUM,
                                                use_challenge_num = 0
                                               })
              end, AllMember).

get_reward_processname_by_sn(Sn) ->
    list_to_atom(lists:concat([mod_league_reward, "_", Sn])).

day_send_reward(Sn) ->
    AllKeys = hdb:dirty_all_keys(get_league_relation_table(Sn)),
    LeagueTable = get_league_table(Sn),
    Title = 
        unicode:characters_to_binary("公会奖励"),
    Content1 = 
        unicode:characters_to_binary("参加工会战获得日基本工资！恭喜"), 
    lists:map(fun(LeagueId) ->
                      case hdb:dirty_read(LeagueTable, LeagueId) of
                          [] ->
                              skip;
                          #league{league_group = Group} ->
                              AllMember = 
                                  hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id, true),
                              case data_base_guild_rank_integral:get(Group) of
                                  [] ->
                                      skip;
                                  #base_guild_rank_integral{rank_wage = Wage} ->
                                      lists:map(fun(#league_member{
                                                       player_id = Id,
                                                       player_name = NickName
                                                      }) ->
                                                        Content2 = 
                                                            unicode:characters_to_binary(lists:concat(["获得", Wage, "公会印章"])),
                                                        Content = 
                                                            <<Content1/binary, NickName/binary, Content2/binary>>,
                                                        Mail = lib_mail:mail(NickName, Title, Content, [{?GOODS_TYPE_LEAGUE_SEAL, Wage}]),
                                                        lib_mail:send_mail(Id, Mail)
                                                end, AllMember)
                              end
                      end
              end, AllKeys).

send_fight_win_reward(Sn) ->
    Table = get_league_relation_table(Sn), 
    AllKeys = hdb:dirty_all_keys(Table),
    Title = 
        unicode:characters_to_binary("军团掠夺战奖励"),
    Content1 = 
        unicode:characters_to_binary("本轮军团掠夺战获胜！恭喜"), 
    lists:map(fun(LeagueId) ->
                      case hdb:dirty_read(Table, LeagueId) of
                          [] ->
                              skip;
                          #league_relation{fight_record = [Last | _]}
                            when Last =:= ?FIGHT_WIN_TYPE ->
                              AllMember = 
                                  hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id, true),
                              lists:map(fun(#league_member{
                                               player_id = Id,
                                               player_name = NickName
                                              }) ->
                                                Content2 = 
                                                    unicode:characters_to_binary(lists:concat(["获得额外奖励", ?LEAGUE_THING, "军团印章"])),
                                                Content = 
                                                    <<Content1/binary, NickName/binary, Content2/binary>>,
                                                Mail = lib_mail:mail(NickName, Title, Content, [{?GOODS_TYPE_LEAGUE_SEAL, ?LEAGUE_THING}]),
                                                lib_mail:send_mail(Id, Mail)
                                        end, AllMember);
                          _ ->
                              skip
                      end
              end, AllKeys).

cmd_fill_point(Sn) ->
    Table = get_league_relation_table(Sn), 
    AllKeys = hdb:dirty_all_keys(Table),
    lists:map(fun(LeagueId) ->
                      case hdb:dirty_index_read(league_fight_point, LeagueId, #league_fight_point.league_id, true) of
                          [] ->
                              skip;
                          AllPoint ->
                              cmd_fill_point1(LeagueId, AllPoint)
                      end
              end, AllKeys).

cmd_fill_point1(LeagueId, AllPoint) ->
    case hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id, true) of
        [] ->
            skip;
        AllMember ->
            List = 
                lists:map(fun(#league_member{
                                 player_id = Id,
                                 player_name = Name
                                }) ->
                                  Player = hdb:dirty_read(player, Id),
                                  {{Name, Id}, Player#player.high_ability}
                          end, AllMember),
            NList = lists:sort(fun({_, A}, {_, B}) -> 
                                       A > B
                               end, List),
            lists:foldl(fun(Point, [{Info1, _}, {Info2, _} | T]) ->
                                hdb:dirty_write(league_fight_point, cmd_fill_point2(Point, [Info1, Info2])),
                                T;
                            (Point, [{Info1, _}])->
                                hdb:dirty_write(league_fight_point, cmd_fill_point2(Point, [Info1])),
                                [];
                           (Point, []) ->
                                hdb:dirty_write(league_fight_point, cmd_fill_point2(Point, [])),
                                []
                        end, NList, AllPoint)
    end.

cmd_fill_point2(Point, ProtectInfo) ->
    Point#league_fight_point{
      status = 0,
      protect_info = ProtectInfo,
      occurpy_info = [],
      record_list = [], 
      attack_info = []
     }.

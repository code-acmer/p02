%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created : 11 Aug 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_team).

-behaviour(gen_server).

-include("define_player.hrl").
-include("define_team.hrl").
-include("define_info_13.hrl").
-include("define_logger.hrl").
-include("define_dungeon.hrl") .

%% API
-export([start/2]).
-export([in_team/3,
         get_team_state/1,
         invite/3,
         out_team/2,
         kick/3,
         ready/2,
         start_dungeon/2,
         chat/3,
         challenge_type/3,
         get_team_pid/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-define(TEAM_MAX_MEMBER, 2).


%%%===================================================================
%%% API
%%%===================================================================
in_team(ModPlayerState, TeamNum, DungeonId) ->
    case get_team_pid(TeamNum) of
        [] ->
            {fail, ?INFO_TEAM_GET_TEAM_ERROR};
        Pid ->
            gen_server:call(Pid, {in_team, {ModPlayerState, DungeonId}})
    end.

get_team_state(Pid) ->
    gen_server:call(Pid, get_team).

invite(Pid, InvitorId, PlayerIdList) ->
    gen_server:cast(Pid, {invite, InvitorId, PlayerIdList}).

out_team(Pid, PlayerId) ->
    gen_server:cast(Pid, {out_team, PlayerId}).

kick(Pid, PlayerId, Tid) ->
    gen_server:call(Pid, {kick_member, PlayerId, Tid}).

ready(Pid, PlayerId) ->
    gen_server:call(Pid, {get_ready, PlayerId}).

challenge_type(Pid, PlayerId, Flag) ->
    gen_server:call(Pid, {challenge_type, PlayerId, Flag}).

start_dungeon(Pid, ModPlayerState) ->
    gen_server:call(Pid, {start_dungeon, ModPlayerState}).

chat(Pid, PlayerId, Msg) ->
    gen_server:cast(Pid, {chat, PlayerId, Msg}).

get_team_pid(TeamNum) ->
    case gproc:where(process_name(TeamNum)) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            []
    end.
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start(Player, DungeonId) ->
    TeamNum = lib_counter:update_counter(team_uid, 1),
    gen_server:start({via, gproc, process_name(TeamNum)}, ?MODULE, [Player, DungeonId, TeamNum], []).

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
init([Player, DungeonId, TeamNum]) ->
    ?DEBUG("team server start TeamNum ~p~n", [TeamNum]),
    Member = member(Player),
    {ok, #team{leaderid = Player#player.id,
               members = [Member#member{state = ?MEMBER_STATE_READY}],
               dungeon_id = DungeonId,
               number = TeamNum}}.

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
handle_call({in_team, {#mod_player_state{player = Player} = ModPlayerState, DungeonId}}, _, 
            #team{members = Members,
                  dungeon_id = DungeonId,
                  state = DungeonState} = State) ->
    if
        DungeonState =:= ?TEAM_DUNGEON_ON ->
            {reply, {fail, ?INFO_TEAM_DUNGEON_ON}, State};
        true ->
            case lib_dungeon:check_dungeon(ModPlayerState, DungeonId) of
                {true, _, _} ->
                    case add_member(Members, Player) of
                        {fail, Reason} ->
                            {reply, {fail, Reason}, State};
                        {ok, NewMembers} ->
                            NewState = State#team{members = NewMembers},
                            send_to_members(NewState),
                            {reply, {ok, self()}, NewState}
                    end;
                Other ->
                    {reply, Other, State}
            end
    end;
handle_call(get_team, _, State) ->
    {reply, {ok, State}, State};
handle_call({out_team, PlayerId}, _, State) ->
    out_member(PlayerId, State);
handle_call({kick_member, PlayerId, Tid}, _, State) ->
    case kick_member(PlayerId, Tid, State) of
        {fail, Reason} ->
            {reply, {fail, Reason}, State};
        {ok, NewState} ->
            send_to_members(NewState),
            {reply, ok, NewState}
    end;
handle_call({get_ready, PlayerId}, _, State) ->
    case inner_ready(PlayerId, State) of
        {fail, Reason} ->
            {reply, {fail, Reason}, State};
        {ok, NewState} ->
            {reply, ok, NewState}
    end;
handle_call({start_dungeon, ModPlayerState}, _, State) ->
    case inner_start_dungeon(ModPlayerState, State) of
        {ok, NewMembers} ->
            NewState = State#team{state = ?TEAM_DUNGEON_ON,
                                  members = NewMembers},
            send_to_members(NewState),
            {reply, ok, NewState};
        {single, DungeonType} ->
            ?DEBUG("single member team trans to master dungeon ~n", []),
            {stop, normal, {single_dungeon, State#team.dungeon_id, DungeonType}, State};
        Other ->
            {reply, Other, State}
    end;
handle_call({challenge_type, PlayerId, Flag}, _, State) ->
    case inner_change_type(PlayerId, Flag, State) of
        {fail, Reason} ->
            {reply, {fail, Reason}, State};
        {ok, NewState} ->
            {reply, ok, NewState}
    end;
handle_call(_Request, _From, State) ->
    Reply = {fail, ?INFO_TEAM_GET_TEAM_ERROR},
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
handle_cast({invite, InvitorId, PlayerIdList}, State) ->
    ?DEBUG("inviting ~n", []),
    inner_invite(PlayerIdList, InvitorId, State),
    {noreply, State};
handle_cast({out_team, PlayerId}, State) ->
    case out_member(PlayerId, State) of
        {reply, _, NewState} ->
            {noreply, NewState};
        _ ->
            {stop, normal, State}
    end;
handle_cast({chat, PlayerId, Msg}, State) ->
    inner_chat(PlayerId, Msg, State),
    {noreply, State};
handle_cast(_Msg, State) ->
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
terminate(Reason, #team{number = TeamNum} = State) ->
    ?DEBUG("mod_team stop reason ~p state ~p TeamNum ~p~n", [Reason, State, TeamNum]),
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
    ?WARNING_MSG("_OldVsn ~p~n", [_OldVsn]),
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
member(Player) ->
    #member{player_id = Player#player.id,
            nickname  = Player#player.nickname,
            lv = Player#player.lv,
            battle_ability = Player#player.battle_ability,
            career = Player#player.career}.
    
add_member(Members, Player) ->
    case length(Members) >= ?TEAM_MAX_MEMBER of
        true ->
            {fail, ?INFO_TEAM_MEMBER_FULL};
        _ ->
            case lists:keyfind(Player#player.id, #member.player_id, Members) of
                false ->
                    {ok, [member(Player)|Members]};
                _ ->
                    {fail, ?INFO_TEAM_IN_TEAM}
            end
    end.

inner_invite(TarIdList, InvitorId, #team{members = Members,
                                         dungeon_id = DungeonId,
                                         number = Number}) ->
    PlayerIdList = 
        lists:filter(fun
                         (Id) when Id =:= InvitorId ->
                             false;
                         (Id) ->
                             case lists:keyfind(Id, #member.player_id, Members) of
                                 false ->
                                     true;
                                 _ ->
                                     false
                             end
                     end, TarIdList),
    ?DEBUG("PlayerIdList ~p~n", [PlayerIdList]),
    case lists:keyfind(InvitorId, #member.player_id, Members) of
        false ->
            ?WARNING_MSG("error occur when Invitor not in team ~p~n", [InvitorId]),
            skip;
        #member{nickname = NickName} ->
            lists:foreach(fun(PlayerId) ->
                              mod_player:invited_in_team(PlayerId, NickName, DungeonId, Number)    
                          end, PlayerIdList)
    end.
out_member(PlayerId, #team{leaderid = LeaderId,
                           members = Members} = Team) ->
    case lists:keytake(PlayerId, #member.player_id, Members) of
        false ->
            {reply, {fail, ?INFO_TEAM_NOT_IN_TEAM}, Team};
        {value, _Value, Rest} ->
            case out_member2(PlayerId, LeaderId, Team, Rest) of
                no_member ->
                    {stop, normal, ok, #team{}};
                {ok, NewState} ->
                    {reply, ok, NewState}
            end
    end.

out_member2(_, _, _, []) ->
    no_member;
out_member2(PlayerId, PlayerId, Team, Rest) ->
    NewLeader = hd(lists:reverse(Rest)),
    LeaderId = NewLeader#member.player_id,
    NewState = Team#team{leaderid = LeaderId,
                         members = lists:keystore(LeaderId, #member.player_id, 
                                                  Rest, NewLeader#member{state = ?MEMBER_STATE_READY})},
    send_to_members(NewState),
    {ok, NewState};
out_member2(_, _, Team, Rest) ->
    NewState = Team#team{members = Rest},
    send_to_members(NewState),
    {ok, NewState}.

kick_member(PlayerId, Tid, #team{
                              leaderid = PlayerId,
                              members = Members} = Team) ->
    case lists:keytake(Tid, #member.player_id, Members) of
        false ->
            {fail, ?INFO_TEAM_TAR_NOT_IN_TEAM};
        {value, _Value, Rest} ->
            mod_player:team_kick(Tid),
            {ok, Team#team{members = Rest}}
    end;
kick_member(_, _, _) ->
    {fail, ?INFO_TEAM_NOT_LEADER}.

inner_ready(PlayerId, #team{members = Members} = Team) ->
    case lists:keytake(PlayerId, #member.player_id, Members) of
        false ->
            {fail, ?INFO_TEAM_NOT_IN_TEAM};
        {value, Value, Rest} ->
            if
                Value#member.state =:= ?MEMBER_STATE_READY ->
                    {fail, ?INFO_TEAM_DO_IN_READY};
                true ->
                    NewTeam = Team#team{members = [Value#member{state = ?MEMBER_STATE_READY}|Rest]},
                    send_to_members(NewTeam),
                    {ok, NewTeam}
            end
    end.

inner_change_type(PlayerId, Flag, Team) ->
    if
        PlayerId =/= Team#team.leaderid ->
            {fail, ?INFO_TEAM_DUNGEON_START_LIMIT};
        true ->
            NewTeam = Team#team{challenge_type = Flag},
            send_to_members(NewTeam),
            {ok, NewTeam}
    end.

inner_start_dungeon(ModPlayerState, #team{members = Members,
                                          dungeon_id = DungeonId} = Team) ->
    if
        ModPlayerState?PLAYER_ID =/= Team#team.leaderid ->
            {fail, ?INFO_TEAM_DUNGEON_START_LIMIT};
        length(Members) =:= 1 -> %%单人就话走黄雀在后
            %% case data_base_dungeon_area:get(DungeonId) of
            %%     [] ->
            %%         {fail, ?INFO_CONF_ERR};
            %%     #base_dungeon_area{dungeon_type = DungeonType} ->
            %%         {single, DungeonType}
            %% end;
            {fail, ?INFO_TEAM_DUNGEON_START_LIMIT};
        true ->
            case check_member_ready(Members) of
                false ->
                    {fail, ?INFO_TEAM_NOT_ALL_READY};
                true ->
                    inner_start_dungeon2(Team)
            end
    end.

inner_start_dungeon2(#team{leaderid = LeaderId,
                           dungeon_id = DungeonId,
                           members = Members,
                           number = Number,
                           challenge_type = ChallengeType}) ->
    case data_base_dungeon_area:get(DungeonId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        Dungeon ->
            {TeamFlag, BossRewardDegree} = 
                case lib_dungeon:is_double_drop(Dungeon) of
                    false ->
                        case ChallengeType of
                            ?CHALLENGE_TYPE_ON ->
                                {?TEAM_FLAG_SNATCH, 1.5};
                            _ ->
                                {?TEAM_FLAG_NO_SNATCH, 1}
                        end;
                    _ ->
                        %%时间内的王者
                        {?TEAM_FLAG_SNATCH, 2}
                end,
            ?DEBUG("BossRewardDegree ~p~n", [BossRewardDegree]),
            case lib_dungeon:generate_dungeon_item(Dungeon, BossRewardDegree) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, MonsDropInfoList, AllDrops} ->
                    NewMembers = 
                        lists:map(fun(#member{player_id = PlayerId} = Member) ->
                                          mod_player:team_start(PlayerId, 
                                                                {Dungeon, MonsDropInfoList, AllDrops, Number, TeamFlag}),
                                          if
                                              PlayerId =:= LeaderId ->
                                                  Member;
                                              true ->
                                                  Member#member{state = ?MEMBER_STATE_NOT_READY}
                                          end
                                  end, Members),
                    {ok, NewMembers}
            end
    end.
                   
check_member_ready([]) ->
    true;
check_member_ready([#member{state = ?MEMBER_STATE_NOT_READY}|_]) ->
    false;
check_member_ready([_H|T]) ->
    check_member_ready(T).

inner_chat(PlayerId, Msg, #team{members = Members}) ->
    case lists:keytake(PlayerId, #member.player_id, Members) of
        false ->
            skip;
        {value, _Value, []} ->
            skip;
        {value, _Value, Rest} ->
            {ok, Bin} = pt_13:write(13208, {PlayerId, Msg}),
            lists:foreach(fun(#member{player_id = SendId}) ->
                                  mod_player:send_to_client(SendId, Bin)
                          end, Rest)
    end.

send_to_members(#team{members = Members} = Team) ->
    {ok, Bin} = pt_13:write(13205, Team),
    lists:foreach(fun(#member{player_id = PlayerId}) ->
                          mod_player:send_to_client(PlayerId, Bin)
                  end, Members).

process_name(TeamNum) ->
    {n, l, {team, TeamNum}}.

-module(lib_team).
-include("define_player.hrl").
-include("define_info_12.hrl").
-include("define_info_13.hrl").
-include("define_team.hrl").
-include("define_logger.hrl").
-include("define_dungeon.hrl").

-export([create_team/2,
         get_team/0,
         get_team/1,
         invite_in_team/2,
         join_in_team/3,
         leave_team/1,
         kick/2,
         get_ready/1,
         challenge_type/2,
         start_dungeon/1,
         chat/2]).

is_in_team() ->
    case get(?PLAYER_CUR_STATE) of
        {?PLAYER_STATE_IN_TEAM, TeamPid} ->
          case is_process_alive(TeamPid) of 
              true ->
                  {true, TeamPid};
              false ->
                  false
          end;
        _ ->
            false
    end.

put_team_state(Pid) when is_pid(Pid) ->
    put(?PLAYER_CUR_STATE, {?PLAYER_STATE_IN_TEAM, Pid});
put_team_state(Other) ->
    put(?PLAYER_CUR_STATE, Other).

create_team(ModPlayerState, DungeonId) ->
    case is_in_team() of
        {true, TeamPid} ->
            leave_team(TeamPid, ModPlayerState?PLAYER_ID);
        false ->
            skip
    end,
    create_team2(ModPlayerState, DungeonId).

create_team2(ModPlayerState, DungeonId) ->
    case lib_dungeon:check_dungeon(ModPlayerState, DungeonId) of
        {true, _, _} ->
            case mod_team:start(ModPlayerState#mod_player_state.player, DungeonId) of
                {ok, Pid} ->
                    case get_team(Pid) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, Team} ->
                            put_team_state(Pid),
                            {ok, ModPlayerState, Team}
                    end;
                _ ->
                    {fail, ?INFO_TEAM_CREATE_ERROR}
            end;
        Other ->
            Other
    end.

get_team() ->
    case is_in_team() of
        {true, Pid} ->
            get_team(Pid);
        false ->
            []
    end.

get_team(Pid) when is_pid(Pid) ->
    case erlang:is_process_alive(Pid) of
        true ->
            case catch mod_team:get_team_state(Pid) of
                {ok, Team} ->
                    {ok, Team};
                Err ->
                    ?WARNING_MSG("get_team error ~p~n", [Err]),
                    {fail, ?INFO_TEAM_GET_TEAM_ERROR}
            end;
        _ ->
            ?WARNING_MSG("team is not alive ~p~n", [Pid]),
            {fail, ?INFO_TEAM_NOT_EXIST}
    end.

invite_in_team(PlayerId, PlayerIdList) ->
    case is_in_team() of
        {true, TeamPid} ->
            mod_team:invite(TeamPid, PlayerId, PlayerIdList),
            ok;
        false ->
            {fail, ?INFO_TEAM_NOT_IN_TEAM}
    end.

join_in_team(ModPlayerState, TeamNum, DungeonId) ->
    case lib_dungeon:check_dungeon(ModPlayerState, DungeonId) of
        {true, _, _} ->
            case mod_team:in_team(ModPlayerState, TeamNum, DungeonId) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, Pid} ->                   
                    case is_in_team() of
                        false ->
                            skip;
                        {true, OldPid} ->
                            leave_team(OldPid)
                    end,
                    put_team_state(Pid),
                    ok;
                _ ->
                    {fail, ?INFO_TEAM_GET_TEAM_ERROR}
            end;
        Other ->
            Other
    end.

leave_team(PlayerId) ->
    case is_in_team() of
        {true, Pid} ->
            leave_team(Pid, PlayerId),
            put_team_state(undefined);
        _ ->
            skip
    end.

leave_team(Pid, PlayerId)
  when is_pid(Pid) ->
    mod_team:out_team(Pid, PlayerId);
leave_team(_, _) ->
    skip.

kick(PlayerId, Tid) ->
    if
        PlayerId =:= Tid ->
            {fail, ?INFO_TEAM_NO_KICK_MYSELF};
        true ->
            case is_in_team() of
                {true, Pid} ->
                    safe_run(fun() -> mod_team:kick(Pid, PlayerId, Tid) end);
                false ->
                    {fail, ?INFO_TEAM_NOT_IN_TEAM}
            end
    end.

get_ready(PlayerId) ->
    case is_in_team() of
        {true, Pid} ->
            safe_run(fun() -> mod_team:ready(Pid, PlayerId) end);
        false ->
            {fail, ?INFO_TEAM_NOT_IN_TEAM}
    end. 

challenge_type(PlayerId, Flag)
  when Flag =:= ?CHALLENGE_TYPE_ON orelse 
       Flag =:= ?CHALLENGE_TYPE_OFF ->
    case is_in_team() of
        {true, Pid} ->
            safe_run(fun() -> mod_team:challenge_type(Pid, PlayerId, Flag) end);
        false ->
            {fail, ?INFO_TEAM_NOT_IN_TEAM}
    end;
challenge_type(_, _) ->
    {fail, ?INFO_NOT_LEGAL_INT}.

safe_run(Fun) ->
    case catch apply(Fun, []) of
        {'EXIT', _} ->
            {fail, ?INFO_TEAM_NOT_EXIST};
        {fail, Reason} ->
            {fail, Reason};
        ok ->
            ok;
        What ->
            ?WARNING_MSG("ERROR ~p~n", [What]),
            {fail, ?INFO_TEAM_GET_TEAM_ERROR}
    end.

start_dungeon(ModPlayerState) ->
    case is_in_team() of
        {true, Pid} ->
            case catch mod_team:start_dungeon(Pid, ModPlayerState) of
                ok ->
                    ok;
                {single_dungeon, DungeonId, DungeonType} ->
                    put_team_state(undefined),
                    {single_dungeon, DungeonId, DungeonType};
                {fail, Reason} ->
                    {fail, Reason};
                Other ->
                    ?WARNING_MSG("ERROR ~p~n", [Other]),
                    {fail, ?INFO_TEAM_GET_TEAM_ERROR}
            end;
        false ->
            {fail, ?INFO_TEAM_NOT_IN_TEAM}
    end.

chat(ModPlayerState, Msg) ->
    case is_in_team() of
        {true, Pid} ->
            mod_team:chat(Pid, ModPlayerState?PLAYER_ID, Msg);
        false ->
            {fail, ?INFO_TEAM_NOT_IN_TEAM}
    end.


%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@moyou.me>
%%% @copyright (C) 2015, liu
%%% @doc
%%%
%%% @end
%%% Created :  2 Mar 2015 by liu <liuzhigang@moyou.me>
%%%-------------------------------------------------------------------
-module(lib_advance_reward).
-include("define_advance_reward.hrl").
-include("define_player.hrl").
-include("define_time.hrl").
-export([login/1,
         take_reward/1,
         save/1]).

%%登陆获取战力进步奖
login(PlayerId) ->
    case hdb:dirty_read(advance_reward, PlayerId, true) of
        [] ->
            dirty(#advance_reward{player_id = PlayerId,
                                  target_id = 1});
        Other ->
            Other
    end.

dirty(Advance) when is_record(Advance, advance_reward) ->
    hdb:dirty(Advance, #advance_reward.dirty);
dirty(Other) ->
    Other.

save(Advance) ->
    hdb:save(Advance, #advance_reward.dirty).

take_reward(#mod_player_state{player = Player,
                              advance_reward = 
                                  #advance_reward{target_id = TarId,
                                                  finish = Finish} = Advance} = ModPlayerState) ->
    if
        Finish =:= ?TAR_FINISH ->
            {fail, 0};
        true ->
            case date_base_advance_reward:get(TarId) of
                [] ->
                    {fail, 0};
                #base_advance_reward{battle_ability = Ability,
                                     reward = Reward,
                                     time = Time}
                  when Ability  =< Player#player.battle_ability ->
                    case lib_reward:take_reward(ModPlayerState, lib_reward:generate_reward_list(Reward), 0) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewModPlayerState} ->
                            NewAdvance = may_add_next(Advance),
                            {ok, NewModPlayerState#mod_player_state{advance_reward = dirty(NewAdvance)}}
                    end;
                _ ->
                    {fail, 0}
            end
    end.

take_reward2(#mod_player_state{player = Player} = ModPlayerState, Reward, Time) ->
    case time_misc:unixtime() - #player.create_timestamp =< Time*?ONE_HOUR_SECONDS of
        true ->
            ok;
        _ ->
            ok
    end.

may_add_next(#advance_reward{target_id = TarId} = Advance) ->
    Next = TarId + 1,
    case date_base_advance_reward:get(Next) of
        [] ->
            Advance#advance_reward{finish = ?TAR_FINISH};
        Next ->
            Advance#advance_reward{target_id = Next}
    end.

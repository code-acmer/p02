%%%-------------------------------------------------------------------
%%% @author Zhangr <zhangr011@gmail.com>
%%% @copyright (C) 2013, Zhangr
%%% @doc
%%%
%%% @end
%%% Created :  4 Nov 2013 by Zhangr <zhangr011@gmail.com>
%%%-------------------------------------------------------------------
-module(lib_relationship).

-include("define_task.hrl").
-include("define_logger.hrl").
-include("define_relationship.hrl").
-include("define_limit.hrl").
-include("define_info_14.hrl").
-include("define_info_12.hrl").
-include("define_info_13.hrl").
-include("define_cache.hrl").
-include("define_time.hrl").
-include("define_player.hrl").
-include("define_log.hrl").

%% API
-export([
         save/1,
         daily_reset/1,
         delete_friend/2,
         friend_deleted/3,
         get_unique_key/2,
         query_friend/2,
         request_friend/2,
         role_login/1
        ]).

%% 副本外部接口
-export([
         calc_friend_point/2,
         is_friend/2,
         can_help/2
        ]).
%% dev tool
-export([gm_delete_rel/1,
         gm_fix_all_player_friends_lim/0]).

%% 整体思路说明
%% relationship放着玩家自己可以处理的记录，比如添加确认，好友关系
%% relationship_tmp放着其他玩家自己待处理的记录，比如添加确认，删除好友关系，好友关系
%% 上线的时候玩家从tmp移到正常部分，只管复制过去，tmp加完之后超过的好友部分就超出
%% 关于上限限制是个不准确的判断，从mnesia取出player的friends_cnt和其上限来判断，因为tmp会有额外别人对你添加确认完成。
%% @doc relalist auto save
%% @spec
%% @end
save(RelaList) ->
    lists:map(fun(Rela) ->
                      hdb:save(Rela, #relationship.dirty)
              end, RelaList).

%% @doc 每日重置回调
daily_reset(RelaList) ->
    Current = time_misc:unixtime(),
    lists:map(fun(#relationship{as_cd = ACD,
                                fp_cd = FCD,
                                dirty = State} = Rela) 
                    when State =/= ?RECORD_STATE_DELETED andalso
                         (ACD > Current orelse FCD > Current) ->
                      %% 只有冷却中的记录才需要重置（已经删除的也不用处理了）
                      Rela#relationship{as_cd = Current,
                                        fp_cd = Current,
                                        dirty = ?RECORD_STATE_DIRTY};
                 (Rela) ->
                      Rela
              end, RelaList).

%% @end
get_unique_key(SID, TID) ->
    %% int64 max is 2 ^ 64 = 10 ^ 10
    SID * ?MAX_INT64_MOD_10 + TID.

%% @doc 计算好友友情值
%% @spec
%% @end
calc_friend_point(#player{
                     lv = SLv,
                     help_battle_id = TID
                    }, RelaList) ->
    case lists:keyfind(TID, #relationship.tid, RelaList) of
        false ->
            %% 好友关系都找不到了那么直接返回0
            {#help_battle{
                value = ?FRIEND_POINT_STRANGER,
                strangers_count = 1
               }, RelaList, null};
        #relationship{dirty = ?RECORD_STATE_DELETED} ->
            %% 已经删除的好友
            {#help_battle{
                value = ?FRIEND_POINT_STRANGER,
                strangers_count = 1
               }, RelaList, null};
        #relationship{fp_cd = FPCD,
                      as_cd = ASCD,
                      rela = ?RELATIONSHIP_FRIENDS} = Rela ->
            Now = time_misc:unixtime(),
            if
                ASCD > Now orelse FPCD > Now ->
                    %% 协助冷却中，无法获得奖励 或 友情点冷却中，获取不到
                    {#help_battle{
                        value = 0,
                        friend_count = 1
                       }, RelaList, null};
                true ->
                    %% 可以获取到好友值
                    TLv = lib_player:get_other_player_val(TID, #player.lv, SLv),
                    NewRela = 
                        Rela#relationship{
                          %% 添加协助和友情点冷却时间
                          fp_cd = Now + cal_fp_cd_seconds(SLv, TLv),
                          as_cd = Now + ?TWO_HOUR_SECONDS},
                    NewRelaList = 
                        lists:keyreplace(
                          TID, #relationship.tid, RelaList, NewRela),
                    {ok, Bin} = pt_14:write(14000, {[NewRela], []}),
                    {#help_battle{
                        value = ?FRIEND_POINT_FRIEND,
                        friend_count = 1
                       }, NewRelaList, Bin}
            end
    end.

%% 计算友情点获取冷却时间
cal_fp_cd_seconds(SLv, TLv) ->
    %% 等级差	时间间隔
    %% 0~5级（包括5级）	4hour
    %% 5~20级（包括20级）	6 hour
    %% 20+级	8 hour
    Diff = abs(SLv - TLv),
    if 
        Diff =< 5 ->
            ?FOUR_HOUR_SECONDS;
        Diff > 5 andalso Diff =< 20 ->
            ?SIX_HOUR_SECONDS;
        true ->
            ?EIGHT_HOUR_SECONDS
    end.

can_help(TID, RelaList) ->
    case lists:keyfind(TID, #relationship.tid, RelaList) of
        [] ->
            %% 好友关系都找不到了那么直接返回0
            {ok, pass};
        #relationship{
           as_cd = ASCD,
           rela = ?RELATIONSHIP_FRIENDS
          } ->
            Now = time_misc:unixtime(),
            if
                ASCD > Now ->
                    %% 协助冷却中，无法获得奖励
                    {fail, ?INFO_CANNOT_HELP};
                true ->
                    {ok, pass}
            end;
        _ ->
            {ok, pass}
    end.

%% @doc 删除好友
%% @spec
%% @end
delete_friend(TID, RelaList) -> 
    %% 清理掉缓存中的数据
    case lists:keytake(TID, #relationship.tid, RelaList) of
        false ->
            %% 未找到缓存数据
            {fail, ?INFO_FRIEND_NOT_EXIST};
        {value, #relationship{id = Id}, NewRelaList} ->
            hdb:dirty_delete(relationship, Id),
            lib_log_player:add_log(?LOG_EVENT_DEL_FRIEND, TID, 0),
            {ok, NewRelaList}
    end.

%% @doc 好友被删除了
%% @spec
%% @end
friend_deleted(SID, TID, RelaList) ->
    Uid = lib_relationship:get_unique_key(SID, TID),
    case lists:keyfind(Uid, #relationship.id, RelaList) of
        false ->
            RelaList;
        Rela ->
            lists:keyreplace(
              Uid, #relationship.id, RelaList,
              Rela#relationship{dirty = ?RECORD_STATE_DELETED})
    end.

%% @doc 查询好友信息
%% @spec
%% @end
query_friend(TID, Sn) ->
    case lib_player:get_other_player(TID, Sn) of
        [] ->
            {fail, ?INFO_FRIEND_NOT_EXIST};
        FriendPlayer ->
            {ok, FriendPlayer}
    end.

%% @doc 添加好友信息
%% @spec
%% @end
request_friend(#mod_player_state{player = #player{id = Tid}}, Tid) ->
    {fail, ?INFO_FRIEND_CAN_NOT_ADD_MYSELF};
request_friend(#mod_player_state{relationship = RelaList,
                                 player = Player} = ModPlayerState, Tid) ->
    case lists:keyfind(Tid, #relationship.tid, RelaList) of
        false ->
            case is_friend_cnt_full(Player) of
                true ->
                    {fail, ?INFO_FRIEND_MY_NUM_EXCEED};
                false ->
                    case request_friend2(Player#player.id, Tid, ModPlayerState?PLAYER_SN) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {Rela, TarPlayer} ->
                            NewFriendCnt = Player#player.friends_cnt + 1,
                            NewPlayer = Player#player{friends_cnt = NewFriendCnt},
                            %%不触发任务事件了，等客户端检测
                            %%mod_player:task_event(ModPlayerState?PLAYER_PID, {?TASK_FRIEND, NewFriendCnt}),
                            lib_log_player:add_log(?LOG_EVENT_ADD_FRIEND, Tid, 0),
                            {TarPlayer, 
                             ModPlayerState#mod_player_state{relationship = [Rela|RelaList],
                                                             player = NewPlayer}}
                    end;
                _ ->
                    {fail, ?INFO_FRIEND_DUPLICATED}
            end;
        _ ->
            {fail, ?INFO_FRIEND_DUPLICATED}
    end.

request_friend2(Sid, Tid, Sn) ->
    UKey = get_unique_key(Sid, Tid),
    case lib_player:get_other_player(Tid, Sn) of
        [] ->
            {fail, ?INFO_QUERY_OTHER_NOTFIND};
        Player ->
            case hdb:dirty_read(relationship, UKey) of
                [] ->
                    Rela = #relationship{id = UKey,
                                         sid = Sid,
                                         tid = Tid,
                                         rela = ?RELATIONSHIP_FRIENDS,
                                         time_form = time_misc:unixtime()},
                    {update(Rela), Player};
                _ ->
                    {fail, ?INFO_FRIEND_DUPLICATED} %%不应该发生的事情
            end
    end.
                  
update(Rela) ->
    hdb:dirty(Rela, #relationship.dirty).
%% @doc 登录时载入角色的所有关系数据
%% @spec
%% @end
role_login(PlayerId) ->
    hdb:dirty_index_read(relationship, PlayerId, #relationship.sid, true).

is_friend(RelaList, TID)->
    case lists:keyfind(TID, #relationship.tid, RelaList) of
        false -> 
            false;
        #relationship{rela = ?RELATIONSHIP_FRIENDS}->
            true; 
        _ -> 
            false
    end.
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================
is_friend_cnt_full(#player{
                      friends_cnt = FriendNum,
                      friends_limit = FriendNumLim,
                      friends_ext = FriendExt,
                      lv          = _Lv
                     }) ->
    %case Lv >= 20 of
       % true ->
            FriendNum >= (FriendNumLim + FriendExt).
      %  false ->
      %      {fail, ?INFO_FRIEND_FUNCTION_OFF}
  %  end.
            

gm_delete_rel(PlayerId) ->
    DelIdList = [Id || #relationship{id=Id} <- hdb:dirty_index_read(relationship, PlayerId, #relationship.sid)],
    hdb:dirty_delete_list(relationship, DelIdList).

gm_fix_all_player_friends_lim() ->
    FixFun = fun(#player{
                    lv = Lv
                   }=Player) ->
                     Player#player{
                       friends_limit = lib_player:get_base_player_val(Lv, #ets_base_player.friends)
                      }
             end,
    gm:fix_player_data(FixFun).


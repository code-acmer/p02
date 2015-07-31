-module(lib_g17_api).

-include("define_player.hrl").
-include("define_pay_info.hrl").
-include("common.hrl").
-export([
         get_role_info/2,
         pay_callback/8,
         get_active_users/3,
         guild_apply_reject_notify/1,
         guild_newbie_notify/1,
         quit_guild_notify/1
        ]).
%%
%% g17平台获取用户角色列表接口
%%
get_role_info(UserId, ServerId) ->
    StrUserId = hmisc:to_string(UserId),
    RoleList = hdb:dirty_index_read(player, StrUserId, #player.accid),
    ?DEBUG("StrUserId:~w, RoleList:~p~n",[StrUserId, RoleList]),
    lists:foldl(fun(Player, RET) ->
                        if
                            element(#player.sn, Player) =:= ServerId -> 
                                [{element(#player.id,Player),
                                  element(#player.nickname, Player),
                                  element(#player.lv, Player)}|RET];
                            true -> 
                                RET
                        end
                end, [], RoleList).

%%
%% @doc g17平台支付回调
%%
pay_callback(OrderId, OrderType, UserId, ServerId, Coin, Extra, Money, RoleId) ->
    case hdb:dirty_read(pay_info, OrderId) of
        [] ->
            case hdb:dirty_read(player, RoleId) of
                [] ->
                    {error, role_notfound};
                Player ->
                    PayInfo = #pay_info{order_id   = OrderId,
                                        order_type = OrderType,
                                        accid      = UserId,
                                        server_id  = ServerId,
                                        coin       = Coin,
                                        extra      = Extra,
                                        money      = Money,
                                        time       = hmisctime:unixtime(),
                                        player_id  = RoleId,
                                        status     = ?ORDER_STATUS_UNHANDLE,
                                        lv         = Player#player.lv
                                       },
                    hdb:dirty_write(pay_info, PayInfo),
                    mod_player:new_pay_info(RoleId),
                    ok
            end;
        _Info ->
            ?WARNING_MSG("repeated order pay_callbak order_id : ~w, accid:~p~n",[OrderId, UserId]),
            {error, error_aleady_pay}
    end.

%%
%% @doc G17平台获取活跃用户接口
%% 
get_active_users(Score, PageRowsNum, PageId) when PageId > 0 ->
    Count = hdb:count(g17_guild_member, [{live_ness, ">=", Score}, {guild_id, ">", 0}]),
    Limit = if
                PageId > 1 ->
                    {limit, (PageId-1) * PageRowsNum, PageRowsNum};
                PageId > 0 ->
                    {limit, PageRowsNum}
            end,

    AccIds = case hdb:select(g17_guild_member, [{live_ness, ">=", Score}, {guild_id, ">", 0}], [], Limit) of
                 [] ->
                     [];
                 Players  ->
                     lists:map(fun(Player) ->
                                       element(#player.accid, Player)
                               end, Players)
             end,
    {ok, Count, AccIds}.

%%
%% @doc g17平台大公会申请拒绝通知
%%
guild_apply_reject_notify(Rejects) ->
    lists:map(fun({UserId, GuildId}) ->
                      mod_g17_srv:update_g17_apply(reject, UserId, GuildId)
              end, Rejects),
    ok.


%%
%% @doc g17平台加入帮派通知
%%
guild_newbie_notify(NewMembers) ->
    lists:map(fun({UserId, GuildId}) ->
                      mod_g17_srv:newbie_join(hmisc:to_string(UserId), hmisc:to_integer(GuildId))
              end, NewMembers),
    ok.

%%
%% @doc g17平台 退出|被踢出 大公会通知
%%
quit_guild_notify(Notifies) ->
    lists:map(fun({UserId, GuildId}) ->
                      mod_g17_srv:quit_guild(hmisc:to_string(UserId), hmisc:to_integer(GuildId))
              end, Notifies),
    ok.

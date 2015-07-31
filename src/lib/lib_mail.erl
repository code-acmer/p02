-module(lib_mail).

-export([login/1,
         save/1,
         base_mail/2,
         base_mail/3,
         base_mail/4,
         mail/4,
         send_mail/2,
         recv_attachments/3,
         get_mails/2,
         to_mail_reward/1,
         daily_delete_mails/0]).

-include("define_mail.hrl").
-include("define_player.hrl").
-include("define_info_19.hrl").
-include("define_logger.hrl").
-include("define_money_cost.hrl").
-include("define_reward.hrl").
-include("define_goods_rec.hrl").
-include("define_goods.hrl").
-include("define_goods_type.hrl").

login(PlayerId) ->
    lib_operators_mail:login(PlayerId).

save(OperatorsMailList) ->
    lib_operators_mail:save(OperatorsMailList).

get_next_mails_id() ->
    lib_counter:update_counter(mails_uid).

%% 普通邮件模板
mail(SendName, Title, Content, Attachments) ->
    #mails{
       type = ?MAIL_TYPE_NORMAL,
       timestamp = time_misc:unixtime(),
       sname = SendName,
       title = Title,
       content = content(Content),
       attachment = Attachments
      }.

%% 游戏系统内部产生的所有邮件使用base_mail接口来构造mail
base_mail(BaseId, Args) ->
    base_mail(BaseId, Args, []).

base_mail(BaseId, Args, Attachments) ->
    base_mail(?SYSTEM_NAME, BaseId, Args, Attachments).

base_mail(SendName, BaseId, Args, Attachments) ->
    #mails{
       type = ?MAIL_TYPE_NORMAL,
       timestamp = time_misc:unixtime(),
       sname = SendName,
       base_id = BaseId,
       args = Args,       
       attachment = Attachments
      }.

%% 原则除了io_lib返回其他情况全binary
content(Bin) when is_binary(Bin) ->
    Bin;
content(LatinList) when is_list(LatinList)->
    %% io_lib返回
    list_to_binary(LatinList).

send_mail(PlayerId, Mail) when is_integer(PlayerId) ->
    case lib_player:check_player_is_exist(PlayerId) of
        true ->
            %mod_player:mail_notice(PlayerId),
            hdb:dirty_write(mails, Mail#mails{
                                     id = get_next_mails_id(),
                                     player_id = PlayerId
                                    });
        false ->
            ingore
    end;
send_mail(PlayerIdList, Mail) when is_list(PlayerIdList)->
    [send_mail(PlayerId, Mail) ||  PlayerId <- PlayerIdList].
    
recv_attachments(#mod_player_state{
                    bag = Bag,
                    player = Player
                   } = ModPlayerState, Id, ?MAIL_TYPE_NORMAL) ->
    BagCnt = Player#player.bag_cnt,
    BagLimit = Player#player.bag_limit,
    if
        BagLimit =< BagCnt ->
            {fail, ?INFO_FULL_OF_BAG};
        true ->
            case get_mail(ModPlayerState?PLAYER_ID, Id) of
                [] ->
                    {fail, ?INFO_MAIL_NOT_FOUND};
                #mails{
                   attachment = Attachments
                  } = Mail ->
                    send_change([], [Mail]),
                    {ok, NewModPlayerState} = 
                        case is_gift(Attachments, Player) of
                            false ->
                                lib_reward:take_reward(ModPlayerState, Attachments, ?INCOME_MAIL_ATTACHMENT);
                            {#goods{} = Goods, NPlayer} ->
                                ?DEBUG("Goods: ~p", [Goods]),
                                pt_15:pack_goods([Goods], [], []),
                                {ok, ModPlayerState#mod_player_state{
                                       bag = [Goods | Bag],
                                       player = NPlayer
                                      }}
                        end,
                    delete(Mail),
                    {ok, NewModPlayerState}
            end
    end.

is_gift([{?GOODS_TYPE_BGOLD, GoldNum}], #player{id = PlayerId} = Player) ->
    OwnGift = 
        lib_pay_gifts:rand_own_gift(GoldNum, PlayerId),
    {NOwnGift, NPlayer} = 
        lib_pay_gifts:first_login_get_gift(OwnGift, Player),
    GiftGoods = 
        lib_pay_gifts:own_gift_to_goods(NOwnGift),
    {GiftGoods, NPlayer};

is_gift(_, _) ->
    false.

send_change(UpdateMails, DeleteMails) ->
    {ok, Bin} = pt_19:write(19004, {UpdateMails, DeleteMails}),
    packet_misc:put_packet(Bin).

get_mail(PlayerId, Id) ->
    case hdb:dirty_read(mails, Id, true) of
        #mails{
           player_id = PlayerId
          } = Mail->
            Mail;
        _ ->
            []
    end.

delete(Mails)
  when is_list(Mails) ->
    [ delete(Mail) || Mail <- Mails];
delete(Mail) ->
    hdb:dirty_delete(mails, Mail#mails.id).

%% 做一个定时删除邮件的接口
daily_delete_mails() ->
    ?WARNING_MSG("DAILY DELETE JOB BEGIN ~n", []),
    KeyList = hdb:dirty_all_keys(mails),
    DeleteTime = time_misc:unixtime() - ?ONE_DAY_SECONDS * 30,
    lists:foreach(fun(Key) ->
                          case hdb:dirty_read(mails, Key) of
                              #mails{id = Id,
                                     timestamp = SendTimeStamp
                                    } when SendTimeStamp < DeleteTime ->
                                  hdb:dirty_delete(mails, Id);
                              _ ->
                                  skip
                          end
                  end, KeyList).
%%  获取邮件列表
%%  这里做了一个删除邮件的函数，其实是要等玩家上线才去删，如果一直不上线，邮件会越来越多
get_mails(#player{
             id = PlayerId             
            } = Player, OperatorsMailList) ->
    List = hdb:dirty_index_read(mails, PlayerId, #mails.player_id, true),
    Now = time_misc:unixtime(),
    SaveTimeFun = fun (?MAIL_STATE_READ) ->
                          ?MAIL_SAVE_TIME_READ;
                      (?MAIL_STATE_UNREAD) ->
                          ?MAIL_SAVE_TIME_UNREAD
                  end,
    TimeoutDelF = fun(#mails{
                         id = Id,
                         timestamp = SendTimeStamp,
                         state = State,
                         attachment = []
                        }) ->
                          case SaveTimeFun(State) + SendTimeStamp =< Now of
                              true ->
                                  hdb:dirty_delete(mails, Id),
                                  true;
                              false ->
                                  false
                          end;
                     (_) ->
                          false
                  end,
    %% Mails = lists:foldl(fun(Mail, Acc) ->
    %%                             case TimeoutDelF(Mail) of
    %%                                 true ->
    %%                                     Acc;
    %%                                 false ->
    %%                                     [add_base_text(Mail)|Acc]
    %%                             end                                
    %%                     end, [], List),
    Mails = 
        filter_timeout_mail(List, [], TimeoutDelF, 0),
    {OperatorsMailMails, NewOperatorsMailList} = lib_operators_mail:to_mail(Player, OperatorsMailList),    
    {OperatorsMailMails ++ Mails, NewOperatorsMailList}.

filter_timeout_mail([], AccMails, _FiterFun, _Count) ->
    AccMails;
filter_timeout_mail(_MailList, AccMails, _FiterFun, Count) when Count >= ?MAIL_MAX_CAPACITY -> %%防止邮件过多引起的问题
    AccMails;
filter_timeout_mail([Mail|Tail], AccMails, FiterFun, Count) ->
    case FiterFun(Mail) of
        true ->
            filter_timeout_mail(Tail, AccMails, FiterFun, Count);
        false ->
            filter_timeout_mail(Tail, [add_base_text(Mail)|AccMails], FiterFun, Count + 1)
    end.

add_base_text(#mails{
                 title = "",
                 base_id = BaseId,
                 type = ?MAIL_TYPE_NORMAL,
                 args = Args
                } = Mail) ->
    case data_base_mail:get(BaseId) of
        [] ->
            Mail#mails{
              title = <<"未导入标题"/utf8>>,
              content = <<"未导入内容"/utf8>>
             };
        #base_mail{
           title = Title,
           content = Content
          } ->
            Mail#mails{
              title = Title,
              content = if 
                            Args =:= [] ->
                                Content;
                            true ->
                                list_to_binary(io_lib:format(Content, Args))
                        end                    
             }
    end;
add_base_text(Mail) ->
    Mail.

to_mail_reward(RewardList) 
  when is_list(RewardList) ->
    lists:foldl(fun(Reward, AccReward) ->
                        to_mail_reward(Reward) ++ AccReward      
                end, [], RewardList);
to_mail_reward(#common_reward{goods_id = Id,
                              goods_sum = Sum}) ->
    [{Id, Sum}].

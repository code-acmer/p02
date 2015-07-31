%%%-------------------------------------------------------------------
%%% @author Zhangr <zhangr011@gmail.com>
%%% @copyright (C) 2013, Zhangr
%%% @doc
%%%
%%% @end
%%% Created : 26 Nov 2013 by Zhangr <zhangr011@gmail.com>
%%%-------------------------------------------------------------------
-module(lib_op).

%% API
-export([
         op_count/2,
         op_select/5,
         op_delete/2
        ]).

-include_lib("stdlib/include/qlc.hrl").
-include("define_logger.hrl").
-include("define_player.hrl").
-include("define_mail.hrl").
-include("define_mnesia.hrl").
-include("define_goods.hrl").

%%%===================================================================
%%% API
%%%===================================================================

op_count(player, []) ->
    mnesia:table_info(player, size);
op_count(player, {"online_flag",1}) ->
    {_, _, Num} = hdb:dirty_read(player_count, player_count),
    Num;
    %%gen_server:call(mod_monitor, cmd_query_player_count);
op_count(player, 
         {"timestamp_logout", {"$gt", STime, "$lt", ETime}}) ->
    MatchHead = #player{id = '$1', timestamp_logout = '$2', _ = '_'},
    GuardList = [{'>', '$2', STime}, {'<', '$2', ETime}],
    ResultList = ['$1'],
    mnesia:dirty_select(player, [{MatchHead, GuardList, ResultList}]);
op_count(mail, _) ->
    mnesia:table_info(mails, size);
op_count(goods, {"player_id", PlayerId}) ->
    case lib_player:get_other_player(PlayerId) of
        [] ->
            0;
        #player{
           bag_cnt = BagCnt
          } ->
            BagCnt
    end;
op_count(Table, Param) ->
    ?WARNING_MSG("not match op_count(~p, ~p)~n", [Table, Param]),
    [].

op_select(player, 
          {"online_flag",1}, 
          null,
          {"lv",-1,"exp",-1,"id",-1},
          {"start",Start,"limit",Limit}) ->
    Fun = 
        fun() ->
                Query = qlc:q([Player || Player <- mnesia:table(player),
                                         Player#player.online_flag == 1]),
                Q2 = qlc:keysort(#player.lv, Query),
                inner_qlc_with_limit(Q2, Start, Limit)    
        end,
    ResultList = mnesia:activity(async_dirty, Fun),
    inner_encode_player_list(ResultList);
op_select(player, 
          {"online_flag",1}, 
          null,
          {"lv",-1,"exp",-1,"id",-1},
          Limit) ->
    op_select(player, {"online_flag",1}, null, {"lv",-1,"exp",-1,"id",-1},
              inner_make_limit(Limit));
op_select(player, [], null, {"id",-1}, {"start",Start,"limit",Limit}) ->
    Fun = 
        fun() ->
                Query = qlc:q([Player || Player <- mnesia:table(player)]),
                Q2 = qlc:keysort(#player.id, Query),
                inner_qlc_with_limit(Q2, Start, Limit)
        end,
    ResultList = mnesia:activity(async_dirty, Fun),
    inner_encode_player_list(ResultList);
op_select(player, [], null, {"id",-1}, Limit) ->
    op_select(player, [], null, {"id",-1}, inner_make_limit(Limit));
op_select(node_status, null, null, null, _) ->
    ResultList = table_to_list(node_status),
    inner_encode_node_status_list(ResultList);
op_select(player, {"accid", AccId}, _, _, _) ->
    Player = hdb:dirty_index_read(player, AccId, #player.accid),
    ?DEBUG("~p~n", [Player]),
    inner_encode_player_list(Player);
op_select(player, WhereList, null, _, _) ->
    WhereProplist = to_proplists(WhereList),
    ?DEBUG("WhereProplist ~p~n", [WhereProplist]),
    FindPlayer = fun
                     %% player_id, nickname, accname
                     (undefined, undefined, undefined) ->
                         [];
                     (undefined, undefined, {_, AccName}) ->
                         hdb:dirty_index_read(player, AccName, #player.accname);
                     (undefined, {_, Nickname}, _) ->
                         hdb:dirty_index_read(player, Nickname, #player.nickname);
                     (PlayerId, _, _) 
                       when PlayerId =/= undefined->
                         case lib_player:get_other_player(PlayerId) of
                             [] ->
                                 [];
                             Player ->
                                 [Player]
                         end;
                     (PlayerId, Nickname, AccName) ->
                         ?WARNING_MSG("PlayerId ~w, Nickname ~w, AccName ~w~n", [PlayerId, Nickname, AccName]),
                         []
                 end,
    Player = FindPlayer(proplists:get_value("id", WhereProplist),
                        proplists:get_value("nickname", WhereProplist),
                        proplists:get_value("accname", WhereProplist)),
    ?DEBUG("Player ~w~n", [Player]),
    inner_encode_player_list(Player);


op_select(mail, _, null, {"id","-1"}, {"start",Start,"limit",Limit}) ->
    Fun = 
        fun() ->
                Query = qlc:q([Mail || Mail <- mnesia:table(mails)]),
                Q2 = qlc:keysort(#mails.id, Query),
                inner_qlc_with_limit(Q2, Start, Limit)
        end,
    ResultList = mnesia:activity(async_dirty, Fun),
    inner_encode_mail_list(ResultList);
op_select(goods, {"player_id", PlayerId}, null, _, {"start",Start,"limit",Limit}) ->
    #player_goods{
       goods_list = GoodsList
      } = lib_goods:db_get_player_goods_list(PlayerId),
    SortList = lists:keysort(#goods.id, GoodsList),
    ReturnList = lists:sublist(SortList, fix_start(Start), Limit),
    inner_encode_list_help(ReturnList, record_info(fields, goods));
op_select(Param1, Param2, Param3, Param4, Param5) ->
    ?WARNING_MSG("not matched op_select(~p, ~p, ~p, ~p, ~p)~n", 
                 [Param1, Param2, Param3, Param4, Param5]),
    [].

op_delete(mail, {"id", MailId}) ->
    hdb:dirty_delete(mails, MailId),
    [];
op_delete(Parm1, Parm2) ->
    ?WARNING_MSG("not match op_delete(~p, ~p)~n",[Parm1,Parm2]),
    [].

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================

inner_qlc_with_limit(Query, Start, Limit) ->
    QC = qlc:cursor(Query),
    ResultList =
        if
            Start =< 0 ->
                qlc:next_answers(QC, Limit);
            true ->
                qlc:next_answers(QC, Start - 1),
                qlc:next_answers(QC, Limit)
        end,
    qlc:delete_cursor(QC),
    ResultList.

inner_encode_player_list(ResultList) ->
    mochijson:encode(
      {array,
       lists:map(
         fun(Res) ->
                 {LastDungeon, _} = Res#player.last_dungeon,
                 NewPlayer = 
                     Res#player{
                       nickname = Res#player.nickname,
                       %% last_dungeon = LastDungeon,
                       %% normal_skill_ids = hmisc:term_to_string(Res#player.normal_skill_ids),
                       dungeon_reward = 0},
                 [player | Tail] = tuple_to_list(NewPlayer),
                 {struct, 
                  lists:zipwith(
                    fun(Key, Value) ->
                            {Key, std_fromat(Value)}
                    end,
                    record_info(fields, player),
                    Tail)}
         end, ResultList)}).

inner_encode_node_status_list(ResultList) ->
    mochijson:encode(
      {array,
       lists:map(
         fun(Res) ->
                 [node_status | Tail] = tuple_to_list(Res),
                 {struct, 
                  lists:zipwith(
                    fun(Key, Value) ->
                            {Key, Value}
                    end, 
                    record_info(fields, node_status),
                    Tail)}
         end, ResultList)}).

inner_encode_mail_list(ResultList) ->
    mochijson:encode(
      {array,
       lists:map(
         fun(Res) ->
                 %% TestName = hmisc:to_binary(unicode:binary_to_characters(hmisc:to_binary(Res#mails.sname))),
                 %% ?WARNING_MSG("hmisc:to_binary(Res#mails.sname) : ~w~n",[hmisc:to_binary(Res#mails.title)]),
                 %% ?WARNING_MSG("unicode:binary_to_characters(hmisc:to_binary(Res#mails.sname)):~w~n",[unicode:characters_to_list(hmisc:to_binary(Res#mails.title))]),
                 %% ?WARNING_MSG("hmisc:to_binary(unicode:binary_to_characters(hmisc:to_binary(Res#mails.sname))):~w~n",[hmisc:to_binary(unicode:characters_to_list(hmisc:to_binary(Res#mails.title)))]),
                 NewMail = Res#mails{
                             sname = hmisc:to_binary(Res#mails.sname),
                             title = hmisc:to_binary(Res#mails.title)
                            },
                 [mails | Tail] = tuple_to_list(NewMail),
                 {struct, 
                  lists:zipwith(
                    fun(Key, Value) ->
                            {Key, std_fromat(Value)}
                    end, 
                    record_info(fields, mails),
                    Tail)}
         end, ResultList)}).

inner_make_limit(Limit)
  when is_integer(Limit) ->
    {"start",0,"limit",Limit};
inner_make_limit({"start",Start,"limit",Limit}) ->
    {"start",Start,"limit",Limit};
inner_make_limit(_Limit) ->
    {"start",0,"limit",1}.


std_fromat(Value) when is_binary(Value) ->
    Value;
std_fromat(Value) ->
    hmisc:term_to_string(Value).

inner_encode_list_help(ResultList, Fields) ->
    mochijson:encode(
      {array,
       lists:map(
         fun(Res) ->
                 [_ | Tail] = tuple_to_list(Res),
                 {
                   struct, 
                   lists:zip(Fields, Tail)
                 }
         end, ResultList)}).

fix_start(-1) ->
    1;
fix_start(0) ->
    1;
fix_start(Start) ->
    Start.

%% 填坑，只支持一层
to_proplists(Tuple) 
  when is_tuple(Tuple)->
    List = tuple_to_list(Tuple),
    to_proplists(List);
to_proplists([K, V | List]) ->
    [{K, V} | to_proplists(List)];
to_proplists(Other) ->
    ?WARNING_MSG("~w~n", [Other]),
    [].

    
                        
table_to_list(TableName) ->
    Fun = fun() ->
                  mnesia:foldl(fun(R, RET) ->
                                       [R|RET]
                               end, [], TableName)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

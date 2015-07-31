-module(lib_league).
-export([create_league/3,
         update_league_data/0,
         add_league/3,
         kick_league_member/2,
         get_my_league/1,
         league_name_title/2,
         league_name_title_new/2,
         get_league_member/1,
         appoint_member/3,
         leave_league/1,
         change_league_declaration/2,
         get_write_table_with_dbsn/1,
         get_league_list/3,
         change_league_join_ability/2,
         create_g17_guild/2,
         apply_g17_guild/2,
         follow_join_g17_guild/1,
         quit_g17_guild/1,
         force_quit_league/1,
         get_g17_guild_list/0,
         get_my_g17_guild/1,
         get_league_list/1,
         get_g17_guild_member/1,
         get_last_timestamp/0,
         get_apply_status/2,
         get_g17_guild_info/1,
         do_after_join_g17_guild/3,
         do_quit_join_g17_guild/2,
         get_g17_league_list/2,
         get_league_member_list/1,
         get_league_info/2,
         update_league/2,
         get_league_member_by_id/1,
         update_league_member/1
        ]).

-export([test/1,
         test_match/0]).

-include("define_league.hrl").
-include("define_info_40.hrl").
-include("define_player.hrl").
-include("define_money_cost.hrl").
-include("define_goods_type.hrl").
-include("define_logger.hrl").
-include("define_time.hrl").
-include_lib("stdlib/include/qlc.hrl").
-include_lib("g17/include/g17.hrl").
-include("define_g17_guild.hrl").
-include("db_base_guild_lv_exp.hrl").

test(Count) ->
    [do_test(Num) || Num <- lists:seq(1, Count)],
    ok.

do_test(Num) ->
    NumBin = integer_to_binary(Num),
    Name = <<"机器人假工会"/utf8, NumBin/binary>>,
    Table = get_write_table(1),
    League = 
        #league{id = next_league_id(),
                name = Name,
                cur_num = 0,
                max_num = ?LEAGUE_MAX_NUM,
                ability_sum = 0,
                declaration = <<"机器人假工会"/utf8>>,
                president = <<"没有会长哦"/utf8>>,
                rank = cache_misc:update_counter(rank_key(Table), 1)},
    hdb:dirty_write(Table, League).

test_match() ->
    F = fun() ->
                MatchHead = #league{id = '$1', rank = '$2', _ = '_'},
                Guard = [{'>', '$2', 50000}],
                Result = ['$1'],
                mnesia:dirty_select(league_1, [{MatchHead, Guard, Result}])
        end,
    F2 = fun() ->
                MatchHead = #league{id = '$1', rank = '$2', _ = '_'},
                Guard = [{'>', '$2', 50000}],
                Result = ['$1'],
                mnesia:select(league_1, [{MatchHead, Guard, Result}], 10, read)
         end,
    F3 = fun() ->
                 MatchHead = #league{id = '$1', rank = '$2', _ = '_'},
                 Guard = [{'>', '$2', 50000}],
                 Result = [['$1', '$2']],
                 mnesia:select(league_1, [{MatchHead, Guard, Result}], 10, read)
         end,
    F4 = fun() ->
                 QH = qlc:q([{X#league.id, X#league.rank}
                             || X <- mnesia:table(league_1), X#league.rank > 50000]),
                 QH1 = qlc:sort(QH, [{order, ascending}]),
                 QC = qlc:cursor(QH1),
                 qlc:next_answers(QC, 10)
         end,
    {Time, Result} = timer:tc(F),
    ?PRINT("F1 cost ~p microseconds length ~p~n", [Time, length(Result)]),
    {Time2, {atomic, {Result2, _Cont}}} = timer:tc(fun() -> mnesia:transaction(F2) end),
    ?PRINT("F2 cost ~p microseconds length ~p ~n", [Time2, length(Result2)]),
    {Time3, {Result3, _}} = timer:tc(fun() -> mnesia:async_dirty(F3, []) end),
    ?PRINT("F3 cost ~p microseconds length ~p ~n", [Time3, length(Result3)]),
    {Time4, {atomic, Result4}} = timer:tc(fun() -> mnesia:transaction(F4) end),
    ?PRINT("F4 cost ~p microseconds length ~p ~n", [Time4, length(Result4)]),
    ?PRINT("Result2 ~p, Result3 ~p, Result4 ~p~n", [Result2, Result3, Result4]).

get_league_list(Sn, LastRank, Type) 
  when is_integer(Sn), is_integer(LastRank), is_integer(Type) ->
    case catch mod_league_cache:get_data(Sn, LastRank, Type) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, LeagueList, Size} ->
            ?DEBUG("LeagueList ~p~n", [LeagueList]),
            {LeagueList, Size};
        Other ->
            ?WARNING_MSG("get league data error Reason ~p~n", [Other]),
            {fail, ?INFO_SERVER_DATA_ERROR}
    end.

%%定时做工会数据的更新，主要是该死的战斗力总和,然后维护一下工会排名。
%%由mod_timer调用，每天一次，不要频繁调用。
update_league_data() ->
    SnList = server_misc:mnesia_sn_list(),
    lists:foreach(fun(DbSn) ->
                          Table = list_to_atom(lists:concat([league, "_", DbSn])),
                          AllLeagueId = hdb:dirty_all_keys(Table),
                          [hdb:dirty_read(Table, LeagueId, true)|| LeagueId <- AllLeagueId],
                          LeagueInfo = [get_league_info(LeagueId) || LeagueId <- AllLeagueId],
                          SortLeagueInfo = lists:reverse(lists:keysort(2, LeagueInfo)),
                          LeagueCount = update_league_info(Table, SortLeagueInfo) - 1,
                          cache_misc:set(rank_key(Table), LeagueCount, infinity),
                          mod_league_cache:sync_data_with_dbsn(DbSn)
                  end, SnList).

update_league_info(Table, SortLeagueInfo) ->
    UpdateFun = fun(LeagueId, AllAbility, Rank) ->
                        case mnesia:read(Table, LeagueId) of
                            [] ->
                                skip;
                            [League] ->
                                mnesia:write(Table, League#league{ability_sum = AllAbility,
                                                                  rank = Rank,
                                                                  league_gifts_num = 0
                                                                 }, write)
                        end
                end,
    lists:foldl(fun({LeagueId, Ability}, AccNum) ->
                        hdb:transaction(fun() -> UpdateFun(LeagueId, Ability, AccNum) end),
                        AccNum + 1
                end, 1, SortLeagueInfo).

rank_key(Table) ->
    {league_count, Table}.

get_league_info(LeagueId) ->
    MemberList = hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id, true),
    AllAbility = 
        lists:foldl(fun(#league_member{player_id = PlayerId}, AccAbility) ->
                            case hdb:dirty_read(player, PlayerId, true) of
                                [] ->
                                    ?WARNING_MSG("PlayerId not found ~p~n", [PlayerId]),
                                   AccAbility;
                                Player ->
                                    AccAbility + Player#player.battle_ability
                            end
                    end, 0, MemberList),
    {LeagueId, AllAbility}.

%%创建工会
create_league(#mod_player_state{player = Player} = ModPlayerState, Name, Decration) ->
    if
        length(Name) > ?LEAGUE_MAX_LEAGUE_NAME_LENGTH ->
            {fail, ?INFO_LEAGUE_LONG_NAME};
        length(Decration) > ?LEAGUE_MAX_LEAGUE_DECRA_LENGTH ->
            {fail, ?INFO_LEAGUE_LONG_DER};
        true ->
            NameBin = unicode:characters_to_binary(Name),
            case check_create_league(Player, NameBin) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewPlayer} ->
                    DbSn = server_misc:get_mnesia_sn(Player#player.sn),
                    Table = list_to_atom(lists:concat([league, "_", DbSn])),
                    LeagueId = next_league_id(),
                    ?DEBUG("LeagueId ~p~n", [LeagueId]),
                    Rank = cache_misc:update_counter(rank_key(Table), 1),
                    G17InfoLeague = case get_g17_guild_member(Player#player.accid) of
                                        [] ->
                                            #league{};
                                        #g17_guild_member{
                                           guild_id = GuildId
                                          } ->
                                            case get_g17_guild_info(GuildId) of
                                                #g17_guild{
                                                   guild_name = GuildName
                                                  } ->
                                                    #league{g17_guild_id = GuildId,
                                                            g17_guild_name = GuildName
                                                           };
                                                _ ->    
                                                    #league{
                                                       g17_guild_id = GuildId
                                                      }
                                            end
                                        end,
                    League = G17InfoLeague#league{id = LeagueId,
                                                  name = NameBin,
                                                  cur_num = 1,
                                                  max_num = ?LEAGUE_MAX_NUM,
                                                  ability_sum = Player#player.battle_ability,
                                                  declaration = sensitive_word_misc:sensitive_word_filter(unicode:characters_to_binary(Decration)),
                                                  president = Player#player.nickname,
                                                  rank = Rank},
                    LeagueMember = 
                        #league_member{player_id = Player#player.id,
                                       league_id = LeagueId,
                                       title = ?LEAGUE_TITLE_BOSS,
                                       player_name = Player#player.nickname
                                      },
                    hdb:dirty_write(Table, League),
                    hdb:dirty_write(league_member, LeagueMember),
                    ?DEBUG("create league ok ~n", []),
                    mod_league_cache:update_league(Player#player.sn, League),
                    {ok, ModPlayerState#mod_player_state{player = NewPlayer}}
            end
    end.

check_create_league(#player{id = PlayerId,
                            lv = Lv} = Player, NameBin) ->
    case sensitive_word_misc:is_sensitive_word(NameBin) of
        false ->
            case hdb:dirty_read(league_member, PlayerId) of
                [] ->
                    if
                        Lv >= ?CREATE_LEAGUE_MIN_LV ->  %%暂定
                            lib_player:cost_money(Player, ?CREATE_LEAGUE_COST_GOLD, ?GOODS_TYPE_GOLD, ?COST_CREATE_LEAGUE);
                        true ->
                            {fail, ?INFO_LEAGUE_CREATE_LEVEL_LIMIT}
                    end;
                _ ->
                    {fail, ?INFO_LEAGUE_IN_LEAGUE}
            end;
        _ ->
            {fail, ?INFO_LEAGUE_LIMIT_NAME}
    end.

next_league_id() ->
    lib_counter:update_counter(league_uid).

%%加入工会
add_league(#mod_player_state{player = #player{last_add_league_time = LastTime} = Player} = ModPlayerState, LeagueId, AddType) ->
    Now = time_misc:unixtime(),
    if
        %% 暂时屏蔽
        Now - LastTime < ?ONE_DAY_SECONDS ->
            {fail, ?INFO_LEAGUE_ADD_LEAGUE_LIMIT};
        true ->
            case hdb:dirty_read(league_member, Player#player.id) of
                [] ->
                    case get_g17_guild_member(Player#player.accid) of
                        [] ->
                            case add_league2(Player, LeagueId, AddType) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                _ ->
                                    follow_join_g17_guild(Player),
                                    {ok, ModPlayerState#mod_player_state{player = Player#player{last_add_league_time = Now}}}
                            end;
                        #g17_guild_member{
                           guild_id = G17GuildId
                          } ->
                            case get_league_info(LeagueId, Player#player.sn) of
                                [] ->
                                    {fail, ?INFO_UNKNOWN};
                                #league{
                                   g17_guild_id = G17GuildId
                                  } ->
                                    case add_league2(Player, LeagueId, AddType) of
                                        {fail, Reason} ->
                                            {fail, Reason};
                                        _ ->
                                            {ok, ModPlayerState#mod_player_state{player = Player#player{last_add_league_time = Now}}}
                                    end;
                                _ ->
                                    {fail, ?INFO_G17_GUILD_JOIN_NOT_SAME}
                            end
                    end;
                _ ->
                    {fail, ?INFO_LEAGUE_IN_LEAGUE}
            end
    end. 

add_league2(Player, LeagueId, AddType) ->
    DbSn = server_misc:get_mnesia_sn(Player#player.sn),
    Table = list_to_atom(lists:concat([league, "_", DbSn])),
    Ability = Player#player.battle_ability,
    LeagueMember = 
        #league_member{player_id = Player#player.id,
                       league_id = LeagueId,
                       player_name = Player#player.nickname
                      },
    AddFun = 
        fun() ->
               case mnesia:read(Table, LeagueId) of
                   [] ->
                       {fail, ?INFO_CONF_ERR};
                   [#league{join_ability = NeedAbility,
                            max_num = Max,
                            cur_num = CurNum,
                            ability_sum = AbilitySum
                           } = League] ->
                       if
                           Ability < NeedAbility andalso AddType =:= ?LEAGUE_NOT_INVITE ->
                               {fail, ?INFO_LEAGUE_ADD_ABILITY_LIMIT};
                           CurNum >= Max ->
                               {fail, ?INFO_LEAGUE_ADD_NUM_LIMIT};
                           true ->
                               NewLeague = 
                                   League#league{cur_num = CurNum + 1,
                                                 ability_sum = AbilitySum + Ability},
                               mnesia:write(Table, NewLeague, write),
                               mnesia:write(league_member, LeagueMember, write)
                       end
               end
        end,
    hdb:transaction(AddFun).

get_write_table(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    list_to_atom(lists:concat([league, "_", DbSn])).

get_write_table_with_dbsn(DbSn) ->
    list_to_atom(lists:concat([league, "_", DbSn])).

%%踢出工会(少数人的操作)
kick_league_member(#mod_player_state{player = #player{id = PlayerId}}, PlayerId) ->
    {fail, ?INFO_LEAGUE_TAR_SELF};
kick_league_member(ModPlayerState, TarId) ->
    Table = get_write_table(ModPlayerState?PLAYER_SN),
    case hdb:dirty_read(league_member, ModPlayerState?PLAYER_ID) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{title = Title,
                       league_id = LeagueId} when Title =:= ?LEAGUE_TITLE_BOSS ->
            case hdb:dirty_read(league_member, TarId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #league_member{title = TarTitle,
                               league_id = LeagueId} ->
                    case check_title(Title, TarTitle) of
                        false ->
                            {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER};
                        true ->
                            kick_league_member2(Table, LeagueId, TarId)
                    end;
                _ ->
                    {fail, ?INFO_CONF_ERR}
            end;
        _ ->
            {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER}
    end.

kick_league_member2(Table, LeagueId, TarId) ->                 
    KickFun =
        fun() ->
                case mnesia:read(Table, LeagueId) of
                    [] ->
                        {fail, ?INFO_CONF_ERR};
                    [#league{cur_num = CurNum} = League] ->
                        case mnesia:read(league_member, TarId) of
                            [] ->
                                {fail, ?INFO_CONF_ERR};
                            _ ->
                                mnesia:delete({league_member, TarId}),
                                mnesia:write(Table, League#league{cur_num = CurNum - 1}, write)
                        end
                end
        end,
    hdb:transaction(KickFun).

check_title(T1, T2) ->
    title_power(T1) > title_power(T2).

title_power(?LEAGUE_TITLE_BOSS) ->
    100;
title_power(?LEAGUE_TITLE_DEPUTY_BOSS) ->
    90;
title_power(?LEAGUE_TITLE_OFFICIAL) ->
    80;
title_power(?LEAGUE_TITLE_ELITE) ->
    10;
title_power(?LEAGUE_TITLE_MEMBER) ->
    10;
title_power(_) ->
    0.

check_title_count(LeagueId, ?LEAGUE_TITLE_DEPUTY_BOSS) ->
    case hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id) of
        [] ->
            true;
        List ->
            Count = length(list_misc:list_match([{#league_member.title, ?LEAGUE_TITLE_DEPUTY_BOSS}], List)),
            Count < ?MAX_COUNT_DEPUTY_BOSS
    end; 
check_title_count(LeagueId, ?LEAGUE_TITLE_OFFICIAL) ->
    case hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id) of
        [] ->
            true;
        List ->
            Count = length(list_misc:list_match([{#league_member.title, ?LEAGUE_TITLE_DEPUTY_BOSS}], List)),
            Count < ?MAX_COUNT_OFFICIAL
    end; 
check_title_count(_, _) ->
    true.

league_name_title(PlayerId, Sn) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            [];
        #league_member{league_id = LeagueId,
                       title = Title} ->
            case hdb:dirty_read(get_write_table(Sn), LeagueId) of
                [] ->
                    [];
                #league{name = Name} ->
                    {Name, Title}
            end
    end.

league_name_title_new(PlayerId, Sn) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            [];
        #league_member{league_id = LeagueId,
                       title = Title} ->
            case hdb:dirty_read(get_write_table(Sn), LeagueId) of
                [] ->
                    [];
                #league{name = Name} ->
                    {LeagueId, Name, Title}
            end
    end.

%% get_my_league(ModPlayerState) ->
%%     case hdb:dirty_read(league_member, ModPlayerState?PLAYER_ID) of
%%         [] ->
%%             [];
%%         #league_member{league_id = LeagueId} ->
%%             case hdb:dirty_read(get_write_table(ModPlayerState?PLAYER_SN), LeagueId) of
%%                 [] ->
%%                     {fail, ?INFO_CONF_ERR};
%%                 League ->
%%                     League
%%             end
%%     end.

get_my_league(#mod_player_state{} = ModPlayerState) ->
    get_my_league(ModPlayerState?PLAYER_ID, ModPlayerState?PLAYER_SN);

get_my_league(#player{id = PlayerId, sn = PlayerSn}) ->
    get_my_league(PlayerId, PlayerSn).

get_my_league(PlayerId, PlayerSn) ->
    case get_league_member_by_id(PlayerId) of
        [] ->
            [];
        #league_member{
           league_id = LeagueId
          } ->
            case get_league_info(LeagueId, PlayerSn) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                League ->
                    League
            end
    end.
get_league_info(LeagueId, Sn) ->
    hdb:dirty_read(get_write_table(Sn), LeagueId).

update_league(League, Sn) ->
    hdb:dirty_write(get_write_table(Sn), League).

update_league_member(LeagueMember) ->
    hdb:dirty_write(league_member, LeagueMember).

get_league_member_by_id(PlayerId) ->
    hdb:dirty_read(league_member, PlayerId).

get_league_member(ModPlayerState) when is_record(ModPlayerState, mod_player_state) ->
    %% case hdb:dirty_read(league_member, ModPlayerState?PLAYER_ID) of
    %%     [] ->
    %%         [];
    %%     #league_member{league_id = LeagueId} ->
    %%         hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id)
    %% end;
    get_league_member(ModPlayerState?PLAYER_ID);
get_league_member(PlayerId) when is_integer(PlayerId) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            [];
        #league_member{league_id = LeagueId} ->
            %% hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id)
            get_league_member_list(LeagueId)
    end.

get_league_member_list(LeagueId) ->
    hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id, true).


appoint_member(#player{id = PlayerId}, PlayerId, _) ->
    {fail, ?INFO_LEAGUE_TAR_SELF};
appoint_member(#player{id = PlayerId, sn = _Sn}, TarId, Title) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId,
                       title = OTitle} = _OMember ->
            case check_appoint(OTitle, Title, LeagueId) of
                true ->
                    %LeagueTable = get_write_table(Sn),
                        Fun = fun() ->
                                 case mnesia:read(league_member, TarId) of
                                     [#league_member{league_id = LeagueId,
                                                     title = TarTitle} = TarMember] ->
                                         P1 = title_power(TarTitle),
                                         P2 = title_power(OTitle),
                                         if
                                             P1 >= P2 ->
                                                 {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER};
                                             %%会长暂时不想支持转交功能，有需要再说
                                             %% Title =:= ?LEAGUE_TITLE_BOSS ->
                                             %%     case mnesia:read(LeagueTable, LeagueId) of
                                             %%         [] ->
                                             %%             {fail, ?INFO_CONF_ERR};
                                             %%         [League] ->
                                             %%             case hdb:dirty_read(player, TarId) of
                                             %%                 #player{nickname = NickName} ->
                                             %%                     mnesia:write(LeagueTable, League#league{president = NickName}, write),
                                             %%                     mnesia:write(league_member, TarMember#league_member{title = Title}, write),
                                             %%                     mnesia:write(league_member, OMember#league_member{title = ?LEAGUE_TITLE_MEMBER}, write);
                                             %%                 _ ->
                                             %%                     {fail, ?INFO_CONF_ERR}
                                             %%             end
                                             %%     end;
                                             true ->
                                                 mnesia:write(league_member, TarMember#league_member{title = Title}, write)
                                         end;
                                     _ ->
                                         {fail, ?INFO_LEAGUE_TAGET_INFO_CHANGE}
                                 end
                         end,
                    hdb:transaction(Fun);
                Other ->
                    Other
            end
    end.

check_appoint(?LEAGUE_TITLE_BOSS, Title, LeagueId) ->
    check_appoint2(?LEAGUE_TITLE_BOSS, Title, LeagueId);
check_appoint(?LEAGUE_TITLE_DEPUTY_BOSS, Title, LeagueId) ->
    check_appoint2(?LEAGUE_TITLE_DEPUTY_BOSS, Title, LeagueId);
check_appoint(?LEAGUE_TITLE_OFFICIAL, Title, LeagueId) ->
    check_appoint2(?LEAGUE_TITLE_OFFICIAL, Title, LeagueId);
check_appoint(_, _, _) ->
    {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER}.

check_appoint2(OTitle, Title, LeagueId) ->
    case {check_title(OTitle, Title), check_title_count(LeagueId, Title)} of
        {true, true} ->
            true;
        {false, _} ->
            {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER};
        {_, false} ->
            {fail, ?INFO_LEAGUE_TITLE_FULL}
    end.


leave_league(#player{id = Id,
                     sn = Sn}) ->
    Table = get_write_table(Sn),
    LeaveFun =
        fun() ->
                case mnesia:read(league_member, Id) of
                    [] ->
                        {fail, ?INFO_LEAGUE_NOT_MEMBER};
                    [#league_member{league_id = LeagueId,
                                    title = Title} = Self] ->
                        if
                            Title =:= ?LEAGUE_TITLE_BOSS ->
                                case hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id) of
                                    [Self] ->
                                        case hdb:dirty_read(Table, LeagueId) of
                                            [] ->
                                                {fail, ?INFO_CONF_ERR};
                                            #league{rank = Rank} ->
                                                mnesia:delete({league_member, Id}),
                                                mnesia:delete({Table, LeagueId}),
                                                {delete, Rank}
                                        end;
                                    _ ->
                                        {fail, ?INFO_LEAGUE_BOSS_CANNOT_LEAVE}
                                end;
                            true ->
                                case mnesia:read(Table, LeagueId) of
                                    [] ->
                                        {fail, ?INFO_CONF_ERR};
                                    [#league{cur_num = CurNum} = League] ->
                                        mnesia:delete({league_member, Id}),
                                        mnesia:write(Table, League#league{cur_num = CurNum - 1}, write)
                                end
                        end
                end
        end,
    case hdb:transaction(LeaveFun) of
        {delete, Rank} ->
            mod_league_cache:delete_league(Sn, Rank),
            ok;
        Other ->
            Other
    end.

%% 强制退出军团，如果是成员直接退出，如果是帮主在军团人数大于2时转让军团长，否则直接解散军团
force_quit_league(#player{id = PlayerId,
                          sn = Sn
                         } = Player) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            ignored;
        #league_member{
           title = Title
          } when Title =/= ?LEAGUE_TITLE_BOSS ->
            leave_league(Player),
            ok;
        #league_member{           
           league_id = LeagueId
          } = OldBoss ->
            Members = get_league_member_list(LeagueId),
            Cnt = length(Members),
            if
                Cnt > 1 -> 
                    %%转让军团逻辑
                    SortFun = fun(#league_member{
                                     contribute_lv = LvA,
                                     contribute = CA
                                    } = _A, 
                                  #league_member{
                                     contribute_lv = LvB,
                                     contribute = CB
                                    } = _B) ->
                                      if
                                          LvA > LvB  ->
                                              true;
                                          LvA == LvB ->
                                              CA > CB;
                                          true  ->
                                              false
                                      end
                              end,        
                    [NewBoss|_]= lists:sort(SortFun, Members),
                    transfer_league(Sn, LeagueId, OldBoss, NewBoss),
                    ok;
                true ->
                    %% 解散军团逻辑
                    PlayerIds = lists:map(fun(Member) ->
                                                  element(#league_member.player_id, Member)
                                          end, Members),
                    dismiss_league(Sn, LeagueId, PlayerIds),
                    ok
            end
    end.

%% 解散军团 直接解散，不进行检测
dismiss_league(Sn, LeagueId, PlayerIds) ->
    hdb:dirty_delete(get_write_table(Sn), LeagueId),    
    hdb:dirty_delete_list(league_member, PlayerIds),
    ok.

%% 转让军团
transfer_league(Sn, LeagueId, OldBoss, NewBoss) ->
    hdb:dirty_delete(league_member, OldBoss#league_member.player_id),
    hdb:dirty_write(league_member, NewBoss#league_member{title = ?LEAGUE_TITLE_BOSS}),
    case get_league_info(LeagueId, Sn) of
        #league{
          } = League ->
            hdb:dirty_write(league, League#league{president = NewBoss#league_member.player_name
                                                 });
        _  ->
            ?WARNING_MSG("League Not found id: ~p, Sn :~p ~n",[LeagueId, Sn]),
            ignored
    end.

change_league_declaration(#player{id = PlayerId,
                                  sn = Sn}, Msg) ->
    if
        length(Msg) > ?LEAGUE_MAX_LEAGUE_DECRA_LENGTH ->
            {fail, ?INFO_LEAGUE_LONG_DER};
        true ->
            Table = get_write_table(Sn),
            case hdb:dirty_read(league_member, PlayerId) of
                [] ->
                    {fail, ?INFO_LEAGUE_NOT_MEMBER};
                #league_member{league_id = LeagueId,
                               title = Title} ->
                    if
                        Title =:= ?LEAGUE_TITLE_BOSS orelse Title =:= ?LEAGUE_TITLE_DEPUTY_BOSS ->
                            OMsgBin = unicode:characters_to_binary(Msg),
                            MsgBin = sensitive_word_misc:sensitive_word_filter(OMsgBin),
                            WriteFun = 
                                fun() ->
                                        case mnesia:read(Table, LeagueId) of
                                            [] ->
                                                {fail, ?INFO_CONF_ERR};
                                            [League] ->
                                                mnesia:write(Table, League#league{declaration = MsgBin}, write),
                                                {ok, League}
                                        end
                                end,
                            case hdb:transaction(WriteFun) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                {ok, League} ->
                                    mod_league_cache:update_league(Sn, League),
                                    ok;
                                Other ->
                                    Other
                            end;
                        true ->
                            {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER}
                    end
            end
    end.

change_league_join_ability(#player{id = PlayerId,
                                   sn = Sn}, Ability) 
  when is_integer(Ability) andalso Ability >= 0 ->
    Table = get_write_table(Sn),
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId,
                       title = Title} ->
            if
                Title =:= ?LEAGUE_TITLE_BOSS orelse Title =:= ?LEAGUE_TITLE_DEPUTY_BOSS ->
                    WriteFun = 
                        fun() ->
                                case mnesia:read(Table, LeagueId) of
                                    [] ->
                                        {fail, ?INFO_CONF_ERR};
                                    [League] ->
                                        mnesia:write(Table, League#league{join_ability = Ability}, write),
                                        {ok, League}
                                end
                        end,
                    case hdb:transaction(WriteFun) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, League} ->
                            mod_league_cache:update_league(Sn, League),
                            ok;
                        Other ->
                            Other
                    end;
                true ->
                    {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER}
            end
    end;
change_league_join_ability(_, _) ->
    {fail, ?INFO_NOT_LEGAL_INT}.



get_my_g17_guild(Player) ->
    case hdb:dirty_read(g17_guild_member, Player#player.accid) of
        [] ->
            [];
        #g17_guild_member{
           guild_id = GuildId
          } ->
            hdb:dirty_read(g17_guild, GuildId, true)
    end.

get_g17_guild_member(StrUserId) ->
    hdb:dirty_read(g17_guild_member, StrUserId).

rm_g17_guild_member(StrUserId) ->
    hdb:dirty_delete(g17_guild_member, StrUserId).

update_league_g17_guild(Sn, LeagueId, G17GuildId, G17GuildName) ->
    case get_league_info(LeagueId, Sn) of
        [] ->
            ?ERROR_MSG("UpdateLeagueG17Failed", []),
            error;
        #league{
          } = League ->
            NewLeague = League#league{g17_guild_id = G17GuildId,
                                      g17_guild_name = G17GuildName
                                     },
            Members = get_league_member_list(LeagueId),
            NewMembers = lists:foldl(fun(#league_member{title = Title} = M, RetMembers) ->
                                             case Title of
                                                 ?LEAGUE_TITLE_BOSS ->
                                                     RetMembers;
                                                 _  ->
                                                     NewM = M#league_member{g17_join_timestamp = get_last_timestamp()
                                                                           },
                                                     [NewM|RetMembers]
                                             end
                                     end, [], Members),
            hdb:dirty_write(get_write_table(Sn), NewLeague),
            hdb:dirty_write(league_member, NewMembers),
            {ok, NewLeague}
    end.

check_create_g17_guild(Player) ->
    case get_g17_guild_member(Player#player.accid) of
        [] ->
            case get_league_member_by_id(Player#player.id) of
                [] ->
                    {error, error_not_league_member};
                #league_member{title = Title, league_id = LeagueId} when Title =:= ?LEAGUE_TITLE_BOSS  ->
                    {ok, LeagueId}
            end;
        _ ->
            {error, error_aleady_join_guild}
    end.

create_g17_guild(Player, GuildName) ->
    case check_create_g17_guild(Player) of
        {ok, MyLeagueId} ->
            %% IntUserId = hmisc:to_integer(Player#player.accid),
            case g17:guild_create(Player#player.accid, GuildName) of
                {ok, #guild_create_ret{
                   code = Code,
                   data = #guild_ret{
                             guild_id = GuildId,
                             guild_name = _RetGuildName,
                             owner_user_id = _OwnerUserId
                            }
                  }} when Code =:= 1 ->
                    IntG17GuildId = hmisc:to_integer(GuildId),
                    G17Guild = #g17_guild{guild_id = 
                                          guild_name = GuildName,
                                          owner_user_id = Player#player.accid
                                         },
                    G17Member = #g17_guild_member{user_id   = Player#player.accid,
                                                  guild_id  = IntG17GuildId,
                                                  title_id  = ?G17_TITLE_BOSS,
                                                  number_id = 0
                                                 },
                    hdb:dirty_write(g17_guild, G17Guild),
                    hdb:dirty_write(g17_guild_member, G17Member),
                    %% 更新LEAGUE属性里的g17_guild_id and g17_guild_name
                    {ok, NewLeague} = update_league_g17_guild(Player#player.sn, MyLeagueId, IntG17GuildId, GuildName),
                    {ok, NewLeague};
                {ok, #guild_create_ret{
                   code = Code,
                   msg  = Msg
                  }} -> 
                    ?WARNING_MSG("CreateG17GuildFailed, Code : ~p, Msg : ~p~n",[Code, Msg]),
                    case Code of
                        -1 ->
                            {error, ?INFO_G17_GUILD_BAD_PARAM};
                        -2 ->
                            {error, ?INFO_G17_GUILD_TIMEOUT};
                        -3 ->
                            {error, ?INFO_G17_GUILD_BAD_SIGN};
                        -4 ->
                            {error, ?INFO_G17_GUILD_SYSTEM_ERROR};
                        -5 ->
                            {error, ?INFO_G17_GUILD_USER_NOTFOUND};
                        -6 ->
                            {error, ?INFO_G17_GUILD_ALEADY_JOIN};
                        -7 ->
                            {error, ?INFO_G17_GUILD_NAME_EMPTY};
                        -8 ->
                            {error, ?INFO_G17_GUILD_NAME_LEN_ERROR};
                        -9 ->
                            {error, ?INFO_G17_GUILD_NAME_SPEICAL};
                        -10 ->
                            {error, ?INFO_G17_GUILD_NAME_USED};
                        -11 ->
                            {error, ?INFO_G17_GUILD_CREATE_FAILED};
                        _ ->
                            {error, ?INFO_UNKNOWN}
                    end
            end;
        {error, _} = ERROR ->
            ERROR
    end.

check_follow_join_g17_guild(Player) ->
    case get_g17_guild_member(Player#player.accid) of
        [] ->
            case get_league_member_by_id(Player#player.id) of
                #league_member{
                   league_id = LeagueId
                  } ->
                    Members = get_league_member_list(LeagueId),
                    case lists:keyfind(?LEAGUE_TITLE_BOSS, #league_member.title, Members) of
                        #league_member{
                           player_id = PlayerId
                          } ->
                            case hdb:dirty_read(player, PlayerId) of
                                [] ->
                                    {error, ?INFO_LEAGUE_NOT_MEMBER};
                                #player{
                                   accid = StrAccid
                                  } ->
                                    case get_g17_guild_member(StrAccid) of
                                        [] ->
                                            {error, ?INFO_G17_GUILD_LEADER_NOT_JOIN};
                                        #g17_guild_member{
                                           guild_id = GuildId
                                          } ->
                                            {ok, GuildId};
                                        _ ->
                                            {error, ?INFO_G17_GUILD_JOIN_NOT_SAME}
                                    end
                            end;
                        _ ->
                            {error, ?INFO_LEAGUE_NOT_MEMBER}
                    end;
                _ ->
                    {error, ?INFO_LEAGUE_NOT_MEMBER}
            end;
        #g17_guild_member{
          } ->
            {error, ?INFO_G17_GUILD_ALEADY_JOIN}
    end.

%% 只提供给跟随军团长加入大公会的接口
follow_join_g17_guild(Player) ->
    case check_follow_join_g17_guild(Player) of
        {ok, GuildId} ->
            %% IntUserId = hmisc:to_integer(Player#player.accid),
            StrGuildId = hmisc:to_string(GuildId),
            case g17:guild_join(Player#player.accid, StrGuildId) of
                {ok, #simple_ret{
                        code = Code
                       }} when Code =:= 1 ->
                    %% success
                    G17Member = #g17_guild_member{user_id = Player#player.accid,
                                                  guild_id = GuildId,
                                                  title_id = 0,
                                                  number_id = 0
                                                 },
                    hdb:dirty_write(g17_guild_member, G17Member),
                    case get_g17_guild_info(GuildId) of
                        [] ->
                            mod_g17_srv:after_join_g17_guild(Player#player.accid, GuildId, "");
                        #g17_guild{
                           guild_name = GuildName
                          } ->
                            mod_g17_srv:after_join_g17_guild(Player#player.accid, GuildId, GuildName)
                    end,

                    case get_league_member_by_id(Player#player.id) of
                        [] ->
                            ?WARNING_MSG("LeagueInfo not found!! PlayerId :~p~n,", [Player#player.id]),
                            ignored,
                            {error, ?INFO_LEAGUE_NOT_MEMBER};
                        LeagueMember ->
                            NewLeagueMember = LeagueMember#league_member{g17_join_timestamp = 0
                                                                        },
                            update_league_member(NewLeagueMember),
                            {ok, NewLeagueMember}
                    end;
                {ok, #simple_ret{
                        code = Code,
                        msg  = Msg
                       }} ->
                    ?WARNING_MSG("JoinG17GuildFailed, Code : ~p, Msg : ~p~n",[Code, Msg]),
                    case Code of
                        -1 ->
                            {error, ?INFO_G17_GUILD_BAD_PARAM};
                        -2 ->
                            {error, ?INFO_G17_GUILD_TIMEOUT};
                        -3 ->
                            {error, ?INFO_G17_GUILD_BAD_SIGN};
                        -4 ->
                            {error, ?INFO_G17_GUILD_SYSTEM_ERROR};
                        -5 ->
                            {error, ?INFO_G17_GUILD_GUILD_NOTFOUND};
                        -6 ->
                            {error, ?INFO_G17_GUILD_ALEADY_JOIN};
                        -7 ->
                            {error, ?INFO_G17_GUILD_ALEADY_APPLY};
                        -8 ->
                            {error, ?INFO_G17_GUILD_APPLY_FAILED};
                        _ ->
                            {error, ?INFO_UNKNOWN}
                    end
            end;
        {error, _} = RET ->
            RET
    end.

check_apply_g17_guild(Player) ->
    case get_g17_guild_member(Player#player.accid) of
        [] ->
            case get_league_member_by_id(Player#player.id)  of
                [] ->
                    {error, error_not_league_member};
                #league_member{league_id = LeagueId,
                               title = Title} when Title =:= ?LEAGUE_TITLE_BOSS  ->
                    LeagueMembers = get_league_member(Player#player.id),
                    get_my_league(Player#player.id, Player#player.sn),
                    Cnt = length(LeagueMembers),
                    League = get_league_info(LeagueId, Player#player.sn),
                    {ok, League, Cnt}
            end;
        _ ->
            {error, ?INFO_G17_GUILD_ALEADY_JOIN}
    end.

apply_g17_guild(Player, G17GuildId) ->
    case check_apply_g17_guild(Player) of
        {ok, #league{id   = GroupId,
                     name = GroupName
                    }, MemberCnt} ->
            %% IntUserId = hmisc:to_integer(Player#player.accid),
            StrGroupId = hmisc:to_string(GroupId),
            StrMemberCnt = hmisc:to_string(MemberCnt),
            StrG17GuildId = hmisc:to_string(G17GuildId),
            case g17:guild_applyjoin(Player#player.accid, GroupId, GroupName, MemberCnt, StrG17GuildId) of
                {ok, #simple_ret{
                   code = Code
                  }} when Code =:= 1 ->
                    Now = hmisctime:unixtime(),
                    G17Apply = #g17_guild_apply{user_id = Player#player.accid,
                                                apply_guild_id = G17GuildId,
                                                status = 0,
                                                delete_time = (Now + 5 * ?ONE_DAY_SECONDS)
                                               },
                    hdb:dirty_write(g17_guild_apply, G17Apply),
                    ok;
                {ok, #simple_ret{
                        code = Code,
                        msg  = Msg
                       }} ->
                    ?WARNING_MSG("ApplyG17GuildFailed, Code : ~p, Msg : ~p~n",[Code, Msg]),
                    case Code of
                        -1 ->
                            {error, ?INFO_G17_GUILD_BAD_PARAM};
                        -2 ->
                            {error, ?INFO_G17_GUILD_TIMEOUT};
                        -3 ->
                            {error, ?INFO_G17_GUILD_BAD_SIGN};
                        -4 ->
                            {error, ?INFO_G17_GUILD_SYSTEM_ERROR};
                        -5 ->
                            {error, ?INFO_G17_GUILD_GUILD_NOTFOUND};
                        -6 ->
                            {error, ?INFO_G17_GUILD_ALEADY_JOIN};
                        -7 ->
                            {error, ?INFO_G17_GUILD_ALEADY_APPLY};
                        -8 ->
                            {error, ?INFO_G17_GUILD_APPLY_FAILED};
                        _ ->
                            {error, ?INFO_UNKNOWN}
                    end
            end;
        {error, _} = ERROR ->
            ERROR
    end.


check_quit_g17_guild(Player) ->
    case get_g17_guild_member(Player#player.accid) of
        [] ->
            {error, ?INFO_G17_GUILD_NOT_GUILD_MEMBER};
        #g17_guild_member{
           title_id = Title
          } when Title =:= ?G17_TITLE_BOSS ->
            {error, ?INFO_G17_GUILD_LEADER_CANT_QUIT};
        #g17_guild_member{
           guild_id = GuildId
          } ->
            case get_league_member_by_id(Player#player.id) of
                [] ->
                    {ok, GuildId};
                #league_member{
                   title = Title
                  } when Title =/= ?LEAGUE_TITLE_BOSS ->
                    {ok, GuildId};
                #league_member{
                  } ->
                    %% 转让军团长|解散帮会
                    %% {ok, GuildId}
                    {error, ?INFO_G17_GUILD_LEADER_CANT_QUIT}
            end
    end.

quit_g17_guild(Player) ->
    case check_quit_g17_guild(Player) of
        {ok, GuildId} ->
            %% IntUserId = hmisc:to_integer(Player#player.accid),
            StrGuildId = hmisc:to_string(GuildId),
            case g17:guild_quit(Player#player.accid, StrGuildId) of
                {ok, #simple_ret{
                        code = Code,
                        msg  = _Msg
                       }} when Code =:= 1 ->
                    rm_g17_guild_member(Player#player.accid),
                    mod_g17_srv:after_quit_g17_guild(Player#player.accid, GuildId),
                    ok;
                {ok, #simple_ret{
                        code = Code,
                        msg  = Msg
                       }}->
                    ?WARNING_MSG("QuitG17GuildFailed, Code : ~p, Msg : ~p~n",[Code, Msg]),
                    case Code of
                        -1 ->
                            {error, ?INFO_G17_GUILD_BAD_PARAM};
                        -2 ->
                            {error, ?INFO_G17_GUILD_TIMEOUT};
                        -3 ->
                            {error, ?INFO_G17_GUILD_BAD_SIGN};
                        -4 ->
                            {error, ?INFO_G17_GUILD_SYSTEM_ERROR};
                        -5 ->
                            {error, ?INFO_G17_GUILD_NOT_GUILD_MEMBER};
                        -6 ->
                            {error, ?INFO_G17_GUILD_LEADER_CANT_QUIT};
                        -7 ->
                            {error, ?INFO_G17_GUILD_QUIT_FAILED};
                        _ ->
                            {error, ?INFO_UNKNOWN}
                    end
            end;
        {error, _} = ERROR->
            ERROR
    end.

get_g17_guild_list() ->
    hdb:tab2list(g17_guild).

get_league_list(Player) ->
    case get_g17_guild_member(Player#player.accid) of
        [] ->
            hdb:tab2list(get_write_table(Player#player.sn));
        #g17_guild_member{
           guild_id = G17GuildId
          } ->
            ?DEBUG("G17GuildId : ~p~n", [G17GuildId]),
            Leagues = hdb:tab2list(get_write_table(Player#player.sn)),
            lists:filter(fun(#league{g17_guild_id = Gid
                                    }) ->
                                 Gid =:= G17GuildId
                         end, Leagues)
    end.

get_apply_status(GuildId, StrUserId) ->
    Key = {GuildId, StrUserId},
    case hdb:dirty_read(g17_guild_apply, Key) of
        [] ->
            ?G17_APPLY_STATUS_NONE;
        #g17_guild_apply{
           status = Status
          } ->
            Status
    end.

%% G17 各类通知的截止时间
get_last_timestamp() ->
    hmisctime:unixtime() + 2 * ?ONE_DAY_SECONDS.

do_after_join_g17_guild(#player{id = PlayerId, sn = Sn} = Player, GuildId, GuildName) ->
    ?DEBUG("do_after_join_g17_guild, SN : ~p, PlayerId : ~p, GuildId:~p, GuildName : ~p~n ",[Sn, PlayerId, GuildId, GuildName]),
    case get_league_member_by_id(PlayerId) of
        [] ->
            ignored;
        #league_member{league_id = LeagueId,
                       title     = Title} when Title =:= ?LEAGUE_TITLE_BOSS ->
            %% 加入大公会后，军团长处理逻辑
            case get_league_info(LeagueId, Sn) of
                [] ->
                    ignored;
                #league{
                   g17_guild_id = GuildId
                  } ->
                    %% 已经处理过的军团
                    ignored;
                _ ->
                    update_league_g17_guild(Sn, LeagueId, GuildId, GuildName)
            end;
        #league_member{league_id = LeagueId} ->
            %% 加入大公会后，普通成员处理逻辑
            case get_league_info(LeagueId, Sn) of
                [] ->
                    ignored;
                #league{
                   g17_guild_id = GuildId
                  } ->
                    ignored;
                #league{
                  } ->
                    force_quit_league(Player)
            end
    end.

do_quit_join_g17_guild(Player, QuitGuildId) ->
    ?DEBUG("do_quit_join_g17_guild, SN : ~p, PlayerId : ~p, GuildId:~p~n ",[Player#player.sn, Player#player.id, QuitGuildId]),
    force_quit_league(Player).


system_quit_league(PlayerId) ->
    ok.


%%
%% @doc 处理加入g17大公会的游戏内部的相关处理
%%
after_quit_g17_guild() ->
    ok.


get_g17_guild_info(GuildId) ->
    case hdb:dirty_read(g17_guild, GuildId) of
        [] ->
            %% Request Guild info
            StrGuildId = hmisc:to_string(GuildId),
            case load_guild_info([StrGuildId]) of
                [] ->
                    [];
                [Guild] ->
                    Guild
            end;
        Guild ->
            Guild
    end.

load_guild_info(GuildIds) ->
    case g17:query_guild_info(GuildIds, []) of
        {ok, #query_guild_info_ret{
                data = GuildList
               }} -> 
            lists:map(fun(#guild_info_ret{guild_id = GuildId,
                                          guild_name = GuildName,
                                          guild_logo = GuildLogo,
                                          owner_user_id = OwnerUserId
                                         }) ->
                              G17Guild = #g17_guild{guild_id = hmisc:to_integer(GuildId),
                                                    guild_name = hmisc:to_string(GuildName),
                                                    guild_logo = hmisc:to_string(GuildLogo),
                                                    owner_user_id = hmisc:to_string(OwnerUserId)
                                                   },
                              hdb:dirty_write(g17_guild, G17Guild),
                              G17Guild
                      end, GuildList);
        Other ->
            ?WARNING_MSG("load_guild_info failed Other:~p~n",[Other]),
            []
    end.


%% 获取N服，指定g17公会id的所有军团
get_g17_league_list(Sn, G17GuildId) ->
    Leagues = hdb:tab2list(get_write_table(Sn)),
    lists:filter(fun(#league{g17_guild_id = Gid
                            }) ->
                         Gid =:= G17GuildId
                 end, Leagues).

%%%-------------------------------------------------------------------
%%% @author Arno <>
%%% @copyright (C) 2015, Arno
%%% @doc
%%%
%%% @end
%%% Created : 23 Apr 2015 by Arno <>
%%%-------------------------------------------------------------------
-module(mod_g17_srv).
-include("define_try_catch.hrl").
-include("define_g17_guild.hrl").
-include("common.hrl").
-include("define_time.hrl").
-include_lib("g17/include/g17.hrl").

-behaviour(gen_server).

-export([update_g17_user_info/4,
         update_g17_apply/3,
         newbie_join/2,
         after_join_g17_guild/3,
         after_quit_g17_guild/2,
         quit_guild/2
       ]).
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(g17_srv_state, {}).

-define(OUT(Format, Args),
        ?DEBUG("~p:~p " ++ Format, [?MODULE, ?LINE] ++ Args)).

%%%===================================================================
%%% API
%%%===================================================================

get_worker_pid(GuildId) ->
    ?SERVER.

%%
%% @doc 处理加入g17大公会的游戏内部的相关处理
%%
after_join_g17_guild(UserId, JoinGuildId, JoinGuildName) ->
    gen_server:cast(get_worker_pid(JoinGuildId), {cmd_after_join_g17_guild, UserId, JoinGuildId, JoinGuildName}).

after_quit_g17_guild(UserId, QuitGuildId) ->
    gen_server:cast(get_worker_pid(QuitGuildId), {cmd_after_quit_g17_guild, UserId, QuitGuildId}).

update_g17_user_info(UserId, GuildId, Title, NumberId) ->
    ?OUT("UserId : ~p, GuildId : ~p, Title : ~p, Number: ~p",[UserId, GuildId, Title, NumberId]),
    gen_server:cast(get_worker_pid(GuildId), {update_g17_user_info, 
                              hmisc:to_string(UserId),
                              hmisc:to_integer(GuildId), 
                              hmisc:to_integer(Title), 
                              hmisc:to_integer(NumberId)}).
update_g17_guild(GuildId) ->
    gen_server:cast(get_worker_pid(GuildId), {cmd_update_g17_guild, GuildId}).

update_g17_apply(Action, UserId, GuildId) ->
    gen_server:cast(get_worker_pid(GuildId), {cmd_update_g17_apply, Action, UserId, GuildId}).
    
newbie_join(UserId, GuildId) ->
    gen_server:cast(get_worker_pid(GuildId), {cmd_newbie_join, UserId, GuildId}).

quit_guild(UserId, GuildId) ->
    gen_server:cast(get_worker_pid(GuildId), {cmd_quit_guild, UserId, GuildId}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    {ok, #g17_srv_state{}}.

handle_call(Request, From, State) ->
    ?DO_HANDLE_CALL(Request, From, State).
handle_cast(Msg, State) ->
    ?DO_HANDLE_CAST(Msg, State).
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State).

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
do_handle_call(_Req, _From, State) ->
    {reply, ok, State}.

do_handle_cast({update_g17_user_info, UserId, GuildId, Title, NumberId},  State) when GuildId > 0 ->
    case hdb:dirty_read(g17_guild_member, UserId) of
        [] ->
            NewMember = #g17_guild_member{user_id  = UserId,
                                          guild_id = GuildId,
                                          title_id = Title,
                                          number_id = NumberId
                                         },
            update_g17_guild(GuildId),
            hdb:dirty_write(g17_guild_member, NewMember);
        #g17_guild_member{} = Member ->
            NewMember = Member#g17_guild_member{guild_id = GuildId,
                                                title_id = Title,
                                                number_id = NumberId
                                               },            
            update_g17_guild(GuildId),
            hdb:dirty_write(g17_guild_member, NewMember)
    end,
    {noreply, State};
do_handle_cast({cmd_update_g17_guild, GuildId}, State) ->
    lib_league:get_g17_guild_info(GuildId),
    {noreply, State};
do_handle_cast({cmd_update_g17_apply, reject, UserId, GuildId}, State) ->
    ?DEBUG("apply reject UserId : ~p, GuildId:~p~n",[UserId, GuildId]),
    Key = {GuildId, UserId},
    case hdb:dirty_read(g17_guild_apply, Key) of
        #g17_guild_apply{
           status = ?G17_APPLY_STATUS_WAIT
          } = GuildApply ->
            NewGuildApply = GuildApply#g17_guild_apply{status = ?G17_APPLY_STATUS_REJECT,
                                                       delete_time = lib_league:get_last_timestamp()
                                                      },
            hdb:dirty_write(g17_guild_apply, NewGuildApply);
        _ ->
            ok
    end,
    {noreply, State};
do_handle_cast({cmd_newbie_join, UserId, GuildId}, State) ->
    StrUserId = hmisc:to_string(UserId),
    case hdb:dirty_read(g17_guild_member, StrUserId) of
        [] ->
            NewGuildMember = #g17_guild_member{user_id = StrUserId,
                                               guild_id = GuildId
                                              },
            hdb:dirty_write(g17_guild_member, NewGuildMember),
            case lib_league:get_g17_guild_info(GuildId) of
                [] ->
                    mod_g17_srv:after_join_g17_guild(UserId, GuildId, "");
                #g17_guild{
                   guild_name = GuildName
                  } ->
                    mod_g17_srv:after_join_g17_guild(UserId, GuildId, GuildName)
            end,
            set_apply_accepted(GuildId, StrUserId);
        #g17_guild_member{
          } = GuildMember ->
            ?WARNING_MSG("g17_newbie_join UserId:~p, aleady in g17guild Old:~p, notify to NewGuild:~p~n",[UserId, GuildMember, GuildId]),
            %% NewGuildMember = GuildMember#g17_guild_member{guild_id = GuildId
            %%                                              },
            %% hdb:dirty_write(g17_guild_member, NewGuildMember),
            %% set_apply_accepted(GuildId, StrUserId)
            ok
    end,
    {noreply, State};
do_handle_cast({cmd_quit_guild, UserId, GuildId}, State) ->
    StrUserId = hmisc:to_string(UserId),
    case hdb:dirty_read(g17_guild_member, StrUserId) of
        [] ->
            ignored;
        #g17_guild_member{
           guild_id = GuildId
          } ->
            hdb:dirty_delete(g17_guild_member, StrUserId),
            after_quit_g17_guild(UserId, GuildId);
        #g17_guild_member{
           guild_id = OldGuildId
          }   ->
            ?WARNING_MSG("g17 cmd_quit_guild not same guild Old : ~p, New : ~p~n", [OldGuildId, GuildId]),
            ignored
    end,
    {noreply, State};
do_handle_cast({cmd_after_join_g17_guild, UserId, JoinGuildId, JoinGuildName}, State) ->
    AllPlayers = hdb:dirty_index_read(player, UserId, #player.accid, true),
    lists:foreach(fun(#player{} = Player) ->
                          lib_league:do_after_join_g17_guild(Player, JoinGuildId, JoinGuildName)
                  end, AllPlayers),
    {noreply, State};
do_handle_cast({cmd_after_quit_g17_guild, UserId, QuitGuildId}, State) ->
    AllPlayers = hdb:dirty_index_read(player, UserId, #player.accid, true),
    lists:foreach(fun(#player{} = Player) ->
                          lib_league:do_quit_join_g17_guild(Player, QuitGuildId)
                  end, AllPlayers),
    {noreply, State};
do_handle_cast(_Cmd,  State) ->
    {noreply, State}.

do_handle_info(_Info,  State) ->
    {noreply, State}.


set_apply_accepted(GuildId, StrUserId) ->
    case hdb:dirty_index_read(g17_guild_apply, StrUserId, #g17_guild_apply.user_id) of
        [] ->
            ignored;
        Applys ->
            lists:map(fun(#g17_guild_apply{key = Key,
                                           guild_id = ApplyGid
                                          } = Apply) ->
                              if
                                  GuildId =:= ApplyGid ->
                                      NewApply = Apply#g17_guild_apply{status = ?G17_APPLY_STATUS_PASS,
                                                                       delete_time = lib_league:get_last_timestamp()
                                                                      },
                                      hdb:dirty_read(g17_guild_apply, NewApply);
                                  true -> 
                                      hdb:dirty_delete(g17_guild_apply, Key)
                              end
                      end, Applys)
    end.




%% get_guild_info(GuildId) ->
%%     case hdb:dirty_read(g17_guild, GuildId) of
%%         [] ->
%%             %% Request Guild info
%%             case load_guild_info([GuildId]) of
%%                 [] ->
%%                     [];
%%                 [Guild] ->
%%                     Guild
%%             end;
%%         Guild ->
%%             Guild
%%     end.

%%%-----------------------------------
%%% @Module  : mod_login
%%% @Created : 2010.10.05
%%% @Description: 用户登陆
%%%-----------------------------------
-module(mod_login).

-include("define_logger.hrl").
-include("define_player.hrl").
-include("define_login.hrl").
-include("define_server.hrl").
-include("define_info_10.hrl").

-export([
         login/1
        ]).

%% 登陆检查入口
%% Data:登陆验证数据
%% Arg:tcp的Socket进程,socket ID
login(Client) -> 
    case inner_login(Client) of
        {fail, Reason} ->
            {fail, Reason};
        Pid ->
            {ok, Client#client{player_pid = Pid}}
    end.

inner_login(#client{
               player_pid = OldPlayerPid,
               player_id = PlayerId,
               sn = Sn
              } = Client) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?DEBUG("new player ~p~n", [PlayerId]),
            case  player_sup:start_child(server_misc:server_name(player_sup, Sn), Client) of   %%用监控树启动player
                {ok, Pid} ->
                    stop_old_role(OldPlayerPid),
                    mod_player:update_client_info(Pid, Client),
                    link(Pid),
                    Pid;
                Err ->
                    ?WARNING_MSG("start player err PlayerId ~p Reason ~p~n", [PlayerId, Err]),
                    {fail, ?INFO_LOGIN_LOGIN_FAILED}
            end;
        PlayerPid ->
            Node = node(PlayerPid),
            case node() =:= Node of
                false ->
                    ?DEBUG("old mod player in ~p~n", [Node]),
                    MRef = erlang:monitor(process, PlayerPid),
                    mod_player:stop(PlayerPid, normal),
                    receive
                        {'DOWN', MRef, process, PlayerPid, _Reason} -> ok
                    end,
                    erlang:demonitor(MRef, [flush]),
                    inner_login(Client);
                true ->
                    if
                        PlayerPid =:= OldPlayerPid ->
                            OldPlayerPid;
                        true ->
                            ?DEBUG("change role id ~p OldPlayerPid ~p~n", [PlayerId, OldPlayerPid]),
                            stop_old_role(OldPlayerPid),
                            mod_player:update_client_info(PlayerPid, Client),
                            link(PlayerPid),
                            PlayerPid
                    end
            end
    end.

stop_old_role(Pid) ->
    if
        is_pid(Pid) ->
            unlink(Pid),
            mod_player:stop(Pid, normal);
        true ->
            skip
    end.
%% login(#client{
%%          player_pid = OldPlayerPid,
%%          player_id = PlayerId
%%         } = Client) ->
%%     case hmisc:whereis_player_pid(PlayerId) of
%%         [] ->
%%             mod_player:stop(OldPlayerPid, change_role),
%%             %% ?DEBUG("Player Not Live, Reason ~w~n", [Reason]),
%%             case  player_sup:start_child(Client) of   %%用监控树启动player
%%                 {ok, Pid} ->
%%                     do_monitor_player(Pid),
%%                     {ok, Client#client{player_pid = Pid}};
%%                 Err ->
%%                     {error, Err}
%%             end;
%%         Pid ->
%%             if
%%                 Pid =:= OldPlayerPid ->
%%                     skip;
%%                 true ->
%%                     mod_player:stop(OldPlayerPid, change_role)
%%             end,
%%             case node(Pid) =:= node() of
%%                 true ->
%%                     ?DEBUG("Player is Live, Update Sesssion~n", []),
%%                     ?DEBUG("mod_login trying to update_client_info~n",[]),
%%                     mod_player:update_client_info(Pid, Client),
%%                     ?DEBUG("mod_login trying to update_client_info done.~n",[]),
%%                     do_monitor_player(Pid),
%%                     {ok, Client#client{player_pid = Pid}};
%%                 false ->
%%                     MRef = erlang:monitor(process, Pid),
%%                     mod_player:stop(Pid, normal),
%%                     receive
%%                         {'DOWN', MRef, process, Pid, _Reason} -> ok
%%                     end,
%%                     erlang:demonitor(MRef, [flush]),
%%                     login(Client)
%%             end
%%     end.

%% do_monitor_player(PlayerPid) ->
%%     case erlang:process_info(self(), monitors) of
%%         {monitors,[]} ->
%%             erlang:monitor(process, PlayerPid);
%%         _ ->
%%             skip
%%     end.

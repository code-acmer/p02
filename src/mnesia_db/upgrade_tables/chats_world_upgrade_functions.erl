-module(chats_world_upgrade_functions).
-include("define_mnesia_upgrade_functions.hrl").
%% If you are tempted to add include file here, don't. Using record
%% defs here leads to pain later.

-compile([export_all]).

-mnesia_upgrade({chats_world_change_nick, []}).

chats_world_change_nick() ->
    do_transform(
      #mnesia_upgrade_conf{
         get_old_field_fun = fun (chats_world) -> 
                                     [id,player_id,nick,lv,career,msg];
                                 (_) ->
                                     same
                             end,
         get_new_field_fun = fun (chats_world) ->
                                     [id,player_id,nickname,lv,career,msg];                      
                                 (_) ->
                                     same
                             end,
         get_field_change_fun = fun ({chats_world, nickname}) ->
                                        nick;
                                    (_) ->
                                        []
                                end
        }).

do_transform(MnesiaUpgradeConf) ->
    ok = mnesia_upgrade_functions:do_transform(chats_world, MnesiaUpgradeConf).

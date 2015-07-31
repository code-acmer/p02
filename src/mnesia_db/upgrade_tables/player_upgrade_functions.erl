-module(player_upgrade_functions).

%% If you are tempted to add include file here, don't. Using record
%% defs here leads to pain later.

-compile([export_all]).

%-mnesia_upgrade({add_vip_test_player, []}).

%% GetOldFieldFun,
%% GetNewFieldFun,
%% GetDefaultValFun
%% GetFieldChangeFun,
%% GetNewRecordNameFun,

%% add_test_field_player_data() ->
%%     {
%% fun 
%%          (player) -> 
%%              [id,accid,accname,nickname,career,lv,exp,vip,vip_exp,
%%               vip_due_time,gm_power,coin,gold,cost,vigor,fpt,
%%               friends_limit,friends_cnt,bag_limit,bag_cnt,core,hp,hp_lim,
%%               hp_rec,mana,mana_lim,mana_rec,mana_init,fire,water,wood,
%%               holy,dark,attack,def,power,online_flag,timestamp_login,
%%               timestamp_logout,total_login_days,timestamp_login_reward,
%%               timestamp_daily_reset,first_login,vip_flag,
%%               login_reward_flag,last_dungeon,dungeon_reward,skill_setting,
%%               normal_skill_ids,stunt_skill_ids,passive_skill_ids,
%%               equip_active_skill_ids,equip_passive_skill_ids,invite_fpt,
%%               mail_flag,help_battle_id,total_gold,last_fashion,fashion,
%%               have_dungeoned,friends_ext,camp_send_timestamp,
%%               beginner_step,status,unlock_role_timestamp,
%%               goods_update_timestamp];
%%          (_) ->
%%             same
%%      end,
%%       fun 
%%          (player) ->
%%              [id,accid,accname,nickname,career,lv,exp,vip,vip_exp,
%%               vip_due_time,gm_power,coin,gold,cost,vigor,fpt,
%%               friends_limit,friends_cnt,bag_limit,bag_cnt,core,hp,hp_lim,
%%               hp_rec,mana,mana_lim,mana_rec,mana_init,fire,water,wood,
%%               holy,dark,attack,def,power,online_flag,timestamp_login,
%%               timestamp_logout,total_login_days,timestamp_login_reward,
%%               timestamp_daily_reset,first_login,vip_flag,
%%               login_reward_flag,last_dungeon,dungeon_reward,skill_setting,
%%               normal_skill_ids,stunt_skill_ids,passive_skill_ids,
%%               equip_active_skill_ids,equip_passive_skill_ids,invite_fpt,
%%               mail_flag,help_battle_id,total_gold,last_fashion,fashion,
%%               have_dungeoned,friends_ext,camp_send_timestamp,
%%               beginner_step,status,unlock_role_timestamp,
%%               goods_update_timestamp,test_mnesia];                         
%%          (_) ->
%%             same
%%      end,
     
%%      fun 
%%          ({player, test_mnesia}) ->
%%              0
%%      end}.

%% add_vip_test_player() ->
%%     ok = mnesia_upgrade_functions:do_transform(player, add_test_field_player_data()),    
%%     ok = mnesia_upgrade_functions:do_transform(player_rec, add_test_field_player_data()).



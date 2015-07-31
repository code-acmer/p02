-module(goods_upgrade_functions).
-include("define_mnesia_upgrade_functions.hrl").
%% If you are tempted to add include file here, don't. Using record
%% defs here leads to pain later.

-compile([export_all]).

-mnesia_upgrade({goods_init, []}).
-mnesia_upgrade({goods_add_is_dirty, [goods_init]}).
goods_init() ->
    do_transform(
      #mnesia_upgrade_conf{
         get_old_field_fun = fun(goods) -> 
                                     [id,type,subtype,goods_id,player_id,partner_id,container,
                                      position,lv,exp,beyond,hp_extra,attack_extra,def_extra,
                                      lead_skill,active_skill,master_skills,quality,cost,element,
                                      sub_element,style,sub_style,due_time,is_specical,
                                      lead_skill2,is_dirty];
                                (_) ->
                                     same
                          end,
         get_new_field_fun = fun (goods) ->
                                     [id,base_id,player_id,type,subtype,sum,bind,str_lv,star_lv,
                                      max_overlap,container,position,extra_att,hp,attack,def,hit,
                                      dodge,crit,anti_crit,stiff,anti_stiff,attack_speed,
                                      move_speed,opear_type];                     
                                 (_) ->
                                     same
                             end,
         get_default_val_fun = fun({goods, extra_att}) ->
                                       [];
                                  ({goods, _}) ->
                                       0
                               end,
         get_field_change_fun = fun ({goods, base_id}) ->
                                        goods_id;
                                    (_) ->
                                        []
                                end
        }).

goods_add_is_dirty() ->
    do_transform(
      #mnesia_upgrade_conf{

         get_old_field_fun = fun (goods) ->
                                     [id,base_id,player_id,type,subtype,sum,bind,str_lv,star_lv,
                                      max_overlap,container,position,extra_att,hp,attack,def,hit,
                                      dodge,crit,anti_crit,stiff,anti_stiff,attack_speed,
                                      move_speed,opear_type];                     
                                 (_) ->
                                     same
                             end,

         get_new_field_fun = fun (goods) ->
                                     [id,base_id,player_id,type,subtype,sum,bind,str_lv,star_lv,
                                      max_overlap,container,position,extra_att,hp,attack,def,hit,
                                      dodge,crit,anti_crit,stiff,anti_stiff,attack_speed,
                                      move_speed,opear_type,is_dirty];                     
                                 (_) ->
                                     same
                             end,                  
         get_default_val_fun = fun ({goods, _}) ->
                                       0
                               end
        }).
do_transform(MnesiaUpgradeConf) ->
    ok = mnesia_upgrade_functions:do_transform(goods, MnesiaUpgradeConf).



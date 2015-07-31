-module(lib_robot_api).

-include("define_info_0.hrl").
-include("define_combat.hrl").
-include("db_base_kuafupvp_robot_attribute.hrl").

-export([
         get_robot_by_ability/1
        ]).
get_robot_by_ability(Ability) ->
    case data_base_kuafupvp_robot_attribute:get(Ability) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_kuafupvp_robot_attribute{} = RobotAttri ->
            %% #combat_attri{player_id = RobotId,
            %%               type      = ?COMBAT_ATTRI_TYPE_ROBOT
            %%              }
            RobotAttri
    end.


-module(ai_lib_dungeon).
-include("define_robot.hrl").
-compile(export_all).

get_dungeon_route(AccountInfo) ->
    Robot = ct_robot:get_robot(AccountInfo),
    DungeonInfo = Robot#ct_robot.dungeon_info,
    %?INFO("12002 DungeonInfo ~p~n", [DungeonInfo]),
    case DungeonInfo =:= #pbdungeon{} of
        true ->
            no_dungeon;
        _ ->
            lib_robot:get_sub_route(Robot)
    end.

get_dungeon_available(AccountInfo) ->
    Robot = ct_robot:get_robot(AccountInfo),
    Lv = Robot?ROBOT_LV,
    case data_base_dungeon_area:get_dungeon_all_lv() of
        [] ->
            [];
        LvList ->
            case ai_lib_player:get_available_lv(Lv, LvList) of
                [] ->
                    [];
                Other ->
                    DungeonId = hmisc:rand(data_base_dungeon_area:get_dungeon_by_lv(Other)),
                    BaseDungeon = data_base_dungeon_area:get(DungeonId),
                    case Robot?ROBOT_VIGOR < BaseDungeon#base_dungeon_area.req_vigor of
                        true ->
                            {no_vigor, DungeonId};
                        _ ->
                            DungeonId
                    end
            end
    end.

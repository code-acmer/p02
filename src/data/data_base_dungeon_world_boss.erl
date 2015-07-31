%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_dungeon_world_boss).
-export([get/1]).
-export([get_all_id/0]).
-export([player_boss_id/0]).
-export([sys_boss_id/0]).
-include("common.hrl").
-include("db_base_dungeon_world_boss.hrl").
get(1) ->
#base_dungeon_world_boss{id = 1,boss_desc = <<"机械公敌"/utf8>>,dungeon_id = 1198011,consume = [{1,50}],type = 2,open_time = [{9,00},{11,00},{13,00},{15,00},{17,00},{19,00},{21,00},{23,00}],last_time = 15,place_day = 0,place_hour = 0,challengers_place = 127,summon_reward = [[]],challengers_reward = [[{common_reward,0,10000,280138,0,0,0,0}]],open_date = [],close_date = []};
get(2) ->
#base_dungeon_world_boss{id = 2,boss_desc = <<"大蛇之魂"/utf8>>,dungeon_id = 1198007,consume = [{1,125}],type = 1,open_time = [],last_time = 15,place_day = 9,place_hour = 9,challengers_place = 100,summon_reward = [[{common_reward,0,10000,30004006,5,0,0,0}],[{common_reward,0,10000,280131,5,0,0,0}]],challengers_reward = [[{common_reward,0,10000,280135,0,0,0,0},{common_reward,0,10000,280136,0,0,0,0}]],open_date = [],close_date = []};
get(3) ->
#base_dungeon_world_boss{id = 3,boss_desc = <<"坦克大战"/utf8>>,dungeon_id = 1198012,consume = [{1,80}],type = 2,open_time = [{8,00},{10,00},{14,00},{16,00},{20,00},{22,00}],last_time = 5,place_day = 0,place_hour = 0,challengers_place = 127,summon_reward = [[]],challengers_reward = [[{common_reward,0,10000,280137,0,0,0,0}]],open_date = [],close_date = []};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

get_all_id() ->
[1,2,3].

player_boss_id() ->
[2].

sys_boss_id() ->
[1,3].

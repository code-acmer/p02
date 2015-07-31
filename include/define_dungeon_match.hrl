-ifndef(DEFINE_DUNGEON_MATCH_HRL).
-define(DEFINE_DUNGEON_MATCH_HRL, true).

-include("db_base_dungeon_match.hrl").

-define(STATE_NORMAL, 0).
-define(STATE_REJECT, 1).

-record(dungeon_match, {id = 0,  %%用team_id
                        dungeon_type, %%索引值{dungeon_id, lv_type}
                        player_id_list = [],
                        player_lv = 0,
                        battle_ability = 0,
                        ability_range = [0, 0],
                        cur_num = 0,
                        max_num = 0,
                        dungeon_info,
                        all_drop = [],
                        state = ?STATE_NORMAL
                       }).

%%统计玩家乱入副本的胜率
-record(player_dungeon_match, {player_id = 0,
                               version = player_dungeon_match_version:current_version(),
                               lv_range = [0, 0],
                               win_times = 0,
                               fail_times = 0,
                               dirty = 0}
                              ).

-endif.

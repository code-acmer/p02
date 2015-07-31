-ifndef(PBRANKINFO_PB_H).
-define(PBRANKINFO_PB_H, true).
-record(pbrankinfo, {
    player_id,
    career,
    nickname,
    level,
    rank,
    value
}).
-endif.

-ifndef(PBRANKLIST_PB_H).
-define(PBRANKLIST_PB_H, true).
-record(pbranklist, {
    rank_list = [],
    rank,
    value
}).
-endif.


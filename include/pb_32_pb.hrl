-ifndef(PBPLAYERACHIEVE_PB_H).
-define(PBPLAYERACHIEVE_PB_H, true).
-record(pbplayerachieve, {
    player_id,
    achieve_id,
    type,
    finish_flag,
    goods_id,
    num,
    task_id
}).
-endif.

-ifndef(PBPLAYERACHIEVELIST_PB_H).
-define(PBPLAYERACHIEVELIST_PB_H, true).
-record(pbplayerachievelist, {
    pa_list = []
}).
-endif.


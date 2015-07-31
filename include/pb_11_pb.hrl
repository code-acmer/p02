-ifndef(PBPRIVATE_PB_H).
-define(PBPRIVATE_PB_H, true).
-record(pbprivate, {
    send_list = [],
    recv_list = []
}).
-endif.

-ifndef(PBCHAT_PB_H).
-define(PBCHAT_PB_H, true).
-record(pbchat, {
    id_n,
    type,
    id,
    recv_id,
    send_id,
    nickname,
    lv,
    career,
    vip,
    msg,
    timestamp,
    league_id,
    gold_num
}).
-endif.

-ifndef(PBCHATLIST_PB_H).
-define(PBCHATLIST_PB_H, true).
-record(pbchatlist, {
    update_list = []
}).
-endif.

-ifndef(PBFEEDBACKMSG_PB_H).
-define(PBFEEDBACKMSG_PB_H, true).
-record(pbfeedbackmsg, {
    title,
    content
}).
-endif.

-ifndef(PBID32_PB_H).
-define(PBID32_PB_H, true).
-record(pbid32, {
    id
}).
-endif.

-ifndef(PBNEWMSG_PB_H).
-define(PBNEWMSG_PB_H, true).
-record(pbnewmsg, {
    send_list = []
}).
-endif.


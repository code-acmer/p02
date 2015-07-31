-ifndef(DEFINE_PAY_INFO_HRL).
-define(DEFINE_PAY_INFO_HRL, true).

-record(pay_info, {order_id   = "",
                   version    = pay_info_version:current_version(),
                   order_type = 0,
                   platform   = "g17",
                   accid      = "",
                   server_id  = 1,
                   coin       = 0,
                   extra      = 0,
                   money      = 0.0,
                   time       = 0,
                   player_id  = 0,
                   status     = 0,                   
                   lv         = 0,
                   handle_time= 0,
                   handle_desc= ""
                  }).

-define(ORDER_STATUS_UNHANDLE, 0).
-define(ORDER_STATUS_HANDLED,  1).

-endif.

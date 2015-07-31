%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_LOGIN_GIFT_HRL).
-define(DB_BASE_LOGIN_GIFT_HRL, true).
%% base_login_gift => ets_base_login_gift
-record(ets_base_login_gift, {
          id = 1,                               %% 
          month = 1,                            %% 月
          day = 1,                              %% 累积登录天数
          type = 2,                             %% 登录奖励类型，1是开服，2是普通
          sn = 1,                               %% 服务器ID
          gift_goods = [],                      %% 连续登录奖励数据
          is_special = 0                        %% 0不是特殊，1是特殊的大奖
         }).
-endif.

%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_PROTOCOL_HRL).
-define(DB_BASE_PROTOCOL_HRL, true).
%% base_protocol => ets_base_protocol
-record(ets_base_protocol, {
          id,                                   %% 协议ID
          c2s,                                  %% 客户端到服务器端的协议体名
          s2c,                                  %% 服务器端到客户端的协议体名
          memo                                  %% 备注
         }).
-endif.

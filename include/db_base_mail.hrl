%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_MAIL_HRL).
-define(DB_BASE_MAIL_HRL, true).
%% base_mail => base_mail
-record(base_mail, {
          id = 0,                               %% id
          title = <<""/utf8>>,                  %% 标题
          content = <<""/utf8>>,                %% 内容
          mail_define = 0                       %% 宏定义
         }).
-endif.

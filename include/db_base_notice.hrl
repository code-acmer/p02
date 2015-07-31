%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_NOTICE_HRL).
-define(DB_BASE_NOTICE_HRL, true).
%% base_notice => base_notice
-record(base_notice, {
          id,                                   %% 
          notice_id,                            %% 
          sort_id,                              %% 
          type,                                 %% 
          server_id = [],                       %% is uf8
          notice_name,                          %% 
          show_time,                            %% 
          activity_time,                        %% 
          headline,                             %% 
          des,                                  %% 
          function_id                           %% 
         }).
-endif.

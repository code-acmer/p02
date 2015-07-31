-ifndef(DEFINE_ERROR_COMMON_HRL).
-define(DEFINE_ERROR_COMMON_HRL, true).

%% error common code = [0, 9999]

-define(ERROR_OK,      0).
-define(ERROR_UNKNOWN, 1).
-define(ERROR_DB,      2).

-record(error_msg, 
        {
          error_code = 0,    %% 错误码
          args       = []    %% 错误消息中的参数列表
        }).

-endif.

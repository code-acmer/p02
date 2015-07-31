-ifndef(COMMON_HRL).
-define(COMMON_HRL,true).
%% 本头文件会被每个module包含，不是需要全局的定义，请不要放在这里，否则会引起频繁编译的问题
-include_lib("stdlib/include/ms_transform.hrl").

-include("define_logger.hrl").
-include("define_player.hrl").

-define(MAX_WAIT_TIME, 16#ffffffff). %% 监控树的等待时间，等待多少毫秒后强制关闭进程

-endif.

%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_LOG_PLAYER_MINI_HRL).
-define(DB_LOG_PLAYER_MINI_HRL, true).
%% log_player_mini => log_player_mini
-record(log_player_mini, {
          player_id = 0,                        %% 玩家id
          acc_id,                               %% 账号id
          acc_name = <<""/utf8>>,               %% 账号名字
          nick_name = <<""/utf8>>               %% 玩家名字
         }).
-endif.

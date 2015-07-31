-ifndef(DEFINE_INFO_32_HRL).
-define(DEFINE_INFO_32_HRL, true).

-include("define_info_0.hrl").


-define(INFO_NOT_GOT_ACHIEVE,                   32001).   %% 没有获得这个成就，不能领取奖励
-define(INFO_ACHIEVE_CONF_ERROR,                32002).   %% 获取成就数据失败
-define(INFO_RECEIVE_ACHIEVE_REWARD_ERROR,      32003).   %% 领取奖励失败
-define(INFO_RECEIVE_ACHIEVE_REWARD_SUCCESS,    32004).   %% 领取奖励成功
-define(INFO_RECEIVED_ACHIEVE_REWARD,           32005).   %% 已经领取奖励，不可再领取


-endif.


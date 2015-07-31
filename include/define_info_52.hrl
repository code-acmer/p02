-ifndef(DEFINE_INFO_52_HRL).
-define(DEFINE_INFO_52_HRL, true).

-include("define_info_0.hrl").


-define(INFO_BOSS_TIME_ERROR,                   52000).   %% 现在不是世界BOSS开放时段
-define(INFO_BOSS_SCEN_IS_BUSY,                 52001).   %% 系统繁忙，请稍候再试
-define(INFO_BOSS_ALEADY_DEAD,                  52002).   %% 世界BOSS已被击败，请明天再来
-define(INFO_QUITE_UNEXPECTED,                  52003).   %% 您异常退出了活动场景，需等待%s秒自动复活后才能重新进入
-define(INFO_REBORN_ERROR,                      52004).   %% 倒计时30秒以内才能复活
-define(INFO_FIRST_OF_WORLD_QUERY_SUCCESS,      52200).   %% 查询演兵论战状态信息成功
-define(INFO_FIRST_OF_WORLD_QUERY_FAILED,       52201).   %% 查询演兵论战状态信息失败
-define(INFO_FIRST_OF_WORLD_QUALIFY_SUCCESS,    52210).   %% 成功参与演兵论战（海选赛）
-define(INFO_FIRST_OF_WORLD_QUALIFY_FAILED,     52211).   %% 参与演兵论战（海选赛）失败
-define(INFO_FIRST_OF_WORLD_QUALIFIED,          52212).   %% 已经获取参赛资格，无法再参与海选
-define(INFO_FIRST_OF_WORLD_OUT_OF_RANGE,       52213).   %% 选位错误，无法参与海选
-define(INFO_FIRST_OF_WORLD_TIMES_OUT,          52214).   %% 今日海选次数已经使用完毕，请明日再来
-define(INFO_FIRST_OF_WORLD_COOLDOWN,           52215).   %% 海选竞技战斗发起冷却中，请稍后再尝试
-define(INFO_FIRST_OF_WORLD_NOT_IN_QUALIFY,     52216).   %% 非海选时间段内，无法参与海选战斗
-define(INFO_FIRST_OF_WORLD_UPDATE_SUCCESS,     52220).   %% 更新演兵论战数据成功
-define(INFO_FIRST_OF_WORLD_UPDATE_FAILED,      52221).   %% 更新演兵论战数据失败
-define(INFO_REPEAT_UPS_GAMBLE,                 52300).   %% 已经押注，不能再次押注
-define(INFO_UPS_GAMBLE_ERROR_PHASE,            52301).   %% 现在不是押注的阶段，请刷新游戏界面
-define(INFO_UPS_NOT_SIGN_UP_TIME,              52302).   %% 现在不是报名时间，请下次再来
-define(INFO_UPS_SIGN_UP_SUCCESS,               52303).   %% 报名成功
-define(INFO_UPS_REPEAT_SIGN_UP,                52304).   %% 你已经报名成功了，无须再次报名


-endif.


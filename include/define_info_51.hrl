-ifndef(DEFINE_INFO_51_HRL).
-define(DEFINE_INFO_51_HRL, true).

-include("define_info_0.hrl").


-define(INFO_TREASURE_INQUIRE_BAG_SUCCESS,      51000).   %% 查询宝物背包成功
-define(INFO_TREASURE_INQUIRE_BAG_FAILED,       51001).   %% 查询宝物背包失败
-define(INFO_TREASURE_INFO_FAILED,              51002).   %% 获取玩家探索信息失败
-define(INFO_TREASURE_EXPLORE_SUCCESS,          51010).   %% 探索成功
-define(INFO_TREASURE_EXPLORE_FAILED,           51011).   %% 探索失败
-define(INFO_TREASURE_EXPLORE_WRONG_TREASURE_ID,51012).   %% 错误的宝藏信息，探索失败
-define(INFO_TREASURE_FULL_OF_TEMP,             51014).   %% 临时背包空间不足，无法进行寻宝
-define(INFO_TREASURE_EXPLORE_TIMES_OUT,        51016).   %% 购买次数已经使用完毕，购买失败
-define(INFO_TREASURE_EXPLORE_WRONG_CURRENT,    51017).   %% 当前探索场景信息获取失败
-define(INFO_TREASURE_EXPLORE_WRONG_PREVIOUS,   51018).   %% 前一探索场景信息获取失败
-define(INFO_TREASURE_EXPLORE_OUT_OF_LIFE,      51019).   %% 探索生命消耗完毕，无法进行当前场景探索
-define(INFO_TREASURE_EXPLORE_DUPLICATED,       51021).   %% 该场景已经探索过了，无法再次探索
-define(INFO_TREASURE_EXPLORE_NOT_OPENED,       51022).   %% 指定的场景还未开放，无法进行探索
-define(INFO_TREASURE_EXPLORE_IN_EXPLORE,       51023).   %% 已经在当前场景探索了，无法使用元宝探索
-define(INFO_TREASURE_PICK_SUCCESS,             51030).   %% 拾取成功
-define(INFO_TREASURE_PICK_FAILED,              51031).   %% 拾取失败
-define(INFO_TREASURE_PICK_FULL_OF_BAG,         51032).   %% 包裹已满，无法拾取
-define(INFO_TREASURE_EMPTY_TEMP_BAG,           51033).   %% 临时包裹为空，不可拾取
-define(INFO_TREASURE_ADD_BAG_SUCCESS,          51040).   %% 扩充包裹成功
-define(INFO_TREASURE_ADD_BAG_FAILED,           51041).   %% 扩充包裹失败
-define(INFO_TREASURE_BAG_ALL_OPENED,           51042).   %% 所有的包裹空间均已经开启
-define(INFO_TREASURE_SWAP_SUCCESS,             51050).   %% 宝物交换成功
-define(INFO_TREASURE_SWAP_FAILED,              51051).   %% 宝物交换失败
-define(INFO_TREASURE_EXP_EXCEED,               51052).   %% 宝物经验已达上限，无法合并
-define(INFO_TREASURE_EMPTY_SOURCE,             51053).   %% 源位置为空，无法交换
-define(INFO_TREASURE_WRONG_BASE_TREASURE,      51054).   %% 错误的宝物数据，无法交换
-define(INFO_TREASURE_DISTINGUISH_FAILED,       51055).   %% 已装备有同类型的宝物，无法再装备
-define(INFO_TREASURE_SCENE_SUCCESS,            51060).   %% 探索场景成功
-define(INFO_TREASURE_SCENE_FAILED,             51061).   %% 探索场景失败
-define(INFO_TREASURE_LIFE_OUT,                 51062).   %% 生命点耗尽！暂且撤退，重新再来吧
-define(INFO_TREASURE_LIFE_COST,                51063).   %% 遇到陷阱，生命 -1
-define(INFO_TREASURE_IN,                       51064).   %% 找到宝物啦！继续向宝藏深处前进
-define(INFO_TREASURE_SCENE_SUCCESS_3,          51065).   %% 探索场景成功，且下一个场景的位置至少为3
-define(INFO_TREASURE_BUY_LIFE_SUCCESS,         51070).   %% 生命购买成功，生命 +3
-define(INFO_TREASURE_BUY_LIFE_FAILED,          51071).   %% 生命购买失败
-define(INFO_TREASURE_LIFE_BUY_TIMES_OUT,       51072).   %% 生命购买次数已经使用完毕
-define(INFO_TREASURE_LIFE_TOO_HIGH,            51073).   %% 生命值高于5，无需购买
-define(INFO_TREASURE_BATCH_VIP_LOWER,          51074).   %% vip等级不足，无法使用一键寻宝功能
-define(INFO_TREASURE_REWARD_FAILED,            51080).   %% 获取宝物奖励失败
-define(INFO_TREASURE_FULL_OF_BAG,              51081).   %% 包裹已满，无法获取奖励
-define(INFO_TREASURE_NOT_OPEN_REWARD_FAILED,   51082).   %% 宝物功能尚未开放，无法获得奖励


-endif.


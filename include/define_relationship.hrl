
-ifndef(DEFINE_RELATIONSHIP_HRL).
-define(DEFINE_RELATIONSHIP_HRL, true).

%% @File 关系宏定义
%% @spec
%% @end

-define(RELATIONSHIP_STRANGE,       0).       %% 陌生人
-define(RELATIONSHIP_FRIENDS,       1).       %% 互为好友

%% 仇人的最大数量
-define(MAX_NUMBER_OF_ENEMY,     30).       %% 仇人的最大数量

-define(DEBUG_RELA(Format, Args), 
        ?DEBUG("Relationship debug: " ++ Format, Args)).

%% 竞技场仇人等级过滤条件，上下10级
-define(ARENA_ENEMY_LV, 10).

%% 普通好友与特别关注好友
-define(FRIEND_NORMAL,   0).
-define(FRIEND_SPECIAL,  1).

%% 记录到推荐好友的最低等级
-define(FRIEND_MIN_LV, 5).
%% 友情值
-define(FRIEND_POINT_STRANGER, 5).
-define(FRIEND_POINT_FRIEND,   10).

%% @doc 好友信息列表	
%% relationship
-record(relationship, 
        {
          id = 0,               %% unique key
          version = relationship_version:current_version(),
          sid = 0,              %% 自己的id
          tid = 0,              %% 目标好友的id
          as_cd = 0,            %% 获得协助的冷却时间
          fp_cd = 0,            %% 获取友情点的冷却时间
          sp    = 0,            %% 特别关注
          rela  = 0,            %% 与B的关系(0: 已删除 1: 好友 2: 已申请 3: 待确认)
          time_form = 0,        %% 建交时间
          dirty = 0             %% 缓存状态
        }).

-endif.


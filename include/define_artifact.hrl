%% 法宝数据的宏定义

-ifndef(DEFINE_ARTIFACT_HRL).
-define(DEFINE_ARTIFACT_HRL, true).

-include("db_base_artifact.hrl").
-include("define_goods.hrl").
-include("pb_54_pb.hrl").

-define(ETS_BASE_ARTIFACT, ets_base_artifact).

-define(ARTIFACT_LIST_LENGTH, 30).

%% 法宝ID编号列表
-define(ARTIFACTBIASLIST, 
        [   0,  100,  200,  300,  400,  500,  600,  700,  800,  900,
         1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900,
         2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800, 2900]).

%% 法宝初始ID
-define(ARTIFACTINITNUM, 81102100).

%% 所有阶的法宝初始列表
-define(INITARTIFACTIDS, lists:map(fun(XX) ->
                                           ?ARTIFACTINITNUM + XX
                                   end, ?ARTIFACTBIASLIST)).

%% 默认的 base_list 数据
-define(DEFAULT_BASE_LIST, 
        [undefined, undefined, undefined, undefined, undefined,
         undefined, undefined, undefined, undefined, undefined]).

-endif.


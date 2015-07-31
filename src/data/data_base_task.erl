%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_task).
-export([get/1]).
-export([all/0]).
-export([get_task_but_main/0]).
-include("common.hrl").
-include("db_base_task.hrl").
get(1000001) ->
#base_task{id = 1000001,name = <<"普通 · 车站边界"/utf8>>,desc = <<"通关普通难度 车站边界 一次"/utf8>>,type = 1,subtype = 10,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1100011,1,0,0},func = <<"[1,1100011]"/utf8>>,reward = [{20,258},{3,102},{240100101,1}],next = 1000002,give_up = 0,double_time = [],liveness_reward = 0};
get(1000002) ->
#base_task{id = 1000002,name = <<"普通 · 车站月台"/utf8>>,desc = <<"通关普通难度 车站月台 一次"/utf8>>,type = 1,subtype = 10,previous = 1000001,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1100021,1,0,0},func = <<"[1,1100021]"/utf8>>,reward = [{20,474},{250200101,1},{22200015,1}],next = 1000003,give_up = 0,double_time = [],liveness_reward = 0};
get(1000003) ->
#base_task{id = 1000003,name = <<"普通 · 新干线列车顶"/utf8>>,desc = <<"通关普通难度 新干线列车顶 一次"/utf8>>,type = 1,subtype = 10,previous = 1000002,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1100031,1,0,0},func = <<"[1,1100031]"/utf8>>,reward = [{20,663},{3,500},{240100101,2}],next = 1000004,give_up = 0,double_time = [],liveness_reward = 0};
get(1000004) ->
#base_task{id = 1000004,name = <<"普通 · 飞驰的湖面"/utf8>>,desc = <<"通关普通难度 飞驰的湖面 一次"/utf8>>,type = 1,subtype = 10,previous = 1000003,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1100041,1,0,0},func = <<"[1,1100041]"/utf8>>,reward = [{20,833},{3,361},{90101000,10},{90201000,10},{300002,16}],next = 1000005,give_up = 0,double_time = [],liveness_reward = 0};
get(1000005) ->
#base_task{id = 1000005,name = <<"普通 · 新干线列车头"/utf8>>,desc = <<"通关普通难度 新干线列车头 一次"/utf8>>,type = 1,subtype = 10,previous = 1000004,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1100051,1,0,0},func = <<"[1,1100051]"/utf8>>,reward = [{20,952},{22110115,1},{22120115,1},{240100101,2}],next = 1000006,give_up = 0,double_time = [],liveness_reward = 0};
get(1000006) ->
#base_task{id = 1000006,name = <<"普通 · 环城高速"/utf8>>,desc = <<"通关普通难度 环城高速 一次"/utf8>>,type = 1,subtype = 10,previous = 1000005,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1101011,1,0,0},func = <<"[1,1101011]"/utf8>>,reward = [{20,1050},{3,487},{6,200}],next = 1000007,give_up = 0,double_time = [],liveness_reward = 0};
get(1000007) ->
#base_task{id = 1000007,name = <<"普通 · 外环公路"/utf8>>,desc = <<"通关普通难度 外环公路 一次"/utf8>>,type = 1,subtype = 10,previous = 1000006,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1101021,1,0,0},func = <<"[1,1101021]"/utf8>>,reward = [{20,1200},{90103000,5},{90203000,5},{22200115,1}],next = 1000008,give_up = 0,double_time = [],liveness_reward = 0};
get(1000008) ->
#base_task{id = 1000008,name = <<"普通 · 乡镇街道"/utf8>>,desc = <<"通关普通难度 乡镇街道 一次"/utf8>>,type = 1,subtype = 10,previous = 1000007,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1101031,1,0,0},func = <<"[1,1101031]"/utf8>>,reward = [{20,1360},{3,583},{280113,10}],next = 1000009,give_up = 0,double_time = [],liveness_reward = 0};
get(1000009) ->
#base_task{id = 1000009,name = <<"普通 · 街道中心"/utf8>>,desc = <<"通关普通难度 街道中心 一次"/utf8>>,type = 1,subtype = 10,previous = 1000008,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1101041,1,0,0},func = <<"[1,1101041]"/utf8>>,reward = [{20,1550},{22300115,1},{90102000,5},{90202000,5}],next = 1000010,give_up = 0,double_time = [],liveness_reward = 0};
get(1000010) ->
#base_task{id = 1000010,name = <<"普通 · 街区闹市"/utf8>>,desc = <<"通关普通难度 街区闹市 一次"/utf8>>,type = 1,subtype = 10,previous = 1000009,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1101051,1,0,0},func = <<"[1,1101051]"/utf8>>,reward = [{20,1800},{22400115,1},{280108,1}],next = 1000011,give_up = 0,double_time = [],liveness_reward = 0};
get(1000011) ->
#base_task{id = 1000011,name = <<"普通 · 暴力街区"/utf8>>,desc = <<"通关普通难度 暴力街区 一次"/utf8>>,type = 1,subtype = 10,previous = 1000010,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1101061,1,0,0},func = <<"[1,1101061]"/utf8>>,reward = [{20,1840},{7,500},{22110213,1},{22120213,1}],next = 1000012,give_up = 0,double_time = [],liveness_reward = 0};
get(1000012) ->
#base_task{id = 1000012,name = <<"普通 · 朗德渔港"/utf8>>,desc = <<"通关普通难度 朗德渔港 一次"/utf8>>,type = 1,subtype = 10,previous = 1000011,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102011,1,0,0},func = <<"[1,1102011]"/utf8>>,reward = [{20,1951},{22500213,1},{280101,10}],next = 1000013,give_up = 0,double_time = [],liveness_reward = 0};
get(1000013) ->
#base_task{id = 1000013,name = <<"普通 · 繁华商业街"/utf8>>,desc = <<"通关普通难度 繁华商业街 一次"/utf8>>,type = 1,subtype = 10,previous = 1000012,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102021,1,0,0},func = <<"[1,1102021]"/utf8>>,reward = [{20,2030},{3,700},{270201,3}],next = 1000014,give_up = 0,double_time = [],liveness_reward = 0};
get(1000014) ->
#base_task{id = 1000014,name = <<"普通 · 城市中心花园"/utf8>>,desc = <<"通关普通难度 城市中心花园 一次"/utf8>>,type = 1,subtype = 10,previous = 1000013,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102031,1,0,0},func = <<"[1,1102031]"/utf8>>,reward = [{20,2205},{240100101,3},{22400213,1}],next = 1000015,give_up = 0,double_time = [],liveness_reward = 0};
get(1000015) ->
#base_task{id = 1000015,name = <<"普通 · 寂静夜晚街道"/utf8>>,desc = <<"通关普通难度 寂静夜晚街道 一次"/utf8>>,type = 1,subtype = 10,previous = 1000014,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102041,1,0,0},func = <<"[1,1102041]"/utf8>>,reward = [{20,2354},{3,962},{280113,50}],next = 1000016,give_up = 0,double_time = [],liveness_reward = 0};
get(1000016) ->
#base_task{id = 1000016,name = <<"普通 · 阴暗下水道"/utf8>>,desc = <<"通关普通难度 阴暗下水道 一次"/utf8>>,type = 1,subtype = 10,previous = 1000015,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102051,1,0,0},func = <<"[1,1102051]"/utf8>>,reward = [{20,2402},{280113,36},{280101,36}],next = 1000017,give_up = 0,double_time = [],liveness_reward = 0};
get(1000017) ->
#base_task{id = 1000017,name = <<"普通 · 下水道深处"/utf8>>,desc = <<"通关普通难度 下水道深处 一次"/utf8>>,type = 1,subtype = 10,previous = 1000016,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102061,1,0,0},func = <<"[1,1102061]"/utf8>>,reward = [{20,2558},{3,1459},{240100101,6}],next = 1000018,give_up = 0,double_time = [],liveness_reward = 0};
get(1000018) ->
#base_task{id = 1000018,name = <<"普通 · 南部海港码头"/utf8>>,desc = <<"通关普通难度 南部海港码头 一次"/utf8>>,type = 1,subtype = 10,previous = 1000017,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102071,1,0,0},func = <<"[1,1102071]"/utf8>>,reward = [{20,2602},{3,1469},{240100101,6}],next = 1000019,give_up = 0,double_time = [],liveness_reward = 0};
get(1000019) ->
#base_task{id = 1000019,name = <<"普通 · 码头内部"/utf8>>,desc = <<"通关普通难度 码头内部 一次"/utf8>>,type = 1,subtype = 10,previous = 1000018,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102081,1,0,0},func = <<"[1,1102081]"/utf8>>,reward = [{20,2700},{3,1516},{240100101,7}],next = 1000020,give_up = 0,double_time = [],liveness_reward = 0};
get(1000020) ->
#base_task{id = 1000020,name = <<"普通 · 码头黄昏"/utf8>>,desc = <<"通关普通难度 码头黄昏 一次"/utf8>>,type = 1,subtype = 10,previous = 1000019,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102091,1,0,0},func = <<"[1,1102091]"/utf8>>,reward = [{20,2880},{3,1519},{240100101,7}],next = 1000021,give_up = 0,double_time = [],liveness_reward = 0};
get(1000021) ->
#base_task{id = 1000021,name = <<"普通 · 钢炼工厂"/utf8>>,desc = <<"通关普通难度 钢炼工厂 一次"/utf8>>,type = 1,subtype = 10,previous = 1000020,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102101,1,0,0},func = <<"[1,1102101]"/utf8>>,reward = [{20,2900},{3,1532},{240100101,7}],next = 1000022,give_up = 0,double_time = [],liveness_reward = 0};
get(1000022) ->
#base_task{id = 1000022,name = <<"普通 · 雨林树村"/utf8>>,desc = <<"通关普通难度 雨林树村 一次"/utf8>>,type = 1,subtype = 10,previous = 1000021,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103011,1,0,0},func = <<"[1,1103011]"/utf8>>,reward = [{20,3061},{3,1515},{240100101,7}],next = 1000023,give_up = 0,double_time = [],liveness_reward = 0};
get(1000023) ->
#base_task{id = 1000023,name = <<"普通 · 树村深处"/utf8>>,desc = <<"通关普通难度 树村深处 一次"/utf8>>,type = 1,subtype = 10,previous = 1000022,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103021,1,0,0},func = <<"[1,1103021]"/utf8>>,reward = [{20,3163},{3,1506},{240100101,7}],next = 1000024,give_up = 0,double_time = [],liveness_reward = 0};
get(1000024) ->
#base_task{id = 1000024,name = <<"普通 · 植物实验基地"/utf8>>,desc = <<"通关普通难度 植物实验基地 一次"/utf8>>,type = 1,subtype = 10,previous = 1000023,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103031,1,0,0},func = <<"[1,1103031]"/utf8>>,reward = [{20,3307},{3,1504},{240100101,7}],next = 1000025,give_up = 0,double_time = [],liveness_reward = 0};
get(1000025) ->
#base_task{id = 1000025,name = <<"普通 · 实验基地内部"/utf8>>,desc = <<"通关普通难度 实验基地内部 一次"/utf8>>,type = 1,subtype = 10,previous = 1000024,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103041,1,0,0},func = <<"[1,1103041]"/utf8>>,reward = [{20,3490},{3,1508},{240100101,7}],next = 1000026,give_up = 0,double_time = [],liveness_reward = 0};
get(1000026) ->
#base_task{id = 1000026,name = <<"普通 · 诡异实验室"/utf8>>,desc = <<"通关普通难度 诡异实验室 一次"/utf8>>,type = 1,subtype = 10,previous = 1000025,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103051,1,0,0},func = <<"[1,1103051]"/utf8>>,reward = [{20,3714},{3,1512},{240100101,8}],next = 1000027,give_up = 0,double_time = [],liveness_reward = 0};
get(1000027) ->
#base_task{id = 1000027,name = <<"普通 · 恐怖研究院"/utf8>>,desc = <<"通关普通难度 恐怖研究院 一次"/utf8>>,type = 1,subtype = 10,previous = 1000026,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103061,1,0,0},func = <<"[1,1103061]"/utf8>>,reward = [{20,3978},{3,1516},{240100101,8}],next = 1000028,give_up = 0,double_time = [],liveness_reward = 0};
get(1000028) ->
#base_task{id = 1000028,name = <<"普通 · 阴暗墓地"/utf8>>,desc = <<"通关普通难度 阴暗墓地 一次"/utf8>>,type = 1,subtype = 10,previous = 1000027,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103071,1,0,0},func = <<"[1,1103071]"/utf8>>,reward = [{20,4279},{3,1623},{240100101,8}],next = 1000029,give_up = 0,double_time = [],liveness_reward = 0};
get(1000029) ->
#base_task{id = 1000029,name = <<"普通 · 送葬者之路"/utf8>>,desc = <<"通关普通难度 送葬者之路 一次"/utf8>>,type = 1,subtype = 10,previous = 1000028,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103081,1,0,0},func = <<"[1,1103081]"/utf8>>,reward = [{20,4617},{3,1747},{240100101,8}],next = 1000030,give_up = 0,double_time = [],liveness_reward = 0};
get(1000030) ->
#base_task{id = 1000030,name = <<"普通 · 冰冷实验室"/utf8>>,desc = <<"通关普通难度 冰冷实验室 一次"/utf8>>,type = 1,subtype = 10,previous = 1000029,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103091,1,0,0},func = <<"[1,1103091]"/utf8>>,reward = [{20,4990},{3,1888},{240100101,9}],next = 1000031,give_up = 0,double_time = [],liveness_reward = 0};
get(1000031) ->
#base_task{id = 1000031,name = <<"普通 · 严寒研究院"/utf8>>,desc = <<"通关普通难度 严寒研究院 一次"/utf8>>,type = 1,subtype = 10,previous = 1000030,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103101,1,0,0},func = <<"[1,1103101]"/utf8>>,reward = [{20,5396},{3,1948},{240100101,9}],next = 1000032,give_up = 0,double_time = [],liveness_reward = 0};
get(1000032) ->
#base_task{id = 1000032,name = <<"普通 · 沙漠集市"/utf8>>,desc = <<"通关普通难度 沙漠集市 一次"/utf8>>,type = 1,subtype = 10,previous = 1000031,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104011,1,0,0},func = <<"[1,1104011]"/utf8>>,reward = [{20,5832},{3,2130},{240100101,9}],next = 1000033,give_up = 0,double_time = [],liveness_reward = 0};
get(1000033) ->
#base_task{id = 1000033,name = <<"普通 · 非洲草原"/utf8>>,desc = <<"通关普通难度 非洲草原 一次"/utf8>>,type = 1,subtype = 10,previous = 1000032,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104021,1,0,0},func = <<"[1,1104021]"/utf8>>,reward = [{20,6295},{3,1883},{240100101,10}],next = 1000034,give_up = 0,double_time = [],liveness_reward = 0};
get(1000034) ->
#base_task{id = 1000034,name = <<"普通 · 草原夜晚"/utf8>>,desc = <<"通关普通难度 草原夜晚 一次"/utf8>>,type = 1,subtype = 10,previous = 1000033,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104031,1,0,0},func = <<"[1,1104031]"/utf8>>,reward = [{20,6781},{3,2109},{240100101,11}],next = 1000035,give_up = 0,double_time = [],liveness_reward = 0};
get(1000035) ->
#base_task{id = 1000035,name = <<"普通 · 灼热沙漠"/utf8>>,desc = <<"通关普通难度 灼热沙漠 一次"/utf8>>,type = 1,subtype = 10,previous = 1000034,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104041,1,0,0},func = <<"[1,1104041]"/utf8>>,reward = [{20,7287},{3,2361},{240100101,12}],next = 1000036,give_up = 0,double_time = [],liveness_reward = 0};
get(1000036) ->
#base_task{id = 1000036,name = <<"普通 · 沙漠夜晚"/utf8>>,desc = <<"通关普通难度 沙漠夜晚 一次"/utf8>>,type = 1,subtype = 10,previous = 1000035,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104051,1,0,0},func = <<"[1,1104051]"/utf8>>,reward = [{20,7807},{3,2639},{240100101,14}],next = 1000037,give_up = 0,double_time = [],liveness_reward = 0};
get(1000037) ->
#base_task{id = 1000037,name = <<"普通 · 沙漠村庄"/utf8>>,desc = <<"通关普通难度 沙漠村庄 一次"/utf8>>,type = 1,subtype = 10,previous = 1000036,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104061,1,0,0},func = <<"[1,1104061]"/utf8>>,reward = [{20,8337},{3,2947},{240100101,15}],next = 1000038,give_up = 0,double_time = [],liveness_reward = 0};
get(1000038) ->
#base_task{id = 1000038,name = <<"普通 · 沙漠遗迹"/utf8>>,desc = <<"通关普通难度 沙漠遗迹 一次"/utf8>>,type = 1,subtype = 10,previous = 1000037,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104071,1,0,0},func = <<"[1,1104071]"/utf8>>,reward = [{20,8869},{3,3285},{240100101,17}],next = 1000039,give_up = 0,double_time = [],liveness_reward = 0};
get(1000039) ->
#base_task{id = 1000039,name = <<"普通 · 金字塔外围"/utf8>>,desc = <<"通关普通难度 金字塔外围 一次"/utf8>>,type = 1,subtype = 10,previous = 1000038,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104081,1,0,0},func = <<"[1,1104081]"/utf8>>,reward = [{20,9399},{3,3655},{240100101,19}],next = 1000040,give_up = 0,double_time = [],liveness_reward = 0};
get(1000040) ->
#base_task{id = 1000040,name = <<"普通 · 金字塔内部"/utf8>>,desc = <<"通关普通难度 金字塔内部 一次"/utf8>>,type = 1,subtype = 10,previous = 1000039,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104091,1,0,0},func = <<"[1,1104091]"/utf8>>,reward = [{20,9919},{3,4060},{240100101,21}],next = 1000041,give_up = 0,double_time = [],liveness_reward = 0};
get(1000041) ->
#base_task{id = 1000041,name = <<"普通 · 法老陵墓"/utf8>>,desc = <<"通关普通难度 法老陵墓 一次"/utf8>>,type = 1,subtype = 10,previous = 1000040,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104101,1,0,0},func = <<"[1,1104101]"/utf8>>,reward = [{20,10419},{3,4501},{240100101,23}],next = 1000042,give_up = 0,double_time = [],liveness_reward = 0};
get(1000042) ->
#base_task{id = 1000042,name = <<"普通 · 贫民区"/utf8>>,desc = <<"通关普通难度 贫民区 一次"/utf8>>,type = 1,subtype = 10,previous = 1000041,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105011,1,0,0},func = <<"[1,1105011]"/utf8>>,reward = [{20,10891},{3,4982},{240100101,25}],next = 1000043,give_up = 0,double_time = [],liveness_reward = 0};
get(1000043) ->
#base_task{id = 1000043,name = <<"普通 · 暴力黑帮街头"/utf8>>,desc = <<"通关普通难度 暴力黑帮街头 一次"/utf8>>,type = 1,subtype = 10,previous = 1000042,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105021,1,0,0},func = <<"[1,1105021]"/utf8>>,reward = [{20,11325},{3,5505},{240100101,28}],next = 1000044,give_up = 0,double_time = [],liveness_reward = 0};
get(1000044) ->
#base_task{id = 1000044,name = <<"普通 · 城市外围地区"/utf8>>,desc = <<"通关普通难度 城市外围地区 一次"/utf8>>,type = 1,subtype = 10,previous = 1000043,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105031,1,0,0},func = <<"[1,1105031]"/utf8>>,reward = [{20,24604},{3,12756},{240100101,64}],next = 1000045,give_up = 0,double_time = [],liveness_reward = 0};
get(1000045) ->
#base_task{id = 1000045,name = <<"普通 · 城市中心地区"/utf8>>,desc = <<"通关普通难度 城市中心地区 一次"/utf8>>,type = 1,subtype = 10,previous = 1000044,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105041,1,0,0},func = <<"[1,1105041]"/utf8>>,reward = [{20,29726},{3,15412},{240100101,77}],next = 1000046,give_up = 0,double_time = [],liveness_reward = 0};
get(1000046) ->
#base_task{id = 1000046,name = <<"普通 · 大型升降梯"/utf8>>,desc = <<"通关普通难度 大型升降梯 一次"/utf8>>,type = 1,subtype = 10,previous = 1000045,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105051,1,0,0},func = <<"[1,1105051]"/utf8>>,reward = [{20,35685},{3,18503},{240100101,93}],next = 1000047,give_up = 0,double_time = [],liveness_reward = 0};
get(1000047) ->
#base_task{id = 1000047,name = <<"普通 · 潜入指挥中心"/utf8>>,desc = <<"通关普通难度 潜入指挥中心 一次"/utf8>>,type = 1,subtype = 10,previous = 1000046,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105061,1,0,0},func = <<"[1,1105061]"/utf8>>,reward = [{20,42584},{3,22079},{240100101,111}],next = 1000048,give_up = 0,double_time = [],liveness_reward = 0};
get(1000048) ->
#base_task{id = 1000048,name = <<"普通 · 西部国道公路"/utf8>>,desc = <<"通关普通难度 西部国道公路 一次"/utf8>>,type = 1,subtype = 10,previous = 1000047,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105071,1,0,0},func = <<"[1,1105071]"/utf8>>,reward = [{20,50532},{3,26201},{240100101,131}],next = 1000049,give_up = 0,double_time = [],liveness_reward = 0};
get(1000049) ->
#base_task{id = 1000049,name = <<"普通 · 火车顶遭遇"/utf8>>,desc = <<"通关普通难度 火车顶遭遇 一次"/utf8>>,type = 1,subtype = 10,previous = 1000048,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105081,1,0,0},func = <<"[1,1105081]"/utf8>>,reward = [{20,59656},{3,30932},{240100101,155}],next = 1000050,give_up = 0,double_time = [],liveness_reward = 0};
get(1000050) ->
#base_task{id = 1000050,name = <<"普通 · 运河大铁桥"/utf8>>,desc = <<"通关普通难度 运河大铁桥 一次"/utf8>>,type = 1,subtype = 10,previous = 1000049,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105091,1,0,0},func = <<"[1,1105091]"/utf8>>,reward = [{20,70088},{3,36342},{240100101,182}],next = 1000051,give_up = 0,double_time = [],liveness_reward = 0};
get(1000051) ->
#base_task{id = 1000051,name = <<"普通 · 航空母舰"/utf8>>,desc = <<"通关普通难度 航空母舰 一次"/utf8>>,type = 1,subtype = 10,previous = 1000050,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105101,1,0,0},func = <<"[1,1105101]"/utf8>>,reward = [{20,81980},{3,42508},{240100101,213}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(1010001) ->
#base_task{id = 1010001,name = <<"冒险 · 外环公路"/utf8>>,desc = <<"通关冒险难度 外环公路 一次"/utf8>>,type = 1,subtype = 11,previous = 0,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1101022,1,0,0},func = <<"[1,1101022]"/utf8>>,reward = [{20,246},{280113,2},{3,200},{240100101,3}],next = 1010002,give_up = 0,double_time = [],liveness_reward = 0};
get(1010002) ->
#base_task{id = 1010002,name = <<"冒险 · 暴力街区"/utf8>>,desc = <<"通关冒险难度 暴力街区 一次"/utf8>>,type = 1,subtype = 11,previous = 1010001,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1101062,1,0,0},func = <<"[1,1101062]"/utf8>>,reward = [{20,346},{280113,3},{3,300},{22200223,1}],next = 1010003,give_up = 0,double_time = [],liveness_reward = 0};
get(1010003) ->
#base_task{id = 1010003,name = <<"冒险 · 朗德渔港"/utf8>>,desc = <<"通关冒险难度 朗德渔港 一次"/utf8>>,type = 1,subtype = 11,previous = 1010002,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102012,1,0,0},func = <<"[1,1102012]"/utf8>>,reward = [{20,546},{280113,4},{90102000,5},{90202000,5}],next = 1010004,give_up = 0,double_time = [],liveness_reward = 0};
get(1010004) ->
#base_task{id = 1010004,name = <<"冒险 · 繁华商业街"/utf8>>,desc = <<"通关冒险难度 繁华商业街 一次"/utf8>>,type = 1,subtype = 11,previous = 1010003,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102022,1,0,0},func = <<"[1,1102022]"/utf8>>,reward = [{20,594},{280113,5},{3,505},{22300223,1}],next = 1010005,give_up = 0,double_time = [],liveness_reward = 0};
get(1010005) ->
#base_task{id = 1010005,name = <<"冒险 · 城市中心花园"/utf8>>,desc = <<"通关冒险难度 城市中心花园 一次"/utf8>>,type = 1,subtype = 11,previous = 1010004,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102032,1,0,0},func = <<"[1,1102032]"/utf8>>,reward = [{20,638},{280113,2},{90111000,5},{90211000,5},{22400223,1}],next = 1010006,give_up = 0,double_time = [],liveness_reward = 0};
get(1010006) ->
#base_task{id = 1010006,name = <<"冒险 · 寂静夜晚街道"/utf8>>,desc = <<"通关冒险难度 寂静夜晚街道 一次"/utf8>>,type = 1,subtype = 11,previous = 1010005,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102042,1,0,0},func = <<"[1,1102042]"/utf8>>,reward = [{20,669},{280113,1},{3,576},{240100101,3}],next = 1010007,give_up = 0,double_time = [],liveness_reward = 0};
get(1010007) ->
#base_task{id = 1010007,name = <<"冒险 · 阴暗下水道"/utf8>>,desc = <<"通关冒险难度 阴暗下水道 一次"/utf8>>,type = 1,subtype = 11,previous = 1010006,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102052,1,0,0},func = <<"[1,1102052]"/utf8>>,reward = [{20,705},{280113,4},{3,601},{240100101,3}],next = 1010008,give_up = 0,double_time = [],liveness_reward = 0};
get(1010008) ->
#base_task{id = 1010008,name = <<"冒险 · 下水道深处"/utf8>>,desc = <<"通关冒险难度 下水道深处 一次"/utf8>>,type = 1,subtype = 11,previous = 1010007,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102062,1,0,0},func = <<"[1,1102062]"/utf8>>,reward = [{20,722},{280113,4},{3,625},{240100101,3}],next = 1010009,give_up = 0,double_time = [],liveness_reward = 0};
get(1010009) ->
#base_task{id = 1010009,name = <<"冒险 · 南部海港码头"/utf8>>,desc = <<"通关冒险难度 南部海港码头 一次"/utf8>>,type = 1,subtype = 11,previous = 1010008,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102072,1,0,0},func = <<"[1,1102072]"/utf8>>,reward = [{20,747},{280113,5},{3,629},{240100101,3}],next = 1010010,give_up = 0,double_time = [],liveness_reward = 0};
get(1010010) ->
#base_task{id = 1010010,name = <<"冒险 · 码头内部"/utf8>>,desc = <<"通关冒险难度 码头内部 一次"/utf8>>,type = 1,subtype = 11,previous = 1010009,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102082,1,0,0},func = <<"[1,1102082]"/utf8>>,reward = [{20,773},{280113,5},{3,649},{240100101,3}],next = 1010011,give_up = 0,double_time = [],liveness_reward = 0};
get(1010011) ->
#base_task{id = 1010011,name = <<"冒险 · 码头黄昏"/utf8>>,desc = <<"通关冒险难度 码头黄昏 一次"/utf8>>,type = 1,subtype = 11,previous = 1010010,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102092,1,0,0},func = <<"[1,1102092]"/utf8>>,reward = [{20,794},{280113,5},{3,651},{240100101,3}],next = 1010012,give_up = 0,double_time = [],liveness_reward = 0};
get(1010012) ->
#base_task{id = 1010012,name = <<"冒险 · 钢炼工厂"/utf8>>,desc = <<"通关冒险难度 钢炼工厂 一次"/utf8>>,type = 1,subtype = 11,previous = 1010011,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102102,1,0,0},func = <<"[1,1102102]"/utf8>>,reward = [{20,800},{280113,5},{3,656},{240100101,3}],next = 1010013,give_up = 0,double_time = [],liveness_reward = 0};
get(1010013) ->
#base_task{id = 1010013,name = <<"冒险 · 雨林树村"/utf8>>,desc = <<"通关冒险难度 雨林树村 一次"/utf8>>,type = 1,subtype = 11,previous = 1010012,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103012,1,0,0},func = <<"[1,1103012]"/utf8>>,reward = [{20,816},{280113,5},{3,649},{240100101,3}],next = 1010014,give_up = 0,double_time = [],liveness_reward = 0};
get(1010014) ->
#base_task{id = 1010014,name = <<"冒险 · 树村深处"/utf8>>,desc = <<"通关冒险难度 树村深处 一次"/utf8>>,type = 1,subtype = 11,previous = 1010013,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103022,1,0,0},func = <<"[1,1103022]"/utf8>>,reward = [{20,843},{280113,6},{3,645},{240100101,3}],next = 1010015,give_up = 0,double_time = [],liveness_reward = 0};
get(1010015) ->
#base_task{id = 1010015,name = <<"冒险 · 植物实验基地"/utf8>>,desc = <<"通关冒险难度 植物实验基地 一次"/utf8>>,type = 1,subtype = 11,previous = 1010014,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103032,1,0,0},func = <<"[1,1103032]"/utf8>>,reward = [{20,881},{280113,6},{3,644},{240100101,3}],next = 1010016,give_up = 0,double_time = [],liveness_reward = 0};
get(1010016) ->
#base_task{id = 1010016,name = <<"冒险 · 实验基地内部"/utf8>>,desc = <<"通关冒险难度 实验基地内部 一次"/utf8>>,type = 1,subtype = 11,previous = 1010015,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103042,1,0,0},func = <<"[1,1103042]"/utf8>>,reward = [{20,930},{280113,7},{3,646},{240100101,3}],next = 1010017,give_up = 0,double_time = [],liveness_reward = 0};
get(1010017) ->
#base_task{id = 1010017,name = <<"冒险 · 诡异实验室"/utf8>>,desc = <<"通关冒险难度 诡异实验室 一次"/utf8>>,type = 1,subtype = 11,previous = 1010016,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103052,1,0,0},func = <<"[1,1103052]"/utf8>>,reward = [{20,990},{280113,7},{3,648},{240100101,4}],next = 1010018,give_up = 0,double_time = [],liveness_reward = 0};
get(1010018) ->
#base_task{id = 1010018,name = <<"冒险 · 恐怖研究院"/utf8>>,desc = <<"通关冒险难度 恐怖研究院 一次"/utf8>>,type = 1,subtype = 11,previous = 1010017,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103062,1,0,0},func = <<"[1,1103062]"/utf8>>,reward = [{20,1060},{280113,8},{3,649},{240100101,4}],next = 1010019,give_up = 0,double_time = [],liveness_reward = 0};
get(1010019) ->
#base_task{id = 1010019,name = <<"冒险 · 阴暗墓地"/utf8>>,desc = <<"通关冒险难度 阴暗墓地 一次"/utf8>>,type = 1,subtype = 11,previous = 1010018,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103072,1,0,0},func = <<"[1,1103072]"/utf8>>,reward = [{20,1141},{280113,8},{3,695},{240100101,4}],next = 1010020,give_up = 0,double_time = [],liveness_reward = 0};
get(1010020) ->
#base_task{id = 1010020,name = <<"冒险 · 送葬者之路"/utf8>>,desc = <<"通关冒险难度 送葬者之路 一次"/utf8>>,type = 1,subtype = 11,previous = 1010019,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103082,1,0,0},func = <<"[1,1103082]"/utf8>>,reward = [{20,1231},{280113,9},{3,748},{240100101,4}],next = 1010021,give_up = 0,double_time = [],liveness_reward = 0};
get(1010021) ->
#base_task{id = 1010021,name = <<"冒险 · 冰冷实验室"/utf8>>,desc = <<"通关冒险难度 冰冷实验室 一次"/utf8>>,type = 1,subtype = 11,previous = 1010020,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103092,1,0,0},func = <<"[1,1103092]"/utf8>>,reward = [{20,1330},{280113,10},{3,809},{240100101,4}],next = 1010022,give_up = 0,double_time = [],liveness_reward = 0};
get(1010022) ->
#base_task{id = 1010022,name = <<"冒险 · 严寒研究院"/utf8>>,desc = <<"通关冒险难度 严寒研究院 一次"/utf8>>,type = 1,subtype = 11,previous = 1010021,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103102,1,0,0},func = <<"[1,1103102]"/utf8>>,reward = [{20,1438},{280113,11},{3,834},{240100101,4}],next = 1010023,give_up = 0,double_time = [],liveness_reward = 0};
get(1010023) ->
#base_task{id = 1010023,name = <<"冒险 · 沙漠集市"/utf8>>,desc = <<"通关冒险难度 沙漠集市 一次"/utf8>>,type = 1,subtype = 11,previous = 1010022,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104012,1,0,0},func = <<"[1,1104012]"/utf8>>,reward = [{20,1555},{280113,12},{3,912},{240100101,4}],next = 1010024,give_up = 0,double_time = [],liveness_reward = 0};
get(1010024) ->
#base_task{id = 1010024,name = <<"冒险 · 非洲草原"/utf8>>,desc = <<"通关冒险难度 非洲草原 一次"/utf8>>,type = 1,subtype = 11,previous = 1010023,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104022,1,0,0},func = <<"[1,1104022]"/utf8>>,reward = [{20,1678},{280113,14},{3,807},{240100101,5}],next = 1010025,give_up = 0,double_time = [],liveness_reward = 0};
get(1010025) ->
#base_task{id = 1010025,name = <<"冒险 · 草原夜晚"/utf8>>,desc = <<"通关冒险难度 草原夜晚 一次"/utf8>>,type = 1,subtype = 11,previous = 1010024,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104032,1,0,0},func = <<"[1,1104032]"/utf8>>,reward = [{20,1808},{280113,15},{3,903},{240100101,5}],next = 1010026,give_up = 0,double_time = [],liveness_reward = 0};
get(1010026) ->
#base_task{id = 1010026,name = <<"冒险 · 灼热沙漠"/utf8>>,desc = <<"通关冒险难度 灼热沙漠 一次"/utf8>>,type = 1,subtype = 11,previous = 1010025,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104042,1,0,0},func = <<"[1,1104042]"/utf8>>,reward = [{20,1943},{280113,17},{3,1011},{240100101,6}],next = 1010027,give_up = 0,double_time = [],liveness_reward = 0};
get(1010027) ->
#base_task{id = 1010027,name = <<"冒险 · 沙漠夜晚"/utf8>>,desc = <<"通关冒险难度 沙漠夜晚 一次"/utf8>>,type = 1,subtype = 11,previous = 1010026,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104052,1,0,0},func = <<"[1,1104052]"/utf8>>,reward = [{20,2081},{280113,18},{3,1131},{240100101,6}],next = 1010028,give_up = 0,double_time = [],liveness_reward = 0};
get(1010028) ->
#base_task{id = 1010028,name = <<"冒险 · 沙漠村庄"/utf8>>,desc = <<"通关冒险难度 沙漠村庄 一次"/utf8>>,type = 1,subtype = 11,previous = 1010027,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104062,1,0,0},func = <<"[1,1104062]"/utf8>>,reward = [{20,2223},{280113,20},{3,1263},{240100101,7}],next = 1010029,give_up = 0,double_time = [],liveness_reward = 0};
get(1010029) ->
#base_task{id = 1010029,name = <<"冒险 · 沙漠遗迹"/utf8>>,desc = <<"通关冒险难度 沙漠遗迹 一次"/utf8>>,type = 1,subtype = 11,previous = 1010028,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104072,1,0,0},func = <<"[1,1104072]"/utf8>>,reward = [{20,2365},{280113,22},{3,1407},{240100101,8}],next = 1010030,give_up = 0,double_time = [],liveness_reward = 0};
get(1010030) ->
#base_task{id = 1010030,name = <<"冒险 · 金字塔外围"/utf8>>,desc = <<"通关冒险难度 金字塔外围 一次"/utf8>>,type = 1,subtype = 11,previous = 1010029,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104082,1,0,0},func = <<"[1,1104082]"/utf8>>,reward = [{20,2506},{280113,25},{3,1566},{240100101,9}],next = 1010031,give_up = 0,double_time = [],liveness_reward = 0};
get(1010031) ->
#base_task{id = 1010031,name = <<"冒险 · 金字塔内部"/utf8>>,desc = <<"通关冒险难度 金字塔内部 一次"/utf8>>,type = 1,subtype = 11,previous = 1010030,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104092,1,0,0},func = <<"[1,1104092]"/utf8>>,reward = [{20,2645},{280113,27},{3,1740},{240100101,9}],next = 1010032,give_up = 0,double_time = [],liveness_reward = 0};
get(1010032) ->
#base_task{id = 1010032,name = <<"冒险 · 法老陵墓"/utf8>>,desc = <<"通关冒险难度 法老陵墓 一次"/utf8>>,type = 1,subtype = 11,previous = 1010031,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104102,1,0,0},func = <<"[1,1104102]"/utf8>>,reward = [{20,2778},{280113,30},{3,1929},{240100101,10}],next = 1010033,give_up = 0,double_time = [],liveness_reward = 0};
get(1010033) ->
#base_task{id = 1010033,name = <<"冒险 · 贫民区"/utf8>>,desc = <<"通关冒险难度 贫民区 一次"/utf8>>,type = 1,subtype = 11,previous = 1010032,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105012,1,0,0},func = <<"[1,1105012]"/utf8>>,reward = [{20,2904},{280113,32},{3,2135},{240100101,11}],next = 1010034,give_up = 0,double_time = [],liveness_reward = 0};
get(1010034) ->
#base_task{id = 1010034,name = <<"冒险 · 暴力黑帮街头"/utf8>>,desc = <<"通关冒险难度 暴力黑帮街头 一次"/utf8>>,type = 1,subtype = 11,previous = 1010033,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105022,1,0,0},func = <<"[1,1105022]"/utf8>>,reward = [{20,3020},{280113,35},{3,2359},{240100101,12}],next = 1010035,give_up = 0,double_time = [],liveness_reward = 0};
get(1010035) ->
#base_task{id = 1010035,name = <<"冒险 · 城市外围地区"/utf8>>,desc = <<"通关冒险难度 城市外围地区 一次"/utf8>>,type = 1,subtype = 11,previous = 1010034,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105032,1,0,0},func = <<"[1,1105032]"/utf8>>,reward = [{20,6561},{280113,80},{3,5466},{240100101,28}],next = 1010036,give_up = 0,double_time = [],liveness_reward = 0};
get(1010036) ->
#base_task{id = 1010036,name = <<"冒险 · 城市中心地区"/utf8>>,desc = <<"通关冒险难度 城市中心地区 一次"/utf8>>,type = 1,subtype = 11,previous = 1010035,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105042,1,0,0},func = <<"[1,1105042]"/utf8>>,reward = [{20,7926},{280113,95},{3,6605},{240100101,33}],next = 1010037,give_up = 0,double_time = [],liveness_reward = 0};
get(1010037) ->
#base_task{id = 1010037,name = <<"冒险 · 大型升降梯"/utf8>>,desc = <<"通关冒险难度 大型升降梯 一次"/utf8>>,type = 1,subtype = 11,previous = 1010036,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105052,1,0,0},func = <<"[1,1105052]"/utf8>>,reward = [{20,9516},{280113,111},{3,7929},{240100101,40}],next = 1010038,give_up = 0,double_time = [],liveness_reward = 0};
get(1010038) ->
#base_task{id = 1010038,name = <<"冒险 · 潜入指挥中心"/utf8>>,desc = <<"通关冒险难度 潜入指挥中心 一次"/utf8>>,type = 1,subtype = 11,previous = 1010037,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105062,1,0,0},func = <<"[1,1105062]"/utf8>>,reward = [{20,11355},{280113,130},{3,9462},{240100101,48}],next = 1010039,give_up = 0,double_time = [],liveness_reward = 0};
get(1010039) ->
#base_task{id = 1010039,name = <<"冒险 · 西部国道公路"/utf8>>,desc = <<"通关冒险难度 西部国道公路 一次"/utf8>>,type = 1,subtype = 11,previous = 1010038,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105072,1,0,0},func = <<"[1,1105072]"/utf8>>,reward = [{20,13475},{280113,152},{3,11229},{240100101,57}],next = 1010040,give_up = 0,double_time = [],liveness_reward = 0};
get(1010040) ->
#base_task{id = 1010040,name = <<"冒险 · 火车顶遭遇"/utf8>>,desc = <<"通关冒险难度 火车顶遭遇 一次"/utf8>>,type = 1,subtype = 11,previous = 1010039,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105082,1,0,0},func = <<"[1,1105082]"/utf8>>,reward = [{20,15908},{280113,175},{3,13256},{240100101,67}],next = 1010041,give_up = 0,double_time = [],liveness_reward = 0};
get(1010041) ->
#base_task{id = 1010041,name = <<"冒险 · 运河大铁桥"/utf8>>,desc = <<"通关冒险难度 运河大铁桥 一次"/utf8>>,type = 1,subtype = 11,previous = 1010040,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105092,1,0,0},func = <<"[1,1105092]"/utf8>>,reward = [{20,18690},{280113,202},{3,15575},{240100101,78}],next = 1010042,give_up = 0,double_time = [],liveness_reward = 0};
get(1010042) ->
#base_task{id = 1010042,name = <<"冒险 · 航空母舰"/utf8>>,desc = <<"通关冒险难度 航空母舰 一次"/utf8>>,type = 1,subtype = 11,previous = 1010041,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105102,1,0,0},func = <<"[1,1105102]"/utf8>>,reward = [{20,21861},{280113,232},{3,18217},{240100101,92}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(1020001) ->
#base_task{id = 1020001,name = <<"王者 · 外环公路"/utf8>>,desc = <<"通关王者难度 外环公路 一次"/utf8>>,type = 1,subtype = 12,previous = 0,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1101023,1,0,0},func = <<"[1,1101023]"/utf8>>,reward = [{20,480},{270101,1},{280102,2},{240100101,4}],next = 1020002,give_up = 0,double_time = [],liveness_reward = 0};
get(1020002) ->
#base_task{id = 1020002,name = <<"王者 · 暴力街区"/utf8>>,desc = <<"通关王者难度 暴力街区 一次"/utf8>>,type = 1,subtype = 12,previous = 1020001,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1101063,1,0,0},func = <<"[1,1101063]"/utf8>>,reward = [{20,700},{270201,1},{280102,2},{240100101,4}],next = 1020003,give_up = 0,double_time = [],liveness_reward = 0};
get(1020003) ->
#base_task{id = 1020003,name = <<"王者 · 朗德渔港"/utf8>>,desc = <<"通关王者难度 朗德渔港 一次"/utf8>>,type = 1,subtype = 12,previous = 1020002,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102013,1,0,0},func = <<"[1,1102013]"/utf8>>,reward = [{90105000,5},{90205000,5},{270101,1},{280101,4},{22110225,1},{22120225,1}],next = 1020004,give_up = 0,double_time = [],liveness_reward = 0};
get(1020004) ->
#base_task{id = 1020004,name = <<"王者 · 繁华商业街"/utf8>>,desc = <<"通关王者难度 繁华商业街 一次"/utf8>>,type = 1,subtype = 12,previous = 1020003,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102023,1,0,0},func = <<"[1,1102023]"/utf8>>,reward = [{90110000,5},{90210000,5},{270201,1},{280101,5},{22500223,1}],next = 1020005,give_up = 0,double_time = [],liveness_reward = 0};
get(1020005) ->
#base_task{id = 1020005,name = <<"王者 · 城市中心花园"/utf8>>,desc = <<"通关王者难度 城市中心花园 一次"/utf8>>,type = 1,subtype = 12,previous = 1020004,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102033,1,0,0},func = <<"[1,1102033]"/utf8>>,reward = [{20,957},{270301,1},{280102,2},{240100101,6}],next = 1020006,give_up = 0,double_time = [],liveness_reward = 0};
get(1020006) ->
#base_task{id = 1020006,name = <<"王者 · 寂静夜晚街道"/utf8>>,desc = <<"通关王者难度 寂静夜晚街道 一次"/utf8>>,type = 1,subtype = 12,previous = 1020005,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102043,1,0,0},func = <<"[1,1102043]"/utf8>>,reward = [{20,1003},{270401,1},{280102,2},{240100101,6}],next = 1020007,give_up = 0,double_time = [],liveness_reward = 0};
get(1020007) ->
#base_task{id = 1020007,name = <<"王者 · 阴暗下水道"/utf8>>,desc = <<"通关王者难度 阴暗下水道 一次"/utf8>>,type = 1,subtype = 12,previous = 1020006,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102053,1,0,0},func = <<"[1,1102053]"/utf8>>,reward = [{20,1057},{270501,1},{280102,4},{240100101,6}],next = 1020008,give_up = 0,double_time = [],liveness_reward = 0};
get(1020008) ->
#base_task{id = 1020008,name = <<"王者 · 下水道深处"/utf8>>,desc = <<"通关王者难度 下水道深处 一次"/utf8>>,type = 1,subtype = 12,previous = 1020007,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102063,1,0,0},func = <<"[1,1102063]"/utf8>>,reward = [{20,1083},{270601,1},{280102,4},{240100101,6}],next = 1020009,give_up = 0,double_time = [],liveness_reward = 0};
get(1020009) ->
#base_task{id = 1020009,name = <<"王者 · 南部海港码头"/utf8>>,desc = <<"通关王者难度 南部海港码头 一次"/utf8>>,type = 1,subtype = 12,previous = 1020008,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102073,1,0,0},func = <<"[1,1102073]"/utf8>>,reward = [{20,1120},{270701,1},{280102,5},{240100101,6}],next = 1020010,give_up = 0,double_time = [],liveness_reward = 0};
get(1020010) ->
#base_task{id = 1020010,name = <<"王者 · 码头内部"/utf8>>,desc = <<"通关王者难度 码头内部 一次"/utf8>>,type = 1,subtype = 12,previous = 1020009,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102083,1,0,0},func = <<"[1,1102083]"/utf8>>,reward = [{20,1159},{270801,1},{280102,5},{240100101,6}],next = 1020011,give_up = 0,double_time = [],liveness_reward = 0};
get(1020011) ->
#base_task{id = 1020011,name = <<"王者 · 码头黄昏"/utf8>>,desc = <<"通关王者难度 码头黄昏 一次"/utf8>>,type = 1,subtype = 12,previous = 1020010,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102093,1,0,0},func = <<"[1,1102093]"/utf8>>,reward = [{20,1191},{270101,1},{280102,5},{240100101,6}],next = 1020012,give_up = 0,double_time = [],liveness_reward = 0};
get(1020012) ->
#base_task{id = 1020012,name = <<"王者 · 钢炼工厂"/utf8>>,desc = <<"通关王者难度 钢炼工厂 一次"/utf8>>,type = 1,subtype = 12,previous = 1020011,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1102103,1,0,0},func = <<"[1,1102103]"/utf8>>,reward = [{20,1200},{270201,1},{280102,5},{240100101,6}],next = 1020013,give_up = 0,double_time = [],liveness_reward = 0};
get(1020013) ->
#base_task{id = 1020013,name = <<"王者 · 雨林树村"/utf8>>,desc = <<"通关王者难度 雨林树村 一次"/utf8>>,type = 1,subtype = 12,previous = 1020012,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103013,1,0,0},func = <<"[1,1103013]"/utf8>>,reward = [{20,1224},{270301,1},{280102,5},{240100101,6}],next = 1020014,give_up = 0,double_time = [],liveness_reward = 0};
get(1020014) ->
#base_task{id = 1020014,name = <<"王者 · 树村深处"/utf8>>,desc = <<"通关王者难度 树村深处 一次"/utf8>>,type = 1,subtype = 12,previous = 1020013,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103023,1,0,0},func = <<"[1,1103023]"/utf8>>,reward = [{20,1264},{270401,1},{280103,6},{240100101,6}],next = 1020015,give_up = 0,double_time = [],liveness_reward = 0};
get(1020015) ->
#base_task{id = 1020015,name = <<"王者 · 植物实验基地"/utf8>>,desc = <<"通关王者难度 植物实验基地 一次"/utf8>>,type = 1,subtype = 12,previous = 1020014,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103033,1,0,0},func = <<"[1,1103033]"/utf8>>,reward = [{20,1321},{270501,1},{280103,6},{240100101,6}],next = 1020016,give_up = 0,double_time = [],liveness_reward = 0};
get(1020016) ->
#base_task{id = 1020016,name = <<"王者 · 实验基地内部"/utf8>>,desc = <<"通关王者难度 实验基地内部 一次"/utf8>>,type = 1,subtype = 12,previous = 1020015,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103043,1,0,0},func = <<"[1,1103043]"/utf8>>,reward = [{20,1395},{270601,1},{280103,7},{240100101,6}],next = 1020017,give_up = 0,double_time = [],liveness_reward = 0};
get(1020017) ->
#base_task{id = 1020017,name = <<"王者 · 诡异实验室"/utf8>>,desc = <<"通关王者难度 诡异实验室 一次"/utf8>>,type = 1,subtype = 12,previous = 1020016,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103053,1,0,0},func = <<"[1,1103053]"/utf8>>,reward = [{20,1485},{270701,1},{280103,7},{240100101,8}],next = 1020018,give_up = 0,double_time = [],liveness_reward = 0};
get(1020018) ->
#base_task{id = 1020018,name = <<"王者 · 恐怖研究院"/utf8>>,desc = <<"通关王者难度 恐怖研究院 一次"/utf8>>,type = 1,subtype = 12,previous = 1020017,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103063,1,0,0},func = <<"[1,1103063]"/utf8>>,reward = [{20,1590},{270801,1},{280103,8},{240100101,8}],next = 1020019,give_up = 0,double_time = [],liveness_reward = 0};
get(1020019) ->
#base_task{id = 1020019,name = <<"王者 · 阴暗墓地"/utf8>>,desc = <<"通关王者难度 阴暗墓地 一次"/utf8>>,type = 1,subtype = 12,previous = 1020018,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103073,1,0,0},func = <<"[1,1103073]"/utf8>>,reward = [{20,1711},{270101,2},{280103,8},{240100101,8}],next = 1020020,give_up = 0,double_time = [],liveness_reward = 0};
get(1020020) ->
#base_task{id = 1020020,name = <<"王者 · 送葬者之路"/utf8>>,desc = <<"通关王者难度 送葬者之路 一次"/utf8>>,type = 1,subtype = 12,previous = 1020019,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103083,1,0,0},func = <<"[1,1103083]"/utf8>>,reward = [{20,1846},{270201,2},{280103,9},{240100101,8}],next = 1020021,give_up = 0,double_time = [],liveness_reward = 0};
get(1020021) ->
#base_task{id = 1020021,name = <<"王者 · 冰冷实验室"/utf8>>,desc = <<"通关王者难度 冰冷实验室 一次"/utf8>>,type = 1,subtype = 12,previous = 1020020,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103093,1,0,0},func = <<"[1,1103093]"/utf8>>,reward = [{20,1995},{270301,2},{280103,10},{240100101,8}],next = 1020022,give_up = 0,double_time = [],liveness_reward = 0};
get(1020022) ->
#base_task{id = 1020022,name = <<"王者 · 严寒研究院"/utf8>>,desc = <<"通关王者难度 严寒研究院 一次"/utf8>>,type = 1,subtype = 12,previous = 1020021,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1103103,1,0,0},func = <<"[1,1103103]"/utf8>>,reward = [{20,2157},{270401,2},{280103,11},{240100101,8}],next = 1020023,give_up = 0,double_time = [],liveness_reward = 0};
get(1020023) ->
#base_task{id = 1020023,name = <<"王者 · 沙漠集市"/utf8>>,desc = <<"通关王者难度 沙漠集市 一次"/utf8>>,type = 1,subtype = 12,previous = 1020022,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104013,1,0,0},func = <<"[1,1104013]"/utf8>>,reward = [{20,2332},{270501,2},{280103,12},{240100101,8}],next = 1020024,give_up = 0,double_time = [],liveness_reward = 0};
get(1020024) ->
#base_task{id = 1020024,name = <<"王者 · 非洲草原"/utf8>>,desc = <<"通关王者难度 非洲草原 一次"/utf8>>,type = 1,subtype = 12,previous = 1020023,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104023,1,0,0},func = <<"[1,1104023]"/utf8>>,reward = [{20,2517},{270601,2},{280104,14},{240100101,10}],next = 1020025,give_up = 0,double_time = [],liveness_reward = 0};
get(1020025) ->
#base_task{id = 1020025,name = <<"王者 · 草原夜晚"/utf8>>,desc = <<"通关王者难度 草原夜晚 一次"/utf8>>,type = 1,subtype = 12,previous = 1020024,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104033,1,0,0},func = <<"[1,1104033]"/utf8>>,reward = [{20,2712},{270701,2},{280104,15},{240100101,10}],next = 1020026,give_up = 0,double_time = [],liveness_reward = 0};
get(1020026) ->
#base_task{id = 1020026,name = <<"王者 · 灼热沙漠"/utf8>>,desc = <<"通关王者难度 灼热沙漠 一次"/utf8>>,type = 1,subtype = 12,previous = 1020025,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104043,1,0,0},func = <<"[1,1104043]"/utf8>>,reward = [{20,2914},{270801,3},{280104,17},{240100101,12}],next = 1020027,give_up = 0,double_time = [],liveness_reward = 0};
get(1020027) ->
#base_task{id = 1020027,name = <<"王者 · 沙漠夜晚"/utf8>>,desc = <<"通关王者难度 沙漠夜晚 一次"/utf8>>,type = 1,subtype = 12,previous = 1020026,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104053,1,0,0},func = <<"[1,1104053]"/utf8>>,reward = [{20,3121},{270101,3},{280104,18},{240100101,12}],next = 1020028,give_up = 0,double_time = [],liveness_reward = 0};
get(1020028) ->
#base_task{id = 1020028,name = <<"王者 · 沙漠村庄"/utf8>>,desc = <<"通关王者难度 沙漠村庄 一次"/utf8>>,type = 1,subtype = 12,previous = 1020027,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104063,1,0,0},func = <<"[1,1104063]"/utf8>>,reward = [{20,3334},{270201,3},{280104,20},{240100101,14}],next = 1020029,give_up = 0,double_time = [],liveness_reward = 0};
get(1020029) ->
#base_task{id = 1020029,name = <<"王者 · 沙漠遗迹"/utf8>>,desc = <<"通关王者难度 沙漠遗迹 一次"/utf8>>,type = 1,subtype = 12,previous = 1020028,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104073,1,0,0},func = <<"[1,1104073]"/utf8>>,reward = [{20,3547},{270301,3},{280104,22},{240100101,16}],next = 1020030,give_up = 0,double_time = [],liveness_reward = 0};
get(1020030) ->
#base_task{id = 1020030,name = <<"王者 · 金字塔外围"/utf8>>,desc = <<"通关王者难度 金字塔外围 一次"/utf8>>,type = 1,subtype = 12,previous = 1020029,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104083,1,0,0},func = <<"[1,1104083]"/utf8>>,reward = [{20,3759},{270401,4},{280104,25},{240100101,18}],next = 1020031,give_up = 0,double_time = [],liveness_reward = 0};
get(1020031) ->
#base_task{id = 1020031,name = <<"王者 · 金字塔内部"/utf8>>,desc = <<"通关王者难度 金字塔内部 一次"/utf8>>,type = 1,subtype = 12,previous = 1020030,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104093,1,0,0},func = <<"[1,1104093]"/utf8>>,reward = [{20,3967},{270501,4},{280104,27},{240100101,18}],next = 1020032,give_up = 0,double_time = [],liveness_reward = 0};
get(1020032) ->
#base_task{id = 1020032,name = <<"王者 · 法老陵墓"/utf8>>,desc = <<"通关王者难度 法老陵墓 一次"/utf8>>,type = 1,subtype = 12,previous = 1020031,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1104103,1,0,0},func = <<"[1,1104103]"/utf8>>,reward = [{20,4167},{270601,4},{280104,30},{240100101,20}],next = 1020033,give_up = 0,double_time = [],liveness_reward = 0};
get(1020033) ->
#base_task{id = 1020033,name = <<"王者 · 贫民区"/utf8>>,desc = <<"通关王者难度 贫民区 一次"/utf8>>,type = 1,subtype = 12,previous = 1020032,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105013,1,0,0},func = <<"[1,1105013]"/utf8>>,reward = [{20,4356},{270701,5},{280104,32},{240100101,22}],next = 1020034,give_up = 0,double_time = [],liveness_reward = 0};
get(1020034) ->
#base_task{id = 1020034,name = <<"王者 · 暴力黑帮街头"/utf8>>,desc = <<"通关王者难度 暴力黑帮街头 一次"/utf8>>,type = 1,subtype = 12,previous = 1020033,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105023,1,0,0},func = <<"[1,1105023]"/utf8>>,reward = [{20,4530},{270801,5},{280105,35},{240100101,24}],next = 1020035,give_up = 0,double_time = [],liveness_reward = 0};
get(1020035) ->
#base_task{id = 1020035,name = <<"王者 · 城市外围地区"/utf8>>,desc = <<"通关王者难度 城市外围地区 一次"/utf8>>,type = 1,subtype = 12,previous = 1020034,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105033,1,0,0},func = <<"[1,1105033]"/utf8>>,reward = [{20,9841},{270101,6},{280105,80},{240100101,56}],next = 1020036,give_up = 0,double_time = [],liveness_reward = 0};
get(1020036) ->
#base_task{id = 1020036,name = <<"王者 · 城市中心地区"/utf8>>,desc = <<"通关王者难度 城市中心地区 一次"/utf8>>,type = 1,subtype = 12,previous = 1020035,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105043,1,0,0},func = <<"[1,1105043]"/utf8>>,reward = [{20,11889},{270201,12},{280105,95},{240100101,66}],next = 1020037,give_up = 0,double_time = [],liveness_reward = 0};
get(1020037) ->
#base_task{id = 1020037,name = <<"王者 · 大型升降梯"/utf8>>,desc = <<"通关王者难度 大型升降梯 一次"/utf8>>,type = 1,subtype = 12,previous = 1020036,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105053,1,0,0},func = <<"[1,1105053]"/utf8>>,reward = [{20,14274},{270301,14},{280105,111},{240100101,80}],next = 1020038,give_up = 0,double_time = [],liveness_reward = 0};
get(1020038) ->
#base_task{id = 1020038,name = <<"王者 · 潜入指挥中心"/utf8>>,desc = <<"通关王者难度 潜入指挥中心 一次"/utf8>>,type = 1,subtype = 12,previous = 1020037,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105063,1,0,0},func = <<"[1,1105063]"/utf8>>,reward = [{20,17032},{270401,17},{280105,130},{240100101,96}],next = 1020039,give_up = 0,double_time = [],liveness_reward = 0};
get(1020039) ->
#base_task{id = 1020039,name = <<"王者 · 西部国道公路"/utf8>>,desc = <<"通关王者难度 西部国道公路 一次"/utf8>>,type = 1,subtype = 12,previous = 1020038,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105073,1,0,0},func = <<"[1,1105073]"/utf8>>,reward = [{20,20212},{270501,19},{280105,152},{240100101,114}],next = 1020040,give_up = 0,double_time = [],liveness_reward = 0};
get(1020040) ->
#base_task{id = 1020040,name = <<"王者 · 火车顶遭遇"/utf8>>,desc = <<"通关王者难度 火车顶遭遇 一次"/utf8>>,type = 1,subtype = 12,previous = 1020039,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105083,1,0,0},func = <<"[1,1105083]"/utf8>>,reward = [{20,23862},{270601,22},{280106,175},{240100101,134}],next = 1020041,give_up = 0,double_time = [],liveness_reward = 0};
get(1020041) ->
#base_task{id = 1020041,name = <<"王者 · 运河大铁桥"/utf8>>,desc = <<"通关王者难度 运河大铁桥 一次"/utf8>>,type = 1,subtype = 12,previous = 1020040,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105093,1,0,0},func = <<"[1,1105093]"/utf8>>,reward = [{20,28035},{270701,26},{280106,202},{240100101,156}],next = 1020042,give_up = 0,double_time = [],liveness_reward = 0};
get(1020042) ->
#base_task{id = 1020042,name = <<"王者 · 航空母舰"/utf8>>,desc = <<"通关王者难度 航空母舰 一次"/utf8>>,type = 1,subtype = 12,previous = 1020041,level = [15,100],circle_type = 0,time = [],end_time = [],condition = {1,1105103,1,0,0},func = <<"[1,1105103]"/utf8>>,reward = [{20,32791},{270801,29},{280106,232},{240100101,184}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000003) ->
#base_task{id = 2000003,name = <<"一阶技能经验副本"/utf8>>,desc = <<"通关一阶技能经验副本 两次 每次至少可获得[00FF00]15[-]中经验石"/utf8>>,type = 2,subtype = 0,previous = 0,level = [10,19],circle_type = 0,time = [],end_time = [],condition = {1,1200001,2,0,0},func = <<"[1,1200001]"/utf8>>,reward = [{20,565},{3,81},{240100101,1}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000004) ->
#base_task{id = 2000004,name = <<"二阶技能经验副本"/utf8>>,desc = <<"通关二阶技能经验副本 两次 每次至少可获得[00FF00]25[-]中经验石"/utf8>>,type = 2,subtype = 0,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {1,1200002,2,0,0},func = <<"[1,1200002]"/utf8>>,reward = [{20,955},{3,159},{240100101,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000005) ->
#base_task{id = 2000005,name = <<"三阶技能经验副本"/utf8>>,desc = <<"通关三阶技能经验副本 两次 每次至少可获得[00FF00]35[-]中经验石"/utf8>>,type = 2,subtype = 0,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {1,1200003,2,0,0},func = <<"[1,1200003]"/utf8>>,reward = [{20,1192},{3,199},{240100101,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000006) ->
#base_task{id = 2000006,name = <<"四阶技能经验副本"/utf8>>,desc = <<"通关四阶技能经验副本 两次 每次至少可获得[00FF00]51[-]中经验石"/utf8>>,type = 2,subtype = 0,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {1,1200004,2,0,0},func = <<"[1,1200004]"/utf8>>,reward = [{20,1689},{3,281},{240100101,3}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000007) ->
#base_task{id = 2000007,name = <<"五阶技能经验副本"/utf8>>,desc = <<"通关五阶技能经验副本 两次 每次至少可获得[00FF00]17[-]大经验石"/utf8>>,type = 2,subtype = 0,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {1,1200005,2,0,0},func = <<"[1,1200005]"/utf8>>,reward = [{20,2235},{3,373},{240100101,4}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000008) ->
#base_task{id = 2000008,name = <<"一阶金币副本"/utf8>>,desc = <<"通关一阶金币副本 两次 每次至少可获得[00FF00]4200[-]金币"/utf8>>,type = 2,subtype = 0,previous = 0,level = [15,24],circle_type = 0,time = [],end_time = [],condition = {1,1200101,2,0,0},func = <<"[1,1200101]"/utf8>>,reward = [{20,565},{3,81},{240100101,1}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000009) ->
#base_task{id = 2000009,name = <<"二阶金币副本"/utf8>>,desc = <<"通关二阶金币副本 两次 每次至少可获得[00FF00]8800[-]金币"/utf8>>,type = 2,subtype = 0,previous = 0,level = [25,34],circle_type = 0,time = [],end_time = [],condition = {1,1200102,2,0,0},func = <<"[1,1200102]"/utf8>>,reward = [{20,955},{3,159},{240100101,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000010) ->
#base_task{id = 2000010,name = <<"三阶金币副本"/utf8>>,desc = <<"通关三阶金币副本 两次 每次至少可获得[00FF00]11000[-]金币"/utf8>>,type = 2,subtype = 0,previous = 0,level = [35,44],circle_type = 0,time = [],end_time = [],condition = {1,1200103,2,0,0},func = <<"[1,1200103]"/utf8>>,reward = [{20,1192},{3,199},{240100101,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000011) ->
#base_task{id = 2000011,name = <<"四阶金币副本"/utf8>>,desc = <<"通关四阶金币副本 两次 每次至少可获得[00FF00]15600[-]金币"/utf8>>,type = 2,subtype = 0,previous = 0,level = [45,54],circle_type = 0,time = [],end_time = [],condition = {1,1200104,2,0,0},func = <<"[1,1200104]"/utf8>>,reward = [{20,1689},{3,281},{240100101,3}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000012) ->
#base_task{id = 2000012,name = <<"一阶经验副本"/utf8>>,desc = <<"通关一阶经验副本 两次 每次至少可获得[00FF00]1500[-]经验"/utf8>>,type = 2,subtype = 0,previous = 0,level = [10,19],circle_type = 0,time = [],end_time = [],condition = {1,1200201,2,0,0},func = <<"[1,1200201]"/utf8>>,reward = [{20,646},{3,93},{240100101,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000013) ->
#base_task{id = 2000013,name = <<"二阶经验副本"/utf8>>,desc = <<"通关二阶经验副本 两次 每次至少可获得[00FF00]5400[-]经验"/utf8>>,type = 2,subtype = 0,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {1,1200202,2,0,0},func = <<"[1,1200202]"/utf8>>,reward = [{20,1092},{3,182},{240100101,3}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000014) ->
#base_task{id = 2000014,name = <<"三阶经验副本"/utf8>>,desc = <<"通关三阶经验副本 两次 每次至少可获得[00FF00]9500[-]经验"/utf8>>,type = 2,subtype = 0,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {1,1200203,2,0,0},func = <<"[1,1200203]"/utf8>>,reward = [{20,1362},{3,227},{240100101,4}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000015) ->
#base_task{id = 2000015,name = <<"四阶经验副本"/utf8>>,desc = <<"通关四阶经验副本 两次 每次至少可获得[00FF00]15000[-]经验"/utf8>>,type = 2,subtype = 0,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {1,1200204,2,0,0},func = <<"[1,1200204]"/utf8>>,reward = [{20,1930},{3,322},{240100101,5}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000016) ->
#base_task{id = 2000016,name = <<"五阶经验副本"/utf8>>,desc = <<"通关五阶经验副本 两次 每次至少可获得[00FF00]21000[-]经验"/utf8>>,type = 2,subtype = 0,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {1,1200205,2,0,0},func = <<"[1,1200205]"/utf8>>,reward = [{20,2555},{3,426},{240100101,7}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000017) ->
#base_task{id = 2000017,name = <<"六阶技能经验副本"/utf8>>,desc = <<"通关六阶技能经验副本 两次 每次至少可获得[00FF00]22[-]大经验石"/utf8>>,type = 2,subtype = 0,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {1,1200006,2,0,0},func = <<"[1,1200006]"/utf8>>,reward = [{20,2948},{3,491},{240100101,5}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000018) ->
#base_task{id = 2000018,name = <<"七阶技能经验副本"/utf8>>,desc = <<"通关七阶技能经验副本 两次 每次至少可获得[00FF00]30[-]大经验石"/utf8>>,type = 2,subtype = 0,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {1,1200007,2,0,0},func = <<"[1,1200007]"/utf8>>,reward = [{20,3910},{3,652},{240100101,7}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000019) ->
#base_task{id = 2000019,name = <<"八阶技能经验副本"/utf8>>,desc = <<"通关八阶技能经验副本 两次 每次至少可获得[00FF00]43[-]大经验石"/utf8>>,type = 2,subtype = 0,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {1,1200008,2,0,0},func = <<"[1,1200008]"/utf8>>,reward = [{20,5206},{3,868},{240100101,9}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000020) ->
#base_task{id = 2000020,name = <<"九阶技能经验副本"/utf8>>,desc = <<"通关八阶技能经验副本 两次 每次至少可获得[00FF00]60[-]大经验石"/utf8>>,type = 2,subtype = 0,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {1,1200009,2,0,0},func = <<"[1,1200009]"/utf8>>,reward = [{20,6949},{3,1158},{240100101,12}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000021) ->
#base_task{id = 2000021,name = <<"六阶经验副本"/utf8>>,desc = <<"通关六阶经验副本 两次 每次至少可获得[00FF00]27000[-]经验"/utf8>>,type = 2,subtype = 0,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {1,1200206,2,0,0},func = <<"[1,1200206]"/utf8>>,reward = [{20,3369},{3,562},{240100101,9}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000022) ->
#base_task{id = 2000022,name = <<"七阶经验副本"/utf8>>,desc = <<"通关七阶经验副本 两次 每次至少可获得[00FF00]36000[-]经验"/utf8>>,type = 2,subtype = 0,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {1,1200207,2,0,0},func = <<"[1,1200207]"/utf8>>,reward = [{20,4468},{3,745},{240100101,12}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000023) ->
#base_task{id = 2000023,name = <<"八阶经验副本"/utf8>>,desc = <<"通关八阶经验副本 两次 每次至少可获得[00FF00]49000[-]经验"/utf8>>,type = 2,subtype = 0,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {1,1200208,2,0,0},func = <<"[1,1200208]"/utf8>>,reward = [{20,5949},{3,992},{240100101,15}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000024) ->
#base_task{id = 2000024,name = <<"九阶经验副本"/utf8>>,desc = <<"通关九阶经验副本 两次 每次至少可获得[00FF00]65000[-]经验"/utf8>>,type = 2,subtype = 0,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {1,1200209,2,0,0},func = <<"[1,1200209]"/utf8>>,reward = [{20,7941},{3,1324},{240100101,20}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000025) ->
#base_task{id = 2000025,name = <<"五阶金币副本"/utf8>>,desc = <<"通关五阶金币副本 两次 每次至少可获得[00FF00]19500[-]金币"/utf8>>,type = 2,subtype = 0,previous = 0,level = [55,64],circle_type = 0,time = [],end_time = [],condition = {1,1200105,2,0,0},func = <<"[1,1200105]"/utf8>>,reward = [{20,2235},{3,373},{240100101,4}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000026) ->
#base_task{id = 2000026,name = <<"六阶金币副本"/utf8>>,desc = <<"通关六阶金币副本 两次 每次至少可获得[00FF00]27000[-]金币"/utf8>>,type = 2,subtype = 0,previous = 0,level = [65,74],circle_type = 0,time = [],end_time = [],condition = {1,1200106,2,0,0},func = <<"[1,1200106]"/utf8>>,reward = [{20,2948},{3,491},{240100101,5}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000027) ->
#base_task{id = 2000027,name = <<"七阶金币副本"/utf8>>,desc = <<"通关七阶金币副本 两次 每次至少可获得[00FF00]35000[-]金币"/utf8>>,type = 2,subtype = 0,previous = 0,level = [75,84],circle_type = 0,time = [],end_time = [],condition = {1,1200107,2,0,0},func = <<"[1,1200107]"/utf8>>,reward = [{20,3910},{3,652},{240100101,7}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(2000028) ->
#base_task{id = 2000028,name = <<"八阶金币副本"/utf8>>,desc = <<"通关八阶金币副本 两次 每次至少可获得[00FF00]48000[-]金币"/utf8>>,type = 2,subtype = 0,previous = 0,level = [85,94],circle_type = 0,time = [],end_time = [],condition = {1,1200108,2,0,0},func = <<"[1,1200108]"/utf8>>,reward = [{20,5206},{3,868},{240100101,9}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4000001) ->
#base_task{id = 4000001,name = <<"等级成就(10级)"/utf8>>,desc = <<"角色等级达到10级"/utf8>>,type = 4,subtype = 40,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {4,10},func = <<"[]"/utf8>>,reward = [{90103000,5},{90203000,5},{240100101,15},{1,200}],next = 4000002,give_up = 0,double_time = [],liveness_reward = 0};
get(4000002) ->
#base_task{id = 4000002,name = <<"等级成就(20级)"/utf8>>,desc = <<"角色等级达到20级"/utf8>>,type = 4,subtype = 40,previous = 4000001,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {4,20},func = <<"[]"/utf8>>,reward = [{90111000,5},{90211000,5},{240100101,22},{1,250}],next = 4000003,give_up = 0,double_time = [],liveness_reward = 0};
get(4000003) ->
#base_task{id = 4000003,name = <<"等级成就(30级)"/utf8>>,desc = <<"角色等级达到30级"/utf8>>,type = 4,subtype = 40,previous = 4000002,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {4,30},func = <<"[]"/utf8>>,reward = [{3,3320},{240100101,33},{1,300}],next = 4000004,give_up = 0,double_time = [],liveness_reward = 0};
get(4000004) ->
#base_task{id = 4000004,name = <<"等级成就(40级)"/utf8>>,desc = <<"角色等级达到40级"/utf8>>,type = 4,subtype = 40,previous = 4000003,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {4,40},func = <<"[]"/utf8>>,reward = [{3,4980},{240100101,50},{1,350}],next = 4000005,give_up = 0,double_time = [],liveness_reward = 0};
get(4000005) ->
#base_task{id = 4000005,name = <<"等级成就(50级)"/utf8>>,desc = <<"角色等级达到50级"/utf8>>,type = 4,subtype = 40,previous = 4000004,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {4,50},func = <<"[]"/utf8>>,reward = [{3,7470},{240100101,75},{1,400}],next = 4000006,give_up = 0,double_time = [],liveness_reward = 0};
get(4000006) ->
#base_task{id = 4000006,name = <<"等级成就(60级)"/utf8>>,desc = <<"角色等级达到60级"/utf8>>,type = 4,subtype = 40,previous = 4000005,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {4,60},func = <<"[]"/utf8>>,reward = [{3,11205},{240100101,112},{1,450}],next = 4000007,give_up = 0,double_time = [],liveness_reward = 0};
get(4000007) ->
#base_task{id = 4000007,name = <<"等级成就(70级)"/utf8>>,desc = <<"角色等级达到70级"/utf8>>,type = 4,subtype = 40,previous = 4000006,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {4,70},func = <<"[]"/utf8>>,reward = [{3,16808},{240100101,168},{1,500}],next = 4000008,give_up = 0,double_time = [],liveness_reward = 0};
get(4000008) ->
#base_task{id = 4000008,name = <<"等级成就(80级)"/utf8>>,desc = <<"角色等级达到80级"/utf8>>,type = 4,subtype = 40,previous = 4000007,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {4,80},func = <<"[]"/utf8>>,reward = [{3,25211},{240100101,252},{1,550}],next = 4000009,give_up = 0,double_time = [],liveness_reward = 0};
get(4000009) ->
#base_task{id = 4000009,name = <<"等级成就(90级)"/utf8>>,desc = <<"角色等级达到90级"/utf8>>,type = 4,subtype = 40,previous = 4000008,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {4,90},func = <<"[]"/utf8>>,reward = [{3,37817},{240100101,378},{1,600}],next = 4000010,give_up = 0,double_time = [],liveness_reward = 0};
get(4000010) ->
#base_task{id = 4000010,name = <<"等级成就(100级)"/utf8>>,desc = <<"角色等级达到100级"/utf8>>,type = 4,subtype = 40,previous = 4000009,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {4,100},func = <<"[]"/utf8>>,reward = [{3,56725},{240100101,567},{1,650}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(5000001) ->
#base_task{id = 5000001,name = <<"装备强化"/utf8>>,desc = <<"装备强化1次"/utf8>>,type = 1,subtype = 0,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {3,1,1},func = <<"[2,2]"/utf8>>,reward = [{20,4000},{3,240},{240100101,3}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(5000002) ->
#base_task{id = 5000002,name = <<"装备升星"/utf8>>,desc = <<"装备升星2次"/utf8>>,type = 1,subtype = 0,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {3,2,2},func = <<"[2,2]"/utf8>>,reward = [{20,4000},{3,240},{240100101,3}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(5000003) ->
#base_task{id = 5000003,name = <<"技能升级"/utf8>>,desc = <<"技能升级3次"/utf8>>,type = 1,subtype = 0,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {3,3,3},func = <<"[2,1]"/utf8>>,reward = [{20,4000},{3,240},{240100101,3}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(5000004) ->
#base_task{id = 5000004,name = <<"技能强化"/utf8>>,desc = <<"技能强化4次"/utf8>>,type = 1,subtype = 0,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {3,4,4},func = <<"[2,1]"/utf8>>,reward = [{20,4000},{3,240},{240100101,3}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4000101) ->
#base_task{id = 4000101,name = <<"王者 · 朗德渔港"/utf8>>,desc = <<"通关副本 王者 · 朗德渔港"/utf8>>,type = 4,subtype = 41,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102013,1,0,0},func = <<"[1,1102013]"/utf8>>,reward = [{3,437},{240100101,4}],next = 4000102,give_up = 0,double_time = [],liveness_reward = 0};
get(4000102) ->
#base_task{id = 4000102,name = <<"王者 · 繁华商业街"/utf8>>,desc = <<"通关副本王者 · 繁华商业街"/utf8>>,type = 4,subtype = 41,previous = 4000101,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102023,1,0,0},func = <<"[1,1102023]"/utf8>>,reward = [{3,472},{240100101,5}],next = 4000103,give_up = 0,double_time = [],liveness_reward = 0};
get(4000103) ->
#base_task{id = 4000103,name = <<"王者 · 城市中心花园"/utf8>>,desc = <<"通关副本王者 · 城市中心花园"/utf8>>,type = 4,subtype = 41,previous = 4000102,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102033,1,0,0},func = <<"[1,1102033]"/utf8>>,reward = [{3,510},{240100101,5}],next = 4000104,give_up = 0,double_time = [],liveness_reward = 0};
get(4000104) ->
#base_task{id = 4000104,name = <<"王者 · 寂静夜晚街道"/utf8>>,desc = <<"通关副本王者 · 寂静夜晚街道"/utf8>>,type = 4,subtype = 41,previous = 4000103,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102043,1,0,0},func = <<"[1,1102043]"/utf8>>,reward = [{3,551},{240100101,6}],next = 4000105,give_up = 0,double_time = [],liveness_reward = 0};
get(4000105) ->
#base_task{id = 4000105,name = <<"王者 · 阴暗下水道"/utf8>>,desc = <<"通关副本王者 · 阴暗下水道"/utf8>>,type = 4,subtype = 41,previous = 4000104,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102053,1,0,0},func = <<"[1,1102053]"/utf8>>,reward = [{3,595},{240100101,6}],next = 4000106,give_up = 0,double_time = [],liveness_reward = 0};
get(4000106) ->
#base_task{id = 4000106,name = <<"王者 · 下水道深处"/utf8>>,desc = <<"通关副本王者 · 下水道深处"/utf8>>,type = 4,subtype = 41,previous = 4000105,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102063,1,0,0},func = <<"[1,1102063]"/utf8>>,reward = [{3,642},{240100101,6}],next = 4000107,give_up = 0,double_time = [],liveness_reward = 0};
get(4000107) ->
#base_task{id = 4000107,name = <<"王者 · 南部海港码头"/utf8>>,desc = <<"通关副本王者 · 南部海港码头"/utf8>>,type = 4,subtype = 41,previous = 4000106,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102073,1,0,0},func = <<"[1,1102073]"/utf8>>,reward = [{3,694},{240100101,7}],next = 4000108,give_up = 0,double_time = [],liveness_reward = 0};
get(4000108) ->
#base_task{id = 4000108,name = <<"王者 · 码头内部"/utf8>>,desc = <<"通关副本王者 · 码头内部"/utf8>>,type = 4,subtype = 41,previous = 4000107,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102083,1,0,0},func = <<"[1,1102083]"/utf8>>,reward = [{3,749},{240100101,7}],next = 4000109,give_up = 0,double_time = [],liveness_reward = 0};
get(4000109) ->
#base_task{id = 4000109,name = <<"王者 · 码头黄昏"/utf8>>,desc = <<"通关副本王者 · 码头黄昏"/utf8>>,type = 4,subtype = 41,previous = 4000108,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102093,1,0,0},func = <<"[1,1102093]"/utf8>>,reward = [{3,809},{240100101,8}],next = 4000110,give_up = 0,double_time = [],liveness_reward = 0};
get(4000110) ->
#base_task{id = 4000110,name = <<"王者 · 钢炼工厂"/utf8>>,desc = <<"通关副本王者 · 钢炼工厂"/utf8>>,type = 4,subtype = 41,previous = 4000109,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1102103,1,0,0},func = <<"[1,1102103]"/utf8>>,reward = [{3,874},{240100101,9}],next = 4000111,give_up = 0,double_time = [],liveness_reward = 0};
get(4000111) ->
#base_task{id = 4000111,name = <<"王者 · 雨林树村"/utf8>>,desc = <<"通关副本王者 · 雨林树村"/utf8>>,type = 4,subtype = 41,previous = 4000110,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103013,1,0,0},func = <<"[1,1103013]"/utf8>>,reward = [{3,944},{240100101,9}],next = 4000112,give_up = 0,double_time = [],liveness_reward = 0};
get(4000112) ->
#base_task{id = 4000112,name = <<"王者 · 树村深处"/utf8>>,desc = <<"通关副本王者 · 树村深处"/utf8>>,type = 4,subtype = 41,previous = 4000111,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103023,1,0,0},func = <<"[1,1103023]"/utf8>>,reward = [{3,1019},{240100101,10}],next = 4000113,give_up = 0,double_time = [],liveness_reward = 0};
get(4000113) ->
#base_task{id = 4000113,name = <<"王者 · 植物实验基地"/utf8>>,desc = <<"通关副本王者 · 植物实验基地"/utf8>>,type = 4,subtype = 41,previous = 4000112,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103033,1,0,0},func = <<"[1,1103033]"/utf8>>,reward = [{3,1101},{240100101,11}],next = 4000114,give_up = 0,double_time = [],liveness_reward = 0};
get(4000114) ->
#base_task{id = 4000114,name = <<"王者 · 实验基地内部"/utf8>>,desc = <<"通关副本王者 · 实验基地内部"/utf8>>,type = 4,subtype = 41,previous = 4000113,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103043,1,0,0},func = <<"[1,1103043]"/utf8>>,reward = [{3,1189},{240100101,12}],next = 4000115,give_up = 0,double_time = [],liveness_reward = 0};
get(4000115) ->
#base_task{id = 4000115,name = <<"王者 · 诡异实验室"/utf8>>,desc = <<"通关副本王者 · 诡异实验室"/utf8>>,type = 4,subtype = 41,previous = 4000114,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103053,1,0,0},func = <<"[1,1103053]"/utf8>>,reward = [{3,1284},{240100101,13}],next = 4000116,give_up = 0,double_time = [],liveness_reward = 0};
get(4000116) ->
#base_task{id = 4000116,name = <<"王者 · 恐怖研究院"/utf8>>,desc = <<"通关副本王者 · 恐怖研究院"/utf8>>,type = 4,subtype = 41,previous = 4000115,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103063,1,0,0},func = <<"[1,1103063]"/utf8>>,reward = [{3,1387},{240100101,14}],next = 4000117,give_up = 0,double_time = [],liveness_reward = 0};
get(4000117) ->
#base_task{id = 4000117,name = <<"王者 · 阴暗墓地"/utf8>>,desc = <<"通关副本王者 · 阴暗墓地"/utf8>>,type = 4,subtype = 41,previous = 4000116,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103073,1,0,0},func = <<"[1,1103073]"/utf8>>,reward = [{3,1498},{240100101,15}],next = 4000118,give_up = 0,double_time = [],liveness_reward = 0};
get(4000118) ->
#base_task{id = 4000118,name = <<"王者 · 送葬者之路"/utf8>>,desc = <<"通关副本王者 · 送葬者之路"/utf8>>,type = 4,subtype = 41,previous = 4000117,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103083,1,0,0},func = <<"[1,1103083]"/utf8>>,reward = [{3,1618},{240100101,16}],next = 4000119,give_up = 0,double_time = [],liveness_reward = 0};
get(4000119) ->
#base_task{id = 4000119,name = <<"王者 · 冰冷实验室"/utf8>>,desc = <<"通关王者难度 冰冷实验室 "/utf8>>,type = 4,subtype = 41,previous = 4000118,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103093,1,0,0},func = <<"[1,1103093]"/utf8>>,reward = [{3,1747},{240100101,17}],next = 4000120,give_up = 0,double_time = [],liveness_reward = 0};
get(4000120) ->
#base_task{id = 4000120,name = <<"王者 · 严寒研究院"/utf8>>,desc = <<"通关王者难度 严寒研究院 "/utf8>>,type = 4,subtype = 41,previous = 4000119,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1103103,1,0,0},func = <<"[1,1103103]"/utf8>>,reward = [{3,1887},{240100101,19}],next = 4000121,give_up = 0,double_time = [],liveness_reward = 0};
get(4000121) ->
#base_task{id = 4000121,name = <<"王者 · 沙漠集市"/utf8>>,desc = <<"通关王者难度 沙漠集市 "/utf8>>,type = 4,subtype = 41,previous = 4000120,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104013,1,0,0},func = <<"[1,1104013]"/utf8>>,reward = [{3,2038},{240100101,20}],next = 4000122,give_up = 0,double_time = [],liveness_reward = 0};
get(4000122) ->
#base_task{id = 4000122,name = <<"王者 · 非洲草原"/utf8>>,desc = <<"通关王者难度 非洲草原 "/utf8>>,type = 4,subtype = 41,previous = 4000121,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104023,1,0,0},func = <<"[1,1104023]"/utf8>>,reward = [{3,2201},{240100101,22}],next = 4000123,give_up = 0,double_time = [],liveness_reward = 0};
get(4000123) ->
#base_task{id = 4000123,name = <<"王者 · 草原夜晚"/utf8>>,desc = <<"通关王者难度 草原夜晚 "/utf8>>,type = 4,subtype = 41,previous = 4000122,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104033,1,0,0},func = <<"[1,1104033]"/utf8>>,reward = [{3,2377},{240100101,24}],next = 4000124,give_up = 0,double_time = [],liveness_reward = 0};
get(4000124) ->
#base_task{id = 4000124,name = <<"王者 · 灼热沙漠"/utf8>>,desc = <<"通关王者难度 灼热沙漠 "/utf8>>,type = 4,subtype = 41,previous = 4000123,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104043,1,0,0},func = <<"[1,1104043]"/utf8>>,reward = [{3,2567},{240100101,26}],next = 4000125,give_up = 0,double_time = [],liveness_reward = 0};
get(4000125) ->
#base_task{id = 4000125,name = <<"王者 · 沙漠夜晚"/utf8>>,desc = <<"通关王者难度 沙漠夜晚 "/utf8>>,type = 4,subtype = 41,previous = 4000124,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104053,1,0,0},func = <<"[1,1104053]"/utf8>>,reward = [{3,2772},{240100101,28}],next = 4000126,give_up = 0,double_time = [],liveness_reward = 0};
get(4000126) ->
#base_task{id = 4000126,name = <<"王者 · 沙漠村庄"/utf8>>,desc = <<"通关王者难度 沙漠村庄 "/utf8>>,type = 4,subtype = 41,previous = 4000125,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104063,1,0,0},func = <<"[1,1104063]"/utf8>>,reward = [{3,2994},{240100101,30}],next = 4000127,give_up = 0,double_time = [],liveness_reward = 0};
get(4000127) ->
#base_task{id = 4000127,name = <<"王者 · 沙漠遗迹"/utf8>>,desc = <<"通关王者难度 沙漠遗迹 "/utf8>>,type = 4,subtype = 41,previous = 4000126,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104073,1,0,0},func = <<"[1,1104073]"/utf8>>,reward = [{3,3233},{240100101,32}],next = 4000128,give_up = 0,double_time = [],liveness_reward = 0};
get(4000128) ->
#base_task{id = 4000128,name = <<"王者 · 金字塔外围"/utf8>>,desc = <<"通关王者难度 金字塔外围 "/utf8>>,type = 4,subtype = 41,previous = 4000127,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104083,1,0,0},func = <<"[1,1104083]"/utf8>>,reward = [{3,3492},{240100101,35}],next = 4000129,give_up = 0,double_time = [],liveness_reward = 0};
get(4000129) ->
#base_task{id = 4000129,name = <<"王者 · 金字塔内部"/utf8>>,desc = <<"通关王者难度 金字塔内部 "/utf8>>,type = 4,subtype = 41,previous = 4000128,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104093,1,0,0},func = <<"[1,1104093]"/utf8>>,reward = [{3,3772},{240100101,38}],next = 4000130,give_up = 0,double_time = [],liveness_reward = 0};
get(4000130) ->
#base_task{id = 4000130,name = <<"王者 · 法老陵墓"/utf8>>,desc = <<"通关王者难度 法老陵墓 "/utf8>>,type = 4,subtype = 41,previous = 4000129,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1104103,1,0,0},func = <<"[1,1104103]"/utf8>>,reward = [{3,4073},{240100101,41}],next = 4000131,give_up = 0,double_time = [],liveness_reward = 0};
get(4000131) ->
#base_task{id = 4000131,name = <<"王者 · 贫民区"/utf8>>,desc = <<"通关王者难度 贫民区 "/utf8>>,type = 4,subtype = 41,previous = 4000130,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105013,1,0,0},func = <<"[1,1105013]"/utf8>>,reward = [{3,4399},{240100101,44}],next = 4000132,give_up = 0,double_time = [],liveness_reward = 0};
get(4000132) ->
#base_task{id = 4000132,name = <<"王者 · 暴力黑帮街头"/utf8>>,desc = <<"通关王者难度 暴力黑帮街头 "/utf8>>,type = 4,subtype = 41,previous = 4000131,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105023,1,0,0},func = <<"[1,1105023]"/utf8>>,reward = [{3,4751},{240100101,48}],next = 4000133,give_up = 0,double_time = [],liveness_reward = 0};
get(4000133) ->
#base_task{id = 4000133,name = <<"王者 · 城市外围地区"/utf8>>,desc = <<"通关王者难度 城市外围地区 "/utf8>>,type = 4,subtype = 41,previous = 4000132,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105033,1,0,0},func = <<"[1,1105033]"/utf8>>,reward = [{3,5131},{240100101,51}],next = 4000134,give_up = 0,double_time = [],liveness_reward = 0};
get(4000134) ->
#base_task{id = 4000134,name = <<"王者 · 城市中心地区"/utf8>>,desc = <<"通关王者难度 城市中心地区 "/utf8>>,type = 4,subtype = 41,previous = 4000133,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105043,1,0,0},func = <<"[1,1105043]"/utf8>>,reward = [{3,5542},{240100101,55}],next = 4000135,give_up = 0,double_time = [],liveness_reward = 0};
get(4000135) ->
#base_task{id = 4000135,name = <<"王者 · 大型升降梯"/utf8>>,desc = <<"通关王者难度 大型升降梯 "/utf8>>,type = 4,subtype = 41,previous = 4000134,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105053,1,0,0},func = <<"[1,1105053]"/utf8>>,reward = [{3,5985},{240100101,60}],next = 4000136,give_up = 0,double_time = [],liveness_reward = 0};
get(4000136) ->
#base_task{id = 4000136,name = <<"王者 · 潜入指挥中心"/utf8>>,desc = <<"通关王者难度 潜入指挥中心 "/utf8>>,type = 4,subtype = 41,previous = 4000135,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105063,1,0,0},func = <<"[1,1105063]"/utf8>>,reward = [{3,6464},{240100101,65}],next = 4000137,give_up = 0,double_time = [],liveness_reward = 0};
get(4000137) ->
#base_task{id = 4000137,name = <<"王者 · 西部国道公路"/utf8>>,desc = <<"通关王者难度 西部国道公路 "/utf8>>,type = 4,subtype = 41,previous = 4000136,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105073,1,0,0},func = <<"[1,1105073]"/utf8>>,reward = [{3,6981},{240100101,70}],next = 4000138,give_up = 0,double_time = [],liveness_reward = 0};
get(4000138) ->
#base_task{id = 4000138,name = <<"王者 · 火车顶遭遇"/utf8>>,desc = <<"通关王者难度 火车顶遭遇 "/utf8>>,type = 4,subtype = 41,previous = 4000137,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105083,1,0,0},func = <<"[1,1105083]"/utf8>>,reward = [{3,7539},{240100101,75}],next = 4000139,give_up = 0,double_time = [],liveness_reward = 0};
get(4000139) ->
#base_task{id = 4000139,name = <<"王者 · 运河大铁桥"/utf8>>,desc = <<"通关王者难度 运河大铁桥 "/utf8>>,type = 4,subtype = 41,previous = 4000138,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105093,1,0,0},func = <<"[1,1105093]"/utf8>>,reward = [{3,8142},{240100101,81}],next = 4000140,give_up = 0,double_time = [],liveness_reward = 0};
get(4000140) ->
#base_task{id = 4000140,name = <<"王者 · 航空母舰"/utf8>>,desc = <<"通关王者难度 航空母舰 "/utf8>>,type = 4,subtype = 41,previous = 4000139,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {1,1105103,1,0,0},func = <<"[1,1105103]"/utf8>>,reward = [{3,8794},{240100101,88}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4000201) ->
#base_task{id = 4000201,name = <<"好友成就(10个)"/utf8>>,desc = <<"好友数量达到10"/utf8>>,type = 4,subtype = 42,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {8,10},func = <<"[]"/utf8>>,reward = [{3,879},{240100101,9}],next = 4000202,give_up = 0,double_time = [],liveness_reward = 0};
get(4000202) ->
#base_task{id = 4000202,name = <<"好友成就(15个)"/utf8>>,desc = <<"好友数量达到15"/utf8>>,type = 4,subtype = 42,previous = 4000201,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {8,15},func = <<"[]"/utf8>>,reward = [{3,1178},{240100101,12}],next = 4000203,give_up = 0,double_time = [],liveness_reward = 0};
get(4000203) ->
#base_task{id = 4000203,name = <<"好友成就(20个)"/utf8>>,desc = <<"好友数量达到20"/utf8>>,type = 4,subtype = 42,previous = 4000202,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {8,20},func = <<"[]"/utf8>>,reward = [{3,1579},{240100101,16}],next = 4000204,give_up = 0,double_time = [],liveness_reward = 0};
get(4000204) ->
#base_task{id = 4000204,name = <<"好友成就(25个)"/utf8>>,desc = <<"好友数量达到25"/utf8>>,type = 4,subtype = 42,previous = 4000203,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {8,25},func = <<"[]"/utf8>>,reward = [{3,2116},{240100101,21}],next = 4000205,give_up = 0,double_time = [],liveness_reward = 0};
get(4000205) ->
#base_task{id = 4000205,name = <<"好友成就(30个)"/utf8>>,desc = <<"好友数量达到30"/utf8>>,type = 4,subtype = 42,previous = 4000204,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {8,30},func = <<"[]"/utf8>>,reward = [{3,2836},{240100101,28}],next = 4000206,give_up = 0,double_time = [],liveness_reward = 0};
get(4000206) ->
#base_task{id = 4000206,name = <<"好友成就(35个)"/utf8>>,desc = <<"好友数量达到35"/utf8>>,type = 4,subtype = 42,previous = 4000205,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {8,35},func = <<"[]"/utf8>>,reward = [{3,3800},{240100101,38}],next = 4000207,give_up = 0,double_time = [],liveness_reward = 0};
get(4000207) ->
#base_task{id = 4000207,name = <<"好友成就(40个)"/utf8>>,desc = <<"好友数量达到40"/utf8>>,type = 4,subtype = 42,previous = 4000206,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {8,40},func = <<"[]"/utf8>>,reward = [{3,5092},{240100101,51}],next = 4000208,give_up = 0,double_time = [],liveness_reward = 0};
get(4000208) ->
#base_task{id = 4000208,name = <<"好友成就(45个)"/utf8>>,desc = <<"好友数量达到45"/utf8>>,type = 4,subtype = 42,previous = 4000207,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {8,45},func = <<"[]"/utf8>>,reward = [{3,6823},{240100101,68}],next = 4000209,give_up = 0,double_time = [],liveness_reward = 0};
get(4000209) ->
#base_task{id = 4000209,name = <<"好友成就(50个)"/utf8>>,desc = <<"好友数量达到50"/utf8>>,type = 4,subtype = 42,previous = 4000208,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {8,50},func = <<"[]"/utf8>>,reward = [{3,9142},{240100101,91}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4000301) ->
#base_task{id = 4000301,name = <<"通天塔成就(10层)"/utf8>>,desc = <<"通天塔打过第10层"/utf8>>,type = 4,subtype = 43,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {7,10},func = <<"[]"/utf8>>,reward = [{3,2253},{240100101,23}],next = 4000302,give_up = 0,double_time = [],liveness_reward = 0};
get(4000302) ->
#base_task{id = 4000302,name = <<"通天塔成就(20层)"/utf8>>,desc = <<"通天塔打过第20层"/utf8>>,type = 4,subtype = 43,previous = 4000301,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {7,20},func = <<"[]"/utf8>>,reward = [{3,3019},{240100101,30}],next = 4000303,give_up = 0,double_time = [],liveness_reward = 0};
get(4000303) ->
#base_task{id = 4000303,name = <<"通天塔成就(30层)"/utf8>>,desc = <<"通天塔打过第30层"/utf8>>,type = 4,subtype = 43,previous = 4000302,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {7,30},func = <<"[]"/utf8>>,reward = [{3,4045},{240100101,40}],next = 4000304,give_up = 0,double_time = [],liveness_reward = 0};
get(4000304) ->
#base_task{id = 4000304,name = <<"通天塔成就(40层)"/utf8>>,desc = <<"通天塔打过第40层"/utf8>>,type = 4,subtype = 43,previous = 4000303,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {7,40},func = <<"[]"/utf8>>,reward = [{3,5421},{240100101,54}],next = 4000305,give_up = 0,double_time = [],liveness_reward = 0};
get(4000305) ->
#base_task{id = 4000305,name = <<"通天塔成就(50层)"/utf8>>,desc = <<"通天塔打过第50层"/utf8>>,type = 4,subtype = 43,previous = 4000304,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {7,50},func = <<"[]"/utf8>>,reward = [{3,7264},{240100101,73}],next = 4000306,give_up = 0,double_time = [],liveness_reward = 0};
get(4000306) ->
#base_task{id = 4000306,name = <<"通天塔成就(60层)"/utf8>>,desc = <<"通天塔打过第60层"/utf8>>,type = 4,subtype = 43,previous = 4000305,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {7,60},func = <<"[]"/utf8>>,reward = [{3,9733},{240100101,97}],next = 4000307,give_up = 0,double_time = [],liveness_reward = 0};
get(4000307) ->
#base_task{id = 4000307,name = <<"通天塔成就(70层)"/utf8>>,desc = <<"通天塔打过第70层"/utf8>>,type = 4,subtype = 43,previous = 4000306,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {7,70},func = <<"[]"/utf8>>,reward = [{3,13043},{240100101,130}],next = 4000308,give_up = 0,double_time = [],liveness_reward = 0};
get(4000308) ->
#base_task{id = 4000308,name = <<"通天塔成就(80层)"/utf8>>,desc = <<"通天塔打过第80层"/utf8>>,type = 4,subtype = 43,previous = 4000307,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {7,80},func = <<"[]"/utf8>>,reward = [{3,17477},{240100101,175}],next = 4000309,give_up = 0,double_time = [],liveness_reward = 0};
get(4000309) ->
#base_task{id = 4000309,name = <<"通天塔成就(90层)"/utf8>>,desc = <<"通天塔打过第90层"/utf8>>,type = 4,subtype = 43,previous = 4000308,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {7,90},func = <<"[]"/utf8>>,reward = [{3,23420},{240100101,234}],next = 4000310,give_up = 0,double_time = [],liveness_reward = 0};
get(4000310) ->
#base_task{id = 4000310,name = <<"通天塔成就(100层)"/utf8>>,desc = <<"通天塔打过第100层"/utf8>>,type = 4,subtype = 43,previous = 4000309,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {7,100},func = <<"[]"/utf8>>,reward = [{3,31382},{240100101,314}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4000401) ->
#base_task{id = 4000401,name = <<"2级生命宝石成就"/utf8>>,desc = <<"获得一颗2级生命宝石"/utf8>>,type = 4,subtype = 44,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270102,1,0,0},func = <<"[]"/utf8>>,reward = [{3,231},{240100101,2}],next = 4000402,give_up = 0,double_time = [],liveness_reward = 0};
get(4000402) ->
#base_task{id = 4000402,name = <<"2级攻击宝石成就"/utf8>>,desc = <<"获得一颗2级攻击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000401,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270202,1,0,0},func = <<"[]"/utf8>>,reward = [{3,243},{240100101,2}],next = 4000403,give_up = 0,double_time = [],liveness_reward = 0};
get(4000403) ->
#base_task{id = 4000403,name = <<"2级防御宝石成就"/utf8>>,desc = <<"获得一颗2级防御宝石"/utf8>>,type = 4,subtype = 44,previous = 4000402,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270302,1,0,0},func = <<"[]"/utf8>>,reward = [{3,255},{240100101,3}],next = 4000404,give_up = 0,double_time = [],liveness_reward = 0};
get(4000404) ->
#base_task{id = 4000404,name = <<"2级命中宝石成就"/utf8>>,desc = <<"获得一颗2级命中宝石"/utf8>>,type = 4,subtype = 44,previous = 4000403,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270402,1,0,0},func = <<"[]"/utf8>>,reward = [{3,268},{240100101,3}],next = 4000405,give_up = 0,double_time = [],liveness_reward = 0};
get(4000405) ->
#base_task{id = 4000405,name = <<"2级闪避宝石成就"/utf8>>,desc = <<"获得一颗2级闪避宝石"/utf8>>,type = 4,subtype = 44,previous = 4000404,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270502,1,0,0},func = <<"[]"/utf8>>,reward = [{3,281},{240100101,3}],next = 4000406,give_up = 0,double_time = [],liveness_reward = 0};
get(4000406) ->
#base_task{id = 4000406,name = <<"2级暴击宝石成就"/utf8>>,desc = <<"获得一颗2级暴击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000405,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270602,1,0,0},func = <<"[]"/utf8>>,reward = [{3,295},{240100101,3}],next = 4000407,give_up = 0,double_time = [],liveness_reward = 0};
get(4000407) ->
#base_task{id = 4000407,name = <<"2级抗暴宝石成就"/utf8>>,desc = <<"获得一颗2级抗暴宝石"/utf8>>,type = 4,subtype = 44,previous = 4000406,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270702,1,0,0},func = <<"[]"/utf8>>,reward = [{3,310},{240100101,3}],next = 4000408,give_up = 0,double_time = [],liveness_reward = 0};
get(4000408) ->
#base_task{id = 4000408,name = <<"2级能量宝石成就"/utf8>>,desc = <<"获得一颗2级能量宝石"/utf8>>,type = 4,subtype = 44,previous = 4000407,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270802,1,0,0},func = <<"[]"/utf8>>,reward = [{3,325},{240100101,3}],next = 4000409,give_up = 0,double_time = [],liveness_reward = 0};
get(4000409) ->
#base_task{id = 4000409,name = <<"3级生命宝石成就"/utf8>>,desc = <<"获得一颗3级生命宝石"/utf8>>,type = 4,subtype = 44,previous = 4000408,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270103,1,0,0},func = <<"[]"/utf8>>,reward = [{3,341},{240100101,3}],next = 4000410,give_up = 0,double_time = [],liveness_reward = 0};
get(4000410) ->
#base_task{id = 4000410,name = <<"3级攻击宝石成就"/utf8>>,desc = <<"获得一颗3级攻击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000409,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270203,1,0,0},func = <<"[]"/utf8>>,reward = [{3,359},{240100101,4}],next = 4000411,give_up = 0,double_time = [],liveness_reward = 0};
get(4000411) ->
#base_task{id = 4000411,name = <<"3级防御宝石成就"/utf8>>,desc = <<"获得一颗3级防御宝石"/utf8>>,type = 4,subtype = 44,previous = 4000410,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270303,1,0,0},func = <<"[]"/utf8>>,reward = [{3,376},{240100101,4}],next = 4000412,give_up = 0,double_time = [],liveness_reward = 0};
get(4000412) ->
#base_task{id = 4000412,name = <<"3级命中宝石成就"/utf8>>,desc = <<"获得一颗3级命中宝石"/utf8>>,type = 4,subtype = 44,previous = 4000411,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270403,1,0,0},func = <<"[]"/utf8>>,reward = [{3,395},{240100101,4}],next = 4000413,give_up = 0,double_time = [],liveness_reward = 0};
get(4000413) ->
#base_task{id = 4000413,name = <<"3级闪避宝石成就"/utf8>>,desc = <<"获得一颗3级闪避宝石"/utf8>>,type = 4,subtype = 44,previous = 4000412,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270503,1,0,0},func = <<"[]"/utf8>>,reward = [{3,415},{240100101,4}],next = 4000414,give_up = 0,double_time = [],liveness_reward = 0};
get(4000414) ->
#base_task{id = 4000414,name = <<"3级暴击宝石成就"/utf8>>,desc = <<"获得一颗3级暴击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000413,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270603,1,0,0},func = <<"[]"/utf8>>,reward = [{3,436},{240100101,4}],next = 4000415,give_up = 0,double_time = [],liveness_reward = 0};
get(4000415) ->
#base_task{id = 4000415,name = <<"3级抗暴宝石成就"/utf8>>,desc = <<"获得一颗3级抗暴宝石"/utf8>>,type = 4,subtype = 44,previous = 4000414,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270703,1,0,0},func = <<"[]"/utf8>>,reward = [{3,458},{240100101,5}],next = 4000416,give_up = 0,double_time = [],liveness_reward = 0};
get(4000416) ->
#base_task{id = 4000416,name = <<"3级能量宝石成就"/utf8>>,desc = <<"获得一颗3级能量宝石"/utf8>>,type = 4,subtype = 44,previous = 4000415,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270803,1,0,0},func = <<"[]"/utf8>>,reward = [{3,481},{240100101,5}],next = 4000417,give_up = 0,double_time = [],liveness_reward = 0};
get(4000417) ->
#base_task{id = 4000417,name = <<"4级生命宝石成就"/utf8>>,desc = <<"获得一颗4级生命宝石"/utf8>>,type = 4,subtype = 44,previous = 4000416,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270104,1,0,0},func = <<"[]"/utf8>>,reward = [{3,505},{240100101,5}],next = 4000418,give_up = 0,double_time = [],liveness_reward = 0};
get(4000418) ->
#base_task{id = 4000418,name = <<"4级攻击宝石成就"/utf8>>,desc = <<"获得一颗4级攻击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000417,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270204,1,0,0},func = <<"[]"/utf8>>,reward = [{3,530},{240100101,5}],next = 4000419,give_up = 0,double_time = [],liveness_reward = 0};
get(4000419) ->
#base_task{id = 4000419,name = <<"4级防御宝石成就"/utf8>>,desc = <<"获得一颗4级防御宝石"/utf8>>,type = 4,subtype = 44,previous = 4000418,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270304,1,0,0},func = <<"[]"/utf8>>,reward = [{3,556},{240100101,6}],next = 4000420,give_up = 0,double_time = [],liveness_reward = 0};
get(4000420) ->
#base_task{id = 4000420,name = <<"4级命中宝石成就"/utf8>>,desc = <<"获得一颗4级命中宝石"/utf8>>,type = 4,subtype = 44,previous = 4000419,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270404,1,0,0},func = <<"[]"/utf8>>,reward = [{3,584},{240100101,6}],next = 4000421,give_up = 0,double_time = [],liveness_reward = 0};
get(4000421) ->
#base_task{id = 4000421,name = <<"4级闪避宝石成就"/utf8>>,desc = <<"获得一颗4级闪避宝石"/utf8>>,type = 4,subtype = 44,previous = 4000420,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270504,1,0,0},func = <<"[]"/utf8>>,reward = [{3,613},{240100101,6}],next = 4000422,give_up = 0,double_time = [],liveness_reward = 0};
get(4000422) ->
#base_task{id = 4000422,name = <<"4级暴击宝石成就"/utf8>>,desc = <<"获得一颗4级暴击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000421,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270604,1,0,0},func = <<"[]"/utf8>>,reward = [{3,644},{240100101,6}],next = 4000423,give_up = 0,double_time = [],liveness_reward = 0};
get(4000423) ->
#base_task{id = 4000423,name = <<"4级抗暴宝石成就"/utf8>>,desc = <<"获得一颗4级抗暴宝石"/utf8>>,type = 4,subtype = 44,previous = 4000422,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270704,1,0,0},func = <<"[]"/utf8>>,reward = [{3,676},{240100101,7}],next = 4000424,give_up = 0,double_time = [],liveness_reward = 0};
get(4000424) ->
#base_task{id = 4000424,name = <<"4级能量宝石成就"/utf8>>,desc = <<"获得一颗4级能量宝石"/utf8>>,type = 4,subtype = 44,previous = 4000423,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270804,1,0,0},func = <<"[]"/utf8>>,reward = [{3,710},{240100101,7}],next = 4000425,give_up = 0,double_time = [],liveness_reward = 0};
get(4000425) ->
#base_task{id = 4000425,name = <<"5级生命宝石成就"/utf8>>,desc = <<"获得一颗5级生命宝石"/utf8>>,type = 4,subtype = 44,previous = 4000424,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270105,1,0,0},func = <<"[]"/utf8>>,reward = [{3,745},{240100101,7}],next = 4000426,give_up = 0,double_time = [],liveness_reward = 0};
get(4000426) ->
#base_task{id = 4000426,name = <<"5级攻击宝石成就"/utf8>>,desc = <<"获得一颗5级攻击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000425,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270205,1,0,0},func = <<"[]"/utf8>>,reward = [{3,783},{240100101,8}],next = 4000427,give_up = 0,double_time = [],liveness_reward = 0};
get(4000427) ->
#base_task{id = 4000427,name = <<"5级防御宝石成就"/utf8>>,desc = <<"获得一颗5级防御宝石"/utf8>>,type = 4,subtype = 44,previous = 4000426,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270305,1,0,0},func = <<"[]"/utf8>>,reward = [{3,822},{240100101,8}],next = 4000428,give_up = 0,double_time = [],liveness_reward = 0};
get(4000428) ->
#base_task{id = 4000428,name = <<"5级命中宝石成就"/utf8>>,desc = <<"获得一颗5级命中宝石"/utf8>>,type = 4,subtype = 44,previous = 4000427,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270405,1,0,0},func = <<"[]"/utf8>>,reward = [{3,863},{240100101,9}],next = 4000429,give_up = 0,double_time = [],liveness_reward = 0};
get(4000429) ->
#base_task{id = 4000429,name = <<"5级闪避宝石成就"/utf8>>,desc = <<"获得一颗5级闪避宝石"/utf8>>,type = 4,subtype = 44,previous = 4000428,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270505,1,0,0},func = <<"[]"/utf8>>,reward = [{3,906},{240100101,9}],next = 4000430,give_up = 0,double_time = [],liveness_reward = 0};
get(4000430) ->
#base_task{id = 4000430,name = <<"5级暴击宝石成就"/utf8>>,desc = <<"获得一颗5级暴击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000429,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270605,1,0,0},func = <<"[]"/utf8>>,reward = [{3,951},{240100101,10}],next = 4000431,give_up = 0,double_time = [],liveness_reward = 0};
get(4000431) ->
#base_task{id = 4000431,name = <<"5级抗暴宝石成就"/utf8>>,desc = <<"获得一颗5级抗暴宝石"/utf8>>,type = 4,subtype = 44,previous = 4000430,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270705,1,0,0},func = <<"[]"/utf8>>,reward = [{3,999},{240100101,10}],next = 4000432,give_up = 0,double_time = [],liveness_reward = 0};
get(4000432) ->
#base_task{id = 4000432,name = <<"5级能量宝石成就"/utf8>>,desc = <<"获得一颗5级能量宝石"/utf8>>,type = 4,subtype = 44,previous = 4000431,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270805,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1049},{240100101,10}],next = 4000433,give_up = 0,double_time = [],liveness_reward = 0};
get(4000433) ->
#base_task{id = 4000433,name = <<"6级生命宝石成就"/utf8>>,desc = <<"获得一颗6级生命宝石"/utf8>>,type = 4,subtype = 44,previous = 4000432,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270106,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1101},{240100101,11}],next = 4000434,give_up = 0,double_time = [],liveness_reward = 0};
get(4000434) ->
#base_task{id = 4000434,name = <<"6级攻击宝石成就"/utf8>>,desc = <<"获得一颗6级攻击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000433,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270206,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1156},{240100101,12}],next = 4000435,give_up = 0,double_time = [],liveness_reward = 0};
get(4000435) ->
#base_task{id = 4000435,name = <<"6级防御宝石成就"/utf8>>,desc = <<"获得一颗6级防御宝石"/utf8>>,type = 4,subtype = 44,previous = 4000434,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270306,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1214},{240100101,12}],next = 4000436,give_up = 0,double_time = [],liveness_reward = 0};
get(4000436) ->
#base_task{id = 4000436,name = <<"6级命中宝石成就"/utf8>>,desc = <<"获得一颗6级命中宝石"/utf8>>,type = 4,subtype = 44,previous = 4000435,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270406,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1275},{240100101,13}],next = 4000437,give_up = 0,double_time = [],liveness_reward = 0};
get(4000437) ->
#base_task{id = 4000437,name = <<"6级闪避宝石成就"/utf8>>,desc = <<"获得一颗6级闪避宝石"/utf8>>,type = 4,subtype = 44,previous = 4000436,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270506,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1339},{240100101,13}],next = 4000438,give_up = 0,double_time = [],liveness_reward = 0};
get(4000438) ->
#base_task{id = 4000438,name = <<"6级暴击宝石成就"/utf8>>,desc = <<"获得一颗6级暴击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000437,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270606,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1406},{240100101,14}],next = 4000439,give_up = 0,double_time = [],liveness_reward = 0};
get(4000439) ->
#base_task{id = 4000439,name = <<"6级抗暴宝石成就"/utf8>>,desc = <<"获得一颗6级抗暴宝石"/utf8>>,type = 4,subtype = 44,previous = 4000438,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270706,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1476},{240100101,15}],next = 4000440,give_up = 0,double_time = [],liveness_reward = 0};
get(4000440) ->
#base_task{id = 4000440,name = <<"6级能量宝石成就"/utf8>>,desc = <<"获得一颗6级能量宝石"/utf8>>,type = 4,subtype = 44,previous = 4000439,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270806,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1550},{240100101,15}],next = 4000441,give_up = 0,double_time = [],liveness_reward = 0};
get(4000441) ->
#base_task{id = 4000441,name = <<"7级生命宝石成就"/utf8>>,desc = <<"获得一颗7级生命宝石"/utf8>>,type = 4,subtype = 44,previous = 4000440,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270107,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1627},{240100101,16}],next = 4000442,give_up = 0,double_time = [],liveness_reward = 0};
get(4000442) ->
#base_task{id = 4000442,name = <<"7级攻击宝石成就"/utf8>>,desc = <<"获得一颗7级攻击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000441,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270207,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1709},{240100101,17}],next = 4000443,give_up = 0,double_time = [],liveness_reward = 0};
get(4000443) ->
#base_task{id = 4000443,name = <<"7级防御宝石成就"/utf8>>,desc = <<"获得一颗7级防御宝石"/utf8>>,type = 4,subtype = 44,previous = 4000442,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270307,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1794},{240100101,18}],next = 4000444,give_up = 0,double_time = [],liveness_reward = 0};
get(4000444) ->
#base_task{id = 4000444,name = <<"7级命中宝石成就"/utf8>>,desc = <<"获得一颗7级命中宝石"/utf8>>,type = 4,subtype = 44,previous = 4000443,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270407,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1884},{240100101,19}],next = 4000445,give_up = 0,double_time = [],liveness_reward = 0};
get(4000445) ->
#base_task{id = 4000445,name = <<"7级闪避宝石成就"/utf8>>,desc = <<"获得一颗7级闪避宝石"/utf8>>,type = 4,subtype = 44,previous = 4000444,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270507,1,0,0},func = <<"[]"/utf8>>,reward = [{3,1978},{240100101,20}],next = 4000446,give_up = 0,double_time = [],liveness_reward = 0};
get(4000446) ->
#base_task{id = 4000446,name = <<"7级暴击宝石成就"/utf8>>,desc = <<"获得一颗7级暴击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000445,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270607,1,0,0},func = <<"[]"/utf8>>,reward = [{3,2077},{240100101,21}],next = 4000447,give_up = 0,double_time = [],liveness_reward = 0};
get(4000447) ->
#base_task{id = 4000447,name = <<"7级抗暴宝石成就"/utf8>>,desc = <<"获得一颗7级抗暴宝石"/utf8>>,type = 4,subtype = 44,previous = 4000446,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270707,1,0,0},func = <<"[]"/utf8>>,reward = [{3,2181},{240100101,22}],next = 4000448,give_up = 0,double_time = [],liveness_reward = 0};
get(4000448) ->
#base_task{id = 4000448,name = <<"7级能量宝石成就"/utf8>>,desc = <<"获得一颗7级能量宝石"/utf8>>,type = 4,subtype = 44,previous = 4000447,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270807,1,0,0},func = <<"[]"/utf8>>,reward = [{3,2290},{240100101,23}],next = 4000449,give_up = 0,double_time = [],liveness_reward = 0};
get(4000449) ->
#base_task{id = 4000449,name = <<"8级生命宝石成就"/utf8>>,desc = <<"获得一颗8级生命宝石"/utf8>>,type = 4,subtype = 44,previous = 4000448,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270108,1,0,0},func = <<"[]"/utf8>>,reward = [{3,2404},{240100101,24}],next = 4000450,give_up = 0,double_time = [],liveness_reward = 0};
get(4000450) ->
#base_task{id = 4000450,name = <<"8级攻击宝石成就"/utf8>>,desc = <<"获得一颗8级攻击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000449,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270208,1,0,0},func = <<"[]"/utf8>>,reward = [{3,2524},{240100101,25}],next = 4000451,give_up = 0,double_time = [],liveness_reward = 0};
get(4000451) ->
#base_task{id = 4000451,name = <<"8级防御宝石成就"/utf8>>,desc = <<"获得一颗8级防御宝石"/utf8>>,type = 4,subtype = 44,previous = 4000450,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270308,1,0,0},func = <<"[]"/utf8>>,reward = [{3,2651},{240100101,27}],next = 4000452,give_up = 0,double_time = [],liveness_reward = 0};
get(4000452) ->
#base_task{id = 4000452,name = <<"8级命中宝石成就"/utf8>>,desc = <<"获得一颗8级命中宝石"/utf8>>,type = 4,subtype = 44,previous = 4000451,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270408,1,0,0},func = <<"[]"/utf8>>,reward = [{3,2783},{240100101,28}],next = 4000453,give_up = 0,double_time = [],liveness_reward = 0};
get(4000453) ->
#base_task{id = 4000453,name = <<"8级闪避宝石成就"/utf8>>,desc = <<"获得一颗8级闪避宝石"/utf8>>,type = 4,subtype = 44,previous = 4000452,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270508,1,0,0},func = <<"[]"/utf8>>,reward = [{3,2922},{240100101,29}],next = 4000454,give_up = 0,double_time = [],liveness_reward = 0};
get(4000454) ->
#base_task{id = 4000454,name = <<"8级暴击宝石成就"/utf8>>,desc = <<"获得一颗8级暴击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000453,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270608,1,0,0},func = <<"[]"/utf8>>,reward = [{3,3068},{240100101,31}],next = 4000455,give_up = 0,double_time = [],liveness_reward = 0};
get(4000455) ->
#base_task{id = 4000455,name = <<"8级抗暴宝石成就"/utf8>>,desc = <<"获得一颗8级抗暴宝石"/utf8>>,type = 4,subtype = 44,previous = 4000454,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270708,1,0,0},func = <<"[]"/utf8>>,reward = [{3,3222},{240100101,32}],next = 4000456,give_up = 0,double_time = [],liveness_reward = 0};
get(4000456) ->
#base_task{id = 4000456,name = <<"8级能量宝石成就"/utf8>>,desc = <<"获得一颗8级能量宝石"/utf8>>,type = 4,subtype = 44,previous = 4000455,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270808,1,0,0},func = <<"[]"/utf8>>,reward = [{3,3383},{240100101,34}],next = 4000457,give_up = 0,double_time = [],liveness_reward = 0};
get(4000457) ->
#base_task{id = 4000457,name = <<"9级生命宝石成就"/utf8>>,desc = <<"获得一颗9级生命宝石"/utf8>>,type = 4,subtype = 44,previous = 4000456,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270109,1,0,0},func = <<"[]"/utf8>>,reward = [{3,3552},{240100101,36}],next = 4000458,give_up = 0,double_time = [],liveness_reward = 0};
get(4000458) ->
#base_task{id = 4000458,name = <<"9级攻击宝石成就"/utf8>>,desc = <<"获得一颗9级攻击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000457,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270209,1,0,0},func = <<"[]"/utf8>>,reward = [{3,3730},{240100101,37}],next = 4000459,give_up = 0,double_time = [],liveness_reward = 0};
get(4000459) ->
#base_task{id = 4000459,name = <<"9级防御宝石成就"/utf8>>,desc = <<"获得一颗9级防御宝石"/utf8>>,type = 4,subtype = 44,previous = 4000458,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270309,1,0,0},func = <<"[]"/utf8>>,reward = [{3,3916},{240100101,39}],next = 4000460,give_up = 0,double_time = [],liveness_reward = 0};
get(4000460) ->
#base_task{id = 4000460,name = <<"9级命中宝石成就"/utf8>>,desc = <<"获得一颗9级命中宝石"/utf8>>,type = 4,subtype = 44,previous = 4000459,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270409,1,0,0},func = <<"[]"/utf8>>,reward = [{3,4112},{240100101,41}],next = 4000461,give_up = 0,double_time = [],liveness_reward = 0};
get(4000461) ->
#base_task{id = 4000461,name = <<"9级闪避宝石成就"/utf8>>,desc = <<"获得一颗9级闪避宝石"/utf8>>,type = 4,subtype = 44,previous = 4000460,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270509,1,0,0},func = <<"[]"/utf8>>,reward = [{3,4317},{240100101,43}],next = 4000462,give_up = 0,double_time = [],liveness_reward = 0};
get(4000462) ->
#base_task{id = 4000462,name = <<"9级暴击宝石成就"/utf8>>,desc = <<"获得一颗9级暴击宝石"/utf8>>,type = 4,subtype = 44,previous = 4000461,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270609,1,0,0},func = <<"[]"/utf8>>,reward = [{3,4533},{240100101,45}],next = 4000463,give_up = 0,double_time = [],liveness_reward = 0};
get(4000463) ->
#base_task{id = 4000463,name = <<"9级抗暴宝石成就"/utf8>>,desc = <<"获得一颗9级抗暴宝石"/utf8>>,type = 4,subtype = 44,previous = 4000462,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270709,1,0,0},func = <<"[]"/utf8>>,reward = [{3,4760},{240100101,48}],next = 4000464,give_up = 0,double_time = [],liveness_reward = 0};
get(4000464) ->
#base_task{id = 4000464,name = <<"9级能量宝石成就"/utf8>>,desc = <<"获得一颗9级能量宝石"/utf8>>,type = 4,subtype = 44,previous = 4000463,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,270809,1,0,0},func = <<"[]"/utf8>>,reward = [{3,4998},{240100101,50}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4000501) ->
#base_task{id = 4000501,name = <<"装备强化(3件强10)"/utf8>>,desc = <<"拥有3件强化到10的装备"/utf8>>,type = 4,subtype = 45,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,1,10},func = <<"[]"/utf8>>,reward = [{3,485},{240100101,5}],next = 4000502,give_up = 0,double_time = [],liveness_reward = 0};
get(4000502) ->
#base_task{id = 4000502,name = <<"装备强化(4件强10)"/utf8>>,desc = <<"拥有4件强化到10的装备"/utf8>>,type = 4,subtype = 45,previous = 4000501,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,1,10},func = <<"[]"/utf8>>,reward = [{3,543},{240100101,5}],next = 4000503,give_up = 0,double_time = [],liveness_reward = 0};
get(4000503) ->
#base_task{id = 4000503,name = <<"装备强化(5件强10)"/utf8>>,desc = <<"拥有5件强化到10的装备"/utf8>>,type = 4,subtype = 45,previous = 4000502,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,1,10},func = <<"[]"/utf8>>,reward = [{3,608},{240100101,6}],next = 4000504,give_up = 0,double_time = [],liveness_reward = 0};
get(4000504) ->
#base_task{id = 4000504,name = <<"装备强化(6件强10)"/utf8>>,desc = <<"拥有6件强化到10的装备"/utf8>>,type = 4,subtype = 45,previous = 4000503,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,1,10},func = <<"[]"/utf8>>,reward = [{3,681},{240100101,7}],next = 4000505,give_up = 0,double_time = [],liveness_reward = 0};
get(4000505) ->
#base_task{id = 4000505,name = <<"装备强化(3件强20)"/utf8>>,desc = <<"拥有3件强化到20的装备"/utf8>>,type = 4,subtype = 45,previous = 4000504,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,1,20},func = <<"[]"/utf8>>,reward = [{3,763},{240100101,8}],next = 4000506,give_up = 0,double_time = [],liveness_reward = 0};
get(4000506) ->
#base_task{id = 4000506,name = <<"装备强化(4件强20)"/utf8>>,desc = <<"拥有4件强化到20的装备"/utf8>>,type = 4,subtype = 45,previous = 4000505,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,1,20},func = <<"[]"/utf8>>,reward = [{3,855},{240100101,9}],next = 4000507,give_up = 0,double_time = [],liveness_reward = 0};
get(4000507) ->
#base_task{id = 4000507,name = <<"装备强化(5件强20)"/utf8>>,desc = <<"拥有5件强化到20的装备"/utf8>>,type = 4,subtype = 45,previous = 4000506,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,1,20},func = <<"[]"/utf8>>,reward = [{3,957},{240100101,10}],next = 4000508,give_up = 0,double_time = [],liveness_reward = 0};
get(4000508) ->
#base_task{id = 4000508,name = <<"装备强化(6件强20)"/utf8>>,desc = <<"拥有6件强化到20的装备"/utf8>>,type = 4,subtype = 45,previous = 4000507,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,1,20},func = <<"[]"/utf8>>,reward = [{3,1072},{240100101,11}],next = 4000509,give_up = 0,double_time = [],liveness_reward = 0};
get(4000509) ->
#base_task{id = 4000509,name = <<"装备强化(3件强30)"/utf8>>,desc = <<"拥有3件强化到30的装备"/utf8>>,type = 4,subtype = 45,previous = 4000508,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,1,30},func = <<"[]"/utf8>>,reward = [{3,1201},{240100101,12}],next = 4000510,give_up = 0,double_time = [],liveness_reward = 0};
get(4000510) ->
#base_task{id = 4000510,name = <<"装备强化(4件强30)"/utf8>>,desc = <<"拥有4件强化到30的装备"/utf8>>,type = 4,subtype = 45,previous = 4000509,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,1,30},func = <<"[]"/utf8>>,reward = [{3,1345},{240100101,13}],next = 4000511,give_up = 0,double_time = [],liveness_reward = 0};
get(4000511) ->
#base_task{id = 4000511,name = <<"装备强化(5件强30)"/utf8>>,desc = <<"拥有5件强化到30的装备"/utf8>>,type = 4,subtype = 45,previous = 4000510,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,1,30},func = <<"[]"/utf8>>,reward = [{3,1506},{240100101,15}],next = 4000512,give_up = 0,double_time = [],liveness_reward = 0};
get(4000512) ->
#base_task{id = 4000512,name = <<"装备强化(6件强30)"/utf8>>,desc = <<"拥有6件强化到30的装备"/utf8>>,type = 4,subtype = 45,previous = 4000511,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,1,30},func = <<"[]"/utf8>>,reward = [{3,1687},{240100101,17}],next = 4000513,give_up = 0,double_time = [],liveness_reward = 0};
get(4000513) ->
#base_task{id = 4000513,name = <<"装备强化(3件强40)"/utf8>>,desc = <<"拥有3件强化到40的装备"/utf8>>,type = 4,subtype = 45,previous = 4000512,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,1,40},func = <<"[]"/utf8>>,reward = [{3,1890},{240100101,19}],next = 4000514,give_up = 0,double_time = [],liveness_reward = 0};
get(4000514) ->
#base_task{id = 4000514,name = <<"装备强化(4件强40)"/utf8>>,desc = <<"拥有4件强化到40的装备"/utf8>>,type = 4,subtype = 45,previous = 4000513,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,1,40},func = <<"[]"/utf8>>,reward = [{3,2116},{240100101,21}],next = 4000515,give_up = 0,double_time = [],liveness_reward = 0};
get(4000515) ->
#base_task{id = 4000515,name = <<"装备强化(5件强40)"/utf8>>,desc = <<"拥有5件强化到40的装备"/utf8>>,type = 4,subtype = 45,previous = 4000514,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,1,40},func = <<"[]"/utf8>>,reward = [{3,2370},{240100101,24}],next = 4000516,give_up = 0,double_time = [],liveness_reward = 0};
get(4000516) ->
#base_task{id = 4000516,name = <<"装备强化(6件强40)"/utf8>>,desc = <<"拥有6件强化到40的装备"/utf8>>,type = 4,subtype = 45,previous = 4000515,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,1,40},func = <<"[]"/utf8>>,reward = [{3,2655},{240100101,27}],next = 4000517,give_up = 0,double_time = [],liveness_reward = 0};
get(4000517) ->
#base_task{id = 4000517,name = <<"装备强化(3件强50)"/utf8>>,desc = <<"拥有3件强化到50的装备"/utf8>>,type = 4,subtype = 45,previous = 4000516,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,1,50},func = <<"[]"/utf8>>,reward = [{3,2974},{240100101,30}],next = 4000518,give_up = 0,double_time = [],liveness_reward = 0};
get(4000518) ->
#base_task{id = 4000518,name = <<"装备强化(4件强50)"/utf8>>,desc = <<"拥有4件强化到50的装备"/utf8>>,type = 4,subtype = 45,previous = 4000517,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,1,50},func = <<"[]"/utf8>>,reward = [{3,3330},{240100101,33}],next = 4000519,give_up = 0,double_time = [],liveness_reward = 0};
get(4000519) ->
#base_task{id = 4000519,name = <<"装备强化(5件强50)"/utf8>>,desc = <<"拥有5件强化到50的装备"/utf8>>,type = 4,subtype = 45,previous = 4000518,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,1,50},func = <<"[]"/utf8>>,reward = [{3,3730},{240100101,37}],next = 4000520,give_up = 0,double_time = [],liveness_reward = 0};
get(4000520) ->
#base_task{id = 4000520,name = <<"装备强化(6件强50)"/utf8>>,desc = <<"拥有6件强化到50的装备"/utf8>>,type = 4,subtype = 45,previous = 4000519,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,1,50},func = <<"[]"/utf8>>,reward = [{3,4178},{240100101,42}],next = 4000521,give_up = 0,double_time = [],liveness_reward = 0};
get(4000521) ->
#base_task{id = 4000521,name = <<"装备强化(3件强60)"/utf8>>,desc = <<"拥有3件强化到60的装备"/utf8>>,type = 4,subtype = 45,previous = 4000520,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,1,60},func = <<"[]"/utf8>>,reward = [{3,4679},{240100101,47}],next = 4000522,give_up = 0,double_time = [],liveness_reward = 0};
get(4000522) ->
#base_task{id = 4000522,name = <<"装备强化(4件强60)"/utf8>>,desc = <<"拥有4件强化到60的装备"/utf8>>,type = 4,subtype = 45,previous = 4000521,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,1,60},func = <<"[]"/utf8>>,reward = [{3,5240},{240100101,52}],next = 4000523,give_up = 0,double_time = [],liveness_reward = 0};
get(4000523) ->
#base_task{id = 4000523,name = <<"装备强化(5件强60)"/utf8>>,desc = <<"拥有5件强化到60的装备"/utf8>>,type = 4,subtype = 45,previous = 4000522,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,1,60},func = <<"[]"/utf8>>,reward = [{3,5869},{240100101,59}],next = 4000524,give_up = 0,double_time = [],liveness_reward = 0};
get(4000524) ->
#base_task{id = 4000524,name = <<"装备强化(6件强60)"/utf8>>,desc = <<"拥有6件强化到60的装备"/utf8>>,type = 4,subtype = 45,previous = 4000523,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,1,60},func = <<"[]"/utf8>>,reward = [{3,6574},{240100101,66}],next = 4000525,give_up = 0,double_time = [],liveness_reward = 0};
get(4000525) ->
#base_task{id = 4000525,name = <<"装备强化(3件强70)"/utf8>>,desc = <<"拥有3件强化到70的装备"/utf8>>,type = 4,subtype = 45,previous = 4000524,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,1,70},func = <<"[]"/utf8>>,reward = [{3,7362},{240100101,74}],next = 4000526,give_up = 0,double_time = [],liveness_reward = 0};
get(4000526) ->
#base_task{id = 4000526,name = <<"装备强化(4件强70)"/utf8>>,desc = <<"拥有4件强化到70的装备"/utf8>>,type = 4,subtype = 45,previous = 4000525,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,1,70},func = <<"[]"/utf8>>,reward = [{3,8246},{240100101,82}],next = 4000527,give_up = 0,double_time = [],liveness_reward = 0};
get(4000527) ->
#base_task{id = 4000527,name = <<"装备强化(5件强70)"/utf8>>,desc = <<"拥有5件强化到70的装备"/utf8>>,type = 4,subtype = 45,previous = 4000526,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,1,70},func = <<"[]"/utf8>>,reward = [{3,9235},{240100101,92}],next = 4000528,give_up = 0,double_time = [],liveness_reward = 0};
get(4000528) ->
#base_task{id = 4000528,name = <<"装备强化(6件强70)"/utf8>>,desc = <<"拥有6件强化到70的装备"/utf8>>,type = 4,subtype = 45,previous = 4000527,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,1,70},func = <<"[]"/utf8>>,reward = [{3,10344},{240100101,103}],next = 4000529,give_up = 0,double_time = [],liveness_reward = 0};
get(4000529) ->
#base_task{id = 4000529,name = <<"装备强化(3件强80)"/utf8>>,desc = <<"拥有3件强化到80的装备"/utf8>>,type = 4,subtype = 45,previous = 4000528,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,1,80},func = <<"[]"/utf8>>,reward = [{3,11585},{240100101,116}],next = 4000530,give_up = 0,double_time = [],liveness_reward = 0};
get(4000530) ->
#base_task{id = 4000530,name = <<"装备强化(4件强80)"/utf8>>,desc = <<"拥有4件强化到80的装备"/utf8>>,type = 4,subtype = 45,previous = 4000529,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,1,80},func = <<"[]"/utf8>>,reward = [{3,12975},{240100101,130}],next = 4000531,give_up = 0,double_time = [],liveness_reward = 0};
get(4000531) ->
#base_task{id = 4000531,name = <<"装备强化(5件强80)"/utf8>>,desc = <<"拥有5件强化到80的装备"/utf8>>,type = 4,subtype = 45,previous = 4000530,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,1,80},func = <<"[]"/utf8>>,reward = [{3,14532},{240100101,145}],next = 4000532,give_up = 0,double_time = [],liveness_reward = 0};
get(4000532) ->
#base_task{id = 4000532,name = <<"装备强化(6件强80)"/utf8>>,desc = <<"拥有6件强化到80的装备"/utf8>>,type = 4,subtype = 45,previous = 4000531,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,1,80},func = <<"[]"/utf8>>,reward = [{3,16276},{240100101,163}],next = 4000533,give_up = 0,double_time = [],liveness_reward = 0};
get(4000533) ->
#base_task{id = 4000533,name = <<"装备强化(3件强90)"/utf8>>,desc = <<"拥有3件强化到90的装备"/utf8>>,type = 4,subtype = 45,previous = 4000532,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,1,90},func = <<"[]"/utf8>>,reward = [{3,18229},{240100101,182}],next = 4000534,give_up = 0,double_time = [],liveness_reward = 0};
get(4000534) ->
#base_task{id = 4000534,name = <<"装备强化(4件强90)"/utf8>>,desc = <<"拥有4件强化到90的装备"/utf8>>,type = 4,subtype = 45,previous = 4000533,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,1,90},func = <<"[]"/utf8>>,reward = [{3,20416},{240100101,204}],next = 4000535,give_up = 0,double_time = [],liveness_reward = 0};
get(4000535) ->
#base_task{id = 4000535,name = <<"装备强化(5件强90)"/utf8>>,desc = <<"拥有5件强化到90的装备"/utf8>>,type = 4,subtype = 45,previous = 4000534,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,1,90},func = <<"[]"/utf8>>,reward = [{3,22866},{240100101,229}],next = 4000536,give_up = 0,double_time = [],liveness_reward = 0};
get(4000536) ->
#base_task{id = 4000536,name = <<"装备强化(6件强90)"/utf8>>,desc = <<"拥有6件强化到90的装备"/utf8>>,type = 4,subtype = 45,previous = 4000535,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,1,90},func = <<"[]"/utf8>>,reward = [{3,25610},{240100101,256}],next = 4000537,give_up = 0,double_time = [],liveness_reward = 0};
get(4000537) ->
#base_task{id = 4000537,name = <<"装备强化(3件强100)"/utf8>>,desc = <<"拥有3件强化到100的装备"/utf8>>,type = 4,subtype = 45,previous = 4000536,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,1,100},func = <<"[]"/utf8>>,reward = [{3,28684},{240100101,287}],next = 4000538,give_up = 0,double_time = [],liveness_reward = 0};
get(4000538) ->
#base_task{id = 4000538,name = <<"装备强化(4件强100)"/utf8>>,desc = <<"拥有4件强化到100的装备"/utf8>>,type = 4,subtype = 45,previous = 4000537,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,1,100},func = <<"[]"/utf8>>,reward = [{3,32126},{240100101,321}],next = 4000539,give_up = 0,double_time = [],liveness_reward = 0};
get(4000539) ->
#base_task{id = 4000539,name = <<"装备强化(5件强100)"/utf8>>,desc = <<"拥有5件强化到100的装备"/utf8>>,type = 4,subtype = 45,previous = 4000538,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,1,100},func = <<"[]"/utf8>>,reward = [{3,35981},{240100101,360}],next = 4000540,give_up = 0,double_time = [],liveness_reward = 0};
get(4000540) ->
#base_task{id = 4000540,name = <<"装备强化(6件强100)"/utf8>>,desc = <<"拥有6件强化到100的装备"/utf8>>,type = 4,subtype = 45,previous = 4000539,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,1,100},func = <<"[]"/utf8>>,reward = [{3,40298},{240100101,403}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4000601) ->
#base_task{id = 4000601,name = <<"装备升星(3件强10)"/utf8>>,desc = <<"拥有3件升星到10的装备"/utf8>>,type = 4,subtype = 46,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,2,10},func = <<"[]"/utf8>>,reward = [{3,485},{240100101,5}],next = 4000602,give_up = 0,double_time = [],liveness_reward = 0};
get(4000602) ->
#base_task{id = 4000602,name = <<"装备升星(4件强10)"/utf8>>,desc = <<"拥有4件升星到10的装备"/utf8>>,type = 4,subtype = 46,previous = 4000601,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,2,10},func = <<"[]"/utf8>>,reward = [{3,543},{240100101,5}],next = 4000603,give_up = 0,double_time = [],liveness_reward = 0};
get(4000603) ->
#base_task{id = 4000603,name = <<"装备升星(5件强10)"/utf8>>,desc = <<"拥有5件升星到10的装备"/utf8>>,type = 4,subtype = 46,previous = 4000602,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,2,10},func = <<"[]"/utf8>>,reward = [{3,608},{240100101,6}],next = 4000604,give_up = 0,double_time = [],liveness_reward = 0};
get(4000604) ->
#base_task{id = 4000604,name = <<"装备升星(6件强10)"/utf8>>,desc = <<"拥有6件升星到10的装备"/utf8>>,type = 4,subtype = 46,previous = 4000603,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,2,10},func = <<"[]"/utf8>>,reward = [{3,681},{240100101,7}],next = 4000605,give_up = 0,double_time = [],liveness_reward = 0};
get(4000605) ->
#base_task{id = 4000605,name = <<"装备升星(3件强20)"/utf8>>,desc = <<"拥有3件升星到20的装备"/utf8>>,type = 4,subtype = 46,previous = 4000604,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,2,20},func = <<"[]"/utf8>>,reward = [{3,763},{240100101,8}],next = 4000606,give_up = 0,double_time = [],liveness_reward = 0};
get(4000606) ->
#base_task{id = 4000606,name = <<"装备升星(4件强20)"/utf8>>,desc = <<"拥有4件升星到20的装备"/utf8>>,type = 4,subtype = 46,previous = 4000605,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,2,20},func = <<"[]"/utf8>>,reward = [{3,855},{240100101,9}],next = 4000607,give_up = 0,double_time = [],liveness_reward = 0};
get(4000607) ->
#base_task{id = 4000607,name = <<"装备升星(5件强20)"/utf8>>,desc = <<"拥有5件升星到20的装备"/utf8>>,type = 4,subtype = 46,previous = 4000606,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,2,20},func = <<"[]"/utf8>>,reward = [{3,957},{240100101,10}],next = 4000608,give_up = 0,double_time = [],liveness_reward = 0};
get(4000608) ->
#base_task{id = 4000608,name = <<"装备升星(6件强20)"/utf8>>,desc = <<"拥有6件升星到20的装备"/utf8>>,type = 4,subtype = 46,previous = 4000607,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,2,20},func = <<"[]"/utf8>>,reward = [{3,1072},{240100101,11}],next = 4000609,give_up = 0,double_time = [],liveness_reward = 0};
get(4000609) ->
#base_task{id = 4000609,name = <<"装备升星(3件强30)"/utf8>>,desc = <<"拥有3件升星到30的装备"/utf8>>,type = 4,subtype = 46,previous = 4000608,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,2,30},func = <<"[]"/utf8>>,reward = [{3,1201},{240100101,12}],next = 4000610,give_up = 0,double_time = [],liveness_reward = 0};
get(4000610) ->
#base_task{id = 4000610,name = <<"装备升星(4件强30)"/utf8>>,desc = <<"拥有4件升星到30的装备"/utf8>>,type = 4,subtype = 46,previous = 4000609,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,2,30},func = <<"[]"/utf8>>,reward = [{3,1345},{240100101,13}],next = 4000611,give_up = 0,double_time = [],liveness_reward = 0};
get(4000611) ->
#base_task{id = 4000611,name = <<"装备升星(5件强30)"/utf8>>,desc = <<"拥有5件升星到30的装备"/utf8>>,type = 4,subtype = 46,previous = 4000610,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,2,30},func = <<"[]"/utf8>>,reward = [{3,1506},{240100101,15}],next = 4000612,give_up = 0,double_time = [],liveness_reward = 0};
get(4000612) ->
#base_task{id = 4000612,name = <<"装备升星(6件强30)"/utf8>>,desc = <<"拥有6件升星到30的装备"/utf8>>,type = 4,subtype = 46,previous = 4000611,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,2,30},func = <<"[]"/utf8>>,reward = [{3,1687},{240100101,17}],next = 4000613,give_up = 0,double_time = [],liveness_reward = 0};
get(4000613) ->
#base_task{id = 4000613,name = <<"装备升星(3件强40)"/utf8>>,desc = <<"拥有3件升星到40的装备"/utf8>>,type = 4,subtype = 46,previous = 4000612,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,2,40},func = <<"[]"/utf8>>,reward = [{3,1890},{240100101,19}],next = 4000614,give_up = 0,double_time = [],liveness_reward = 0};
get(4000614) ->
#base_task{id = 4000614,name = <<"装备升星(4件强40)"/utf8>>,desc = <<"拥有4件升星到40的装备"/utf8>>,type = 4,subtype = 46,previous = 4000613,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,2,40},func = <<"[]"/utf8>>,reward = [{3,2116},{240100101,21}],next = 4000615,give_up = 0,double_time = [],liveness_reward = 0};
get(4000615) ->
#base_task{id = 4000615,name = <<"装备升星(5件强40)"/utf8>>,desc = <<"拥有5件升星到40的装备"/utf8>>,type = 4,subtype = 46,previous = 4000614,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,2,40},func = <<"[]"/utf8>>,reward = [{3,2370},{240100101,24}],next = 4000616,give_up = 0,double_time = [],liveness_reward = 0};
get(4000616) ->
#base_task{id = 4000616,name = <<"装备升星(6件强40)"/utf8>>,desc = <<"拥有6件升星到40的装备"/utf8>>,type = 4,subtype = 46,previous = 4000615,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,2,40},func = <<"[]"/utf8>>,reward = [{3,2655},{240100101,27}],next = 4000617,give_up = 0,double_time = [],liveness_reward = 0};
get(4000617) ->
#base_task{id = 4000617,name = <<"装备升星(3件强50)"/utf8>>,desc = <<"拥有3件升星到50的装备"/utf8>>,type = 4,subtype = 46,previous = 4000616,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,2,50},func = <<"[]"/utf8>>,reward = [{3,2974},{240100101,30}],next = 4000618,give_up = 0,double_time = [],liveness_reward = 0};
get(4000618) ->
#base_task{id = 4000618,name = <<"装备升星(4件强50)"/utf8>>,desc = <<"拥有4件升星到50的装备"/utf8>>,type = 4,subtype = 46,previous = 4000617,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,2,50},func = <<"[]"/utf8>>,reward = [{3,3330},{240100101,33}],next = 4000619,give_up = 0,double_time = [],liveness_reward = 0};
get(4000619) ->
#base_task{id = 4000619,name = <<"装备升星(5件强50)"/utf8>>,desc = <<"拥有5件升星到50的装备"/utf8>>,type = 4,subtype = 46,previous = 4000618,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,2,50},func = <<"[]"/utf8>>,reward = [{3,3730},{240100101,37}],next = 4000620,give_up = 0,double_time = [],liveness_reward = 0};
get(4000620) ->
#base_task{id = 4000620,name = <<"装备升星(6件强50)"/utf8>>,desc = <<"拥有6件升星到50的装备"/utf8>>,type = 4,subtype = 46,previous = 4000619,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,2,50},func = <<"[]"/utf8>>,reward = [{3,4178},{240100101,42}],next = 4000621,give_up = 0,double_time = [],liveness_reward = 0};
get(4000621) ->
#base_task{id = 4000621,name = <<"装备升星(3件强60)"/utf8>>,desc = <<"拥有3件升星到60的装备"/utf8>>,type = 4,subtype = 46,previous = 4000620,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,2,60},func = <<"[]"/utf8>>,reward = [{3,4679},{240100101,47}],next = 4000622,give_up = 0,double_time = [],liveness_reward = 0};
get(4000622) ->
#base_task{id = 4000622,name = <<"装备升星(4件强60)"/utf8>>,desc = <<"拥有4件升星到60的装备"/utf8>>,type = 4,subtype = 46,previous = 4000621,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,2,60},func = <<"[]"/utf8>>,reward = [{3,5240},{240100101,52}],next = 4000623,give_up = 0,double_time = [],liveness_reward = 0};
get(4000623) ->
#base_task{id = 4000623,name = <<"装备升星(5件强60)"/utf8>>,desc = <<"拥有5件升星到60的装备"/utf8>>,type = 4,subtype = 46,previous = 4000622,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,2,60},func = <<"[]"/utf8>>,reward = [{3,5869},{240100101,59}],next = 4000624,give_up = 0,double_time = [],liveness_reward = 0};
get(4000624) ->
#base_task{id = 4000624,name = <<"装备升星(6件强60)"/utf8>>,desc = <<"拥有6件升星到60的装备"/utf8>>,type = 4,subtype = 46,previous = 4000623,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,2,60},func = <<"[]"/utf8>>,reward = [{3,6574},{240100101,66}],next = 4000625,give_up = 0,double_time = [],liveness_reward = 0};
get(4000625) ->
#base_task{id = 4000625,name = <<"装备升星(3件强70)"/utf8>>,desc = <<"拥有3件升星到70的装备"/utf8>>,type = 4,subtype = 46,previous = 4000624,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,2,70},func = <<"[]"/utf8>>,reward = [{3,7362},{240100101,74}],next = 4000626,give_up = 0,double_time = [],liveness_reward = 0};
get(4000626) ->
#base_task{id = 4000626,name = <<"装备升星(4件强70)"/utf8>>,desc = <<"拥有4件升星到70的装备"/utf8>>,type = 4,subtype = 46,previous = 4000625,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,2,70},func = <<"[]"/utf8>>,reward = [{3,8246},{240100101,82}],next = 4000627,give_up = 0,double_time = [],liveness_reward = 0};
get(4000627) ->
#base_task{id = 4000627,name = <<"装备升星(5件强70)"/utf8>>,desc = <<"拥有5件升星到70的装备"/utf8>>,type = 4,subtype = 46,previous = 4000626,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,2,70},func = <<"[]"/utf8>>,reward = [{3,9235},{240100101,92}],next = 4000628,give_up = 0,double_time = [],liveness_reward = 0};
get(4000628) ->
#base_task{id = 4000628,name = <<"装备升星(6件强70)"/utf8>>,desc = <<"拥有6件升星到70的装备"/utf8>>,type = 4,subtype = 46,previous = 4000627,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,2,70},func = <<"[]"/utf8>>,reward = [{3,10344},{240100101,103}],next = 4000629,give_up = 0,double_time = [],liveness_reward = 0};
get(4000629) ->
#base_task{id = 4000629,name = <<"装备升星(3件强80)"/utf8>>,desc = <<"拥有3件升星到80的装备"/utf8>>,type = 4,subtype = 46,previous = 4000628,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,2,80},func = <<"[]"/utf8>>,reward = [{3,11585},{240100101,116}],next = 4000630,give_up = 0,double_time = [],liveness_reward = 0};
get(4000630) ->
#base_task{id = 4000630,name = <<"装备升星(4件强80)"/utf8>>,desc = <<"拥有4件升星到80的装备"/utf8>>,type = 4,subtype = 46,previous = 4000629,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,2,80},func = <<"[]"/utf8>>,reward = [{3,12975},{240100101,130}],next = 4000631,give_up = 0,double_time = [],liveness_reward = 0};
get(4000631) ->
#base_task{id = 4000631,name = <<"装备升星(5件强80)"/utf8>>,desc = <<"拥有5件升星到80的装备"/utf8>>,type = 4,subtype = 46,previous = 4000630,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,2,80},func = <<"[]"/utf8>>,reward = [{3,14532},{240100101,145}],next = 4000632,give_up = 0,double_time = [],liveness_reward = 0};
get(4000632) ->
#base_task{id = 4000632,name = <<"装备升星(6件强80)"/utf8>>,desc = <<"拥有6件升星到80的装备"/utf8>>,type = 4,subtype = 46,previous = 4000631,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,2,80},func = <<"[]"/utf8>>,reward = [{3,16276},{240100101,163}],next = 4000633,give_up = 0,double_time = [],liveness_reward = 0};
get(4000633) ->
#base_task{id = 4000633,name = <<"装备升星(3件强90)"/utf8>>,desc = <<"拥有3件升星到90的装备"/utf8>>,type = 4,subtype = 46,previous = 4000632,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,2,90},func = <<"[]"/utf8>>,reward = [{3,18229},{240100101,182}],next = 4000634,give_up = 0,double_time = [],liveness_reward = 0};
get(4000634) ->
#base_task{id = 4000634,name = <<"装备升星(4件强90)"/utf8>>,desc = <<"拥有4件升星到90的装备"/utf8>>,type = 4,subtype = 46,previous = 4000633,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,2,90},func = <<"[]"/utf8>>,reward = [{3,20416},{240100101,204}],next = 4000635,give_up = 0,double_time = [],liveness_reward = 0};
get(4000635) ->
#base_task{id = 4000635,name = <<"装备升星(5件强90)"/utf8>>,desc = <<"拥有5件升星到90的装备"/utf8>>,type = 4,subtype = 46,previous = 4000634,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,2,90},func = <<"[]"/utf8>>,reward = [{3,22866},{240100101,229}],next = 4000636,give_up = 0,double_time = [],liveness_reward = 0};
get(4000636) ->
#base_task{id = 4000636,name = <<"装备升星(6件强90)"/utf8>>,desc = <<"拥有6件升星到90的装备"/utf8>>,type = 4,subtype = 46,previous = 4000635,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,2,90},func = <<"[]"/utf8>>,reward = [{3,25610},{240100101,256}],next = 4000637,give_up = 0,double_time = [],liveness_reward = 0};
get(4000637) ->
#base_task{id = 4000637,name = <<"装备升星(3件强100)"/utf8>>,desc = <<"拥有3件升星到100的装备"/utf8>>,type = 4,subtype = 46,previous = 4000636,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,3,2,100},func = <<"[]"/utf8>>,reward = [{3,28684},{240100101,287}],next = 4000638,give_up = 0,double_time = [],liveness_reward = 0};
get(4000638) ->
#base_task{id = 4000638,name = <<"装备升星(4件强100)"/utf8>>,desc = <<"拥有4件升星到100的装备"/utf8>>,type = 4,subtype = 46,previous = 4000637,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,4,2,100},func = <<"[]"/utf8>>,reward = [{3,32126},{240100101,321}],next = 4000639,give_up = 0,double_time = [],liveness_reward = 0};
get(4000639) ->
#base_task{id = 4000639,name = <<"装备升星(5件强100)"/utf8>>,desc = <<"拥有5件升星到100的装备"/utf8>>,type = 4,subtype = 46,previous = 4000638,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,5,2,100},func = <<"[]"/utf8>>,reward = [{3,35981},{240100101,360}],next = 4000640,give_up = 0,double_time = [],liveness_reward = 0};
get(4000640) ->
#base_task{id = 4000640,name = <<"装备升星(6件强100)"/utf8>>,desc = <<"拥有6件升星到100的装备"/utf8>>,type = 4,subtype = 46,previous = 4000639,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {9,0,6,2,100},func = <<"[]"/utf8>>,reward = [{3,40298},{240100101,403}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4000901) ->
#base_task{id = 4000901,name = <<"战斗连击数(200次)"/utf8>>,desc = <<"单个副本中连击数达到200"/utf8>>,type = 4,subtype = 49,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,200},func = <<"[]"/utf8>>,reward = [{3,358},{240100101,4}],next = 4000902,give_up = 0,double_time = [],liveness_reward = 0};
get(4000902) ->
#base_task{id = 4000902,name = <<"战斗连击数(600次)"/utf8>>,desc = <<"单个副本中连击数达到600"/utf8>>,type = 4,subtype = 49,previous = 4000901,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,600},func = <<"[]"/utf8>>,reward = [{3,430},{240100101,4}],next = 4000903,give_up = 0,double_time = [],liveness_reward = 0};
get(4000903) ->
#base_task{id = 4000903,name = <<"战斗连击数(1000次)"/utf8>>,desc = <<"单个副本中连击数达到1000"/utf8>>,type = 4,subtype = 49,previous = 4000902,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,1000},func = <<"[]"/utf8>>,reward = [{3,516},{240100101,5}],next = 4000904,give_up = 0,double_time = [],liveness_reward = 0};
get(4000904) ->
#base_task{id = 4000904,name = <<"战斗连击数(1400次)"/utf8>>,desc = <<"单个副本中连击数达到1400"/utf8>>,type = 4,subtype = 49,previous = 4000903,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,1400},func = <<"[]"/utf8>>,reward = [{3,619},{240100101,6}],next = 4000905,give_up = 0,double_time = [],liveness_reward = 0};
get(4000905) ->
#base_task{id = 4000905,name = <<"战斗连击数(1800次)"/utf8>>,desc = <<"单个副本中连击数达到1800"/utf8>>,type = 4,subtype = 49,previous = 4000904,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,1800},func = <<"[]"/utf8>>,reward = [{3,743},{240100101,7}],next = 4000906,give_up = 0,double_time = [],liveness_reward = 0};
get(4000906) ->
#base_task{id = 4000906,name = <<"战斗连击数(2200次)"/utf8>>,desc = <<"单个副本中连击数达到2200"/utf8>>,type = 4,subtype = 49,previous = 4000905,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,2200},func = <<"[]"/utf8>>,reward = [{3,892},{240100101,9}],next = 4000907,give_up = 0,double_time = [],liveness_reward = 0};
get(4000907) ->
#base_task{id = 4000907,name = <<"战斗连击数(2600次)"/utf8>>,desc = <<"单个副本中连击数达到2600"/utf8>>,type = 4,subtype = 49,previous = 4000906,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,2600},func = <<"[]"/utf8>>,reward = [{3,1070},{240100101,11}],next = 4000908,give_up = 0,double_time = [],liveness_reward = 0};
get(4000908) ->
#base_task{id = 4000908,name = <<"战斗连击数(3000次)"/utf8>>,desc = <<"单个副本中连击数达到3000"/utf8>>,type = 4,subtype = 49,previous = 4000907,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,3000},func = <<"[]"/utf8>>,reward = [{3,1284},{240100101,13}],next = 4000909,give_up = 0,double_time = [],liveness_reward = 0};
get(4000909) ->
#base_task{id = 4000909,name = <<"战斗连击数(3400次)"/utf8>>,desc = <<"单个副本中连击数达到3400"/utf8>>,type = 4,subtype = 49,previous = 4000908,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,3400},func = <<"[]"/utf8>>,reward = [{3,1541},{240100101,15}],next = 4000910,give_up = 0,double_time = [],liveness_reward = 0};
get(4000910) ->
#base_task{id = 4000910,name = <<"战斗连击数(3800次)"/utf8>>,desc = <<"单个副本中连击数达到3800"/utf8>>,type = 4,subtype = 49,previous = 4000909,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,3800},func = <<"[]"/utf8>>,reward = [{3,1849},{240100101,18}],next = 4000911,give_up = 0,double_time = [],liveness_reward = 0};
get(4000911) ->
#base_task{id = 4000911,name = <<"战斗连击数(4200次)"/utf8>>,desc = <<"单个副本中连击数达到4200"/utf8>>,type = 4,subtype = 49,previous = 4000910,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,4200},func = <<"[]"/utf8>>,reward = [{3,2218},{240100101,22}],next = 4000912,give_up = 0,double_time = [],liveness_reward = 0};
get(4000912) ->
#base_task{id = 4000912,name = <<"战斗连击数(4600次)"/utf8>>,desc = <<"单个副本中连击数达到4600"/utf8>>,type = 4,subtype = 49,previous = 4000911,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,4600},func = <<"[]"/utf8>>,reward = [{3,2662},{240100101,27}],next = 4000913,give_up = 0,double_time = [],liveness_reward = 0};
get(4000913) ->
#base_task{id = 4000913,name = <<"战斗连击数(5000次)"/utf8>>,desc = <<"单个副本中连击数达到5000"/utf8>>,type = 4,subtype = 49,previous = 4000912,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,5000},func = <<"[]"/utf8>>,reward = [{3,3195},{240100101,32}],next = 4000914,give_up = 0,double_time = [],liveness_reward = 0};
get(4000914) ->
#base_task{id = 4000914,name = <<"战斗连击数(5400次)"/utf8>>,desc = <<"单个副本中连击数达到5400"/utf8>>,type = 4,subtype = 49,previous = 4000913,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,5400},func = <<"[]"/utf8>>,reward = [{3,3834},{240100101,38}],next = 4000915,give_up = 0,double_time = [],liveness_reward = 0};
get(4000915) ->
#base_task{id = 4000915,name = <<"战斗连击数(5800次)"/utf8>>,desc = <<"单个副本中连击数达到5800"/utf8>>,type = 4,subtype = 49,previous = 4000914,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,5800},func = <<"[]"/utf8>>,reward = [{3,4600},{240100101,46}],next = 4000916,give_up = 0,double_time = [],liveness_reward = 0};
get(4000916) ->
#base_task{id = 4000916,name = <<"战斗连击数(6200次)"/utf8>>,desc = <<"单个副本中连击数达到6200"/utf8>>,type = 4,subtype = 49,previous = 4000915,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,6200},func = <<"[]"/utf8>>,reward = [{3,5520},{240100101,55}],next = 4000917,give_up = 0,double_time = [],liveness_reward = 0};
get(4000917) ->
#base_task{id = 4000917,name = <<"战斗连击数(6600次)"/utf8>>,desc = <<"单个副本中连击数达到6600"/utf8>>,type = 4,subtype = 49,previous = 4000916,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,6600},func = <<"[]"/utf8>>,reward = [{3,6624},{240100101,66}],next = 4000918,give_up = 0,double_time = [],liveness_reward = 0};
get(4000918) ->
#base_task{id = 4000918,name = <<"战斗连击数(7000次)"/utf8>>,desc = <<"单个副本中连击数达到7000"/utf8>>,type = 4,subtype = 49,previous = 4000917,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,7000},func = <<"[]"/utf8>>,reward = [{3,7949},{240100101,79}],next = 4000919,give_up = 0,double_time = [],liveness_reward = 0};
get(4000919) ->
#base_task{id = 4000919,name = <<"战斗连击数(7400次)"/utf8>>,desc = <<"单个副本中连击数达到7400"/utf8>>,type = 4,subtype = 49,previous = 4000918,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,7400},func = <<"[]"/utf8>>,reward = [{3,9539},{240100101,95}],next = 4000920,give_up = 0,double_time = [],liveness_reward = 0};
get(4000920) ->
#base_task{id = 4000920,name = <<"战斗连击数(9999次)"/utf8>>,desc = <<"单个副本中连击数达到9999"/utf8>>,type = 4,subtype = 49,previous = 4000919,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,1,9999},func = <<"[]"/utf8>>,reward = [{3,11447},{240100101,114}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4001001) ->
#base_task{id = 4001001,name = <<"战斗浮空连击数(200次)"/utf8>>,desc = <<"单个副本中浮空连击数达到200"/utf8>>,type = 4,subtype = 50,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,200},func = <<"[]"/utf8>>,reward = [{3,358},{240100101,4}],next = 4001002,give_up = 0,double_time = [],liveness_reward = 0};
get(4001002) ->
#base_task{id = 4001002,name = <<"战斗浮空连击数(600次)"/utf8>>,desc = <<"单个副本中浮空连击数达到600"/utf8>>,type = 4,subtype = 50,previous = 4001001,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,600},func = <<"[]"/utf8>>,reward = [{3,430},{240100101,4}],next = 4001003,give_up = 0,double_time = [],liveness_reward = 0};
get(4001003) ->
#base_task{id = 4001003,name = <<"战斗浮空连击数(1000次)"/utf8>>,desc = <<"单个副本中浮空连击数达到1000"/utf8>>,type = 4,subtype = 50,previous = 4001002,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,1000},func = <<"[]"/utf8>>,reward = [{3,516},{240100101,5}],next = 4001004,give_up = 0,double_time = [],liveness_reward = 0};
get(4001004) ->
#base_task{id = 4001004,name = <<"战斗浮空连击数(1400次)"/utf8>>,desc = <<"单个副本中浮空连击数达到1400"/utf8>>,type = 4,subtype = 50,previous = 4001003,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,1400},func = <<"[]"/utf8>>,reward = [{3,619},{240100101,6}],next = 4001005,give_up = 0,double_time = [],liveness_reward = 0};
get(4001005) ->
#base_task{id = 4001005,name = <<"战斗浮空连击数(1800次)"/utf8>>,desc = <<"单个副本中浮空连击数达到1800"/utf8>>,type = 4,subtype = 50,previous = 4001004,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,1800},func = <<"[]"/utf8>>,reward = [{3,743},{240100101,7}],next = 4001006,give_up = 0,double_time = [],liveness_reward = 0};
get(4001006) ->
#base_task{id = 4001006,name = <<"战斗浮空连击数(2200次)"/utf8>>,desc = <<"单个副本中浮空连击数达到2200"/utf8>>,type = 4,subtype = 50,previous = 4001005,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,2200},func = <<"[]"/utf8>>,reward = [{3,892},{240100101,9}],next = 4001007,give_up = 0,double_time = [],liveness_reward = 0};
get(4001007) ->
#base_task{id = 4001007,name = <<"战斗浮空连击数(2600次)"/utf8>>,desc = <<"单个副本中浮空连击数达到2600"/utf8>>,type = 4,subtype = 50,previous = 4001006,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,2600},func = <<"[]"/utf8>>,reward = [{3,1070},{240100101,11}],next = 4001008,give_up = 0,double_time = [],liveness_reward = 0};
get(4001008) ->
#base_task{id = 4001008,name = <<"战斗浮空连击数(3000次)"/utf8>>,desc = <<"单个副本中浮空连击数达到3000"/utf8>>,type = 4,subtype = 50,previous = 4001007,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,3000},func = <<"[]"/utf8>>,reward = [{3,1284},{240100101,13}],next = 4001009,give_up = 0,double_time = [],liveness_reward = 0};
get(4001009) ->
#base_task{id = 4001009,name = <<"战斗浮空连击数(3400次)"/utf8>>,desc = <<"单个副本中浮空连击数达到3400"/utf8>>,type = 4,subtype = 50,previous = 4001008,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,3400},func = <<"[]"/utf8>>,reward = [{3,1541},{240100101,15}],next = 4001010,give_up = 0,double_time = [],liveness_reward = 0};
get(4001010) ->
#base_task{id = 4001010,name = <<"战斗浮空连击数(3800次)"/utf8>>,desc = <<"单个副本中浮空连击数达到3800"/utf8>>,type = 4,subtype = 50,previous = 4001009,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,3800},func = <<"[]"/utf8>>,reward = [{3,1849},{240100101,18}],next = 4001011,give_up = 0,double_time = [],liveness_reward = 0};
get(4001011) ->
#base_task{id = 4001011,name = <<"战斗浮空连击数(4200次)"/utf8>>,desc = <<"单个副本中浮空连击数达到4200"/utf8>>,type = 4,subtype = 50,previous = 4001010,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,4200},func = <<"[]"/utf8>>,reward = [{3,2218},{240100101,22}],next = 4001012,give_up = 0,double_time = [],liveness_reward = 0};
get(4001012) ->
#base_task{id = 4001012,name = <<"战斗浮空连击数(4600次)"/utf8>>,desc = <<"单个副本中浮空连击数达到4600"/utf8>>,type = 4,subtype = 50,previous = 4001011,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,4600},func = <<"[]"/utf8>>,reward = [{3,2662},{240100101,27}],next = 4001013,give_up = 0,double_time = [],liveness_reward = 0};
get(4001013) ->
#base_task{id = 4001013,name = <<"战斗浮空连击数(5000次)"/utf8>>,desc = <<"单个副本中浮空连击数达到5000"/utf8>>,type = 4,subtype = 50,previous = 4001012,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,5000},func = <<"[]"/utf8>>,reward = [{3,3195},{240100101,32}],next = 4001014,give_up = 0,double_time = [],liveness_reward = 0};
get(4001014) ->
#base_task{id = 4001014,name = <<"战斗浮空连击数(5400次)"/utf8>>,desc = <<"单个副本中浮空连击数达到5400"/utf8>>,type = 4,subtype = 50,previous = 4001013,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,5400},func = <<"[]"/utf8>>,reward = [{3,3834},{240100101,38}],next = 4001015,give_up = 0,double_time = [],liveness_reward = 0};
get(4001015) ->
#base_task{id = 4001015,name = <<"战斗浮空连击数(5800次)"/utf8>>,desc = <<"单个副本中浮空连击数达到5800"/utf8>>,type = 4,subtype = 50,previous = 4001014,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,5800},func = <<"[]"/utf8>>,reward = [{3,4600},{240100101,46}],next = 4001016,give_up = 0,double_time = [],liveness_reward = 0};
get(4001016) ->
#base_task{id = 4001016,name = <<"战斗浮空连击数(6200次)"/utf8>>,desc = <<"单个副本中浮空连击数达到6200"/utf8>>,type = 4,subtype = 50,previous = 4001015,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,6200},func = <<"[]"/utf8>>,reward = [{3,5520},{240100101,55}],next = 4001017,give_up = 0,double_time = [],liveness_reward = 0};
get(4001017) ->
#base_task{id = 4001017,name = <<"战斗浮空连击数(6600次)"/utf8>>,desc = <<"单个副本中浮空连击数达到6600"/utf8>>,type = 4,subtype = 50,previous = 4001016,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,6600},func = <<"[]"/utf8>>,reward = [{3,6624},{240100101,66}],next = 4001018,give_up = 0,double_time = [],liveness_reward = 0};
get(4001018) ->
#base_task{id = 4001018,name = <<"战斗浮空连击数(7000次)"/utf8>>,desc = <<"单个副本中浮空连击数达到7000"/utf8>>,type = 4,subtype = 50,previous = 4001017,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,7000},func = <<"[]"/utf8>>,reward = [{3,7949},{240100101,79}],next = 4001019,give_up = 0,double_time = [],liveness_reward = 0};
get(4001019) ->
#base_task{id = 4001019,name = <<"战斗浮空连击数(7400次)"/utf8>>,desc = <<"单个副本中浮空连击数达到7400"/utf8>>,type = 4,subtype = 50,previous = 4001018,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,7400},func = <<"[]"/utf8>>,reward = [{3,9539},{240100101,95}],next = 4001020,give_up = 0,double_time = [],liveness_reward = 0};
get(4001020) ->
#base_task{id = 4001020,name = <<"战斗浮空连击数(9999次)"/utf8>>,desc = <<"单个副本中浮空连击数达到9999"/utf8>>,type = 4,subtype = 50,previous = 4001019,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,2,9999},func = <<"[]"/utf8>>,reward = [{3,11447},{240100101,114}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4001101) ->
#base_task{id = 4001101,name = <<"战斗倒地连击(50次)"/utf8>>,desc = <<"单个副本中倒地连击数达到50"/utf8>>,type = 4,subtype = 51,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,50},func = <<"[]"/utf8>>,reward = [{3,358},{240100101,4}],next = 4001102,give_up = 0,double_time = [],liveness_reward = 0};
get(4001102) ->
#base_task{id = 4001102,name = <<"战斗倒地连击(150次)"/utf8>>,desc = <<"单个副本中倒地连击数达到150"/utf8>>,type = 4,subtype = 51,previous = 4001101,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,150},func = <<"[]"/utf8>>,reward = [{3,430},{240100101,4}],next = 4001103,give_up = 0,double_time = [],liveness_reward = 0};
get(4001103) ->
#base_task{id = 4001103,name = <<"战斗倒地连击(250次)"/utf8>>,desc = <<"单个副本中倒地连击数达到250"/utf8>>,type = 4,subtype = 51,previous = 4001102,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,250},func = <<"[]"/utf8>>,reward = [{3,516},{240100101,5}],next = 4001104,give_up = 0,double_time = [],liveness_reward = 0};
get(4001104) ->
#base_task{id = 4001104,name = <<"战斗倒地连击(350次)"/utf8>>,desc = <<"单个副本中倒地连击数达到350"/utf8>>,type = 4,subtype = 51,previous = 4001103,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,350},func = <<"[]"/utf8>>,reward = [{3,619},{240100101,6}],next = 4001105,give_up = 0,double_time = [],liveness_reward = 0};
get(4001105) ->
#base_task{id = 4001105,name = <<"战斗倒地连击(450次)"/utf8>>,desc = <<"单个副本中倒地连击数达到450"/utf8>>,type = 4,subtype = 51,previous = 4001104,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,450},func = <<"[]"/utf8>>,reward = [{3,743},{240100101,7}],next = 4001106,give_up = 0,double_time = [],liveness_reward = 0};
get(4001106) ->
#base_task{id = 4001106,name = <<"战斗倒地连击(550次)"/utf8>>,desc = <<"单个副本中倒地连击数达到550"/utf8>>,type = 4,subtype = 51,previous = 4001105,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,550},func = <<"[]"/utf8>>,reward = [{3,892},{240100101,9}],next = 4001107,give_up = 0,double_time = [],liveness_reward = 0};
get(4001107) ->
#base_task{id = 4001107,name = <<"战斗倒地连击(650次)"/utf8>>,desc = <<"单个副本中倒地连击数达到650"/utf8>>,type = 4,subtype = 51,previous = 4001106,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,650},func = <<"[]"/utf8>>,reward = [{3,1070},{240100101,11}],next = 4001108,give_up = 0,double_time = [],liveness_reward = 0};
get(4001108) ->
#base_task{id = 4001108,name = <<"战斗倒地连击(750次)"/utf8>>,desc = <<"单个副本中倒地连击数达到750"/utf8>>,type = 4,subtype = 51,previous = 4001107,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,750},func = <<"[]"/utf8>>,reward = [{3,1284},{240100101,13}],next = 4001109,give_up = 0,double_time = [],liveness_reward = 0};
get(4001109) ->
#base_task{id = 4001109,name = <<"战斗倒地连击(850次)"/utf8>>,desc = <<"单个副本中倒地连击数达到850"/utf8>>,type = 4,subtype = 51,previous = 4001108,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,850},func = <<"[]"/utf8>>,reward = [{3,1541},{240100101,15}],next = 4001110,give_up = 0,double_time = [],liveness_reward = 0};
get(4001110) ->
#base_task{id = 4001110,name = <<"战斗倒地连击(950次)"/utf8>>,desc = <<"单个副本中倒地连击数达到950"/utf8>>,type = 4,subtype = 51,previous = 4001109,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,950},func = <<"[]"/utf8>>,reward = [{3,1849},{240100101,18}],next = 4001111,give_up = 0,double_time = [],liveness_reward = 0};
get(4001111) ->
#base_task{id = 4001111,name = <<"战斗倒地连击(1050次)"/utf8>>,desc = <<"单个副本中倒地连击数达到1050"/utf8>>,type = 4,subtype = 51,previous = 4001110,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,1050},func = <<"[]"/utf8>>,reward = [{3,2218},{240100101,22}],next = 4001112,give_up = 0,double_time = [],liveness_reward = 0};
get(4001112) ->
#base_task{id = 4001112,name = <<"战斗倒地连击(1150次)"/utf8>>,desc = <<"单个副本中倒地连击数达到1150"/utf8>>,type = 4,subtype = 51,previous = 4001111,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,1150},func = <<"[]"/utf8>>,reward = [{3,2662},{240100101,27}],next = 4001113,give_up = 0,double_time = [],liveness_reward = 0};
get(4001113) ->
#base_task{id = 4001113,name = <<"战斗倒地连击(1250次)"/utf8>>,desc = <<"单个副本中倒地连击数达到1250"/utf8>>,type = 4,subtype = 51,previous = 4001112,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,1250},func = <<"[]"/utf8>>,reward = [{3,3195},{240100101,32}],next = 4001114,give_up = 0,double_time = [],liveness_reward = 0};
get(4001114) ->
#base_task{id = 4001114,name = <<"战斗倒地连击(1350次)"/utf8>>,desc = <<"单个副本中倒地连击数达到1350"/utf8>>,type = 4,subtype = 51,previous = 4001113,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,1350},func = <<"[]"/utf8>>,reward = [{3,3834},{240100101,38}],next = 4001115,give_up = 0,double_time = [],liveness_reward = 0};
get(4001115) ->
#base_task{id = 4001115,name = <<"战斗倒地连击(1450次)"/utf8>>,desc = <<"单个副本中倒地连击数达到1450"/utf8>>,type = 4,subtype = 51,previous = 4001114,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,1450},func = <<"[]"/utf8>>,reward = [{3,4600},{240100101,46}],next = 4001116,give_up = 0,double_time = [],liveness_reward = 0};
get(4001116) ->
#base_task{id = 4001116,name = <<"战斗倒地连击(1550次)"/utf8>>,desc = <<"单个副本中倒地连击数达到1550"/utf8>>,type = 4,subtype = 51,previous = 4001115,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,1550},func = <<"[]"/utf8>>,reward = [{3,5520},{240100101,55}],next = 4001117,give_up = 0,double_time = [],liveness_reward = 0};
get(4001117) ->
#base_task{id = 4001117,name = <<"战斗倒地连击(1650次)"/utf8>>,desc = <<"单个副本中倒地连击数达到1650"/utf8>>,type = 4,subtype = 51,previous = 4001116,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,1650},func = <<"[]"/utf8>>,reward = [{3,6624},{240100101,66}],next = 4001118,give_up = 0,double_time = [],liveness_reward = 0};
get(4001118) ->
#base_task{id = 4001118,name = <<"战斗倒地连击(1750次)"/utf8>>,desc = <<"单个副本中倒地连击数达到1750"/utf8>>,type = 4,subtype = 51,previous = 4001117,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,1750},func = <<"[]"/utf8>>,reward = [{3,7949},{240100101,79}],next = 4001119,give_up = 0,double_time = [],liveness_reward = 0};
get(4001119) ->
#base_task{id = 4001119,name = <<"战斗倒地连击(1850次)"/utf8>>,desc = <<"单个副本中倒地连击数达到1850"/utf8>>,type = 4,subtype = 51,previous = 4001118,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,1850},func = <<"[]"/utf8>>,reward = [{3,9539},{240100101,95}],next = 4001120,give_up = 0,double_time = [],liveness_reward = 0};
get(4001120) ->
#base_task{id = 4001120,name = <<"战斗倒地连击(9999次)"/utf8>>,desc = <<"单个副本中倒地连击数达到9999"/utf8>>,type = 4,subtype = 51,previous = 4001119,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,3,9999},func = <<"[]"/utf8>>,reward = [{3,11447},{240100101,114}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4001201) ->
#base_task{id = 4001201,name = <<"战斗格挡反击(5次)"/utf8>>,desc = <<"单个副本格挡反击数达到5"/utf8>>,type = 4,subtype = 52,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,5},func = <<"[]"/utf8>>,reward = [{3,269},{240100101,3}],next = 4001202,give_up = 0,double_time = [],liveness_reward = 0};
get(4001202) ->
#base_task{id = 4001202,name = <<"战斗格挡反击(15次)"/utf8>>,desc = <<"单个副本格挡反击数达到15"/utf8>>,type = 4,subtype = 52,previous = 4001201,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,15},func = <<"[]"/utf8>>,reward = [{3,322},{240100101,3}],next = 4001203,give_up = 0,double_time = [],liveness_reward = 0};
get(4001203) ->
#base_task{id = 4001203,name = <<"战斗格挡反击(25次)"/utf8>>,desc = <<"单个副本格挡反击数达到25"/utf8>>,type = 4,subtype = 52,previous = 4001202,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,25},func = <<"[]"/utf8>>,reward = [{3,387},{240100101,4}],next = 4001204,give_up = 0,double_time = [],liveness_reward = 0};
get(4001204) ->
#base_task{id = 4001204,name = <<"战斗格挡反击(35次)"/utf8>>,desc = <<"单个副本格挡反击数达到35"/utf8>>,type = 4,subtype = 52,previous = 4001203,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,35},func = <<"[]"/utf8>>,reward = [{3,464},{240100101,5}],next = 4001205,give_up = 0,double_time = [],liveness_reward = 0};
get(4001205) ->
#base_task{id = 4001205,name = <<"战斗格挡反击(45次)"/utf8>>,desc = <<"单个副本格挡反击数达到45"/utf8>>,type = 4,subtype = 52,previous = 4001204,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,45},func = <<"[]"/utf8>>,reward = [{3,557},{240100101,6}],next = 4001206,give_up = 0,double_time = [],liveness_reward = 0};
get(4001206) ->
#base_task{id = 4001206,name = <<"战斗格挡反击(55次)"/utf8>>,desc = <<"单个副本格挡反击数达到55"/utf8>>,type = 4,subtype = 52,previous = 4001205,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,55},func = <<"[]"/utf8>>,reward = [{3,669},{240100101,7}],next = 4001207,give_up = 0,double_time = [],liveness_reward = 0};
get(4001207) ->
#base_task{id = 4001207,name = <<"战斗格挡反击(65次)"/utf8>>,desc = <<"单个副本格挡反击数达到65"/utf8>>,type = 4,subtype = 52,previous = 4001206,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,65},func = <<"[]"/utf8>>,reward = [{3,802},{240100101,8}],next = 4001208,give_up = 0,double_time = [],liveness_reward = 0};
get(4001208) ->
#base_task{id = 4001208,name = <<"战斗格挡反击(75次)"/utf8>>,desc = <<"单个副本格挡反击数达到75"/utf8>>,type = 4,subtype = 52,previous = 4001207,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,75},func = <<"[]"/utf8>>,reward = [{3,963},{240100101,10}],next = 4001209,give_up = 0,double_time = [],liveness_reward = 0};
get(4001209) ->
#base_task{id = 4001209,name = <<"战斗格挡反击(85次)"/utf8>>,desc = <<"单个副本格挡反击数达到85"/utf8>>,type = 4,subtype = 52,previous = 4001208,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,85},func = <<"[]"/utf8>>,reward = [{3,1155},{240100101,12}],next = 4001210,give_up = 0,double_time = [],liveness_reward = 0};
get(4001210) ->
#base_task{id = 4001210,name = <<"战斗格挡反击(95次)"/utf8>>,desc = <<"单个副本格挡反击数达到95"/utf8>>,type = 4,subtype = 52,previous = 4001209,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,95},func = <<"[]"/utf8>>,reward = [{3,1387},{240100101,14}],next = 4001211,give_up = 0,double_time = [],liveness_reward = 0};
get(4001211) ->
#base_task{id = 4001211,name = <<"战斗格挡反击(105次)"/utf8>>,desc = <<"单个副本格挡反击数达到105"/utf8>>,type = 4,subtype = 52,previous = 4001210,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,105},func = <<"[]"/utf8>>,reward = [{3,1664},{240100101,17}],next = 4001212,give_up = 0,double_time = [],liveness_reward = 0};
get(4001212) ->
#base_task{id = 4001212,name = <<"战斗格挡反击(115次)"/utf8>>,desc = <<"单个副本格挡反击数达到115"/utf8>>,type = 4,subtype = 52,previous = 4001211,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,115},func = <<"[]"/utf8>>,reward = [{3,1997},{240100101,20}],next = 4001213,give_up = 0,double_time = [],liveness_reward = 0};
get(4001213) ->
#base_task{id = 4001213,name = <<"战斗格挡反击(125次)"/utf8>>,desc = <<"单个副本格挡反击数达到125"/utf8>>,type = 4,subtype = 52,previous = 4001212,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,125},func = <<"[]"/utf8>>,reward = [{3,2396},{240100101,24}],next = 4001214,give_up = 0,double_time = [],liveness_reward = 0};
get(4001214) ->
#base_task{id = 4001214,name = <<"战斗格挡反击(135次)"/utf8>>,desc = <<"单个副本格挡反击数达到135"/utf8>>,type = 4,subtype = 52,previous = 4001213,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,135},func = <<"[]"/utf8>>,reward = [{3,2875},{240100101,29}],next = 4001215,give_up = 0,double_time = [],liveness_reward = 0};
get(4001215) ->
#base_task{id = 4001215,name = <<"战斗格挡反击(145次)"/utf8>>,desc = <<"单个副本格挡反击数达到145"/utf8>>,type = 4,subtype = 52,previous = 4001214,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,145},func = <<"[]"/utf8>>,reward = [{3,3450},{240100101,35}],next = 4001216,give_up = 0,double_time = [],liveness_reward = 0};
get(4001216) ->
#base_task{id = 4001216,name = <<"战斗格挡反击(155次)"/utf8>>,desc = <<"单个副本格挡反击数达到155"/utf8>>,type = 4,subtype = 52,previous = 4001215,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,155},func = <<"[]"/utf8>>,reward = [{3,4140},{240100101,41}],next = 4001217,give_up = 0,double_time = [],liveness_reward = 0};
get(4001217) ->
#base_task{id = 4001217,name = <<"战斗格挡反击(165次)"/utf8>>,desc = <<"单个副本格挡反击数达到165"/utf8>>,type = 4,subtype = 52,previous = 4001216,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,165},func = <<"[]"/utf8>>,reward = [{3,4968},{240100101,50}],next = 4001218,give_up = 0,double_time = [],liveness_reward = 0};
get(4001218) ->
#base_task{id = 4001218,name = <<"战斗格挡反击(175次)"/utf8>>,desc = <<"单个副本格挡反击数达到175"/utf8>>,type = 4,subtype = 52,previous = 4001217,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,175},func = <<"[]"/utf8>>,reward = [{3,5962},{240100101,60}],next = 4001219,give_up = 0,double_time = [],liveness_reward = 0};
get(4001219) ->
#base_task{id = 4001219,name = <<"战斗格挡反击(185次)"/utf8>>,desc = <<"单个副本格挡反击数达到185"/utf8>>,type = 4,subtype = 52,previous = 4001218,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,185},func = <<"[]"/utf8>>,reward = [{3,7154},{240100101,72}],next = 4001220,give_up = 0,double_time = [],liveness_reward = 0};
get(4001220) ->
#base_task{id = 4001220,name = <<"战斗格挡反击(9999次)"/utf8>>,desc = <<"单个副本格挡反击数达到9999"/utf8>>,type = 4,subtype = 52,previous = 4001219,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,4,9999},func = <<"[]"/utf8>>,reward = [{3,8585},{240100101,86}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(4001301) ->
#base_task{id = 4001301,name = <<"战斗解围反击(5次)"/utf8>>,desc = <<"单个副本解围反击数达到5"/utf8>>,type = 4,subtype = 53,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,5},func = <<"[]"/utf8>>,reward = [{3,269},{240100101,3}],next = 4001302,give_up = 0,double_time = [],liveness_reward = 0};
get(4001302) ->
#base_task{id = 4001302,name = <<"战斗解围反击(15次)"/utf8>>,desc = <<"单个副本解围反击数达到15"/utf8>>,type = 4,subtype = 53,previous = 4001301,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,15},func = <<"[]"/utf8>>,reward = [{3,322},{240100101,3}],next = 4001303,give_up = 0,double_time = [],liveness_reward = 0};
get(4001303) ->
#base_task{id = 4001303,name = <<"战斗解围反击(25次)"/utf8>>,desc = <<"单个副本解围反击数达到25"/utf8>>,type = 4,subtype = 53,previous = 4001302,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,25},func = <<"[]"/utf8>>,reward = [{3,387},{240100101,4}],next = 4001304,give_up = 0,double_time = [],liveness_reward = 0};
get(4001304) ->
#base_task{id = 4001304,name = <<"战斗解围反击(35次)"/utf8>>,desc = <<"单个副本解围反击数达到35"/utf8>>,type = 4,subtype = 53,previous = 4001303,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,35},func = <<"[]"/utf8>>,reward = [{3,464},{240100101,5}],next = 4001305,give_up = 0,double_time = [],liveness_reward = 0};
get(4001305) ->
#base_task{id = 4001305,name = <<"战斗解围反击(45次)"/utf8>>,desc = <<"单个副本解围反击数达到45"/utf8>>,type = 4,subtype = 53,previous = 4001304,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,45},func = <<"[]"/utf8>>,reward = [{3,557},{240100101,6}],next = 4001306,give_up = 0,double_time = [],liveness_reward = 0};
get(4001306) ->
#base_task{id = 4001306,name = <<"战斗解围反击(55次)"/utf8>>,desc = <<"单个副本解围反击数达到55"/utf8>>,type = 4,subtype = 53,previous = 4001305,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,55},func = <<"[]"/utf8>>,reward = [{3,669},{240100101,7}],next = 4001307,give_up = 0,double_time = [],liveness_reward = 0};
get(4001307) ->
#base_task{id = 4001307,name = <<"战斗解围反击(65次)"/utf8>>,desc = <<"单个副本解围反击数达到65"/utf8>>,type = 4,subtype = 53,previous = 4001306,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,65},func = <<"[]"/utf8>>,reward = [{3,802},{240100101,8}],next = 4001308,give_up = 0,double_time = [],liveness_reward = 0};
get(4001308) ->
#base_task{id = 4001308,name = <<"战斗解围反击(75次)"/utf8>>,desc = <<"单个副本解围反击数达到75"/utf8>>,type = 4,subtype = 53,previous = 4001307,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,75},func = <<"[]"/utf8>>,reward = [{3,963},{240100101,10}],next = 4001309,give_up = 0,double_time = [],liveness_reward = 0};
get(4001309) ->
#base_task{id = 4001309,name = <<"战斗解围反击(85次)"/utf8>>,desc = <<"单个副本解围反击数达到85"/utf8>>,type = 4,subtype = 53,previous = 4001308,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,85},func = <<"[]"/utf8>>,reward = [{3,1155},{240100101,12}],next = 4001310,give_up = 0,double_time = [],liveness_reward = 0};
get(4001310) ->
#base_task{id = 4001310,name = <<"战斗解围反击(95次)"/utf8>>,desc = <<"单个副本解围反击数达到95"/utf8>>,type = 4,subtype = 53,previous = 4001309,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,95},func = <<"[]"/utf8>>,reward = [{3,1387},{240100101,14}],next = 4001311,give_up = 0,double_time = [],liveness_reward = 0};
get(4001311) ->
#base_task{id = 4001311,name = <<"战斗解围反击(105次)"/utf8>>,desc = <<"单个副本解围反击数达到105"/utf8>>,type = 4,subtype = 53,previous = 4001310,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,105},func = <<"[]"/utf8>>,reward = [{3,1664},{240100101,17}],next = 4001312,give_up = 0,double_time = [],liveness_reward = 0};
get(4001312) ->
#base_task{id = 4001312,name = <<"战斗解围反击(115次)"/utf8>>,desc = <<"单个副本解围反击数达到115"/utf8>>,type = 4,subtype = 53,previous = 4001311,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,115},func = <<"[]"/utf8>>,reward = [{3,1997},{240100101,20}],next = 4001313,give_up = 0,double_time = [],liveness_reward = 0};
get(4001313) ->
#base_task{id = 4001313,name = <<"战斗解围反击(125次)"/utf8>>,desc = <<"单个副本解围反击数达到125"/utf8>>,type = 4,subtype = 53,previous = 4001312,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,125},func = <<"[]"/utf8>>,reward = [{3,2396},{240100101,24}],next = 4001314,give_up = 0,double_time = [],liveness_reward = 0};
get(4001314) ->
#base_task{id = 4001314,name = <<"战斗解围反击(135次)"/utf8>>,desc = <<"单个副本解围反击数达到135"/utf8>>,type = 4,subtype = 53,previous = 4001313,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,135},func = <<"[]"/utf8>>,reward = [{3,2875},{240100101,29}],next = 4001315,give_up = 0,double_time = [],liveness_reward = 0};
get(4001315) ->
#base_task{id = 4001315,name = <<"战斗解围反击(145次)"/utf8>>,desc = <<"单个副本解围反击数达到145"/utf8>>,type = 4,subtype = 53,previous = 4001314,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,145},func = <<"[]"/utf8>>,reward = [{3,3450},{240100101,35}],next = 4001316,give_up = 0,double_time = [],liveness_reward = 0};
get(4001316) ->
#base_task{id = 4001316,name = <<"战斗解围反击(155次)"/utf8>>,desc = <<"单个副本解围反击数达到155"/utf8>>,type = 4,subtype = 53,previous = 4001315,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,155},func = <<"[]"/utf8>>,reward = [{3,4140},{240100101,41}],next = 4001317,give_up = 0,double_time = [],liveness_reward = 0};
get(4001317) ->
#base_task{id = 4001317,name = <<"战斗解围反击(165次)"/utf8>>,desc = <<"单个副本解围反击数达到165"/utf8>>,type = 4,subtype = 53,previous = 4001316,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,165},func = <<"[]"/utf8>>,reward = [{3,4968},{240100101,50}],next = 4001318,give_up = 0,double_time = [],liveness_reward = 0};
get(4001318) ->
#base_task{id = 4001318,name = <<"战斗解围反击(175次)"/utf8>>,desc = <<"单个副本解围反击数达到175"/utf8>>,type = 4,subtype = 53,previous = 4001317,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,175},func = <<"[]"/utf8>>,reward = [{3,5962},{240100101,60}],next = 4001319,give_up = 0,double_time = [],liveness_reward = 0};
get(4001319) ->
#base_task{id = 4001319,name = <<"战斗解围反击(185次)"/utf8>>,desc = <<"单个副本解围反击数达到185"/utf8>>,type = 4,subtype = 53,previous = 4001318,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,185},func = <<"[]"/utf8>>,reward = [{3,7154},{240100101,72}],next = 4001320,give_up = 0,double_time = [],liveness_reward = 0};
get(4001320) ->
#base_task{id = 4001320,name = <<"战斗解围反击(9999次)"/utf8>>,desc = <<"单个副本解围反击数达到9999"/utf8>>,type = 4,subtype = 53,previous = 4001319,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {11,5,9999},func = <<"[]"/utf8>>,reward = [{3,8585},{240100101,86}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(6010001) ->
#base_task{id = 6010001,name = <<"冒险试炼 · 朗德"/utf8>>,desc = <<"通关冒险难度 朗德任意副本 三次"/utf8>>,type = 2,subtype = 60,previous = 0,level = [20,35],circle_type = 0,time = [],end_time = [],condition = {6,1102,2,3},func = <<"[3,1102]"/utf8>>,reward = [{20,808},{3,116},{240100101,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(6010002) ->
#base_task{id = 6010002,name = <<"冒险试炼 · 科娜群岛"/utf8>>,desc = <<"通关冒险难度 科娜群岛任意副本 三次"/utf8>>,type = 2,subtype = 60,previous = 0,level = [36,50],circle_type = 0,time = [],end_time = [],condition = {6,1103,2,3},func = <<"[3,1103]"/utf8>>,reward = [{20,1365},{3,227},{240100101,3}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(6010003) ->
#base_task{id = 6010003,name = <<"冒险试炼 · 夏尔坎沙漠"/utf8>>,desc = <<"通关冒险难度 夏尔坎沙漠任意副本 三次"/utf8>>,type = 2,subtype = 60,previous = 0,level = [51,60],circle_type = 0,time = [],end_time = [],condition = {6,1104,2,3},func = <<"[3,1104]"/utf8>>,reward = [{20,1703},{3,284},{240100101,3}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(6010004) ->
#base_task{id = 6010004,name = <<"冒险试炼 · 曼德尔洲"/utf8>>,desc = <<"通关冒险难度 曼德尔洲任意副本 三次"/utf8>>,type = 2,subtype = 60,previous = 0,level = [61,90],circle_type = 0,time = [],end_time = [],condition = {6,1105,2,3},func = <<"[3,1105]"/utf8>>,reward = [{20,2412},{3,402},{240100101,5}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(6020001) ->
#base_task{id = 6020001,name = <<"王者试炼 · 朗德"/utf8>>,desc = <<"通关王者难度 朗德任意副本 两次"/utf8>>,type = 2,subtype = 60,previous = 0,level = [20,35],circle_type = 0,time = [],end_time = [],condition = {6,1102,3,2},func = <<"[3,1102]"/utf8>>,reward = [{20,1211},{3,174},{240100101,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(6020002) ->
#base_task{id = 6020002,name = <<"王者试炼 · 科娜群岛"/utf8>>,desc = <<"通关王者难度 科娜群岛任意副本 两次"/utf8>>,type = 2,subtype = 60,previous = 0,level = [36,50],circle_type = 0,time = [],end_time = [],condition = {6,1103,3,2},func = <<"[3,1103]"/utf8>>,reward = [{20,2047},{3,341},{240100101,4}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(6020003) ->
#base_task{id = 6020003,name = <<"王者试炼 · 夏尔坎沙漠"/utf8>>,desc = <<"通关王者难度 夏尔坎沙漠任意副本 三次"/utf8>>,type = 2,subtype = 60,previous = 0,level = [51,60],circle_type = 0,time = [],end_time = [],condition = {6,1104,3,2},func = <<"[3,1104]"/utf8>>,reward = [{20,2554},{3,426},{240100101,5}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(6020004) ->
#base_task{id = 6020004,name = <<"王者试炼 · 曼德尔洲"/utf8>>,desc = <<"通关王者难度 曼德尔洲任意副本 三次"/utf8>>,type = 2,subtype = 60,previous = 0,level = [61,90],circle_type = 0,time = [],end_time = [],condition = {6,1105,3,2},func = <<"[3,1105]"/utf8>>,reward = [{20,3619},{3,603},{240100101,7}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(6030001) ->
#base_task{id = 6030001,name = <<"强化"/utf8>>,desc = <<"每天强化 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {3,1,2},func = <<"[]"/utf8>>,reward = [{20,409},{3,68},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030002) ->
#base_task{id = 6030002,name = <<"升星"/utf8>>,desc = <<"每天升星 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {3,2,2},func = <<"[]"/utf8>>,reward = [{20,409},{3,68},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030003) ->
#base_task{id = 6030003,name = <<"宝石合成"/utf8>>,desc = <<"每天宝石合成 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {3,5,1},func = <<"[]"/utf8>>,reward = [{20,409},{3,68},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030004) ->
#base_task{id = 6030004,name = <<"天赋升级"/utf8>>,desc = <<"每天天赋升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {3,3,1},func = <<"[]"/utf8>>,reward = [{20,409},{3,68},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030005) ->
#base_task{id = 6030005,name = <<"技能升级"/utf8>>,desc = <<"每天技能升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {3,10,1},func = <<"[]"/utf8>>,reward = [{20,409},{3,68},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030006) ->
#base_task{id = 6030006,name = <<"竞技场"/utf8>>,desc = <<"每天打竞技场 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {12,1,2},func = <<"[]"/utf8>>,reward = [{20,819},{3,136},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030007) ->
#base_task{id = 6030007,name = <<"苍蓝争霸"/utf8>>,desc = <<"每天打苍蓝争霸 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {12,2,2},func = <<"[]"/utf8>>,reward = [{20,819},{3,136},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030008) ->
#base_task{id = 6030008,name = <<"热血之征"/utf8>>,desc = <<"每天热血之征打到 4 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {13,4},func = <<"[]"/utf8>>,reward = [{20,682},{3,114},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030009) ->
#base_task{id = 6030009,name = <<"通天塔"/utf8>>,desc = <<"每天通天塔打到 20 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {7,20},func = <<"[]"/utf8>>,reward = [{20,682},{3,114},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030010) ->
#base_task{id = 6030010,name = <<"金钱抽奖"/utf8>>,desc = <<"每天金钱抽奖 5 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {3,8,5},func = <<"[]"/utf8>>,reward = [{20,409},{3,68},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030011) ->
#base_task{id = 6030011,name = <<"钻石抽奖"/utf8>>,desc = <<"每天钻石抽奖 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {3,9,1},func = <<"[]"/utf8>>,reward = [{20,819},{3,136},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 60};
get(6030012) ->
#base_task{id = 6030012,name = <<"钻石消费"/utf8>>,desc = <<"每天消费任意钻石"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {3,7,1},func = <<"[]"/utf8>>,reward = [{20,546},{3,91},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030013) ->
#base_task{id = 6030013,name = <<"购买体力"/utf8>>,desc = <<"每天购买体力 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {3,6,1},func = <<"[]"/utf8>>,reward = [{20,409},{3,68},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030014) ->
#base_task{id = 6030014,name = <<"强化"/utf8>>,desc = <<"每天强化 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {3,1,2},func = <<"[]"/utf8>>,reward = [{20,511},{3,85},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030015) ->
#base_task{id = 6030015,name = <<"升星"/utf8>>,desc = <<"每天升星 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {3,2,2},func = <<"[]"/utf8>>,reward = [{20,511},{3,85},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030016) ->
#base_task{id = 6030016,name = <<"宝石合成"/utf8>>,desc = <<"每天宝石合成 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {3,5,1},func = <<"[]"/utf8>>,reward = [{20,511},{3,85},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030017) ->
#base_task{id = 6030017,name = <<"天赋升级"/utf8>>,desc = <<"每天天赋升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {3,3,1},func = <<"[]"/utf8>>,reward = [{20,511},{3,85},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030018) ->
#base_task{id = 6030018,name = <<"技能升级"/utf8>>,desc = <<"每天技能升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {3,10,1},func = <<"[]"/utf8>>,reward = [{20,511},{3,85},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030019) ->
#base_task{id = 6030019,name = <<"竞技场"/utf8>>,desc = <<"每天打竞技场 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {12,1,2},func = <<"[]"/utf8>>,reward = [{20,1022},{3,170},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030020) ->
#base_task{id = 6030020,name = <<"苍蓝争霸"/utf8>>,desc = <<"每天打苍蓝争霸 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {12,2,2},func = <<"[]"/utf8>>,reward = [{20,1022},{3,170},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030021) ->
#base_task{id = 6030021,name = <<"热血之征"/utf8>>,desc = <<"每天热血之征打到 4 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {13,4},func = <<"[]"/utf8>>,reward = [{20,851},{3,142},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030022) ->
#base_task{id = 6030022,name = <<"通天塔"/utf8>>,desc = <<"每天通天塔打到 20 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {7,20},func = <<"[]"/utf8>>,reward = [{20,851},{3,142},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030023) ->
#base_task{id = 6030023,name = <<"金钱抽奖"/utf8>>,desc = <<"每天金钱抽奖 5 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {3,8,5},func = <<"[]"/utf8>>,reward = [{20,511},{3,85},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030024) ->
#base_task{id = 6030024,name = <<"钻石抽奖"/utf8>>,desc = <<"每天钻石抽奖 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {3,9,1},func = <<"[]"/utf8>>,reward = [{20,1022},{3,170},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 60};
get(6030025) ->
#base_task{id = 6030025,name = <<"钻石消费"/utf8>>,desc = <<"每天消费任意钻石"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {3,7,1},func = <<"[]"/utf8>>,reward = [{20,681},{3,114},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030026) ->
#base_task{id = 6030026,name = <<"购买体力"/utf8>>,desc = <<"每天购买体力 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {3,6,1},func = <<"[]"/utf8>>,reward = [{20,511},{3,85},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030027) ->
#base_task{id = 6030027,name = <<"强化"/utf8>>,desc = <<"每天强化 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {3,1,2},func = <<"[]"/utf8>>,reward = [{20,724},{3,121},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030028) ->
#base_task{id = 6030028,name = <<"升星"/utf8>>,desc = <<"每天升星 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {3,2,2},func = <<"[]"/utf8>>,reward = [{20,724},{3,121},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030029) ->
#base_task{id = 6030029,name = <<"宝石合成"/utf8>>,desc = <<"每天宝石合成 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {3,5,1},func = <<"[]"/utf8>>,reward = [{20,724},{3,121},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030030) ->
#base_task{id = 6030030,name = <<"天赋升级"/utf8>>,desc = <<"每天天赋升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {3,3,1},func = <<"[]"/utf8>>,reward = [{20,724},{3,121},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030031) ->
#base_task{id = 6030031,name = <<"技能升级"/utf8>>,desc = <<"每天技能升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {3,10,1},func = <<"[]"/utf8>>,reward = [{20,724},{3,121},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030032) ->
#base_task{id = 6030032,name = <<"竞技场"/utf8>>,desc = <<"每天打竞技场 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {12,1,2},func = <<"[]"/utf8>>,reward = [{20,1447},{2,241},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030033) ->
#base_task{id = 6030033,name = <<"苍蓝争霸"/utf8>>,desc = <<"每天打苍蓝争霸 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {12,2,2},func = <<"[]"/utf8>>,reward = [{20,1447},{2,241},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030034) ->
#base_task{id = 6030034,name = <<"热血之征"/utf8>>,desc = <<"每天热血之征打到 4 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {13,4},func = <<"[]"/utf8>>,reward = [{20,1206},{2,201},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030035) ->
#base_task{id = 6030035,name = <<"通天塔"/utf8>>,desc = <<"每天通天塔打到 30 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {7,30},func = <<"[]"/utf8>>,reward = [{20,1206},{2,201},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030036) ->
#base_task{id = 6030036,name = <<"金钱抽奖"/utf8>>,desc = <<"每天金钱抽奖 5 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {3,8,5},func = <<"[]"/utf8>>,reward = [{20,724},{2,121},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030037) ->
#base_task{id = 6030037,name = <<"钻石抽奖"/utf8>>,desc = <<"每天钻石抽奖 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {3,9,1},func = <<"[]"/utf8>>,reward = [{20,1447},{2,241},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 60};
get(6030038) ->
#base_task{id = 6030038,name = <<"钻石消费"/utf8>>,desc = <<"每天消费任意钻石"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {3,7,1},func = <<"[]"/utf8>>,reward = [{20,965},{3,161},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030039) ->
#base_task{id = 6030039,name = <<"购买体力"/utf8>>,desc = <<"每天购买体力 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {3,6,1},func = <<"[]"/utf8>>,reward = [{20,724},{3,121},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030040) ->
#base_task{id = 6030040,name = <<"强化"/utf8>>,desc = <<"每天强化 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {3,1,2},func = <<"[]"/utf8>>,reward = [{20,958},{3,160},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030041) ->
#base_task{id = 6030041,name = <<"升星"/utf8>>,desc = <<"每天升星 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {3,2,2},func = <<"[]"/utf8>>,reward = [{20,958},{3,160},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030042) ->
#base_task{id = 6030042,name = <<"宝石合成"/utf8>>,desc = <<"每天宝石合成 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {3,5,1},func = <<"[]"/utf8>>,reward = [{20,958},{3,160},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030043) ->
#base_task{id = 6030043,name = <<"天赋升级"/utf8>>,desc = <<"每天天赋升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {3,3,1},func = <<"[]"/utf8>>,reward = [{20,958},{3,160},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030044) ->
#base_task{id = 6030044,name = <<"技能升级"/utf8>>,desc = <<"每天技能升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {3,10,1},func = <<"[]"/utf8>>,reward = [{20,958},{3,160},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030045) ->
#base_task{id = 6030045,name = <<"竞技场"/utf8>>,desc = <<"每天打竞技场 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {12,1,2},func = <<"[]"/utf8>>,reward = [{20,1916},{3,319},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030046) ->
#base_task{id = 6030046,name = <<"苍蓝争霸"/utf8>>,desc = <<"每天打苍蓝争霸 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {12,2,2},func = <<"[]"/utf8>>,reward = [{20,1916},{3,319},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030047) ->
#base_task{id = 6030047,name = <<"热血之征"/utf8>>,desc = <<"每天热血之征打到 4 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {13,4},func = <<"[]"/utf8>>,reward = [{20,1597},{3,266},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030048) ->
#base_task{id = 6030048,name = <<"通天塔"/utf8>>,desc = <<"每天通天塔打到 30 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {7,30},func = <<"[]"/utf8>>,reward = [{20,1597},{3,266},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030049) ->
#base_task{id = 6030049,name = <<"金钱抽奖"/utf8>>,desc = <<"每天金钱抽奖 5 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {3,8,5},func = <<"[]"/utf8>>,reward = [{20,958},{3,160},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030050) ->
#base_task{id = 6030050,name = <<"钻石抽奖"/utf8>>,desc = <<"每天钻石抽奖 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {3,9,1},func = <<"[]"/utf8>>,reward = [{20,1916},{3,319},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 60};
get(6030051) ->
#base_task{id = 6030051,name = <<"钻石消费"/utf8>>,desc = <<"每天消费任意钻石"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {3,7,1},func = <<"[]"/utf8>>,reward = [{20,1277},{3,213},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030052) ->
#base_task{id = 6030052,name = <<"购买体力"/utf8>>,desc = <<"每天购买体力 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {3,6,1},func = <<"[]"/utf8>>,reward = [{20,958},{3,160},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030053) ->
#base_task{id = 6030053,name = <<"强化"/utf8>>,desc = <<"每天强化 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {3,1,2},func = <<"[]"/utf8>>,reward = [{20,1264},{3,211},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030054) ->
#base_task{id = 6030054,name = <<"升星"/utf8>>,desc = <<"每天升星 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {3,2,2},func = <<"[]"/utf8>>,reward = [{20,1264},{3,211},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030055) ->
#base_task{id = 6030055,name = <<"宝石合成"/utf8>>,desc = <<"每天宝石合成 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {3,5,1},func = <<"[]"/utf8>>,reward = [{20,1264},{3,211},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030056) ->
#base_task{id = 6030056,name = <<"天赋升级"/utf8>>,desc = <<"每天天赋升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {3,3,1},func = <<"[]"/utf8>>,reward = [{20,1264},{3,211},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030057) ->
#base_task{id = 6030057,name = <<"技能升级"/utf8>>,desc = <<"每天技能升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {3,10,1},func = <<"[]"/utf8>>,reward = [{20,1264},{3,211},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030058) ->
#base_task{id = 6030058,name = <<"竞技场"/utf8>>,desc = <<"每天打竞技场 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {12,1,2},func = <<"[]"/utf8>>,reward = [{20,2527},{3,421},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030059) ->
#base_task{id = 6030059,name = <<"苍蓝争霸"/utf8>>,desc = <<"每天打苍蓝争霸 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {12,2,2},func = <<"[]"/utf8>>,reward = [{20,2527},{3,421},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030060) ->
#base_task{id = 6030060,name = <<"热血之征"/utf8>>,desc = <<"每天热血之征打到 4 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {13,4},func = <<"[]"/utf8>>,reward = [{20,2106},{3,351},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030061) ->
#base_task{id = 6030061,name = <<"通天塔"/utf8>>,desc = <<"每天通天塔打到 30 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {7,30},func = <<"[]"/utf8>>,reward = [{20,2106},{3,351},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030062) ->
#base_task{id = 6030062,name = <<"金钱抽奖"/utf8>>,desc = <<"每天金钱抽奖 5 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {3,8,5},func = <<"[]"/utf8>>,reward = [{20,1264},{3,211},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030063) ->
#base_task{id = 6030063,name = <<"钻石抽奖"/utf8>>,desc = <<"每天钻石抽奖 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {3,9,1},func = <<"[]"/utf8>>,reward = [{20,2527},{3,421},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 60};
get(6030064) ->
#base_task{id = 6030064,name = <<"钻石消费"/utf8>>,desc = <<"每天消费任意钻石"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {3,7,1},func = <<"[]"/utf8>>,reward = [{20,1685},{3,281},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030065) ->
#base_task{id = 6030065,name = <<"购买体力"/utf8>>,desc = <<"每天购买体力 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {3,6,1},func = <<"[]"/utf8>>,reward = [{20,1264},{3,211},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030066) ->
#base_task{id = 6030066,name = <<"强化"/utf8>>,desc = <<"每天强化 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {3,1,2},func = <<"[]"/utf8>>,reward = [{20,1676},{3,279},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030067) ->
#base_task{id = 6030067,name = <<"升星"/utf8>>,desc = <<"每天升星 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {3,2,2},func = <<"[]"/utf8>>,reward = [{20,1676},{3,279},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030068) ->
#base_task{id = 6030068,name = <<"宝石合成"/utf8>>,desc = <<"每天宝石合成 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {3,5,1},func = <<"[]"/utf8>>,reward = [{20,1676},{3,279},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030069) ->
#base_task{id = 6030069,name = <<"天赋升级"/utf8>>,desc = <<"每天天赋升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {3,3,1},func = <<"[]"/utf8>>,reward = [{20,1676},{3,279},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030070) ->
#base_task{id = 6030070,name = <<"技能升级"/utf8>>,desc = <<"每天技能升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {3,10,1},func = <<"[]"/utf8>>,reward = [{20,1676},{3,279},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030071) ->
#base_task{id = 6030071,name = <<"竞技场"/utf8>>,desc = <<"每天打竞技场 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {12,1,2},func = <<"[]"/utf8>>,reward = [{20,3351},{3,559},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030072) ->
#base_task{id = 6030072,name = <<"苍蓝争霸"/utf8>>,desc = <<"每天打苍蓝争霸 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {12,2,2},func = <<"[]"/utf8>>,reward = [{20,3351},{3,559},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030073) ->
#base_task{id = 6030073,name = <<"热血之征"/utf8>>,desc = <<"每天热血之征打到 4 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {13,4},func = <<"[]"/utf8>>,reward = [{20,2793},{3,465},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030074) ->
#base_task{id = 6030074,name = <<"通天塔"/utf8>>,desc = <<"每天通天塔打到 30 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {7,30},func = <<"[]"/utf8>>,reward = [{20,2793},{3,465},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030075) ->
#base_task{id = 6030075,name = <<"金钱抽奖"/utf8>>,desc = <<"每天金钱抽奖 5 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {3,8,5},func = <<"[]"/utf8>>,reward = [{20,1676},{3,279},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030076) ->
#base_task{id = 6030076,name = <<"钻石抽奖"/utf8>>,desc = <<"每天钻石抽奖 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {3,9,1},func = <<"[]"/utf8>>,reward = [{20,3351},{3,559},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 60};
get(6030077) ->
#base_task{id = 6030077,name = <<"钻石消费"/utf8>>,desc = <<"每天消费任意钻石"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {3,7,1},func = <<"[]"/utf8>>,reward = [{20,2234},{3,372},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030078) ->
#base_task{id = 6030078,name = <<"购买体力"/utf8>>,desc = <<"每天购买体力 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {3,6,1},func = <<"[]"/utf8>>,reward = [{20,1676},{3,279},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030079) ->
#base_task{id = 6030079,name = <<"强化"/utf8>>,desc = <<"每天强化 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {3,1,2},func = <<"[]"/utf8>>,reward = [{20,2231},{3,372},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030080) ->
#base_task{id = 6030080,name = <<"升星"/utf8>>,desc = <<"每天升星 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {3,2,2},func = <<"[]"/utf8>>,reward = [{20,2231},{3,372},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030081) ->
#base_task{id = 6030081,name = <<"宝石合成"/utf8>>,desc = <<"每天宝石合成 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {3,5,1},func = <<"[]"/utf8>>,reward = [{20,2231},{3,372},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030082) ->
#base_task{id = 6030082,name = <<"天赋升级"/utf8>>,desc = <<"每天天赋升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {3,3,1},func = <<"[]"/utf8>>,reward = [{20,2231},{3,372},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030083) ->
#base_task{id = 6030083,name = <<"技能升级"/utf8>>,desc = <<"每天技能升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {3,10,1},func = <<"[]"/utf8>>,reward = [{20,2231},{3,372},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030084) ->
#base_task{id = 6030084,name = <<"竞技场"/utf8>>,desc = <<"每天打竞技场 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {12,1,2},func = <<"[]"/utf8>>,reward = [{20,4462},{3,744},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030085) ->
#base_task{id = 6030085,name = <<"苍蓝争霸"/utf8>>,desc = <<"每天打苍蓝争霸 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {12,2,2},func = <<"[]"/utf8>>,reward = [{20,4462},{3,744},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030086) ->
#base_task{id = 6030086,name = <<"热血之征"/utf8>>,desc = <<"每天热血之征打到 4 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {13,4},func = <<"[]"/utf8>>,reward = [{20,3718},{3,620},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030087) ->
#base_task{id = 6030087,name = <<"通天塔"/utf8>>,desc = <<"每天通天塔打到 30 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {7,30},func = <<"[]"/utf8>>,reward = [{20,3718},{3,620},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030088) ->
#base_task{id = 6030088,name = <<"金钱抽奖"/utf8>>,desc = <<"每天金钱抽奖 5 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {3,8,5},func = <<"[]"/utf8>>,reward = [{20,2231},{3,372},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030089) ->
#base_task{id = 6030089,name = <<"钻石抽奖"/utf8>>,desc = <<"每天钻石抽奖 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {3,9,1},func = <<"[]"/utf8>>,reward = [{20,4462},{3,744},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 60};
get(6030090) ->
#base_task{id = 6030090,name = <<"钻石消费"/utf8>>,desc = <<"每天消费任意钻石"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {3,7,1},func = <<"[]"/utf8>>,reward = [{20,2975},{3,496},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030091) ->
#base_task{id = 6030091,name = <<"购买体力"/utf8>>,desc = <<"每天购买体力 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {3,6,1},func = <<"[]"/utf8>>,reward = [{20,2231},{3,372},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030092) ->
#base_task{id = 6030092,name = <<"强化"/utf8>>,desc = <<"每天强化 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {3,1,2},func = <<"[]"/utf8>>,reward = [{20,2978},{3,496},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030093) ->
#base_task{id = 6030093,name = <<"升星"/utf8>>,desc = <<"每天升星 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {3,2,2},func = <<"[]"/utf8>>,reward = [{20,2978},{3,496},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030094) ->
#base_task{id = 6030094,name = <<"宝石合成"/utf8>>,desc = <<"每天宝石合成 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {3,5,1},func = <<"[]"/utf8>>,reward = [{20,2978},{3,496},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030095) ->
#base_task{id = 6030095,name = <<"天赋升级"/utf8>>,desc = <<"每天天赋升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {3,3,1},func = <<"[]"/utf8>>,reward = [{20,2978},{3,496},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030096) ->
#base_task{id = 6030096,name = <<"技能升级"/utf8>>,desc = <<"每天技能升级 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {3,10,1},func = <<"[]"/utf8>>,reward = [{20,2978},{3,496},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030097) ->
#base_task{id = 6030097,name = <<"竞技场"/utf8>>,desc = <<"每天打竞技场 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {12,1,2},func = <<"[]"/utf8>>,reward = [{20,5956},{3,993},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030098) ->
#base_task{id = 6030098,name = <<"苍蓝争霸"/utf8>>,desc = <<"每天打苍蓝争霸 2 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {12,2,2},func = <<"[]"/utf8>>,reward = [{20,5956},{3,993},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030099) ->
#base_task{id = 6030099,name = <<"热血之征"/utf8>>,desc = <<"每天热血之征打到 4 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {13,4},func = <<"[]"/utf8>>,reward = [{20,4963},{3,827},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030100) ->
#base_task{id = 6030100,name = <<"通天塔"/utf8>>,desc = <<"每天通天塔打到 30 层"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {7,30},func = <<"[]"/utf8>>,reward = [{20,4963},{3,827},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030101) ->
#base_task{id = 6030101,name = <<"金钱抽奖"/utf8>>,desc = <<"每天金钱抽奖 5 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {3,8,5},func = <<"[]"/utf8>>,reward = [{20,2978},{3,496},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030102) ->
#base_task{id = 6030102,name = <<"钻石抽奖"/utf8>>,desc = <<"每天钻石抽奖 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {3,9,1},func = <<"[]"/utf8>>,reward = [{20,5956},{3,993},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 60};
get(6030103) ->
#base_task{id = 6030103,name = <<"钻石消费"/utf8>>,desc = <<"每天消费任意钻石"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {3,7,1},func = <<"[]"/utf8>>,reward = [{20,3971},{3,662},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030104) ->
#base_task{id = 6030104,name = <<"购买体力"/utf8>>,desc = <<"每天购买体力 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {14,2,1},func = <<"[]"/utf8>>,reward = [{20,2978},{3,496},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 10};
get(6030105) ->
#base_task{id = 6030105,name = <<"组队副本"/utf8>>,desc = <<"每天组队副本 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [20,29],circle_type = 0,time = [],end_time = [],condition = {14,2,1},func = <<"[]"/utf8>>,reward = [{20,819},{3,136},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030106) ->
#base_task{id = 6030106,name = <<"组队副本"/utf8>>,desc = <<"每天组队副本 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [30,39],circle_type = 0,time = [],end_time = [],condition = {14,2,1},func = <<"[]"/utf8>>,reward = [{20,1022},{3,170},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030107) ->
#base_task{id = 6030107,name = <<"组队副本"/utf8>>,desc = <<"每天组队副本 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [40,49],circle_type = 0,time = [],end_time = [],condition = {14,2,1},func = <<"[]"/utf8>>,reward = [{20,1447},{3,241},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030108) ->
#base_task{id = 6030108,name = <<"组队副本"/utf8>>,desc = <<"每天组队副本 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [50,59],circle_type = 0,time = [],end_time = [],condition = {14,2,1},func = <<"[]"/utf8>>,reward = [{20,1916},{3,319},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030109) ->
#base_task{id = 6030109,name = <<"组队副本"/utf8>>,desc = <<"每天组队副本 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [60,69],circle_type = 0,time = [],end_time = [],condition = {14,2,1},func = <<"[]"/utf8>>,reward = [{20,2527},{3,421},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030110) ->
#base_task{id = 6030110,name = <<"组队副本"/utf8>>,desc = <<"每天组队副本 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [70,79],circle_type = 0,time = [],end_time = [],condition = {14,2,1},func = <<"[]"/utf8>>,reward = [{20,3351},{3,559},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030111) ->
#base_task{id = 6030111,name = <<"组队副本"/utf8>>,desc = <<"每天组队副本 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [80,89],circle_type = 0,time = [],end_time = [],condition = {14,2,1},func = <<"[]"/utf8>>,reward = [{20,4462},{3,744},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(6030112) ->
#base_task{id = 6030112,name = <<"组队副本"/utf8>>,desc = <<"每天组队副本 1 次"/utf8>>,type = 2,subtype = 61,previous = 0,level = [90,99],circle_type = 0,time = [],end_time = [],condition = {14,2,1},func = <<"[]"/utf8>>,reward = [{20,5956},{3,993},{1,10},{280133,2}],next = 0,give_up = 0,double_time = [],liveness_reward = 5};
get(4001501) ->
#base_task{id = 4001501,name = <<"生命天赋等级10"/utf8>>,desc = <<"生命天赋升级到10"/utf8>>,type = 4,subtype = 55,previous = 0,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500101,1,10},func = <<"[]"/utf8>>,reward = [{3,239},{240100101,2}],next = 4001502,give_up = 0,double_time = [],liveness_reward = 0};
get(4001502) ->
#base_task{id = 4001502,name = <<"攻击天赋等级10"/utf8>>,desc = <<"攻击天赋升级到10"/utf8>>,type = 4,subtype = 55,previous = 4001501,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500201,1,10},func = <<"[]"/utf8>>,reward = [{3,248},{240100101,2}],next = 4001503,give_up = 0,double_time = [],liveness_reward = 0};
get(4001503) ->
#base_task{id = 4001503,name = <<"防御天赋等级10"/utf8>>,desc = <<"防御天赋升级到10"/utf8>>,type = 4,subtype = 55,previous = 4001502,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500301,1,10},func = <<"[]"/utf8>>,reward = [{3,256},{240100101,3}],next = 4001504,give_up = 0,double_time = [],liveness_reward = 0};
get(4001504) ->
#base_task{id = 4001504,name = <<"命中天赋等级10"/utf8>>,desc = <<"命中天赋升级到10"/utf8>>,type = 4,subtype = 55,previous = 4001503,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500401,1,10},func = <<"[]"/utf8>>,reward = [{3,265},{240100101,3}],next = 4001505,give_up = 0,double_time = [],liveness_reward = 0};
get(4001505) ->
#base_task{id = 4001505,name = <<"闪避天赋等级10"/utf8>>,desc = <<"闪避天赋升级到10"/utf8>>,type = 4,subtype = 55,previous = 4001504,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500501,1,10},func = <<"[]"/utf8>>,reward = [{3,275},{240100101,3}],next = 4001506,give_up = 0,double_time = [],liveness_reward = 0};
get(4001506) ->
#base_task{id = 4001506,name = <<"暴击天赋等级10"/utf8>>,desc = <<"暴击天赋升级到10"/utf8>>,type = 4,subtype = 55,previous = 4001505,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500601,1,10},func = <<"[]"/utf8>>,reward = [{3,284},{240100101,3}],next = 4001507,give_up = 0,double_time = [],liveness_reward = 0};
get(4001507) ->
#base_task{id = 4001507,name = <<"抗暴天赋等级10"/utf8>>,desc = <<"抗暴天赋升级到10"/utf8>>,type = 4,subtype = 55,previous = 4001506,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500701,1,10},func = <<"[]"/utf8>>,reward = [{3,294},{240100101,3}],next = 4001508,give_up = 0,double_time = [],liveness_reward = 0};
get(4001508) ->
#base_task{id = 4001508,name = <<"精神天赋等级10"/utf8>>,desc = <<"精神天赋升级到10"/utf8>>,type = 4,subtype = 55,previous = 4001507,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500801,1,10},func = <<"[]"/utf8>>,reward = [{3,304},{240100101,3}],next = 4001509,give_up = 0,double_time = [],liveness_reward = 0};
get(4001509) ->
#base_task{id = 4001509,name = <<"生命天赋等级20"/utf8>>,desc = <<"生命天赋升级到20"/utf8>>,type = 4,subtype = 55,previous = 4001508,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500101,1,20},func = <<"[]"/utf8>>,reward = [{3,315},{240100101,3}],next = 4001510,give_up = 0,double_time = [],liveness_reward = 0};
get(4001510) ->
#base_task{id = 4001510,name = <<"攻击天赋等级20"/utf8>>,desc = <<"攻击天赋升级到20"/utf8>>,type = 4,subtype = 55,previous = 4001509,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500201,1,20},func = <<"[]"/utf8>>,reward = [{3,326},{240100101,3}],next = 4001511,give_up = 0,double_time = [],liveness_reward = 0};
get(4001511) ->
#base_task{id = 4001511,name = <<"防御天赋等级20"/utf8>>,desc = <<"防御天赋升级到20"/utf8>>,type = 4,subtype = 55,previous = 4001510,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500301,1,20},func = <<"[]"/utf8>>,reward = [{3,338},{240100101,3}],next = 4001512,give_up = 0,double_time = [],liveness_reward = 0};
get(4001512) ->
#base_task{id = 4001512,name = <<"命中天赋等级20"/utf8>>,desc = <<"命中天赋升级到20"/utf8>>,type = 4,subtype = 55,previous = 4001511,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500401,1,20},func = <<"[]"/utf8>>,reward = [{3,349},{240100101,3}],next = 4001513,give_up = 0,double_time = [],liveness_reward = 0};
get(4001513) ->
#base_task{id = 4001513,name = <<"闪避天赋等级20"/utf8>>,desc = <<"闪避天赋升级到20"/utf8>>,type = 4,subtype = 55,previous = 4001512,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500501,1,20},func = <<"[]"/utf8>>,reward = [{3,362},{240100101,4}],next = 4001514,give_up = 0,double_time = [],liveness_reward = 0};
get(4001514) ->
#base_task{id = 4001514,name = <<"暴击天赋等级20"/utf8>>,desc = <<"暴击天赋升级到20"/utf8>>,type = 4,subtype = 55,previous = 4001513,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500601,1,20},func = <<"[]"/utf8>>,reward = [{3,374},{240100101,4}],next = 4001515,give_up = 0,double_time = [],liveness_reward = 0};
get(4001515) ->
#base_task{id = 4001515,name = <<"抗暴天赋等级20"/utf8>>,desc = <<"抗暴天赋升级到20"/utf8>>,type = 4,subtype = 55,previous = 4001514,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500701,1,20},func = <<"[]"/utf8>>,reward = [{3,387},{240100101,4}],next = 4001516,give_up = 0,double_time = [],liveness_reward = 0};
get(4001516) ->
#base_task{id = 4001516,name = <<"抗暴天赋等级20"/utf8>>,desc = <<"抗暴天赋升级到20"/utf8>>,type = 4,subtype = 55,previous = 4001515,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500801,1,20},func = <<"[]"/utf8>>,reward = [{3,401},{240100101,4}],next = 4001517,give_up = 0,double_time = [],liveness_reward = 0};
get(4001517) ->
#base_task{id = 4001517,name = <<"生命天赋等级30"/utf8>>,desc = <<"生命天赋升级到30"/utf8>>,type = 4,subtype = 55,previous = 4001516,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500101,1,30},func = <<"[]"/utf8>>,reward = [{3,415},{240100101,4}],next = 4001518,give_up = 0,double_time = [],liveness_reward = 0};
get(4001518) ->
#base_task{id = 4001518,name = <<"攻击天赋等级30"/utf8>>,desc = <<"攻击天赋升级到30"/utf8>>,type = 4,subtype = 55,previous = 4001517,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500201,1,30},func = <<"[]"/utf8>>,reward = [{3,429},{240100101,4}],next = 4001519,give_up = 0,double_time = [],liveness_reward = 0};
get(4001519) ->
#base_task{id = 4001519,name = <<"防御天赋等级30"/utf8>>,desc = <<"防御天赋升级到30"/utf8>>,type = 4,subtype = 55,previous = 4001518,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500301,1,30},func = <<"[]"/utf8>>,reward = [{3,444},{240100101,4}],next = 4001520,give_up = 0,double_time = [],liveness_reward = 0};
get(4001520) ->
#base_task{id = 4001520,name = <<"命中天赋等级30"/utf8>>,desc = <<"命中天赋升级到30"/utf8>>,type = 4,subtype = 55,previous = 4001519,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500401,1,30},func = <<"[]"/utf8>>,reward = [{3,460},{240100101,5}],next = 4001521,give_up = 0,double_time = [],liveness_reward = 0};
get(4001521) ->
#base_task{id = 4001521,name = <<"闪避天赋等级30"/utf8>>,desc = <<"闪避天赋升级到30"/utf8>>,type = 4,subtype = 55,previous = 4001520,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500501,1,30},func = <<"[]"/utf8>>,reward = [{3,476},{240100101,5}],next = 4001522,give_up = 0,double_time = [],liveness_reward = 0};
get(4001522) ->
#base_task{id = 4001522,name = <<"暴击天赋等级30"/utf8>>,desc = <<"暴击天赋升级到30"/utf8>>,type = 4,subtype = 55,previous = 4001521,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500601,1,30},func = <<"[]"/utf8>>,reward = [{3,493},{240100101,5}],next = 4001523,give_up = 0,double_time = [],liveness_reward = 0};
get(4001523) ->
#base_task{id = 4001523,name = <<"抗暴天赋等级30"/utf8>>,desc = <<"抗暴天赋升级到30"/utf8>>,type = 4,subtype = 55,previous = 4001522,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500701,1,30},func = <<"[]"/utf8>>,reward = [{3,510},{240100101,5}],next = 4001524,give_up = 0,double_time = [],liveness_reward = 0};
get(4001524) ->
#base_task{id = 4001524,name = <<"抗暴天赋等级30"/utf8>>,desc = <<"抗暴天赋升级到30"/utf8>>,type = 4,subtype = 55,previous = 4001523,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500801,1,30},func = <<"[]"/utf8>>,reward = [{3,528},{240100101,5}],next = 4001525,give_up = 0,double_time = [],liveness_reward = 0};
get(4001525) ->
#base_task{id = 4001525,name = <<"生命天赋等级40"/utf8>>,desc = <<"生命天赋升级到40"/utf8>>,type = 4,subtype = 55,previous = 4001524,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500101,1,40},func = <<"[]"/utf8>>,reward = [{3,546},{240100101,5}],next = 4001526,give_up = 0,double_time = [],liveness_reward = 0};
get(4001526) ->
#base_task{id = 4001526,name = <<"攻击天赋等级40"/utf8>>,desc = <<"攻击天赋升级到40"/utf8>>,type = 4,subtype = 55,previous = 4001525,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500201,1,40},func = <<"[]"/utf8>>,reward = [{3,565},{240100101,6}],next = 4001527,give_up = 0,double_time = [],liveness_reward = 0};
get(4001527) ->
#base_task{id = 4001527,name = <<"防御天赋等级40"/utf8>>,desc = <<"防御天赋升级到40"/utf8>>,type = 4,subtype = 55,previous = 4001526,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500301,1,40},func = <<"[]"/utf8>>,reward = [{3,585},{240100101,6}],next = 4001528,give_up = 0,double_time = [],liveness_reward = 0};
get(4001528) ->
#base_task{id = 4001528,name = <<"命中天赋等级40"/utf8>>,desc = <<"命中天赋升级到40"/utf8>>,type = 4,subtype = 55,previous = 4001527,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500401,1,40},func = <<"[]"/utf8>>,reward = [{3,606},{240100101,6}],next = 4001529,give_up = 0,double_time = [],liveness_reward = 0};
get(4001529) ->
#base_task{id = 4001529,name = <<"闪避天赋等级40"/utf8>>,desc = <<"闪避天赋升级到40"/utf8>>,type = 4,subtype = 55,previous = 4001528,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500501,1,40},func = <<"[]"/utf8>>,reward = [{3,627},{240100101,6}],next = 4001530,give_up = 0,double_time = [],liveness_reward = 0};
get(4001530) ->
#base_task{id = 4001530,name = <<"暴击天赋等级40"/utf8>>,desc = <<"暴击天赋升级到40"/utf8>>,type = 4,subtype = 55,previous = 4001529,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500601,1,40},func = <<"[]"/utf8>>,reward = [{3,649},{240100101,6}],next = 4001531,give_up = 0,double_time = [],liveness_reward = 0};
get(4001531) ->
#base_task{id = 4001531,name = <<"抗暴天赋等级40"/utf8>>,desc = <<"抗暴天赋升级到40"/utf8>>,type = 4,subtype = 55,previous = 4001530,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500701,1,40},func = <<"[]"/utf8>>,reward = [{3,672},{240100101,7}],next = 4001532,give_up = 0,double_time = [],liveness_reward = 0};
get(4001532) ->
#base_task{id = 4001532,name = <<"抗暴天赋等级40"/utf8>>,desc = <<"抗暴天赋升级到40"/utf8>>,type = 4,subtype = 55,previous = 4001531,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500801,1,40},func = <<"[]"/utf8>>,reward = [{3,695},{240100101,7}],next = 4001533,give_up = 0,double_time = [],liveness_reward = 0};
get(4001533) ->
#base_task{id = 4001533,name = <<"生命天赋等级50"/utf8>>,desc = <<"生命天赋升级到50"/utf8>>,type = 4,subtype = 55,previous = 4001532,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500101,1,50},func = <<"[]"/utf8>>,reward = [{3,719},{240100101,7}],next = 4001534,give_up = 0,double_time = [],liveness_reward = 0};
get(4001534) ->
#base_task{id = 4001534,name = <<"攻击天赋等级50"/utf8>>,desc = <<"攻击天赋升级到50"/utf8>>,type = 4,subtype = 55,previous = 4001533,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500201,1,50},func = <<"[]"/utf8>>,reward = [{3,745},{240100101,7}],next = 4001535,give_up = 0,double_time = [],liveness_reward = 0};
get(4001535) ->
#base_task{id = 4001535,name = <<"防御天赋等级50"/utf8>>,desc = <<"防御天赋升级到50"/utf8>>,type = 4,subtype = 55,previous = 4001534,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500301,1,50},func = <<"[]"/utf8>>,reward = [{3,771},{240100101,8}],next = 4001536,give_up = 0,double_time = [],liveness_reward = 0};
get(4001536) ->
#base_task{id = 4001536,name = <<"命中天赋等级50"/utf8>>,desc = <<"命中天赋升级到50"/utf8>>,type = 4,subtype = 55,previous = 4001535,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500401,1,50},func = <<"[]"/utf8>>,reward = [{3,798},{240100101,8}],next = 4001537,give_up = 0,double_time = [],liveness_reward = 0};
get(4001537) ->
#base_task{id = 4001537,name = <<"闪避天赋等级50"/utf8>>,desc = <<"闪避天赋升级到50"/utf8>>,type = 4,subtype = 55,previous = 4001536,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500501,1,50},func = <<"[]"/utf8>>,reward = [{3,826},{240100101,8}],next = 4001538,give_up = 0,double_time = [],liveness_reward = 0};
get(4001538) ->
#base_task{id = 4001538,name = <<"暴击天赋等级50"/utf8>>,desc = <<"暴击天赋升级到50"/utf8>>,type = 4,subtype = 55,previous = 4001537,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500601,1,50},func = <<"[]"/utf8>>,reward = [{3,855},{240100101,9}],next = 4001539,give_up = 0,double_time = [],liveness_reward = 0};
get(4001539) ->
#base_task{id = 4001539,name = <<"抗暴天赋等级50"/utf8>>,desc = <<"抗暴天赋升级到50"/utf8>>,type = 4,subtype = 55,previous = 4001538,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500701,1,50},func = <<"[]"/utf8>>,reward = [{3,884},{240100101,9}],next = 4001540,give_up = 0,double_time = [],liveness_reward = 0};
get(4001540) ->
#base_task{id = 4001540,name = <<"抗暴天赋等级50"/utf8>>,desc = <<"抗暴天赋升级到50"/utf8>>,type = 4,subtype = 55,previous = 4001539,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500801,1,50},func = <<"[]"/utf8>>,reward = [{3,915},{240100101,9}],next = 4001541,give_up = 0,double_time = [],liveness_reward = 0};
get(4001541) ->
#base_task{id = 4001541,name = <<"生命天赋等级60"/utf8>>,desc = <<"生命天赋升级到60"/utf8>>,type = 4,subtype = 55,previous = 4001540,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500101,1,60},func = <<"[]"/utf8>>,reward = [{3,947},{240100101,9}],next = 4001542,give_up = 0,double_time = [],liveness_reward = 0};
get(4001542) ->
#base_task{id = 4001542,name = <<"攻击天赋等级60"/utf8>>,desc = <<"攻击天赋升级到60"/utf8>>,type = 4,subtype = 55,previous = 4001541,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500201,1,60},func = <<"[]"/utf8>>,reward = [{3,981},{240100101,10}],next = 4001543,give_up = 0,double_time = [],liveness_reward = 0};
get(4001543) ->
#base_task{id = 4001543,name = <<"防御天赋等级60"/utf8>>,desc = <<"防御天赋升级到60"/utf8>>,type = 4,subtype = 55,previous = 4001542,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500301,1,60},func = <<"[]"/utf8>>,reward = [{3,1015},{240100101,10}],next = 4001544,give_up = 0,double_time = [],liveness_reward = 0};
get(4001544) ->
#base_task{id = 4001544,name = <<"命中天赋等级60"/utf8>>,desc = <<"命中天赋升级到60"/utf8>>,type = 4,subtype = 55,previous = 4001543,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500401,1,60},func = <<"[]"/utf8>>,reward = [{3,1050},{240100101,11}],next = 4001545,give_up = 0,double_time = [],liveness_reward = 0};
get(4001545) ->
#base_task{id = 4001545,name = <<"闪避天赋等级60"/utf8>>,desc = <<"闪避天赋升级到60"/utf8>>,type = 4,subtype = 55,previous = 4001544,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500501,1,60},func = <<"[]"/utf8>>,reward = [{3,1087},{240100101,11}],next = 4001546,give_up = 0,double_time = [],liveness_reward = 0};
get(4001546) ->
#base_task{id = 4001546,name = <<"暴击天赋等级60"/utf8>>,desc = <<"暴击天赋升级到60"/utf8>>,type = 4,subtype = 55,previous = 4001545,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500601,1,60},func = <<"[]"/utf8>>,reward = [{3,1125},{240100101,11}],next = 4001547,give_up = 0,double_time = [],liveness_reward = 0};
get(4001547) ->
#base_task{id = 4001547,name = <<"抗暴天赋等级60"/utf8>>,desc = <<"抗暴天赋升级到60"/utf8>>,type = 4,subtype = 55,previous = 4001546,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500701,1,60},func = <<"[]"/utf8>>,reward = [{3,1165},{240100101,12}],next = 4001548,give_up = 0,double_time = [],liveness_reward = 0};
get(4001548) ->
#base_task{id = 4001548,name = <<"抗暴天赋等级60"/utf8>>,desc = <<"抗暴天赋升级到60"/utf8>>,type = 4,subtype = 55,previous = 4001547,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500801,1,60},func = <<"[]"/utf8>>,reward = [{3,1205},{240100101,12}],next = 4001549,give_up = 0,double_time = [],liveness_reward = 0};
get(4001549) ->
#base_task{id = 4001549,name = <<"生命天赋等级70"/utf8>>,desc = <<"生命天赋升级到70"/utf8>>,type = 4,subtype = 55,previous = 4001548,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500101,1,70},func = <<"[]"/utf8>>,reward = [{3,1248},{240100101,12}],next = 4001550,give_up = 0,double_time = [],liveness_reward = 0};
get(4001550) ->
#base_task{id = 4001550,name = <<"攻击天赋等级70"/utf8>>,desc = <<"攻击天赋升级到70"/utf8>>,type = 4,subtype = 55,previous = 4001549,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500201,1,70},func = <<"[]"/utf8>>,reward = [{3,1291},{240100101,13}],next = 4001551,give_up = 0,double_time = [],liveness_reward = 0};
get(4001551) ->
#base_task{id = 4001551,name = <<"防御天赋等级70"/utf8>>,desc = <<"防御天赋升级到70"/utf8>>,type = 4,subtype = 55,previous = 4001550,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500301,1,70},func = <<"[]"/utf8>>,reward = [{3,1336},{240100101,13}],next = 4001552,give_up = 0,double_time = [],liveness_reward = 0};
get(4001552) ->
#base_task{id = 4001552,name = <<"命中天赋等级70"/utf8>>,desc = <<"命中天赋升级到70"/utf8>>,type = 4,subtype = 55,previous = 4001551,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500401,1,70},func = <<"[]"/utf8>>,reward = [{3,1383},{240100101,14}],next = 4001553,give_up = 0,double_time = [],liveness_reward = 0};
get(4001553) ->
#base_task{id = 4001553,name = <<"闪避天赋等级70"/utf8>>,desc = <<"闪避天赋升级到70"/utf8>>,type = 4,subtype = 55,previous = 4001552,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500501,1,70},func = <<"[]"/utf8>>,reward = [{3,1432},{240100101,14}],next = 4001554,give_up = 0,double_time = [],liveness_reward = 0};
get(4001554) ->
#base_task{id = 4001554,name = <<"暴击天赋等级70"/utf8>>,desc = <<"暴击天赋升级到70"/utf8>>,type = 4,subtype = 55,previous = 4001553,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500601,1,70},func = <<"[]"/utf8>>,reward = [{3,1482},{240100101,15}],next = 4001555,give_up = 0,double_time = [],liveness_reward = 0};
get(4001555) ->
#base_task{id = 4001555,name = <<"抗暴天赋等级70"/utf8>>,desc = <<"抗暴天赋升级到70"/utf8>>,type = 4,subtype = 55,previous = 4001554,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500701,1,70},func = <<"[]"/utf8>>,reward = [{3,1534},{240100101,15}],next = 4001556,give_up = 0,double_time = [],liveness_reward = 0};
get(4001556) ->
#base_task{id = 4001556,name = <<"抗暴天赋等级70"/utf8>>,desc = <<"抗暴天赋升级到70"/utf8>>,type = 4,subtype = 55,previous = 4001555,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500801,1,70},func = <<"[]"/utf8>>,reward = [{3,1587},{240100101,16}],next = 4001557,give_up = 0,double_time = [],liveness_reward = 0};
get(4001557) ->
#base_task{id = 4001557,name = <<"生命天赋等级80"/utf8>>,desc = <<"生命天赋升级到80"/utf8>>,type = 4,subtype = 55,previous = 4001556,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500101,1,80},func = <<"[]"/utf8>>,reward = [{3,1643},{240100101,16}],next = 4001558,give_up = 0,double_time = [],liveness_reward = 0};
get(4001558) ->
#base_task{id = 4001558,name = <<"攻击天赋等级80"/utf8>>,desc = <<"攻击天赋升级到80"/utf8>>,type = 4,subtype = 55,previous = 4001557,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500201,1,80},func = <<"[]"/utf8>>,reward = [{3,1700},{240100101,17}],next = 4001559,give_up = 0,double_time = [],liveness_reward = 0};
get(4001559) ->
#base_task{id = 4001559,name = <<"防御天赋等级80"/utf8>>,desc = <<"防御天赋升级到80"/utf8>>,type = 4,subtype = 55,previous = 4001558,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500301,1,80},func = <<"[]"/utf8>>,reward = [{3,1760},{240100101,18}],next = 4001560,give_up = 0,double_time = [],liveness_reward = 0};
get(4001560) ->
#base_task{id = 4001560,name = <<"命中天赋等级80"/utf8>>,desc = <<"命中天赋升级到80"/utf8>>,type = 4,subtype = 55,previous = 4001559,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500401,1,80},func = <<"[]"/utf8>>,reward = [{3,1821},{240100101,18}],next = 4001561,give_up = 0,double_time = [],liveness_reward = 0};
get(4001561) ->
#base_task{id = 4001561,name = <<"闪避天赋等级80"/utf8>>,desc = <<"闪避天赋升级到80"/utf8>>,type = 4,subtype = 55,previous = 4001560,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500501,1,80},func = <<"[]"/utf8>>,reward = [{3,1885},{240100101,19}],next = 4001562,give_up = 0,double_time = [],liveness_reward = 0};
get(4001562) ->
#base_task{id = 4001562,name = <<"暴击天赋等级80"/utf8>>,desc = <<"暴击天赋升级到80"/utf8>>,type = 4,subtype = 55,previous = 4001561,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500601,1,80},func = <<"[]"/utf8>>,reward = [{3,1951},{240100101,20}],next = 4001563,give_up = 0,double_time = [],liveness_reward = 0};
get(4001563) ->
#base_task{id = 4001563,name = <<"抗暴天赋等级80"/utf8>>,desc = <<"抗暴天赋升级到80"/utf8>>,type = 4,subtype = 55,previous = 4001562,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500701,1,80},func = <<"[]"/utf8>>,reward = [{3,2019},{240100101,20}],next = 4001564,give_up = 0,double_time = [],liveness_reward = 0};
get(4001564) ->
#base_task{id = 4001564,name = <<"抗暴天赋等级80"/utf8>>,desc = <<"抗暴天赋升级到80"/utf8>>,type = 4,subtype = 55,previous = 4001563,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500801,1,80},func = <<"[]"/utf8>>,reward = [{3,2090},{240100101,21}],next = 4001565,give_up = 0,double_time = [],liveness_reward = 0};
get(4001565) ->
#base_task{id = 4001565,name = <<"生命天赋等级90"/utf8>>,desc = <<"生命天赋升级到90"/utf8>>,type = 4,subtype = 55,previous = 4001564,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500101,1,90},func = <<"[]"/utf8>>,reward = [{3,2163},{240100101,22}],next = 4001566,give_up = 0,double_time = [],liveness_reward = 0};
get(4001566) ->
#base_task{id = 4001566,name = <<"攻击天赋等级90"/utf8>>,desc = <<"攻击天赋升级到90"/utf8>>,type = 4,subtype = 55,previous = 4001565,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500201,1,90},func = <<"[]"/utf8>>,reward = [{3,2239},{240100101,22}],next = 4001567,give_up = 0,double_time = [],liveness_reward = 0};
get(4001567) ->
#base_task{id = 4001567,name = <<"防御天赋等级90"/utf8>>,desc = <<"防御天赋升级到90"/utf8>>,type = 4,subtype = 55,previous = 4001566,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500301,1,90},func = <<"[]"/utf8>>,reward = [{3,2317},{240100101,23}],next = 4001568,give_up = 0,double_time = [],liveness_reward = 0};
get(4001568) ->
#base_task{id = 4001568,name = <<"命中天赋等级90"/utf8>>,desc = <<"命中天赋升级到90"/utf8>>,type = 4,subtype = 55,previous = 4001567,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500401,1,90},func = <<"[]"/utf8>>,reward = [{3,2398},{240100101,24}],next = 4001569,give_up = 0,double_time = [],liveness_reward = 0};
get(4001569) ->
#base_task{id = 4001569,name = <<"闪避天赋等级90"/utf8>>,desc = <<"闪避天赋升级到90"/utf8>>,type = 4,subtype = 55,previous = 4001568,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500501,1,90},func = <<"[]"/utf8>>,reward = [{3,2482},{240100101,25}],next = 4001570,give_up = 0,double_time = [],liveness_reward = 0};
get(4001570) ->
#base_task{id = 4001570,name = <<"暴击天赋等级90"/utf8>>,desc = <<"暴击天赋升级到90"/utf8>>,type = 4,subtype = 55,previous = 4001569,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500601,1,90},func = <<"[]"/utf8>>,reward = [{3,2569},{240100101,26}],next = 4001571,give_up = 0,double_time = [],liveness_reward = 0};
get(4001571) ->
#base_task{id = 4001571,name = <<"抗暴天赋等级90"/utf8>>,desc = <<"抗暴天赋升级到90"/utf8>>,type = 4,subtype = 55,previous = 4001570,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500701,1,90},func = <<"[]"/utf8>>,reward = [{3,2659},{240100101,27}],next = 4001572,give_up = 0,double_time = [],liveness_reward = 0};
get(4001572) ->
#base_task{id = 4001572,name = <<"抗暴天赋等级90"/utf8>>,desc = <<"抗暴天赋升级到90"/utf8>>,type = 4,subtype = 55,previous = 4001571,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500801,1,90},func = <<"[]"/utf8>>,reward = [{3,2752},{240100101,28}],next = 4001573,give_up = 0,double_time = [],liveness_reward = 0};
get(4001573) ->
#base_task{id = 4001573,name = <<"生命天赋等级100"/utf8>>,desc = <<"生命天赋升级到100"/utf8>>,type = 4,subtype = 55,previous = 4001572,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500101,1,100},func = <<"[]"/utf8>>,reward = [{3,2849},{240100101,28}],next = 4001574,give_up = 0,double_time = [],liveness_reward = 0};
get(4001574) ->
#base_task{id = 4001574,name = <<"攻击天赋等级100"/utf8>>,desc = <<"攻击天赋升级到100"/utf8>>,type = 4,subtype = 55,previous = 4001573,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500201,1,100},func = <<"[]"/utf8>>,reward = [{3,2948},{240100101,29}],next = 4001575,give_up = 0,double_time = [],liveness_reward = 0};
get(4001575) ->
#base_task{id = 4001575,name = <<"防御天赋等级100"/utf8>>,desc = <<"防御天赋升级到100"/utf8>>,type = 4,subtype = 55,previous = 4001574,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500301,1,100},func = <<"[]"/utf8>>,reward = [{3,3051},{240100101,31}],next = 4001576,give_up = 0,double_time = [],liveness_reward = 0};
get(4001576) ->
#base_task{id = 4001576,name = <<"命中天赋等级100"/utf8>>,desc = <<"命中天赋升级到100"/utf8>>,type = 4,subtype = 55,previous = 4001575,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500401,1,100},func = <<"[]"/utf8>>,reward = [{3,3158},{240100101,32}],next = 4001577,give_up = 0,double_time = [],liveness_reward = 0};
get(4001577) ->
#base_task{id = 4001577,name = <<"闪避天赋等级100"/utf8>>,desc = <<"闪避天赋升级到100"/utf8>>,type = 4,subtype = 55,previous = 4001576,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500501,1,100},func = <<"[]"/utf8>>,reward = [{3,3269},{240100101,33}],next = 4001578,give_up = 0,double_time = [],liveness_reward = 0};
get(4001578) ->
#base_task{id = 4001578,name = <<"暴击天赋等级100"/utf8>>,desc = <<"暴击天赋升级到100"/utf8>>,type = 4,subtype = 55,previous = 4001577,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500601,1,100},func = <<"[]"/utf8>>,reward = [{3,3383},{240100101,34}],next = 4001579,give_up = 0,double_time = [],liveness_reward = 0};
get(4001579) ->
#base_task{id = 4001579,name = <<"抗暴天赋等级100"/utf8>>,desc = <<"抗暴天赋升级到100"/utf8>>,type = 4,subtype = 55,previous = 4001578,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500701,1,100},func = <<"[]"/utf8>>,reward = [{3,3502},{240100101,35}],next = 4001580,give_up = 0,double_time = [],liveness_reward = 0};
get(4001580) ->
#base_task{id = 4001580,name = <<"抗暴天赋等级100"/utf8>>,desc = <<"抗暴天赋升级到100"/utf8>>,type = 4,subtype = 55,previous = 4001579,level = [1,100],circle_type = 0,time = [],end_time = [],condition = {10,500801,1,100},func = <<"[]"/utf8>>,reward = [{3,3624},{240100101,36}],next = 0,give_up = 0,double_time = [],liveness_reward = 0};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

all() ->
[1000001,1000002,1000003,1000004,1000005,1000006,1000007,1000008,1000009,1000010,1000011,1000012,1000013,1000014,1000015,1000016,1000017,1000018,1000019,1000020,1000021,1000022,1000023,1000024,1000025,1000026,1000027,1000028,1000029,1000030,1000031,1000032,1000033,1000034,1000035,1000036,1000037,1000038,1000039,1000040,1000041,1000042,1000043,1000044,1000045,1000046,1000047,1000048,1000049,1000050,1000051,1010001,1010002,1010003,1010004,1010005,1010006,1010007,1010008,1010009,1010010,1010011,1010012,1010013,1010014,1010015,1010016,1010017,1010018,1010019,1010020,1010021,1010022,1010023,1010024,1010025,1010026,1010027,1010028,1010029,1010030,1010031,1010032,1010033,1010034,1010035,1010036,1010037,1010038,1010039,1010040,1010041,1010042,1020001,1020002,1020003,1020004,1020005,1020006,1020007,1020008,1020009,1020010,1020011,1020012,1020013,1020014,1020015,1020016,1020017,1020018,1020019,1020020,1020021,1020022,1020023,1020024,1020025,1020026,1020027,1020028,1020029,1020030,1020031,1020032,1020033,1020034,1020035,1020036,1020037,1020038,1020039,1020040,1020041,1020042,2000003,2000004,2000005,2000006,2000007,2000008,2000009,2000010,2000011,2000012,2000013,2000014,2000015,2000016,2000017,2000018,2000019,2000020,2000021,2000022,2000023,2000024,2000025,2000026,2000027,2000028,4000001,4000002,4000003,4000004,4000005,4000006,4000007,4000008,4000009,4000010,5000001,5000002,5000003,5000004,4000101,4000102,4000103,4000104,4000105,4000106,4000107,4000108,4000109,4000110,4000111,4000112,4000113,4000114,4000115,4000116,4000117,4000118,4000119,4000120,4000121,4000122,4000123,4000124,4000125,4000126,4000127,4000128,4000129,4000130,4000131,4000132,4000133,4000134,4000135,4000136,4000137,4000138,4000139,4000140,4000201,4000202,4000203,4000204,4000205,4000206,4000207,4000208,4000209,4000301,4000302,4000303,4000304,4000305,4000306,4000307,4000308,4000309,4000310,4000401,4000402,4000403,4000404,4000405,4000406,4000407,4000408,4000409,4000410,4000411,4000412,4000413,4000414,4000415,4000416,4000417,4000418,4000419,4000420,4000421,4000422,4000423,4000424,4000425,4000426,4000427,4000428,4000429,4000430,4000431,4000432,4000433,4000434,4000435,4000436,4000437,4000438,4000439,4000440,4000441,4000442,4000443,4000444,4000445,4000446,4000447,4000448,4000449,4000450,4000451,4000452,4000453,4000454,4000455,4000456,4000457,4000458,4000459,4000460,4000461,4000462,4000463,4000464,4000501,4000502,4000503,4000504,4000505,4000506,4000507,4000508,4000509,4000510,4000511,4000512,4000513,4000514,4000515,4000516,4000517,4000518,4000519,4000520,4000521,4000522,4000523,4000524,4000525,4000526,4000527,4000528,4000529,4000530,4000531,4000532,4000533,4000534,4000535,4000536,4000537,4000538,4000539,4000540,4000601,4000602,4000603,4000604,4000605,4000606,4000607,4000608,4000609,4000610,4000611,4000612,4000613,4000614,4000615,4000616,4000617,4000618,4000619,4000620,4000621,4000622,4000623,4000624,4000625,4000626,4000627,4000628,4000629,4000630,4000631,4000632,4000633,4000634,4000635,4000636,4000637,4000638,4000639,4000640,4000901,4000902,4000903,4000904,4000905,4000906,4000907,4000908,4000909,4000910,4000911,4000912,4000913,4000914,4000915,4000916,4000917,4000918,4000919,4000920,4001001,4001002,4001003,4001004,4001005,4001006,4001007,4001008,4001009,4001010,4001011,4001012,4001013,4001014,4001015,4001016,4001017,4001018,4001019,4001020,4001101,4001102,4001103,4001104,4001105,4001106,4001107,4001108,4001109,4001110,4001111,4001112,4001113,4001114,4001115,4001116,4001117,4001118,4001119,4001120,4001201,4001202,4001203,4001204,4001205,4001206,4001207,4001208,4001209,4001210,4001211,4001212,4001213,4001214,4001215,4001216,4001217,4001218,4001219,4001220,4001301,4001302,4001303,4001304,4001305,4001306,4001307,4001308,4001309,4001310,4001311,4001312,4001313,4001314,4001315,4001316,4001317,4001318,4001319,4001320,6010001,6010002,6010003,6010004,6020001,6020002,6020003,6020004,6030001,6030002,6030003,6030004,6030005,6030006,6030007,6030008,6030009,6030010,6030011,6030012,6030013,6030014,6030015,6030016,6030017,6030018,6030019,6030020,6030021,6030022,6030023,6030024,6030025,6030026,6030027,6030028,6030029,6030030,6030031,6030032,6030033,6030034,6030035,6030036,6030037,6030038,6030039,6030040,6030041,6030042,6030043,6030044,6030045,6030046,6030047,6030048,6030049,6030050,6030051,6030052,6030053,6030054,6030055,6030056,6030057,6030058,6030059,6030060,6030061,6030062,6030063,6030064,6030065,6030066,6030067,6030068,6030069,6030070,6030071,6030072,6030073,6030074,6030075,6030076,6030077,6030078,6030079,6030080,6030081,6030082,6030083,6030084,6030085,6030086,6030087,6030088,6030089,6030090,6030091,6030092,6030093,6030094,6030095,6030096,6030097,6030098,6030099,6030100,6030101,6030102,6030103,6030104,6030105,6030106,6030107,6030108,6030109,6030110,6030111,6030112,4001501,4001502,4001503,4001504,4001505,4001506,4001507,4001508,4001509,4001510,4001511,4001512,4001513,4001514,4001515,4001516,4001517,4001518,4001519,4001520,4001521,4001522,4001523,4001524,4001525,4001526,4001527,4001528,4001529,4001530,4001531,4001532,4001533,4001534,4001535,4001536,4001537,4001538,4001539,4001540,4001541,4001542,4001543,4001544,4001545,4001546,4001547,4001548,4001549,4001550,4001551,4001552,4001553,4001554,4001555,4001556,4001557,4001558,4001559,4001560,4001561,4001562,4001563,4001564,4001565,4001566,4001567,4001568,4001569,4001570,4001571,4001572,4001573,4001574,4001575,4001576,4001577,4001578,4001579,4001580].

get_task_but_main() ->
[2000003,2000004,2000005,2000006,2000007,2000008,2000009,2000010,2000011,2000012,2000013,2000014,2000015,2000016,2000017,2000018,2000019,2000020,2000021,2000022,2000023,2000024,2000025,2000026,2000027,2000028,6010001,6010002,6010003,6010004,6020001,6020002,6020003,6020004,6030001,6030002,6030003,6030004,6030005,6030006,6030007,6030008,6030009,6030010,6030011,6030012,6030013,6030014,6030015,6030016,6030017,6030018,6030019,6030020,6030021,6030022,6030023,6030024,6030025,6030026,6030027,6030028,6030029,6030030,6030031,6030032,6030033,6030034,6030035,6030036,6030037,6030038,6030039,6030040,6030041,6030042,6030043,6030044,6030045,6030046,6030047,6030048,6030049,6030050,6030051,6030052,6030053,6030054,6030055,6030056,6030057,6030058,6030059,6030060,6030061,6030062,6030063,6030064,6030065,6030066,6030067,6030068,6030069,6030070,6030071,6030072,6030073,6030074,6030075,6030076,6030077,6030078,6030079,6030080,6030081,6030082,6030083,6030084,6030085,6030086,6030087,6030088,6030089,6030090,6030091,6030092,6030093,6030094,6030095,6030096,6030097,6030098,6030099,6030100,6030101,6030102,6030103,6030104,6030105,6030106,6030107,6030108,6030109,6030110,6030111,6030112].

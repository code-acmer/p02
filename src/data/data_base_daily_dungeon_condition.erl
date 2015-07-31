%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_daily_dungeon_condition).
-export([get/1]).
-include("common.hrl").
-include("db_base_daily_dungeon_condition.hrl").
get(1) ->
[{time,60},
 {damage,90},
 {hurt,10},
 {combo,200},
 {aircombo,50},
 {skillcancel,50},
 {crit,50}];
get(2) ->
[{time,61},
 {damage,91},
 {hurt,11},
 {combo,201},
 {aircombo,51},
 {skillcancel,51},
 {crit,51}];
get(3) ->
[{time,62},
 {damage,92},
 {hurt,12},
 {combo,202},
 {aircombo,52},
 {skillcancel,52},
 {crit,52}];
get(4) ->
[{time,63},
 {damage,93},
 {hurt,13},
 {combo,203},
 {aircombo,53},
 {skillcancel,53},
 {crit,53}];
get(5) ->
[{time,64},
 {damage,94},
 {hurt,14},
 {combo,204},
 {aircombo,54},
 {skillcancel,54},
 {crit,54}];
get(6) ->
[{time,65},
 {damage,95},
 {hurt,15},
 {combo,205},
 {aircombo,55},
 {skillcancel,55},
 {crit,55}];
get(7) ->
[{time,66},
 {damage,96},
 {hurt,16},
 {combo,206},
 {aircombo,56},
 {skillcancel,56},
 {crit,56}];
get(8) ->
[{time,67},
 {damage,97},
 {hurt,17},
 {combo,207},
 {aircombo,57},
 {skillcancel,57},
 {crit,57}];
get(9) ->
[{time,68},
 {damage,98},
 {hurt,18},
 {combo,208},
 {aircombo,58},
 {skillcancel,58},
 {crit,58}];
get(10) ->
[{time,69},
 {damage,99},
 {hurt,19},
 {combo,209},
 {aircombo,59},
 {skillcancel,59},
 {crit,59}];
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

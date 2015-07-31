-module(db_version).

%% API

-export([behaviour_info/1]).
-export([start/0]).

behaviour_info(callbacks) ->
    [{current_version, 0},
     {version, 1}];
behaviour_info(_Other) ->
    undefined.


%% current_version返回当前record的版本号
%% version就是记录每个版本的数据原型，完整格式是{RecordInfo, ChangeNameList}，但是大部分情况不涉及改名字，所以可以直接RecordInfo也可以，RecordInfo是有all_record:new(Record)打印 ChangeNameList [{OldField, NewField}]

%% ** 每个record都有个version
%%    强制放在第二位
   
%% ** 读取时转换
%%    通过版本号匹配，匹配直接返回。
%%    否则进行转换。

%% ** 转换功能支持
%%    1、基础功能：加减字段，重命名，调整顺序
%%    2、嵌套更新


start() ->
    [start(proplists:get_value(record_name, TabDef, Tab)) || {Tab, TabDef} <- mnesia_table:definitions()].

start(player) ->
    ok;
start(mnesia_statistics) ->
    ok;
start(player_count) ->
    ok;
start(node_status) ->
    ok;
start(RecordName) ->
    Src = lists:concat(["-module(", RecordName, "_version).\n-behaviour(db_version).\n-export([current_version/0, version/1]).\ncurrent_version() ->\n    1.\n\nversion(1) ->\n    "]) ++ all_record:new(RecordName) ++ ";\nversion(Version) ->\n    throw({version_error, Version}).",
    file:write_file(filename:join([app_misc:server_root(), "src/mnesia_db/table_version/", atom_to_list(RecordName) ++"_version.erl"]), io_lib:format("~s", [Src])).


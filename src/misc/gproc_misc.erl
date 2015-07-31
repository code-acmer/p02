-module(gproc_misc).

-export([start/0]).
%% 新增DB节点的时候，最好要停服，不然gproc不能正常工作，gproc使用的gen_leader有这个缺陷
start() ->
    ok = application:load(gproc),
    DBNodes = app_misc:get_env(db_nodes),
    application:set_env(gproc, gproc_dist, {DBNodes, [{vardir, vardir()}, {workers, [node()]}]}),
    ok = application:start(gproc).



vardir() ->
    Dir = filename:join(app_misc:server_root(), "logs/gproc/") ++ "/",
    ok = filelib:ensure_dir(Dir),
    Dir.

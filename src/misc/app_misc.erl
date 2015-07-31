-module(app_misc).
-export([get_env/2, get_env/1]).
-export([ensure_application_loaded/0]).
-export([get_module/1, version/0]).
-export([init/0, mochi_set/2, mochi_get/1, get_db_config/1]).
-export([get_sdk_config/2]).

-export([server_root/0]).
-export([start/1]).

init() ->
    mochi_set_value().

mochi_set_value() ->
    [mochi_set(Key, get_app_env(Key)) || Key <- [strict_md5, can_gmcmd, server_state, server_start_timestamp] ],
    set_boss_double_drop(),
    mochi_set(server_root, remove_suffix_ebin(code:which(main))), %% cover编译后会丢失ebin路径信息，所以预先保存起来。
    ok.
%% 开服需要的信息就直接get_env
%% 如果常取的数据，比如server_id，那么可以通过mochiweb golbal动态编译，然后直接函数调用
get_app_env(App, Key, Def) ->
  case application:get_env(App, Key) of
      undefined -> 
          Def;
      {ok, Value} -> 
          Value
  end.

%%api
get_env(server_start_timestamp) ->
    mochi_get(server_start_timestamp);
get_env(server_state) ->
    mochi_get(server_state);
get_env(strict_md5) ->
    mochi_get(strict_md5);
get_env(can_gmcmd) ->
    mochi_get(can_gmcmd);
get_env(Key) ->
    get_app_env(Key, undefined).

get_env(Key, Def) ->
    get_app_env(Key, Def).

get_app_env(Key) ->
    get_app_env(Key, undefined).
get_app_env(Key, Def) ->
    get_app_env(server, Key, Def).

ensure_application_loaded() ->
    case application:load(server) of
        ok ->
            ok;
        {error, {already_loaded, server}} ->
            ok
    end.

get_module(App) ->
    application:get_key(App, modules).

get_vsn(App) ->
    application:get_key(App, vsn).

version() ->
    {ok, Vsn} = get_vsn(server),
    Vsn.

mochi_set(Key, Value) ->
    mochiglobal:put(Key, Value).

mochi_get(Key) ->
    case mochiglobal:get(Key) of
        undefined ->
            %error_logger:info_msg("mochi_get error Key ~p~n", [Key]),
            get_app_env(Key);
        Value ->
            Value
    end.

get_db_config(Db) ->
    case get_env(Db) of
        undefined -> throw(undefined);
	DB_config -> 
            {_, Type} = lists:keyfind(type, 1, DB_config),
            {_, Host} = lists:keyfind(host, 1, DB_config),
            {_, Port} = lists:keyfind(port, 1, DB_config),
            {_, User} = lists:keyfind(user, 1, DB_config),
            {_, Password} = lists:keyfind(password, 1, DB_config),
            {_, DB} = lists:keyfind(db, 1, DB_config),
            {_, Poolsize} = lists:keyfind(poolsize, 1, DB_config),
            {_, Encode} = lists:keyfind(encode, 1, DB_config),
            [Type, Host, Port, User, Password, DB, Poolsize, Encode]
    end.

%% 这个做法比较不合理，但是能工作。
%% code:lib_dir有局限性，就是app目录名和app名要一致
server_root() ->
    case mochiglobal:get(server_root) of
        undefined ->
            %% 兼容脚本启动的调用，这个时候可能并没有扔到mochigolbal
            remove_suffix_ebin(code:which(main));
        Value ->
            Value
    end.
 
remove_suffix_ebin(MainPath) ->
    Detal = length(MainPath) - length("ebin/main.beam"),
     lists:sublist(MainPath, Detal).

start(App) ->
    start_ok(App, application:start(App)).

start_ok(_App, ok) -> ok;
start_ok(_App, {error, {already_started, _App}}) -> ok;
start_ok(App, {error, {not_started, Dep}}) ->
    ok = start(Dep),
    start(App);
start_ok(App, {error, Reason}) ->
    erlang:error({app_start_failed, App, Reason}).

set_boss_double_drop() ->
    case application:get_env(server, boss_double_drop) of
        undefined ->
            skip;
        {ok, TimeInfoList} ->
            %% TimeStampList = 
            %%     lists:map(fun({From, To}) ->
            %%                       {time_misc:datetime_to_timestamp(From), time_misc:datetime_to_timestamp(To)}
            %%               end, TimeInfoList),
            mochi_set(boss_double_drop_timestamp, TimeInfoList)
    end.


get_sdk_config(SdkType, Key) ->
    {ok, Config} = application:get_env(server, SdkType),
    proplists:get_value(Key, Config).

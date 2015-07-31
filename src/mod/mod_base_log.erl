-module(mod_base_log).

-behaviour(gen_server).

%% API
-export([start_link/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% log api
-export([
         log/2
        ]).

%% test
-export([test/1, test_start/0, test_log/1]).

-include("define_log.hrl").
-include("common.hrl").
-include("db_log_player.hrl").
-include("define_mysql.hrl").

-define(SERVER, ?MODULE). 

test_start() ->
    start_link(log_player_p, #log_state{
                              db_conf = #record_mysql_info{
                                           db_pool = db_log,
                                           table_name = log_player,
                                           record_name = log_player,
                                           fields = record_info(fields, log_player)
                                          },
                              timestamp_pos = #log_player.timestamp
                             }).
test(N) ->
    Before = os:timestamp(),
    test_log(N),
    After = os:timestamp(),
    ?DEBUG("time ~p microseconds~n", [timer:now_diff(After, Before)]).

test_log(0) ->
    ok;
test_log(N) ->
    Run = fun() ->
                  Logs = [#log_player{
                             player_id = Id,
                             event_id = Id
                            } || Id <- lists:seq(1, 30)],
                  log(log_player_p, Logs)
          end,
    [spawn(Run) || _ <- lists:seq(1,3000)],
    timer:sleep(2000),    
    ?DEBUG("msg_q ~p~n", [erlang:process_info(whereis(log_player_p), message_queue_len)]),
    test_log(N - 1).
%% create table log_player_20140601 like log_player
% CREATE TABLE IF NOT EXISTS log_player_20140601_2 like log_player ;
%%%===================================================================
%%% API
%%%===================================================================

start_link(Server, LogState) ->
    gen_server:start_link({local, Server}, ?MODULE, LogState, []).

log(Server, Log) when is_tuple(Log) ->
    log(Server, [Log]);
log(Server, Log) ->
    gen_server:cast(Server, {log, Log}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init(#log_state{
        db_conf = #record_mysql_info{
                     table_name = TableName
                    },
        is_rotate = IsRotate
       } = LogState) ->
    if
        IsRotate =:= true ->
            gen_server:cast(self(), check_rotate);
        true ->
            ignore
    end,
    {ok, LogState#log_state{
           base_table_name = atom_to_list(TableName)
          }}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(check_rotate, LogState) ->
    {noreply, check_rotate(LogState)};

handle_cast({log, Logs}, #log_state{
                            log_list = LogList,
                            timestamp_pos = TimeStampPos
                           } = LogState) ->
    %?DEBUG("append len ~p~n", [length(Logs)]),
    {noreply, LogState#log_state{
                log_list = set_timestamp(Logs, TimeStampPos) ++ LogList
               }, 0};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(timeout, #log_state{
                        db_conf = DbConf,
                        log_list = LogList,
                        last_check = LastCheck,
                        is_rotate = IsRotate,
                        insert_fun = F
                       } = LogState) ->
    Len = length(LogList),
    Before = os:timestamp(),
    %% 实际最大可以去到7000, log_player，实际还是看表，一般数据太多，3k是可以接受，数据量少就按照500来。
    N = erlang:min(3000, erlang:max(Len div 20, 500)),
    Now = time_misc:unixtime(),
    insert_every_n(DbConf, LogList, N, F),
    EmptyLogState = LogState#log_state{
                      log_list = []
                     },

    NewLogState = if
                      IsRotate =:= true andalso
                      Now > LastCheck + ?ROTATE_CHECK_INTERVAL ->
                          check_rotate(EmptyLogState);
                      true ->
                          EmptyLogState
                  end,

    After = os:timestamp(),
    Times = timer:now_diff(After, Before),
    ?DEBUG("~p insert len ~p ~p microseconds~n", [DbConf#record_mysql_info.table_name, Len, Times]),
    {noreply, NewLogState};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

with_try(Fun) ->
    try
        Fun()
    catch Error:Reason ->
            ?WARNING_MSG("Error ~w, Reason: ~w, Stack: ~p~n",
                         [Error, Reason, erlang:get_stacktrace()])
    end.

set_timestamp(Logs, undefined) ->
    Logs;
set_timestamp(Logs, TimeStampPos) ->
    Now = time_misc:unixtime(),
    [setelement(TimeStampPos, Log, Now) || Log <- Logs].
  

insert_every_n(_DbConf, [], _, _) ->
    ok;
insert_every_n(DbConf, LogList, N, F) ->
    {InsertLogList, RestLogList} = ds_misc:split(N, LogList),
    with_try(fun() ->
                     %% db_mysql_base:r_list_insert_withnot_id
                     case F(DbConf, InsertLogList) of
                         {ok, _} ->
                             ok;
                         {error, Error} ->
                             ?WARNING_MSG("log error ~p~n", [Error])
                     end
                     %?DEBUG("insert Result ~p~n", [Result])
             end),
    insert_every_n(DbConf, RestLogList, N, F).
    


check_rotate(#log_state{
                db_conf = #record_mysql_info{
                             db_pool = DbPool,
                             table_name = TableName0
                            } = DbConf,
                is_rotate = true,
                base_table_name = BaseTableName,
                table_index = TableIndex0,
                last_check = LastCheck
               } = LogState) ->
    Now = time_misc:unixtime(),
    CurrentTableName = rotate_table(BaseTableName, TableIndex0),
    TableIndex = 
        if
            CurrentTableName =:= TableName0 ->                
                %% 还是同一天，否则index一样，时间也会不一样的
                %% 初始化走初始化分支也是没有问题
                TableIndex0;
            true ->
                1
        end,
    if
       Now - LastCheck > ?ONE_DAY_SECONDS -> 
            may_delete_table(DbPool, BaseTableName);
        true ->
            skip
    end,
    NewTableIndex = available_table2(DbPool, BaseTableName, TableIndex),
    LogState#log_state{
      table_index = NewTableIndex,
      db_conf = DbConf#record_mysql_info{
                  table_name = rotate_table(BaseTableName, NewTableIndex)
                 },
      last_check = Now
     };
check_rotate(LogState) -> 
    LogState.

may_delete_table(DbPool, BaseTableName) ->
    %%log_player_20140601_1
    Sql = lists:concat(["show tables like '", BaseTableName, "_20%'"]),
    ?INFO_MSG("Sql ~p~n", [Sql]),
    case db_mysql_base:run_rows(DbPool, Sql) of
        {ok, Result} ->
            {_, DelList} = list_misc:sublist(lists:reverse(Result), 30),
            ?INFO_MSG("DelList ~p~n", [DelList]),
            lists:foreach(fun([Table]) ->
                                  DelSql = <<"drop table ", Table/binary>>,
                                  emysql:execute(DbPool, DelSql)
                          end, DelList),
            ok;
        {error, Result} ->
            ?WARNING_MSG("error Result ~p~n", [Result]),
            ok
    end.

%% 寻找可用的Index
available_table2(DbPool, BaseTableName, TableIndex) ->
    RotateTable = rotate_table(BaseTableName, TableIndex),
    %% 懒得事务，数据库最终去决定是否需要创建
    CreateTableSQL = lists:concat(["CREATE TABLE IF NOT EXISTS ", 
                                   RotateTable, 
                                   " LIKE ", BaseTableName]),
    case db_mysql_base:run_affected(DbPool, CreateTableSQL) of
        {ok, Result} ->
            ?INFO_MSG("run CreateTableSQL Result ~p, TableIndex ~p~n", [Result, TableIndex]),
            SQL = erl_mysql:select({call, count, 1}, RotateTable),
            case db_mysql_base:run_rows(DbPool, SQL) of
                {ok, [[Count]]} ->
                    if
                        Count =< ?TABLE_OVERFLOW_COUNT ->
                            TableIndex;
                        true ->
                            available_table2(DbPool, BaseTableName, TableIndex + 1)
                    end;
                {error, Error} ->
                    ?WARNING_MSG("run count error ~p, SQL ~s~n", [Error, SQL]),
                    TableIndex
            end;
        {error, Error} ->
            ?WARNING_MSG("run CreateTableSQL error ~p, CreateTableSQL ~s~n", [Error, CreateTableSQL]),
            TableIndex
    end.


rotate_table(TableName, TableIndex) -> 
    list_to_atom(lists:concat([TableName, "_", time_misc:yyyymmdd(), "_", TableIndex])).
    
%% db_mysql_base:run_rows(db_log, ).

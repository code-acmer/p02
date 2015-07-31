%%%-------------------------------------------------------------------
%%% @author Arno <>
%%% @copyright (C) 2013, Arno
%%% @doc
%%%
%%% @end
%%% Created : 18 Dec 2013 by Arno <>
%%%-------------------------------------------------------------------
-module(mod_mnesia_backup).

-include("define_logger.hrl").
-include("define_time.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0,
         inner_mnesia_backup/0,
         mnesia_restore/1
        ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 
-define(MNESIA_BACKUP_PATH, "./backup/").

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    ?INFO_MSG("trying mnesai_backup server started.~n",[]),
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    ?INFO_MSG("mnesai_backup server started.~n",[]),
    Tomorrow4Sec = time_misc:get_seconds_to_tomorrow_4(),
    erlang:send_after(Tomorrow4Sec * 1000, self(), mnesia_backup),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(mnesia_backup, State) ->
    case inner_mnesia_backup() of
        ok ->
            ?INFO_MSG("mnesia_backup success~n",[]);
        _ ->
            ?WARNING_MSG("mnesia_backup failed!~b",[])
    end,
    erlang:send_after(?ONE_DAY_SECONDS * 1000, self(), mnesia_backup),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.


terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

inner_mnesia_backup() ->
    MnesiaBackRoot = app_misc:get_env(mnesia_back_root, "./backup/"),
    case catch filelib:ensure_dir(MnesiaBackRoot) of
        ok ->
            BackupPath = lists:concat([MnesiaBackRoot, time_misc:yyyymmdd(), ".bak"]),
            ?INFO_MSG("trying to backup mnesia to path:~s~n",[BackupPath]),
            catch mnesia:backup(BackupPath);
        R ->
            ?WARNING_MSG("create mnesia_back_root failed!R:~p~n",[R]),
            ok
    end.
    

mnesia_restore(BackupFile) ->
    catch mnesia:restore(BackupFile, [{default_op, recreate_tables}]).

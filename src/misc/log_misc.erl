-module(log_misc).
-export([start/0]).

start() ->
    ok = application:load(lager),
    case application:get_env(lager, log_level) of
        {ok, Val} ->
            start(Val);
        _ ->
            throw({lager_start_error,not_set_log_level})
    end.

start(Level) ->
    ConsoleBackend = lager_console_backend(Level),
    FileBackend = [lager_file_backend(Level)],
    application:set_env(lager, handlers, ConsoleBackend ++ FileBackend),
    application:set_env(lager, crash_log, crash_log()),
    lager:start().
    
is_console() ->
    init:get_argument(noshell) =:= error.

lager_file_backend(Level) ->
    {lager_file_backend, 
     [
      {level, Level}, 
      {date, "$W0D23"},
      {count, 20}, %% 默认每个文件10M
      {file, lager_file_backend_file()}
     ]}.

lager_console_backend(Level) ->
    case is_console() of
        true ->
            [lager_console_backend2(Level)];  
        _ ->
            []
    end.

lager_console_backend2(Level) ->
    {lager_console_backend,
     [Level, {lager_default_formatter, 
              [date, " ", time, color, " [",severity,"] <",pid, ">@", module,":",
               function, ":", line, " ", message, "\e[0m\r\n"]
             }]}.

lager_file_backend_file() ->
    filename:join(log_dir(), "server.log").

crash_log() ->
    filename:join(log_dir(), "server-crash.log").

log_dir() ->
    LogDir = app_misc:get_env(log_dir, "logs/"),    
    case LogDir of
        "/" ++ _ ->
            filename:join([LogDir, node()]);
        _ ->
            filename:join([app_misc:server_root(), LogDir, node()])
    end.

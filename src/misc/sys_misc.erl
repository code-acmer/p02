-module(sys_misc).
-compile(export_all).

help() ->
    error_logger:info_msg("pid_info/1 /2 support args meta, signals, location, memory_used, work", []),
    error_logger:info_msg("memory/0 lookup memory_used in vm by bytes ~n", []),
    error_logger:info_msg("cpu/0 lookup cpu info within 3 seconds ~n", []),
    error_logger:info_msg("proc_num/0 count proc num ~n", []),
    error_logger:info_msg("proc_count/2 (Type, Num) show top num of proc on type,include memory reductions, message_queue_len~n", []),
    error_logger:info_msg("get_state/1 pid show state in OTP proc~n", []),
    error_logger:info_msg("system_info/0 pid show state in OTP proc~n", []),
    ok.

pid_info(Pid) ->
    recon:info(Pid).

pid_info(Pid, Type) ->
    recon:info(Pid, Type).

memory() ->
    erlang:memory().

cpu() ->
    recon:scheduler_usage(1000).

proc_num() ->
    length(processes()).

proc_count(Type, Num) ->
    recon:proc_count(Type, Num).

ports() ->
    recon:port_types().

get_state(Pid) ->
    recon:get_state(Pid).

system_info() ->
    ProcCount = proc_num(),
    ProcLimit = erlang:system_info(process_limit),
    PortCount = erlang:system_info(port_count),
    PortLimit = erlang:system_info(port_limit),
    EtsLimit = erlang:system_info(ets_limit),
    MemInfo = memory(),
    CpuInfo = cpu(),
    PortInfo = ports(),
    error_logger:info_msg("show system information:
                         ~n ProcCount: ~p
                         ~n ProcLimit: ~p
                         ~n PortCount: ~p
                         ~n PortLimit: ~p
                         ~n EtsLimit: ~p
                         ~n MemInfo(bytes): ~p
                         ~n CpuInfo: ~p
                         ~n PortInfo: ~p~n", 
                          [ProcCount, ProcLimit, PortCount,
                           PortLimit, EtsLimit, MemInfo, 
                           CpuInfo, PortInfo]).

system_top() ->
    ProcTopMem = proc_count(memory, 10),
    ProcTopRed = proc_count(reductions, 10),
    ProcTopMeg = proc_count(message_queue_len, 10),
    error_logger:info_msg("ProcTopMem ~w~n", [ProcTopMem]),
    error_logger:info_msg("ProcTopRed ~w~n", [ProcTopRed]),
    error_logger:info_msg("ProcTopMsgLen ~w~n", [ProcTopMeg]),
    ok.

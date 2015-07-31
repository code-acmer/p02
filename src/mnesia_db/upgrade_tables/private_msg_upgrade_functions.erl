-module(private_msg_upgrade_functions).
-include("define_mnesia_upgrade_functions.hrl").
%% If you are tempted to add include file here, don't. Using record
%% defs here leads to pain later.

-compile([export_all]).

-mnesia_upgrade({private_msg_create, []}).

private_msg_create() ->
    {atomic, ok} =  mnesia:create_table(private_msg,[{type,set},
                                                     {attributes, [id,msg,timestamp]},
                                                     {disc_copies, [node()]}]).  
                        
do_transform(MnesiaUpgradeConf) ->
    ok = mnesia_upgrade_functions:do_transform(private_msg, MnesiaUpgradeConf).

-module(chat_private_upgrade_functions).
-include("define_mnesia_upgrade_functions.hrl").
%% If you are tempted to add include file here, don't. Using record
%% defs here leads to pain later.

-compile([export_all]).

-mnesia_upgrade({chat_private_create, []}).

chat_private_create() ->
    {atomic, ok} = mnesia:create_table(chat_private,[{type,set},
                                                     {attributes,[id,msg_ids,recv_id]},
                                                     {disc_copies,[node()]}]).    

do_transform(MnesiaUpgradeConf) ->
    ok = mnesia_upgrade_functions:do_transform(chat_private, MnesiaUpgradeConf).

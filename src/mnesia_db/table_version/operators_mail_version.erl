-module(operators_mail_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,undefined},{version,1},{dirty,1},{player_id,undefined},{base_id,undefined},{state,0},{recv_attachments_state,0}];

version(Version) ->
    throw({version_error, Version}).

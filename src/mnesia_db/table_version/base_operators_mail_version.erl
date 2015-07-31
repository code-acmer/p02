-module(base_operators_mail_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,0},{version,1},{send_timestamp,0},{begin_timestamp,0},{end_timestamp,0},{min_lv,0},{max_lv,0},{send_name,0},{title,<<>>},{content,<<>>},{attachments,[]}];
version(Version) ->
    throw({version_error, Version}).

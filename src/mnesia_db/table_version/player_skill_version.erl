-module(player_skill_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    3.

version(1) ->
    [{id,0},{version,1},{skill_id,0},{player_id,0},{lv,0},{str_lv,0},{status,0}];
version(2) ->
    [{id,0},{version,2},{skill_id,0},{player_id,0},{lv,0},{str_lv,0},{type,0},{sigil,[]},{status,0}];
version(3) ->
    [{id,0},{version,3},{skill_id,0},{player_id,0},{lv,1},{str_lv,0},{type,0},{sigil,[]},{status,0},{dirty,0}];
version(Version) ->
    throw({version_error, Version}).

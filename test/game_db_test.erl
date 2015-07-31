-module(game_db_test).

%% setup_games() ->
%%     Limit = #limit{small = 10, big = 20, min = 500, max = 1000},
%%     mnesia:dirty_write(
%%       #tab_game_config{
%%          id = 1, 
%%          module = game,
%%          mods = ?DEF_MOD,
%%          limit = Limit,
%%          seat_count = 9,
%%          start_delay = ?START_DELAY,
%%          required = 2,
%%          timeout = 1000,
%%          max = 10}).
%% %% mnesia:dirty_write(#tab_game_config{id = 2, module = game, mods = ?DEF_MOD, limit = Limit#limit{small = 100, big = 200}, seat_count = 9, start_delay = ?START_DELAY, required = 2, timeout = 1000, max = 10}),
%% %% mnesia:dirty_write(#tab_game_config{id = 3, module = game, mods = ?DEF_MOD, limit = Limit#limit{small = 500, big = 1000}, seat_count = 5, start_delay = ?START_DELAY, required = 2, timeout = 1000, max = 10}).

%% setup_players() ->
%%     mnesia:dirty_write(
%%       #tab_player_info{
%%          pid = 1,
%%          identity = "player",
%%          password = ?DEF_HASH_PWD,
%%          nick = "nick",
%%          photo = "default.png",
%%          cash = 10000}),
%%     mnesia:dirty_write(
%%       #tab_player_info{
%%          pid = 2,
%%          identity = "robot",
%%          password = ?DEF_HASH_PWD,
%%          nick = "robot",
%%          photo = "2012491443.jpg",
%%          cash = 10000}),
%%     mnesia:dirty_write(
%%       #tab_player_info{
%%          pid = 3,
%%          identity = "robot_foo",
%%          password = ?DEF_HASH_PWD,
%%          nick = "robot foo",
%%          photo = "2011962129360.jpg",
%%          cash = 10000}),
%%     mnesia:dirty_write(
%%       #tab_player_info{
%%          pid = 4,
%%          identity = "robot_doo",
%%          password = ?DEF_HASH_PWD,
%%          nick = "robot doo",
%%          photo = "2012491439.jpg",
%%          cash = 10000}),
%%     setup_test_players(200).

%% setup_test_players(100) ->
%%     ok;
%% setup_test_players(N) ->
%%     Nick = string:concat("TEST ", integer_to_list(N)),
%%     Identity = string:concat("tester_", integer_to_list(N)),
%%     mnesia:dirty_write(#tab_player_info{pid = N, identity = Identity, password = ?HASH_PWD("pwd"), nick = Nick, photo = "default.png", cash = 100000}),
%%     setup_test_players(N - 1).

%% setup_counters()->
%%     %% counter:reset(game),
%%     %% counter:reset(player),
%%     %% counter:reset(inplay_xref),
%%     ok.



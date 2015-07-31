-module(pt_44).

-include("define_logger.hrl").
-include_lib("pb_44_pb.hrl").
-include_lib("define_camp.hrl").

-export([write/2]).

write(44000, {Now, #player_camp{player_id = PlayerId,
                                using_camp = UsingCamp,
                                camp_list  = CampList
                               }}) ->
    PbPlayerCamp = #pbplayercamp{player_id = PlayerId,
                                 using_camp = UsingCamp,
                                 camp_list  = to_pbcamp_list(CampList),
                                 update_timestamp = Now
                                },
    pt:pack(44000, PbPlayerCamp);
write(44100, {Now, Camp}) ->
    PbCamp = (to_pbcamp(Camp))#pbcamp{
               update_timestamp = Now
              },
    pt:pack(44100, PbCamp);
write(44101, {Now, CampId}) ->
    pt:pack(44101, #pbplayercamp{                     
                      using_camp = CampId,
                      update_timestamp = Now
                     });
write(Cmd, _R) ->
    ?ERROR_MSG("~n Errorcmd ~p ~n",[Cmd]),
    pt:pack(0, null).

to_pbcamp_list(CampList) ->
    lists:map(fun(Camp) ->
                      to_pbcamp(Camp)
              end,CampList).

to_pbcamp(#camp{id = Id,
                pos_list = PosList
               }) ->
    #pbcamp{id = Id,
            pos_list = to_pbcamp_pos_list(PosList)
           }.

to_pbcamp_pos_list(PosList) ->
    lists:map(fun({Pos, Gid}) ->
                      #pbcamppos{
                         pos = Pos,
                         goods_uid = Gid
                        }
              end, PosList).

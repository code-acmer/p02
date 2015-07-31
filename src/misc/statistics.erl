-module(statistics).
-include("common.hrl").

-export([
         get_proto_tc/1,
         metrics_value/0
        ]).

-export([proto/2]).

get_proto_tc(ProtocolId) ->
    list_to_atom("proto_tc_" ++ integer_to_list(ProtocolId)).

proto(Cmd, Duration) ->
    MetricName = get_proto_tc(Cmd),
    case folsom_metrics:notify({MetricName, Duration}) of
        {error,_,nonexistent_metric} ->
            proto_metric_init(MetricName),
            folsom_metrics:notify({MetricName, Duration});
        ok ->
            ok
    end.

proto_metric_init(MetricName) ->
    ok = folsom_metrics:new_histogram(MetricName),
    ok = folsom_metrics:tag_metric(MetricName, protocol).

metrics_value() ->
    List = folsom_metrics:get_metrics_value(protocol),
    [begin
         Stat = bear:get_statistics(Data),
         MiniStat = [{K, proplists:get_value(K, Stat)} || K <- [min, max, arithmetic_mean, standard_deviation, variance, n]],
         {MetricName, MiniStat}
     end || {MetricName, Data} <- List].

-file("src/pb_11_pb.erl", 1).

-module(pb_11_pb).

-export([encode_pbnewmsg/1, decode_pbnewmsg/1,
	 delimited_decode_pbnewmsg/1, encode_pbid32/1,
	 decode_pbid32/1, delimited_decode_pbid32/1,
	 encode_pbfeedbackmsg/1, decode_pbfeedbackmsg/1,
	 delimited_decode_pbfeedbackmsg/1, encode_pbchatlist/1,
	 decode_pbchatlist/1, delimited_decode_pbchatlist/1,
	 encode_pbchat/1, decode_pbchat/1,
	 delimited_decode_pbchat/1, encode_pbprivate/1,
	 decode_pbprivate/1, delimited_decode_pbprivate/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(pbnewmsg, {send_list}).

-record(pbid32, {id}).

-record(pbfeedbackmsg, {title, content}).

-record(pbchatlist, {update_list}).

-record(pbchat,
	{id_n, type, id, recv_id, send_id, nickname, lv, career,
	 vip, msg, timestamp, league_id, gold_num}).

-record(pbprivate, {send_list, recv_list}).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_pbnewmsg(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbnewmsg(Record)
    when is_record(Record, pbnewmsg) ->
    encode(pbnewmsg, Record).

encode_pbid32(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbid32(Record) when is_record(Record, pbid32) ->
    encode(pbid32, Record).

encode_pbfeedbackmsg(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbfeedbackmsg(Record)
    when is_record(Record, pbfeedbackmsg) ->
    encode(pbfeedbackmsg, Record).

encode_pbchatlist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbchatlist(Record)
    when is_record(Record, pbchatlist) ->
    encode(pbchatlist, Record).

encode_pbchat(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbchat(Record) when is_record(Record, pbchat) ->
    encode(pbchat, Record).

encode_pbprivate(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbprivate(Record)
    when is_record(Record, pbprivate) ->
    encode(pbprivate, Record).

encode(pbprivate, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbprivate, Record) ->
    [iolist(pbprivate, Record) | encode_extensions(Record)];
encode(pbchat, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbchat, Record) ->
    [iolist(pbchat, Record) | encode_extensions(Record)];
encode(pbchatlist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbchatlist, Record) ->
    [iolist(pbchatlist, Record)
     | encode_extensions(Record)];
encode(pbfeedbackmsg, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbfeedbackmsg, Record) ->
    [iolist(pbfeedbackmsg, Record)
     | encode_extensions(Record)];
encode(pbid32, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbid32, Record) ->
    [iolist(pbid32, Record) | encode_extensions(Record)];
encode(pbnewmsg, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbnewmsg, Record) ->
    [iolist(pbnewmsg, Record) | encode_extensions(Record)].

encode_extensions(_) -> [].

delimited_encode(Records) ->
    lists:map(fun (Record) ->
		      IoRec = encode(Record),
		      Size = iolist_size(IoRec),
		      [protobuffs:encode_varint(Size), IoRec]
	      end,
	      Records).

iolist(pbprivate, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbprivate.send_list, none), pbchat,
	  []),
     pack(2, repeated,
	  with_default(Record#pbprivate.recv_list, none), pbchat,
	  [])];
iolist(pbchat, Record) ->
    [pack(1, optional,
	  with_default(Record#pbchat.id_n, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbchat.type, none), int32, []),
     pack(3, optional, with_default(Record#pbchat.id, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbchat.recv_id, none), int64, []),
     pack(5, optional,
	  with_default(Record#pbchat.send_id, none), int64, []),
     pack(6, optional,
	  with_default(Record#pbchat.nickname, none), string, []),
     pack(7, optional, with_default(Record#pbchat.lv, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbchat.career, none), int32, []),
     pack(9, optional, with_default(Record#pbchat.vip, none),
	  int32, []),
     pack(10, optional,
	  with_default(Record#pbchat.msg, none), string, []),
     pack(11, optional,
	  with_default(Record#pbchat.timestamp, none), int32, []),
     pack(12, optional,
	  with_default(Record#pbchat.league_id, none), int32, []),
     pack(13, optional,
	  with_default(Record#pbchat.gold_num, none), int32, [])];
iolist(pbchatlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbchatlist.update_list, none),
	  pbchat, [])];
iolist(pbfeedbackmsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbfeedbackmsg.title, none), string,
	  []),
     pack(2, optional,
	  with_default(Record#pbfeedbackmsg.content, none),
	  string, [])];
iolist(pbid32, Record) ->
    [pack(1, optional, with_default(Record#pbid32.id, none),
	  int32, [])];
iolist(pbnewmsg, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbnewmsg.send_list, none), int32,
	  [])].

with_default(Default, Default) -> undefined;
with_default(Val, _) -> Val.

pack(_, optional, undefined, _, _) -> [];
pack(_, repeated, undefined, _, _) -> [];
pack(_, repeated_packed, undefined, _, _) -> [];
pack(_, repeated_packed, [], _, _) -> [];
pack(FNum, required, undefined, Type, _) ->
    exit({error,
	  {required_field_is_undefined, FNum, Type}});
pack(_, repeated, [], _, Acc) -> lists:reverse(Acc);
pack(FNum, repeated, [Head | Tail], Type, Acc) ->
    pack(FNum, repeated, Tail, Type,
	 [pack(FNum, optional, Head, Type, []) | Acc]);
pack(FNum, repeated_packed, Data, Type, _) ->
    protobuffs:encode_packed(FNum, Data, Type);
pack(FNum, _, Data, _, _) when is_tuple(Data) ->
    [RecName | _] = tuple_to_list(Data),
    protobuffs:encode(FNum, encode(RecName, Data), bytes);
pack(FNum, _, Data, Type, _)
    when Type =:= bool;
	 Type =:= int32;
	 Type =:= uint32;
	 Type =:= int64;
	 Type =:= uint64;
	 Type =:= sint32;
	 Type =:= sint64;
	 Type =:= fixed32;
	 Type =:= sfixed32;
	 Type =:= fixed64;
	 Type =:= sfixed64;
	 Type =:= string;
	 Type =:= bytes;
	 Type =:= float;
	 Type =:= double ->
    protobuffs:encode(FNum, Data, Type);
pack(FNum, _, Data, Type, _) when is_atom(Data) ->
    protobuffs:encode(FNum, enum_to_int(Type, Data), enum).

enum_to_int(pikachu, value) -> 1.

int_to_enum(_, Val) -> Val.

decode_pbnewmsg(Bytes) when is_binary(Bytes) ->
    decode(pbnewmsg, Bytes).

decode_pbid32(Bytes) when is_binary(Bytes) ->
    decode(pbid32, Bytes).

decode_pbfeedbackmsg(Bytes) when is_binary(Bytes) ->
    decode(pbfeedbackmsg, Bytes).

decode_pbchatlist(Bytes) when is_binary(Bytes) ->
    decode(pbchatlist, Bytes).

decode_pbchat(Bytes) when is_binary(Bytes) ->
    decode(pbchat, Bytes).

decode_pbprivate(Bytes) when is_binary(Bytes) ->
    decode(pbprivate, Bytes).

delimited_decode_pbprivate(Bytes) ->
    delimited_decode(pbprivate, Bytes).

delimited_decode_pbchat(Bytes) ->
    delimited_decode(pbchat, Bytes).

delimited_decode_pbchatlist(Bytes) ->
    delimited_decode(pbchatlist, Bytes).

delimited_decode_pbfeedbackmsg(Bytes) ->
    delimited_decode(pbfeedbackmsg, Bytes).

delimited_decode_pbid32(Bytes) ->
    delimited_decode(pbid32, Bytes).

delimited_decode_pbnewmsg(Bytes) ->
    delimited_decode(pbnewmsg, Bytes).

delimited_decode(Type, Bytes) when is_binary(Bytes) ->
    delimited_decode(Type, Bytes, []).

delimited_decode(_Type, <<>>, Acc) ->
    {lists:reverse(Acc), <<>>};
delimited_decode(Type, Bytes, Acc) ->
    try protobuffs:decode_varint(Bytes) of
      {Size, Rest} when size(Rest) < Size ->
	  {lists:reverse(Acc), Bytes};
      {Size, Rest} ->
	  <<MessageBytes:Size/binary, Rest2/binary>> = Rest,
	  Message = decode(Type, MessageBytes),
	  delimited_decode(Type, Rest2, [Message | Acc])
    catch
      _What:_Why -> {lists:reverse(Acc), Bytes}
    end.

decode(enummsg_values, 1) -> value1;
decode(pbprivate, Bytes) when is_binary(Bytes) ->
    Types = [{2, recv_list, pbchat, [is_record, repeated]},
	     {1, send_list, pbchat, [is_record, repeated]}],
    Defaults = [{1, send_list, []}, {2, recv_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbprivate, Decoded);
decode(pbchat, Bytes) when is_binary(Bytes) ->
    Types = [{13, gold_num, int32, []},
	     {12, league_id, int32, []}, {11, timestamp, int32, []},
	     {10, msg, string, []}, {9, vip, int32, []},
	     {8, career, int32, []}, {7, lv, int32, []},
	     {6, nickname, string, []}, {5, send_id, int64, []},
	     {4, recv_id, int64, []}, {3, id, int32, []},
	     {2, type, int32, []}, {1, id_n, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchat, Decoded);
decode(pbchatlist, Bytes) when is_binary(Bytes) ->
    Types = [{1, update_list, pbchat,
	      [is_record, repeated]}],
    Defaults = [{1, update_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchatlist, Decoded);
decode(pbfeedbackmsg, Bytes) when is_binary(Bytes) ->
    Types = [{2, content, string, []},
	     {1, title, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbfeedbackmsg, Decoded);
decode(pbid32, Bytes) when is_binary(Bytes) ->
    Types = [{1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbid32, Decoded);
decode(pbnewmsg, Bytes) when is_binary(Bytes) ->
    Types = [{1, send_list, int32, [repeated]}],
    Defaults = [{1, send_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbnewmsg, Decoded).

decode(<<>>, Types, Acc) ->
    reverse_repeated_fields(Acc, Types);
decode(Bytes, Types, Acc) ->
    {ok, FNum} = protobuffs:next_field_num(Bytes),
    case lists:keyfind(FNum, 1, Types) of
      {FNum, Name, Type, Opts} ->
	  {Value1, Rest1} = case lists:member(is_record, Opts) of
			      true ->
				  {{FNum, V}, R} = protobuffs:decode(Bytes,
								     bytes),
				  RecVal = decode(Type, V),
				  {RecVal, R};
			      false ->
				  case lists:member(repeated_packed, Opts) of
				    true ->
					{{FNum, V}, R} =
					    protobuffs:decode_packed(Bytes,
								     Type),
					{V, R};
				    false ->
					{{FNum, V}, R} =
					    protobuffs:decode(Bytes, Type),
					{unpack_value(V, Type), R}
				  end
			    end,
	  case lists:member(repeated, Opts) of
	    true ->
		case lists:keytake(FNum, 1, Acc) of
		  {value, {FNum, Name, List}, Acc1} ->
		      decode(Rest1, Types,
			     [{FNum, Name, [int_to_enum(Type, Value1) | List]}
			      | Acc1]);
		  false ->
		      decode(Rest1, Types,
			     [{FNum, Name, [int_to_enum(Type, Value1)]} | Acc])
		end;
	    false ->
		decode(Rest1, Types,
		       [{FNum, Name, int_to_enum(Type, Value1)} | Acc])
	  end;
      false ->
	  case lists:keyfind('$extensions', 2, Acc) of
	    {_, _, Dict} ->
		{{FNum, _V}, R} = protobuffs:decode(Bytes, bytes),
		Diff = size(Bytes) - size(R),
		<<V:Diff/binary, _/binary>> = Bytes,
		NewDict = dict:store(FNum, V, Dict),
		NewAcc = lists:keyreplace('$extensions', 2, Acc,
					  {false, '$extensions', NewDict}),
		decode(R, Types, NewAcc);
	    _ ->
		{ok, Skipped} = protobuffs:skip_next_field(Bytes),
		decode(Skipped, Types, Acc)
	  end
    end.

reverse_repeated_fields(FieldList, Types) ->
    [begin
       case lists:keyfind(FNum, 1, Types) of
	 {FNum, Name, _Type, Opts} ->
	     case lists:member(repeated, Opts) of
	       true -> {FNum, Name, lists:reverse(Value)};
	       _ -> Field
	     end;
	 _ -> Field
       end
     end
     || {FNum, Name, Value} = Field <- FieldList].

unpack_value(Binary, string) when is_binary(Binary) ->
    binary_to_list(Binary);
unpack_value(Value, _) -> Value.

to_record(pbprivate, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbprivate),
						   Record, Name, Val)
			  end,
			  #pbprivate{}, DecodedTuples),
    Record1;
to_record(pbchat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbchat),
						   Record, Name, Val)
			  end,
			  #pbchat{}, DecodedTuples),
    Record1;
to_record(pbchatlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbchatlist),
						   Record, Name, Val)
			  end,
			  #pbchatlist{}, DecodedTuples),
    Record1;
to_record(pbfeedbackmsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbfeedbackmsg),
						   Record, Name, Val)
			  end,
			  #pbfeedbackmsg{}, DecodedTuples),
    Record1;
to_record(pbid32, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbid32),
						   Record, Name, Val)
			  end,
			  #pbid32{}, DecodedTuples),
    Record1;
to_record(pbnewmsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbnewmsg),
						   Record, Name, Val)
			  end,
			  #pbnewmsg{}, DecodedTuples),
    Record1.

decode_extensions(Record) -> Record.

decode_extensions(_Types, [], Acc) ->
    dict:from_list(Acc);
decode_extensions(Types, [{Fnum, Bytes} | Tail], Acc) ->
    NewAcc = case lists:keyfind(Fnum, 1, Types) of
	       {Fnum, Name, Type, Opts} ->
		   {Value1, Rest1} = case lists:member(is_record, Opts) of
				       true ->
					   {{FNum, V}, R} =
					       protobuffs:decode(Bytes, bytes),
					   RecVal = decode(Type, V),
					   {RecVal, R};
				       false ->
					   case lists:member(repeated_packed,
							     Opts)
					       of
					     true ->
						 {{FNum, V}, R} =
						     protobuffs:decode_packed(Bytes,
									      Type),
						 {V, R};
					     false ->
						 {{FNum, V}, R} =
						     protobuffs:decode(Bytes,
								       Type),
						 {unpack_value(V, Type), R}
					   end
				     end,
		   case lists:member(repeated, Opts) of
		     true ->
			 case lists:keytake(FNum, 1, Acc) of
			   {value, {FNum, Name, List}, Acc1} ->
			       decode(Rest1, Types,
				      [{FNum, Name,
					lists:reverse([int_to_enum(Type, Value1)
						       | lists:reverse(List)])}
				       | Acc1]);
			   false ->
			       decode(Rest1, Types,
				      [{FNum, Name, [int_to_enum(Type, Value1)]}
				       | Acc])
			 end;
		     false ->
			 [{Fnum,
			   {optional, int_to_enum(Type, Value1), Type, Opts}}
			  | Acc]
		   end;
	       false -> [{Fnum, Bytes} | Acc]
	     end,
    decode_extensions(Types, Tail, NewAcc).

set_record_field(Fields, Record, '$extensions',
		 Value) ->
    Decodable = [],
    NewValue = decode_extensions(element(1, Record),
				 Decodable, dict:to_list(Value)),
    Index = list_index('$extensions', Fields),
    erlang:setelement(Index + 1, Record, NewValue);
set_record_field(Fields, Record, Field, Value) ->
    Index = list_index(Field, Fields),
    erlang:setelement(Index + 1, Record, Value).

list_index(Target, List) -> list_index(Target, List, 1).

list_index(Target, [Target | _], Index) -> Index;
list_index(Target, [_ | Tail], Index) ->
    list_index(Target, Tail, Index + 1);
list_index(_, [], _) -> -1.

extension_size(_) -> 0.

has_extension(_Record, _FieldName) -> false.

get_extension(_Record, _FieldName) -> undefined.

set_extension(Record, _, _) -> {error, Record}.


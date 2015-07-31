-module(protoc).
-export([start/0]).

%% start() ->
%%     protobuffs_compile:generate_source(
%%       File, [{imports_dir, ["./subgit/p02_proto/"]},
%%              {output_src_dir, "./src/protocol/"},
%%              {output_include_dir, "./include/"}]).

start() ->
    {ok, [[ImportDir]]} = init:get_argument(import_dir),
    io:format("ImportDir ~p~n", [ImportDir]),
    {ok, [[InlcudeDir]]} = init:get_argument(include_dir),
    io:format("InlcudeDir ~p~n", [InlcudeDir]),
    {ok, [[OutSrcDir]]} = init:get_argument(out_src),
    io:format("OutSrcDir ~p~n", [OutSrcDir]),
    ProtoFiles = get_proto_files(ImportDir),
    io:format("ProtoFiles ~p~n", [ProtoFiles]),
    [make_proto(File, ImportDir, InlcudeDir, OutSrcDir) || File <- ProtoFiles].

get_proto_files(Dir) ->
    io:format("Dir ~p~n", [Dir]),
    case file:list_dir(Dir) of
        {error, Reason} ->
            throw({get_proto_files_error, Reason});
        {ok, FileList} ->
            lists:foldl(fun(File, AccFileList) ->
                                case filename:extension(File) of
                                    ".proto" ->
                                        [Dir ++ File|AccFileList];
                                    _ ->
                                        AccFileList
                                end
                        end, [], FileList)
    end.

make_proto(File, ImportDir, InlcudeDir, OutSrcDir) ->
    protobuffs_compile:generate_source(
      File, [{imports_dir, [ImportDir]},
             {output_src_dir, OutSrcDir},
             {output_include_dir, InlcudeDir}]).

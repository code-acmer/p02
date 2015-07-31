REBAR = rebar
DIALYZER = dialyzer

GENDIR_INC = ./include/
GENDIR_SRC = ./src/protocol/
PROTO_PATH = ./subgit/p02_proto/

PROTOC = ./sh/protoc-erl

OS_NAME := $(shell uname -s)
OSType := $(findstring  Linux,$(OS_NAME))

DIALYZER_WARNINGS = -Wunmatched_returns -Werror_handling \
                    -Wrace_conditions -Wunderspecs

.PHONY: get-deps proto compile test clean build-plt dialyze

compile:
	@$(REBAR) compile

src   = $(wildcard $(PROTO_PATH)*.proto)
pfile = $(notdir $(src))
obj   = $(patsubst %.proto, $(GENDIR_INC)/%_pb.hrl, $(pfile))
proto : $(src)
    %.proto: $(src)
	$(PROTOC) $<

infos   = $(wildcard $(GENDIR_INC)define_info_*.hrl)
ifeq (Linux, $(OSType))
	make_info_cmd := ./sh/define_info_to_db
else
	make_info_cmd := script\info_to_db.bat     
endif
info: $(infos)
	$(make_info_cmd)

datas   = $(wildcard src/data/data_*.erl)
ifeq (Linux, $(OSType))
	generate_data_cmd := ./sh/data_generate
else
	generate_data_cmd := script\data_generate.bat 
endif
data : $(datas)
	$(generate_data_cmd)
    
test: compile
	@$(REBAR) eunit skip_deps=true -v

qc: compile
	@$(REBAR) qc skip_deps=true

clean:
	-rm $(GENDIR_INC)/pb_*.hrl $(GENDIR_SRC)/pb_*.erl
	@$(REBAR) clean

get-deps:
	@$(REBAR) get-deps

build-plt:
	@$(DIALYZER) --build_plt --output_plt .dialyzer_plt \
	    --apps kernel stdlib

dialyze: compile
	@$(DIALYZER) --src src --plt .dialyzer_plt $(DIALYZER_WARNINGS) | \
	    fgrep -vf .dialyzer-ignore-warnings

generate:
	./priv/generate_server_protocol.sh
	./priv/generate_client_protocol.sh

console:
	rebar compile generate
	./rel/openpoker/bin/openpoker console


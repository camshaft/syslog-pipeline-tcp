REBAR = ./rebar
APP = syslog_drain

default: compile

all: deps compile dev/sync

compile:
	$(REBAR) compile

deps:
	$(REBAR) get-deps

clean:
	$(REBAR) clean

dev:
	mkdir dev

dev/sync: dev
	git clone https://github.com/rustyio/sync.git dev/sync
	cd dev/sync && make && cd -

devstart: dev/sync
	@dev/start

distclean: clean 
	$(REBAR) delete-deps

test:
	$(REBAR) skip_deps=true eunit

docs: deps
	$(REBAR) skip_deps=true doc

dialyzer: compile
	@dialyzer -Wno_return -c apps/$(APP)/ebin


.PHONY: all deps test
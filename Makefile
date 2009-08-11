ERL=erl

all: src

# TODO: this is where custom include paths can be defined using -I
src: FORCE
	@$(ERL) -pa ebin -make

check: src
	@dialyzer -q -r . -I include/ \
		-I $(ERL_LIBS)/test_server*/include/ \
		-I $(ERL_LIBS)/common_test*/include/

test: test.spec src FORCE
	@run_test -pa $(PWD)/ebin -spec test.spec
	@rm variables-ct*

test.spec: test.spec.in
	@cat test.spec.in | sed -e "s,@PATH@,$(PWD)," > $(PWD)/test.spec

clean:
	rm -f ebin/*.beam
	rm -f test/*.beam
	rm test.spec

doc: FORCE
	@erl -noshell -run edoc_run application routy '"."' '[{new, true}]'

FORCE:

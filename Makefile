.PHONY: all
all: static/test/test

static/gen/gen: $(shell find static/gen/*.pony)
	cd static/gen && ponyc --debug

static/ast.pony: static/gen/gen
	static/gen/gen > $@

static/test/test: static/ast.pony $(shell find static/*.pony) $(shell find static/test/*.pony)
	cd static/test && ponyc --debug

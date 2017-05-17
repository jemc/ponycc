.PHONY: all
all: static/test/test

static/gen/gen: $(shell find static/gen/*.pony)
	stable env ponyc --debug -o static/gen static/gen

static/ast.pony: static/gen/gen
	static/gen/gen ast > $@

static/parser/parser.pony: static/gen/gen
	static/gen/gen parser > $@

static/parser/parser: static/parser/parser.pony $(shell find static/parser/*.pony)
	stable env ponyc --debug -o static/parser static/parser

static/test/test: static/ast.pony static/parser/parser.pony $(shell find static/*.pony) $(shell find static/test/*.pony) $(shell find static/parser/*.pony)
	stable env ponyc --debug -o static/test static/test

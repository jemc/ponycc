.PHONY: all
all: ast/test/test

ast/gen/gen: $(shell find ast/gen/*.pony)
	stable env ponyc --debug -o ast/gen ast/gen

ast/ast.pony: ast/gen/gen
	ast/gen/gen ast > $@

ast/parser/parser.pony: ast/gen/gen
	ast/gen/gen parser > $@

ast/parser/parser: ast/parser/parser.pony \
	$(shell find ast/parser/*.pony)
	stable env ponyc --debug -o ast/parser ast/parser

ast/test/test: ast/ast.pony ast/parser/parser.pony \
	$(shell find ast/*.pony) \
	$(shell find ast/test/*.pony) \
	$(shell find ast/parser/*.pony)
	stable env ponyc --debug -o ast/test ast/test

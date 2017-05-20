.PHONY: all
all: ast/test/test

ast/gen/gen: $(shell find ast/gen/*.pony)
	stable env ponyc --debug -o ast/gen ast/gen

ast/ast.pony: ast/gen/gen
	ast/gen/gen ast > $@

parser/parser.pony: ast/gen/gen
	ast/gen/gen parser > $@

parser/parser: parser/parser.pony \
	$(shell find parser/*.pony)
	stable env ponyc --debug -o parser parser

ast/test/test: ast/ast.pony parser/parser.pony \
	$(shell find ast/*.pony) \
	$(shell find ast/test/*.pony) \
	$(shell find parser/*.pony)
	stable env ponyc --debug -o ast/test ast/test

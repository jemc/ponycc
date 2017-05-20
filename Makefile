.PHONY: all
all: test/test

clean:
	rm -f ast/gen/gen
	rm -f ast/ast.pony
	rm -f parser/_parser.pony
	rm -f test/test

ast/gen/gen: $(shell find ast/gen/*.pony)
	stable env ponyc --debug -o ast/gen ast/gen

ast/ast.pony: ast/gen/gen
	ast/gen/gen ast > $@

parser/_parser.pony: ast/gen/gen
	ast/gen/gen parser > $@

test/test: ast/ast.pony parser/_parser.pony \
	$(shell find ast/*.pony) \
	$(shell find parser/*.pony) \
	$(shell find test/*.pony)
	stable env ponyc --debug -o test test

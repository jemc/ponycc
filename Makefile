.PHONY: all
all: test/test

clean:
	rm -f ast/gen/gen
	rm -f ast/ast.pony
	rm -f ast/parse/_parser.pony
	rm -f test/test

ast/gen/gen: $(shell find ast/gen/*.pony)
	stable env ponyc --debug -o ast/gen ast/gen

ast/ast.pony: ast/gen/gen
	ast/gen/gen ast > $@

ast/parse/_parser.pony: ast/gen/gen
	ast/gen/gen parser > $@

test/test: ast/ast.pony ast/parse/_parser.pony \
	$(shell find ast/*.pony) \
	$(shell find ast/parse/*.pony) \
	$(shell find ast/print/*.pony) \
	$(shell find test/*.pony)
	stable env ponyc --debug -o test test

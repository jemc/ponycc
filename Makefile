.PHONY: all test
all: ponycc/test/test

test: ponycc/test/test
	ponycc/test/test

clean:
	rm -f ponycc/ast/gen/gen
	rm -f ponycc/ast/ast.pony
	rm -f ponycc/ast/parse/_parser.pony
	rm -f ponycc/test/test

ponycc/ast/gen/gen: $(shell find ponycc/ast/gen/*.pony)
	stable env ponyc --debug -o ponycc/ast/gen ponycc/ast/gen

ponycc/ast/ast.pony: ponycc/ast/gen/gen
	ponycc/ast/gen/gen ast > $@

ponycc/ast/parse/_parser.pony: ponycc/ast/gen/gen
	ponycc/ast/gen/gen parser > $@

ponycc/test/test: ponycc/ast/ast.pony ponycc/ast/parse/_parser.pony \
	$(shell find ponycc/ast/*.pony) \
	$(shell find ponycc/ast/parse/*.pony) \
	$(shell find ponycc/ast/print/*.pony) \
	$(shell find ponycc/frame/*.pony) \
	$(shell find ponycc/pass/syntax/*.pony) \
	$(shell find ponycc/test/*.pony)
	stable env ponyc --debug -o ponycc/test ponycc/test

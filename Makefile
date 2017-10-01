.PHONY: all test
all: ponycc/test/test

test: ponycc/test/test
	ponycc/test/test

clean:
	rm -f ponycc/ast/gen/gen
	rm -f ponycc/ast/ast.pony
	rm -f ponycc/pass/parse/_parser.pony
	rm -f ponycc/test/test

ponycc/ast/gen/gen: $(shell ls ponycc/ast/gen/*.pony)
	stable env ponyc --debug -o ponycc/ast/gen ponycc/ast/gen

ponycc/ast/ast.pony: ponycc/ast/gen/gen
	ponycc/ast/gen/gen ast > $@

ponycc/pass/parse/_parser.pony: ponycc/ast/gen/gen
	ponycc/ast/gen/gen parser > $@

ponycc/test/test: \
	ponycc/ast/ast.pony \
	ponycc/pass/parse/_parser.pony \
	$(shell sh -c "find ponycc | grep .pony | grep -v fixtures") \

	stable env ponyc --debug -o ponycc/test ponycc/test

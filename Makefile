src?=1
dest?=2

build:
	@echo "\n==== COMPILING ====\n"
	ocamlbuild ftest.native

format:
	ocp-indent --inplace src/*

edit:
	code . -n

test: build
	@echo "\n==== EXECUTING ====\n"
	./ftest.native

clean:
	-rm -rf _build/
	-rm ftest.native

svg:
	dot -Tsvg outfile > graph.svg
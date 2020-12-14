src?=1
dest?=2
hosting?=hostings/hosting1
outfile?=

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
	-rm hosting.native

svg:
	dot -Tsvg outfile > graph.svg

hosting:
	@echo "\n==== COMPILING ====\n"
	ocamlbuild hosting.native
	@echo "\n==== EXECUTING ====\n"
	./hosting.native ${hosting} ${outfile}
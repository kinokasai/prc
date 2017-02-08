all:
	(cd src/transpiler; ocamlbuild -use-menhir -use-ocamlfind -pkg batteries -pkg core -tag thread main.native)
	cp -L src/transpiler/main.native sdt

clean:
	(cd src/transpiler; ocamlbuild -clean)
	rm sdt

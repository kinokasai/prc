all:
	(cd src/transpiler; ocamlbuild -use-menhir -use-ocamlfind -pkg batteries -pkg core -tag thread -tag debug main.byte)
	cp -L src/transpiler/main.byte sdt

clean:
	(cd src/transpiler; ocamlbuild -clean)
	rm sdt

check:
	echo "done."

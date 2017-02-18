all: runtime
	(cd src/transpiler; ocamlbuild -use-menhir -use-ocamlfind -pkg batteries -pkg core -tag thread -tag debug -tag explain  main.byte)
	cp -L src/transpiler/main.byte sdt

runtime:
	cat src/runtime/op.js src/runtime/runtime.js > runtime.js

run:
	mkdir -p out
	./sdt tests/dig2.sol > out/out.js
	cp src/runtime/op.js out/

clean:
	(cd src/transpiler; ocamlbuild -clean)
	rm -f sdt runtime.js

check:
	echo "done."

all: runtime
	(cd src/transpiler; ocamlbuild -use-menhir -use-ocamlfind -pkg batteries -pkg core\
	 -pkg ocamlgraph -tag thread -tag debug -tag explain -r main.byte)
	cp -L src/transpiler/main.byte sdt

runtime:
	cat src/runtime/op.js src/runtime/runtime.js > runtime.js

game: runtime
	mkdir -p ${name}
	mv runtime.js ${name}
	cp src/runtime/engine.js ${name}
	cp src/runtime/game.js ${name}/${name}.js
	cp src/runtime/game.html ${name}/${name}.html

run:
	mkdir -p out
	./sdt tests/dig2.sol > out/out.js
	cp src/runtime/op.js out/

clean:
	(cd src/transpiler; ocamlbuild -clean)
	rm -f sdt runtime.js doc/full_report.md doc/report.pdf

check: all
	bash tests/test.sh

report:
	(cd doc;\
	bash include_md.sh report.md > full_report.md;\
	pandoc full_report.md -o report.pdf;\
	echo "Done.")
all: runtime
	(cd src/transpiler; ocamlbuild -use-menhir -use-ocamlfind -pkg batteries -pkg core\
	 -pkg ocamlgraph -pkg flow_parser -tag thread -tag debug -tag explain -r main.byte)
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

doc: report

report:
	(cd doc;\
	bash include_md.sh report.md > full_report.md;\
	./side_code.sh full_report.md;\
	pandoc -t json out.md | python ./tex_templates/underline.py | \
	pandoc -f json -o report.pdf --latex-engine=xelatex --toc \
	--template=tex_templates/template.latex &&\
	echo "Done.")

slides:
	(cd doc;\
	bash include_md.sh slides.md > full_slides.md;\
	./side_code.sh full_slides.md;\
	pandoc -t json out.md | python ./tex_templates/filter.py | \
  pandoc -f json -o slides.pdf -t beamer --latex-engine=xelatex \
	--template=tex_templates/slide_template.tex --listings)
# pandoc --filter tex_templates/filter.py -s out.md -t beamer -o slides.pdf --latex-engine=xelatex \
# --template=tex_templates/slide_template.tex --listings &&\
	echo "Done.")
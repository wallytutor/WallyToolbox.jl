all:
	pdflatex main
	makeindex main.idx -s Parts/styleind.ist
	biber main
	biber main
	pdflatex main
	pdflatex main

clean:
	rm -rf main.aux
	rm -rf main.bbl
	rm -rf main.bcf
	rm -rf main.blg
	rm -rf main.fdb_latexmk
	rm -rf main.fls
	rm -rf main.idx
	rm -rf main.ilg
	rm -rf main.ind
	rm -rf main.log
	rm -rf main.ptc
	rm -rf main.run.xml
	rm -rf main.synctex.gz
	rm -rf main.toc

dist-clean: clean
	rm -rf main.pdf

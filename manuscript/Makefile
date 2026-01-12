all: document-draft.pdf document-pub.pdf

draft: document-draft.pdf

pub: document-pub.pdf

document-draft.pdf: document.tex references.bib preamble.tex appendix-statistical-methods.tex appendix-data-preprocessing.tex
	pdflatex -jobname=document-draft "\def\draftmode{}\input{document.tex}"
	bibtex document-draft
	pdflatex -jobname=document-draft "\def\draftmode{}\input{document.tex}"
	pdflatex -jobname=document-draft "\def\draftmode{}\input{document.tex}"

document-pub.pdf: document.tex references.bib preamble.tex appendix-statistical-methods.tex appendix-data-preprocessing.tex
	pdflatex -jobname=document-pub "\def\pubmode{}\input{document.tex}"
	bibtex document-pub
	pdflatex -jobname=document-pub "\def\pubmode{}\input{document.tex}"
	pdflatex -jobname=document-pub "\def\pubmode{}\input{document.tex}"

clean:
	rm -f *.aux *.bbl *.blg *.log *.out *.synctex.gz *.fls *.fdb_latexmk *.toc *.lof *.lot
	rm -f document-draft.pdf document-pub.pdf document.pdf

.PHONY: all draft pub clean
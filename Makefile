.DEFAULT_GOAL := pdf

define INFORMATION
Makefile for automated typography using pandoc.
Version 1.2                       

Usage:
make prepare    first time use, setting the directories 
make html       generate a web version             
make pdf        generate a PDF file  			  
make docx       generate a Docx file 			  
make tex        generate a Latex file 			  
make beamer     generate a beamer presentation 		  
make all        generate all files              
make update     update the makefile to last version      
make            will fallback to PDF               

It implies some directories in the filesystem: source, output and style
It also implies that the bibliography will be defined via the yaml	  
Depends on pandoc-citeproc and pandoc-crossref						  
endef

export INFORMATION

MD = $(wildcard source/*.md)
PDF = output/$(notdir $(CURDIR)).pdf
TEX = output/$(notdir $(CURDIR)).tex
DOCX = output/$(notdir $(CURDIR)).docx
HTML5 = output/$(notdir $(CURDIR)).html
EPUB = output/$(notdir $(CURDIR)).epub
BEAMER = output/$(notdir $(CURDIR))-presentation.pdf

FILFILES = $(wildcard style/*.py)
FILTERS := $(foreach FILFILES, $(FILFILES), --filter $(FILFILES))
TEXFLAGS = -F pandoc-crossref -F pandoc-citeproc --latex-engine=xelatex

ifneq ("$(wildcard style/template.tex)","")
	TEXTEMPLATE := "--template=style/template.tex"
endif
ifneq ("$(wildcard style/reference.docx)","")
	DOCXTEMPLATE := "--reference-docx=style/reference.docx"
endif
ifneq ("$(wildcard style/style.css)","")
	CSS := "--include-in-header=style/style.css"
endif

help:
	@echo "$$INFORMATION"

all : tex docx html5 epub pdf


pdf:$(PDF)
$(PDF): $(MD)
	pandoc -o $@ source/*.md $(TEXTEMPLATE) $(TEXFLAGS) $(FILTERS) 2>output/pdf.log
	if [[ "$OSTYPE" == "darwin" ]]; then open $@; else xdg-open $@;fi

tex: $(TEX)
$(TEX): $(MD)
	pandoc -o $@ source/*.md $(TEXFLAGS) 2>output/tex.log
	if [[ "$OSTYPE" == "darwin" ]]; then open $@; else xdg-open $@;fi

docx: $(DOCX)
$(DOCX): $(MD)
	pandoc -o $@ source/*.md $(TEXFLAGS) $(DOCXTEMPLATE) --toc 2>output/docx.log
	if [[ "$OSTYPE" == "darwin" ]]; then open $@; else xdg-open $@;fi

html5: $(HTML5)
$(HTML5): $(MD)
	pandoc -o $@ source/*.md $(CSS) $(TEXFLAGS) --toc -t html5 2>output/html5.log
	if [[ "$OSTYPE" == "darwin" ]]; then open $@; else xdg-open $@;fi

epub: $(EPUB)
$(EPUB): $(MD)
	pandoc -o $@ source/*.md $(TEXFLAGS) --toc 2>output/epub.log
	if [[ "$OSTYPE" == "darwin" ]]; then open $@; else xdg-open $@;fi

beamer: $(BEAMER)
$(BEAMER): $(MD)
	pandoc -o $@ source/*.md $(TEXFLAGS) -t beamer 2>output/beamer.log
	if [[ "$OSTYPE" == "darwin" ]]; then open $@; else xdg-open $@;fi

prepare:
	command -v pandoc >/dev/null 2>&1 || { echo "I require pandoc but it's not installed.  Aborting." >&2; exit 1; }
	command -v pandoc-crossref >/dev/null 2>&1 || { echo "I require pandoc-crossref but it's not installed.  Aborting." >&2; exit 1; }
	command -v pandoc-citeproc >/dev/null 2>&1 || { echo "I require pandoc-citeproc but it's not installed.  Aborting." >&2; exit 1; }
	mkdir "output"
	mkdir "source"
	mkdir "style"

prepare-latex:
	@echo "This will install a latex minimal installation, but tlmgr can be used to fill in the packages"
	wget \
	--continue \
	--directory-prefix /tmp \
	http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

	tar \
	--extract \
	--gunzip \
	--directory /tmp \
	--file /tmp/install-tl-unx.tar.gz

	/tmp/install-tl-*/install-tl \
	-repository http://mirror.ctan.org/systems/texlive/tlnet \
	-no-gui \
	-scheme scheme-minimal
	@echo "It's done. Use <tlmgr install PACKAGENAME> to install the packages you need."

update:
	wget http://tiny.cc/mighty_make -O Makefile

clean:
	rm -f "output/" *.md *.html *.pdf *.tex *.docx *.epub

.PHONY: help prepare update beamer clean

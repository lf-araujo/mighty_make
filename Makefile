.DEFAULT_GOAL := pdf


define INFORMATION
Makefile for automated typography using pandoc.
Version 1.7                       

Usage:
make prepare                    first time use, setting the directories
make prepare-latex              create a minimal latex install
make dependencies               tries to fetch all included packages in the project and install them
make html                       generate a web version
make pdf                        generate a PDF file
make docx                       generate a Docx file 			  
make tex                        generate a Latex file
make beamer                     generate a beamer presentation
make all                        generate all files
make fetch THEME=<github addrs> fetch the theme for a template online
make update                     update the makefile to last version
make update-testing-branch      update to latest testing version            
make                            will fallback to PDF

It implies some directories in the filesystem: source, output and style
It also implies that the bibliography file will be defined via the yaml	  
Depends on pandoc-citeproc and pandoc-crossref						  
endef

export INFORMATION

SHELL = /bin/bash


OPENWITH := "open"

ifneq ("$(wildcard style/Makefile)","")
	include style/Makefile
else ifneq ("$(wildcard style/template.tex)","")


help:
	@echo "$$INFORMATION"

all : tex docx html5 epub pdf


pdf: $(PDF)
$(PDF): $(MD)
	pandoc -o $@ source/*.md $(TEXTEMPLATE) $(TEXFLAGS) $(FILTERS) 2>output/pdf.log
	$(OPENWITH)  $@

tex: $(TEX)
$(TEX): $(MD)
	pandoc -o $@ source/*.md $(TEXFLAGS) 2>output/tex.log
	$(OPENWITH)  $@

docx: $(DOCX)
$(DOCX): $(MD)
	pandoc -o $@ source/*.md $(TEXFLAGS) $(DOCXTEMPLATE) --toc 2>output/docx.log
	$(OPENWITH)  $@

html5: $(HTML5)
$(HTML5): $(MD)
	pandoc -o $@ source/*.md $(CSS) $(TEXFLAGS) --toc -t html5 2>output/html5.log
	$(OPENWITH)  $@

epub: $(EPUB)
$(EPUB): $(MD)
	pandoc -o $@ source/*.md $(TEXFLAGS) --toc 2>output/epub.log
	$(OPENWITH)  $@

beamer: $(BEAMER)
$(BEAMER): $(MD)
	pandoc -o $@ source/*.md $(TEXFLAGS) -t beamer 2>output/beamer.log
	$(OPENWITH)  $@

prepare:
	command -v xetex >/dev/null 2>&1 || { echo "Latex is not installed.  Please run make prepare-latex for a minimal installation." >&2; exit 1; }
	command -v pandoc >/dev/null 2>&1 || { echo "I require pandoc but it's not installed.  Aborting." >&2; exit 1; }
	command -v pandoc-crossref >/dev/null 2>&1 || { echo "I require pandoc-crossref but it's not installed.  Aborting." >&2; exit 1; }
	command -v pandoc-citeproc >/dev/null 2>&1 || { echo "I require pandoc-citeproc but it's not installed.  Aborting." >&2; exit 1; }
	command -v svn >/dev/null 2>&1 || { echo "I require svn but it's not installed.  Aborting." >&2; exit 1; }
	mkdir "output"
	mkdir "source"
	mkdir "style"
	touch source/00-metadata.md

	$(OPENWITH) source/00-metadata.md

fetch:
	command -v svn >/dev/null 2>&1 || { echo "I require svn but it's not installed.  Aborting." >&2; exit 1; }
	@echo "Trying to fetch the style directory from this github repo"
	svn export $(THEME).git/trunk/style

prepare-latex:
	@echo "This will install a latex minimal installation, but tlmgr can be used to fill in the packages."
	@echo "To automatically perform dependency installations run make dependencies in the project directory."
	@echo "Note that installing a latex distribution takes some trial and error, "
	@echo "the approach I used here is the one that creates the smallest distribution."
	@echo "Ubuntu's latex distribution can be up to 2.8GB, whereas with this method it only takes around 1GB."
	wget \
	--continue \
	--directory-prefix /tmp \
	http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

	tar \
	--extract \
	--gunzip \
	--directory /tmp \
	--file /tmp/install-tl-unx.tar.gz

	pkexec /tmp/install-tl-*/install-tl \
	-repository http://mirror.ctan.org/systems/texlive/tlnet \
	-no-gui \
	-scheme scheme-minimal
	@echo "It's done. Use <tlmgr install PACKAGENAME> to install the packages you need."

dependencies:
	pkexec /opt/texbin/tlmgr install $$(cat source/*.md | sed -n '$(PACKAGES)' | paste -sd ' ' -) $$(cat style/*.tex | sed -n '$(PACKAGES)' | paste -sd ' ' -)

update:
	wget http://tiny.cc/mighty_make -O Makefile

update-testing-branch:
	wget http://tiny.cc/mighty_test -O Makefile

clean:
	rm -f "output/" *.md *.html *.pdf *.tex *.docx *.epub

.PHONY: help prepare update beamer clean

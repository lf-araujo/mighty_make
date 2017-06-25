.DEFAULT_GOAL := pdf

INPUTDIR=$(CURDIR)/source
OUTPUTDIR=$(CURDIR)/output
STYLEDIR=$(CURDIR)/style
NAME = $(notdir $(shell basename "$(CURDIR)"))

FILFILES = $(wildcard style/*.py)

FILTER := $(foreach FILFILES, $(FILFILES), --filter $(FILFILES))
TEXFLAGS = --filter pandoc-crossref --filter pandoc-citeproc $(FILTER) --latex-engine=xelatex

ifeq ($(shell test -e "$(STYLEDIR)/template.tex" && echo -n yes),yes)
	TEXTEMPLATE = "--template=$(STYLEDIR)/template.tex"
endif

ifeq ($(shell test -e "$(STYLEDIR)/reference.docx" && echo -n yes),yes)
	DOCXTEMPLATE = "--reference-docx=$(STYLEDIR)/reference.docx"
endif

help:

	@echo ' 																	  '
	@echo 'Makefile for automated typography using pandoc.                         '
	@echo 'Version 1.0                        '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make prepare    first time use, setting the directories     '
	@echo '   make html       generate a web version             '
	@echo '   make pdf        generate a PDF file  			  '
	@echo '   make docx       generate a Docx file 			  '
	@echo '   make tex        generate a Latex file 			  '
	@echo '   make beamer     generate a beamer presentation 			  '
	@echo '   make all        generate all files                 '
	@echo '   make update     update the makefile to last version       '
	@echo '   make            will fallback to PDF               '
	@echo ' 																	  '
	@echo 'It implies some directories in the filesystem: source, output and style'
	@echo 'It also implies that the bibliography will be defined via the yaml	  '
	@echo ' 																	  '
	@echo 'Depends on pandoc-citeproc and pandoc-crossref						  '
	@echo 'Get local templates with: pandoc -D latex/html/etc	         		  '
	@echo ' 																	  '



all : tex docx html epub pdf


pdf:
	pandoc "$(INPUTDIR)/"*.md \
	-o "$(OUTPUTDIR)/$(NAME).pdf" \
	$(TEXTEMPLATE) \
	$(TEXFLAGS) 2>pandoc.log
	xdg-open "$(OUTPUTDIR)/$(NAME).pdf"

tex:
	pandoc "$(INPUTDIR)"/*.md \
	--filter pandoc-crossref \
	--filter pandoc-citeproc \
	-o "$(OUTPUTDIR)/$(NAME).tex" \
	--latex-engine=xelatex

docx:
	pandoc "$(INPUTDIR)"/*.md \
	--filter pandoc-crossref \
	--filter pandoc-citeproc \
	$(DOCXTEMPLATE) \
	--toc \
	-o "$(OUTPUTDIR)/$(NAME).docx"

html:
	pandoc "$(INPUTDIR)"/*.md \
	-o "$(OUTPUTDIR)/$(NAME).html" \
	--include-in-header="$(STYLEDIR)/style.css" \
	-t html5 \
	--toc \
	--standalone \
	--filter pandoc-crossref \
	--filter pandoc-citeproc \
	--number-sections
	rm -rf "$(OUTPUTDIR)/source"
	mkdir "$(OUTPUTDIR)/source"
	cp -r "$(INPUTDIR)/figures" "$(OUTPUTDIR)/source/figures"

epub:
	pandoc "$(INPUTDIR)"/*.md \
	-o "$(OUTPUTDIR)/$(NAME).epub" \
	--toc \
	--standalone \
	--filter pandoc-crossref \
	--filter pandoc-citeproc
	rm -rf "$(OUTPUTDIR)/source"
	mkdir "$(OUTPUTDIR)/source"
	cp -r "$(INPUTDIR)/figures" "$(OUTPUTDIR)/source/figures"

beamer:
	pandoc "$(INPUTDIR)/"*.md \
	-t beamer \
	-o "$(OUTPUTDIR)/$(NAME).pdf" \
	$(TEXTEMPLATE) \
	$(TEXFLAGS) 2>pandoc.log
	xdg-open "$(OUTPUTDIR)/$(NAME).pdf"

prepare:
	mkdir "output"
	mkdir "source"
	mkdir "style"

update:
	wget http://tiny.cc/mighty_make -O Makefile

clean:
	rm -f "$(OUTPUTDIR)/" *.md *.html *.pdf *.tex *.docx

.PHONY: help pdf docx html tex clean

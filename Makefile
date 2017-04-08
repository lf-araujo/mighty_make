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

help:

	@echo ' 																	  '
	@echo 'Makefile for typography with pandoc                                    '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make prepare            first time use, setting the directories     '
	@echo '   make html                        generate a web version             '
	@echo '   make pdf                         generate a PDF file  			  '
	@echo '   make docx                        generate a Docx file 			  '
	@echo '   make tex                         generate a Latex file 			  '
	@echo '   make all                         generate all files                 '
	@echo '   make                             will fallback to PDF               '
	@echo ' 																	  '
	@echo 'It implies some directories in the filesystem: source, output and style'
	@echo 'It also implies that the bibliography will be defined via the yaml	  '
	@echo ' 																	  '
	@echo 'Depends on pandoc-citeproc and pandoc-crossref						  '
	@echo 'Get local templates with: pandoc -D latex/html/etc	         		  '
	@echo ' 																	  '



all : pdf tex docx html epub


pdf:
	pandoc "$(INPUTDIR)/"*.md \
	-o "$(OUTPUTDIR)/$(NAME).pdf" \
	$(TEXTEMPLATE) \
	$(TEXFLAGS)
	xdg-open "$(OUTPUTDIR)/$(NAME).pdf"

tex:
	pandoc "$(INPUTDIR)"/*.md \
	--filter pandoc-crossref \
	--filter pandoc-citeproc \
	-o "$(OUTPUTDIR)/$(NAME).tex" \
	--latex-engine=xelatex
	xdg-open "$(OUTPUTDIR)/$(NAME).tex"

docx:
	pandoc "$(INPUTDIR)"/*.md \
	-o "$(OUTPUTDIR)/$(NAME).docx" \
	--filter pandoc-crossref \
	--filter pandoc-citeproc \
	--toc
	xdg-open "$(OUTPUTDIR)/$(NAME).docx"

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
	xdg-open "$(OUTPUTDIR)/$(NAME).html"

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
	xdg-open "$(OUTPUTDIR)/$(NAME).epub"

prepare:
	mkdir "output"
	mkdir "source"
	mkdir "style"

clean:
	rm -f "$(OUTPUTDIR)/" *.md *.html *.pdf *.tex *.docx

.PHONY: help pdf docx html tex clean

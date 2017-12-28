# Mighty Make - Standardized Document Building

## Todos
- [ ] Make an output md file with citations added to the yaml header, so to facilitate sharing the document with coworkers
- [ ] Windows testing
- [ ] Lose the subversion dependence

## Uses

It reduces the time for text editing using LaTeX. It all starts with downloading the Makefile with:

```bash
wget http://tiny.cc/mighty_make -O Makefile
```

Now, some themes are baked in:

### Scientific report

```make
make fetch THEME="https://github.com/lf-araujo/tuftish-pandoc"
```

Editing the source in the `/source` directory will produce documents similar to:

![](https://lf-araujo.github.io/images/Captura%20de%20tela%20de%202017-12-26%2020-26-08.png)

![]( lf-araujo.github.io/images/Captura de tela de 2017-12-26 20-26-35.png )

[More here](https://lf-araujo.github.io/2017/11/10/tuftish.html)

### A curriculum vitae

```make
make fetch THEME="https://github.com/lf-araujo/yapcvt"
```

Editing the source in the `/source` directory will produce documents similar to:

![]( lf-araujo.github.io/images/Captura de tela de 2017-12-26 20-34-18.png )


[More here](https://lf-araujo.github.io/2016/09/24/Yet-Another-CV.html)

### A letter with and without letterhead


```bash
make fetch THEME="https://github.com/lf-araujo/pandoc-letter"
```

Editing the source in the `/source` directory will produce documents similar to:

![]( lf-araujo.github.io/images/Captura de tela de 2017-12-26 20-18-27.png )

[More here](https://lf-araujo.github.io/2017/04/08/zletter.html)

## Abstract

Mighty make is a building system for medium or large document projects (books, thesis, essays, papers). It is a makefile that considers a certain folder structure and passes information in these folders on to [pandoc](www.pandoc.org), which proceeds with the heavy lifting.  It follows pandoc-scholar designs loosely and has reached a stable state. I will slowly reduce pushes to this project, as it already does most of what I wanted. There is some functionality for Windows systems, however untested. Also, there is an extension framework, where one can pull themes from github.  

## Introduction

The amount of time I spent correcting small styling changes introduced by the text editors from my colleagues (while collaborating), make me try to tackle the problem. This is a known problem from current text editors, where I can edit in windows, adding custom styles to conform to a journal's requirement, but after passing it along to other authors, the text would inevitably come back with styling problems. After years, I gave up and passed the text without any alterations to the standard Word styles, but even then some styling would be altered given other authors modifications. The simple act of opening a Windows made document in a MacOS machine (both with the latest Word) would introduce styling problems.

It is obviously not reasonable to expect that one person could alone tackle the problem. This is where open source came into scene. I noticed that by connecting open source projects as a recipe, would allow me generate much nicer texts than Word could ever produce. In the beginning I used bash scripts (see [here](https://lf-araujo.github.io/)), but came to discover a much nicer (however harder to code) approach using an old technology called [GNUMake](gnumake.org). 

What I wanted was to separate style from the body of text. I did that by simply creating a standard directory structure, so whenever a certain style would be required, all I needed to do is to add the style files into the `/style` directory and the makefile would incorporate these into the final document. This is what `mighty_make` does.

## Dependencies

The wall I faced during the process of creating `mighty_make` regarded LaTeX rather complicated package management. The coolest mathematician, will still spend a lot of time setting the style of his paper with LaTeX, there is simply no way around this fact. How could I possibly convince my colleagues that this is a reasonable way of writing, but that would require the same amount of time as fixing the eventual Word style hindrances?

In order to minimize the problem, I tried to bake a method of installing latex and dependencies for the themes using makefile targets (specific commands). This caused mighty_make to depend on more software than I wanted it to. The dependencies are:

1. git
2. subversion
3. pandoc
4. pandoc-citeproc
5. pandoc-crossref

One can install them all in any debian system using:

```bash
sudo apt install git subversion cabal-install
cabal install pandoc pandoc-citeproc pandoc-crossref
```

### Fonts

Fonts are not dependencies *per se*, as one can choose any that suits the needs. But remember to change the settings in the `yaml` block of the source file.


## Using it

Start with: 

```
wget http://tiny.cc/mighty_make -O Makefile
```

You can find all instructions with the command `make help`. This is the output it produces:


```
Makefile for automated typography using pandoc.
Version 1.6                       

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
```

Now prepare the file system to start the project with the command `make prepare`. This will create three directories (and open your standard editor with a blank source file in it):

2. Source: this is the folder where your md files should be, also remember to organize them with leading number. Usually 00-metadata.md should hold the yaml for your project, followed by 01-first-chapter.md and so on.
3. Style: this directory should hold all styling documents, from citation style to custom filters.
1. Output: this folder should hold files once building is complete.

If you follow the workflow from [this](https://lf-araujo.github.io/2016/11/07/mdworkflow.html) post you can `cd` into the working directory: `cd source`, create your first file `touch document.md`, and open it with sublime text `subl3 document.md` to start writing. This is the simpler approach to start the project. In the case you are aiming at a larger document, you will probably want to create a 00-metadata.md to hold all yaml variables to the project.

The style directory should hold your cls file (the citation style) and custom filters. I will present an acronym filter in upcoming post. 

Finally, configure Sublime Text to build the files using make. This can be achieved by choosing `Tools > Build System > Make`, and once ready hit `Ctrl+B`. Your markdown document should then be processed and the output will be populated with a pdf file. If you are not interested in a pdf, but in any of the several formats supported by Pandoc, change the first line of the makefile accordingly: `.DEFAULT_GOAL := pdf`. Note that in the terminal you can call any of the formats supported: `make epub`, `make docx`, `make tex`, `make html`. In case you work with other formats, please commit changes to the project.

Note that it might be useful to update the Makefile by running the command `make update` now and then.


### Managing your LaTeX distribution with mighty_make

As mentioned previously, one can manage the LaTeX distribution using this tool. This makes managing LaTeX easier, but it is still somewhat fallible. Some times LaTeX processing will require manual installation of packages, which my routine isn't able to detect as a dependency. 

I would recommend this approach to everyone who needs to save space in the computer. If you have plenty of space, follow your distribution standard standard way of installing LaTeX instead. In my case, I have a laptop with a tiny SDD, and using this method I can make the installation, that normally uses up to 2GB of space, use around 900mb (considering the type of work I do).

#### Installing the LaTeX distribution

In order to do that run:

```bash
make prepare-latex
```

You will be prompted for password and it will take care of the rest. Once the process is finished, one will end up with a minimal LaTeX installation of 100mb. This is not enough for a minimally working LaTeX installation, but is enough for a install-as-you-go approach.

Now suppose you want to print a cv as per the example in the beginning of this document. Cd into the directory, say `cd yapcvt` and you can try to install all dependencies for this theme with:

```bash
make dependencies
```

If all went well, issuing `make` will generate the cv as expected in the `/output` directory.
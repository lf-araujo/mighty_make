# Mighty Make - Standardize Document Building

**Latest version of the instructions are to be found in the project website, link above.**

The use of pandoc over years and the repetitive work of rendering documents in the command line naturally compelled me to find some way of automating these steps. A simple way of making that is by using a building system. It had to separate two elemens of document production: content and style. 

Pandoc does not have a custom building system. In what follows an attempt of standardization for building a document using Pandoc will be shown. The easier way of doing that was by using the long tested and reliable GNU make system. It means that you will need it installed in your system. Also, my makefile is Linux compatible and was tested in at least two Linux systems, however it may work in Mac OSs. However, it was not tested in Macs, so if you manage to make it work, please report and commit changes to the project. This makefile aims at medium to larger projects, therefore it depends on pandoc-citeproc and pandoc-crossref, so make sure you have these installed in your system.

The first step is to download the makefile in the directory where you want to start your project:

```
wget http://tiny.cc/mighty_make -O Makefile
```

You can find all intructions with the command `make help`. Now prepare the file system to start the project with the command `make prepare`. This will create three directories:

1. Output: this folder should hold files once building is complete.
2. Source: this is the folder where your md files should be, also remember to organize them with leading number. Usually 00-metadata.md should hold the yaml for your project, followed by 01-first-chapter.md and so on.
3. Style: this directory should hold all styling documents, from citation style to custom filters.

Cd into the working directory: `cd source`, create your first file `touch document.md`, and open it with sublime text `subl3 document.md` to start writing. This is the simpler approach to start the project. In the case you are aiming at a larger document, you will probably want to create a 00-metadata.md to hold all yaml variables to the project as I mentioned previously.

The style directory should hold your cls file (the citation style) and custom filters. I will present an acronym filter in upcoming post. 

Finally, configure Sublime Text to build the files using make. This can be achieved by choosing Tools > Build System > Make, and once ready hit `Ctrl+B`. Your markdown document should then be processed and the output will be populated with a pdf file. If you are not interested in a pdf, but in any of the several formats supported by Pandoc, change the first line of the makefile accordingly: `.DEFAULT_GOAL := pdf`. Note that in the terminal you can call any of the formats supported: `make epub`, `make docx`, `make tex`, `make html`. In case you work with other formats, please commit changes to the project.

Note that it might be useful to update the Makefile by running the command `make update` every now and then.

The [mighty_make project](https://github.com/lf-araujo/mighty_make) is particularly useful to those who have to write project frequently. If the desired output is PDF, it saves time and allows you to start writing in two steps (given that you already have your Sublime Text editor ready to work), whilst liberating the writer from Office Suites.

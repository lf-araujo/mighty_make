# Mighty Make - Standardized Document Building

Mighty make is a building system to large projects that uses pandoc. It can help producing from letters to entire thesis and books.

To use it start with: 

```
wget http://tiny.cc/mighty_make -O Makefile
```

You can find all intructions with the command `make help`. Now prepare the file system to start the project with the command `make prepare`. This will create three directories:

2. Source: this is the folder where your md files should be, also remember to organize them with leading number. Usually 00-metadata.md should hold the yaml for your project, followed by 01-first-chapter.md and so on.
3. Style: this directory should hold all styling documents, from citation style to custom filters.
1. Output: this folder should hold files once building is complete.

If you follow the workflow from [this](https://lf-araujo.github.io/2016/11/07/mdworkflow.html) post you can `cd` into the working directory: `cd source`, create your first file `touch document.md`, and open it with sublime text `subl3 document.md` to start writing. This is the simpler approach to start the project. In the case you are aiming at a larger document, you will probably want to create a 00-metadata.md to hold all yaml variables to the project.

The style directory should hold your cls file (the citation style) and custom filters. I will present an acronym filter in upcoming post. 

Finally, configure Sublime Text to build the files using make. This can be achieved by choosing Tools > Build System > Make, and once ready hit `Ctrl+B`. Your markdown document should then be processed and the output will be populated with a pdf file. If you are not interested in a pdf, but in any of the several formats supported by Pandoc, change the first line of the makefile accordingly: `.DEFAULT_GOAL := pdf`. Note that in the terminal you can call any of the formats supported: `make epub`, `make docx`, `make tex`, `make html`. In case you work with other formats, please commit changes to the project.

Note that it might be useful to update the Makefile by running the command `make update` every now and then.
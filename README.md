# Thesis template and a multi-file (\& folder) LaTeX structure

This repository contains an example of a multi-file thesis structure that I created for my PhD thesis.

I also created a thesis style for UTS (`utsthesis.cls`) by modifying the book style.

**DISCLAIMER: THIS IS NOT AN OFFICIAL UTS THESIS STYLE/TEMPLATE.**
In its current form, it may not even be consistent with UTS style guidelines (e.g. for the title page and/or logo use).
Therefore, certain page designs might need to be changed.
This is an initial implementation, and it will most surely be updated.
**In short, it is provided with no warranty and use it at your own risk.**
Please feel free to add/change/modify/refine and issue a pull-request so we all can benefit from those changes.

I like to use vs-code and write the output files into the `out` folder/s, where you can find the compiled `0_main.pdf` to see how does the template look like.
Also, I included my vscode settings (see `.vscode` folder), in case you want to use them.

Here are the "features":
- You can compile and work-on/test each file separately, i.e. you can compile the whole thesis as well as any chapter/section/etc (depending on how much you divide)
    - You just need to make a couple of small changes in the tex files when you are compiling them individually. These changes are explained in the comments in the files.
    - currently, it is configured to compile the whole thesis
    - if you forget to make these changes and try to compile, you will get a compilation error. But, also note that, depending on what you use (like LaTeX distribution, IDE, etc.), the files created during the failed compilation might cause errors (if not cleaned) even when you make the necessary changes. Therefore, make sure that you delete all the output files before compilation (this is where the use of `out` folder comes handy, you can just delete the folder).
- Even in this separated structure, you can create references/hyperlinks to other chapters/sections/etc. in other folders/files.
- References are shown at the end of each chapter
- References are stored in one central bibliography file
- You can still compile each file with references to test that your references are working/citing properly. But note that the reference styles are different for individual and whole compilations.
- There is one minor bug in the fancy headers that happens only when a chapter is too short and/or you omit the `\clearpage` command at the end of the chapters. It shows the name of the last section in the header if these conditions are not met. As you can see from the `pdf` file, it does not happen when the chapters are long enough and `\clearpage` command is used at the end of each chapter.


@echo off
rem 这是用于编译 LaTeX 文件并自动清理临时文件的批处理脚本

rem 1. 清理旧的临时文件
echo Deleting old temporary files...
del /q *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.ent-x *.tmp *.ltx *.los *.lol *.loc *.listing *.gz *.userbak *.nav *.snm *.vrb *.synctex(busy)
del /q *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk *.dvi
echo Temporary files deleted.

rem 2. 提示用户选择编译链组合
echo Please choose a compilation chain:
echo 1. pdflatex + bibtex (most common)
echo 2. xelatex + biber (advanced fonts and modern bibliography)
echo 3. pdflatex + biber (modern bibliography)
echo 4. xelatex + bibtex
echo 5. lualatex + biber (Lua scripting and modern bibliography)
echo 6. lualatex + bibtex
echo 7. pdflatex + makeindex (for documents with index)
echo 8. xelatex + makeindex
echo 9. lualatex + makeindex
echo 10. pdflatex + natbib (for natbib bibliography style)
echo 11. xelatex + natbib
echo 12. latex + dvipdf (traditional DVI to PDF)
echo 13. Custom (choose compiler and bibliography processor separately)
set /p choice=Enter your choice (1-13): 

rem 初始化变量
set compiler_option=
set bib_option=

if "%choice%"=="1" (
    set compiler_option=-pdf
    set bib_option=-e "$bibtex_use = 1"
    echo Selected: pdflatex + bibtex
    goto compile
) else if "%choice%"=="2" (
    set compiler_option=-xelatex
    set bib_option=-e "$bibtex_use = 2"
    echo Selected: xelatex + biber
    goto compile
) else if "%choice%"=="3" (
    set compiler_option=-pdf
    set bib_option=-e "$bibtex_use = 2"
    echo Selected: pdflatex + biber
    goto compile
) else if "%choice%"=="4" (
    set compiler_option=-xelatex
    set bib_option=-e "$bibtex_use = 1"
    echo Selected: xelatex + bibtex
    goto compile
) else if "%choice%"=="5" (
    set compiler_option=-lualatex
    set bib_option=-e "$bibtex_use = 2"
    echo Selected: lualatex + biber
    goto compile
) else if "%choice%"=="6" (
    set compiler_option=-lualatex
    set bib_option=-e "$bibtex_use = 1"
    echo Selected: lualatex + bibtex
    goto compile
) else if "%choice%"=="7" (
    set compiler_option=-pdf
    set bib_option=-e "$makeindex_use = 1"
    echo Selected: pdflatex + makeindex
    goto compile
) else if "%choice%"=="8" (
    set compiler_option=-xelatex
    set bib_option=-e "$makeindex_use = 1"
    echo Selected: xelatex + makeindex
    goto compile
) else if "%choice%"=="9" (
    set compiler_option=-lualatex
    set bib_option=-e "$makeindex_use = 1"
    echo Selected: lualatex + makeindex
    goto compile
) else if "%choice%"=="10" (
    set compiler_option=-pdf
    set bib_option=-e "$bibtex_use = 1" -e "$natbib_use = 1"
    echo Selected: pdflatex + natbib
    goto compile
) else if "%choice%"=="11" (
    set compiler_option=-xelatex
    set bib_option=-e "$bibtex_use = 1" -e "$natbib_use = 1"
    echo Selected: xelatex + natbib
    goto compile
) else if "%choice%"=="12" (
    set compiler_option=-dvi -e "$dvipdf = 'dvipdf %O %S %D'"
    set bib_option=-e "$bibtex_use = 1"
    echo Selected: latex + dvipdf
    goto compile
) else if "%choice%"=="13" (
    rem 自定义选项
    echo Please choose the compiler:
    echo 1. pdflatex
    echo 2. xelatex
    echo 3. lualatex
    echo 4. latex (with dvipdf)
    set /p compiler_choice=Enter your choice (1-4): 
    if "%compiler_choice%"=="1" (
        set compiler_option=-pdf
        echo Selected compiler: pdflatex
    ) else if "%compiler_choice%"=="2" (
        set compiler_option=-xelatex
        echo Selected compiler: xelatex
    ) else if "%compiler_choice%"=="3" (
        set compiler_option=-lualatex
        echo Selected compiler: lualatex
    ) else if "%compiler_choice%"=="4" (
        set compiler_option=-dvi -e "$dvipdf = 'dvipdf %O %S %D'"
        echo Selected compiler: latex (with dvipdf)
    ) else (
        echo Invalid choice. Defaulting to pdflatex.
        set compiler_option=-pdf
    )
    
    echo Please choose the bibliography processor:
    echo 1. bibtex
    echo 2. biber
    echo 3. makeindex (for index generation)
    echo 4. natbib (with bibtex)
    set /p bib_choice=Enter your choice (1-4): 
    if "%bib_choice%"=="1" (
        set bib_option=-e "$bibtex_use = 1"
        echo Selected bibliography processor: bibtex
    ) else if "%bib_choice%"=="2" (
        set bib_option=-e "$bibtex_use = 2"
        echo Selected bibliography processor: biber
    ) else if "%bib_choice%"=="3" (
        set bib_option=-e "$makeindex_use = 1"
        echo Selected: makeindex
    ) else if "%bib_choice%"=="4" (
        set bib_option=-e "$bibtex_use = 1" -e "$natbib_use = 1"
        echo Selected: natbib (with bibtex)
    ) else (
        echo Invalid choice. Defaulting to bibtex.
        set bib_option=-e "$bibtex_use = 1"
    )
    goto compile
) else (
    echo Invalid choice. Defaulting to pdflatex + bibtex.
    set compiler_option=-pdf
    set bib_option=-e "$bibtex_use = 1"
    goto compile
)

:compile
rem 3. 遍历当前目录中的所有 .tex 文件并编译
for %%f in (*.tex) do (
    rem 设置当前正在处理的 LaTeX 文件
    set texfile=%%f

    rem 显示正在编译的文件名
    echo Compiling %%f with latexmk using %compiler_option% and %bib_option%...

    rem 使用 latexmk 编译 LaTeX 文件
    latexmk %compiler_option% %bib_option% %%f

    rem 编译完成后，删除临时文件
    echo Deleting temporary files for %%f...
    del /q *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.ent-x *.tmp *.ltx *.los *.lol *.loc *.listing *.gz *.userbak *.nav *.snm *.vrb *.synctex(busy)
    del /q *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk *.dvi
    echo Temporary files for %%f deleted.
)

rem 执行完所有操作后，自动关闭窗口
exit
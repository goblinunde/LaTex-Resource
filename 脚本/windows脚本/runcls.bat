@echo off
rem 这是用于编译 LaTeX 文件并自动清理临时文件的批处理脚本

rem 1. 清理旧的临时文件
echo Deleting old temporary files...
del /q *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.ent-x *.tmp *.ltx *.los *.lol *.loc *.listing *.gz *.userbak *.nav *.snm *.vrb *.synctex(busy)
del /q *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk
echo Temporary files deleted.

rem 2. 提示用户选择编译器
echo Please choose the compiler:
echo 1. pdflatex (most common)
echo 2. xelatex (supports advanced fonts)
echo 3. lualatex (Lua scripting support)
set /p compiler_choice=Enter your choice (1-3): 

if "%compiler_choice%"=="1" (
    set compiler_option=-pdf
) else if "%compiler_choice%"=="2" (
    set compiler_option=-xelatex
) else if "%compiler_choice%"=="3" (
    set compiler_option=-lualatex
) else (
    echo Invalid choice. Defaulting to pdflatex.
    set compiler_option=-pdf
)

rem 3. 提示用户选择参考文献处理器
echo Please choose the bibliography processor:
echo 1. bibtex (traditional)
echo 2. biber (modern, recommended with xelatex/lualatex)
set /p bib_choice=Enter your choice (1-2): 

if "%bib_choice%"=="1" (
    set bib_option=-e "$bibtex_use = 1"
) else if "%bib_choice%"=="2" (
    set bib_option=-e "$bibtex_use = 2"
) else (
    echo Invalid choice. Defaulting to bibtex.
    set bib_option=-e "$bibtex_use = 1"
)

rem 4. 遍历当前目录中的所有 .tex 文件并编译
for %%f in (*.tex) do (
    rem 设置当前正在处理的 LaTeX 文件
    set texfile=%%f

    rem 显示正在编译的文件名
    echo Compiling %%f with latexmk...

    rem 使用 latexmk 编译 LaTeX 文件并生成 PDF
    latexmk %compiler_option% %bib_option% %%f

    rem 编译完成后，删除临时文件
    echo Deleting temporary files for %%f...
    del /q *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.ent-x *.tmp *.ltx *.los *.lol *.loc *.listing *.gz *.userbak *.nav *.snm *.vrb *.synctex(busy)
    del /q *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk
    echo Temporary files for %%f deleted.
)

rem 执行完所有操作后，自动关闭窗口
cls
exit

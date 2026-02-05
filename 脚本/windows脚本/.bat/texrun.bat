@echo off
cls
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

rem 4. 获取当前目录下的 .tex 文件列表
echo Available .tex files:
setlocal enabledelayedexpansion
set file_count=0
for %%f in (*.tex) do (
    set /a file_count+=1
    set "file[!file_count!]=%%f"
    echo !file_count!. %%f
)

if %file_count%==0 (
    echo No .tex files found in the current directory.
    goto end
)

rem 5. 提示用户选择要编译的 .tex 文件
echo Please select the .tex file to compile by entering its number:
set /p selected_number=Enter your choice: 

rem 6. 解析用户输入的编号并编译选定的文件
set /a num=%selected_number%
if !num! geq 1 if !num! leq %file_count% (
    set texfile=!file[%selected_number%]!
    echo Compiling !texfile! with latexmk...
    latexmk %compiler_option% %bib_option% !texfile!
    if !errorlevel! == 0 (
        cls
        echo Compilation successful for !texfile!.
        echo Deleting temporary files for !texfile!...
        del /q *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.ent-x *.tmp *.ltx *.los *.lol *.loc *.listing *.gz *.userbak *.nav *.snm *.vrb *.synctex(busy)
        del /q *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk
        echo Temporary files for !texfile! deleted.
    ) else (
        echo.
        echo Compilation failed for !texfile!. See errors above.
        echo Press any key to continue...
        pause > nul
    )
) else (
    echo Invalid selection: %selected_number%
)

:end
endlocal
echo All selected files have been processed.
pause
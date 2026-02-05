@echo off
cls
rem 这是用于编译 LaTeX 文件并自动清理临时文件的批处理脚本

rem 询问是否检测多文件依赖
echo Do you want to detect dependencies (\include or \input) in the main .tex file?
echo 1. Yes (includes subdirectories)
echo 2. No
set /p detect_choice=Enter your choice (1-2): 
if "%detect_choice%"=="1" (
    set detect_deps=yes
) else (
    set detect_deps=no
)

rem 1. 清理旧的临时文件
echo Deleting old temporary files...
del /q *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.ent-x *.tmp *.ltx *.los *.lol *.loc *.listing *.gz *.userbak *.nav *.snm *.vrb *.synctex(busy)
del /q *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk
echo Temporary files deleted.

rem 2. 读取配置文件或提示用户选择编译器和参考文献处理器
if exist "latex_config.ini" (
    for /f "tokens=1,2 delims==" %%a in (latex_config.ini) do (
        if "%%a"=="compiler" set compiler_option=%%b
        if "%%a"=="bib_processor" set bib_option=%%b
    )
    echo Using settings from latex_config.ini: %compiler_option%, %bib_option%
) else (
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
)

rem 3. 获取当前目录下的 .tex 文件列表
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

rem 4. 提示用户选择要编译的 .tex 文件
echo Please select the .tex file to compile by entering its number:
set /p selected_number=Enter your choice: 

rem 5. 解析用户输入的编号并编译选定的文件
set /a num=%selected_number%
if !num! geq 1 if !num! leq %file_count% (
    set texfile=!file[%selected_number%]!
    echo Compiling !texfile! with latexmk...

    rem 如果启用了依赖检测，查找 \include 和 \input，支持一级子目录
    if "!detect_deps!"=="yes" (
        echo Detecting dependencies in !texfile!...
        set "dependencies="
        for /f "tokens=*" %%l in ('findstr /r /c:"\\\(include\|input\){[^}]*}" !texfile!') do (
            for /f "tokens=2 delims={}" %%d in ("%%l") do (
                set dep=%%d
                if not "!dep:~-4!"==".tex" set dep=!dep!.tex
                rem 检查当前目录
                if exist "!dep!" (
                    set "dependencies=!dependencies! !dep!"
                    echo Found dependency in current directory: !dep!
                ) else (
                    rem 检查一级子目录
                    for /d %%s in (*) do (
                        if exist "%%s\!dep!" (
                            set "dependencies=!dependencies! %%s\!dep!"
                            echo Found dependency in subdirectory %%s: !dep!
                        )
                    )
                )
            )
        )
    )

    rem 编译主文件
    latexmk %compiler_option% %bib_option% !texfile!
    if !errorlevel! == 0 (
        cls
        echo Compilation successful for !texfile!.
        if defined dependencies (
            echo Dependencies compiled: !dependencies!
        )
        echo Deleting temporary files for !texfile!...
        del /q *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.ent-x *.tmp *.ltx *.los *.lol *.loc *.listing *.gz *.userbak *.nav *.snm *.vrb *.synctex(busy)
        del /q *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk
        rem 清理子目录中的临时文件
        if "!detect_deps!"=="yes" (
            for /d %%s in (*) do (
                del /q "%%s\*.aux" "%%s\*.bbl" "%%s\*.blg" "%%s\*.log" "%%s\*.out" "%%s\*.toc" "%%s\*.bcf" "%%s\*.xml" "%%s\*.synctex" "%%s\*.nlo" "%%s\*.nls" "%%s\*.bak" "%%s\*.ind" "%%s\*.idx" "%%s\*.ilg" "%%s\*.lof" "%%s\*.lot" "%%s\*.tmp" "%%s\*.nav" "%%s\*.snm" "%%s\*.vrb" "%%s\*.fls" "%%s\*.xdv" "%%s\*.fdb_latexmk" 2>nul
            )
        )
        echo Temporary files for !texfile! deleted.
    ) else (
        echo.
        echo Compilation failed for !texfile!. Analyzing log file...
        set "logfile=!texfile:.tex=.log!"
        if exist "!logfile!" (
            echo Errors and warnings from !logfile!:
            for /f "tokens=*" %%e in ('findstr /r /c:"!.*" /c:"Warning" !logfile!') do (
                echo %%e
            )
        ) else (
            echo Log file not found.
        )
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
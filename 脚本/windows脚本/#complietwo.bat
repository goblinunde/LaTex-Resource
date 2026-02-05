@echo off
rem 这是用于编译 LaTeX 文件并自动清理临时文件的批处理脚本
if exist *.aux del /q *.aux
if exist *.nav del /q *.nav
if exist *.synctex del /q *.synctex
rem 1. 清理旧的临时文件
echo Deleting old temporary files...
del /q *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.ent-x *.tmp *.ltx *.los *.lol *.loc *.listing *.gz *.userbak *.nav *.snm *.vrb *.synctex(busy)
del /q *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk
echo Temporary files deleted.

rem 2. 遍历当前目录中的所有 .tex 文件并编译
for %%f in (*.tex) do (
    rem 设置当前正在处理的 LaTeX 文件
    set texfile=%%f

    rem 显示正在编译的文件名
    echo Compiling %%f with latexmk...

    rem 使用 latexmk 编译 LaTeX 文件并生成 PDF
    latexmk -pdf %%f

    rem 编译完成后，删除临时文件
    echo Deleting temporary files for %%f...
    del /q *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.ent-x *.tmp *.ltx *.los *.lol *.loc *.listing *.gz *.userbak *.nav *.snm *.vrb *.synctex(busy)
    del /q *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk
    echo Temporary files for %%f deleted.
)

echo Temporary files deleted.

rem 执行完所有操作后，自动关闭窗口
exit
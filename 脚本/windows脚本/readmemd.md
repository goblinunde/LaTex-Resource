







# 



根据你的需求，我将修改之前的脚本，使依赖检测功能支持更深一层的目录（即当前目录及其一级子目录），同时保持对当前目录的支持。以下是修改后的批处理脚本及其详细说明。

---

### 修改目标
1. **支持当前目录**：检测主 `.tex` 文件中 `\include` 或 `\input` 引用的文件，如果这些文件在当前目录下，照常识别。
2. **支持一级子目录**：如果依赖文件不在当前目录下，搜索一级子目录（如 `chapters/`、`sections/` 等），并在找到时记录完整路径。
3. **保持其他功能不变**：保留配置文件支持、日志分析、清屏和编译反馈等功能。

---

### 修改后的批处理脚本

```batch
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
```

---

### 修改说明

#### 1. 依赖检测支持一级子目录
- **实现方式**：
  - 在检测 `\include` 或 `\input` 时，首先检查当前目录（`if exist "!dep!"`）。
  - 如果当前目录不存在，使用 `for /d %%s in (*)` 遍历一级子目录，检查每个子目录中是否存在依赖文件（`if exist "%%s\!dep!"`）。
  - 如果找到依赖文件，将完整路径（例如 `chapters\chapter1.tex`）添加到 `dependencies` 变量中。
- **效果**：
  - 支持当前目录中的文件（如 `chapter1.tex`）。
  - 支持一级子目录中的文件（如 `chapters\chapter1.tex`）。
  - `latexmk` 会自动处理这些依赖文件（它支持相对路径）。

#### 2. 清理子目录临时文件
- **实现方式**：
  - 在编译成功后，如果启用了依赖检测，添加了对一级子目录临时文件的清理。
  - 使用 `del /q "%%s\*.aux" "%%s\*.bbl" ...` 清理子目录中的常见临时文件，`2>nul` 避免无文件时的错误提示。
- **效果**：
  - 保持当前目录和子目录的整洁。

#### 3. 保持原有功能
- 保留了配置文件读取、日志分析、清屏和编译反馈的功能。
- 用户仍可选择是否启用依赖检测。

---

### 使用方法

1. **目录结构示例**：
   ```
   main.tex
   chapter1.tex
   chapters\
     chapter2.tex
   ```
   `main.tex` 内容：
   ```
   \documentclass{article}
   \begin{document}
   \include{chapter1}
   \input{chapters/chapter2}
   \end{document}
   ```

2. **运行脚本**：
   - 选择 `1` 启用依赖检测。
   - 如果有 `latex_config.ini`，自动读取配置；否则手动选择编译器和参考文献处理器。
   - 选择主文件 `main.tex` 的编号。

3. **输出示例**：
   ```
   Do you want to detect dependencies (\include or \input) in the main .tex file?
   1. Yes (includes subdirectories)
   2. No
   Enter your choice (1-2): 1
   Deleting old temporary files...
   Temporary files deleted.
   Available .tex files:
   1. main.tex
   2. chapter1.tex
   Please select the .tex file to compile by entering its number:
   Enter your choice: 1
   Compiling main.tex with latexmk...
   Detecting dependencies in main.tex...
   Found dependency in current directory: chapter1.tex
   Found dependency in subdirectory chapters: chapter2.tex
   [latexmk 输出]
   [清屏]
   Compilation successful for main.tex.
   Dependencies compiled: chapter1.tex chapters\chapter2.tex
   Deleting temporary files for main.tex...
   Temporary files for main.tex deleted.
   All selected files have been processed.
   Press any key to continue...
   ```

---

### 注意事项
- **依赖文件路径**：支持当前目录和一级子目录，不支持更深层（如 `chapters/sub/chapter3.tex`）。如果需要更深层支持，可以进一步修改。
- **文件名匹配**：依赖文件名必须与 `\include` 或 `\input` 中的内容一致（忽略 `.tex` 扩展名）。
- **临时文件清理**：清理范围限于当前目录和一级子目录。

这个脚本现已支持更深一层的目录依赖检测，同时兼容当前目录。如果你需要支持更复杂的目录结构或有其他需求，请告诉我！



## 



### 



### Makefile

Makefile 是编译项目的经典工具，特别适合需要管理依赖关系的 LaTeX 项目。它可以自动检测文件更改并只编译必要的部分。

**示例 Makefile：**

makefile

CollapseUnwrapCopy

```
MAIN = main TEX_FILES = $(wildcard *.tex) PDF = $(MAIN).pdf all: $(PDF) $(PDF): $(TEX_FILES) latexmk -xelatex -e "$$bibtex_use = 2" $(MAIN).tex clean: rm -f *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.tmp *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk .PHONY: all clean
```

**使用方法**：

- 保存为 Makefile，将主文件命名为 main.tex。
- 在终端运行：
  - make：编译生成 PDF。
  - make clean：清理临时文件。

**优点**：

- 自动依赖管理，只编译更改的文件。
- 跨平台（Linux/macOS，Windows 需安装 make）。
- 非常适合复杂项目。

**缺点**：

- 不够直观，缺少交互性。
- 需要学习 Makefile 语法。





在 Windows 和 Ubuntu 上使用 Makefile 编译 LaTeX 项目需要不同的配置步骤，因为它们的操作系统环境和工具链有所不同。以下分别说明如何在 Windows 和 Ubuntu 上配置并使用你提供的 Makefile 示例。

---

### 示例 Makefile
以下是你提供的 Makefile，我稍作调整以确保清晰和兼容性：

```makefile
MAIN = main
TEX_FILES = $(wildcard *.tex)
PDF = $(MAIN).pdf

all: $(PDF)

$(PDF): $(TEX_FILES)
	latexmk -xelatex -e "$$bibtex_use = 2" $(MAIN).tex

clean:
	rm -f *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.tmp *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk

.PHONY: all clean
```

- `MAIN`：主 `.tex` 文件名（不含扩展名）。
- `TEX_FILES`：当前目录下所有 `.tex` 文件（通过 `wildcard` 自动检测）。
- `PDF`：目标 PDF 文件。
- `all`：默认目标，生成 PDF。
- `clean`：清理临时文件。
- `latexmk`：使用 `xelatex` 编译，并启用 `biber` 处理参考文献。

---

### 在 Windows 上配置和使用

#### 1. 安装必要工具
Windows 默认没有 `make` 和 LaTeX 工具链，需要安装以下软件：

- **LaTeX 发行版**：
  - 推荐安装 **MiKTeX**（轻量）或 **TeX Live**（完整）。
  - 下载 MiKTeX：https://miktex.org/download
  - 安装后，确保 `latexmk`、`xelatex` 和 `biber` 在 PATH 中（MiKTeX 会自动配置）。
  - 测试：打开命令提示符 (cmd)，输入 `xelatex --version`，应显示版本信息。

- **Make 工具**：
  - Windows 不自带 `make`，需要安装一个实现。
  - **方法 1：安装 MinGW**（推荐）：
    - 下载 MinGW：http://www.mingw.org/
    - 安装时选择 `mingw32-make` 包。
    - 安装完成后，将 MinGW 的 `bin` 目录（例如 `C:\MinGW\bin`）添加到系统 PATH。
    - 重命名 `mingw32-make.exe` 为 `make.exe`（可选，便于使用 `make` 命令）。
  - **方法 2：安装 Chocolatey**（包管理器）：
    - 安装 Chocolatey：https://chocolatey.org/install
    - 在命令提示符运行：`choco install make`
  - 测试：在 cmd 中输入 `make --version`，应显示版本信息。

#### 2. 配置环境变量
- 确保 `xelatex`、`latexmk` 和 `biber` 可在命令行直接调用：
  - 打开“系统属性” → “高级系统设置” → “环境变量”。
  - 在“系统变量”或“用户变量”的 `Path` 中添加 MiKTeX 的 `bin` 目录（例如 `C:\Program Files\MiKTeX 2.9\miktex\bin\x64`）和 MinGW 的 `bin` 目录。
- 重启命令提示符或重启电脑以应用更改。

#### 3. 创建项目并使用 Makefile
- **目录结构**：
  ```
  project_folder/
    main.tex
    Makefile
  ```
- **main.tex 示例**：
  ```latex
  \documentclass{article}
  \begin{document}
  Hello, LaTeX!
  \end{document}
  ```
- 将上述 Makefile 保存为 `Makefile`（无扩展名）。

#### 4. 运行 Makefile
- 打开命令提示符 (cmd)，进入项目目录：
  ```
  cd C:\path\to\project_folder
  ```
- 编译生成 PDF：
  ```
  make
  ```
  - 这将运行 `latexmk -xelatex -e "$bibtex_use = 2" main.tex`，生成 `main.pdf`。
- 清理临时文件：
  ```
  make clean
  ```

#### 5. 注意事项
- **编码问题**：Windows 的 cmd 默认使用 GBK 编码，若 `main.tex` 使用 UTF-8，确保文件有 BOM 或用支持 UTF-8 的编辑器保存。
- **清理命令兼容性**：Makefile 中的 `rm -f` 在 Windows 下不可用，但 MinGW 的 `make` 会将其解释为删除命令，无需修改。
- **依赖检测**：`latexmk` 会自动处理 `\include` 和 `\input`，无需额外配置。

---

### 在 Ubuntu 上配置和使用

#### 1. 安装必要工具
Ubuntu 默认支持 `make`，但需要安装 LaTeX 工具链：

- **安装 TeX Live**（推荐完整版，包含 `latexmk`、`xelatex`、`biber`）：
  ```
  sudo apt update
  sudo apt install texlive-full
  ```
  - 如果只需要基本功能，可用 `texlive` 替代 `texlive-full`（较小，但可能缺少某些包）。
- **安装 make**（通常已预装）：
  ```
  sudo apt install make
  ```
- 测试：
  - `xelatex --version`：检查 LaTeX 编译器。
  - `latexmk --version`：检查 LaTeX 自动化工具。
  - `make --version`：检查 make 工具。

#### 2. 配置环境变量
- Ubuntu 的 TeX Live 默认安装在 `/usr/bin` 或 `/usr/local/texlive/YYYY/bin/x86_64-linux`，通常无需手动配置 PATH。
- 如果安装了自定义版本的 TeX Live（如通过官方脚本安装），需将路径添加到 `~/.bashrc`：
  ```
  export PATH=$PATH:/usr/local/texlive/2023/bin/x86_64-linux
  ```
  然后运行 `source ~/.bashrc` 应用更改。

#### 3. 创建项目并使用 Makefile
- **目录结构**：
  ```
  project_folder/
    main.tex
    Makefile
  ```
- **main.tex 示例**：
  ```latex
  \documentclass{article}
  \begin{document}
  Hello, LaTeX!
  \end{document}
  ```
- 将上述 Makefile 保存为 `Makefile`。

#### 4. 运行 Makefile
- 打开终端，进入项目目录：
  ```
  cd /path/to/project_folder
  ```
- 编译生成 PDF：
  ```
  make
  ```
  - 这将运行 `latexmk -xelatex -e "$bibtex_use = 2" main.tex`，生成 `main.pdf`。
- 清理临时文件：
  ```
  make clean
  ```

#### 5. 注意事项
- **权限**：确保当前用户对项目目录有写权限。
- **编码**：Ubuntu 默认支持 UTF-8，无需特别处理。
- **依赖检测**：`latexmk` 会自动处理 `\include` 和 `\input`，Makefile 通过 `$(TEX_FILES)` 确保所有 `.tex` 文件被视为依赖。

---

### Windows 和 Ubuntu 的主要区别

| 方面         | Windows                                        | Ubuntu                          |
| ------------ | ---------------------------------------------- | ------------------------------- |
| **工具安装** | 需手动安装 MiKTeX/TeX Live 和 MinGW/Chocolatey | `apt` 一键安装 TeX Live 和 make |
| **环境变量** | 需手动配置 PATH                                | 默认可用或简单修改 `~/.bashrc`  |
| **清理命令** | `rm -f` 通过 MinGW 兼容                        | `rm -f` 原生支持                |
| **终端**     | cmd 或 PowerShell                              | Bash 或其他终端                 |
| **编码支持** | 默认 GBK，需注意 UTF-8                         | 默认 UTF-8                      |

---

### 扩展 Makefile（可选）
如果你需要更复杂的依赖管理，可以改进 Makefile：

```makefile
MAIN = main
TEX_FILES = $(wildcard *.tex) $(wildcard */*.tex)
PDF = $(MAIN).pdf

all: $(PDF)

$(PDF): $(TEX_FILES)
	latexmk -xelatex -e "$$bibtex_use = 2" $(MAIN).tex

clean:
	rm -f *.aux *.bbl *.blg *.log *.out *.toc *.bcf *.xml *.synctex *.nlo *.nls *.bak *.ind *.idx *.ilg *.lof *.lot *.tmp *.nav *.snm *.vrb *.fls *.xdv *.fdb_latexmk
	rm -f */*.aux */*.bbl */*.blg */*.log */*.out */*.toc */*.bcf */*.xml */*.synctex */*.nlo */*.nls */*.bak */*.ind */*.idx */*.ilg */*.lof */*.lot */*.tmp */*.nav */*.snm */*.vrb */*.fls */*.xdv */*.fdb_latexmk

.PHONY: all clean
```

- `$(wildcard */*.tex)`：检测一级子目录中的 `.tex` 文件。
- `rm -f */*.<ext>`：清理子目录中的临时文件。

---

### 总结
- **Windows**：安装 MiKTeX 和 MinGW，配置 PATH，使用 cmd 运行 `make`。
- **Ubuntu**：安装 TeX Live 和 make，无需额外配置，使用终端运行 `make`。

配置完成后，Makefile 的使用方法在两平台上完全一致。如果你有其他问题或需要进一步调整 Makefile（例如添加交互性），请告诉我！
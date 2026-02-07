# 神经网络与深度学习 中文翻译（LaTeX 版本）

这是 Michael Nielsen 的《Neural Networks and Deep Learning》一份中文翻译排版工程。
项目使用 XeLaTeX + CJK 字体，强调跨平台可编译与可维护的排版结构。

## 编译

推荐使用 TeX Live（或 MacTeX）并启用 XeLaTeX。

1) 生成图片（TikZ/EPS -> PDF）：
```shell
$ make -C images
```

2) 生成主文档（建议执行两次以稳定引用）：
```shell
$ make
$ make
```

重要：不要直接编译 `main.tex`，它是通用前导文件，会生成错误的 `main.pdf`。
请编译 `nndl-ebook.tex` 或直接运行 `make`。

### Make 目标

- `make ebook`：生成电子版（与默认构建一致）
- `make print`：以 `\nndlprinttrue` 方式生成打印版（双面 + 章起始右页）

### 编译模式（可选）

`nndl-ebook.tex` 提供简单的编译开关：
- `\nndlprinttrue`：打印版（双面 + 章起始右页）
- `\nndldrafttrue`：草稿版（静默版式警告）

在 `nndl-ebook.tex` 顶部取消注释即可启用。

### 页面与字体选项（可选）

你可以在 `nndl-ebook.tex` 顶部自定义纸张、边距、字体方案与标题样式：
- 纸张：`\def\nndlPaper{a4paper}` 或 `letterpaper`
- 边距：`\def\nndlGeometry{...}`（任意 geometry 参数）
- 字体方案：`\def\nndlFontScheme{auto}`（`auto | noto | fandol | western`）
- 标题样式：`\def\nndlTitleStyle{classic}`（`classic | dual`，dual 会显示英文副标题行）

注意：`western` 会关闭 CJK 字体，只适用于纯西文输出。

## 项目分析

这个项目将“内容”和“排版/配置”分离，以获得更清晰的结构与更快的构建速度：
- 入口文件只有 `nndl-ebook.tex`，保持最小化配置。
- 全局排版、字体与包设置集中在 `main.tex`。
- 图片在 `images/` 中单独构建并缓存为 PDF，避免每次编译都跑 TikZ。
- 字体选择使用多系统回退策略，保证 Fedora/macOS/Windows 都能构建。

## 结构分析

主要文件与目录：
- `nndl-ebook.tex`：编译入口，设置文档类与页面尺寸。
- `main.tex`：全局排版与包配置，禁止直接编译。
- `chapters/chap1.tex` ... `chapters/chap6.tex`：章节内容。
- `frontmatter/title.tex`、`frontmatter/copyright.tex`：标题与版权页。
- `frontmatter/preface.tex`、`frontmatter/about.tex`、`frontmatter/author.tex`、`frontmatter/acknowledgements.tex`：前置内容。
- `appendix/translation.tex`、`appendix/sai.tex`、`appendix/history.tex`：附录内容。
- `supplements/glossaries.tex`：术语表定义。
- `supplements/snippets/`：小片段/通用宏。
- `config/localization.tex`：本地化入口。
- `config/fonts.tex`：字体方案选择与 CJK 开关。
- `config/typography.tex`：标题样式与中文断行。
- `config/cjkfonts.sty`、`config/westernfonts.tex`：中英文字体选择与回退。
- `cjkfonts.sty`：加载 `config/cjkfonts.sty` 的包装文件。
- `config/figures.tex`：pgfplots 配置与图形宏。
- `images/`：图片源文件与生成的 PDF。
- `code_samples/`：代码样例子模块。
- `Makefile`：构建入口与清理目标。
- `BUILDING.md`：更详细的构建说明。

## 字体

默认使用多系统回退策略：
- 优先：Noto CJK + Source Serif Pro + Source Code Pro
- 备用：TeX Live 自带的 Latin Modern 和 Fandol

若需更好的排版效果，可安装：
- Noto CJK 字体
- Source Serif Pro
- Source Code Pro

## 排错

- 图片缺失：执行 `make -C images`
- 引用异常：再次执行 `make`
- 字体警告：安装 Noto CJK 以获得完整中文字体支持

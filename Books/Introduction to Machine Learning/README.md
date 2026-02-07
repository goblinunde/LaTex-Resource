# Introduction to Machine Learning (LaTeX Project)

**项目简介**
本仓库是《Introduction to Machine Learning》的 LaTeX 项目，编译产物为 `machine_learning.pdf`。内容来自课程讲义与章节文件，主入口为 `machine_learning.tex`。

**用途**
用于生成课程讲义/教材级别的机器学习笔记 PDF。

**编译方式**
```bash
latexmk -C
latexmk -pdf -interaction=nonstopmode -file-line-error machine_learning.tex
```

**依赖**
- TeX Live 2025
- latexmk
- 主要宏包：`kpfonts`, `yfonts`, `mathalfa`, `mathtools`, `ntheorem`, `cleveref`, `enumitem`, `graphicx`, `fancyhdr`, `geometry`, `natbib`, `tikz`

**Fedora 安装示例**
```bash
sudo dnf install \
  texlive-scheme-medium \
  texlive-kpfonts texlive-yfonts texlive-mathalpha texlive-mathtools \
  texlive-ntheorem texlive-cleveref texlive-enumitem texlive-graphics \
  texlive-fancyhdr texlive-geometry texlive-natbib texlive-pgf latexmk
```

**作者信息**
- Laurent Younes

**许可证**
- 未在仓库中明确说明许可信息。

---

**Project Overview**
This repository contains the LaTeX sources for *Introduction to Machine Learning*, producing `machine_learning.pdf`. The main entry point is `machine_learning.tex`.

**Purpose**
Build a textbook/lecture-notes PDF for a machine learning course.

**Build**
```bash
latexmk -C
latexmk -pdf -interaction=nonstopmode -file-line-error machine_learning.tex
```

**Dependencies**
- TeX Live 2025
- latexmk
- Key packages: `kpfonts`, `yfonts`, `mathalfa`, `mathtools`, `ntheorem`, `cleveref`, `enumitem`, `graphicx`, `fancyhdr`, `geometry`, `natbib`, `tikz`

**Fedora Install Example**
```bash
sudo dnf install \
  texlive-scheme-medium \
  texlive-kpfonts texlive-yfonts texlive-mathalpha texlive-mathtools \
  texlive-ntheorem texlive-cleveref texlive-enumitem texlive-graphics \
  texlive-fancyhdr texlive-geometry texlive-natbib texlive-pgf latexmk
```

**Author**
- Laurent Younes

**License**
- Not specified in this repository.

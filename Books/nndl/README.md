# Another Chinese Translation of Neural Networks and Deep Learning

This is another (work in progress) Chinese translation of Michael Nielsen's
[Neural Networks and Deep Learning](http://neuralnetworksanddeeplearning.com/),
originally my learning notes of this free online book. It's written in
LaTeX for better look and cross-referencing of math equations and plots. And I
borrowed some finished work from
https://github.com/tigerneil/neural-networks-and-deep-learning-zh-cn.

## Build the LaTeX Source Code

This project targets XeLaTeX with CJK support. Please ensure a recent TeX
distribution is installed on your system.

Recommended:
- Tex Live 2015+ (Linux)
- MacTeX 2015+ (macOS)

### Check out source code

Use git to clone this repository and the code samples as a sub module:

```shell
$ git clone --recursive https://github.com/zhanggyb/nndl.git
```

or

```shell
$ git clone https://github.com/zhanggyb/nndl.git
$ cd nndl
$ git submodule update --init --recursive
```

### Fonts (Cross-Platform)

The build uses a multi-system font fallback:
- Preferred (when available): Noto CJK + Source Serif Pro + Source Code Pro
- Fallbacks: Latin Modern (TeX Live) and Fandol (TeX Live)

If you want the best typography, install the preferred fonts:
- Google Noto CJK
- Adobe Source Serif Pro
- Adobe Source Code Pro

### Generate PDF

1) Build images (TikZ + EPS -> PDF):
```shell
$ make -C images
```

2) Build the book (run twice for stable references):
```shell
$ make
$ make
```

Important: do not compile `main.tex` directly. It is a preamble file and will
produce a broken `main.pdf`. Always compile `nndl-ebook.tex` (or run `make`).

### Make Targets

- `make ebook`: build the ebook profile (same as default)
- `make print`: build with `\nndlprinttrue` (twoside + openright)

### Build Profiles (Optional)

`nndl-ebook.tex` supports simple build profiles:
- `\nndlprinttrue`: print-style layout (twoside + openright)
- `\nndldrafttrue`: draft build (silence layout warnings)

Edit `nndl-ebook.tex` and uncomment the desired switches near the top.

### Page & Typography Options (Optional)

You can customize paper size, margins, font scheme, and title style near the top
of `nndl-ebook.tex`:
- Paper size: `\def\nndlPaper{a4paper}` or `letterpaper`
- Margins: `\def\nndlGeometry{...}` (any valid geometry settings)
- Font scheme: `\def\nndlFontScheme{auto}` (`auto | noto | fandol | western`)
- Title style: `\def\nndlTitleStyle{classic}` (`classic | dual`, dual adds an English subtitle line)

Note: `western` disables CJK fonts and is only suitable for Latin-only output.

## Project Analysis

This repository is a clean, reproducible LaTeX pipeline for a Chinese
translation of "Neural Networks and Deep Learning". It separates concerns
into a small, stable entry file (`nndl-ebook.tex`) and a reusable preamble
(`main.tex`) that hosts the layout, packages, and language settings.

The build flow is intentionally split:
- `images/` builds all TikZ/EPS assets once into PDF for fast re-compiles.
- The book is compiled with XeLaTeX to support CJK fonts and proper Unicode.
- Glossaries are generated as part of the `make` pipeline when enabled.

Font handling is cross-platform by design: the build tries best-effort matches
for commonly available fonts and falls back to TeX Live defaults if needed.

## Structure Analysis

Key layout and content components:
- `nndl-ebook.tex`: entry point for compilation; set class/options here.
- `main.tex`: preamble and global configuration; do not compile directly.
- `chapters/chap1.tex` ... `chapters/chap6.tex`: chapter sources.
- `frontmatter/title.tex`, `frontmatter/copyright.tex`: title and copyright.
- `frontmatter/preface.tex`, `frontmatter/about.tex`, `frontmatter/author.tex`, `frontmatter/acknowledgements.tex`: front matter.
- `appendix/translation.tex`, `appendix/sai.tex`, `appendix/history.tex`: appendices.
- `supplements/glossaries.tex`: glossary entries and setup.
- `supplements/snippets/`: small LaTeX fragments or reusable bits.
- `config/localization.tex`: localization entry point.
- `config/fonts.tex`: font scheme selection and CJK toggles.
- `config/typography.tex`: section styles and CJK line breaking.
- `config/cjkfonts.sty`, `config/westernfonts.tex`: font selection and fallback logic.
- `cjkfonts.sty`: wrapper to load `config/cjkfonts.sty`.
- `config/figures.tex`: pgfplots settings and figure helpers.
- `images/`: TikZ/EPS sources and generated PDFs.
- `code_samples/`: external code samples (submodule or separate clone).
- `Makefile`: build targets (`make`, `make clean`, `make cleanall`).
- `BUILDING.md`: detailed build instructions and Fedora notes.

For Chinese instructions, see `README_ch.md`.

### Code Samples

The code samples are stored in a separate repository:
```shell
$ git clone https://github.com/mnielsen/neural-networks-and-deep-learning.git code_samples
```

### Troubleshooting

- If you see missing images, run `make -C images`.
- If references look wrong, run `make` again.
- For full CJK fonts, install Noto CJK.

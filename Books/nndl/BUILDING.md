# Building

This project is designed for XeLaTeX with CJK support.

## Prerequisites

- A recent TeX distribution with XeLaTeX and glossaries support
- CJK fonts (best results with Noto CJK)
- Optional: Source Serif Pro / Source Code Pro for western text and code

Font fallback is configured, so the build will still work if the preferred
fonts are missing.

## Build Steps

1) Generate images (TikZ and EPS conversion):
```shell
make -C images
```

2) Build the book (run twice for references):
```shell
make
make
```

Note: Do not compile `main.tex` directly. It is a shared preamble and will
produce a broken `main.pdf`. Always compile `nndl-ebook.tex` (or run `make`).

## Code Samples

If you want embedded code listings, clone the sample repo into `code_samples/`:
```shell
git clone https://github.com/mnielsen/neural-networks-and-deep-learning.git code_samples
```

## Notes

- If you edit content and references look wrong, run `make` again.
- Glossaries use `makeindex` by default (no xindy required).

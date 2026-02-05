# Real Analysis Problem Set / 实分析习题课讲义

[![License](https://img.shields.io/badge/license-LPPL--1.3c-blue.svg)](License)
[![LaTeX](https://img.shields.io/badge/LaTeX-XeLaTeX-green.svg)](https://www.latex-project.org/)
[![Template](https://img.shields.io/badge/Template-ElegantBook-orange.svg)](https://github.com/ElegantLaTeX/ElegantBook)

[中文版](README-CN.md)

---

## Introduction

This is an open-source Real Analysis problem set with LaTeX source code. You can download, edit, and compile the `.tex` files to create your own customized problem set.

**Author**: kumiko ∈ 𝓜aki's 𝓛ab  
**Source**: [GitHub Repository](https://github.com/kumiko-euphonium/Real-Analysis-Problem-Set-LaTeX)

## Project Structure

```
Real-Analysis-Problem-Set-LaTeX/
├── main.tex                 # Main entry file
├── macros.tex               # Custom LaTeX commands
├── prologue.tex             # Prologue and references
├── elegantbook.cls          # ElegantBook template
├── reference.bib            # Bibliography
├── 0 preliminary/           # Chapter 0: Preliminaries
│   ├── set_and_function.tex
│   └── analysis_technique.tex
├── 1 measure/               # Chapter 1: Lebesgue Measure
│   ├── Lebesgue_meas.tex
│   ├── nonmeasurable_sets.tex
│   ├── Borel_to_Lebesgue.tex
│   ├── Brunn-Minkowski.tex
│   └── meas_and_transform.tex
├── 2 integration/           # Chapter 2: Measurable Functions & Integration
│   ├── 2 measurable_functions.tex
│   ├── DCT.tex
│   ├── 4 L1 space.tex
│   ├── 5 Littlewood_three_principles.tex
│   ├── 6 modes_of_convergence.tex
│   └── meas_and_integration.tex
├── 3 differentiation/       # Chapter 3: Differentiation
│   ├── 1 BV_functions.tex
│   └── 2 abs_cts_functions.tex
├── abstract measure/        # Chapter 4: Abstract Measure & Integration
│   ├── 1 abstract_measure.tex
│   └── 2 abstract_integration.tex
├── figure/                  # Figures and cover images
└── image/                   # Additional images
```

## Compilation

### Requirements

- **TeX Distribution**: TeX Live 2022 or later (recommended)
- **Compiler**: XeLaTeX (required for Chinese support)
- **Bibliography**: Biber

### Local Compilation

```bash
# Using latexmk (recommended)
latexmk -xelatex -f main.tex

# Or manually compile with XeLaTeX
xelatex main.tex
biber main
xelatex main.tex
xelatex main.tex
```

### Overleaf

1. Download the ZIP file from the repository
2. Import the project in Overleaf
3. Set the compiler to **XeLaTeX** in project settings
4. Compile

## Contents

The problem set covers the following topics:

1. **Preliminaries** - Set theory, functions, and analysis techniques
2. **Lebesgue Measure** - Construction, properties, non-measurable sets, Brunn-Minkowski inequality
3. **Measurable Functions & Lebesgue Integration** - DCT, L¹ space, Littlewood's three principles, modes of convergence
4. **Differentiation** - BV functions, absolutely continuous functions
5. **Abstract Measure & Integration** - General measure spaces and integration theory

## References

Problems are selected from:

- *Princeton Lectures in Analysis* (Stein)
- *Real Analysis* (Folland)
- *实变函数论* (周民强)
- *Probability: Theory and Examples* (Durrett)
- *Classical and Multilinear Harmonic Analysis* (Muscalu & Schlag)
- UW-Madison Analysis Qualifying Exams

## License

- **Content**: For educational purposes only. **Not for commercial use.**
- **Template**: [ElegantBook](https://github.com/ElegantLaTeX/ElegantBook) is released under LPPL-1.3c.

## Acknowledgement

Thanks to the ElegantBook team ([Dongsheng Deng](https://ddswhu.me/) & [Liam Huang](https://liam.page/)) for the beautiful LaTeX template.

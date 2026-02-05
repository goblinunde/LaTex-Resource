# 实分析习题课讲义

[![License](https://img.shields.io/badge/license-LPPL--1.3c-blue.svg)](License)
[![LaTeX](https://img.shields.io/badge/LaTeX-XeLaTeX-green.svg)](https://www.latex-project.org/)
[![Template](https://img.shields.io/badge/Template-ElegantBook-orange.svg)](https://github.com/ElegantLaTeX/ElegantBook)

[English](README.md)

---

## 简介

这是一份开源的实分析习题集，提供完整的 LaTeX 源代码。你可以直接下载、编辑 `.tex` 文件，创造出属于自己的习题集。

**作者**: kumiko ∈ 𝓜aki's 𝓛ab  
**仓库**: [GitHub](https://github.com/kumiko-euphonium/Real-Analysis-Problem-Set-LaTeX)  
**视频**: [Bilibili](https://space.bilibili.com/391930545/channel/collectiondetail?sid=1055062)

## 项目结构

```
Real-Analysis-Problem-Set-LaTeX/
├── main.tex                 # 主入口文件
├── macros.tex               # 自定义 LaTeX 命令
├── prologue.tex             # 前言与参考资料
├── elegantbook.cls          # ElegantBook 模板
├── reference.bib            # 参考文献
├── 0 preliminary/           # 第0章：预备知识
├── 1 measure/               # 第1章：勒贝格测度
├── 2 integration/           # 第2章：可测函数与勒贝格积分
├── 3 differentiation/       # 第3章：函数的微分
├── abstract measure/        # 第4章：抽象测度与积分
├── figure/                  # 封面图片
└── image/                   # 其他图片
```

## 编译方法

### 环境要求

- **TeX 发行版**: TeX Live 2022 或更新版本（推荐）
- **编译器**: XeLaTeX（中文支持必需）
- **参考文献**: Biber

### 本地编译

```bash
# 使用 latexmk（推荐）
latexmk -xelatex -f main.tex

# 或手动编译
xelatex main.tex
biber main
xelatex main.tex
xelatex main.tex
```

### Overleaf 在线编译

1. 将本仓库的 ZIP 文件下载
2. 在 Overleaf 中导入项目
3. **重要**：在项目设置中将编译器选择为 **XeLaTeX**
4. 点击编译

## 内容概要

本习题集涵盖以下主题：

| 章节 | 内容 |
|:---:|:---|
| 第0章 | 预备知识：集合论、函数、分析技巧 |
| 第1章 | 勒贝格测度：构造、性质、不可测集、Brunn-Minkowski 不等式 |
| 第2章 | 可测函数与积分：DCT、L¹ 空间、Littlewood 三原则、收敛模式 |
| 第3章 | 函数的微分：BV 函数、绝对连续函数 |
| 第4章 | 抽象测度与积分：一般测度空间与积分理论 |

## 自定义命令

本项目使用了大量自定义命令，位于 `macros.tex` 中。如果你要基于本项目创建自己的讲义，请保留此文件以确保内容正常编译，同时可以添加自己喜欢的命令。

## 参考资料

习题取材自：

- **经典教材**
  - *Princeton Lectures in Analysis* (Stein)
  - *Real Analysis* (Folland)
  - *实变函数论* (周民强)
  - *Probability: Theory and Examples* (Durrett)
  - *Classical and Multilinear Harmonic Analysis* (Muscalu & Schlag)

- **UW-Madison 博士资格考试**
  - [往年试卷](https://uwmadison.app.box.com/v/analysis-realanalysis)
  - [2022 夏季强化班讲义](https://jdjake.github.io/notes.html) (Jacob Denson)

## 学习资源

- **Folland 习题解答**: 搜索 "real analysis Folland solution + 章节"
- **𝓜aki's 𝓛ab 实分析讲义**: [maki-math.com](https://www.maki-math.com/#/courses/74)
- **Claudio Landim 测度论**: [Bilibili](https://www.bilibili.com/video/BV1EW411K7dN)

## 许可协议

- **内容**: 仅供学习使用，**请勿用于盈利及任何商业用途**
- **模板**: [ElegantBook](https://github.com/ElegantLaTeX/ElegantBook) 采用 LPPL-1.3c 协议

## 致谢

感谢 ElegantBook 团队 ([Dongsheng Deng](https://ddswhu.me/) & [Liam Huang](https://liam.page/)) 提供优雅的 LaTeX 模板！

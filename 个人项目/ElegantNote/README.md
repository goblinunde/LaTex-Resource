<!-- Author: Dongsheng Deng -->
<!-- Email: ddswhu@outlook.com -->

# ElegantNote

[Homepage](https://elegantlatex.org/) | [Github](https://github.com/ElegantLaTeX/ElegantNote) | [CTAN](https://ctan.org/pkg/elegantnote) | [Download](https://github.com/ElegantLaTeX/ElegantNote/releases) | [Wiki](https://github.com/ElegantLaTeX/ElegantNote/wiki) | [Weibo](https://weibo.com/elegantlatex)

![License](https://img.shields.io/ctan/l/elegantnote.svg)
![CTAN Version](https://img.shields.io/ctan/v/elegantnote.svg)
![Github Version](https://img.shields.io/github/release/ElegantLaTeX/ElegantNote.svg)
![Repo Size](https://img.shields.io/github/repo-size/ElegantLaTeX/ElegantNote.svg)

ElegantNote is designed for Notes. Just enjoy it! If you have any questions, suggestions or bug reports, you can create issues, pull requests or email us at <elegantlatex2e@gmail.com>.

设计 ElegantNote 是为了方便记录笔记和阅读笔记。如果你有其他问题、建议或者报告 bug，可以提交 issues 或者给我们发邮件：<elegantlatex2e@gmail.com>。

---

## 📐 实变函数笔记 (Real Analysis Notes)

本仓库包含一份完整的 **实变函数笔记** (`real-analysis-notes.tex`)，基于 ElegantNote 模板制作，涵盖测度论与积分论的核心内容。

### 📖 笔记目录

| 章节 | 主要内容 |
|------|----------|
| **1. 集合** | 集合运算、对等与基数、可数/不可数集合 |
| **2. 点集** | 度量空间、聚点/内点/界点、开集/闭集/紧集、康托尔三分集 |
| **3. 测度论** | 外测度、可测集、σ代数、Borel代数、Vitali不可测集 |
| **4. 可测函数** | 可测函数性质、叶戈罗夫定理、卢津定理、依测度收敛 |
| **5. 积分论** | 黎曼/勒贝格积分、Levi定理、Fatou引理、控制收敛定理、富比尼定理 |
| **6. 微分与不定积分** | 维塔利定理、有界变差函数、绝对连续函数、斯蒂尔切斯积分 |

### ✨ 笔记特色

- **12个详细例题**：包含完整证明过程
- **TikZ 图形**：康托尔三分集可视化
- **严谨定义**：定义、定理、例题环境清晰分明
- **30页内容**：涵盖实变函数课程核心知识点

```bash
# 编译笔记
xelatex real-analysis-notes.tex
xelatex real-analysis-notes.tex  # 运行两次获得完整目录
```

---

## 📚 LaTeX 数学符号与语法快速参考教程

本仓库包含一份基于 ElegantNote 模板制作的 **LaTeX 数学符号与语法快速参考教程** (`latex-tutorial.tex`)，是学习和查阅 LaTeX 数学排版的实用指南。

### ✨ 教程特色

- **前言引导**：介绍教程目的和使用方式，帮助读者快速上手
- **自然过渡**：各章节间有衔接文字，内容逻辑清晰连贯
- **丰富对比展示**：
  - 行内模式 vs 行间模式显示效果对比
  - 希腊字母标准形式与变体形式对照
  - 6 种矩阵环境效果一览表
  - 大型运算符多维度对比
- **专业排版**：使用 `booktabs` 表格、`infobox` 提示框、Font Awesome 图标
- **实用示例**：涵盖数学公式、TikZ 绘图、PGFPlots 函数图、神经网络可视化

### 📖 教程目录

1. **入门** - 数学模式基础、行内/行间公式
2. **希腊字母** - 小写、大写、变体形式
3. **上下标与修饰符号** - 幂指数、重音符号
4. **分数与根号** - 多种分数写法、根号语法
5. **运算符** - 二元运算符、大型运算符
6. **关系符号** - 等式/不等式、集合论、逻辑符号
7. **括号与分隔符** - 自动/手动大小调整
8. **矩阵与数组** - 各种矩阵环境
9. **常用数学环境** - equation、align、cases
10. **注解与标注** - 删除线、方框、括号标注
11. **常用数学函数** - 预定义函数名
12. **高级数学主题** - 泛函分析、神经网络符号
13. **TikZ 绘图** - 基本图形、节点、神经网络可视化
14. **Font Awesome 图标** - 常用图标速查
15. **LaTeX3 编程** - expl3 基础、xparse 命令

### 🔧 编译方式

使用 Makefile 管理编译：

```bash
make          # 编译 LaTeX 教程
make tutorial # 编译 LaTeX 教程（同上）
make docs     # 编译官方文档 (cn/en)
make clean    # 清理辅助文件
make distclean# 深度清理（包括 PDF）
make watch    # 监视文件变化自动编译
make help     # 显示帮助信息
```

或直接使用 XeLaTeX：

```bash
xelatex latex-tutorial.tex
```

### 📦 增强功能（elegantnote.cls 扩展）

模板类文件已扩展以下现代 LaTeX 功能：

| 功能 | 宏包 | 说明 |
|------|------|------|
| 绘图 | `tikz` | 矢量图形、节点图、流程图 |
| 数据可视化 | `pgfplots` | 函数图、数据图表 |
| 图标 | `fontawesome5` | 上千个矢量图标 |
| 现代编程 | `expl3`, `xparse` | LaTeX3 编程支持 |

### 🚀 自动构建 (GitHub Actions)

每次推送到 `main` 分支时，GitHub Actions 会自动：

1. 使用 XeLaTeX 编译文档
2. 上传 PDF 到 Artifacts
3. 更新 `latest` Release 预发布版

**发布正式版本**：

```bash
git tag v1.0.0
git push origin v1.0.0
```

推送 tag 后会自动创建正式 Release 并附带 PDF。

[![Build Status](https://github.com/goblinunde/ElegantNote/actions/workflows/build-latex.yml/badge.svg)](https://github.com/goblinunde/ElegantNote/actions)
[![Latest Release](https://img.shields.io/github/v/release/goblinunde/ElegantNote?include_prereleases)](https://github.com/goblinunde/ElegantNote/releases/latest)

---

# License

This work is released under the LaTeX Project Public License, v1.3c or later.

本模板发布遵循 LaTeX 项目公共许可证 1.3 c 或更高版本。

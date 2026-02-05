# pkuthss: 北京大学学位论文 LaTeX 模板

[![Build & Test](https://github.com/CasperVector/pkuthss/actions/workflows/build.yml/badge.svg)](https://github.com/CasperVector/pkuthss/actions/workflows/build.yml)
[![License](https://img.shields.io/badge/license-LPPL%201.3-blue.svg)](https://www.latex-project.org/lppl/)
[![TeX Live](https://img.shields.io/badge/TeX%20Live-2023+-green.svg)](https://tug.org/texlive/)
[![Version](https://img.shields.io/badge/version-1.9.4-orange.svg)](https://github.com/CasperVector/pkuthss/releases)

一个简洁、清晰、灵活的北京大学学位论文 LaTeX 模板。

- **维护者**: Casper Ti. Vector <CasperVector@gmail.com>
- **主页**: <https://gitea.com/CasperVector/pkuthss>

## 📦 快速开始

### 1. 安装 TeX Live

| 操作系统 | 安装命令 |
|----------|----------|
| **Windows** | 下载 [TeX Live](https://tug.org/texlive/) 安装包 |
| **macOS** | `brew install --cask mactex` |
| **Fedora** | `sudo dnf install texlive-scheme-full` |
| **Ubuntu/Debian** | `sudo apt install texlive-full` |
| **Arch Linux** | `sudo pacman -S texlive` |

### 2. 编译示例论文

```bash
cd doc/example
latexmk -xelatex thesis.tex
```

或使用 Makefile：

```bash
make           # 编译示例论文
make preview   # 编译并预览
make watch     # 监视模式自动编译
```

## 🛠️ 构建命令

运行 `make help` 查看所有可用命令：

```
╔══════════════════════════════════════════════════════════════════╗
║               pkuthss 构建系统 v1.9.4                            ║
╠══════════════════════════════════════════════════════════════════╣
║  本地开发:                                                        ║
║    make              编译示例论文 (thesis.pdf)                    ║
║    make doc          编译文档 (pkuthss.pdf)                       ║
║    make all          编译所有文档                                 ║
║    make preview      编译并预览 PDF                               ║
║    make watch        监视文件变化自动编译                         ║
║    make test         测试编译（验证模板可用性）                   ║
╠══════════════════════════════════════════════════════════════════╣
║  发布相关:                                                        ║
║    make dist         构建 CTAN 发布包                             ║
║    make release V=x.y.z  发布新版本                               ║
╠══════════════════════════════════════════════════════════════════╣
║  清理:                                                            ║
║    make clean        清理编译临时文件                             ║
║    make distclean    完全清理                                     ║
╚══════════════════════════════════════════════════════════════════╝
```

## 🖥️ 跨平台字体支持

本模板支持 **自动字体检测**，适配 Windows、macOS 和 Linux：

| 操作系统 | 宋体 | 黑体 | 楷体 | 仿宋 |
|----------|------|------|------|------|
| **Windows** | SimSun | SimHei | KaiTi | FangSong |
| **macOS** | Songti SC | Heiti SC | Kaiti SC | STFangsong |
| **Linux** | Noto Serif CJK SC | Noto Sans CJK SC | STKaiti / Noto | Noto Sans CJK SC |

### Linux 字体安装

```bash
# Fedora
sudo dnf install google-noto-cjk-fonts-common google-noto-serif-cjk-fonts

# Ubuntu/Debian
sudo apt install fonts-noto-cjk fonts-noto-cjk-extra

# Arch Linux
sudo pacman -S noto-fonts-cjk
```

## 📁 目录结构

```
pkuthss-master/
├── .github/workflows/    # GitHub Actions CI/CD
│   ├── build.yml         # 多平台构建测试
│   └── release.yml       # 自动发布
├── doc/
│   ├── example/          # 示例论文
│   └── readme/           # 文档源码
├── scripts/
│   └── release.sh        # 版本发布脚本
├── tex/                  # 模板类文件
├── Makefile              # 构建系统
├── CHANGELOG.md          # 变更日志
└── README.md
```

## 🚀 CI/CD

本项目使用 GitHub Actions 进行持续集成：

- **构建测试**: 每次推送自动在 Windows/macOS/Linux 三平台测试编译
- **自动发布**: 推送 tag 时自动构建并创建 GitHub Release

### 发布新版本

```bash
# 方法 1: 使用 Makefile
make release V=1.9.5

# 方法 2: 使用脚本
./scripts/release.sh 1.9.5

# 推送到远程
git push origin master
git push origin v1.9.5
```

### 启用 GitHub Actions

workflow 文件以 `.example` 后缀提供，需要手动启用：

```bash
cd .github/workflows
cp build.yml.example build.yml
cp release.yml.example release.yml
git add -A && git commit -m "chore: enable GitHub Actions"
git push
```

## 📖 使用说明

### 基本配置

在 `thesis.tex` 中设置论文信息：

```latex
\pkuthssinfo{
    cthesisname = {博士学位论文}, ethesisname = {Doctor Thesis},
    ctitle = {论文标题}, etitle = {Thesis Title},
    cauthor = {作者姓名}, eauthor = {Author Name},
    date = {2024年6月},
    studentid = {2000000000}, school = {某某学院},
    cmajor = {某某专业}, emajor = {Some Major},
    cmentor = {导师姓名}, ementor = {Mentor Name},
    ckeywords = {关键词1，关键词2},
    ekeywords = {keyword1, keyword2},
}
```

### 引用格式

```latex
\cite{ref-key}        % 未格式化引用
\parencite{ref-key}   % 带方括号引用
\supercite{ref-key}   % 上标引用
```

## 🔧 常见问题

### 1. 字体找不到

确保安装了中文字体，参考上文「跨平台字体支持」。

### 2. 参考文献不显示

```bash
xelatex thesis.tex
biber thesis
xelatex thesis.tex
xelatex thesis.tex
```

或使用 `make` / `latexmk -xelatex thesis.tex`。

### 3. 查看详细文档

```bash
texdoc pkuthss
texdoc biblatex-caspervector
```

## 📜 许可证

- `copy.tex` 和 `origin.tex`: New BSD License
- `tex/` 和 `doc/readme/`: [LPPL 1.3+](https://www.latex-project.org/lppl/)
- 其他文件: Public Domain

---

> 📚 完整文档请查看编译生成的 `pkuthss.pdf` 或运行 `texdoc pkuthss`。

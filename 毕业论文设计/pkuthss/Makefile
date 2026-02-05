# pkuthss 构建系统
# Copyright (c) 2011-2014,2019 Casper Ti. Vector
# Enhanced by SMLYFM <yytcjx@gmail.com> 2026
# Public domain.

# ============================================
# 配置变量
# ============================================
TITLE     := pkuthss
EXAMPLE   := thesis
VERSION   := 1.9.4

# 目录
DOC_DIR   := doc
EXAMPLE_DIR := $(DOC_DIR)/example
README_DIR  := $(DOC_DIR)/readme
TEX_DIR   := tex
SCRIPTS_DIR := scripts

# 工具
LATEXMK   := latexmk
LATEX_ENGINE := -xelatex
RM        := rm -rf
CP        := cp -a
MD        := mkdir -p
ZIP       := zip -rT

# 跨平台检测
ifeq ($(OS),Windows_NT)
    DETECTED_OS := Windows
    OPEN_CMD := start
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        DETECTED_OS := Linux
        OPEN_CMD := xdg-open
    endif
    ifeq ($(UNAME_S),Darwin)
        DETECTED_OS := macOS
        OPEN_CMD := open
    endif
endif

# ============================================
# 帮助信息（默认目标）
# ============================================
.PHONY: help
help:
	@echo "╔══════════════════════════════════════════════════════════════════╗"
	@echo "║               pkuthss 构建系统 v$(VERSION)                          ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║  本地开发:                                                        ║"
	@echo "║    make              编译示例论文 (thesis.pdf)                    ║"
	@echo "║    make doc          编译文档 (pkuthss.pdf)                       ║"
	@echo "║    make all          编译所有文档                                 ║"
	@echo "║    make preview      编译并预览 PDF                               ║"
	@echo "║    make watch        监视文件变化自动编译                         ║"
	@echo "║    make test         测试编译（验证模板可用性）                   ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║  发布相关:                                                        ║"
	@echo "║    make dist         构建 CTAN 发布包                             ║"
	@echo "║    make release V=x.y.z  发布新版本（更新版本号+tag）             ║"
	@echo "║    make changelog    生成变更日志                                 ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║  质量保证:                                                        ║"
	@echo "║    make qa           运行质量检查                                 ║"
	@echo "║    make lint         检查 LaTeX 语法                              ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║  清理:                                                            ║"
	@echo "║    make clean        清理编译临时文件                             ║"
	@echo "║    make distclean    完全清理（包括发布包）                       ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║  检测到的操作系统: $(DETECTED_OS)                                     ║"
	@echo "╚══════════════════════════════════════════════════════════════════╝"

# ============================================
# 本地开发工具
# ============================================

# 默认目标：编译示例论文
.PHONY: default
default: example

# 编译示例论文
.PHONY: example
example:
	@echo "📄 编译示例论文..."
	cd $(EXAMPLE_DIR) && $(LATEXMK) $(LATEX_ENGINE) $(EXAMPLE).tex
	@echo "✅ 编译完成: $(EXAMPLE_DIR)/$(EXAMPLE).pdf"

# 编译文档
.PHONY: doc
doc:
	@echo "📚 编译文档..."
	cd $(README_DIR) && $(LATEXMK) $(LATEX_ENGINE) $(TITLE).tex
	@echo "✅ 编译完成: $(README_DIR)/$(TITLE).pdf"

# 编译所有
.PHONY: all
all: example doc
	@echo "🎉 所有文档编译完成！"

# 预览 PDF
.PHONY: preview
preview: example
	@echo "👁️ 打开 PDF 预览..."
	$(OPEN_CMD) $(EXAMPLE_DIR)/$(EXAMPLE).pdf

# 监视模式自动编译
.PHONY: watch
watch:
	@echo "👀 监视模式启动，按 Ctrl+C 退出..."
	cd $(EXAMPLE_DIR) && $(LATEXMK) $(LATEX_ENGINE) -pvc $(EXAMPLE).tex

# 测试编译（验证模板可用性）
.PHONY: test
test:
	@echo "🧪 测试编译..."
	@cd $(EXAMPLE_DIR) && $(LATEXMK) $(LATEX_ENGINE) -interaction=nonstopmode $(EXAMPLE).tex > /dev/null 2>&1 \
		&& echo "✅ 示例论文编译通过" \
		|| (echo "❌ 示例论文编译失败" && exit 1)
	@cd $(README_DIR) && $(LATEXMK) $(LATEX_ENGINE) -interaction=nonstopmode $(TITLE).tex > /dev/null 2>&1 \
		&& echo "✅ 文档编译通过" \
		|| (echo "❌ 文档编译失败" && exit 1)
	@echo "🎉 所有测试通过！"

# ============================================
# 质量保证
# ============================================

.PHONY: qa
qa:
	@echo "🔍 运行质量检查..."
	utils/qa

.PHONY: lint
lint:
	@echo "🔍 检查 LaTeX 语法..."
	@if command -v chktex > /dev/null 2>&1; then \
		chktex -q $(EXAMPLE_DIR)/$(EXAMPLE).tex; \
		echo "✅ 语法检查完成"; \
	else \
		echo "⚠️ chktex 未安装，跳过语法检查"; \
	fi

# ============================================
# 发布相关
# ============================================

# 构建 CTAN 发布包
.PHONY: dist
dist:
	@echo "📦 构建发布包..."
	utils/dist TITLE=$(TITLE) EXAMPLE=$(EXAMPLE) VERSION=$(VERSION) dist
	@echo "✅ 发布包已生成: $(TITLE)-$(VERSION).zip"

# 版本发布（需要指定版本号：make release V=1.9.5）
.PHONY: release
release:
ifndef V
	$(error ❌ 请指定版本号，例如: make release V=1.9.5)
endif
	@echo "🚀 发布版本 v$(V)..."
	@if [ -f "$(SCRIPTS_DIR)/release.sh" ]; then \
		bash $(SCRIPTS_DIR)/release.sh $(V); \
	else \
		echo "⚠️ 发布脚本不存在，执行基本发布流程..."; \
		sed -i 's/VERSION   := .*/VERSION   := $(V)/' Makefile; \
		git add -A; \
		git commit -m "chore: release v$(V)"; \
		git tag -a "v$(V)" -m "Release v$(V)"; \
		echo "✅ 已创建 tag v$(V)，请使用 git push --tags 推送"; \
	fi

# 生成变更日志
.PHONY: changelog
changelog:
	@echo "📝 生成变更日志..."
	@if command -v git-cliff > /dev/null 2>&1; then \
		git-cliff --output CHANGELOG.md; \
		echo "✅ CHANGELOG.md 已更新"; \
	elif command -v conventional-changelog > /dev/null 2>&1; then \
		conventional-changelog -p angular -i CHANGELOG.md -s; \
		echo "✅ CHANGELOG.md 已更新"; \
	else \
		echo "📋 最近的 Git 提交:"; \
		git log --oneline -20; \
		echo ""; \
		echo "⚠️ 建议安装 git-cliff 自动生成 changelog: cargo install git-cliff"; \
	fi

# 版本号更新（内部使用）
.PHONY: bump
bump:
	utils/bump VERSION=$(VERSION)

# ============================================
# 清理
# ============================================

.PHONY: clean
clean:
	@echo "🧹 清理编译临时文件..."
	cd $(EXAMPLE_DIR) && $(LATEXMK) -C
	cd $(README_DIR) && $(LATEXMK) -C
	$(RM) $(EXAMPLE_DIR)/*.xdv $(README_DIR)/*.xdv
	$(RM) $(EXAMPLE_DIR)/*.bbl-SAVE-ERROR $(EXAMPLE_DIR)/*.bcf-SAVE-ERROR
	@echo "✅ 清理完成"

.PHONY: distclean
distclean: clean
	@echo "🧹 完全清理..."
	utils/dist TITLE=$(TITLE) EXAMPLE=$(EXAMPLE) VERSION=$(VERSION) distclean
	$(RM) $(TITLE).tds.zip $(TITLE)-$(VERSION).zip
	$(RM) dir-ctan/ dir-tds/ tex-dist/ doc-dist/
	@echo "✅ 完全清理完成"

# ============================================
# CI/CD 辅助目标
# ============================================

# CI 构建（用于 GitHub Actions）
.PHONY: ci-build
ci-build:
	@echo "🤖 CI 构建开始..."
	$(MAKE) all
	@echo "✅ CI 构建完成"

# CI 测试
.PHONY: ci-test
ci-test:
	@echo "🤖 CI 测试开始..."
	$(MAKE) test
	@echo "✅ CI 测试完成"

# 打印版本信息
.PHONY: version
version:
	@echo "$(VERSION)"

# vim:ts=4:sw=4:noet

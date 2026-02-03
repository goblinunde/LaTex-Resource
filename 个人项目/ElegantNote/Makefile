# Makefile for ElegantNote LaTeX Project
# Author: SMLYFM <yytcjx@gmail.com>

# 💡 主要文档
MAIN = latex-tutorial
NOTES = real-analysis-notes
DOCS = elegantnote-cn elegantnote-en

# 💡 编译器设置
LATEX = xelatex
LATEXFLAGS = -interaction=nonstopmode -file-line-error

# 💡 颜色输出
GREEN = \033[0;32m
YELLOW = \033[0;33m
CYAN = \033[0;36m
NC = \033[0m # No Color

.PHONY: all tutorial notes docs clean distclean watch help

# 默认目标：编译教程
all: tutorial notes

# 编译 LaTeX 教程
tutorial: $(MAIN).pdf
	@echo "$(GREEN)✓ $(MAIN).pdf 编译完成$(NC)"

$(MAIN).pdf: $(MAIN).tex elegantnote.cls
	@echo "$(CYAN)→ 编译 $(MAIN).tex ...$(NC)"
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	@echo "$(YELLOW)→ 第二遍编译（更新目录）...$(NC)"
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex

# 编译实变函数笔记
notes: $(NOTES).pdf
	@echo "$(GREEN)✓ $(NOTES).pdf 编译完成$(NC)"

$(NOTES).pdf: $(NOTES).tex elegantnote.cls
	@echo "$(CYAN)→ 编译 $(NOTES).tex ...$(NC)"
	$(LATEX) $(LATEXFLAGS) $(NOTES).tex
	@echo "$(YELLOW)→ 第二遍编译（更新目录）...$(NC)"
	$(LATEX) $(LATEXFLAGS) $(NOTES).tex

# 编译官方文档
docs: $(addsuffix .pdf,$(DOCS))
	@echo "$(GREEN)✓ 所有文档编译完成$(NC)"

%.pdf: %.tex elegantnote.cls
	@echo "$(CYAN)→ 编译 $< ...$(NC)"
	$(LATEX) $(LATEXFLAGS) $<
	$(LATEX) $(LATEXFLAGS) $<

# 清理辅助文件
clean:
	@echo "$(YELLOW)→ 清理辅助文件...$(NC)"
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz
	rm -f *.bbl *.blg *.bcf *.run.xml
	@echo "$(GREEN)✓ 清理完成$(NC)"

# 深度清理（包括 PDF）
distclean: clean
	@echo "$(YELLOW)→ 清理 PDF 文件...$(NC)"
	rm -f $(MAIN).pdf $(addsuffix .pdf,$(DOCS))
	@echo "$(GREEN)✓ 深度清理完成$(NC)"

# 监视文件变化自动编译（需要 fswatch 或 inotifywait）
watch:
	@echo "$(CYAN)→ 监视 $(MAIN).tex 变化...$(NC)"
	@echo "$(YELLOW)  按 Ctrl+C 停止$(NC)"
	@while true; do \
		inotifywait -q -e modify $(MAIN).tex elegantnote.cls 2>/dev/null || fswatch -1 $(MAIN).tex elegantnote.cls; \
		make tutorial; \
	done

# 帮助信息
help:
	@echo ""
	@echo "$(CYAN)ElegantNote Makefile 使用说明$(NC)"
	@echo "================================"
	@echo ""
	@echo "  $(GREEN)make$(NC)          - 编译 LaTeX 教程 ($(MAIN).pdf)"
	@echo "  $(GREEN)make tutorial$(NC) - 编译 LaTeX 教程"
	@echo "  $(GREEN)make docs$(NC)     - 编译官方文档 (cn/en)"
	@echo "  $(GREEN)make clean$(NC)    - 清理辅助文件 (.aux, .log, ...)"
	@echo "  $(GREEN)make distclean$(NC)- 深度清理（包括 PDF）"
	@echo "  $(GREEN)make watch$(NC)    - 监视文件变化自动编译"
	@echo "  $(GREEN)make help$(NC)     - 显示此帮助信息"
	@echo ""

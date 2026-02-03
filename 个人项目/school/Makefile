# =========================================================
# hustreport LaTeX 项目 Makefile
# 用法: make [target]
# =========================================================

# 配置
LATEX = xelatex
BIBTEX = bibtex
LATEXFLAGS = -interaction=nonstopmode -file-line-error

# 主文档（不带扩展名）
DOCS = report report_cn

# 默认目标
.PHONY: all clean cleanall help cn en watch

# 编译所有文档
all: $(DOCS)
	@echo "✅ 所有文档编译完成!"

# 编译中文报告
cn: report_cn
	@echo "✅ report_cn.pdf 编译完成!"

# 编译英文报告
en: report
	@echo "✅ report.pdf 编译完成!"

# 单个文档编译规则 (完整编译：含目录和交叉引用)
%: %.tex
	@echo "📝 正在编译 $<..."
	$(LATEX) $(LATEXFLAGS) $< > /dev/null 2>&1 || (echo "❌ 第一次编译失败"; exit 1)
	@if [ -f ref.bib ]; then \
		echo "📚 处理参考文献..."; \
		$(BIBTEX) $@ > /dev/null 2>&1 || true; \
	fi
	$(LATEX) $(LATEXFLAGS) $< > /dev/null 2>&1
	$(LATEX) $(LATEXFLAGS) $< > /dev/null 2>&1
	@echo "📄 生成 $@.pdf"

# 快速编译（单次，用于预览）
quick:
	@for doc in $(DOCS); do \
		echo "⚡ 快速编译 $$doc.tex..."; \
		$(LATEX) $(LATEXFLAGS) $$doc.tex > /dev/null 2>&1; \
	done
	@echo "✅ 快速编译完成!"

# 清理临时文件（保留 PDF）
clean:
	@echo "🧹 清理临时文件..."
	@rm -f *.aux *.log *.toc *.out *.bbl *.blg *.lot *.lof
	@rm -f *.fls *.fdb_latexmk *.synctex.gz *.nav *.snm *.vrb
	@rm -f *.listing *.idx *.ilg *.ind *.glo *.gls *.glg
	@rm -f *.run.xml *.bcf *.xdv *.pyg
	@rm -f *-blx.bib
	@echo "✅ 临时文件已清理 (PDF 已保留)"

# 完全清理（包括 PDF）
cleanall: clean
	@echo "🗑️  删除 PDF 文件..."
	@rm -f *.pdf
	@echo "✅ 所有生成文件已删除"

# 查看 PDF
view: all
	@for doc in $(DOCS); do \
		if [ -f $$doc.pdf ]; then \
			echo "👁️  打开 $$doc.pdf..."; \
			xdg-open $$doc.pdf 2>/dev/null & \
		fi; \
	done

# 仅查看中文报告
view-cn: cn
	@xdg-open report_cn.pdf 2>/dev/null &

# 仅查看英文报告
view-en: en
	@xdg-open report.pdf 2>/dev/null &

# 监视文件变化自动编译（需要 inotifywait）
watch:
	@echo "👀 监视文件变化... (Ctrl+C 退出)"
	@while true; do \
		inotifywait -qe modify *.tex *.cls 2>/dev/null; \
		echo "📝 检测到变化，重新编译..."; \
		make quick; \
	done

# 打包发布（创建压缩包）
dist: cleanall
	@echo "📦 创建发布包..."
	@mkdir -p dist
	@tar -czvf dist/hustreport-$(shell date +%Y%m%d).tar.gz \
		*.tex *.cls *.bib \
		figure/ fonts/ README.md Makefile \
		--exclude='*.pdf' --exclude='*.aux' --exclude='*.log'
	@echo "✅ 发布包已创建: dist/hustreport-$(shell date +%Y%m%d).tar.gz"

# 帮助信息
help:
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════╗"
	@echo "║           hustreport LaTeX 项目构建系统                  ║"
	@echo "╠══════════════════════════════════════════════════════════╣"
	@echo "║  make all      - 编译所有文档 (report.pdf, report_cn.pdf)║"
	@echo "║  make cn       - 仅编译中文报告 (report_cn.pdf)          ║"
	@echo "║  make en       - 仅编译英文报告 (report.pdf)             ║"
	@echo "║  make quick    - 快速编译（单次，用于预览）              ║"
	@echo "║  make clean    - 清理临时文件（保留 PDF）                ║"
	@echo "║  make cleanall - 完全清理（包括 PDF）                    ║"
	@echo "║  make view     - 编译并打开所有 PDF                      ║"
	@echo "║  make view-cn  - 编译并打开中文报告                      ║"
	@echo "║  make view-en  - 编译并打开英文报告                      ║"
	@echo "║  make watch    - 监视文件变化自动编译                    ║"
	@echo "║  make dist     - 创建发布压缩包                          ║"
	@echo "║  make help     - 显示此帮助信息                          ║"
	@echo "╚══════════════════════════════════════════════════════════╝"
	@echo ""

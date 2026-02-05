# Makefile for Real Analysis Problem Set LaTeX Project
# Compiler: XeLaTeX with latexmk

# 💡 Main configuration
MAIN       := main
LATEXMK    := latexmk
XELATEX    := xelatex
BIBER      := biber

# 💡 Latexmk flags
LATEXMK_FLAGS := -xelatex -interaction=nonstopmode -file-line-error -synctex=1

# 💡 Output files
PDF        := $(MAIN).pdf
AUX_FILES  := *.aux *.log *.toc *.out *.bcf *.run.xml *.bbl *.blg *.fls *.fdb_latexmk *.synctex.gz *.xdv

# Default target
.PHONY: all
all: $(PDF)

# 💡 Build PDF using latexmk (recommended, with force mode for warnings)
$(PDF): $(MAIN).tex
	@echo "📦 Compiling $(MAIN).tex with XeLaTeX..."
	@$(LATEXMK) $(LATEXMK_FLAGS) -f $(MAIN).tex || true
	@if [ -f $(PDF) ]; then echo "✅ Build complete: $(PDF)"; else echo "❌ Build failed"; exit 1; fi

# 💡 Quick build (single pass, no bibliography)
.PHONY: quick
quick:
	@echo "⚡ Quick compile (single pass)..."
	$(XELATEX) -interaction=nonstopmode $(MAIN).tex

# 💡 Full build with bibliography
.PHONY: full
full:
	@echo "📚 Full compile with bibliography..."
	$(XELATEX) $(MAIN).tex
	$(BIBER) $(MAIN)
	$(XELATEX) $(MAIN).tex
	$(XELATEX) $(MAIN).tex
	@echo "✅ Full build complete: $(PDF)"

# 💡 Force rebuild (ignore errors)
.PHONY: force
force:
	@echo "🔧 Force rebuild..."
	$(LATEXMK) $(LATEXMK_FLAGS) -f $(MAIN).tex

# 💡 Watch mode - auto-recompile on file changes
.PHONY: watch
watch:
	@echo "👀 Watching for changes..."
	$(LATEXMK) $(LATEXMK_FLAGS) -pvc $(MAIN).tex

# 💡 Clean auxiliary files
.PHONY: clean
clean:
	@echo "🧹 Cleaning auxiliary files..."
	$(LATEXMK) -C
	rm -f $(AUX_FILES)
	@echo "✅ Clean complete"

# 💡 Clean all (including PDF)
.PHONY: distclean
distclean: clean
	@echo "🗑️  Removing PDF..."
	rm -f $(PDF)
	@echo "✅ Full clean complete"

# 💡 Open PDF with default viewer
.PHONY: view
view: $(PDF)
	@echo "📖 Opening $(PDF)..."
	@xdg-open $(PDF) 2>/dev/null || open $(PDF) 2>/dev/null || echo "Please open $(PDF) manually"

# 💡 Show help
.PHONY: help
help:
	@echo "📘 Real Analysis Problem Set - Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all       Build PDF using latexmk (default)"
	@echo "  quick     Quick single-pass compile"
	@echo "  full      Full compile with bibliography"
	@echo "  force     Force rebuild, ignore errors"
	@echo "  watch     Watch mode - auto-recompile on changes"
	@echo "  clean     Remove auxiliary files"
	@echo "  distclean Remove all generated files including PDF"
	@echo "  view      Open PDF with default viewer"
	@echo "  help      Show this help message"

#!/usr/bin/env bash
# pkuthss 示例论文编译脚本 (Linux/macOS)
# Copyright (c) 2008-2009 solvethis
# Copyright (c) 2010-2012,2019 Casper Ti. Vector
# Enhanced 2026 for cross-platform support
# Public domain.

set -euo pipefail

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 帮助信息
usage() {
    echo -e "${BLUE}pkuthss 示例论文编译脚本${NC}"
    echo ""
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  doc, build    编译论文 (默认)"
    echo "  clean         清理临时文件"
    echo "  distclean     完全清理 (包括 PDF)"
    echo "  preview       编译并预览 PDF"
    echo "  watch         监视模式自动编译"
    echo "  help          显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0              # 编译论文"
    echo "  $0 preview      # 编译并打开 PDF"
    echo "  $0 watch        # 自动编译模式"
}

# 检测 PDF 查看器
get_pdf_viewer() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "open"
    elif command -v xdg-open &> /dev/null; then
        echo "xdg-open"
    elif command -v evince &> /dev/null; then
        echo "evince"
    elif command -v okular &> /dev/null; then
        echo "okular"
    else
        echo "echo 请手动打开"
    fi
}

# 编译文档
do_doc() {
    echo -e "${BLUE}📄 编译论文...${NC}"
    latexmk -xelatex thesis.tex
    echo -e "${GREEN}✅ 编译完成: thesis.pdf${NC}"
}

# 清理临时文件
do_clean() {
    echo -e "${YELLOW}🧹 清理临时文件...${NC}"
    latexmk -c
    rm -f *.xdv *.bbl-SAVE-ERROR *.bcf-SAVE-ERROR
    echo -e "${GREEN}✅ 清理完成${NC}"
}

# 完全清理
do_distclean() {
    echo -e "${YELLOW}🧹 完全清理...${NC}"
    latexmk -C
    rm -f *.xdv *.bbl-SAVE-ERROR *.bcf-SAVE-ERROR
    echo -e "${GREEN}✅ 完全清理完成${NC}"
}

# 编译并预览
do_preview() {
    do_doc
    local viewer=$(get_pdf_viewer)
    echo -e "${BLUE}👁️ 打开 PDF 预览...${NC}"
    $viewer thesis.pdf &
}

# 监视模式
do_watch() {
    echo -e "${BLUE}👀 启动监视模式 (Ctrl+C 退出)...${NC}"
    latexmk -xelatex -pvc thesis.tex
}

# 主程序
main() {
    local cmd="${1:-doc}"
    
    case "$cmd" in
        doc|build|"")
            do_doc
            ;;
        clean)
            do_clean
            ;;
        distclean)
            do_distclean
            ;;
        preview)
            do_preview
            ;;
        watch)
            do_watch
            ;;
        help|-h|--help)
            usage
            ;;
        *)
            echo -e "${YELLOW}⚠️ 未知命令: $cmd${NC}"
            usage
            exit 1
            ;;
    esac
}

main "$@"

# vim:ts=4:sw=4

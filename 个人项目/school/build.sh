#!/bin/bash
# =========================================================
# hustreport LaTeX 编译脚本
# 用法: ./build.sh [选项] [文档名]
# =========================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
LATEX="xelatex"
BIBTEX="bibtex"
LATEXFLAGS="-interaction=nonstopmode -file-line-error"

# 帮助信息
show_help() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           hustreport LaTeX 编译脚本                      ║${NC}"
    echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║${NC}  用法: ./build.sh [选项] [文档名]                        ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}                                                          ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  选项:                                                   ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    -h, --help     显示帮助信息                           ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    -c, --clean    清理临时文件                           ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    -C, --cleanall 完全清理（包括PDF）                    ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    -q, --quick    快速编译（单次）                       ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    -f, --full     完整编译（含参考文献）                 ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    -v, --view     编译后打开 PDF                         ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    -w, --watch    监视文件变化自动编译                   ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}                                                          ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  文档名:                                                 ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    report         英文报告                               ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    report_cn      中文报告                               ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    all            所有报告（默认）                       ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}                                                          ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  示例:                                                   ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    ./build.sh                  # 编译所有                ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    ./build.sh report_cn        # 编译中文报告            ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    ./build.sh -q report        # 快速编译英文报告        ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    ./build.sh -v report_cn     # 编译并查看中文报告      ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}    ./build.sh -c               # 清理临时文件            ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# 清理临时文件
clean_temp() {
    echo -e "${YELLOW}🧹 清理临时文件...${NC}"
    rm -f *.aux *.log *.toc *.out *.bbl *.blg *.lot *.lof
    rm -f *.fls *.fdb_latexmk *.synctex.gz *.nav *.snm *.vrb
    rm -f *.listing *.idx *.ilg *.ind *.glo *.gls *.glg
    rm -f *.run.xml *.bcf *.xdv *.pyg
    rm -f *-blx.bib
    echo -e "${GREEN}✅ 临时文件已清理${NC}"
}

# 完全清理
clean_all() {
    clean_temp
    echo -e "${YELLOW}🗑️  删除 PDF 文件...${NC}"
    rm -f *.pdf
    echo -e "${GREEN}✅ 所有生成文件已删除${NC}"
}

# 快速编译（单次）
quick_compile() {
    local doc=$1
    echo -e "${BLUE}⚡ 快速编译 ${doc}.tex...${NC}"
    if $LATEX $LATEXFLAGS "${doc}.tex" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ ${doc}.pdf 编译成功${NC}"
    else
        echo -e "${RED}❌ ${doc}.tex 编译失败${NC}"
        $LATEX $LATEXFLAGS "${doc}.tex" 2>&1 | tail -20
        return 1
    fi
}

# 完整编译（含参考文献和交叉引用）
full_compile() {
    local doc=$1
    echo -e "${BLUE}📝 完整编译 ${doc}.tex...${NC}"
    
    # 第一次编译
    echo -e "  ${YELLOW}[1/3] 第一次编译...${NC}"
    if ! $LATEX $LATEXFLAGS "${doc}.tex" > /dev/null 2>&1; then
        echo -e "${RED}❌ 第一次编译失败${NC}"
        $LATEX $LATEXFLAGS "${doc}.tex" 2>&1 | tail -30
        return 1
    fi
    
    # 处理参考文献
    if [ -f "ref.bib" ]; then
        echo -e "  ${YELLOW}[BIB] 处理参考文献...${NC}"
        $BIBTEX "$doc" > /dev/null 2>&1 || true
    fi
    
    # 第二次编译
    echo -e "  ${YELLOW}[2/3] 第二次编译...${NC}"
    $LATEX $LATEXFLAGS "${doc}.tex" > /dev/null 2>&1
    
    # 第三次编译
    echo -e "  ${YELLOW}[3/3] 第三次编译...${NC}"
    $LATEX $LATEXFLAGS "${doc}.tex" > /dev/null 2>&1
    
    echo -e "${GREEN}✅ ${doc}.pdf 编译完成${NC}"
}

# 打开 PDF
view_pdf() {
    local doc=$1
    if [ -f "${doc}.pdf" ]; then
        echo -e "${BLUE}👁️  打开 ${doc}.pdf...${NC}"
        xdg-open "${doc}.pdf" 2>/dev/null &
    else
        echo -e "${RED}❌ ${doc}.pdf 不存在${NC}"
    fi
}

# 监视文件变化
watch_files() {
    if ! command -v inotifywait &> /dev/null; then
        echo -e "${RED}❌ 需要安装 inotify-tools: sudo dnf install inotify-tools${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}👀 监视文件变化... (Ctrl+C 退出)${NC}"
    while true; do
        inotifywait -qe modify *.tex *.cls 2>/dev/null
        echo -e "${YELLOW}📝 检测到变化，重新编译...${NC}"
        for doc in report report_cn; do
            quick_compile "$doc"
        done
    done
}

# 主程序
main() {
    local mode="full"
    local docs=()
    local view=false
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -c|--clean)
                clean_temp
                exit 0
                ;;
            -C|--cleanall)
                clean_all
                exit 0
                ;;
            -q|--quick)
                mode="quick"
                shift
                ;;
            -f|--full)
                mode="full"
                shift
                ;;
            -v|--view)
                view=true
                shift
                ;;
            -w|--watch)
                watch_files
                exit 0
                ;;
            all)
                docs=(report report_cn)
                shift
                ;;
            report|report_cn)
                docs+=("$1")
                shift
                ;;
            *)
                echo -e "${RED}❌ 未知选项: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 默认编译所有文档
    if [ ${#docs[@]} -eq 0 ]; then
        docs=(report report_cn)
    fi
    
    # 编译
    for doc in "${docs[@]}"; do
        if [ ! -f "${doc}.tex" ]; then
            echo -e "${RED}❌ 文件不存在: ${doc}.tex${NC}"
            continue
        fi
        
        if [ "$mode" = "quick" ]; then
            quick_compile "$doc"
        else
            full_compile "$doc"
        fi
        
        if [ "$view" = true ]; then
            view_pdf "$doc"
        fi
    done
    
    echo ""
    echo -e "${GREEN}🎉 编译任务完成!${NC}"
}

# 运行主程序
main "$@"

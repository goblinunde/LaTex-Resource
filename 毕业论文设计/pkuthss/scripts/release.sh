#!/usr/bin/env bash
# pkuthss 版本发布脚本
# 用法: ./scripts/release.sh <version>
# 示例: ./scripts/release.sh 1.9.5

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
info() { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✅${NC} $*"; }
warn() { echo -e "${YELLOW}⚠️${NC} $*"; }
error() { echo -e "${RED}❌${NC} $*" >&2; exit 1; }

# 版本号验证
validate_version() {
    local version=$1
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
        error "无效的版本号格式: $version (期望格式: x.y.z 或 x.y.z-suffix)"
    fi
}

# 检查 Git 状态
check_git_status() {
    if [[ -n $(git status --porcelain) ]]; then
        warn "工作区有未提交的更改"
        git status --short
        read -p "是否继续? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# 更新版本号
update_version() {
    local new_version=$1
    local date_str=$(date '+%Y/%m/%d')
    local cn_date=$(date '+\\zhdigits{%Y}年\\zhnumber{%-m}月')
    
    info "更新 Makefile 中的版本号..."
    sed -i "s/^VERSION   := .*/VERSION   := ${new_version}/" Makefile
    
    info "更新 tex/ 中的版本号..."
    find tex/ -name '*.cls' -o -name '*.def' | while read -r file; do
        if grep -q '\\Provides' "$file"; then
            sed -i "/\\\\Provides/,+1 s;\\[[^ ]* [^ ]*;[${date_str} v${new_version};g" "$file"
        fi
    done
    
    info "更新文档中的版本号..."
    if [[ -f doc/readme/pkuthss.tex ]]; then
        sed -i -e "/date = / s;{[^,]\\+},\$;{${cn_date}},;g" \
               -e "/\\\\newcommand\\*{\\\\docversion}/ s;{[^{}]\\+}\$;{v${new_version}};g" \
               doc/readme/pkuthss.tex
    fi
    
    success "版本号已更新为 v${new_version}"
}

# 生成 Changelog
generate_changelog() {
    local new_version=$1
    local changelog_file="CHANGELOG.md"
    local date_str=$(date '+%Y-%m-%d')
    
    info "生成变更日志..."
    
    # 获取上一个 tag
    local prev_tag=$(git describe --tags --abbrev=0 HEAD 2>/dev/null || echo "")
    
    # 准备新的 changelog 条目
    local new_entry="## [${new_version}] - ${date_str}\n\n"
    
    if [[ -n "$prev_tag" ]]; then
        new_entry+="### 变更\n\n"
        # 获取提交信息
        while IFS= read -r line; do
            new_entry+="- ${line}\n"
        done < <(git log --oneline "${prev_tag}..HEAD" | head -20)
    else
        new_entry+="### 初始版本\n\n"
        new_entry+="- 初始发布\n"
    fi
    new_entry+="\n"
    
    # 更新或创建 CHANGELOG.md
    if [[ -f "$changelog_file" ]]; then
        # 在文件头部插入新条目（保留标题）
        local temp_file=$(mktemp)
        echo -e "# Changelog\n\n所有重要变更都会记录在此文件中。\n\n${new_entry}" > "$temp_file"
        # 跳过旧文件的头部，追加其余内容
        tail -n +5 "$changelog_file" >> "$temp_file" 2>/dev/null || true
        mv "$temp_file" "$changelog_file"
    else
        echo -e "# Changelog\n\n所有重要变更都会记录在此文件中。\n\n${new_entry}" > "$changelog_file"
    fi
    
    success "CHANGELOG.md 已更新"
}

# 创建 Git 提交和 Tag
create_git_release() {
    local new_version=$1
    
    info "创建 Git 提交..."
    git add -A
    git commit -m "chore: release v${new_version}"
    
    info "创建 Git Tag..."
    git tag -a "v${new_version}" -m "Release v${new_version}"
    
    success "已创建 tag: v${new_version}"
}

# 主流程
main() {
    if [[ $# -lt 1 ]]; then
        echo "用法: $0 <version>"
        echo "示例: $0 1.9.5"
        exit 1
    fi
    
    local new_version=$1
    
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║          pkuthss 版本发布工具                          ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    
    validate_version "$new_version"
    info "准备发布版本: v${new_version}"
    
    check_git_status
    update_version "$new_version"
    generate_changelog "$new_version"
    create_git_release "$new_version"
    
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                  🎉 发布完成！                         ║"
    echo "╠════════════════════════════════════════════════════════╣"
    echo "║  下一步:                                               ║"
    echo "║  1. 检查变更: git diff HEAD~1                         ║"
    echo "║  2. 推送代码: git push origin master                  ║"
    echo "║  3. 推送标签: git push origin v${new_version}              ║"
    echo "║  4. GitHub Actions 将自动创建 Release                 ║"
    echo "╚════════════════════════════════════════════════════════╝"
}

main "$@"

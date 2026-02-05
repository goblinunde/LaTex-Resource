#!/usr/bin/env bash
###############################################################################
# dp (DUST-PRO Analyzer) — Operations & Maintenance + Repo/Git Size Analysis
#
# Goals:
#   1) Robust menu system + direct parameter execution (subcommands)
#   2) Safe + portable size filtering (no fragile `find -size +100M` usage)
#   3) Graceful handling when `dust` panics or is missing
#   4) Richer capabilities:
#        - quick directory view
#        - file type distribution
#        - interactive large-file browser (fzf)
#        - identify files larger than X (for GitHub limits, e.g. 100MB)
#        - Git working tree size report (directories + files)
#        - Git commit/tree size report: show file + folder sizes inside ANY commit
#
# Notes about the dust panic you saw:
#   du-dust can read config from files/environment; a corrupted config or invalid
#   data format can cause a panic. This script:
#     - catches dust failures and falls back to `du` instead of crashing
#     - provides a "dp doctor" command to show common causes and mitigation
#
# Dependencies:
#   Required (typical POSIX): bash, find, du, sort, awk, head, xargs, sed
#   Optional: dust, fzf, git, file
###############################################################################

set -Eeuo pipefail

# --------------------------- Defaults & Globals ------------------------------

VERSION="3.0"
LIMIT="${LIMIT:-20}"
MIN_SIZE="${MIN_SIZE:-100M}"
TARGET_DIR="${TARGET_DIR:-.}"
DEPTH="${DEPTH:-2}"   # directory aggregation depth in Git reports

# Flags
FLAG_TYPE=false
FLAG_FZF=false

# Colors (simple, safe)
c_bold=$'\033[1m'
c_dim=$'\033[2m'
c_red=$'\033[31m'
c_grn=$'\033[32m'
c_yel=$'\033[33m'
c_blu=$'\033[34m'
c_rst=$'\033[0m'

# --------------------------- Small Helpers -----------------------------------

have() { command -v "$1" >/dev/null 2>&1; }

say()  { printf "%s\n" "$*"; }
warn() { printf "%s⚠️  %s%s\n" "$c_yel" "$*" "$c_rst" >&2; }
err()  { printf "%s❌ %s%s\n" "$c_red" "$*" "$c_rst" >&2; }
die()  { err "$*"; exit 1; }

validate_dir() {
  local d="$1"
  [[ -d "$d" ]] || die "Not a directory: $d"
}

# Parse size strings like: 500M, 2G, 120K, 1024, 1.5G  (binary units)
parse_size_to_bytes() {
  local s="${1//[[:space:]]/}"
  [[ -n "$s" ]] || die "Empty size."

  if [[ ! "$s" =~ ^([0-9]+([.][0-9]+)?)([bBkKmMgGtTpP]?)$ ]]; then
    die "Invalid size: '$1' (examples: 500M, 2G, 120K, 1024, 1.5G)"
  fi

  local num="${BASH_REMATCH[1]}"
  local suf="${BASH_REMATCH[3],,}"

  local mul=1
  case "$suf" in
    ""|b) mul=1 ;;
    k) mul=1024 ;;
    m) mul=$((1024**2)) ;;
    g) mul=$((1024**3)) ;;
    t) mul=$((1024**4)) ;;
    p) mul=$((1024**5)) ;;
    *) die "Invalid size suffix in '$1'." ;;
  esac

  awk -v n="$num" -v m="$mul" 'BEGIN { printf "%.0f\n", (n*m) }'
}

# Convert KB to human-ish display
kb_to_human() {
  awk -v kb="$1" '
    function human(x,   u, i) {
      split("KB MB GB TB PB", u, " ");
      i=1;
      while (x>=1024 && i<5) { x/=1024; i++; }
      return sprintf((x<10 && i>1) ? "%.1f %s" : "%.0f %s", x, u[i]);
    }
    BEGIN { print human(kb); }
  '
}

# Safely run dust; if it errors/panics, fall back.
safe_dust() {
  # Usage: safe_dust <dust args...>
  if ! have dust; then
    return 127
  fi

  # dust writes panic to stderr; exit code will be non-zero
  if dust "$@"; then
    return 0
  fi

  warn "dust failed (possibly due to config/invalid format). Falling back to du."
  return 1
}

# --------------------------- “Doctor” ----------------------------------------

cmd_doctor() {
  say "${c_bold}dp doctor${c_rst}"
  say "------------------------------------------------"
  say "Checks:"
  say "  dust: $(have dust && echo "installed" || echo "missing")"
  say "  fzf : $(have fzf  && echo "installed" || echo "missing")"
  say "  git : $(have git  && echo "installed" || echo "missing")"
  say ""
  say "If dust panics with 'invalid data format', common causes include:"
  say "  - A corrupted dust config file or invalid config values"
  say "  - Unexpected locale/encoding issues"
  say ""
  say "Mitigations:"
  say "  1) Try running dust with no config (if dust supports it in your version)."
  say "  2) Temporarily move dust config out of the way and retry."
  say "  3) Upgrade dust (du-dust) to a newer version."
  say ""
  say "This script already catches dust failures and uses safe fallbacks."
}

# --------------------------- Core Commands -----------------------------------

# 1) Quick view: top items > MIN_SIZE (dust) OR fallback top children by du
cmd_view() {
  local dir="$1"
  validate_dir "$dir"

  say ""
  say "🚀 Analyzing: $dir (Threshold: $MIN_SIZE)"
  say "------------------------------------------------"

  if safe_dust -n "$LIMIT" -r -M "$MIN_SIZE" "$dir"; then
    return 0
  fi

  # Fallback (fast and simple): list immediate children by size
  (
    shopt -s nullglob dotglob
    for p in "$dir"/* "$dir"/.*; do
      [[ -e "$p" ]] || continue
      [[ "$(basename "$p")" == "." || "$(basename "$p")" == ".." ]] && continue
      du -sk -- "$p" 2>/dev/null || true
    done
  ) | sort -rn | head -n "$LIMIT" | awk '{
      kb=$1; $1=""; sub(/^ +/,"");
      printf "%8s  %s\n", kb " KB", $0
    }'
}

# 2) Type distribution: dust -t OR fallback by scanning files and aggregating ext
cmd_types() {
  local dir="$1"
  validate_dir "$dir"

  say ""
  say "📊 File Type Distribution ($dir):"
  say "------------------------------------------------"

  if safe_dust -t "$dir" | head -n 20; then
    return 0
  fi

  # Fallback: extension aggregation with du -k per file
  local tmp
  tmp="$(mktemp)"
  trap 'rm -f "$tmp"' RETURN

  find "$dir" -type f -print0 2>/dev/null \
    | xargs -0 -I{} sh -c 'du -k -- "{}" 2>/dev/null || true' \
    > "$tmp"

  awk '
    function ext(path,   base, e) {
      base = path
      sub(/^.*\//, "", base)
      if (base ~ /^\.[^\.]+$/) return "(dotfile)"
      if (base !~ /\./) return "(none)"
      e = base
      sub(/^.*\./, "", e)
      if (e == base) return "(none)"
      return "." tolower(e)
    }
    {
      kb=$1; $1=""; sub(/^ +/,""); path=$0
      e = ext(path)
      sum[e] += kb
      cnt[e] += 1
    }
    END {
      for (e in sum) printf "%d\t%d\t%s\n", sum[e], cnt[e], e
    }
  ' "$tmp" | sort -rn | head -n 20 | awk -F'\t' '{
      kb=$1; cnt=$2; ext=$3;
      x=kb; u="KB";
      if (x>=1024) { x/=1024; u="MB" }
      if (x>=1024) { x/=1024; u="GB" }
      if (x>=1024) { x/=1024; u="TB" }
      printf "%8.1f %s  %7d files  %s\n", x, u, cnt, ext
    }'
}

# 3) List large files in a folder tree, with locations (GitHub-friendly)
# Output: size_kb, human_size, path
cmd_large_files() {
  local dir="$1"
  validate_dir "$dir"
  local min_bytes
  min_bytes="$(parse_size_to_bytes "$MIN_SIZE")"

  say ""
  say "🧱 Files >= $MIN_SIZE under: $dir"
  say "------------------------------------------------"

  # du -k per file, filter by bytes threshold, then pretty print
  find "$dir" -type f -print0 2>/dev/null \
    | xargs -0 -I{} sh -c '
        kb=$(du -k -- "{}" 2>/dev/null | awk "{print \$1}")
        [ -n "$kb" ] || exit 0
        bytes=$((kb*1024))
        if [ "$bytes" -ge "'"$min_bytes"'" ]; then
          printf "%d\t%s\n" "$kb" "{}"
        fi
      ' \
    | sort -rn \
    | awk -F'\t' '{
        kb=$1; path=$2;
        # show kb + human string
        # human done in awk to avoid calling external in loop
        x=kb; u="KB";
        if (x>=1024) { x/=1024; u="MB" }
        if (x>=1024) { x/=1024; u="GB" }
        if (x>=1024) { x/=1024; u="TB" }
        printf "%10d KB  %7.1f %s  %s\n", kb, x, u, path
      }'
}

# 4) Interactive large file search with preview (fzf)
cmd_fzf() {
  local dir="$1"
  validate_dir "$dir"
  have fzf || die "fzf is required for this mode."

  local min_bytes
  min_bytes="$(parse_size_to_bytes "$MIN_SIZE")"

  say ""
  say "🔍 Interactive Search (Dir: $dir, Threshold: $MIN_SIZE)"
  say "------------------------------------------------"

  # Feed fzf: "size_kb<TAB>path"
  find "$dir" -type f -print0 2>/dev/null \
    | xargs -0 -I{} sh -c '
        kb=$(du -k -- "{}" 2>/dev/null | awk "{print \$1}")
        [ -n "$kb" ] || exit 0
        bytes=$((kb*1024))
        if [ "$bytes" -ge "'"$min_bytes"'" ]; then
          printf "%s\t%s\n" "$kb" "{}"
        fi
      ' \
    | sort -rn \
    | fzf --delimiter=$'\t' --with-nth=2 \
        --header "ENTER: details | ESC: back | Threshold: $MIN_SIZE" \
        --preview-window=right:55%:wrap \
        --preview '
          kb={1}
          path={2}
          echo "📄 $path"
          echo "📦 Size: " '"$(kb_to_human '"'"'{1}'"'"')"' " ($kb KB)"
          echo "------------------------------------------------"
          parent=$(dirname -- "$path")
          if command -v dust >/dev/null 2>&1; then
            dust -n 20 -r "$parent" 2>/dev/null || true
          else
            ls -lah -- "$parent" 2>/dev/null | head -n 80 || true
          fi
          echo "------------------------------------------------"
          if command -v file >/dev/null 2>&1; then
            file -- "$path" 2>/dev/null || true
          fi
        ' \
        --bind 'enter:execute-silent(
          path={2};
          echo;
          echo "Selected: $path";
          echo "------------------------------------------------";
          du -sh -- "$path" 2>/dev/null || true;
          ls -lah -- "$path" 2>/dev/null || true;
          echo "------------------------------------------------";
          read -r -p "Press Enter to return..." _
        )' >/dev/null
}

# --------------------------- Git / Repo Features -----------------------------

# (A) Working tree directory size report (fast-ish): top directories by du.
# This answers: “within each directory, show sizes of files/folders clearly”.
cmd_repo_worktree_sizes() {
  local dir="$1"
  validate_dir "$dir"
  have git || die "git is required."
  (cd "$dir" && git rev-parse --is-inside-work-tree >/dev/null 2>&1) \
    || die "Not a git repository: $dir"

  say ""
  say "🧾 Git working tree size report (dir: $dir)"
  say "   (uses du over your current checkout; ignores .git directory)"
  say "------------------------------------------------"

  # Show top-level items excluding .git
  ( cd "$dir"
    shopt -s nullglob dotglob
    for p in ./* ./.*
    do
      [[ -e "$p" ]] || continue
      [[ "$p" == "./." || "$p" == "./.." ]] && continue
      [[ "$p" == "./.git" ]] && continue
      du -sk -- "$p" 2>/dev/null || true
    done \
    | sort -rn | head -n "$LIMIT" \
    | awk '{
        kb=$1; $1=""; sub(/^ +/,"");
        x=kb; u="KB";
        if (x>=1024) { x/=1024; u="MB" }
        if (x>=1024) { x/=1024; u="GB" }
        if (x>=1024) { x/=1024; u="TB" }
        printf "%8.1f %s  %s\n", x, u, $0
      }'
  )
}

# (B) Git commit/tree size analysis:
#     - list all files in a commit, with their blob sizes
#     - aggregate “folder sizes” by path prefixes (depth control)
#
# This is the key missing feature you requested: size of files & folders per dir
# *in each commit*, not just the working tree.
cmd_git_tree_sizes() {
  local repo="$1"
  local commit="${2:-HEAD}"
  local depth="${3:-$DEPTH}"
  have git || die "git is required."
  validate_dir "$repo"
  (cd "$repo" && git rev-parse --is-inside-work-tree >/dev/null 2>&1) \
    || die "Not a git repository: $repo"

  # Ensure commit-ish exists
  (cd "$repo" && git cat-file -e "${commit}^{tree}" 2>/dev/null) \
    || die "Invalid commit/tree: $commit"

  say ""
  say "🧠 Git tree size analysis"
  say "  Repo  : $repo"
  say "  Commit: $commit"
  say "  Depth : $depth"
  say "------------------------------------------------"
  say "${c_dim}Computing file blob sizes from git objects (not working tree).${c_rst}"
  say ""

  # We need a list of files in the tree, then size each blob:
  # git ls-tree -r -z gives NUL-delimited entries including blob SHA and path.
  #
  # Format per entry:
  #   <mode> <type> <object>\t<file>\0
  #
  # We parse out object SHA and path, then call:
  #   git cat-file -s <object>  -> size in bytes
  #
  # Then we:
  #   1) print top N largest files
  #   2) aggregate by directory prefix up to 'depth' and print top N directories
  ( cd "$repo"
    # Build a stream of: size_bytes<TAB>path
    git ls-tree -r -z "$commit" \
      | awk -v RS='\0' '
          NF==0 { next }
          {
            # split at tab: left contains mode type sha, right contains path
            n = split($0, parts, "\t")
            if (n < 2) next
            left = parts[1]
            path = parts[2]
            # object sha is third token on left
            split(left, t, " ")
            sha = t[3]
            if (sha != "" && path != "") {
              print sha "\t" path
            }
          }
        ' \
      | while IFS=$'\t' read -r sha path; do
          size=$(git cat-file -s "$sha" 2>/dev/null || echo 0)
          printf "%s\t%s\n" "$size" "$path"
        done \
      > /tmp/dp_git_sizes.$$.tsv

    # 1) Top files
    say "📄 Top $LIMIT largest files (in commit $commit):"
    say "------------------------------------------------"
    sort -rn -k1,1 /tmp/dp_git_sizes.$$.tsv \
      | head -n "$LIMIT" \
      | awk -F'\t' '{
          b=$1; p=$2;
          x=b; u="B";
          if (x>=1024) { x/=1024; u="KB" }
          if (x>=1024) { x/=1024; u="MB" }
          if (x>=1024) { x/=1024; u="GB" }
          printf "%8.2f %s  %s\n", x, u, p
        }'

    say ""
    say "📁 Top $LIMIT largest directories (aggregated to depth=$depth):"
    say "------------------------------------------------"
    awk -F'\t' -v depth="$depth" '
      function dirprefix(path, depth,   i, n, out, parts) {
        n = split(path, parts, "/")
        if (n == 1) return "."   # file at root
        out = parts[1]
        # depth=1 => top-level folder
        for (i=2; i<=n-1 && i<=depth; i++) out = out "/" parts[i]
        return out
      }
      {
        b=$1; p=$2
        d = dirprefix(p, depth)
        sum[d] += b
      }
      END {
        for (d in sum) printf "%s\t%s\n", sum[d], d
      }
    ' /tmp/dp_git_sizes.$$.tsv \
      | sort -rn -k1,1 \
      | head -n "$LIMIT" \
      | awk -F'\t' '{
          b=$1; d=$2;
          x=b; u="B";
          if (x>=1024) { x/=1024; u="KB" }
          if (x>=1024) { x/=1024; u="MB" }
          if (x>=1024) { x/=1024; u="GB" }
          printf "%8.2f %s  %s\n", x, u, d
        }'

    rm -f /tmp/dp_git_sizes.$$.tsv
  )
}

# (C) Identify “GitHub limit risk” files in working tree OR in commit
# GitHub warns around 50MB; hard limit is 100MB for regular pushes.
# You can set -s 100M (default) and it will list offenders with location.
cmd_github_limit_scan() {
  local dir="$1"
  validate_dir "$dir"
  say ""
  say "🚧 GitHub size-limit scan (working tree): files >= $MIN_SIZE"
  say "------------------------------------------------"
  cmd_large_files "$dir"
}

# --------------------------- Menu System -------------------------------------

menu_pause() { read -r -p "Press Enter to continue..." _; }

menu_main() {
  while true; do
    clear
    say "============================================"
    say "      ✨ DUST-PRO ANALYZER v$VERSION ✨"
    say "============================================"
    say " Directory : $TARGET_DIR"
    say " Threshold : $MIN_SIZE"
    say " Limit     : $LIMIT"
    say "--------------------------------------------"
    say " 1) Quick View (top items)"
    say " 2) Type Profile (extensions)"
    say " 3) Large Files (list)"
    say " 4) Deep Search (fzf interactive)"
    say " 5) Repo Menu (Git analysis)"
    say " 6) Set Threshold"
    say " 7) Set Directory"
    say " 8) Doctor (debug dust panic etc.)"
    say " q) Exit"
    say "============================================"
    read -r -p "Select: " opt

    case "$opt" in
      1) cmd_view "$TARGET_DIR"; menu_pause ;;
      2) cmd_types "$TARGET_DIR"; menu_pause ;;
      3) cmd_large_files "$TARGET_DIR"; menu_pause ;;
      4) cmd_fzf "$TARGET_DIR" || true; menu_pause ;;
      5) menu_repo ;;
      6)
        read -r -p "New threshold (e.g., 50M, 1G, 120K): " s
        parse_size_to_bytes "$s" >/dev/null
        MIN_SIZE="$s"
        ;;
      7)
        read -r -p "New directory path: " d
        validate_dir "$d"
        TARGET_DIR="$d"
        ;;
      8) cmd_doctor; menu_pause ;;
      q|Q) exit 0 ;;
      *) warn "Invalid option."; sleep 1 ;;
    esac
  done
}

menu_repo() {
  while true; do
    clear
    say "============================================"
    say "            🧠 Repo / Git Menu"
    say "============================================"
    say " Repo Dir   : $TARGET_DIR"
    say " Threshold  : $MIN_SIZE"
    say " Depth      : $DEPTH"
    say " Limit      : $LIMIT"
    say "--------------------------------------------"
    say " 1) Working tree sizes (top-level)"
    say " 2) Git tree sizes for a commit (files + dirs)"
    say " 3) GitHub limit scan (working tree files >= threshold)"
    say " 4) Set aggregation depth (current: $DEPTH)"
    say " b) Back"
    say "============================================"
    read -r -p "Select: " opt

    case "$opt" in
      1) cmd_repo_worktree_sizes "$TARGET_DIR"; menu_pause ;;
      2)
        read -r -p "Commit-ish (default HEAD): " c
        c="${c:-HEAD}"
        cmd_git_tree_sizes "$TARGET_DIR" "$c" "$DEPTH"
        menu_pause
        ;;
      3) cmd_github_limit_scan "$TARGET_DIR"; menu_pause ;;
      4)
        read -r -p "New depth (e.g., 1-6): " d
        [[ "$d" =~ ^[0-9]+$ ]] || die "Depth must be an integer."
        DEPTH="$d"
        ;;
      b|B) return 0 ;;
      *) warn "Invalid option."; sleep 1 ;;
    esac
  done
}

# --------------------------- CLI Parsing -------------------------------------

usage() {
  cat <<EOF
dp (DUST-PRO Analyzer) v$VERSION

Usage:
  dp                 # interactive menu
  dp <cmd> [options] # direct execution

Commands:
  view              Quick view (top items)
  types             File type distribution
  large             List files >= threshold
  fzf               Interactive large-file browser (requires fzf)
  doctor            Show diagnostics/tips (dust panic etc.)

  repo-worktree     Git working tree size report (top-level items)
  git-tree          Git commit/tree size analysis (largest files + aggregated dirs)
  github-scan        Convenience alias: list files >= threshold (for GitHub limits)

Common options:
  -d DIR     Target directory (default: .)
  -s SIZE    Threshold (default: 100M) examples: 50M, 1G, 120K, 1.5G
  -n N       Limit lines (default: 20)

Git-tree options:
  -c COMMIT  Commit-ish (default: HEAD)
  --depth N  Directory aggregation depth (default: $DEPTH)

Examples:
  dp view -d /var/log -s 200M
  dp large -d . -s 100M
  dp fzf -d /home/me -s 1G
  dp repo-worktree -d /path/to/repo -n 30
  dp git-tree -d /path/to/repo -c HEAD~3 --depth 2
EOF
}

# Parse common flags for subcommands
parse_common_opts() {
  # Resets OPTIND for nested getopts usage
  OPTIND=1
  local opt
  while getopts ":d:s:n:" opt; do
    case "$opt" in
      d) TARGET_DIR="$OPTARG" ;;
      s) parse_size_to_bytes "$OPTARG" >/dev/null; MIN_SIZE="$OPTARG" ;;
      n) [[ "$OPTARG" =~ ^[0-9]+$ ]] || die "-n expects an integer"; LIMIT="$OPTARG" ;;
      :) die "Option -$OPTARG requires an argument." ;;
      \?) die "Unknown option: -$OPTARG" ;;
    esac
  done
  shift $((OPTIND-1))
  # Return remaining args to caller via echo (bash pattern)
  echo "$@"
}

# --------------------------- Main --------------------------------------------

# Light dependency warnings up front (do not hard fail)
if ! have dust; then warn "dust not found — will use fallbacks."; fi
if ! have fzf;  then warn "fzf not found — interactive mode disabled."; fi

# No args => menu
if [[ $# -eq 0 ]]; then
  menu_main
fi

cmd="${1:-}"
shift || true

case "$cmd" in
  -h|--help|help) usage; exit 0 ;;
esac

# Subcommand dispatch (with per-command option parsing)
case "$cmd" in
  view)
    rest="$(parse_common_opts "$@")"
    validate_dir "$TARGET_DIR"
    cmd_view "$TARGET_DIR"
    ;;
  types)
    rest="$(parse_common_opts "$@")"
    validate_dir "$TARGET_DIR"
    cmd_types "$TARGET_DIR"
    ;;
  large)
    rest="$(parse_common_opts "$@")"
    validate_dir "$TARGET_DIR"
    cmd_large_files "$TARGET_DIR"
    ;;
  fzf)
    rest="$(parse_common_opts "$@")"
    validate_dir "$TARGET_DIR"
    cmd_fzf "$TARGET_DIR"
    ;;
  doctor)
    cmd_doctor
    ;;
  repo-worktree)
    rest="$(parse_common_opts "$@")"
    validate_dir "$TARGET_DIR"
    cmd_repo_worktree_sizes "$TARGET_DIR"
    ;;
  git-tree)
    # Parse common + git-tree specific options
    OPTIND=1
    commit="HEAD"
    while [[ $# -gt 0 ]]; do
      case "$1" in
        -d) TARGET_DIR="$2"; shift 2 ;;
        -s) parse_size_to_bytes "$2" >/dev/null; MIN_SIZE="$2"; shift 2 ;;
        -n) [[ "$2" =~ ^[0-9]+$ ]] || die "-n expects integer"; LIMIT="$2"; shift 2 ;;
        -c) commit="$2"; shift 2 ;;
        --depth) [[ "$2" =~ ^[0-9]+$ ]] || die "--depth expects integer"; DEPTH="$2"; shift 2 ;;
        -h|--help)
          usage; exit 0 ;;
        *) die "Unknown option for git-tree: $1 (see dp --help)" ;;
      esac
    done
    validate_dir "$TARGET_DIR"
    cmd_git_tree_sizes "$TARGET_DIR" "$commit" "$DEPTH"
    ;;
  github-scan)
    rest="$(parse_common_opts "$@")"
    validate_dir "$TARGET_DIR"
    cmd_github_limit_scan "$TARGET_DIR"
    ;;
  *)
    err "Unknown command: $cmd"
    usage
    exit 1
    ;;
esac

#!/usr/bin/env zsh
# =========================================================
# w_h_lang_nghiem.zsh
# 📿 TỤNG KINH / CHÚ LĂNG NGHIÊM – Terminal (Zsh)
# - chạy được ở mọi thư mục dự án (git root / LN_BASE / script root)
# - không cần perl, dùng read -t -k của zsh
# =========================================================

# ---- ANSI COLORS ----
_ln_reset=$'\033[0m'
_ln_bold=$'\033[1m'

_ln_red=$'\033[31m'
_ln_green=$'\033[32m'
_ln_white=$'\033[37m'
_ln_yellow=$'\033[33m'
_ln_gray=$'\033[90m'

# ---- Color for main text (phiên âm) ----
_ln_color_main() {
  local k=$1
  local r=$(( (k - 1) % 12 ))
  if   [[ $r -lt 3 ]]; then echo $_ln_red
  elif [[ $r -lt 6 ]]; then echo $_ln_green
  elif [[ $r -lt 9 ]]; then echo $_ln_white
  else                    echo $_ln_yellow
  fi
}

# ---- Color for Chinese text (sau #) ----
_ln_color_han() {
  local k=$1
  local r=$(( (k - 1) % 12 ))
  if   [[ $r -lt 3 ]]; then echo $_ln_white
  elif [[ $r -lt 6 ]]; then echo $_ln_yellow
  elif [[ $r -lt 9 ]]; then echo $_ln_red
  else                    echo $_ln_green
  fi
}

# =========================================================
# Root resolver: git root -> LN_BASE -> script root
# =========================================================
_ln_git_root() {
  command git rev-parse --show-toplevel 2>/dev/null
}

_ln_script_root() {
  # thư mục chứa file này
  local SCRIPT_DIR="${${(%):-%x}:A:h}"
  # file đang nằm ở win_home_sh/ => root repo = parent của win_home_sh
  echo "${SCRIPT_DIR:h}"
}

_ln_pick_root() {
  local gr="$(_ln_git_root)"
  if [[ -n "$gr" && -d "$gr" ]]; then
    echo "$gr"
    return
  fi

  # nếu thầy có LN_BASE trỏ tới repo chứa md_files
  if [[ -n "$LN_BASE" && -d "$LN_BASE" ]]; then
    echo "$LN_BASE"
    return
  fi

  echo "$(_ln_script_root)"
}

# =========================================================
# Main function
# Usage:
#   lang_nghiem            # đọc 12 câu đầu
#   lang_nghiem 157        # từ câu 157 -> tự tính 12 câu
#   lang_nghiem 157 168    # từ 157 -> 168
#   lang_nghiem lang_nghiem.md 157 168
#   lang_nghiem chu_lang_nghiem.md
# Env:
#   LN_TIMEOUT=3
# =========================================================
lang_nghiem () {
  local ROOT_DIR="$(_ln_pick_root)"
  local MD_DIR="${ROOT_DIR}/md_files"

  local START_LINE=1
  local END_LINE=""
  local IN=""
  local MD_FILE=""
  local NUM_RE='^[0-9]+$'

  local MANUAL_TIMEOUT="${LN_TIMEOUT:-3}"

  # ---- parse args ----
  if [[ "$1" =~ $NUM_RE ]]; then
    START_LINE="$1"
    [[ "$2" =~ $NUM_RE ]] && END_LINE="$2"
    [[ -n "$2" && ! "$2" =~ $NUM_RE ]] && IN="$2"
    [[ -n "$3" && ! "$3" =~ $NUM_RE ]] && IN="$3"
  elif [[ -n "$1" ]]; then
    IN="$1"
    [[ "$2" =~ $NUM_RE ]] && START_LINE="$2"
    [[ "$3" =~ $NUM_RE ]] && END_LINE="$3"
  fi

  # ---- file name normalize ----
  [[ "$IN" == *.md ]] || [[ -z "$IN" ]] || IN="${IN}.md"

  # ---- find file (ưu tiên md_files) ----
  MD_FILE="${MD_DIR}/${IN:-lang_nghiem.md}"
  [[ -f "$MD_FILE" ]] || MD_FILE="${ROOT_DIR}/${IN:-lang_nghiem.md}"
  [[ -f "$MD_FILE" ]] || { echo "❌ Không thấy file: ${IN:-lang_nghiem.md}"; echo "   ROOT=$ROOT_DIR"; return 1; }

  # ---- compute END_LINE to block of 12 ----
  [[ -z "$END_LINE" ]] && END_LINE=$(( ((START_LINE + 11) / 12) * 12 ))

  clear
  echo "📿 TỤNG KINH / CHÚ LĂNG NGHIÊM"
  echo "File: $MD_FILE"
  echo "Từ câu: $START_LINE  →  $END_LINE"
  echo "Auto-advance: ${MANUAL_TIMEOUT}s | q/ESC: thoát"
  echo "----------------------------------------"

  local verse_no=0
  local raw main han c_main c_han key

  while IFS= read -r raw; do
    [[ -z "${raw//[[:space:]]/}" ]] && continue
    ((verse_no++))

    ((verse_no < START_LINE)) && continue
    ((verse_no > END_LINE)) && break

    main="${raw%%#*}"
    han=""
    [[ "$raw" == *"#"* ]] && han="${raw#*#}"

    c_main="$(_ln_color_main $verse_no)"
    c_han="$(_ln_color_han $verse_no)"

    print -r -- \
"${_ln_bold}${c_main}${main}${_ln_reset}${_ln_gray}#${_ln_reset}${_ln_bold}${c_han} ${han}${_ln_reset}"

    # ---- key wait (zsh native) ----
    key=""
    if read -r -t "$MANUAL_TIMEOUT" -k 1 key; then
      # got key
      :
    else
      # timeout
      key=""
    fi

    [[ "$key" == [qQ] || "$key" == $'\e' ]] && break
  done < "$MD_FILE"

  echo
  echo "🙏 Hết đoạn. Nam Mô A Di Đà Phật."
}

# alias ln (đỡ đụng command ln của hệ thống)
ln () {
  if [[ $# -eq 0 || "$1" =~ '^[0-9]+$' || "$1" == *.md || "$1" == lang_nghiem* || "$1" == chu_* ]]; then
    lang_nghiem "$@"
  else
    command ln "$@"
  fi
}

# ---------------------------------------------------------
# 📌 Quick hint (hiện khi source file)
# ---------------------------------------------------------
echo ""
echo "📿 Lang Nghiem ready."
echo "   ln            → 12 câu đầu"
echo "   ln 12         → 1→12"
echo "   ln 12 17      → 12→17"
echo "   ln 157        → 157→168"
echo ""


# alias nạp source 
alias sz='source ~/.bashrc && echo "🔄 ~/.bashrc reloaded"'



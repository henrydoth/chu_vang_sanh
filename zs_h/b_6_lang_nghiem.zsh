#!/usr/bin/env zsh
# =========================================================
# b_6_lang_nghiem.zsh
# 📿 TỤNG KINH LĂNG NGHIÊM – MANUAL
# =========================================================

lang_nghiem () {

  # ---- PATHS ----
  SCRIPT_DIR="${0:A:h}"
  ROOT_DIR="${SCRIPT_DIR:h}"
  MD_DIR="${ROOT_DIR}/md_files"

  IN="${1:-lang_nghiem.md}"
  [[ "$IN" == *.md ]] || IN="${IN}.md"
  MD_FILE="${MD_DIR}/${IN}"

  # ---- CHECK ----
  [[ -d "$MD_DIR" ]] || { echo "❌ Không thấy thư mục: $MD_DIR"; return 1; }
  [[ -f "$MD_FILE" ]] || { echo "❌ Không thấy file: $MD_FILE"; return 1; }

  # ---- COLORS ----
  RESET=$'\033[0m'
  BOLD=$'\033[1m'
  colors=(
    $'\033[31m'  # red
    $'\033[35m'  # magenta
    $'\033[32m'  # green
    $'\033[36m'  # cyan
    $'\033[34m'  # blue
    $'\033[33m'  # yellow
  )

  clear
  echo "📿 TỤNG KINH LĂNG NGHIÊM"
  echo "File : $MD_FILE"
  echo "Mode : MANUAL (SPACE / ENTER)"
  echo "q / ESC để thoát"
  echo "----------------------------------------"

  local i=0
  while IFS= read -r raw; do
    [[ -z "${raw//[[:space:]]/}" ]] && continue
    line="${raw#$'\ufeff'}"

    color="${colors[$(( i % ${#colors[@]} ))+1]}"
    echo "${BOLD}${color}${line}${RESET}"
    ((i++))

    local key=""
    read -r -k 1 -s key </dev/tty || break
    [[ "$key" == "q" || "$key" == $'\e' ]] && break
  done < "$MD_FILE"

  echo
  echo "🙏 Hết Kinh. Nam Mô A Di Đà Phật."
}

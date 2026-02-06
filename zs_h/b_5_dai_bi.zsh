#!/usr/bin/env zsh
# =========================================================
# b_5_dai_bi.zsh
# 📿 TỤNG (CHUNG) – đọc từ md_files/*.md
# =========================================================

b_5_dai_bi () {

  # ---- PATHS (FIXED FOR SOURCE) ----
  local SCRIPT_DIR="${${(%):-%x}:A:h}"   # .../chu_vang_sanh/zs_h
  local ROOT_DIR="${SCRIPT_DIR:h}"        # .../chu_vang_sanh
  local MD_DIR="${ROOT_DIR}/md_files"

  # ---- ARGS ----
  local IN="${1:-chu_dai_bi.md}"
  local MODE="${2:-manual}"    # manual | auto
  local DELAY="${3:-1.5}"

  [[ "$IN" == *.md ]] || IN="${IN}.md"
  local MD_FILE="${MD_DIR}/${IN}"

  # ---- CHECK ----
  [[ -d "$MD_DIR" ]] || { echo "❌ Không thấy thư mục: $MD_DIR"; return 1; }
  [[ -f "$MD_FILE" ]] || { echo "❌ Không thấy file: $MD_FILE"; return 1; }

  # ---- COLORS ----
  local RESET=$'\033[0m'
  local BOLD=$'\033[1m'
  local colors=(
    $'\033[31m' $'\033[33m' $'\033[32m'
    $'\033[36m' $'\033[34m' $'\033[35m'
  )

  clear
  echo "📿 TỤNG | $MD_FILE"
  echo "Mode : $MODE | Delay : ${DELAY}s"
  echo "SPACE / ENTER | q / ESC thoát"
  echo "----------------------------------------"

  local i=0 raw line color key

  while IFS= read -r raw; do
    [[ -z "${raw//[[:space:]]/}" ]] && continue

    line="${raw#$'\ufeff'}"
    [[ "$line" == fNam-* ]] && line="${line#f}"

    color="${colors[$(( i % ${#colors[@]} ))+1]}"
    echo "${BOLD}${color}${line}${RESET}"
    ((i++))

    key=""
    if [[ "$MODE" == auto ]]; then
      read -r -k 1 -s -t "$DELAY" key </dev/tty 2>/dev/null || true
    else
      read -r -k 1 -s key </dev/tty 2>/dev/null || true
    fi

    [[ "$key" == q || "$key" == $'\e' ]] && break
  done < "$MD_FILE"

  echo
  echo "🙏 Nam Mô A Di Đà Phật."
}

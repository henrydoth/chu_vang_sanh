#!/usr/bin/env bash
# =========================================================
# w_h_lang_nghiem.bash
# 📿 TỤNG KINH / CHÚ LĂNG NGHIÊM – Terminal (Git Bash)
# - chạy ở mọi thư mục: ưu tiên git root -> LN_BASE -> default path
# - dùng read -t -n 1 (bash), không perl, không zsh
# - FIX: số thứ tự in đúng tuyệt đối (không bị rớt số)
# =========================================================

# ---- ANSI COLORS ----
_ln_reset=$'\033[0m'
_ln_bold=$'\033[1m'

_ln_red=$'\033[31m'
_ln_green=$'\033[32m'
_ln_white=$'\033[37m'
_ln_yellow=$'\033[33m'
_ln_gray=$'\033[90m'

_ln_color_main () {
  local k="$1"
  local r=$(( (k - 1) % 12 ))
  if   (( r < 3 )); then echo "$_ln_red"
  elif (( r < 6 )); then echo "$_ln_green"
  elif (( r < 9 )); then echo "$_ln_white"
  else                  echo "$_ln_yellow"
  fi
}

_ln_color_han () {
  local k="$1"
  local r=$(( (k - 1) % 12 ))
  if   (( r < 3 )); then echo "$_ln_white"
  elif (( r < 6 )); then echo "$_ln_yellow"
  elif (( r < 9 )); then echo "$_ln_red"
  else                  echo "$_ln_green"
  fi
}

_ln_git_root () {
  command git rev-parse --show-toplevel 2>/dev/null
}

_ln_pick_root () {
  local gr
  gr="$(_ln_git_root)"
  if [[ -n "$gr" && -d "$gr" ]]; then
    echo "$gr"; return
  fi

  # nếu thầy có set LN_BASE
  if [[ -n "${LN_BASE:-}" && -d "$LN_BASE" ]]; then
    echo "$LN_BASE"; return
  fi

  # fallback: repo chu_vang_sanh mặc định của thầy
  echo "/d/GitHub/chu_vang_sanh"
}

lang_nghiem () {
  local ROOT_DIR MD_DIR START_LINE END_LINE IN MD_FILE
  local MANUAL_TIMEOUT NUM_RE
  ROOT_DIR="$(_ln_pick_root)"
  MD_DIR="${ROOT_DIR}/md_files"

  START_LINE=1
  END_LINE=""
  IN=""
  NUM_RE='^[0-9]+$'
  MANUAL_TIMEOUT="${LN_TIMEOUT:-3}"

  # ---- parse args ----
  if [[ "${1:-}" =~ $NUM_RE ]]; then
    START_LINE="$1"
    [[ "${2:-}" =~ $NUM_RE ]] && END_LINE="$2"
    [[ -n "${2:-}" && ! "${2:-}" =~ $NUM_RE ]] && IN="$2"
    [[ -n "${3:-}" && ! "${3:-}" =~ $NUM_RE ]] && IN="$3"
  elif [[ -n "${1:-}" ]]; then
    IN="$1"
    [[ "${2:-}" =~ $NUM_RE ]] && START_LINE="$2"
    [[ "${3:-}" =~ $NUM_RE ]] && END_LINE="$3"
  fi

  [[ -n "$IN" && "$IN" != *.md ]] && IN="${IN}.md"

  # ---- find file (ưu tiên md_files) ----
  MD_FILE="${MD_DIR}/${IN:-lang_nghiem.md}"
  [[ -f "$MD_FILE" ]] || MD_FILE="${ROOT_DIR}/${IN:-lang_nghiem.md}"

  # fallback cứng theo đường dẫn thầy nói
  [[ -f "$MD_FILE" ]] || MD_FILE="/d/GitHub/chu_vang_sanh/md_files/lang_nghiem.md"

  [[ -f "$MD_FILE" ]] || {
    echo "❌ Không thấy file: ${IN:-lang_nghiem.md}"
    echo "   ROOT=$ROOT_DIR"
    return 1
  }

  [[ -z "$END_LINE" ]] && END_LINE=$(( ((START_LINE + 11) / 12) * 12 ))

  clear
  echo "📿 TỤNG KINH / CHÚ LĂNG NGHIÊM"
  echo "File: $MD_FILE"
  echo "Từ câu: $START_LINE  →  $END_LINE"
  echo "Auto-advance: ${MANUAL_TIMEOUT}s | q: thoát"
  echo "----------------------------------------"

  local verse_no=0 raw main han c_main c_han key
  while IFS= read -r raw; do
    [[ -z "${raw//[[:space:]]/}" ]] && continue
    verse_no=$((verse_no + 1))

    (( verse_no < START_LINE )) && continue
    (( verse_no > END_LINE )) && break

    main="${raw%%#*}"
    han=""
    [[ "$raw" == *"#"* ]] && han="${raw#*#}"

    # ✅ bỏ số đầu dòng có sẵn trong file: "157. " hoặc "157) "
    main="$(echo "$main" | sed -E 's/^[[:space:]]*[0-9]+[.)][[:space:]]*//')"

    c_main="$(_ln_color_main "$verse_no")"
    c_han="$(_ln_color_han  "$verse_no")"

    # ✅ in số bằng verse_no (đúng tuyệt đối), canh đẹp
    printf "%s%3d.%s %s%s%s#%s%s %s%s\n" \
      "$_ln_gray" "$verse_no" "$_ln_reset" \
      "$_ln_bold" "$c_main" "$main" "$_ln_reset" \
      "$_ln_gray" "$_ln_reset" "$_ln_bold" "$han" "$_ln_reset"

    key=""
    # đọc 1 phím trong MANUAL_TIMEOUT giây
    IFS= read -r -t "$MANUAL_TIMEOUT" -n 1 key 2>/dev/null || true
    [[ "$key" == "q" || "$key" == "Q" ]] && break
  done < "$MD_FILE"

  echo
  echo "🙏 Hết đoạn. Nam Mô A Di Đà Phật."
}

# alias "ln" (khỏi đụng lệnh ln hệ thống)
ln () {
  if [[ $# -eq 0 || "${1:-}" =~ ^[0-9]+$ || "${1:-}" == *.md || "${1:-}" == lang_nghiem* || "${1:-}" == chu_* ]]; then
    lang_nghiem "$@"
  else
    command ln "$@"
  fi
}

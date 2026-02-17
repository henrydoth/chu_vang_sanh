#!/usr/bin/env bash
# ==========================================
# ln_lang_nghiem.bash (SIMPLE + KEYWORD PICK)
# Usage:
#   ln 13            # 13 -> 24 (auto block 12)
#   ln 13 27         # 13 -> 27 (giữ kiểu cũ)
#   lnk "tát đát"     # liệt kê match -> chọn -> tụng tới hết block 12
# Keys while chanting:
#   any key = next
#   q or ESC = quit
# ==========================================

LN_FILE="/d/GitHub/chu_vang_sanh/md_files/lang_nghiem.md"

# ANSI
_reset=$'\033[0m'
_bold=$'\033[1m'
_red=$'\033[31m'
_green=$'\033[32m'
_white=$'\033[37m'
_yellow=$'\033[33m'
_gray=$'\033[90m'

# Phiên âm: 12 câu / vòng -> 3 đỏ, 3 xanh, 3 trắng, 3 vàng
_ln_color_main() {
  local n="$1"
  local r=$(( (n - 1) % 12 ))
  if   (( r < 3 )); then echo "$_red"
  elif (( r < 6 )); then echo "$_green"
  elif (( r < 9 )); then echo "$_white"
  else                  echo "$_yellow"
  fi
}

# Hán: 12 câu / vòng -> 3 trắng, 3 vàng, 3 đỏ, 3 xanh
_ln_color_han() {
  local n="$1"
  local r=$(( (n - 1) % 12 ))
  if   (( r < 3 )); then echo "$_white"
  elif (( r < 6 )); then echo "$_yellow"
  elif (( r < 9 )); then echo "$_red"
  else                  echo "$_green"
  fi
}

# ==========================================
# ln: tụng theo số
# - ln N      -> N → bội 12 kế tiếp (vd 2→12, 13→24)
# - ln A B    -> A → B (giữ kiểu cũ)
# ==========================================
ln() {
  local start="${1:-1}"
  local end="${2:-0}"

  [[ -f "$LN_FILE" ]] || { echo "❌ Không thấy file: $LN_FILE"; return 1; }
  [[ "$start" =~ ^[0-9]+$ ]] || { echo "❌ start phải là số"; return 1; }
  [[ "$end"   =~ ^[0-9]+$ ]] || { echo "❌ end phải là số"; return 1; }

  # Nếu không nhập end (end=0) -> chạy tới bội số 12 kế tiếp
  if (( end == 0 )); then
    end=$(( ((start - 1) / 12 + 1) * 12 ))
  fi

  # Không cho end vượt quá số dòng thực tế
  local total
  total="$(wc -l < "$LN_FILE" 2>/dev/null)"
  [[ "$total" =~ ^[0-9]+$ ]] || total=0
  (( total > 0 && end > total )) && end="$total"

  # Nếu nhập ngược thì đảo lại
  if (( end < start )); then
    local tmp="$start"; start="$end"; end="$tmp"
  fi

  clear
  echo "📿 TỤNG KINH / CHÚ LĂNG NGHIÊM"
  echo "File: $LN_FILE"
  echo "Từ câu: $start → $end"
  echo "Phím bất kỳ: câu kế | q/ESC: thoát"
  echo "----------------------------------------"

  local i raw main han key c_main c_han
  trap 'stty echo < /dev/tty 2>/dev/null' EXIT

  for (( i=start; i<=end; i++ )); do
    raw="$(sed -n "${i}p" "$LN_FILE")"

    if [[ -z "${raw//[[:space:]]/}" ]]; then
      echo "${_gray}$(printf "%03d" "$i"). (trống)${_reset}"
    else
      main="${raw%%#*}"
      han=""
      [[ "$raw" == *"#"* ]] && han="${raw#*#}"

      main="$(echo "$main" | sed -E 's/^[[:space:]]*[0-9]+[.)][[:space:]]*//')"

      c_main="$(_ln_color_main "$i")"
      c_han="$(_ln_color_han "$i")"

      printf "%s%03d.%s %s%s%s%s" \
        "$_gray" "$i" "$_reset" \
        "$_bold" "$c_main" "$main" "$_reset"

      if [[ -n "${han//[[:space:]]/}" ]]; then
        printf " %s#%s %s%s%s%s" \
          "$_gray" "$_reset" \
          "$_bold" "$c_han" "$han" "$_reset"
      fi
      printf "\n"
    fi

    key=""
    stty -echo < /dev/tty 2>/dev/null
    IFS= read -r -n 1 key < /dev/tty 2>/dev/null || true
    stty echo < /dev/tty 2>/dev/tty 2>/dev/null || true

    [[ "$key" == $'\e' || "$key" == "q" || "$key" == "Q" ]] && break
  done

  echo
  echo "🙏 Hết đoạn. Nam Mô A Di Đà Phật."
}

# ==========================================
# lnk: tìm keyword -> liệt kê match -> chọn -> tụng tới hết block 12
# ==========================================
lnk() {
  local kw="$*"
  [[ -n "${kw//[[:space:]]/}" ]] || { echo '❌ Nhập từ khoá. Ví dụ: lnk "tát đát"'; return 1; }
  [[ -f "$LN_FILE" ]] || { echo "❌ Không thấy file: $LN_FILE"; return 1; }

  # Liệt kê tất cả match (line_no:line_text)
  local matches
  matches="$(grep -in -- "$kw" "$LN_FILE" 2>/dev/null | head -n 200)"
  [[ -n "$matches" ]] || { echo "❌ Không tìm thấy: $kw"; return 1; }

  echo "🔎 Tìm thấy các câu có: \"$kw\""
  echo "----------------------------------------"
  # In gọn: 003. <đoạn trước #>
  echo "$matches" | while IFS=: read -r n line; do
    # lấy phần trước # cho gọn
    local before="${line%%#*}"
    before="$(echo "$before" | sed -E 's/^[[:space:]]*[0-9]+[.)][[:space:]]*//')"
    printf "%s%03d%s  %s\n" "$_gray" "$n" "$_reset" "$before"
  done
  echo "----------------------------------------"
  echo "Nhập số câu muốn tụng (vd 1 hoặc 5 hoặc 174). Enter = câu đầu tiên. q = thoát"
  printf "> "

  local pick
  IFS= read -r pick < /dev/tty 2>/dev/null || pick=""
  [[ "$pick" == "q" || "$pick" == "Q" ]] && return 0

  local start
  if [[ -z "${pick//[[:space:]]/}" ]]; then
    # mặc định: lấy match đầu tiên
    start="$(echo "$matches" | head -n 1 | cut -d: -f1)"
  else
    [[ "$pick" =~ ^[0-9]+$ ]] || { echo "❌ Phải nhập số."; return 1; }
    start="$pick"
  fi

  local end=$(( ((start - 1) / 12 + 1) * 12 ))
  ln "$start" "$end"
}

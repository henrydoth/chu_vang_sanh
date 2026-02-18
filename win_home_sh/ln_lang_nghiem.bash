#!/usr/bin/env bash
# ==========================================
# ln_lang_nghiem.bash (SIMPLE + KEYWORD PICK)
# Usage:
#   ln 13             # 13 -> 24 (auto block 12)
#   ln 13 27          # 13 -> 27 (giữ kiểu cũ)
#   ln 0*             # 1  -> 12   (block 0)
#   ln 1*             # 13 -> 24   (block 1)
#   ln 2*             # 25 -> 36   (block 2)
#   ln 3*             # 37 -> 48   (block 3)
#   ln 0* 1* 2*       # gộp nhiều block, hiển thị LIỀN MẠCH (vd 1→36)
#   ln 0*:2*          # range block: block 0 tới 2 (vd 1→36)
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
# - ln N          -> N → bội 12 kế tiếp (vd 2→12, 13→24)
# - ln A B        -> A → B (giữ kiểu cũ)
# - ln K*         -> block K (0* = 1→12; 1* = 13→24; 2* = 25→36; ...)
# - ln 0* 1* 2*   -> gộp nhiều block và tụng LIỀN MẠCH (vd 1→36)
# - ln 0*:2*      -> range block K*:M* (vd 1→36)
# ==========================================
ln() {
  [[ -f "$LN_FILE" ]] || { echo "❌ Không thấy file: $LN_FILE"; return 1; }

  # ---- Range block: ln K*:M* ----
  if [[ "${1:-}" =~ ^([0-9]+)\*:([0-9]+)\*$ ]]; then
    local b1="${BASH_REMATCH[1]}" b2="${BASH_REMATCH[2]}"
    (( b2 < b1 )) && { local t="$b1"; b1="$b2"; b2="$t"; }
    ln "$(( b1*12 + 1 ))" "$(( (b2+1)*12 ))"
    return 0
  fi

  # ranges: mảng các đoạn "start:end"
  local ranges=()

  # ---- Multi-block: ln 0* 1* 2* (LIỀN MẠCH) ----
  local all_block_mode=true
  if (( $# == 0 )); then
    all_block_mode=false
  else
    for arg in "$@"; do
      [[ "$arg" =~ ^[0-9]+\*$ ]] || { all_block_mode=false; break; }
    done
  fi

  if [[ "$all_block_mode" == true ]]; then
    local blocks_sorted
    blocks_sorted="$(printf "%s\n" "$@" | sed 's/\*$//' | sort -n | uniq)"

    local first=1 cur_s=0 cur_e=0 b s e
    while IFS= read -r b; do
      [[ -n "$b" ]] || continue
      s=$(( b * 12 + 1 ))
      e=$(( s + 11 ))

      if (( first == 1 )); then
        cur_s=$s; cur_e=$e; first=0
      else
        if (( s <= cur_e + 1 )); then
          (( e > cur_e )) && cur_e=$e
        else
          ranges+=( "${cur_s}:${cur_e}" )
          cur_s=$s; cur_e=$e
        fi
      fi
    done <<< "$blocks_sorted"
    (( first == 0 )) && ranges+=( "${cur_s}:${cur_e}" )

  else
    # ---- Normal: ln N / ln A B / ln K* ----
    local start="${1:-1}"
    local end="${2:-0}"

    if [[ "$start" =~ ^([0-9]+)\*$ ]]; then
      local block="${BASH_REMATCH[1]}"
      start=$(( block * 12 + 1 ))
      end=$(( start + 11 ))
    fi

    [[ "$start" =~ ^[0-9]+$ ]] || { echo "❌ start phải là số hoặc dạng K* (vd 0*, 1*, 2*)"; return 1; }
    [[ "$end"   =~ ^[0-9]+$ ]] || { echo "❌ end phải là số"; return 1; }

    if (( end == 0 )); then
      end=$(( ((start - 1) / 12 + 1) * 12 ))
    fi

    (( end < start )) && { local t="$start"; start="$end"; end="$t"; }
    ranges+=( "${start}:${end}" )
  fi

  # ---- Clamp theo số dòng ----
  local total
  total="$(wc -l < "$LN_FILE" 2>/dev/null)"
  [[ "$total" =~ ^[0-9]+$ ]] || total=0

  local fixed_ranges=() r rs re
  for r in "${ranges[@]}"; do
    rs="${r%%:*}"; re="${r##*:}"
    (( total > 0 && re > total )) && re="$total"
    (( total > 0 && rs > total )) && continue
    fixed_ranges+=( "${rs}:${re}" )
  done
  ranges=( "${fixed_ranges[@]}" )
  (( ${#ranges[@]} == 0 )) && { echo "❌ Không có đoạn hợp lệ để tụng."; return 1; }

  # ---- Header 1 lần (+ thêm Block info) ----
  clear
  echo "📿 TỤNG KINH / CHÚ LĂNG NGHIÊM"
  echo "File: $LN_FILE"
  if (( ${#ranges[@]} == 1 )); then
    local rs="${ranges[0]%%:*}"
    local re="${ranges[0]##*:}"
    echo "Từ câu: $rs → $re"

    local b_start=$(( (rs - 1) / 12 ))
    local b_end=$(( (re - 1) / 12 ))
    if (( b_start == b_end )); then
      echo "Block: ${b_start}*12"
    else
      echo "Block: ${b_start}*12 → ${b_end}*12"
    fi
  else
    echo "Đoạn tụng:"
    for r in "${ranges[@]}"; do
      echo "  - ${r%%:*} → ${r##*:}"
    done
  fi
  echo "Phím bất kỳ: câu kế | q/ESC: thoát"
  echo "----------------------------------------"

  local i raw main han key c_main c_han stop=0
  trap 'stty echo < /dev/tty 2>/dev/null' EXIT

  for r in "${ranges[@]}"; do
    local start="${r%%:*}"
    local end="${r##*:}"

    for (( i=start; i<=end; i++ )); do
      raw="$(sed -n "${i}p" "$LN_FILE")"

      if [[ -z "${raw//[[:space:]]/}" ]]; then
        echo "${_gray}$(printf "%d" "$i"). (trống)${_reset}"
      else
        main="${raw%%#*}"
        han=""
        [[ "$raw" == *"#"* ]] && han="${raw#*#}"
        main="$(echo "$main" | sed -E 's/^[[:space:]]*[0-9]+[.)][[:space:]]*//')"

        c_main="$(_ln_color_main "$i")"
        c_han="$(_ln_color_han "$i")"

        printf "%s%d.%s %s%s%s%s" \
          "$_gray" "$i" "$_reset" \
          "$_bold" "$c_main" "$main" "$_reset"

        if [[ -n "${han//[[:space:]]/}" ]]; then
          printf " %s#%s %s%s%s%s" \
            "$_gray" "$_reset" \
            "$_bold" "$c_han" "$han" "$_reset"
        fi
        printf "\n"
      fi

      stty -echo < /dev/tty 2>/dev/null
      IFS= read -r -n 1 key < /dev/tty 2>/dev/null || true
      stty echo < /dev/tty 2>/dev/null || true

      if [[ "$key" == $'\e' || "$key" == "q" || "$key" == "Q" ]]; then
        stop=1
        break
      fi
    done
    (( stop == 1 )) && break
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

  local matches
  matches="$(grep -in -- "$kw" "$LN_FILE" 2>/dev/null | head -n 200)"
  [[ -n "$matches" ]] || { echo "❌ Không tìm thấy: $kw"; return 1; }

  echo "🔎 Tìm thấy các câu có: \"$kw\""
  echo "----------------------------------------"
  echo "$matches" | while IFS=: read -r n line; do
    local before="${line%%#*}"
    before="$(echo "$before" | sed -E 's/^[[:space:]]*[0-9]+[.)][[:space:]]*//')"
    printf "%s%d%s  %s\n" "$_gray" "$n" "$_reset" "$before"
  done
  echo "----------------------------------------"
  echo "Nhập số câu muốn tụng (vd 1 hoặc 5 hoặc 174). Enter = câu đầu tiên. q = thoát"
  printf "> "

  local pick
  IFS= read -r pick < /dev/tty 2>/dev/null || pick=""
  [[ "$pick" == "q" || "$pick" == "Q" ]] && return 0

  local start
  if [[ -z "${pick//[[:space:]]/}" ]]; then
    start="$(echo "$matches" | head -n 1 | cut -d: -f1)"
  else
    [[ "$pick" =~ ^[0-9]+$ ]] || { echo "❌ Phải nhập số."; return 1; }
    start="$pick"
  fi

  ln "$start" $(( ((start - 1) / 12 + 1) * 12 ))
}

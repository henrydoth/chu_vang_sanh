#!/usr/bin/env zsh
# =========================================================
# b_6_lang_nghiem.zsh
# 📿 TỤNG KINH LĂNG NGHIÊM – MANUAL
# =========================================================

lang_nghiem () {
  # ---- PATHS ----
  local SCRIPT_DIR="${${(%):-%x}:A:h}"
  local ROOT_DIR="${SCRIPT_DIR:h}"
  local MD_DIR="${ROOT_DIR}/md_files"

  local START_LINE=1
  local IN=""
  local MD_FILE=""
  local NUM_RE='^[0-9]+$'
  local MANUAL_TIMEOUT="${LN_TIMEOUT:-5}"
  [[ "$MANUAL_TIMEOUT" =~ '^[0-9]+$' && "$MANUAL_TIMEOUT" -ge 1 ]] || MANUAL_TIMEOUT=5

  # Args:
  #   lang_nghiem              -> file mặc định, từ câu 1
  #   lang_nghiem 13           -> file mặc định, từ câu 13
  #   lang_nghiem chu_dai_bi   -> chu_dai_bi.md, từ câu 1
  #   lang_nghiem 13 chu_dai_bi -> chu_dai_bi.md, từ câu 13
  if [[ -n "$1" ]]; then
    if [[ "$1" =~ $NUM_RE ]]; then
      START_LINE="$1"
      [[ -n "$2" ]] && IN="$2"
    else
      IN="$1"
      [[ -n "$2" && "$2" =~ $NUM_RE ]] && START_LINE="$2"
    fi
  fi

  # Mặc định tự tìm file hợp lệ
  if [[ -z "$IN" ]]; then
    if [[ -f "${MD_DIR}/lang_nghiem.md" ]]; then
      MD_FILE="${MD_DIR}/lang_nghiem.md"
    elif [[ -f "${ROOT_DIR}/lang_nghiem_chi.md" ]]; then
      MD_FILE="${ROOT_DIR}/lang_nghiem_chi.md"
    else
      MD_FILE=""
    fi
  else
    [[ "$IN" == *.md ]] || IN="${IN}.md"
    if [[ -f "${MD_DIR}/${IN}" ]]; then
      MD_FILE="${MD_DIR}/${IN}"
    elif [[ -f "${ROOT_DIR}/${IN}" ]]; then
      MD_FILE="${ROOT_DIR}/${IN}"
    else
      MD_FILE="${MD_DIR}/${IN}"
    fi
  fi

  # ---- CHECK ----
  [[ -d "$MD_DIR" ]] || { echo "❌ Không thấy thư mục: $MD_DIR"; return 1; }
  [[ "$START_LINE" =~ $NUM_RE && "$START_LINE" -ge 1 ]] || {
    echo "❌ Số câu bắt đầu phải là số nguyên dương."
    return 1
  }
  [[ -f "$MD_FILE" ]] || {
    echo "❌ Không thấy file: $MD_FILE"
    echo "📂 Các file .md đang có:"
    command ls -1 "$ROOT_DIR"/*.md 2>/dev/null | sed 's|.*/||' || true
    command ls -1 "$MD_DIR"/*.md 2>/dev/null | sed 's|.*/||' || true
    return 1
  }

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
  echo "Từ câu: $START_LINE"
  echo "Mode : MANUAL (SPACE / ENTER)"
  echo "q / ESC để thoát"
  echo "Manual timeout: ${MANUAL_TIMEOUT}s (không bấm sẽ tự chạy)"
  echo "----------------------------------------"

  local i=0
  local verse_no=0

  while IFS= read -r raw; do
    [[ -z "${raw//[[:space:]]/}" ]] && continue
    line="${raw#$'\ufeff'}"
    ((verse_no++))
    ((verse_no < START_LINE)) && continue

    color="${colors[$(( i % ${#colors[@]} ))+1]}"
    echo "${BOLD}${color}${line}${RESET}"
    ((i++))

    # Chờ 1 phím từ /dev/tty tối đa MANUAL_TIMEOUT giây.
    # Không bấm gì -> tự qua câu kế.
    local key=""
    key="$(perl -e '
      use IO::Select;
      my $t = shift;
      open my $tty, "<", "/dev/tty" or exit 0;
      my $sel = IO::Select->new($tty);
      if ($sel->can_read($t)) {
        my $c = "";
        sysread($tty, $c, 1);
        print $c if defined $c;
      }
    ' "$MANUAL_TIMEOUT" 2>/dev/null)"
    [[ "$key" == [qQ] || "$key" == *$'\e'* ]] && break
  done < "$MD_FILE"

  echo
  echo "🙏 Hết Kinh. Nam Mô A Di Đà Phật."
}

# Wrapper để gõ ngắn: ln 13 / ln ten_file
# Vẫn giữ được lệnh ln gốc nếu truyền kiểu tham số tạo symlink.
ln () {
  if [[ $# -eq 0 || "$1" =~ '^[0-9]+$' || "$1" == *.md || "$1" == lang_nghiem* || "$1" == chu_* ]]; then
    lang_nghiem "$@"
  else
    command ln "$@"
  fi
}

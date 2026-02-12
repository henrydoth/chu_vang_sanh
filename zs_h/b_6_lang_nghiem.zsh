#!/usr/bin/env zsh
# =========================================================
# b_6_lang_nghiem.zsh
# 📿 TỤNG KINH LĂNG NGHIÊM – MANUAL
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

lang_nghiem () {
  local SCRIPT_DIR="${${(%):-%x}:A:h}"
  local ROOT_DIR="${SCRIPT_DIR:h}"
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
    [[ "$2" =~ $NUM_RE ]] && END_LINE="$2" && [[ -n "$3" ]] && IN="$3"
    [[ -z "$END_LINE" && -n "$2" && ! "$2" =~ $NUM_RE ]] && IN="$2"
  elif [[ -n "$1" ]]; then
    IN="$1"
    [[ "$2" =~ $NUM_RE ]] && START_LINE="$2"
    [[ "$3" =~ $NUM_RE ]] && END_LINE="$3"
  fi

  # ---- find file ----
  [[ "$IN" == *.md ]] || [[ -z "$IN" ]] || IN="${IN}.md"
  MD_FILE="${MD_DIR}/${IN:-lang_nghiem.md}"
  [[ -f "$MD_FILE" ]] || MD_FILE="${ROOT_DIR}/${IN}"

  [[ -f "$MD_FILE" ]] || { echo "❌ Không thấy file"; return 1; }

  [[ -z "$END_LINE" ]] && END_LINE=$(( ((START_LINE + 11) / 12) * 12 ))

  clear
  echo "📿 TỤNG KINH LĂNG NGHIÊM"
  echo "Từ câu: $START_LINE  →  $END_LINE"
  echo "Auto-advance: ${MANUAL_TIMEOUT}s | q/ESC: thoát"
  echo "----------------------------------------"

  local verse_no=0

  while IFS= read -r raw; do
    [[ -z "${raw//[[:space:]]/}" ]] && continue
    ((verse_no++))

    ((verse_no < START_LINE)) && continue
    ((verse_no > END_LINE)) && break

    local main="${raw%%#*}"
    local han=""
    [[ "$raw" == *"#"* ]] && han="${raw#*#}"

    local c_main="$(_ln_color_main $verse_no)"
    local c_han="$(_ln_color_han $verse_no)"

    print -r -- \
"${_ln_bold}${c_main}${main}${_ln_reset}${_ln_gray}#${_ln_reset}${_ln_bold}${c_han} ${han}${_ln_reset}"

    local key=""
    key="$(perl -e '
      use IO::Select;
      my $t = shift;
      open my $tty, "<", "/dev/tty" or exit;
      my $s = IO::Select->new($tty);
      if ($s->can_read($t)) {
        sysread($tty, my $c, 1);
        print $c;
      }
    ' "$MANUAL_TIMEOUT")"

    [[ "$key" == [qQ] || "$key" == *$'\e'* ]] && break
  done < "$MD_FILE"

  echo
  echo "🙏 Hết đoạn. Nam Mô A Di Đà Phật."
}

ln () {
  if [[ $# -eq 0 || "$1" =~ '^[0-9]+$' || "$1" == *.md || "$1" == lang_nghiem* || "$1" == chu_* ]]; then
    lang_nghiem "$@"
  else
    command ln "$@"
  fi
}

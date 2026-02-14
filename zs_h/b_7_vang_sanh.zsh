#!/usr/bin/env zsh
# =========================================================
# b_7_vang_sanh.zsh
# 📿 TỤNG CHÚ VÃNG SANH
# =========================================================

v_s () {

  local FILE="$CSV_BASE/md_files/chu_vang_sanh.md"
  local WAIT_SEC="${VS_TIMEOUT:-1}"
  [[ "$WAIT_SEC" =~ '^[0-9]+([.][0-9]+)?$' ]] || WAIT_SEC=1

  if [[ ! -f "$FILE" ]]; then
    echo "❌ Không thấy file: $FILE"
    return 1
  fi

  echo
  echo "🙏 Nam Mô A Di Đà Phật"
  echo "📿 Bắt đầu tụng Chú Vãng Sanh"
  echo "q / ESC để thoát | timeout: ${WAIT_SEC}s"
  echo "--------------------------------"

  local key=""
  while IFS= read -r line; do
    # bỏ dòng trống hoặc toàn khoảng trắng
    [[ -z "${line// }" ]] && continue
    echo "  $line"
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
    ' "$WAIT_SEC" 2>/dev/null)"
    [[ "$key" == [qQ] || "$key" == *$'\e'* ]] && break
  done < "$FILE"

  echo "--------------------------------"
  echo "🙏 Hồi hướng công đức"
  echo "🙏 Nam Mô A Di Đà Phật"
  echo
}

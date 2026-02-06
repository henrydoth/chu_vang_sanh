#!/usr/bin/env zsh
# b_3: if + read (an toàn)

echo -n "Nhập câu niệm: "
if ! read PHRASE; then
  echo "\n❌ Bạn đã kết thúc input (EOF/Ctrl+D) nên script dừng."
  exit 1
fi

echo -n "Nhập số lần: "
if ! read COUNT; then
  echo "\n❌ Bạn đã kết thúc input (EOF/Ctrl+D) nên script dừng."
  exit 1
fi

echo "________________"

if [[ -z "$PHRASE" ]]; then
  echo "⚠️  Bạn chưa nhập câu niệm"
else
  echo "📿 Câu niệm: $PHRASE"
fi

if [[ "$COUNT" -gt 0 ]]; then
  echo "🔢 Số lần: $COUNT"
else
  echo "⚠️  Số lần phải > 0"
fi

#!/usr/bin/env zsh

# Usage:
#   ./niem_nam_mo.zsh            # default 21 times, 1 second interval
#   ./niem_nam_mo.zsh 21         # 21 times
#   ./niem_nam_mo.zsh 21 0.5     # 21 times, 0.5 second interval

count="${1:-21}"
delay="${2:-1}"
phrase="Nam Mô A Di Đà Phật"
colors=(31 32 33 34 35 36 91 92 93 94 95 96)

if ! [[ "$count" =~ '^[0-9]+$' ]] || [[ "$count" -le 0 ]]; then
  echo "Số lần niệm phải là số nguyên dương."
  exit 1
fi

for ((i = 1; i <= count; i++)); do
  color="${colors[$(( (i - 1) % ${#colors[@]} + 1 ))]}"
  printf "\033[%sm%3d. %s\033[0m\n" "$color" "$i" "$phrase"
  sleep "$delay"
done

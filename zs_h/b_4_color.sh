#!/usr/bin/env zsh
# b_4: loop + đổi màu RGB

# mã màu ANSI
RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[34m'
RESET='\033[0m'

colors=($RED $GREEN $BLUE)

for i in {1..12}
do
  idx=$(( (i - 1) % 3 ))
  echo "${colors[$idx+1]}A Di Đà Phật${RESET}"
  sleep 1
done

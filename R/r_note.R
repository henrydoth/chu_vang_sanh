# tụng 1 -20 ngẫu nhiên
# 
colors <- c(31, 32, 33, 34, 35, 36)

for (i in 1:20) {
  col <- colors[(i - 1) %% length(colors) + 1]
  cat(sprintf("\033[%dm%02d. Nam mô A Di Đà Phật\033[0m\n", col, i))
  Sys.sleep(1)
}

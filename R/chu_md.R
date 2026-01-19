# =========================================
# TỤNG CHÚ từ Markdown (.md)
# RStudio friendly – dùng here (cross-platform)
# - RStudio Console: có màu
# - Terminal/Rscript: không rác ANSI
# =========================================

# ---- packages ----
if (!requireNamespace("crayon", quietly = TRUE)) {
  install.packages("crayon")
}
if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here")
}

library(crayon)
library(here)

# Nếu chạy bằng Rscript (non-interactive) thì tắt màu để tránh rác ANSI
if (!interactive()) {
  options(crayon.enabled = FALSE)
}

# ---- xác định file markdown theo gốc project ----
md_file <- here::here("chu_vang_sanh.md")

if (!file.exists(md_file)) {
  stop(
    "Khong thay file: ", md_file, "\n",
    "Hay mo dung RStudio Project (chu_vang_sanh.Rproj)"
  )
}

# ---- đọc file markdown (UTF-8 chuẩn) ----
lines <- readLines(md_file, encoding = "UTF-8", warn = FALSE)

# ---- bỏ tiêu đề (# ...) và dòng trống ----
lines <- lines[lines != "" & !grepl("^#", lines)]

# ---- thông báo ----
cat(bold("Bat dau tung tu:"), md_file, "\n\n")

# ---- cấu hình ----
colors <- list(
  yellow,
  cyan,
  green,
  magenta,
  blue,
  white
)

delay <- 2
i <- 0

# ---- tụng từng dòng ----
for (l in lines) {
  i <- i + 1
  f <- colors[[ (i - 1) %% length(colors) + 1 ]]
  cat(f(l), "\n")
  Sys.sleep(delay)
}

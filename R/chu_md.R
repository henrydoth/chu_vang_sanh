# =========================================
# TỤNG CHÚ từ Markdown (.md)
# RStudio friendly – dùng here (cross-platform)
# - In sạch (bỏ khoảng trắng cuối dòng)
# - In đậm + đổi màu từng câu
# - Không hiện log "here() starts at ..."
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

# ---- cố định gốc project & tắt message của here ----
suppressMessages({
  # dựa vào file .Rproj ở root để xác định project
  here::i_am("chu_vang_sanh.Rproj")
})

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

# ---- làm sạch: bỏ khoảng trắng cuối dòng (markdown hard break) ----
lines <- sub("[[:space:]]+$", "", lines)

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
  cat(bold(f(l)), "\n")
  Sys.sleep(delay)
}

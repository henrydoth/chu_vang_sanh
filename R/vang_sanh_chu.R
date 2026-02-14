# =========================================
# VÃNG SANH: tụng trong Console bằng crayon
# - vs()  : bản Việt (bỏ dòng #)
# - vs1() : bản Hoa (lấy dòng #, bỏ dấu #)
# - dùng here() (cross-platform), không hiện message của here
# - có màu theo chu kỳ + delay
# =========================================

# ---- packages ----
if (!requireNamespace("crayon", quietly = TRUE)) install.packages("crayon")
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")

library(crayon)
library(here)

# Nếu chạy bằng Rscript (non-interactive) thì tắt màu để tránh rác ANSI
if (!interactive()) options(crayon.enabled = FALSE)

# ---- locate project root quietly ----
suppressMessages({
  # dựa vào file .Rproj ở root để xác định project
  # (nếu bạn không dùng RStudio Project, có thể bỏ i_am)
  here::i_am("chu_vang_sanh.Rproj")
})

# ---- file path ----
VS_MD <- here::here("chu_vang_sanh.md")

# ---- helpers ----
read_vs_md <- function(path = VS_MD) {
  if (!file.exists(path)) {
    stop("Không thấy file: ", path, "\n",
         "Hãy mở đúng RStudio Project: chu_vang_sanh.Rproj")
  }
  x <- readLines(path, encoding = "UTF-8", warn = FALSE)
  x <- sub("[[:space:]]+$", "", x)          # bỏ khoảng trắng cuối dòng
  x <- x[nzchar(trimws(x))]                 # bỏ dòng trống
  x
}

cycle_colors <- function() {
  list(yellow, cyan, green, magenta, blue, white)
}

# ---- core printer ----
print_with_cycle <- function(lines, delay = 2, colors = cycle_colors(),
                             bold_text = TRUE, header = NULL) {
  if (!is.null(header)) {
    cat(bold(header), "\n\n")
  }
  i <- 0
  for (l in lines) {
    i <- i + 1
    f <- colors[[ (i - 1) %% length(colors) + 1 ]]
    out <- if (bold_text) bold(f(l)) else f(l)
    cat(out, "\n")
    Sys.sleep(delay)
  }
  invisible(lines)
}

# =========================================
# vs(): tụng BẢN VIỆT (bỏ dòng bắt đầu bằng #)
# =========================================
vs <- function(delay = 2, show_header = TRUE) {
  x <- read_vs_md()
  viet <- x[!grepl("^\\s*#", x)]  # bỏ dòng Hán
  if (length(viet) == 0) stop("Không thấy dòng Việt trong file.")
  hdr <- if (show_header) paste0("Bắt đầu tụng (Việt): ", VS_MD) else NULL
  print_with_cycle(viet, delay = delay, colors = cycle_colors(),
                   bold_text = TRUE, header = hdr)
}

# =========================================
# VÃNG SANH: tụng trong Console bằng crayon
# - vs()  : bản Việt (bỏ dòng #)
# - vs1() : bản Hoa (lấy dòng #, bỏ dấu #)
# - dùng here() (cross-platform), không hiện message của here
# - có màu theo chu kỳ + delay
# =========================================

# ---- packages ----
if (!requireNamespace("crayon", quietly = TRUE)) install.packages("crayon")
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")

library(crayon)
library(here)

# Nếu chạy bằng Rscript (non-interactive) thì tắt màu để tránh rác ANSI
if (!interactive()) options(crayon.enabled = FALSE)

# ---- locate project root quietly ----
suppressMessages({
  # dựa vào file .Rproj ở root để xác định project
  # (nếu bạn không dùng RStudio Project, có thể bỏ i_am)
  here::i_am("chu_vang_sanh.Rproj")
})

# ---- file path ----
VS_MD <- here::here("chu_vang_sanh.md")

# ---- helpers ----
read_vs_md <- function(path = VS_MD) {
  if (!file.exists(path)) {
    stop("Không thấy file: ", path, "\n",
         "Hãy mở đúng RStudio Project: chu_vang_sanh.Rproj")
  }
  x <- readLines(path, encoding = "UTF-8", warn = FALSE)
  x <- sub("[[:space:]]+$", "", x)          # bỏ khoảng trắng cuối dòng
  x <- x[nzchar(trimws(x))]                 # bỏ dòng trống
  x
}

cycle_colors <- function() {
  list(yellow, cyan, green, magenta, blue, white)
}

# ---- core printer ----
print_with_cycle <- function(lines, delay = 2, colors = cycle_colors(),
                             bold_text = TRUE, header = NULL) {
  if (!is.null(header)) {
    cat(bold(header), "\n\n")
  }
  i <- 0
  for (l in lines) {
    i <- i + 1
    f <- colors[[ (i - 1) %% length(colors) + 1 ]]
    out <- if (bold_text) bold(f(l)) else f(l)
    cat(out, "\n")
    Sys.sleep(delay)
  }
  invisible(lines)
}

# =========================================
# vs(): tụng BẢN VIỆT (bỏ dòng bắt đầu bằng #)
# =========================================
vs <- function(delay = 2, show_header = TRUE) {
  x <- read_vs_md()
  viet <- x[!grepl("^\\s*#", x)]  # bỏ dòng Hán
  if (length(viet) == 0) stop("Không thấy dòng Việt trong file.")
  hdr <- if (show_header) paste0("Bắt đầu tụng (Việt): ", VS_MD) else NULL
  print_with_cycle(viet, delay = delay, colors = cycle_colors(),
                   bold_text = TRUE, header = hdr)
}
# =========================================
# vs1(): tụng BẢN HOA – đổi màu từng hàng
# =========================================
vs1 <- function(delay = 2, show_header = TRUE) {
  
  # đọc file md
  x <- read_vs_md()
  
  # lấy dòng Hoa (bắt đầu bằng #)
  hoa <- x[grepl("^\\s*#", x)]
  hoa <- sub("^\\s*#\\s*", "", hoa)  # bỏ dấu #
  
  if (length(hoa) == 0) {
    stop("Không thấy dòng Hoa (# ...) trong file.")
  }
  
  # header
  if (show_header) {
    cat(bold("Bắt đầu tụng (Hoa): "), VS_MD, "\n\n")
  }
  
  # bảng màu chu kỳ (có thể chỉnh)
  colors <- list(
    cyan,
    yellow,
    green,
    magenta,
    blue,
    white
  )
  
  # tụng từng dòng – đổi màu mỗi hàng
  i <- 0
  for (l in hoa) {
    i <- i + 1
    f <- colors[[ (i - 1) %% length(colors) + 1 ]]
    cat(bold(f(l)), "\n")
    Sys.sleep(delay)
  }
  
  invisible(hoa)
}


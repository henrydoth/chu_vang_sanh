# =========================================
# LN: TỤNG LĂNG NGHIÊM từ Markdown (.md)
# - Dùng here() theo RStudio Project
# - Không hiện "here() starts at ..."
# - Bỏ phần # chữ Hán (tuỳ chọn)
# - Màu theo chu kỳ 12 dòng: red, pink, white, green, ...
# - Khi hiện Chinese:
#     + dấu # màu xám
#     + chữ Hoa luôn 1 màu cố định (cyan), khác chu kỳ màu Việt
# =========================================

if (!requireNamespace("crayon", quietly = TRUE)) install.packages("crayon")
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")

library(crayon)
library(here)

# Nếu chạy bằng Rscript (non-interactive) thì tắt màu cho sạch
if (!interactive()) options(crayon.enabled = FALSE)

# ---- cố định gốc project & tắt message của here ----
suppressMessages({
  here::i_am("chu_vang_sanh.Rproj")
})

# ---- file nguồn ----
md_file <- here::here("lang_nghiem_chi.md")
if (!file.exists(md_file)) stop("Khong thay file: ", md_file)

# ---- hàm ln() ----
ln <- function(start = 1, end = Inf, delay = 2, show_han = FALSE) {
  
  lines <- readLines(md_file, encoding = "UTF-8", warn = FALSE)
  
  # bỏ khoảng trắng cuối dòng
  lines <- sub("[[:space:]]+$", "", lines)
  
  # bỏ dòng trống
  lines <- lines[lines != ""]
  
  # (tuỳ chọn) bỏ phần chữ Hán sau #
  if (!show_han) {
    lines <- sub("#.*$", "", lines)
    lines <- sub("[[:space:]]+$", "", lines)
    lines <- lines[lines != ""]
  }
  
  # cắt theo start/end
  n <- length(lines)
  if (is.infinite(end)) end <- n
  start <- max(1, as.integer(start))
  end <- min(n, as.integer(end))
  if (start > end) stop("start > end")
  
  cat(crayon::bold("Bat dau tung Lang Nghiem tu:"), md_file, "\n\n")
  
  # ---- chu kỳ 12 màu (PHẦN VIỆT) ----
  colors <- list(
    crayon::red,       # 1
    crayon::magenta,   # 2 pink
    crayon::white,     # 3
    crayon::green,     # 4
    crayon::magenta,   # 5
    crayon::white,     # 6
    crayon::blue,      # 7
    crayon::magenta,   # 8
    crayon::white,     # 9
    crayon::yellow,    # 10
    crayon::magenta,   # 11
    crayon::white      # 12
  )
  
  hash_color <- crayon::silver  # dấu # màu xám
  han_color  <- crayon::cyan    # chữ Hoa luôn cyan (khác chu kỳ)
  
  i <- 0
  for (k in start:end) {
    i <- i + 1
    f <- colors[[ (i - 1) %% 12 + 1 ]]
    
    line <- lines[[k]]
    
    # Nếu show_han và có dấu # -> tách Việt / Hán để tô màu riêng
    if (show_han && grepl("#", line)) {
      parts <- strsplit(line, "#", fixed = TRUE)[[1]]
      viet <- trimws(parts[1])
      han  <- trimws(paste(parts[-1], collapse = "#"))
      
      cat(
        crayon::bold(f(viet)),
        hash_color(" # "),
        crayon::bold(han_color(han)),
        "\n",
        sep = ""
      )
    } else {
      cat(crayon::bold(f(line)), "\n")
    }
    
    Sys.sleep(delay)
  }
  
  invisible(TRUE)
}

# =========================================
# lnnc(): như lnn() nhưng HIỆN CẢ CHINESE sau #
# - GIỮ NGUYÊN màu chu kỳ 12 như ln()/lnn()
# - "# xám + Chinese cyan" do ln() xử lý
# lnnc(n)      -> chu kỳ n (12 dòng)
# lnnc(n1, n2) -> chu kỳ n1..n2
# =========================================

lnnc <- function(n1, n2 = NULL, delay = 2) {
  
  if (!is.numeric(n1) || n1 < 0 || n1 != as.integer(n1)) {
    stop("n1 phai la so nguyen >= 0")
  }
  if (!is.null(n2)) {
    if (!is.numeric(n2) || n2 < n1 || n2 != as.integer(n2)) {
      stop("n2 phai la so nguyen >= n1")
    }
  } else {
    n2 <- n1
  }
  
  start <- n1 * 12 + 1
  end   <- n2 * 12 + 12
  
  ln(
    start = start,
    end   = end,
    delay = delay,
    show_han = TRUE
  )
}

# =========================================
# LN: TỤNG LĂNG NGHIÊM từ Markdown (.md)
# - Dùng here() theo RStudio Project
# - Không hiện "here() starts at ..."
# - Bỏ phần # chữ Hán (tuỳ chọn)
# - Màu theo chu kỳ 12 dòng: red, pink, white, green, ...
# - Khi hiện Chinese:
#     + dấu # màu xám
#     + chữ Hoa luôn 1 màu cố định (cyan), khác chu kỳ màu Việt
# - Auto-delay theo SỐ TỪ: 1s..4s (delay=NULL)
# - Sau khi chạy xong: in ASCII A DI ĐÀ PHẬT
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

# ---- ASCII A Di Đà Phật (gọn, nổi bật) ----
print_buddha <- function() {
  cat(crayon::bold(crayon::yellow("✦ NAM MÔ A DI ĐÀ PHẬT ✦")), "\n")
}

# ---- hàm ln() ----
# delay:
#   - số (vd 2): delay cố định
#   - NULL     : auto-delay 1..4s theo SỐ TỪ (tính theo phần Việt)
ln <- function(start = 1, end = Inf, delay = 2, show_han = FALSE,
               quiet = FALSE, color_offset = 0, show_buddha_end = TRUE) {
  
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
  
  if (!quiet) {
    cat(crayon::bold("Bat dau tung Lang Nghiem tu:"), md_file, "\n\n")
  }
  
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
  
  # ---- auto-delay 1..4s theo SỐ TỪ (phần Việt) ----
  min_delay <- 1
  max_delay <- 4
  min_words <- 2    # <=2 từ coi như rất ngắn
  max_words <- 10   # >=10 từ coi như rất dài
  
  count_words <- function(x) {
    x <- trimws(x)
    if (!nzchar(x)) return(0L)
    x <- gsub("[[:space:]]+", " ", x)
    length(strsplit(x, " ", fixed = TRUE)[[1]])
  }
  
  calc_delay <- function(viet_text) {
    w <- count_words(viet_text)
    t <- (w - min_words) / (max_words - min_words)
    t <- max(0, min(1, t))
    min_delay + t * (max_delay - min_delay)
  }
  
  i <- 0
  for (k in start:end) {
    i <- i + 1
    
    # color_offset giúp màu liền mạch khi gọi nhiều block
    f <- colors[[ ((color_offset + i - 1) %% 12) + 1 ]]
    
    line <- lines[[k]]
    
    # phần Việt để tính auto-delay (không tính chữ Hán)
    viet_for_delay <- line
    if (grepl("#", viet_for_delay, fixed = TRUE)) {
      viet_for_delay <- trimws(strsplit(viet_for_delay, "#", fixed = TRUE)[[1]][1])
    } else {
      viet_for_delay <- trimws(viet_for_delay)
    }
    
    if (show_han && grepl("#", line, fixed = TRUE)) {
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
    
    d <- if (is.null(delay)) calc_delay(viet_for_delay) else delay
    Sys.sleep(d)
  }
  
  # ---- kết thúc: in ASCII (tuỳ chọn) ----
  if (show_buddha_end && !quiet) {
    cat("\n")
    print_buddha()
  }
  
  invisible(TRUE)
}

# =========================================
# lnnc(): nhiều chu kỳ 12 dòng (có Chinese)
# - lnnc(0,1,2) chạy lần lượt chu kỳ 0 rồi 1 rồi 2
# - lnnc(3:6) chạy 3,4,5,6
# - giữ màu LIỀN MẠCH xuyên các chu kỳ
# - mặc định auto-delay (delay=NULL) 1..4s theo SỐ TỪ
# - kết thúc: in ASCII
# =========================================
lnnc <- function(..., delay = NULL, show_buddha_end = TRUE) {
  
  cycles <- c(...)
  if (length(cycles) == 0) stop("Can it nhat 1 chu ky. Vi du: lnnc(0)")
  
  cycles <- as.integer(cycles)
  
  if (any(is.na(cycles)) || any(cycles < 0)) {
    stop("Tat ca chu ky phai la so nguyen >= 0. Vi du: lnnc(0,1,2) hoac lnnc(3:6)")
  }
  
  cat(crayon::bold("Chu ky:"), paste(cycles, collapse = ", "), "\n\n")
  
  offset <- 0
  for (ncy in cycles) {
    start <- ncy * 12 + 1
    end   <- ncy * 12 + 12
    
    ln(
      start = start,
      end   = end,
      delay = delay,          # NULL => auto 1..4s, số => cố định
      show_han = TRUE,
      quiet = TRUE,
      color_offset = offset,
      show_buddha_end = FALSE
    )
    
    offset <- offset + 12
  }
  
  if (show_buddha_end) {
    cat("\n")
    print_buddha()
  }
  
  invisible(TRUE)
}

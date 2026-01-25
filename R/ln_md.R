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
# - Manual (ổn định): manual=TRUE -> bấm phím:
#       Enter / n : dòng kế
#       p         : lùi 1 dòng
#       q         : thoát
# - Sau khi chạy xong: in ASCII A DI ĐÀ PHẬT
# =========================================

if (!requireNamespace("crayon", quietly = TRUE)) install.packages("crayon")
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")

library(crayon)
library(here)

if (!interactive()) options(crayon.enabled = FALSE)

suppressMessages({
  here::i_am("chu_vang_sanh.Rproj")
})

md_file <- here::here("lang_nghiem_chi.md")
if (!file.exists(md_file)) stop("Khong thay file: ", md_file)

print_buddha <- function() {
  cat(crayon::bold(crayon::yellow("✦ NAM MÔ A DI ĐÀ PHẬT ✦")), "\n")
}

# ---- helper: nhập phím điều khiển (KHÔNG in prompt mỗi lần) ----
# Enter / n : next
# p         : previous
# q         : quit
wait_key <- function() {
  repeat {
    key <- readline()
    key <- tolower(trimws(key))
    if (key %in% c("", "n", "p", "q")) return(key)
  }
}

read_ln_lines <- function(show_han) {
  lines <- readLines(md_file, encoding = "UTF-8", warn = FALSE)
  lines <- sub("[[:space:]]+$", "", lines)
  lines <- lines[lines != ""]
  if (!show_han) {
    lines <- sub("#.*$", "", lines)
    lines <- sub("[[:space:]]+$", "", lines)
    lines <- lines[lines != ""]
  }
  lines
}

ln <- function(start = 1, end = Inf, delay = 2, show_han = FALSE,
               quiet = FALSE, color_offset = 0, show_buddha_end = TRUE,
               manual = FALSE) {
  
  lines <- read_ln_lines(show_han = show_han)
  
  n <- length(lines)
  if (is.infinite(end)) end <- n
  start <- max(1, as.integer(start))
  end <- min(n, as.integer(end))
  if (start > end) stop("start > end")
  
  # ---- header: COMPACT ----
  if (!quiet) {
    cat(crayon::bold("Bat dau tung Lang Nghiem tu:"), md_file, "\n")  # <- chỉ 1 \n
    if (isTRUE(manual)) {
      cat(crayon::silver("Dieu khien: [Enter/n]=tiep | p=lui | q=thoat"), "\n") # <- chỉ 1 \n
    }
  }
  
  colors <- list(
    crayon::red,
    crayon::magenta,
    crayon::white,
    crayon::green,
    crayon::magenta,
    crayon::white,
    crayon::blue,
    crayon::magenta,
    crayon::white,
    crayon::yellow,
    crayon::magenta,
    crayon::white
  )
  
  hash_color <- crayon::silver
  han_color  <- crayon::cyan
  
  min_delay <- 1
  max_delay <- 4
  min_words <- 2
  max_words <- 10
  
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
  
  print_one <- function(line, f) {
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
  }
  
  viet_for_delay_of <- function(line) {
    if (grepl("#", line, fixed = TRUE)) {
      trimws(strsplit(line, "#", fixed = TRUE)[[1]][1])
    } else {
      trimws(line)
    }
  }
  
  if (!isTRUE(manual)) {
    i <- 0
    for (k in start:end) {
      i <- i + 1
      f <- colors[[ ((color_offset + i - 1) %% 12) + 1 ]]
      line <- lines[[k]]
      
      print_one(line, f)
      
      viet_for_delay <- viet_for_delay_of(line)
      d <- if (is.null(delay)) calc_delay(viet_for_delay) else delay
      Sys.sleep(d)
    }
    
  } else {
    idx  <- start
    step <- 0L
    
    repeat {
      step <- step + 1L
      f <- colors[[ ((color_offset + step - 1) %% 12) + 1 ]]
      line <- lines[[idx]]
      
      print_one(line, f)
      
      if (idx >= end) break
      
      key <- wait_key()
      if (key == "q") break
      
      if (key == "p") {
        if (idx > start) {
          idx <- idx - 1L
          step <- max(0L, step - 2L)
        }
      } else {
        idx <- min(end, idx + 1L)
      }
    }
  }
  
  # ---- footer: COMPACT ----
  if (show_buddha_end && !quiet) {
    print_buddha()  # <- không thêm dòng trống trước
  }
  
  invisible(TRUE)
}

lnnc <- function(..., delay = NULL, show_buddha_end = TRUE, manual = FALSE) {
  
  cycles <- c(...)
  if (length(cycles) == 0) stop("Can it nhat 1 chu ky. Vi du: lnnc(0)")
  
  cycles <- as.integer(cycles)
  if (any(is.na(cycles)) || any(cycles < 0)) {
    stop("Tat ca chu ky phai la so nguyen >= 0. Vi du: lnnc(0,1,2) hoac lnnc(3:6)")
  }
  
  cat(crayon::bold("Chu ky:"), paste(cycles, collapse = ", "), "\n")  # <- compact (1 \n)
  
  offset <- 0
  for (ncy in cycles) {
    start <- ncy * 12 + 1
    end   <- ncy * 12 + 12
    
    ln(
      start = start,
      end   = end,
      delay = delay,
      show_han = TRUE,
      quiet = TRUE,
      color_offset = offset,
      show_buddha_end = FALSE,
      manual = manual
    )
    
    offset <- offset + 12
  }
  
  if (show_buddha_end) {
    print_buddha()  # <- compact
  }
  
  invisible(TRUE)
}

# =========================================
# LN: TỤNG LĂNG NGHIÊM từ Markdown (.md)
# - Chuông theo chu kỳ 12 dòng
# - Mõ đều theo từng TỪ/KÝ TỰ (nhịp cố định mo_interval)
# - Nam-mô = 2 nhịp (Nam / mô) mà KHÔNG sửa file gốc
# - Gặp "🙏" -> bỏ ký tự 🙏 (không gõ cho 🙏), vẫn gõ các token còn lại
# - Bỏ số đầu dòng khỏi việc gõ mõ
# - Mõ fade-out: giảm dần trong 1 dòng, tiếng cuối = 1/2 vol_mo
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

ln <- function(start = 1, end = Inf, delay = 2, show_han = TRUE,
               quiet = FALSE, color_offset = 0, show_buddha_end = TRUE,
               manual = FALSE,
               # ====== CHUÔNG + MÕ ======
               chuong = "./phap_khi/chuong.mp3",
               mo = "./phap_khi/mo.mp3",
               use_chuong = TRUE,
               use_mo = TRUE,
               chuong_moi = 12,
               night_mode = TRUE,
               vol_chuong = 0.10,
               vol_mo = 0.06,          # mõ “chuẩn” trong dòng
               async_audio = TRUE,
               # ====== NHỊP MÕ ĐỀU (GIẢM TỐC ĐỘ CÒN 1/2) ======
               mo_interval = 0.80, #chỉnh tốc độ muốn nhanh th
               pause_giua_dong = 0.00,
               # ====== theo yêu cầu ======
               skip_mo_symbol = "🙏",
               mo_start = c("viet", "han"),   # mặc định gõ theo VIỆT để đúng số chữ
               vol_mo_first = 0.10,           # tiếng đầu to hơn
               vol_mo_last = NULL             # NULL => tự = vol_mo/2 (tiếng cuối)
) {
  
  mo_start <- match.arg(mo_start)
  if (is.null(vol_mo_last)) vol_mo_last <- vol_mo / 2
  
  lines <- read_ln_lines(show_han = show_han)
  
  n <- length(lines)
  if (is.infinite(end)) end <- n
  start <- max(1, as.integer(start))
  end <- min(n, as.integer(end))
  if (start > end) stop("start > end")
  
  if (!quiet) {
    cat(crayon::bold("Bat dau tung Lang Nghiem tu:"), md_file, "\n")
    if (isTRUE(manual)) {
      cat(crayon::silver("Dieu khien: [Enter/n]=tiep | p=lui | q=thoat"), "\n")
    }
  }
  
  colors <- list(
    crayon::red, crayon::magenta, crayon::white, crayon::green,
    crayon::magenta, crayon::white, crayon::blue, crayon::magenta,
    crayon::white, crayon::yellow, crayon::magenta, crayon::white
  )
  hash_color <- crayon::silver
  han_color  <- crayon::cyan
  
  play <- function(file, vol = 1, async = async_audio) {
    if (!isTRUE(use_chuong) && identical(file, chuong)) return(invisible(FALSE))
    if (!isTRUE(use_mo) && identical(file, mo)) return(invisible(FALSE))
    if (!file.exists(file)) return(invisible(FALSE))
    v <- if (isTRUE(night_mode)) vol else 1
    args <- c("-v", sprintf("%.2f", v), file)
    system2("afplay", args = args, wait = !isTRUE(async))
    invisible(TRUE)
  }
  
  split_viet_han <- function(line) {
    if (grepl("#", line, fixed = TRUE)) {
      parts <- strsplit(line, "#", fixed = TRUE)[[1]]
      viet <- trimws(parts[1])
      han  <- trimws(paste(parts[-1], collapse = "#"))
    } else {
      viet <- trimws(line)
      han  <- ""
    }
    list(viet = viet, han = han)
  }
  
  strip_prefix_number <- function(x) {
    sub("^\\s*\\d+\\s*\\.\\s*", "", x)
  }
  
  viet_words <- function(v) {
    v <- strip_prefix_number(v)
    v <- gsub(skip_mo_symbol, " ", v, fixed = TRUE)
    v <- gsub("\\bNam\\s*[-–—]\\s*mô\\b", "Nam mô", v)
    v <- gsub("[-–—]", " ", v)
    v <- gsub("[[:space:]]+", " ", v)
    v <- trimws(v)
    if (!nzchar(v)) return(character(0))
    unlist(strsplit(v, "\\s+"))
  }
  
  han_chars <- function(h) {
    h <- gsub("[[:space:]]+", "", h)
    h <- trimws(h)
    if (!nzchar(h)) return(character(0))
    strsplit(h, "", useBytes = FALSE)[[1]]
  }
  
  tokens_for_mo <- function(viet, han) {
    if (mo_start == "viet") {
      vw <- viet_words(viet)
      if (length(vw) > 0) return(vw)
      return(han_chars(han))
    } else {
      hc <- han_chars(han)
      if (length(hc) > 0) return(hc)
      return(viet_words(viet))
    }
  }
  
  # ====== NEW: fade-out volume theo token trong 1 dòng ======
  mo_vol_at <- function(j, m) {
    if (m <= 1) return(vol_mo_first)
    t <- (j - 1) / (m - 1)  # 0 -> 1
    # tuyến tính: từ vol_mo_first xuống vol_mo_last
    vol_mo_first + (vol_mo_last - vol_mo_first) * t
  }
  
  print_one <- function(line, f) {
    if (show_han && grepl("#", line, fixed = TRUE)) {
      parts <- strsplit(line, "#", fixed = TRUE)[[1]]
      viet <- trimws(parts[1])
      han  <- trimws(paste(parts[-1], collapse = "#"))
      viet <- gsub("\\bNam\\s*[-–—]\\s*mô\\b", "Nam mô", viet)
      cat(crayon::bold(f(viet)), hash_color(" # "),
          crayon::bold(han_color(han)), "\n", sep = "")
    } else {
      x <- gsub("\\bNam\\s*[-–—]\\s*mô\\b", "Nam mô", line)
      cat(crayon::bold(f(x)), "\n")
    }
  }
  
  if (isTRUE(use_chuong) && !quiet) {
    play(chuong, vol_chuong, async = TRUE)
    Sys.sleep(0.15)
  }
  
  if (!isTRUE(manual)) {
    
    i <- 0
    for (k in start:end) {
      i <- i + 1
      f <- colors[[ ((color_offset + i - 1) %% 12) + 1 ]]
      line <- lines[[k]]
      
      print_one(line, f)
      sp <- split_viet_han(line)
      
      if (isTRUE(use_mo)) {
        tokens <- tokens_for_mo(sp$viet, sp$han)
        m <- length(tokens)
        
        if (m == 0) {
          Sys.sleep(mo_interval)
        } else {
          for (j in seq_along(tokens)) {
            vmo <- mo_vol_at(j, m)      # fade-out trong 1 dòng
            play(mo, vmo, async = TRUE)
            Sys.sleep(mo_interval)
          }
        }
        
        if (pause_giua_dong > 0) Sys.sleep(pause_giua_dong)
      } else {
        Sys.sleep(delay)
      }
      
      if (isTRUE(use_chuong) && chuong_moi > 0 && (i %% chuong_moi == 0) && (k < end)) {
        play(chuong, vol_chuong, async = TRUE)
        Sys.sleep(0.10)
      }
    }
    
  } else {
    
    idx  <- start
    step <- 0L
    
    repeat {
      step <- step + 1L
      f <- colors[[ ((color_offset + step - 1) %% 12) + 1 ]]
      line <- lines[[idx]]
      
      print_one(line, f)
      sp <- split_viet_han(line)
      
      if (isTRUE(use_mo)) {
        tokens <- tokens_for_mo(sp$viet, sp$han)
        m <- length(tokens)
        if (m > 0) {
          for (j in seq_along(tokens)) {
            vmo <- mo_vol_at(j, m)     # manual cũng fade-out
            play(mo, vmo, async = TRUE)
          }
        }
      }
      
      if (isTRUE(use_chuong) && chuong_moi > 0 && (step %% chuong_moi == 0) && (idx < end)) {
        play(chuong, vol_chuong, async = TRUE)
      }
      
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
  
  if (isTRUE(use_chuong) && !quiet) {
    play(chuong, vol_chuong, async = TRUE)
    Sys.sleep(0.15)
  }
  
  if (show_buddha_end && !quiet) print_buddha()
  invisible(TRUE)
}

lnnc <- function(..., delay = 2, show_buddha_end = TRUE, manual = FALSE) {
  cycles <- c(...)
  if (length(cycles) == 0) stop("Can it nhat 1 chu ky. Vi du: lnnc(0)")
  cycles <- as.integer(cycles)
  if (any(is.na(cycles)) || any(cycles < 0)) stop("Chu ky phai la so nguyen >= 0")
  
  cat(crayon::bold("Chu ky:"), paste(cycles, collapse = ", "), "\n")
  
  offset <- 0
  for (ncy in cycles) {
    s <- ncy * 12 + 1
    e <- ncy * 12 + 12
    ln(start = s, end = e, delay = delay, show_han = TRUE, quiet = TRUE,
       color_offset = offset, show_buddha_end = FALSE, manual = manual)
    offset <- offset + 12
  }
  
  if (show_buddha_end) print_buddha()
  invisible(TRUE)
}

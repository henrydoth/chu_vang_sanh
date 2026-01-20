# =========================================================
# LOAD LINES FROM lang_nghiem_chi.md (01. ... 187.)
# =========================================================

LANG_NGHIEM_MD <- "lang_nghiem_chi.md"

load_lang_nghiem_from_md <- function(path = LANG_NGHIEM_MD) {
  if (!file.exists(path)) {
    warning("Không thấy file: ", path)
    return(character(0))
  }
  x <- readLines(path, encoding = "UTF-8", warn = FALSE)
  x <- trimws(x)
  # chỉ lấy các dòng dạng "01. ..." đến "187. ..."
  x <- x[grepl("^[0-9]{2,3}\\.", x)]
  x
}

# reload lines on demand (useful when md is edited)
reload_lang_nghiem <- function() {
  LANG_NGHIEM_LINES <<- load_lang_nghiem_from_md()
  invisible(LANG_NGHIEM_LINES)
}

# initial load
LANG_NGHIEM_LINES <- load_lang_nghiem_from_md()

check_lang_nghiem <- function() {
  n <- length(LANG_NGHIEM_LINES)
  cat("LANG_NGHIEM_LINES:", n, "lines\n")
  if (n > 0) {
    cat("First:", LANG_NGHIEM_LINES[1], "\n")
    cat("Last :", LANG_NGHIEM_LINES[n], "\n")
  }
  invisible(n)
}

print_block <- function(idx, lines = LANG_NGHIEM_LINES, block_size = 12) {
  # auto reload if empty (or after file edits)
  if (length(lines) == 0) {
    reload_lang_nghiem()
    lines <- LANG_NGHIEM_LINES
  }
  
  if (length(lines) == 0) {
    cat("\n⚠️ Không load được câu từ lang_nghiem_chi.md\n\n")
    return(invisible(NULL))
  }
  
  n_lines <- length(lines)
  start_line <- (idx - 1) * block_size + 1
  end_line   <- min(start_line + block_size - 1, n_lines)
  
  if (start_line > n_lines) {
    cat("\n⚠️ idx quá lớn, không còn câu để in.\n\n")
    return(invisible(NULL))
  }
  
  cat("\n────────────────────────────────\n")
  cat(sprintf("📿 BOOKMARK %d | CÂU %03d → %03d (tổng %d câu)\n",
              idx, start_line, end_line, end_line - start_line + 1))
  cat("────────────────────────────────\n")
  
  for (i in start_line:end_line) cat(lines[i], "\n")
  
  cat("────────────────────────────────\n\n")
}

# =========================================================
# LOOP + SHOW
# =========================================================

# Loop a single bookmark + show its 12-line block on console
# (bookmark last will show <12 lines automatically)
loop_idx_show <- function(bk, idx, n = 50, gap = 0,
                          block_size = 12, quiet = FALSE) {
  
  start <- bk$start_sec[idx]
  dur   <- bk$dur_sec[idx]
  
  if (!quiet) {
    cat(sprintf("Loop idx=%d | %s | start=%s | dur=%ds\n",
                idx, bk$label[idx], sec_to_mmss(start), dur))
  }
  
  for (k in seq_len(n)) {
    if (!quiet) cat(sprintf("Loop %d / %d\n", k, n))
    
    print_block(idx, block_size = block_size)
    
    vlc_seek(start)
    vlc_play()
    Sys.sleep(dur)
    
    if (gap > 0) Sys.sleep(gap)
  }
}

# Loop nhiều bookmark liên tiếp (mỗi bookmark lặp n lần)
# ví dụ: loop_idxs(bk, 1:3, n = 2)
loop_idxs <- function(bk, idxs, n = 1, gap = 0,
                      block_size = 12, quiet = FALSE) {
  for (i in idxs) {
    loop_idx_show(bk, idx = i, n = n, gap = gap,
                  block_size = block_size, quiet = quiet)
  }
}

# =========================================================
# loo_p(): HÀM CHÍNH (dùng lâu dài)
# - idxs: 1 số (vd: 3) hoặc nhiều số (vd: 1:3, c(1,4,7))
# - n: số vòng cho MỖI bookmark
# - rounds: số chu kỳ (lặp cả nhóm idxs)
# =========================================================
loo_p <- function(bk,
                  idxs,
                  n = 1,
                  rounds = 1,
                  gap = 0,
                  block_size = 12,
                  quiet = FALSE) {
  
  stopifnot(all(idxs >= 1), all(idxs <= nrow(bk)))
  
  for (r in seq_len(rounds)) {
    if (!quiet) {
      cat(sprintf("\n🔁 CHU KỲ %d / %d | idxs = %s\n",
                  r, rounds, paste(idxs, collapse = ",")))
    }
    for (i in idxs) {
      loop_idx_show(bk, idx = i, n = n, gap = gap,
                    block_size = block_size, quiet = quiet)
    }
  }
}

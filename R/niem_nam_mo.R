# ---- NIỆM NAM MÔ A DI ĐÀ PHẬT – BAN ĐÊM (CỰC ÊM) ----
# - Chuông rất nhẹ và thưa, phù hợp tại gia
# - Có "night_mode": tự giảm âm lượng
# - Có "silent": tắt hoàn toàn âm thanh (chỉ giữ nhịp)
# - Mỗi CÂU 1 màu theo chu kỳ 7 màu (console)
# - Mỗi TỪ = 1 tiếng mõ (mặc định)
# - Audio async: chuông/mõ kêu nhưng KHÔNG chặn việc in chữ

if (!requireNamespace("crayon", quietly = TRUE)) install.packages("crayon")
library(crayon)

niem <- function(
    n = 21,
    text = "Nam mô A Di Đà Phật",
    chuong = "./phap_khi/chuong.mp3",
    mo = "./phap_khi/mo.mp3",
    delay = 1.6,            # tổng thời gian cho 1 câu (ban đêm)
    chuong_moi = 7,         # chuông thưa: mỗi 7 câu (0 = chỉ đầu/cuối)
    use_mo = TRUE,          # MẶC ĐỊNH: có mõ
    mo_moi_tu = TRUE,       # MẶC ĐỊNH: mỗi TỪ = 1 tiếng mõ
    silent = FALSE,         # TRUE = tắt hết âm thanh
    night_mode = TRUE,      # TRUE = tự giảm âm lượng chuông/mõ
    vol_chuong = 0.12,      # âm lượng chuông ban đêm (0.05–0.2)
    vol_mo = 0.08,          # âm lượng mõ (ban đêm nên nhỏ hơn chuông)
    mark = "·",             # dấu “mõ im lặng” khi silent=TRUE hoặc use_mo=FALSE
    show_hint = TRUE,       # in hướng dẫn dừng
    color_cycle = TRUE,     # TRUE = mỗi câu 1 màu (7 màu)
    async_audio = TRUE      # TRUE = chuông/mõ không làm gián đoạn hiển thị
) {
  
  if (!file.exists(chuong)) stop("Không thấy file chuông: ", chuong)
  if (use_mo && !file.exists(mo)) stop("Không thấy file mõ: ", mo)
  
  # ---- 7-color PHẬT QUANG palette (dịu, ban đêm) ----
  cycle7 <- list(
    crayon::white,        # Thanh tịnh
    crayon::yellow,       # Trí tuệ (nhạt)
    crayon::cyan,         # An định (lam nhạt)
    crayon::green,        # Điều hòa
    crayon::magenta,      # Từ bi (hồng nhạt)
    crayon::blue,         # Nhiếp tâm (tím/lam sẫm)
    crayon::silver        # Vô (nghỉ mắt)
  )
  
  # --- play helpers (macOS: afplay) ---
  # async_audio = TRUE -> system2(..., wait=FALSE) để không chặn in chữ
  play <- function(file, vol = 1, async = async_audio) {
    if (isTRUE(silent)) return(invisible(FALSE))
    v <- if (isTRUE(night_mode)) vol else 1
    args <- c("-v", sprintf("%.2f", v), file)
    system2("afplay", args = args, wait = !isTRUE(async))
    invisible(TRUE)
  }
  
  # helper: tách từ
  split_words <- function(x) {
    x <- trimws(x)
    if (!nzchar(x)) return(character(0))
    unlist(strsplit(x, "\\s+"))
  }
  
  if (show_hint) {
    cat(crayon::silver("🌙 night: very soft | Stop: Esc (RStudio)"), "\n\n")
  }
  
  # Chuông mở (async, không khựng chữ)
  play(chuong, vol_chuong, async = TRUE)
  Sys.sleep(0.2)
  
  for (i in 1:n) {
    
    # chọn màu theo chu kỳ 7 (theo CÂU)
    if (isTRUE(color_cycle)) {
      f <- cycle7[[ (i - 1) %% length(cycle7) + 1 ]]
    } else {
      f <- identity
    }
    
    words <- split_words(text)
    if (length(words) == 0) next
    
    # in số thứ tự
    cat(f(sprintf("%3d. ", i)))
    
    # chia delay cho từng từ (để câu vẫn đúng nhịp tổng)
    per_word_delay <- delay / max(1, length(words))
    
    if (isTRUE(use_mo) && !isTRUE(silent) && isTRUE(mo_moi_tu)) {
      # ---- MỖI TỪ = 1 tiếng mõ ----
      for (w in words) {
        cat(f(paste0(w, " ")))
        play(mo, vol_mo, async = TRUE)     # async: không chặn hiển thị
        Sys.sleep(per_word_delay)
      }
      cat("\n")
    } else {
      # ---- 1 câu = 1 tiếng mõ (hoặc im lặng) ----
      cat(f(paste(words, collapse = " ")))
      if (isTRUE(use_mo) && !isTRUE(silent)) {
        cat("\n")
        play(mo, vol_mo, async = TRUE)
      } else {
        cat(crayon::silver(paste0("  ", mark)), "\n")
      }
      Sys.sleep(delay)
    }
    
    # Chuông thưa (async)
    if (chuong_moi > 0 && i %% chuong_moi == 0 && i < n) {
      play(chuong, vol_chuong, async = TRUE)
      Sys.sleep(0.1)
    }
  }
  
  # Chuông kết (async)
  play(chuong, vol_chuong, async = TRUE)
  Sys.sleep(0.2)
  
  cat("\n", crayon::bold(crayon::yellow("✦ Hồi hướng – Nguyện vãng sanh tịnh độ trung ✦")), "\n", sep = "")
  invisible(TRUE)
}

# =========================================
# HELP: NIỆM NAM MÔ A DI ĐÀ PHẬT (BAN ĐÊM)
# Gõ: help_niem()
# =========================================
help_niem <- function() {
  cat("
📌 NIỆM NAM MÔ A DI ĐÀ PHẬT — HƯỚNG DẪN NHANH

0) Load file:
   source('R/niem_nam_mo.R')

1) Ban đêm (mặc định):
   niem()
   - 21 câu
   - 7 màu hào quang (mỗi câu 1 màu)
   - MỖI TỪ = 1 tiếng mõ (async, không khựng chữ)
   - Chuông thưa: mỗi 7 câu

2) Rất hợp chu kỳ 7:
   niem(49)     # 7×7

3) Im lặng tuyệt đối:
   niem(54, silent = TRUE)

4) Nếu muốn 1 câu = 1 tiếng mõ (không gõ từng từ):
   niem(54, mo_moi_tu = FALSE)

5) Chuông thưa hơn / chỉ đầu-cuối:
   niem(54, chuong_moi = 14)
   niem(54, chuong_moi = 0)

6) Nhịp sâu hơn:
   niem(49, delay = 2.0, vol_mo = 0.05, vol_chuong = 0.08)

7) Tắt màu:
   niem(54, color_cycle = FALSE)

⛔ Dừng:
- RStudio: ESC
- Terminal: Ctrl+C

📁 Kiểm tra pháp khí:
   list.files('./phap_khi')
")
  invisible(TRUE)
}

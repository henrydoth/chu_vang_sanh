# =========================================================
# VLC + R control for Lang Nghiem chanting
# Author: bạn
# Purpose: điều khiển VLC (play / seek / loop / lnnc)
# Requirement:
#   - VLC bật Web Interface (http://127.0.0.1:8080)
#   - Lua HTTP password (ví dụ: 1234)
# =========================================================

# ---- CONFIG ------------------------------------------------
VLC_PWD <- "1234"   # đổi nếu bạn đặt mật khẩu khác
# ------------------------------------------------------------

# ---- LIBS --------------------------------------------------
if (!requireNamespace("curl", quietly = TRUE)) {
  install.packages("curl")
}
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite")
}

library(curl)
library(jsonlite)
# ------------------------------------------------------------

# ---- CORE VLC FUNCTION ------------------------------------
vlc <- function(cmd, pwd = VLC_PWD) {
  h <- new_handle(userpwd = paste0(":", pwd))
  url <- paste0("http://127.0.0.1:8080/requests/status.json?", cmd)
  curl_fetch_memory(url, handle = h)
}

vlc_status <- function(pwd = VLC_PWD) {
  fromJSON(rawToChar(vlc("", pwd)$content))
}

vlc_play  <- function(pwd = VLC_PWD) vlc("command=pl_play",  pwd)
vlc_pause <- function(pwd = VLC_PWD) vlc("command=pl_pause", pwd)
vlc_stop  <- function(pwd = VLC_PWD) vlc("command=pl_stop",  pwd)

vlc_seek <- function(sec, pwd = VLC_PWD) {
  vlc(paste0("command=seek&val=", as.integer(sec)), pwd)
}

vlc_time <- function(pwd = VLC_PWD) {
  vlc_status(pwd)$time
}
# ------------------------------------------------------------

# ---- LOOP ONE BOOKMARK ------------------------------------
loop_bookmark <- function(start, dur, n = 108,
                          gap = 0, pwd = VLC_PWD) {
  for (i in seq_len(n)) {
    message(sprintf("Loop %d / %d (start=%ds)", i, n, start))
    vlc_seek(start, pwd)
    vlc_play(pwd)
    Sys.sleep(dur)
    if (gap > 0) Sys.sleep(gap)
  }
}
# ------------------------------------------------------------

# ---- LNNC (CHU KỲ) LOOP -----------------------------------
# bk phải có: line, start, dur
lnnc_loop <- function(bk,
                      rounds = 9,
                      gap_line = 0.3,
                      gap_round = 2,
                      pwd = VLC_PWD) {
  
  stopifnot(all(c("line", "start", "dur") %in% names(bk)))
  
  for (r in seq_len(rounds)) {
    message(sprintf("===== ROUND %d / %d =====", r, rounds))
    for (i in seq_len(nrow(bk))) {
      message(sprintf("Line %s (start=%ds)",
                      bk$line[i], bk$start[i]))
      vlc_seek(bk$start[i], pwd)
      vlc_play(pwd)
      Sys.sleep(bk$dur[i])
      if (gap_line > 0) Sys.sleep(gap_line)
    }
    if (gap_round > 0) Sys.sleep(gap_round)
  }
}
# ------------------------------------------------------------

# ---- EXAMPLE BOOKMARK: LNNC(8) 97–104 ---------------------
# ⚠️ chỉnh lại start/dur cho đúng bookmark thực tế của bạn
bk_97_104 <- data.frame(
  line  = 97:104,
  start = c(157, 182, 210, 238, 268, 297, 325, 352),
  dur   = c(25, 25, 28, 31, 28, 31, 32, 28)
)
# ------------------------------------------------------------

# ---- QUICK COMMANDS ---------------------------------------
# ví dụ:
# source("vlc_lang_nghiem.R")
# vlc_seek(157)
# loop_bookmark(157, 25, n = 108)
# lnnc_loop(bk_97_104, rounds = 9)
# ------------------------------------------------------------

message("vlc_lang_nghiem.R loaded successfully.")

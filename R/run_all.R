# =========================================
# RUN ALL: load toàn bộ hàm tụng / niệm
# Chỉ cần source("run_all.R") 1 lần
# =========================================

library(here)

suppressMessages({
  here::i_am("chu_vang_sanh.Rproj")
})

# ---- 1) Vãng Sanh Chú ----
source(here::here("R", "vang_sanh_chu.R"),
       echo = FALSE, max.deparse.length = Inf)

# ---- 2) Niệm Nam Mô A Di Đà Phật ----
source(here::here("R", "niem_nam_mo.R"),
       echo = FALSE, max.deparse.length = Inf)

# ---- 3) Chú Lăng Nghiêm ----
source(here::here("R", "ln_md.R"),
       echo = FALSE, max.deparse.length = Inf)

# =========================================
# CÁCH DÙNG (gõ trực tiếp trong Console)
# =========================================
# vs()            # Vãng Sanh (Việt)
# vs1()           # Vãng Sanh (Hoa)
#
# niem()          # Niệm A Di Đà Phật (mặc định)
# niem(108)       # 108 câu
#
# ln()            # Tụng Lăng Nghiêm (mặc định)
# ln(1, 12)       # 12 dòng đầu
# lnnc(0:3)       # 4 chu kỳ (mỗi chu kỳ 12 dòng)

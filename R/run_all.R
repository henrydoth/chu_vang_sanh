# =========================================
# RUN ALL: load toàn bộ hàm tụng/niệm
# =========================================

library(here)

suppressMessages({
  here::i_am("chu_vang_sanh.Rproj")
})

# 1) Vãng sanh chú (vs, vs1)
source(here::here("R", "vang_sanh_chu.R"), echo = TRUE, max.deparse.length = Inf)

# 2) Niệm Nam mô A Di Đà Phật (niem)
source(here::here("R", "niem_nam_mo.R"), echo = TRUE, max.deparse.length = Inf)

# =========================================
# GỌI THỬ (bỏ # để chạy)
# =========================================

# vs(delay = 2)                 # tụng Việt
# vs1(delay = 2)                # tụng Hoa

# niem()                        # 27 câu, chuông+mõ
# niem(108)                     # 108 câu
# niem(18, mo_moi_chu = TRUE)   # 18 vòng = 108 chữ (mỗi chữ 1 mõ)

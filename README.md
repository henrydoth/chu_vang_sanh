Dưới đây là **DANH SÁCH CÁC LỆNH** (ngắn – đúng – dùng ngay trong **RStudio Console**):

------

## 🚀 Khởi động (mỗi lần mở / Restart R)

```
source("R/commands.R", encoding="UTF-8")
lns()
```

------

## 📿 Tụng Lăng Nghiêm

### 🔹 Theo **chu kỳ 12 dòng** (có chữ Hán)

```
lnnc(0)          # chu kỳ 0 (dòng 1–12)
lnnc(1)          # chu kỳ 1 (dòng 13–24)
lnnc(0,1,2)      # chu kỳ 0 → 1 → 2
lnnc(3:6)        # chu kỳ 3,4,5,6
lnnc(0:9)        # chu kỳ 0–9
lnnc(0:9, delay=1)
```

### 🔹 Theo **dòng**

```
ln()                         # toàn bộ (không Hán)
ln(1, 12)                    # dòng 1–12
ln(1, 12, show_han=TRUE)     # Việt + Hán
ln(13, 24, delay=1)
```

------

## 🧭 Kiểm tra & tiện ích

```
where()        # xem project root + md_file đang dùng
reload("ln")   # nạp lại ln_md.R
reload("vs")   # nạp lại chu_md.R
reload("all")  # nạp lại tất cả
```

------

## 📦 Chú Vãng Sanh

```
vs()           # chạy hệ Chú Vãng Sanh
```

------

## ❌ Không dùng

```
pwd()          # ❌ không phải lệnh R
```

------

## 🧠 Ghi nhớ nhanh

```
source("R/commands.R")
lns()
lnnc(0:9)
```

> ✦ NAM MÔ A DI ĐÀ PHẬT ✦	



# 📿 HƯỚNG DẪN SỬ DỤNG (R + VLC + MP3 Books)

## 1️⃣ Chuẩn bị

### 1. VLC

- Mở **VLC**
- Bật **Web Interface**
   `VLC → Preferences → Show All → Interface → Main interfaces → tick "Web"`
- Đặt **Lua HTTP password** (ví dụ: `1234`)
- VLC chạy tại: `http://127.0.0.1:8080`

### 2. File cần có trong project

```
chu_vang_sanh/
├─ lang_nghiem_chi.md          # 187 câu (01. … 187.)
├─ R/
│  └─ vlc_lang_nghiem_bookmarks.R
```

------

## 2️⃣ Khởi động trong R

### Mở project

```
setwd("~/Documents/chu_vang_sanh")
```

### Nạp toàn bộ hệ thống

```
source("R/vlc_lang_nghiem_bookmarks.R")
```

### Kiểm tra đã load đủ 187 câu chưa

```
check_lang_nghiem()
```

Kết quả mong đợi:

```
LANG_NGHIEM_LINES: 187 lines
```

------

## 3️⃣ Chuẩn bị bookmarks MP3

### Đọc bookmark từ file text (export từ MP3 Books)

```
bk <- read_bookmarks_mp3books("R/bookmarks_mp3books.txt")
```

### Tự tính thời lượng mỗi bookmark (chuẩn nhất)

```
bk <- add_durations_from_vlc(bk)
```

------

## 4️⃣ Các lệnh sử dụng chính

### 🔹 Loop 1 đoạn (hiện 12 câu)

```
loop_idx_show(bk, idx = 1, n = 2)
```

→ Đoạn 1, lặp 2 vòng

------

### 🔹 Loop nhiều đoạn liên tiếp

```
loop_idxs(bk, 1:3, n = 2)
```

→ Đoạn 1 → 2 → 3
 → mỗi đoạn lặp 2 vòng

------

## 5️⃣ ⭐ LỆNH CHÍNH: `loo_p()` (khuyên dùng)

### Cú pháp

```
loo_p(bk, idxs, n = 1, rounds = 1)
```

| Tham số  | Ý nghĩa                                   |
| -------- | ----------------------------------------- |
| `idxs`   | đoạn muốn tụng (vd: `3`, `1:2`, `c(7,9)`) |
| `n`      | số vòng cho **mỗi đoạn**                  |
| `rounds` | số chu kỳ (lặp cả nhóm đoạn)              |

------

### Ví dụ thực tế

#### ▶️ Đoạn 1 + 2, rồi lặp lại thêm 1 vòng

```
loo_p(bk, 1:2, rounds = 2)
```

Thứ tự phát:

```
1 → 2 → 1 → 2
```

------

#### ▶️ Một đoạn duy nhất, nhiều vòng

```
loo_p(bk, 3, n = 5)
```

→ 3 → 3 → 3 → 3 → 3

------

#### ▶️ Nhiều đoạn, nhiều vòng, nhiều chu kỳ

```
loo_p(bk, 7:9, n = 2, rounds = 3)
```

→ (7×2 → 8×2 → 9×2) × 3

------

## 6️⃣ Ghi chú quan trọng

- Mỗi bookmark tương ứng **12 câu**
- Bookmark cuối tự động hiện **<12 câu** (vd: 181–187)
- Nếu sửa `lang_nghiem_chi.md`, chỉ cần:

```
reload_lang_nghiem()
```

------

## 7️⃣ Gợi ý nâng cao (tuỳ chọn)

- `quiet = TRUE` → chạy im lặng, không in log
- Có thể mở rộng thêm:
  - đếm **108 biến**
  - ghi **log tụng theo ngày**
  - báo **tổng thời gian**

------

🙏 **Hệ thống này được thiết kế cho hành trì lâu dài: đơn giản – chính xác – dễ mở rộng.**
## 🔁 R command history (Project-specific)

Project này sử dụng **R history riêng theo project** để dễ khôi phục các lệnh đã chạy.

### Cách hoạt động
- Các lệnh R trong console được lưu vào file `.Rhistory` (file ẩn, nằm trong thư mục project).
- Khi mở project `chu_vang_sanh.Rproj`, history sẽ **tự động được nạp lại**.
- Khi đóng project / thoát RStudio, history sẽ **tự động được lưu**.

### Xem lại lệnh đã chạy
```r
history(50)   # xem 50 lệnh gần nhất

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
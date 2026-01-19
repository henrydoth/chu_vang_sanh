------

```

# 📿 Tụng Kinh Lăng Nghiêm – R Console Toolkit

Bộ hàm R dùng để **tụng Kinh Lăng Nghiêm** trực tiếp trong **R console / RStudio**,  
đọc từ file Markdown `lang_nghiem_chi.md`, có **delay**, **màu sắc theo chu kỳ**,  
và **hỗ trợ hiển thị chữ Hán (Chinese)**.

---

## 📁 Cấu trúc project
```

Dưới đây là **DANH SÁCH CÁC LỆNH** (ngắn – đúng – dễ nhớ) cho hệ **tụng Lăng Nghiêm trong R console** mà bạn đang dùng.

------

## 🚀 Nạp lệnh (bắt buộc trước khi dùng)

```
source("R/ln_md.R", encoding = "UTF-8")
```

------

## 📌 1️⃣ `ln()` – tụng theo **dòng**

```
ln(start = 1, end = Inf, delay = 2, show_han = FALSE)
```

### Ví dụ

```
ln()                      # tụng toàn bộ, chỉ tiếng Việt
ln(1, 12)                 # dòng 1–12
ln(1, 12, delay = 1)      # nhanh hơn
ln(1, 12, show_han=TRUE)  # hiện cả chữ Hán
```

------

## 📌 2️⃣ `lnnc()` – tụng theo **CHU KỲ 12 DÒNG + chữ Hán**

> Quy ước: **chu kỳ bắt đầu từ 0**

```
lnnc(n)
lnnc(n1, n2)
```

### Ví dụ

```
lnnc(0)        # chu kỳ 0  → dòng 1–12
lnnc(1)        # chu kỳ 1  → dòng 13–24
lnnc(3)        # chu kỳ 3  → dòng 37–48
lnnc(3, 4)     # chu kỳ 3–4 → dòng 37–60
lnnc(0, delay=1)
```

------

## 🎨 Quy ước màu (tóm tắt)

- **Tiếng Việt**: chu kỳ 12 màu (red → pink → white → green → …)
- **`#`**: xám
- **Chữ Hán**: **cyan** (luôn cố định, không theo chu kỳ)

------

## 🔎 Lệnh kiểm tra nhanh trong R

```
ls()        # xem các hàm đã nạp
ln          # xem code hàm ln()
lnnc        # xem code hàm lnnc()
getwd()     # xem thư mục hiện tại
```

chu_vang_sanh/
 ├── chu_vang_sanh.Rproj
 ├── lang_nghiem_chi.md
 ├── README.md
 └── R/
 ├── ln_md.R        # các hàm ln(), lnnc()
 └── commands.R    # (tuỳ chọn) hàm nạp nhanh

```
---

## 🚀 Khởi động nhanh

### 1️⃣ Mở RStudio Project
Mở file:
```

chu_vang_sanh.Rproj

```
### 2️⃣ Nạp các hàm
Trong **R Console**:

```r
source("R/ln_md.R", encoding = "UTF-8")
```

Hoặc nếu có `commands.R`:

```
source("R/commands.R", encoding = "UTF-8")
```

------

## 🔹 Hàm `ln()` – tụng theo dòng

### Cú pháp

```
ln(start = 1, end = Inf, delay = 2, show_han = FALSE)
```

### Ý nghĩa

- `start`, `end` : dòng bắt đầu / kết thúc trong file
- `delay`        : số giây chờ giữa mỗi dòng
- `show_han`     :
  - `FALSE` → chỉ hiện tiếng Việt
  - `TRUE`  → hiện **Việt + chữ Hán**

### Ví dụ

```
ln()                         # tụng toàn bộ, chỉ tiếng Việt
ln(1, 12)                    # dòng 1–12
ln(1, 12, delay = 1)
ln(1, 12, show_han = TRUE)   # hiện cả chữ Hán
```

------

## 🔹 Hàm `lnnc()` – tụng theo CHU KỲ 12 DÒNG (có Chinese)

> Mỗi **chu kỳ = 12 dòng**
>  Chu kỳ bắt đầu từ **0**

### Cú pháp

```
lnnc(n)
lnnc(n1, n2)
```

### Quy ước

- `lnnc(0)` → dòng 1–12
- `lnnc(1)` → dòng 13–24
- `lnnc(3)` → dòng 37–48
- `lnnc(3,4)` → dòng 37–60

### Ví dụ

```
lnnc(0)        # chu kỳ 0
lnnc(1)        # chu kỳ 1
lnnc(3)        # chu kỳ 3
lnnc(3, 4)     # chu kỳ 3–4
lnnc(0, delay = 1)
```

------

## 🎨 Quy ước màu sắc

### 🔸 Phần tiếng Việt – chu kỳ 12 dòng (lặp lại)

1. red
2. pink (magenta)
3. white
4. green
5. pink
6. white
7. blue
8. pink
9. white
10. yellow
11. pink
12. white

### 🔸 Phần chữ Hán

- Dấu `#`  → **xám (silver)**
- Chữ Hán → **cyan (xanh lơ)**
   → **luôn cố định**, không phụ thuộc chu kỳ

------

## 🧘 Mục đích thiết kế

- Phù hợp **tụng – đọc chậm – thiền**
- Không gây rối mắt
- Chữ Hán luôn nổi rõ nhưng không lấn màu Việt
- Dùng được trong:
  - RStudio
  - R console thuần
  - macOS / Windows / Linux

------

## 🛠 Tuỳ chỉnh nhanh

Trong file `R/ln_md.R` bạn có thể:

- Đổi `delay` mặc định
- Đổi màu chữ Hán (`han_color <- crayon::cyan`)
- Bỏ `bold()` nếu muốn chữ nhẹ hơn
- Mở rộng thêm:
  - `lnn()` (chu kỳ 12 không Hán)
  - `lnf()` (bung theo khối)
  - `ln_auto()` (tụng toàn bộ tự động)

------

🙏 **Nam-mô Lăng Nghiêm Hội Thượng Phật Bồ Tát**

```
---
```
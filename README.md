## 📿 Hướng dẫn sử dụng (Usage)

### 1️⃣ Chuẩn bị

- Project phải có file **`chu_vang_sanh.Rproj`**
- Cấu trúc tối thiểu:

```
chu_vang_sanh/
├─ R/
│  ├─ run_all.R
│  ├─ ln_md.R          # tụng Lăng Nghiêm từ Markdown
│  ├─ niem_nam_mo.R    # niệm Nam mô A Di Đà Phật
│  └─ vang_sanh_chu.R  # chú Vãng Sanh
├─ lang_nghiem_chi.md  # nội dung chú Lăng Nghiêm
├─ phap_khi/
│  ├─ chuong.mp3
│  └─ mo.mp3
```

------

### 2️⃣ Nạp toàn bộ hệ thống (chỉ cần 1 lệnh)

Trong R / RStudio:

```
source("R/run_all.R")
```

Sau đó **các hàm sẽ sẵn sàng dùng ngay**.

------

## 🔔 Niệm *Nam mô A Di Đà Phật*

```
niem()
```

- Mặc định: **27 câu**
- Có **chuông + mõ**
- Phù hợp ban đêm (âm lượng thấp)

Ví dụ:

```
niem(108)                 # 108 câu
niem(18, mo_moi_chu=TRUE) # 18 vòng = 108 chữ, mỗi chữ 1 mõ
```

------

## 📜 Tụng *Chú Vãng Sanh*

```
vs()        # tiếng Việt
vs1()       # chữ Hán
```

Ví dụ:

```
vs(delay = 2)
vs1(delay = 2)
```

------

## 🕉️ Tụng *Chú Lăng Nghiêm* (từ Markdown)

### ▶️ Tụng tự động

```
ln(1, 12)
```

### ▶️ Tụng một đoạn

```
ln(1, 4)          # dòng 1 → 4
ln(13, 24)        # chu kỳ kế tiếp
```

### ▶️ Tụng theo **chu kỳ 12 dòng**

```
lnnc(0)           # chu kỳ đầu
lnnc(0, 1, 2)     # nhiều chu kỳ
```

------

## 🎧 Quy tắc chuông – mõ (đã tối ưu)

- 🔔 **Chuông**: mỗi **12 dòng**
- 🪵 **Mõ**:
  - Mỗi **từ / ký tự = 1 nhịp**
  - `Nam-mô` → **2 nhịp** (`Nam` / `mô`)
  - Ký tự `🙏` **không gõ mõ**
  - **Bỏ số thứ tự đầu dòng**
  - Âm lượng **fade-out** trong 1 dòng
     → tiếng cuối = `1/2` tiếng đầu
- ⏱️ Nhịp mặc định:

```
mo_interval = 0.80   # có thể chỉnh nhanh/chậm
```

Ví dụ:

```
ln(1, 12, mo_interval = 1.0)  # tụng chậm, rõ chữ
```

------

## ⌨️ Chế độ điều khiển tay (Manual)

```
ln(1, 12, manual = TRUE)
```

Phím:

- `Enter` / `n` : dòng tiếp
- `p`           : lùi dòng
- `q`           : thoát

------

## 

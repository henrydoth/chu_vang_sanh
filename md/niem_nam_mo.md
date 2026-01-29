## 📌 PHỤ LỤC — CÁCH DÙNG NHANH (GHI NHỚ)

### 1️⃣ Load hàm (mỗi phiên RStudio)

```
source("R/niem_nam_mo.R")
```

------

### 2️⃣ Ban đêm (khuyên dùng nhất)

```
niem()
```

- 54 câu
- Chuông **rất nhẹ**, đánh **thưa**
- Mõ **im lặng**
- Phù hợp trước khi ngủ

------

### 3️⃣ Số câu thường dùng

```
niem(27)     # ngắn, thu tâm nhanh
niem(54)     # chuẩn tại gia
niem(108, delay = 1.8, chuong_moi = 27)  # dài, niệm sâu
```

------

### 4️⃣ Im lặng tuyệt đối (không chuông, không mõ)

```
niem(54, silent = TRUE, chuong_moi = 0)
```

- Chỉ nhìn chữ + niệm trong tâm
- Phù hợp **khuya**, **gia đình ngủ**

------

### 5️⃣ Có mõ thật nhưng rất nhỏ

```
niem(
  54,
  use_mo = TRUE,
  vol_mo = 0.06,
  vol_chuong = 0.08
)
```

- Dành cho người quen nhịp mõ
- Âm lượng rất thấp, không gây ồn

------

### 6️⃣ Chuông thưa / dày (điều chỉnh nhắc tâm)

```
niem(54, chuong_moi = 27)  # rất thưa (ban đêm)
niem(54, chuong_moi = 9)   # dày hơn (không khuyên ban đêm)
```

------

### 7️⃣ Đổi nhịp niệm (chậm / nhanh)

```
niem(54, delay = 2.0)  # chậm, sâu
niem(54, delay = 1.2)  # nhanh hơn
```

------

### 8️⃣ Dấu “mõ im lặng” (chỉ để giữ nhịp mắt)

```
niem(54, mark = "·")
niem(54, mark = "•")
```

------

### ⛔ Dừng ngay khi cần

- **RStudio**: nhấn `Esc`
- **Terminal**: `Ctrl + C`

------

### 📁 File âm thanh sử dụng

```
./phap_khi/
├── chuong.mp3
└── mo.mp3
```

Kiểm tra nhanh:

```
list.files("./phap_khi")
```

------

### 🧠 Ghi nhớ ngắn gọn

> Ban đêm: **giảm tiếng – tăng tâm**
>  Không cầu đủ số,
>  chỉ cầu **mỗi câu đều biết mình đang niệm**.

✦ **Nam mô A Di Đà Phật** ✦

Máy mới chỉ cần:

```
ln 13
ln 13 24
lnk "tát đát"
```

# 1️⃣ Máy Windows kia phải dùng Git Bash

Script của thầy là:

```
#!/usr/bin/env bash
```

→ Nó chạy trong **Git Bash / MINGW64**,
 không chạy trong:

- ❌ CMD
- ❌ PowerShell thuần

👉 Chỉ cần cài Git for Windows là OK.

------

# ✅ 2️⃣ Phải source file trong `.bashrc`

Trên máy mới:

### Bước 1 – clone repo

```
git clone https://github.com/henrydoth/chu_vang_sanh.git
cd chu_vang_sanh
```

------

### Bước 2 – source script

Giả sử file nằm ở:

```
/d/GitHub/chu_vang_sanh/ln_lang_nghiem.bash
```

Thêm vào `~/.bashrc`:

```
source /d/GitHub/chu_vang_sanh/ln_lang_nghiem.bash
```

Sau đó:

```
source ~/.bashrc
```

------

# ✅✅ 1️⃣ Máy Windows khác

### Điều kiện:

- Có **Git for Windows (Git Bash)**
- Hoặc có **WSL (Ubuntu)**

### Cách dùng:

1. Clone repo từ GitHub
2. Vào thư mục
3. `source ln_lang_nghiem.bash`
4. Gõ:

```
ln 13
lnk "tát đát"
```

👉 Chạy bình thường trong **Git Bash**

⚠ Không chạy trong CMD hoặc PowerShell thuần (trừ khi vào WSL)

------

# ✅ 2️⃣ MacBook

MacOS mặc định có:

- bash
- zsh
- sed
- grep
- stty

👉 Script của thầy **100% tương thích**

Chỉ cần:

```
chmod +x ln_lang_nghiem.bash
source ln_lang_nghiem.bash
```

Hoặc thêm vào `~/.zshrc`:

```
source /path/to/ln_lang_nghiem.bash
```

Sau đó mở terminal là dùng được.













## 📿 Hướng dẫn sử dụng R trên mac, win

### 1️⃣ Chuẩn bị

-   Project phải có file **`chu_vang_sanh.Rproj`**
-   Cấu trúc tối thiểu:

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

------------------------------------------------------------------------

### 2️⃣ Nạp toàn bộ hệ thống (chỉ cần 1 lệnh)

Trong R / RStudio:

```         
source("R/run_all.R")
```

Sau đó **các hàm sẽ sẵn sàng dùng ngay**.

------------------------------------------------------------------------

## 🔔 Niệm *Nam mô A Di Đà Phật*

```         
niem()
```

-   Mặc định: **27 câu**
-   Có **chuông + mõ**
-   Phù hợp ban đêm (âm lượng thấp)

Ví dụ:

```         
niem(108)                 # 108 câu
niem(18, mo_moi_chu=TRUE) # 18 vòng = 108 chữ, mỗi chữ 1 mõ
```

------------------------------------------------------------------------

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

------------------------------------------------------------------------

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

------------------------------------------------------------------------

## 🎧 Quy tắc chuông – mõ (đã tối ưu)

-   🔔 **Chuông**: mỗi **12 dòng**
-   🪵 **Mõ**:
    -   Mỗi **từ / ký tự = 1 nhịp**
    -   `Nam-mô` → **2 nhịp** (`Nam` / `mô`)
    -   Ký tự `🙏` **không gõ mõ**
    -   **Bỏ số thứ tự đầu dòng**
    -   Âm lượng **fade-out** trong 1 dòng → tiếng cuối = `1/2` tiếng đầu
-   ⏱️ Nhịp mặc định:

```         
mo_interval = 0.80   # có thể chỉnh nhanh/chậm
```

Ví dụ:

```         
ln(1, 12, mo_interval = 1.0)  # tụng chậm, rõ chữ
```

------------------------------------------------------------------------

## ⌨️ Chế độ điều khiển tay (Manual)

```         
ln(1, 12, manual = TRUE)
```

Phím:

-   `Enter` / `n` : dòng tiếp
-   `p` : lùi dòng
-   `q` : thoát

------------------------------------------------------------------------

## 

**`README.md`** của project `/Users/mac/Documents/chu_vang_sanh`.

Bạn chỉ cần **copy & paste**.

------------------------------------------------------------------------

# README.md — Zsh learning notes (b_1, b_2)

## Project

```         
chu_vang_sanh/
└── zs_h/
    ├── b_1_hello.zsh
    └── b_2_echo.zsh
```

-   **Editor**: RStudio (chỉ để edit text)
-   **Runtime**: Terminal macOS
-   **Ngôn ngữ**: Zsh (Z shell)

------------------------------------------------------------------------

## b_1 — Hello World (Zsh)

### File

```         
zs_h/b_1_hello.zsh
#!/usr/bin/env zsh
# b_1: Hello World

echo "Hello, World"
```

### Chạy

```         
cd zs_h
chmod +x b_1_hello.zsh   # chỉ cần làm 1 lần
./b_1_hello.zsh
```

### Ghi nhớ

-   `chmod +x` = cho phép file **được chạy**
-   `./file.zsh` = chạy file trong **thư mục hiện tại**
-   Shell **không tự chạy** file nếu không có `./`

------------------------------------------------------------------------

## b_2 — Biến & Tham số (phiên bản đơn giản)

### Mục tiêu

-   Hiểu **biến**
-   Hiểu **tham số dòng lệnh** (`$1`, `$#`, `$@`)

### File

```         
zs_h/b_2_echo.zsh
#!/usr/bin/env zsh
# b_2: variables & arguments (simple)

NAME="Liêm"
COUNT=2

echo "Xin chào $NAME"
echo "Số lần: $COUNT"
echo "---------------------"

echo "Câu niệm: $1"
echo "Số tham số: $#"
echo "Tất cả: $@"
```

### Chạy

Không truyền tham số:

```         
./b_2_echo.zsh
```

Truyền 1 câu (có khoảng trắng → phải dùng dấu ngoặc kép):

```         
./b_2_echo.zsh "Nam Mô A Di Đà Phật"
```

### Ghi nhớ quan trọng

-   Khai báo biến **không có dấu cách**:

    ```         
    A=1      # đúng
    A = 1    # sai
    ```

-   Tham số:

    -   `$1` : tham số thứ nhất
    -   `$#` : số lượng tham số
    -   `$@` : tất cả tham số

-   Chuỗi có dấu cách **bắt buộc** dùng `"..."`

------------------------------------------------------------------------

## Tổng kết kiến thức đã học

-   RStudio chỉ dùng làm **editor**

-   Terminal là nơi **chạy thật**

-   `.zsh` là **shell script**

-   Luồng chuẩn:

    ```         
    edit → chmod +x → ./script.zsh
    ```

------------------------------------------------------------------------

## FILE README.qmd

- `ln12()` → đọc 12 dòng Lăng Nghiêm

- `ln12(time = 3)` → đọc chậm

- `ln12(1:3)` → đọc nhiều block

  ## 🧠 CHEAT SHEET – GÕ & SỬA FILE BẰNG R CONSOLE

  ### 📍 Xác định thư mục gốc project

  ```
  here::here()
  ```

  ------

  ## 📂 Tạo & xem thư mục / file

  ### Tạo thư mục

  ```
  dir.create(here::here("tmp"), showWarnings = FALSE)
  ```

  ### Xem file trong thư mục

  ```
  dir()
  list.files()
  list.files(here::here("md_files"))
  ```

  ### Kiểm tra file có tồn tại

  ```
  file.exists(here::here("md_files", "test.md"))
  ```

  ------

  ## ✍️ Tạo & ghi file

  ### Ghi mới (ghi đè)

  ```
  writeLines("Nam mô", here::here("tmp", "test.md"))
  ```

  ### Ghi thêm (append)

  #### Ghi **cùng dòng**

  ```
  cat(" A di Đà Phật", file = here::here("tmp", "test.md"), append = TRUE)
  ```

  #### Ghi **xuống dòng**

  ```
  cat("\nNam mô A Di Đà Phật", file = here::here("tmp", "test.md"), append = TRUE)
  ```

  📌 Nhớ:

  - `\n` = xuống dòng
  - `append = TRUE` = ghi thêm, không mất chữ cũ

  ------

  ## 📖 Đọc file

  ```
  readLines(here::here("tmp", "test.md"))
  ```

  ------

  ## ✏️ SỬA FILE BẰNG CONSOLE (QUAN TRỌNG NHẤT)

  ### Quy tắc vàng

  > **Không sửa trực tiếp file**
  >  → luôn: **đọc → sửa vector → ghi lại**

  ------

  ### Gán đường dẫn cho nhanh

  ```
  f <- here::here("md_files", "ke_tan_a_di.md")
  ```

  ------

  ### Đọc file vào R

  ```
  x <- readLines(f)
  ```

  ------

  ### ✏️ Sửa **1 dòng theo số dòng**

  ```
  x[3] <- "Bốn mươi tám nguyện viên thành"
  writeLines(x, f)
  ```

  ------

  ### ✏️ Sửa **1 chữ trong dòng**

  ```
  x[6] <- gsub("dậc", "bậc", x[6])
  writeLines(x, f)
  ```

  ------

  ### ✏️ Sửa theo **nội dung** (không nhớ số dòng)

  ```
  x[x == "Bốn mươi tám"] <- "Bốn mươi tám nguyện viên thành"
  writeLines(x, f)
  ```

  ------

  ## ❌ Xóa dòng

  ### Xóa dòng theo số dòng

  ```
  x <- readLines(f)
  x <- x[-5]
  writeLines(x, f)
  ```

  ### Xóa dòng trùng (giữ dòng đầu)

  ```
  x <- readLines(f)
  x <- x[!duplicated(x)]
  writeLines(x, f)
  ```

  ------

  ## 🧹 Xử lý xuống dòng `\n`

  ### Gộp nhiều dòng thành 1 dòng

  ```
  x <- readLines(f)
  writeLines(paste(x, collapse = " "), f)
  ```

  ### Xóa dòng trống

  ```
  x <- readLines(f)
  x <- x[nzchar(trimws(x))]
  writeLines(x, f)
  ```

  ------

  ## 🔐 Backup nhanh (thói quen tốt)

  ```
  file.copy(f, paste0(f, ".bak"), overwrite = TRUE)
  ```

  ------

  ## 🚫 KHÔNG DÙNG

  ```
  setwd("...")
  ```

  ------

  ## 🧘 TÓM TẮT 5 PHẢN XẠ VÀNG

  | Việc            | Lệnh                       |
  | --------------- | -------------------------- |
  | Biết mình ở đâu | `here::here()`             |
  | Ghi file mới    | `writeLines()`             |
  | Ghi thêm        | `cat(..., append=TRUE)`    |
  | Đọc file        | `readLines()`              |
  | Sửa             | đọc → sửa → `writeLines()` |

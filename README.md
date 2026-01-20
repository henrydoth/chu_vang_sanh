------

```
# 📿 Tụng Lăng Nghiêm trong RStudio (Console)

Hệ script này cho phép **tụng Chú Lăng Nghiêm** trực tiếp trong **RStudio Console**:
- Có **màu sắc theo chu kỳ 12 dòng**
- Hiện **số thứ tự + chữ Hán** (màu riêng)
- Tụng theo **chu kỳ (block)** hoặc **theo dòng**
- Chạy ổn định, không phụ thuộc đường dẫn máy

---

## 📂 Cấu trúc project



chu_vang_sanh/
├── chu_vang_sanh.Rproj
├── lang_nghiem_chi.md # nội dung Lăng Nghiêm (Việt + Hán)
├── R/
│ ├── ln_md.R # logic tụng Lăng Nghiêm (ln, lnnc)
│ ├── chu_md.R # logic Chú Vãng Sanh
│ └── commands.R # lệnh gọi nhanh (vs, lns, where, reload)
└── README.md


---

## 🚀 Cách chạy nhanh (MỖI LẦN mở RStudio)

### 1️⃣ Nạp lệnh gọi nhanh
```r
source("R/commands.R", encoding="UTF-8")

2️⃣ Nạp hệ Lăng Nghiêm
lns()

3️⃣ Bắt đầu tụng
lnnc(0)        # chu kỳ 0 (12 dòng đầu)
lnnc(0:9)      # chu kỳ 0–9

📌 Các lệnh chính
🔹 ln() – tụng theo DÒNG
ln(start = 1, end = Inf, delay = 2, show_han = FALSE)


Ví dụ:

ln(1, 12)                     # dòng 1–12
ln(1, 12, show_han = TRUE)    # hiện cả chữ Hán
ln(13, 24, delay = 1)

🔹 lnnc() – tụng theo CHU KỲ 12 DÒNG (có chữ Hán)

Chu kỳ bắt đầu từ 0

lnnc(n)
lnnc(n1, n2, n3, ...)
lnnc(n1:n2)


Ví dụ:

lnnc(0)          # dòng 1–12
lnnc(1)          # dòng 13–24
lnnc(0,1,2)      # chu kỳ 0 → 1 → 2
lnnc(3:6)        # chu kỳ 3,4,5,6
lnnc(0:9, delay=1)

🎨 Quy ước hiển thị

Tiếng Việt: màu theo chu kỳ 12 dòng

Dấu #: màu xám

Chữ Hán: luôn màu cyan (cố định, không theo chu kỳ)

Cuối buổi tụng: in câu

✦ NAM MÔ A DI ĐÀ PHẬT ✦

🧭 Lệnh kiểm tra & tiện ích
🔹 Kiểm tra đang dùng file nào
where()


Kết quả đúng phải là:

md_file: .../lang_nghiem_chi.md

🔹 Nạp lại nhanh khi sửa code
reload("ln")    # nạp lại ln_md.R
reload("vs")    # nạp lại chu_md.R
reload("all")   # nạp lại tất cả

⚠️ Lưu ý quan trọng

Luôn chạy lns() trước khi gọi ln() hoặc lnnc()
```